class QueryBuilder
{
  SQLite db;
  QueryBuilder()
  {
      db = new SQLite(Proj3.this,"FARS_G7.sqlite");
  }
  
  void checking() // checks for DB Connection
  {
    if(db.connect())
    {
      
      db.query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" );
      while (db.next())
      {
          //println( db.getString("Name") );
      }
    }
  }
  
  ArrayList<DataBean> getPointsFromDB(int year)
  {
    println("querying..");
    float[] clist = getCurrentMapCoordinates();
    String qc = getCoordQuery(clist);
     //qc="";
    String query = "SELECT * FROM Data_"+year+" WHERE "+qc;
    println(query);
    db.query(query);
    ArrayList<DataBean> dbList = new ArrayList<DataBean>();
    while(db.next())
    {
      float lat = db.getFloat("Latitude");
      float lon = db.getFloat("Longitude");
      DataBean b = new DataBean();
      b.set_Latitude_(lat);
      b.set_Longitude_(lon);
      b.set_State_(db.getInt("State"));
      b.set_County_(db.getInt("County"));
      dbList.add(b);
    }
    println("returning results"+dbList.size());
    stateLevelZoom = false;
    return dbList;
  }
  
  /*
    Method that helps in filtering the query based on the map shown, avoids fetching lot of points from the DB.
  */
  float[] getCurrentMapCoordinates()
  {
    ArrayList<Location> coordlist = new ArrayList<Location>();
    float gx1 = width/2;
    float gx2 = width;
    float gy1 = 0;
    float gy2 = height; 
    println(gx1);
    println(gy1);
    println(gx2);
    println(gy2);
    Location p1 = map.pointLocation(gx1,0);
    Location p2 = map.pointLocation(gx2,0);
    Location p3 = map.pointLocation(gx1,gy2);
    Location p4 = map.pointLocation(gx2,gy2);
    coordlist.add(p1);
    coordlist.add(p2);
    coordlist.add(p3);
    coordlist.add(p4);
    HashSet hlat = new HashSet();
    float[] llList = {p1.lat,p3.lat,p1.lon,p2.lon};
    println(p1);
    println(p2);
    println(p3);
    println(p4);
    return llList;
  }
  
  String getCoordQuery(float[] clist)
  {
    String q2 =" and Longitude between "+clist[2]+" and "+clist[3];
    String q1 ="  Latitude between "+clist[1]+" and "+clist[0];
    return q1+" "+q2;
  }
  
  ArrayList<DataBean> getStatePointsFromDB(int year)
  {
    HashMap<String,Location> stList = getStateCoordList();
    getStateBiMap();
    String query = "SELECT State,count(*) FROM Data_"+year+" group by State"; 
    db.query(query);
    ArrayList<DataBean> dbList = new ArrayList<DataBean>();
    while(db.next())
    {
      DataBean b = new DataBean();
      int stid = db.getInt("State");
      int count = db.getInt(2);
      b._State_ = stid;
      b.count = count;
      dbList.add(b);
    }
    for(DataBean b : dbList)
    {
      String stateName = stateHashMap.get(b._State_);
      Location l = stList.get(stateName);
      b._Latitude_ = l.lat;
      b._Longitude_ = l.lon;
    }
    stateLevelZoom = true;
    DataBean dbTotal = new DataBean();
    String totQ = "Select count(*) FROM Data_"+year;
    db.query(totQ);
    int totCount = 0;
    while(db.next())
    {
      totCount = db.getInt(1);
    }
    dbTotal.count = totCount;
    dbList.add(dbTotal);
    println(dbTotal.count);
    return dbList;
  }
  
  HashMap<String,Location> getStateCoordList()
  {
    HashMap<String,Location> stateList = new HashMap<String,Location>();
    Location l;
    l = new Location(61.3850,-152.2683);
    stateList.put("Alaska",l);
    l = new Location(32.7990,-86.8073);
    stateList.put("Alabama",l);
    l = new Location(34.9513,-92.3809);
    stateList.put("Arkansas",l);
    l = new Location(33.7712,-111.3877);
    stateList.put("Arizona",l);
    l = new Location(36.1700,-119.7462);
    stateList.put("California",l);
    l = new Location(39.0646,-105.3272);
    stateList.put("Colorado",l);
    l = new Location(41.5834,-72.7622);
    stateList.put("Connecticut",l);
    l = new Location(38.8964,-77.0262);
    stateList.put("DistrictofColumbia",l);
    l = new Location(39.3498,-75.5148);
    stateList.put("Delaware",l);
    l = new Location(27.8333,-81.7170);
    stateList.put("Florida",l);
    l = new Location(32.9866,-83.6487);
    stateList.put("Georgia",l);
    l = new Location(21.1098,-157.5311);
    stateList.put("Hawaii",l);
    l = new Location(42.0046,-93.2140);
    stateList.put("Iowa",l);
    l = new Location(44.2394,-114.5103);
    stateList.put("Idaho",l);
    l = new Location(40.3363,-89.0022);
    stateList.put("Illinois",l);
    l = new Location(39.8647,-86.2604);
    stateList.put("Indiana",l);
    l = new Location(38.5111,-96.8005);
    stateList.put("Kansas",l);
    l = new Location(37.6690,-84.6514);
    stateList.put("Kentucky",l);
    l = new Location(31.1801,-91.8749);
    stateList.put("Louisiana",l);
    l = new Location(42.2373,-71.5314);
    stateList.put("Massachusetts",l);
    l = new Location(39.0724,-76.7902);
    stateList.put("Maryland",l);
    l = new Location(44.6074,-69.3977);
    stateList.put("Maine",l);
    l = new Location(43.3504,-84.5603);
    stateList.put("Michigan",l);
    l = new Location(45.7326,-93.9196);
    stateList.put("Minnesota",l);
    l = new Location(38.4623,-92.3020);
    stateList.put("Missouri",l);
    l = new Location(32.7673,-89.6812);
    stateList.put("Mississippi",l);
    l = new Location(46.9048,-110.3261);
    stateList.put("Montana",l);
    l = new Location(35.6411,-79.8431);
    stateList.put("NorthCarolina",l);
    l = new Location(47.5362,-99.7930);
    stateList.put("NorthDakota",l);
    l = new Location(41.1289,-98.2883);
    stateList.put("Nebraska",l);
    l = new Location(43.4108,-71.5653);
    stateList.put("NewHampshire",l);
    l = new Location(40.3140,-74.5089);
    stateList.put("NewJersey",l);
    l = new Location(34.8375,-106.2371);
    stateList.put("NewMexico",l);
    l = new Location(38.4199,-117.1219);
    stateList.put("Nevada",l);
    l = new Location(42.1497,-74.9384);
    stateList.put("NewYork",l);
    l = new Location(40.3736,-82.7755);
    stateList.put("Ohio",l);
    l = new Location(35.5376,-96.9247);
    stateList.put("Oklahoma",l);
    l = new Location(44.5672,-122.1269);
    stateList.put("Oregon",l);
    l = new Location(40.5773,-77.2640);
    stateList.put("Pennsylvania",l);
    l = new Location(41.6772,-71.5101);
    stateList.put("RhodeIsland",l);
    l = new Location(33.8191,-80.9066);
    stateList.put("SouthCarolina",l);
    l = new Location(44.2853,-99.4632);
    stateList.put("SouthDakota",l);
    l = new Location(35.7449,-86.7489);
    stateList.put("Tennessee",l);
    l = new Location(31.1060,-97.6475);
    stateList.put("Texas",l);
    l = new Location(40.1135,-111.8535);
    stateList.put("Utah",l);
    l = new Location(37.7680,-78.2057);
    stateList.put("Virginia",l);
    l = new Location(44.0407,-72.7093);
    stateList.put("Vermont",l);
    l = new Location(47.3917,-121.5708);
    stateList.put("Washington",l);
    l = new Location(44.2563,-89.6385);
    stateList.put("Wisconsin",l);
    l = new Location(38.4680,-80.9696);
    stateList.put("WestVirginia",l);
    l = new Location(42.7475,-107.2085);
    stateList.put("Wyoming",l);
    
    return stateList;
  }
  
  void getStateBiMap()
  {
    stateHashMap = HashBiMap.create();
    stateHashMap.put(1,"Alabama");
    stateHashMap.put(2,"Alaska");
    stateHashMap.put(4,"Arizona");
    stateHashMap.put(5,"Arkansas");
    stateHashMap.put(6,"California");
    stateHashMap.put(8,"Colorado");
    stateHashMap.put(9,"Connecticut");
    stateHashMap.put(10,"Delaware");
    stateHashMap.put(11,"DistrictofColumbia");
    stateHashMap.put(12,"Florida");
    stateHashMap.put(13,"Georgia");
    stateHashMap.put(15,"Hawaii");
    stateHashMap.put(16,"Idaho");
    stateHashMap.put(17,"Illinois");
    stateHashMap.put(18,"Indiana");
    stateHashMap.put(19,"Iowa");
    stateHashMap.put(20,"Kansas");
    stateHashMap.put(21,"Kentucky");
    stateHashMap.put(22,"Louisiana");
    stateHashMap.put(23,"Maine");
    stateHashMap.put(24,"Maryland");
    stateHashMap.put(25,"Massachusetts");
    stateHashMap.put(26,"Michigan");
    stateHashMap.put(27,"Minnesota");
    stateHashMap.put(28,"Mississippi");
    stateHashMap.put(29,"Missouri");
    stateHashMap.put(30,"Montana");
    stateHashMap.put(31,"Nebraska");
    stateHashMap.put(32,"Nevada");
    stateHashMap.put(33,"NewHampshire");
    stateHashMap.put(34,"NewJersey");
    stateHashMap.put(35,"NewMexico");
    stateHashMap.put(36,"NewYork");
    stateHashMap.put(37,"NorthCarolina");
    stateHashMap.put(38,"NorthDakota");
    stateHashMap.put(39,"Ohio");
    stateHashMap.put(40,"Oklahoma");
    stateHashMap.put(41,"Oregon");
    stateHashMap.put(42,"Pennsylvania");
    stateHashMap.put(43,"PuertoRico");
    stateHashMap.put(44,"RhodeIsland");
    stateHashMap.put(45,"SouthCarolina");
    stateHashMap.put(46,"SouthDakota");
    stateHashMap.put(47,"Tennessee");
    stateHashMap.put(48,"Texas");
    stateHashMap.put(49,"Utah");
    stateHashMap.put(50,"Vermont");
    stateHashMap.put(52,"VirginIslands");
    stateHashMap.put(51,"Virginia");
    stateHashMap.put(53,"Washington");
    stateHashMap.put(54,"WestVirginia");
    stateHashMap.put(55,"Wisconsin");
    stateHashMap.put(56,"Wyoming");
  }  
}
