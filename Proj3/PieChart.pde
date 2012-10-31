public class PieChart {
	Connection mysql = null;
	PApplet parent = null;
	float x=0;
	float y=0;
	float diameter=0;
	float labelX = 0;
	float labelY = 0;
	int mode = 1;
	int numerator = 0;
	int denominator = 0;
	float split = 0;
	String qry = "";
	String curCountry = "";
	String curGenre = "";
	int scaleFactor = 1;
	String label = "";
	boolean isVisible = false;
	public pieChart(PApplet parent){
		this.parent = parent;
		scaleFactor = ((MonsterMashSketch)parent).scaleFactor;
		
		x = parent.width - 100*scaleFactor; //newX is width
		y = 6*scaleFactor;
		diameter = ((65*scaleFactor)-(2*y)); //newY is top of graph frame
		curGenre = "NULL";
		try{
			
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			//mysql = DriverManager.getConnection("rstahm2.mysql.uic.edu/rstahm2", "rstahm2-rw", "Project2");
			
			mysql = DriverManager.getConnection("jdbc:mysql://rstahm2.mysql.uic.edu/rstahm2?user=rstahm2-rw&password=Project2");
			
			
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
		
	}
	
	public void setMode(int i)
	{
		//0: % of (top 5% of all movies) which are in this category
		//1: % of (total films) in this genre
		//2: % of (total films in this genre) from this country
		mode = i;
	}
	
	public void setGenre( Selection s )
	{
		isVisible = true;
		int total = 1;
		Statement stmt = null;
		ResultSet rs = null;
		try {
		    stmt = mysql.createStatement();
		    
			curGenre = s.show.Genre;
			
			qry = "SELECT COUNT(*) FROM `TABLE 2`";
			rs = stmt.executeQuery(qry);
			rs.next();
			total = rs.getInt(1);
			stmt = mysql.createStatement();
			qry = "SELECT COUNT(*) FROM `TABLE 2` WHERE `Genre` LIKE '" + curGenre + "'";
			rs = stmt.executeQuery(qry);
			rs.next();
			numerator = rs.getInt(1);
			denominator = total; 
			
			if(curGenre.isEmpty() || curGenre == null){
				curGenre = "N/A";
			}
			split = ((float)((float)numerator/((float)denominator)))*(2*(float)Math.PI);
			float percent = ((float)((float)numerator/((float)denominator)))*100;
			label = curGenre+" is "+FormatDataValue(""+percent,1)+"%\nof total";
		} //end try
		catch(Exception ex){
			ex.printStackTrace();
		}
	}
		
	
	public void setCountry( String newCountry )
	{
		curCountry = newCountry;
	}
	
	public void draw()
	{
		//0: % of (top 5% of all movies) which are in this category (not used)
		//1: % of (total films) in this genre
		//2: % of (total films in this genre) from this country (not used)
				/*case 0: //0: % of (top 5% of all movies) which are in this category
					qry = "SELECT COUNT(*) FROM `TABLE 1`";
					rs = stmt.executeQuery(qry);
					rs.next();
					total = rs.getInt(1);
					stmt = mysql.createStatement();
					qry = "SELECT MIN(`Rating`) FROM `TABLE 1`" + 
							"ORDER BY (`Rating`) DESC LIMIT 0, "+(total)/20;
					rs = stmt.executeQuery(qry);
					rs.next();
					int minRating = rs.getInt(1);
					stmt = mysql.createStatement();
					qry = "SELECT COUNT(*) FROM `TABLE 1` WHERE `Genre`=" + curGenre;
					rs = stmt.executeQuery(qry);
					rs.next();
					numerator = rs.getInt(1);
					denominator = total/20;
					 
					parent.fill(0, 0, 0);
					parent.arc(x, y, diameter, diameter, (float)0.0, parent.radians(360 * (numerator/denominator)));
					parent.fill(64, 64, 64);
					parent.arc(x, y, diameter, diameter, parent.radians(360 * (numerator/denominator)), parent.radians(360));
				break;
				case 1: *///1: % of (total films) in this genre
		if(isVisible){
			parent.fill(254);
			parent.textAlign(parent.RIGHT);
			//parent.text(label, x-diameter-10, y+((y-x)/2));
			parent.textSize(scaleFactor*12);
			parent.text(label, x-10, y+(diameter/2));
			parent.textAlign(parent.LEFT);
			parent.fill(0, 64, 128);
			parent.arc(x+diameter/2, y, x+diameter*(float)1.5, y+diameter, 0, split);
			parent.fill(128, 64, 0);
			parent.arc(x+diameter/2, y, x+diameter*(float)1.5, y+diameter, split, 2*(float)Math.PI);
			parent.textSize(8*((int)(1.2*scaleFactor)));
		}
					
				/*break;
				default: //2: % of (total films in this genre) from this country
					qry = "SELECT COUNT(*) FROM `TABLE 1` WHERE `Genre`=" + curGenre;
					rs = stmt.executeQuery(qry);
					rs.next();
					denominator = rs.getInt(1);
					stmt = mysql.createStatement();
					qry = "SELECT COUNT(*) FROM `TABLE 1` WHERE `Genre`=" + curGenre + 
								" AND `Country`=" + curCountry;
					rs = stmt.executeQuery(qry);
					rs.next();
					numerator = rs.getInt(1);
					
					parent.fill(0, 0, 0);
					parent.arc(x, y, diameter, diameter, (float)0.0, parent.radians(360 * (numerator/denominator)));
					parent.fill(64, 64, 64);
					parent.arc(x, y, diameter, diameter, parent.radians(360 * (numerator/denominator)), parent.radians(360));
				break;
				
			} //end switch
		*/
	}
	public String FormatDataValue(String original, int places)
	{
		if(original.contains(".")){
			String[] sp = original.split("\\.");
			String leading = sp[0];
			String ending = sp[1];
			if(places > ending.length()){
				for(int i = 0; i < places; i++){
					ending.concat("0");
				}
				return String.format("%s.%s", leading, ending);
			}
			else{
				String roundingD = "";
				if(ending.length()>places+2){
					roundingD = ending.substring(places+1, places+2);
				}
				else{
					roundingD = ending.substring(ending.length()-1,ending.length());
				}
				
				if(places+2 == ending.length()){
					int d = Integer.parseInt(roundingD);				
					ending = ending.substring(0,places);
					ending.concat(String.valueOf(d));	
					if(places == 0){
						return String.format("%s%s", leading,ending);
					}
					else{
						return String.format("%s.%s", leading,ending);
					}
					
				}
				else{
					int d = Integer.parseInt(roundingD);	
					String hintD = "";
					if(ending.length() > places+2){
						hintD = ending.substring(places+2,places+3);
					}
					else{
						hintD = ending.substring(ending.length()-1, ending.length());
					}
							
					int h = Integer.parseInt(hintD);
					if(h >= 5){
						d++;
					}
					ending = ending.substring(0,places);
					ending.concat(String.valueOf(d));	
					if(places == 0){
						return String.format("%s%s", leading,ending);
					}
					else{
						return String.format("%s.%s", leading,ending);
					}
					
				}
			}
		}
		else{
			if(places > 0){
				original.concat(".");
			}			
			for(int i = 0; i < places; i++){
				original.concat("0");
			}
			return original;
		}
	
	}
	
} //end class