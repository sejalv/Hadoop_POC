package imdb;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

import static imdb.Utils.SPACE_DELIM;

public class Parser {

	private LinkedHashMap<String, String> recordMap;

	private List<String> fieldList;
	
	public Parser(String header) {
		recordMap = new LinkedHashMap<String, String>();
		fieldList = new ArrayList<String>();
		if ((header != null) && (!"".equals(header))) {
			String[] fields = header.split(SPACE_DELIM);
			for (String field : fields) {
				fieldList.add(field);
				recordMap.put(field, "");
			}
		}

	}

	public void parse(String line) {
		String[] tokens = line.split(SPACE_DELIM, -1);

		for (int i = 0; i < fieldList.size(); i++) {
			recordMap.put(fieldList.get(i), tokens[i]);
		}
	}
	
	public String get(String fieldName) {
		return recordMap.get(fieldName);
	}

	public static void main(String[] args) {
		Parser parser = new Parser("New  Distribution  Votes  Rank  Title");
		for (String key : parser.fieldList) {
			System.out.println(key);
		}

		System.out.println();
		parser.parse("      2...1.2002      13   3.4  \"$1,000,000 Chance of a Lifetime\" (1986)");
		for (String key : parser.recordMap.keySet()) {
			System.out.println(key + "=" + parser.recordMap.get(key));
		}
		
		
	}
}
