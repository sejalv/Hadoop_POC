package imdb.top100;

import static imdb.Utils.TAB_DELIM;
import imdb.Movie;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Scanner;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class Top100Reducer extends Reducer<Text, Text, Text, Text> {

	private List<Movie> movies;

	public void reduce(Text key, Iterable<Text> values, Context context)
			throws IOException, InterruptedException {
		for (Text value : values) {
			Scanner scanner = new Scanner(value.toString());
			scanner.useDelimiter(TAB_DELIM);

			Movie movie = new Movie();
			movie.setRank(Float.parseFloat(key.toString()));
			movie.setVotes(scanner.nextInt());
			movie.setTitle(scanner.next());
			movie.setYear(scanner.nextInt());

			movies.add(movie);
		}
	}

	@Override
	protected void setup(Context context) throws IOException, InterruptedException {
		super.setup(context);
		context.write(new Text("rank"),
				new Text("votes" + TAB_DELIM + "title" + TAB_DELIM + "year"));
		movies = new ArrayList<Movie>();
	}

	@Override
	protected void cleanup(Context context) throws IOException,
			InterruptedException {
		super.cleanup(context);
		
		if (!movies.isEmpty()) {
			Collections.sort(movies);
			for (int i = 0; i < 100; i++) {
				Movie movie = movies.get(i);
				context.write(new Text(Float.toString(movie.getRank())), new Text(movie.getVotes()
						+ TAB_DELIM + movie.getTitle() + TAB_DELIM + movie.getYear()));
			}
		}
	}

}
