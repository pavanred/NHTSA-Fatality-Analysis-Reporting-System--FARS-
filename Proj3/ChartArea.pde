class ChartArea{

  float X1;
  float Y1;
  float X2;
  float Y2;

  ChartArea(float _X1, float _Y1, float _X2, float _Y2){
    
    X1 = _X1;
    Y1 = _Y1;
    X2 = _X2;
    Y2 = _Y2;
    
  }  
  
  void draw(){
    
    Chart c = new Chart(X1,Y1,X2-X1,Y2-Y1,0,0,0,0);  //margins not defined
    c.getData(new ArrayList<Float>(),2001,2011);
    c.drawChart(0,255,10,5,"years","Crashes","");
    
    
  }
}
