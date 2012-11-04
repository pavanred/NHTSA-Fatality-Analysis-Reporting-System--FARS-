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
  
  //To query DB for individual points on the map.
  ArrayList<DataBean> getPointsFromDB()
  {
    println("querying..");
    float[] clist = getCurrentMapCoordinates();
    String qc = getCoordQuery(clist);
    String whereClause = constructWhereClause();
     //qc="";
    //String query = "SELECT Distinct(CaseNumber),Latitude,Longitude,State,County,Year FROM Data_All WHERE "+ qc + whereClause;
    String query = "SELECT Distinct(CaseNumber),Latitude,Longitude,State,County FROM Data_All WHERE "+ qc + whereClause;
    println(query);
    db.query(query);
    ArrayList<DataBean> dbList = new ArrayList<DataBean>();
    while(db.next())
    {
      DataBean b = new DataBean();
      
      b.set_Latitude_(db.getFloat("Latitude"));
      b.set_Longitude_(db.getFloat("Longitude"));
      b.set_State_(db.getInt("State"));
      b.set_County_(db.getInt("County"));
      //b.set_Year_(db.getInt("Year"));
      dbList.add(b);
    }
    println("returning results"+dbList.size());
    println(query);
    stateLevelZoom = false;
    return dbList;
  }
  
  //To query DB to get points on the state level.
  ArrayList<DataBean> getCountyPointsFromDB()
  {
    println("Querying....");
//    HashMap<Integer,HashMap<Integer,DataBean>> ctList = getCountyCoordList(); //List used to get all county info.
    float[] cl = getCurrentMapCoordinates();
    String cq = getCoordQuery(cl);
    String query = "SELECT State,County,count(*) FROM Data_All WHERE "+ cq + " " + constructWhereClause() + " group by County";
    db.query(query);
    ArrayList<DataBean> dbList = new ArrayList<DataBean>();// List that is returned.
    HashSet<Integer> hsState = new HashSet<Integer>();
    HashSet<Integer> hs = new HashSet<Integer>();
    println("Queried !");

    while(db.next())
    {
      DataBean b = new DataBean();
      int stid = db.getInt("State");
      int count = db.getInt(3);
      b._State_ = stid;
      b._County_ = db.getInt("County");
      b.count = count;
      hsState.add(b._State_);
      dbList.add(b);
    }
    String inputStates = Joiner.on(", ").join(hsState);
    HashMap<Integer,HashMap<Integer,DataBean>> ctList = getCountyCoordList(inputStates);
    ArrayList<DataBean> dbNewList = new ArrayList<DataBean>();
    for(DataBean b : dbList)
    {
      HashMap<Integer,DataBean> hmOne = ctList.get(b._State_);
      if(hmOne==null || !hmOne.containsKey(b._County_)) //TODO - Ignores the point if it does not have a matching county, should be fixed !!
        continue;
      DataBean ctBean = hmOne.get(b._County_);
      b._Latitude_ = ctBean._Latitude_;
      b._Longitude_ = ctBean._Longitude_;
      b._countyName_ = ctBean._countyName_;
      b.stateCount = -1;
      dbNewList.add(b);
      hs.add(b._State_);
    }
        
    println("Result set Size:"+dbNewList.size());
    countyLevelZoom = true;
    String states = Joiner.on(", ").join(hs);
    println("States - "+states);
    String totQ = "Select State,count(*) FROM Data_All WHERE State in ("+states+") " + constructWhereClause()  + " GROUP BY State";
    println("tot Q:"+ totQ);
//    db.query(totQ);
//    HashMap<Integer,Integer> stateWiseCount = new HashMap<Integer,Integer>();
//    while(db.next())
//    {
//      stateWiseCount.put(db.getInt("State"),db.getInt(1));
//    }
    for(DataBean nb : dbNewList)
    {
      if(statePointList!=null)
      {
        for(DataBean bn : statePointList)
        {
          if(bn._State_== nb._State_)
            nb.stateCount = bn.count;
        }
      }
      //nb.stateCount = stateWiseCount.get(nb._State_);
      println("nb.stateCount::"+nb.stateCount);
    }
    return dbNewList;
  }
  
  //To query DB to get points on the state level.
  ArrayList<DataBean> getStatePointsFromDB()
  {
    HashMap<String,Location> stList = getStateCoordList();
    getStateBiMap();
    float[] cl = getCurrentMapCoordinates();
    String cq = getCoordQuery(cl);
    //String query = "SELECT State,count(*) FROM Data_"+year+" group by State"; 

//    String query = "SELECT State,count(*) FROM Data_All group by State order by count(*) DESC";
    String query = "SELECT State,count(*) FROM Data_All " + constructWhereClause() + " group by State";
    println(query);
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
    String totQ = "Select count(*) FROM Data_All";
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
    String q1 ="  Latitude between "+clist[1]+" and "+clist[0] + 
              " and Longitude between "+clist[2]+" and "+clist[3];
    
    return q1;
  }
  
  String constructWhereClause(){
   
    Bimaps bimaps = new Bimaps();
    StringBuilder filters = new StringBuilder();
    
    filters.append(" ");
    
    /*if(searchCriteria.Weather != 99)
      filters.append("AND Weather = " + searchCriteria.Weather + " ");
     
    if(searchCriteria.SpeedCategory != -1)
      filters.append("AND Speed_Category = " + searchCriteria.SpeedCategory + " ");
     
    if(searchCriteria.LightCondition != 99)
      filters.append("AND LightCondition = " + searchCriteria.LightCondition + " ");
     
    if(searchCriteria.VehicleType != -1)
      filters.append("AND VehicleType = " + searchCriteria.VehicleType + " "); 
    
    if(searchCriteria.AgeCategory != -1)
      filters.append("AND AgeCategory = " + searchCriteria.AgeCategory + " ");
    
    if(searchCriteria.AgeCategory != -1)
      filters.append("AND Alcohol_Category = " + searchCriteria.AlcoholCategory + " ");
    
    if(searchCriteria.CrashHour != -1)
      filters.append("AND (CrashHour " + getCrashHourfilter() + " ");
      
    if(searchCriteria.Sex != 0)
      filters.append("AND Sex =" + searchCriteria.Sex + " ");*/
      
    int weather = bimaps.getFiltersBimap().get("Weather");  
    int speed = bimaps.getFiltersBimap().get("Speed");
    int light = bimaps.getFiltersBimap().get("Light Condition");
    int days = bimaps.getFiltersBimap().get("Day");  
    int age = bimaps.getFiltersBimap().get("Age");
    int alcohol = bimaps.getFiltersBimap().get("Alcohol");
    int sex = bimaps.getFiltersBimap().get("Sex");  
    int vehicle = bimaps.getFiltersBimap().get("Vehicle Type");
    int hours = bimaps.getFiltersBimap().get("Hour of Day");
    int months = bimaps.getFiltersBimap().get("Month");
    println("null:"+searchCriteria.searchFilter.get(weather));
    if (!searchCriteria.searchFilter.get(weather).contains(bimaps.getWeatherBimap().inverse().get("All")))
      filters.append("AND Weather IN (" + arrayListToCSV(searchCriteria.searchFilter.get(weather)) + ") "); 
 
    if (!searchCriteria.searchFilter.get(speed).contains(bimaps.getSpeedBimap().inverse().get("All")))
      filters.append("AND Speed_Category IN (" + arrayListToCSV(searchCriteria.searchFilter.get(speed)) + ") "); 
      
    if (!searchCriteria.searchFilter.get(light).contains(bimaps.getLightBimap().inverse().get("All")))
      filters.append("AND LightCondition IN (" + arrayListToCSV(searchCriteria.searchFilter.get(light)) + ") "); 
      
    if (!searchCriteria.searchFilter.get(vehicle).contains(bimaps.getVehicleBimap().inverse().get("All")))
      filters.append("AND VehicleType IN (" + arrayListToCSV(searchCriteria.searchFilter.get(vehicle)) + ") "); 
      
    if (!searchCriteria.searchFilter.get(age).contains(bimaps.getAgeBimap().inverse().get("All")))
      filters.append("AND AgeCategory IN (" + arrayListToCSV(searchCriteria.searchFilter.get(age)) + ") "); 
 
    if (!searchCriteria.searchFilter.get(alcohol).contains(bimaps.getAlcoholBimap().inverse().get("All")))
      filters.append("AND Alcohol_Category IN (" + arrayListToCSV(searchCriteria.searchFilter.get(alcohol)) + ") "); 
      
    if (!searchCriteria.searchFilter.get(sex).contains(bimaps.getSexBimap().inverse().get("All")))
      filters.append("AND Sex IN (" + arrayListToCSV(searchCriteria.searchFilter.get(sex)) + ") ");
  
    if (!searchCriteria.searchFilter.get(months).contains(bimaps.getMonthBimap().inverse().get("All")))
      filters.append("AND (((CrashDate/1000000)%100) IN (" + arrayListToCSV(searchCriteria.searchFilter.get(months)) + ")) ");  //should ocnsider making this a column, perhaps
  
    //to add hour and days - should be simple and efficient to do it by adding a column to the table    
        
    return filters.toString();
  }
  
  
  
  HashMap<Integer,HashMap<Integer,DataBean>> getCountyCoordList(String inputStates)
  {
    float[] cl = getCurrentMapCoordinates();
    String cq = getCoordQuery(cl);
    String qry = "SELECT StateId, CountyId, CountyName, Latitude, Longitude FROM County WHERE StateId in ("+inputStates+") AND "+cq+" ORDER BY CountyId";
    println("input states query:"+qry);
    db.query(qry);
    HashMap<Integer,HashMap<Integer,DataBean>> countyListByState = new HashMap<Integer,HashMap<Integer,DataBean>>(); 
    println("Got counties");
    while(db.next())
    {
      DataBean mydata = new DataBean();
      mydata._State_ = db.getInt("StateId");
      mydata._County_ = db.getInt("CountyId");
      mydata._countyName_ = db.getString("CountyName");
      mydata._Latitude_ = db.getFloat("Latitude");
      mydata._Longitude_ = db.getFloat("Longitude");
      if(countyListByState.containsKey(mydata._State_))
      {
        HashMap<Integer,DataBean> b = countyListByState.get(mydata._State_);
        b.put(mydata._County_,mydata);
      }
      else
      {
        HashMap<Integer,DataBean> nb = new HashMap<Integer,DataBean>();
        nb.put(mydata._County_,mydata);
        countyListByState.put(mydata._State_,nb);
      }
    }
    return countyListByState;
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
  
  String getCrashHourfilter(){
   
   String condition="";
    
   /*switch(searchCriteria.CrashHour){
    
    case 0:
      condition = " between 5 and 12) ";
      break;
    case 1:
      condition = " between 13 and 17) ";
      break;
    case 2:
      condition = " between 18 and 21) ";
      break;
    case 3:
      condition = " between 22 and 24 OR CrashHour between 0 and 4) ";
      break;
    case 4: 
      condition = " > 24) ";
      break;
    default :
      condition = " between 5 and 12) "; 
      break;
         
   }   */
   return condition;
    
  }
  

  BiMap getDisplayStates()
  {
    BiMap displayStateMap = HashBiMap.create();
    displayStateMap.put(1,"AL");
    displayStateMap.put(2,"AK");
    displayStateMap.put(4,"AZ");
    displayStateMap.put(5,"AR");
    displayStateMap.put(6,"CA");
    displayStateMap.put(8,"CO");
    displayStateMap.put(9,"CT");
    displayStateMap.put(10,"DE");
    displayStateMap.put(11,"DC");
    displayStateMap.put(12,"FL");
    displayStateMap.put(13,"GA");
    displayStateMap.put(15,"HI");
    displayStateMap.put(16,"ID");
    displayStateMap.put(17,"IL");
    displayStateMap.put(18,"IN");
    displayStateMap.put(19,"IA");
    displayStateMap.put(20,"KS");
    displayStateMap.put(21,"KY");
    displayStateMap.put(22,"LA");
    displayStateMap.put(23,"ME");
    displayStateMap.put(24,"MD");
    displayStateMap.put(25,"MA");
    displayStateMap.put(26,"MI");
    displayStateMap.put(27,"MN");
    displayStateMap.put(28,"MS");
    displayStateMap.put(29,"MO");
    displayStateMap.put(30,"MT");
    displayStateMap.put(31,"NE");
    displayStateMap.put(32,"NV");
    displayStateMap.put(33,"NH");
    displayStateMap.put(34,"NJ");
    displayStateMap.put(35,"NM");
    displayStateMap.put(36,"NY");
    displayStateMap.put(37,"NC");
    displayStateMap.put(38,"ND");
    displayStateMap.put(39,"OH");
    displayStateMap.put(40,"OK");
    displayStateMap.put(41,"OR");
    displayStateMap.put(42,"PA");
    displayStateMap.put(43,"PR");
    displayStateMap.put(44,"RI");
    displayStateMap.put(45,"SC");
    displayStateMap.put(46,"SD");
    displayStateMap.put(47,"TN");
    displayStateMap.put(48,"TX");
    displayStateMap.put(49,"UT");
    displayStateMap.put(50,"VT");
    displayStateMap.put(51,"VA");
    displayStateMap.put(52,"VI");
    displayStateMap.put(53,"WA");
    displayStateMap.put(54,"WV");
    displayStateMap.put(55,"WI");
    displayStateMap.put(56,"WY");

    return displayStateMap;
  }

  /*--------------------------------------------------Chart queies-----------------------------------------*/
      
  public ArrayList<Float> getCrashesByYear(){
    ArrayList<Float> crashCounts;

    StringBuilder query = new StringBuilder();
    query.append(" SELECT Count(CaseNumber) as CaseNumber from ( ");
    query.append(" SELECT Distinct(CaseNumber) as CaseNumber,Year from Data_All Where ");
    query.append(" " + getCoordQuery(getCurrentMapCoordinates()) + " ");
    query.append(" " + constructWhereClause() + " )");
    query.append(" GROUP BY Year ");             

    println(query.toString());
    db.connect();
    
    db.query(query.toString());
    
    crashCounts = new ArrayList<Float>();
    while(db.next())
    {
      float count = db.getFloat("CaseNumber");
          
      crashCounts.add(count);      
    }
    db.close();    
    
    crashes = crashCounts;
    
    return crashes;
  }
  
  public ArrayList<KeyValue> getCrashesByGroup(){
    
    ArrayList<KeyValue> crashCounts = new ArrayList<KeyValue>();
    KeyValue kv;   
    int id;

    StringBuilder query = new StringBuilder();
    query.append(" SELECT Count(CaseNumber) as CaseNumber, " + getGroupByName() + " as Id from ( ");
    query.append(" SELECT Distinct(CaseNumber) as CaseNumber, " + getGroupByName() + " from Data_All Where ");
    query.append(" " + getCoordQuery(getCurrentMapCoordinates()) + " ");
    query.append(" " + constructChartWhereClause());        

    //println(query.toString());
    db.connect();
    
    db.query(query.toString());

    while(db.next()){         
      id = db.getInt("Id");
      crashCounts.add(new KeyValue(id, db.getFloat("CaseNumber"),getLabelName(id)));      
    }
    db.close();    
    println(crashCounts.size());
    return crashCounts;
  }
  
  String constructChartWhereClause(){   //overload for barcharts.. to eliminate the charttype from the filter
   
    StringBuilder filters = new StringBuilder();
    //println("adding where clause");
    filters.append(" ");
    
    /*if(searchCriteria.Weather != 99 && selectedChart != selectedChartType)
      filters.append("AND Weather = " + searchCriteria.Weather + " ");
     
    if(searchCriteria.SpeedCategory != -1  && selectedChart != selectedChartType)
      filters.append("AND Speed_Category = " + searchCriteria.SpeedCategory + " ");
     
    if(searchCriteria.LightCondition != 99 && selectedChart != selectedChartType)
      filters.append("AND LightCondition = " + searchCriteria.LightCondition + " ");
     
    if(searchCriteria.VehicleType != -1 && selectedChart != selectedChartType)
      filters.append("AND VehicleType = " + searchCriteria.VehicleType + " "); 
    
    if(searchCriteria.AgeCategory != -1 && selectedChart != selectedChartType)
      filters.append("AND AgeCategory = " + searchCriteria.AgeCategory + " ");
    
    if(searchCriteria.AgeCategory != -1 && selectedChart != selectedChartType)
      filters.append("AND Alcohol_Category = " + searchCriteria.AlcoholCategory + " ");
      
    if(searchCriteria.Sex != 0 && selectedChart != selectedChartType)
      filters.append("AND Sex =" + searchCriteria.Sex + " ");
      
    filters.append(" ) ");
    println("after adding where clause");
    switch (selectedChartType){
      
      case 1:
        filters.append(" Group by Weather");
        break;
      case 2:
        filters.append(" Group by Speed_Category");
        break;
      case 3:
        filters.append(" Group by LightCondition");
        break;
      case 4:
        filters.append(" Group by VehicleType");
        break;
      case 5:
        filters.append(" Group by AgeCategory");
        break;
      case 6:
        filters.append(" Group by Alcohol_Category");
        break;
      case 7:
        filters.append(" Group by Sex");
        break;
      default:
        filters.append(" Group by State");
        break;
    }*/
    
     Bimaps bimaps = new Bimaps(); 
    int weather = bimaps.getFiltersBimap().get("Weather");  
    int speed = bimaps.getFiltersBimap().get("Speed");
    int light = bimaps.getFiltersBimap().get("Light Condition");
    int days = bimaps.getFiltersBimap().get("Day");  
    int age = bimaps.getFiltersBimap().get("Age");
    int alcohol = bimaps.getFiltersBimap().get("Alcohol");
    int sex = bimaps.getFiltersBimap().get("Sex");  
    int vehicle = bimaps.getFiltersBimap().get("Vehicle Type");
    int hours = bimaps.getFiltersBimap().get("Hour of Day");
    int months = bimaps.getFiltersBimap().get("Month");
    
    if (!(searchCriteria.searchFilter.get(weather).contains(bimaps.getWeatherBimap().inverse().get("All")) || searchCriteria.getSelectedButton() ==  weather))
      filters.append("AND Weather IN (" + arrayListToCSV(searchCriteria.searchFilter.get(weather)) + ") "); 
 
    if (!(searchCriteria.searchFilter.get(speed).contains(bimaps.getSpeedBimap().inverse().get("All")) || searchCriteria.getSelectedButton() ==  speed))
      filters.append("AND Speed_Category IN (" + arrayListToCSV(searchCriteria.searchFilter.get(speed)) + ") "); 
      
    if (!(searchCriteria.searchFilter.get(light).contains(bimaps.getLightBimap().inverse().get("All")) || searchCriteria.getSelectedButton() ==  light))
      filters.append("AND LightCondition IN (" + arrayListToCSV(searchCriteria.searchFilter.get(light)) + ") "); 
      
    if (!(searchCriteria.searchFilter.get(vehicle).contains(bimaps.getVehicleBimap().inverse().get("All")) || searchCriteria.getSelectedButton() ==  vehicle))
      filters.append("AND VehicleType IN (" + arrayListToCSV(searchCriteria.searchFilter.get(vehicle)) + ") "); 
      
    if (!(searchCriteria.searchFilter.get(age).contains(bimaps.getAgeBimap().inverse().get("All")) || searchCriteria.getSelectedButton() ==  age))
      filters.append("AND AgeCategory IN (" + arrayListToCSV(searchCriteria.searchFilter.get(age)) + ") "); 
 
    if (!(searchCriteria.searchFilter.get(alcohol).contains(bimaps.getAlcoholBimap().inverse().get("All")) || searchCriteria.getSelectedButton() ==  alcohol))
      filters.append("AND Alcohol_Category IN (" + arrayListToCSV(searchCriteria.searchFilter.get(alcohol)) + ") "); 
      
    if (!(searchCriteria.searchFilter.get(sex).contains(bimaps.getSexBimap().inverse().get("All")) || searchCriteria.getSelectedButton() ==  sex))
      filters.append("AND Sex IN (" + arrayListToCSV(searchCriteria.searchFilter.get(sex)) + ") ");
  
    if (!(searchCriteria.searchFilter.get(months).contains(bimaps.getMonthBimap().inverse().get("All")) || searchCriteria.getSelectedButton() ==  months))
      filters.append("AND (((CrashDate/1000000)%100) IN (" + arrayListToCSV(searchCriteria.searchFilter.get(months)) + ")) ");  //should ocnsider making this a column, perhaps
  
    //to add hour and days - should be simple and efficient to do it by adding a column to the table    
        
    filters.append(") Group by Id"); //+ getGroupByName());    
    
    return filters.toString();
  }
  
  String getGroupByName(){
   
    StringBuilder filters = new StringBuilder();
    
   switch (searchCriteria.getSelectedButton()){
     
      case 9:
        filters.append(" Weather ");
        break;
      case 5:
        filters.append(" Speed_Category ");
        break;
      case 10:
        filters.append(" LightCondition ");
        break;
      case 4:
        filters.append(" VehicleType ");
        break;
      case 1:
        filters.append(" AgeCategory ");
        break;
      case 2:
        filters.append(" Alcohol_Category ");
        break;
      case 3:
        filters.append(" Sex ");
        break;
      default:
        filters.append(" Weather ");
        break;
    }
    
    return filters.toString();
    
  }
  
  String getLabelName(int id){
   
    String label;
    
    Bimaps bimaps = new Bimaps();
    
     switch (searchCriteria.getSelectedButton()){
      case 9:
        label = bimaps.getWeatherBimap().get(id);
        break;
      case 5:
        label = bimaps.getSpeedBimap().get(id);
        break;
      case 10:
        label = bimaps.getLightBimap().get(id);
        break;
      case 4:
        label = bimaps.getVehicleBimap().get(id);
        break;
      case 1:
        label = bimaps.getAgeBimap().get(id);
        break;
      case 2:
        label = bimaps.getAlcoholBimap().get(id);
        break;
      case 3:
        label = bimaps.getSexBimap().get(id);
        break;
      default:
        label = bimaps.getMonthBimap().get(id);
        break;
     }
    
    return label;
    
  }

}
