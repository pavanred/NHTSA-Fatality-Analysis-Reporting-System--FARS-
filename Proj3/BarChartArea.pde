
class BarChartArea{

  float X1;
  float Y1;
  float X2;
  float Y2;

  BarChartArea(float _X1, float _Y1, float _X2, float _Y2){
    
    X1 = _X1;
    Y1 = _Y1;
    X2 = _X2;
    Y2 = _Y2;
    
  }  
  
  void draw(){
    
    int selectedChart = 0; //default state
    
    BarChart c = new BarChart(X1,Y1,(X2-X1)/2,Y2-Y1,percentX(5),percentX(5),percentY(2),percentY(6));  
        
    //QueryBuilder qb = new QueryBuilder();
    
    /*ArrayList<KeyValue> data = new ArrayList<KeyValue>();
    data.add(new KeyValue(0,300,"test"));
    data.add(new KeyValue(1,200,"ad"));
    data.add(new KeyValue(3,800,"adsf sd"));
    data.add(new KeyValue(4,600,"dsfsda"));
    data.add(new KeyValue(5,500,"dsf"));*/
    
    c.getData(barChartData);
    c.drawChart(#EBD566,10,4,"Years","Crashes","",percentY(6));   
    
  }
}
