
class Filters{
 
 Filters(){}  //
 
 Filters(int weather, int speedCategory, int lightCondition, int vehicleType, int ageCategory, int alcoholCategory, int crashHour, int sex){   //setting default search criteria
   
   Weather = weather;
   SpeedCategory = speedCategory;
   LightCondition = lightCondition;
   VehicleType = vehicleType;
   AgeCategory = ageCategory;
   AlcoholCategory = alcoholCategory;
   CrashHour = crashHour;
   Sex = sex;
   
 }
  
 int Weather;
 int SpeedCategory;
 int LightCondition;
 int VehicleType;
 int AgeCategory;
 int AlcoholCategory;
 int CrashHour;
 int Sex;
}
