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
  float sliderX1,sliderX2,sliderY1,sliderY2;
  float tabW,tabH;
  
  ListBox lb;
  YearSlider slider;
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
    
    this.sliderX1 = x1+(x2-x1)*0.025;
    this.sliderY1 = graphY2;
    this.sliderX2 = x1 + (x2-x1)*0.5 - (x2-x1)*0.025;
    this.sliderY2 = graphY2 + (y2-y1)*0.1;
    
    this.controlsX1 = x1;
    this.controlsY1 = sliderY2+(y2-y1)*0.05;
    this.controlsX2 = x1 + (x2-x1)*0.5;
    this.controlsY2 = sliderY2 + (y2-y1)*0.4;
    
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
    
    //rect(graphX1,graphY1,graphX2,graphY2);
    chartArea.draw(); 
     //rect(graphX1,graphY1,graphX2,graphY2);       

    //rect(controlsX1,controlsY1,controlsX2,controlsY2);
    tabs.draw();    
    barChartArea.draw();
    
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

    
    //searchCriteria = new Filters();
    
    //slider = new YearSlider(width-(width*0.75),height-200,width-(width*0.25),height-150,2000,2011);
    slider = new YearSlider(sliderX1,sliderY1,sliderX2,sliderY2,2000,2011);
    barChartArea = new BarChartArea(controlsX1 + percentX(6),controlsY1 + percentY(14),controlsX2 + percentX(17),controlsY2);

  }
  
  void drawControls()
  {
    for(TileButton b : buttons)
    {
      b.draw();
    }
    
    slider.drawSlider();
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


class YearSlider
{
  float x,y,x2,y2;
  float mmin,mmax;
  Integer yearMin,yearMax;
  YearSlider(float x, float y, float x2, float y2,int yearMin,int yearMax)
  {
    this.x = x;
    this.y = y;
    this.x2 = x2;
    this.y2 = y2;
    this.yearMin = yearMin;
    this.yearMax = yearMax;
    
  }
  
  void drawSlider()
  {
    pushStyle();
    rectMode(CORNERS);
    fill(#35402F,200);
    //rect(x,y,w,h);
    
    int yearInterval = 1;
    int totalYears = yearMax-yearMin;//should be done prior to this in map
    int currentYear = yearMin;
    
    
    
    //draws min ellipse
    fill(#F4F4F7,200);
    stroke(#F4F4F7);
    strokeWeight(6*scaleFactor);
    mmin = map(searchCriteria.currentMinYear,yearMin, yearMax, x, x2);
    ellipse(mmin,(y+y2)/2,y2*0.05,y2*0.05);
    line(mmin,(y+y2)/2,mmin,y2); //line on the ellipse indicating year of selection
    fill(#F4F4F7);
    textAlign(CENTER,TOP);
    text(searchCriteria.currentMinYear,mmin,y2);
    fill(#F4F4F7,200);
    fill(#F4F4F7);
    
    text(yearMin.toString(),x,y2);
    
    //draws max ellipse
    stroke(#F4F4F7);
    fill(#F4F4F7,200);
    mmax = map(searchCriteria.currentMaxYear,yearMin, yearMax, x, x2);
    ellipse(mmax,(y+y2)/2,y2*0.05,y2*0.05);
    line(mmax,(y+y2)/2,mmax,y2); //line on the ellipse indicating year of selection
    fill(#F4F4F7);
    text(searchCriteria.currentMaxYear,mmax,y2);
    fill(#F4F4F7,200);
    fill(#F4F4F7);
    text(yearMax.toString(),x2,y2);
    
    stroke(#F3AB09,50);
    line(x,(y+y2)/2,x2,(y+y2)/2); //center line of the range slider.
    
    stroke(#F3AB09);
    line(getPositionYearMin(),(y+y2)/2,getPositionYearMax(),(y+y2)/2);
    
    //draws lines for slider
    for(currentYear=yearMin;currentYear<yearMax;currentYear++){
      float m = map(currentYear, yearMin, yearMax, x,x2);
      if(currentYear%yearInterval == 0){
        stroke(#ffffff,200);
        float r = y2-y;
        line(m,y+r*0.4,m,y2-r*0.4);
      }
    }
    popStyle();
  }
  
  void updateSlider(float mx, float my){
     if(isWithinSlider(mx,my))
     {
       if(searchCriteria.currentMinYear < searchCriteria.currentMaxYear )
         updatePosition(mx,my);
     }
  }
  
  boolean isWithinSlider(float mx, float my)
  {
    if (mx >= x && mx <= x2 && 
      my >= y && my <= y2) {
      return true;
    }
    else return false;
  }
  
  void updatePosition(float mx, float my)
  {
    float disMinX = (mx > mmin)? mx-mmin: mmin-mx;
    float disMaxX = (mx > mmax)? mx-mmax: mmax-mx;
    if(disMinX < disMaxX)
    {
       int v = getYearPosition(mx); 
       if(v < searchCriteria.currentMaxYear)
         searchCriteria.currentMinYear = v;
    }
    else
    {
      int v = getYearPosition(mx); 
      if(v > searchCriteria.currentMinYear)
        searchCriteria.currentMaxYear = v;
    }
  }
  
  int getYearPosition(float inx)
  {
    return (int)map(inx,x,x2,yearMin,yearMax);
  }
  
  float getPositionYearMin()
  {
    return map(searchCriteria.currentMinYear,yearMin,yearMax,x,x2);
  }
  
  float getPositionYearMax()
  {
    return map(searchCriteria.currentMaxYear,yearMin,yearMax,x,x2);
  }
}

