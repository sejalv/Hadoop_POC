package imdb;

public class Movie implements Comparable<Movie>{

	private String title;

	private Integer year;

	private Float rank;

	private String distribution;

	private Integer votes;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Integer getYear() {
		return year;
	}

	public void setYear(Integer year) {
		this.year = year;
	}

	public Float getRank() {
		return rank;
	}

	public void setRank(Float rank) {
		this.rank = rank;
	}

	public String getDistribution() {
		return distribution;
	}

	public void setDistribution(String distribution) {
		this.distribution = distribution;
	}

	public Integer getVotes() {
		return votes;
	}

	public void setVotes(Integer votes) {
		this.votes = votes;
	}

	@Override
	public int compareTo(Movie m) {
		int compare = m.getRank().compareTo(rank);
		if (compare == 0) {
			compare = m.getVotes().compareTo(votes);
		}
		
		return compare;
	}

	@Override
	public int hashCode() {
		return title.hashCode() * 31;
	}

	@Override
	public boolean equals(Object obj) {
		boolean isEqual = false;
		if (obj instanceof Movie) {
			Movie other = (Movie)obj;
			isEqual = title.equals(other.getTitle());
		}
		
		return isEqual;
	}
	
	
	

}
