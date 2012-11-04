
import java.util.*;

//percent screen width height utilites - should make it easier to use screen space
int percentX(int value){  
  return (value * width)/100;
}

int percentY(int value){
  return (value * height)/100;
} 

String arrayListToCSV(ArrayList<Integer> arr){
 
 String values = " ";
 
 for(Integer item:arr){      
      values = values + item.toString() + ",";
 }
     
 return values.substring(0, values.length() - 1); 
}

String arrayListYear(){
 
 String values = " ";
 
 for(Integer i = searchCriteria.currentMinYear; i <= searchCriteria.currentMaxYear; i++){      
      values = values + i.toString() + ",";
 }
     
 return values.substring(0, values.length() - 1); 
}

HashMap<Integer,ArrayList<Integer>> getDefaultFilter(){
  
  Bimaps bimaps = new Bimaps();
  HashMap<Integer,ArrayList<Integer>> filters = new HashMap<Integer,ArrayList<Integer>>();

  ArrayList<Integer> value99 = new ArrayList<Integer>();
  value99.add(99);
  
  ArrayList<Integer> value_1 = new ArrayList<Integer>();
  value_1.add(-1);
  
  ArrayList<Integer> value0 = new ArrayList<Integer>();
  value0.add(0);
  
  filters.put(bimaps.getFiltersBimap().get("Weather"),value99);
  filters.put(bimaps.getFiltersBimap().get("Speed"),value_1);
  filters.put(bimaps.getFiltersBimap().get("Age"),value_1);
  filters.put(bimaps.getFiltersBimap().get("Alcohol"),value_1);
  filters.put(bimaps.getFiltersBimap().get("Sex"),value0);
  filters.put(bimaps.getFiltersBimap().get("Vehicle Type"),value_1);
  filters.put(bimaps.getFiltersBimap().get("Day"),value_1);
  filters.put(bimaps.getFiltersBimap().get("Month"),value_1);
  filters.put(bimaps.getFiltersBimap().get("Hour of Day"),value_1);
  filters.put(bimaps.getFiltersBimap().get("Light Condition"),value99);  

  return filters;   
}

 //to be tested properly   
 public int getDay(int date){
  
   int _day = 8; //invalid
   int dayOfMonth = 0;
   int _month = 0;
   int _year = 0;
   
   try{
     
       _year = date % 10000;  //gets year
           
       if (_year > 2000){
         
         _month = (date / 10000) % 100; //gets month
         
         dayOfMonth = (date / 1000000);  //gets dayOfMonth
         
         Calendar calendar = new GregorianCalendar();
         calendar.set(_year, (_month - 1), dayOfMonth); //month is 0 based value
         _day = calendar.get(Calendar.DAY_OF_WEEK);
       }
       else {
         _day = 8;  //invalid
       }       
     }
     catch (Exception e){
       _day = 8;
     }      
     finally{
       return _day;
     }
 }  
 
 //to be tested properly
 
 public int getDayCategory(int date){
   
   int dayCategory = 4; //unknown
   
   try{
   
   int _day = getDay(date);
   
     
   if(_day >= 1 && _day <=5)
     dayCategory = Day.Weekday;
   else if (_day == 0 || _day == 6)
     dayCategory = Day.Weekend;
   else 
     dayCategory = Day.Unknown;
   
   }
   catch (Exception e){
     dayCategory = Day.Unknown;
   }      
   finally{
     return dayCategory;
   }  
   
 }  

