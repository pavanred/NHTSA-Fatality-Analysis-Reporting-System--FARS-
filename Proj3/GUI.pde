/*
Main GUI Class that does all the drawing on the canvas.
*/
class GUI
{
  float x1,y1,x2,y2; 
  float graphX1,graphY1,graphX2,graphY2;
  float controlsX1,controlsY1,controlsX2,controlsY2;
  float mapX1,mapY1,mapX2,mapY2;
  float detailsX1,detailsY1,detailsX2,detailsY2;
  float tabW,tabH;
  ChartArea chartArea;
  ListBox lb;
  GUI(float x1, float y1, float x2, float y2)
  {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    
    this.graphX1 = x1;
    this.graphY1 = y1;
    this.graphX2 = x1 + (x2-x1)*0.5;
    this.graphY2 = y1 + (y2-y1)*0.5;
    
    this.controlsX1 = x1;
    this.controlsY1 = graphY2;
    this.controlsX2 = x1 + (x2-x1)*0.5;
    this.controlsY2 = graphY2 + (y2-y1)*0.5;
    
    this.tabW = (controlsX2-controlsX1)/10;
    this.tabH = (controlsY2-controlsY1)*0.25;
    
    this.mapX1 = graphX2;
    this.mapY1 = y1;
    this.mapX2 = x2;
    this.mapY2 = y2;
    
    this.detailsX1 = width/2;
    this.detailsX2 = width;
    this.detailsY1 = 0;
    this.detailsY2 = height*0.15;
    
    println("====");
    setupControls();
    
  }
  
  void draw()
  {
    pushStyle();
    rectMode(CORNERS);
    
    //rect(mapX1,mapY1,mapX2,mapY2);
    
    mapArea.draw();
    
    pushStyle();
    fill(20);
    
    rect(0,0,width/2,height); // to hide extra map drawn. TODO - find a better way.
    
    rect(graphX1,graphY1,graphX2,graphY2);
    
     //rect(graphX1,graphY1,graphX2,graphY2);
    //chartArea.draw();    

    rect(controlsX1,controlsY1,controlsX2,controlsY2);
    tabs.draw();
    
    
    fill(0,200);
    rect(detailsX1,detailsY1,detailsX2,detailsY2);
    
    popStyle();
    drawControls();
    
    popStyle();    
  }
  
  void setupControls()
  {
    weatherHashMap = HashBiMap.create();
    weatherHashMap.put("Clear",100);
    //stateHashMap = HashBiMap.create();
    //stateHashMap.put("Illinois",17);
    
    float tileX1 = controlsX1+controlsX1*0.05;
    float tileY1 = controlsY1+controlsY1*0.05;
    float tileX2 = controlsX2-controlsX2*0.05;
    float tileY2 = controlsY2-controlsY1*0.05;
    
    float tileWidth = (tileX2-tileX1)/5;
    float tileHeight = (tileY2-tileY1)/3;
    buttons = new ArrayList<TileButton>();
    TileButton b = new TileButton(tileX2-(tileWidth*0.30),tileY2-tileHeight,tileX2,tileY2,"Apply");
    buttons.add(b);
    
    chartArea = new ChartArea(graphX1,graphY1,graphX2,graphY2); //init for chartarea.
    
//    lb = new ListBox(tileX1+tileWidth,tileY1+tileHeight,tileX1+tileWidth*2,tileY1+tileHeight*2,scaleFactor);
//    lb.addItem("Hello1");
//    lb.addItem("Hello2");
//    lb.addItem("Hello3");
  }
  
  void drawControls()
  {
    for(TileButton b : buttons)
    {
      b.draw();
    }
    //lb.draw();
    drawPointDetails();
  }
  
  void drawPointDetails() // method to draw the details of the currently selected plot
  {
    pushStyle();
    fill(255);
    if(selectedPoint!=null)
    {
      if(selectedPoint.stateLevel!=null && selectedPoint.stateLevel)
      {
        float w = (detailsX2 - detailsX1)*0.5;
        float h = (detailsY1+detailsY2)/4;
        text(stateHashMap.get(selectedPoint._State_),detailsX1+w,detailsY1+h);
      }
      else if(countyLevelZoom!=null && countyLevelZoom)
      {
        float w = (detailsX2 - detailsX1)*0.5;
        float h = (detailsY1+detailsY2)/4;
        if(selectedPoint._countyName_!=null)
        text(selectedPoint._countyName_,detailsX1+w,detailsY1+h);
      }
      else
        text("Lat:"+selectedPoint._Latitude_+",Lon:"+selectedPoint._Longitude_,detailsX1+50,detailsY1+50);
    }
    popStyle();
  }
}
