
import java.util.*;

//percent screen width height utilites - should make it easier to use screen space
int percentX(int value){  
  return (value * width)/100;
}

int percentY(int value){
  return (value * height)/100;
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

