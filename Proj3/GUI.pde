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
    
    this.sliderX1 = x1 + percentX(5);
    this.sliderY1 = graphY2 - percentY(5);
    this.sliderX2 = graphX2 - percentX(5) ;
    //this.sliderY2 = graphY2 + (y2-y1)*0.1;
    this.sliderY2 = graphY2;
    
    this.controlsX1 = x1;
    this.controlsY1 = sliderY2+(y2-y1)*0.025;
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
        
    barChartArea.draw();
    
    fill(0,200);
    rect(detailsX1,detailsY1,detailsX2,detailsY2);
    
    popStyle();
    drawControls();
    tabs.draw();
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
    buttons = new ArrayList<BangButton>();
    Tbuttons = new ArrayList<TileButton>();
    BangButton b = new BangButton(tileX2-(tileWidth*0.60),tileY2-tileHeight,tileX2-(tileWidth*0.30),tileY2,"Apply");
    TileButton helpButton = new TileButton(tileX2-(tileWidth*0.60),tileY2,tileX2-(tileWidth*0.30),tileY2+tileHeight,"Help");
    TileButton events = new TileButton(tileX2-(tileWidth*0.30),tileY2-tileHeight,tileX2,tileY2,"Events");
    TileButton usmap = new TileButton(tileX2-(tileWidth*0.30),tileY2,tileX2,tileY2+tileHeight,"Popul.");
    TileButton switchRoadMap = new TileButton(tileX2-(tileWidth*0.6),tileY2-tileHeight*3,tileX2,tileY2-tileHeight*2.5,"Road");
    TileButton switchHybridMap = new TileButton(tileX2-(tileWidth*0.6),tileY2-tileHeight*2.5,tileX2,tileY2-tileHeight*2,"Hybrid");
    TileButton switchAerialMap = new TileButton(tileX2-(tileWidth*0.6),tileY2-tileHeight*2,tileX2,tileY2-tileHeight*1.5,"Aerial");
//    
    buttons.add(b);
    Tbuttons.add(helpButton);
    Tbuttons.add(events);
    Tbuttons.add(usmap);
    Tbuttons.add(switchRoadMap);
    Tbuttons.add(switchHybridMap);
    Tbuttons.add(switchAerialMap);
    
    chartArea = new ChartArea(graphX1,graphY1,graphX2,graphY2 - percentY(13)); //init for chartarea.

    
    //searchCriteria = new Filters();
    
    //slider = new YearSlider(width-(width*0.75),height-200,width-(width*0.25),height-150,2000,2011);
    slider = new YearSlider(sliderX1,sliderY1-percentY(4),sliderX2,sliderY2-percentY(4),2001,2011);
    //slider = new YearSlider(graphX1,graphY1+percentY(4),graphX2,graphY2+percentY(4),2000,2011);
    barChartArea = new BarChartArea(controlsX1 + percentX(8),controlsY1 + percentY(10),controlsX2 + percentX(24),controlsY2 + percentY(8));

  }
  
  void drawControls()
  {
    for(BangButton b : buttons)
    {
      b.draw();
    }
    
    
    slider.drawSlider();
    for(TileButton b : Tbuttons)
    {
      b.draw();
    }
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
        
        float dx1 = detailsX1;
        float dy1 = detailsY1;
        float dx2 = detailsX2;
        float dy2 = detailsY2;

        float dh = (detailsY2-detailsY1)/3;
        textAlign(TOP,TOP);
        StringBuffer displayString = new StringBuffer();
        String popn = execQuery.getPopulationMap().get(selectedPoint._State_);
        String pop1 = popn.split(",")[0];
        String pop2 = popn.split(",")[1];
        float percentage = map(selectedPoint.count,0,getTotalDistinctCasesCount(),0,100);

        DecimalFormat formatter = new DecimalFormat("##,##,###");
        NumberFormat nf = NumberFormat.getInstance();
        nf.setMaximumFractionDigits(3);
        nf.setMinimumFractionDigits(3);
        
        float ratio1 = (float) selectedPoint.count/Float.parseFloat(pop1+1000);
        println(ratio1);
        float ratio2 = (float) selectedPoint.count/Float.parseFloat(pop2+1000);
        
         
        
        displayString.append( stateHashMap.get(selectedPoint._State_)+"  ");
        textSize(12);
        text(displayString.toString(),dx1,dy1,dx2,dy2);
        displayString.setLength(0);
        displayString.append( "Total population in 2000 was "+formatter.format(Integer.parseInt(pop1+1000))+". In 2010, it was "+formatter.format(Integer.parseInt(pop2+1000))+"  ");
        text(displayString.toString(),dx1,dy1 + percentY(3),dx2,dy2 + percentY(3));
        displayString.setLength(0);
        displayString.append("Total number of traffic accidents - "+selectedPoint.count+"  ");
        text(displayString.toString(),dx1,dy1 + percentY(6),dx2,dy2 + percentY(6));
        displayString.setLength(0);
        displayString.append(String.valueOf(nf.format(percentage).toString()) + " % of traffic accidents in USA");
        text(displayString.toString(),dx1,dy1 + percentY(9),dx2,dy2 + percentY(9));
      }
      else if(countyLevelZoom!=null && countyLevelZoom)
      {
        float w = (detailsX2 - detailsX1)*0.5;
        float h = (detailsY1+detailsY2)/4;
        float dx1 = detailsX1;
        float dy1 = detailsY1;
        float dx2 = detailsX2;
        float dy2 = detailsY2;
        
        StringBuffer displayString = new StringBuffer();
        NumberFormat nf = NumberFormat.getInstance();
        nf.setMaximumFractionDigits(3);
        nf.setMinimumFractionDigits(3);
        if(selectedPoint!=null && selectedPoint.count!=-1 && selectedPoint.stateCount!=-1 ){
          float percentage = map(selectedPoint.count,0,selectedPoint.stateCount,0,100);
          if(selectedPoint._countyName_!=null)
            displayString.append(selectedPoint._countyName_ + " County");
            text(displayString.toString(),dx1,dy1,dx2,dy2);
             displayString.setLength(0);
          displayString.append("Number of crashes:"+selectedPoint.count+"  ");
          text(displayString.toString(),dx1,dy1+percentY(3),dx2,dy2+percentY(3));
           displayString.setLength(0);
          displayString.append(String.valueOf(nf.format(percentage).toString()) + " % of traffic accidents in this state");
          
          text(displayString.toString(),dx1,dy1+percentY(6),dx2,dy2+percentY(6));
        }
      }
      else
      {
        StringBuffer displayString = new StringBuffer();
        float dx1 = detailsX1;
        float dy1 = detailsY1;
        float dx2 = detailsX2;
        float dy2 = detailsY2;
        
        displayString.append("Latitude : "+selectedPoint._Latitude_+",Longitude : "+selectedPoint._Longitude_);
        text(displayString.toString(),dx1,dy1,dx2,dy2);
        String cn = removeWhiteSpaces(selectedPoint._countyName_);
//<<<<<<< HEAD
//        displayString.append("County:"+cn+" State:"+selectedPoint._stateName_);
//        displayString.append(", Fatalities:"+selectedPoint._Fatalities_);
//        displayString.append(", Travel Speed:"+convertUnknownTravelSpeed(selectedPoint._TravelSpeed_));
//        displayString.append(", Light Condition:"+bimap.getLightBimap().get( selectedPoint._LightCondition_));
//        displayString.append(", Year:"+selectedPoint._Year_);
//        displayString.append(", Road Surface:"+bimap.getRoadSurfaceBimap().get(selectedPoint._RoadwaySurface_));
//        //displayString.append(", Crash Factor:"+bimap.getCrashFactorBimap().get(selectedPoint._CrashFactor_));
//        displayString.append(", Crash Factor:"+bimap.getCrashFactorBimap().get(selectedPoint._CrashFactor_));
//        text(displayString.toString(),dx1,dy1,dx2,dy2);
//=======
        
        displayString.setLength(0);
        displayString.append("County - "+cn+" State - "+selectedPoint._stateName_);
        text(displayString.toString(),dx1 + percentX(30),dy1,dx2 + percentX(30),dy2);
        
        displayString.setLength(0);
        displayString.append("Year - "+selectedPoint._Year_);
        text(displayString.toString(),dx1,dy1 + percentY(3),dx2,dy2 + percentY(3));
        
        displayString.setLength(0);
        displayString.append("Total Fatalities - "+selectedPoint._Fatalities_);
        text(displayString.toString(),dx1,dy1 + percentY(6),dx2 ,dy2 + percentY(6));
        
        //displayString.append(", Age:"+convertUnknownAge(selectedPoint._Age_));
        //displayString.append(", Travel Speed:"+convertUnknownTravelSpeed(selectedPoint._TravelSpeed_));
        displayString.setLength(0);
        displayString.append("Light Condition - "+bimap.getLightBimap().get( selectedPoint._LightCondition_));
        text(displayString.toString(),dx1 + percentX(30),dy1 + percentY(6),dx2+ percentX(30),dy2 + percentY(6));
         
        displayString.setLength(0);
        displayString.append("Road Surface - "+bimap.getRoadSurfaceBimap().get(selectedPoint._RoadwaySurface_));
        text(displayString.toString(),dx1,dy1 + percentY(9),dx2,dy2 + percentY(9));
        //displayString.append(", Crash Factor:"+bimap.getCrashFactorBimap().get(selectedPoint._CrashFactor_));
        
        Bimaps bimap = new Bimaps();
        
        displayString.setLength(0);
        displayString.append("Crash Factor - "+ bimap.getCrashFactorBimap().get(selectedPoint._CrashFactor_));
        text(displayString.toString(),dx1,dy1+ percentY(12),dx2,dy2+ percentY(12));

        
      }
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

