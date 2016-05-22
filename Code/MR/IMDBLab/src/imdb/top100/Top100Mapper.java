package imdb.top100;

import static imdb.Utils.FEW_LOWRANK_VOTES;
import static imdb.Utils.TAB_DELIM;
import static imdb.Utils.TITLE;
import static imdb.Utils.VOTES_LOWER_LIMIT;
import imdb.Movie;
import imdb.Parser;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.regex.Matcher;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class Top100Mapper extends Mapper<LongWritable, Text, Text, Text> {

	private static final LongWritable HEADER = new LongWritable(0);

	private Parser parser;

	private List<Movie> movies;

	public void map(LongWritable key, Text value, Context context) throws IOException,
			InterruptedException {
		String line = value.toString();
		if (HEADER.equals(key)) {
			parser = new Parser(line);
			movies = new ArrayList<Movie>();
		} else {
			parser.parse(line);
			int votes = 0;
			try {
				votes = Integer.parseInt(parser.get("Votes"));
			} catch (NumberFormatException nfe) {
				votes = 0;
			}
			String distribution = parser.get("Distribution");
			float rank = Float
					.parseFloat((parser.get("Rank") == null ? "0.0" : parser.get("Rank")));

			if ((votes > VOTES_LOWER_LIMIT) && (distribution.matches(FEW_LOWRANK_VOTES))
					&& (rank > 7.0)) {
				String title = parser.get("Title");
				Matcher m = TITLE.matcher(title);
				if (m.matches()) {
					Movie movie = new Movie();
					movie.setTitle(m.group(1) + m.group(3));
					movie.setYear(new Integer(m.group(2)));
					movie.setDistribution(distribution);
					movie.setRank(rank);
					movie.setVotes(votes);

					movies.add(movie);
				}
			}
		}
	}

	@Override
	protected void cleanup(Context context) throws IOException, InterruptedException {
		super.cleanup(context);

		int size = movies.size();
		if (size != 0) {
			Collections.sort(movies);
			size = Math.min(100, size);
			for (int i = 0; i < size; i++) {
				Movie movie = movies.get(i);
				context.write(new Text(Float.toString(movie.getRank())), new Text(movie.getVotes()
						+ TAB_DELIM + movie.getTitle() + TAB_DELIM + movie.getYear()));
			}
		}
	}

}