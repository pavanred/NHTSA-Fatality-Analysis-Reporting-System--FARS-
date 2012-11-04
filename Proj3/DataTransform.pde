
class DataTransform{
 
 public ArrayList<Float> getCrashCountByYear(){
  
  ArrayList<Integer> years = new ArrayList<Integer>(); 
  ArrayList<Float> graphData = new ArrayList<Float>();
  int prevYear = -1;
  int currentYear = 0;
  int currentIndex = 0;
  float currentCount = 0;
 
  for(int i = 0; i < pointList.size();i++){

    currentYear = pointList.get(i).get_Year_();
    
   if(prevYear != currentYear){    
    years.add(currentYear); 
    graphData.add(0.0);
    currentIndex = years.indexOf(currentYear);
    currentCount = 0;    
    graphData.set(currentIndex,(currentCount + 1));
   }
   else{
     currentIndex = years.indexOf(currentYear);
     currentCount = graphData.get(currentIndex); 
     graphData.set(currentIndex,(currentCount + 1));
   }
   
   prevYear = currentYear;  
  }
  
  for(int i=0;i<years.size();i++){
   println(years.get(i));
   println(graphData.get(i)); 
  }
  
  return graphData;
 }
 
 /*public ArrayList<KeyValue> getBarChartData(int dataType){
   
 }*/
  
}
