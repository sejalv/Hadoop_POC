package imdb;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class Utils {

	public final static String SPACE_DELIM = "\\s{2,}";
	
	public final static String TAB_DELIM = "\t";
	
	public final static String FEW_LOWRANK_VOTES = "^[\\.0-2]{5}[\\.\\d]{5}$";
	
	public final static Pattern TITLE = Pattern.compile("^(.+)\\s{1}\\((\\d{4})\\)(.*)$");
	
	public final static int VOTES_LOWER_LIMIT = 25000; 	
	
	public static void main(String[] args) {
		System.out.println("0000000125".matches(FEW_LOWRANK_VOTES));
		String sTitle = "\"Behzat Ç. Bir Ankara Polisiyesi\" (2010) {Kayip Yasamlar (#1.5)}";
		Matcher m = TITLE.matcher(sTitle);
		if (m.matches()) {
			System.out.println(m.group(1) + m.group(3));
			System.out.println(m.group(2));
		}
	}
}
