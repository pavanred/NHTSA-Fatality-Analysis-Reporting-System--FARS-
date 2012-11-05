ArrayList<Float> crashes = new ArrayList();

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
    
    Chart c = new Chart(X1,Y1,X2-X1,Y2-Y1,percentX(5),percentX(5),percentY(3),percentY(3));  //margins not defined
    
    c.getData(chartData,2001,2011);
    c.drawChart(0,#EEE09B,10,4,"","Crashes","");   
    
  }
}
