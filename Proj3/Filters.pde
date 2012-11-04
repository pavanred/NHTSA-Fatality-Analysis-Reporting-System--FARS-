
class Filters{
 
 Filters(){
   this.searchFilter = new HashMap<Integer,ArrayList<Integer>>();
 }  //
 
 Filters(HashMap<Integer,ArrayList<Integer>> searchFilter){   //setting default search criteria
   this.searchFilter = searchFilter;
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
 
 void setSelectedButton(Integer val)
 {
   this.selectedButton = val;
 }
 
 Integer getSelectedButton()
 {
   return this.selectedButton;
 }
}
