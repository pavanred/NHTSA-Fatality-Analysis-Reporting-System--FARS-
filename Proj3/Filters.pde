
class Filters{
 
 Filters(){
   this.searchFilter = new HashMap<Integer,ArrayList<Integer>>();
   this.currentMinYear = 2000;
   this.currentMaxYear = 2010;
 }  //
 
 Filters(HashMap<Integer,ArrayList<Integer>> searchFilter){   //setting default search criteria
   this.searchFilter = searchFilter;
   this.currentMinYear = 2000;
   this.currentMaxYear = 2010;
 }
  
 /*int Weather;
 int SpeedCategory;
 int LightCondition;
 int VehicleType;
 int AgeCategory;
 int AlcoholCategory;
 int CrashHour;
 int Sex;*/
 
 HashMap<Integer,ArrayList<Integer>> searchFilter;
 Integer selectedButton;
 Integer currentMinYear,currentMaxYear;
 
 void setSelectedButton(Integer val)
 {
   this.selectedButton = val;
 }
 
 Integer getSelectedButton()
 {
   return this.selectedButton;
 }
}
