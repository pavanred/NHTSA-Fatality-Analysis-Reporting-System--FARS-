
class Bimaps{
 
 BiMap<Integer, String> weatherList;
 BiMap<Integer, String> speedList;
 BiMap<Integer, String> lightList;
 BiMap<Integer, String> vehicleList;
 BiMap<Integer, String> ageList;
 BiMap<Integer, String> alcoholList;
 BiMap<Integer, String> dayList;
 BiMap<Integer, String> monthList;
 BiMap<Integer, String> hourOfDayList;

 BiMap<Integer, String> sexList;
 BiMap<String, Integer> filtersList;

 //BiMap<String, Location> countylist;

 public BiMap<Integer,String> getWeatherBimap(){
  
   weatherList = HashBiMap.create();
   
   weatherList.put(99,"All");
   weatherList.put(100,"Clear");
   weatherList.put(101,"Rainy");
   weatherList.put(102,"Windy");
   weatherList.put(103,"Snow");
   weatherList.put(104,"Foggy");
   weatherList.put(105,"Unknown");

   return weatherList;   
 } 
 
 public BiMap<Integer,String> getSpeedBimap(){
  
   speedList = HashBiMap.create();
   
   speedList.put(-1,"All");
   speedList.put(0,"Static");
   speedList.put(1,"0 - 50");
   speedList.put(2,"51 - 100");
   speedList.put(3,"Above 100");
   speedList.put(4,"Unknown");
   
   return speedList;   
 } 
 
 public BiMap<Integer,String> getLightBimap(){
  
   lightList = HashBiMap.create();
   
   lightList.put(99,"All");
   lightList.put(100,"Daylight");
   lightList.put(101,"Dim");
   lightList.put(102,"Dark");
   lightList.put(103,"Unknown");
   
   return lightList;   
 }
 
 public BiMap<Integer,String> getVehicleBimap(){
  
   vehicleList = HashBiMap.create();
   
   vehicleList.put(-1,"All");
   vehicleList.put(0,"2 wheelers");
   vehicleList.put(1,"Cars");
   vehicleList.put(2,"Utility");
   vehicleList.put(3,"Heavy transport");
   vehicleList.put(4,"Others");
   vehicleList.put(5,"Unknown");
   
   return vehicleList;   
 }
 
 public BiMap<Integer,String> getAgeBimap(){
  
   ageList = HashBiMap.create();
   
   ageList.put(-1,"All");
   ageList.put(0,"0 - 18");
   ageList.put(1,"19 - 40");
   ageList.put(2,"41 - 60");
   ageList.put(3,"Above 60");
   ageList.put(4,"Unknown");
   
   return ageList;   
 }
 
 public BiMap<Integer,String> getAlcoholBimap(){
  
   alcoholList = HashBiMap.create();
   
   alcoholList.put(-1,"All");
   alcoholList.put(0,"Sober");
   alcoholList.put(1,"Mild");
   alcoholList.put(2,"Heavy");
   alcoholList.put(3,"Unknown");
   
   return alcoholList;   
 }
 
 public BiMap<Integer,String> getDayBimap(){
  
   dayList = HashBiMap.create();
   
   dayList.put(-1,"All");
   dayList.put(0,"Weekdays");
   dayList.put(1,"Weekends");
   dayList.put(2,"Holidays");
   dayList.put(3,"Unknown");
   
   return dayList;   
 }
 
 public BiMap<Integer,String> getMonthBimap(){
  
   monthList = HashBiMap.create();
   
   monthList.put(-1,"All");
   monthList.put(1,"Jan");
   monthList.put(2,"Feb");
   monthList.put(3,"Mar");
   monthList.put(4,"Apr");
   monthList.put(5,"May");
   monthList.put(6,"Jun");
   monthList.put(7,"Jul");
   monthList.put(8,"Aug");
   monthList.put(9,"Sep");
   monthList.put(10,"Oct");
   monthList.put(11,"Nov");
   monthList.put(12,"Dec");
   monthList.put(0,"Unknown");
   
   return monthList;   
 }
 
 public BiMap<Integer,String> getHourOfDayBimap(){
  
   hourOfDayList = HashBiMap.create();
   
   hourOfDayList.put(-1,"All");
   hourOfDayList.put(0,"Morning");
   hourOfDayList.put(1,"Afternoon");
   hourOfDayList.put(2,"Evening");
   hourOfDayList.put(3,"Night");
   hourOfDayList.put(4,"Unknown");
   
   return hourOfDayList;   
 }
 

 public BiMap<Integer,String> getSexBimap(){
  
   sexList = HashBiMap.create();
   
   sexList.put(0,"All");
   sexList.put(1,"Male");
   sexList.put(2,"Female");
   sexList.put(3,"Unknown");
   //hourOfDayList.put(9,"Night");
   //hourOfDayList.put(.,"Unknown");
   
   return sexList;
 }
 
 public BiMap<String,Integer> getFiltersBimap(){
   filtersList = HashBiMap.create();
   
   //Person
   filtersList.put("Age",1);
   filtersList.put("Alcohol",2);
   filtersList.put("Sex",3);
   
   //Vehicle
   filtersList.put("Vehicle Type",4);
   filtersList.put("Speed",5);
   
   //Crash
   filtersList.put("Day",6);
   filtersList.put("Month",7);
   filtersList.put("Hour of Day",8);
   
   //External
   filtersList.put("Weather",9);
   filtersList.put("Light Condition",10);
   
   return filtersList;
 }
 

 /*public BiMap<String,Location> getCountyBimap(){
  
   countylist = HashBiMap.create();
   
   

    
   return countylist;   
 }*/
  
}
