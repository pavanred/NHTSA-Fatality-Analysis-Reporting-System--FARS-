int[] colorArray;
class MapArea
{
  PVector mapSize;
  PVector mapOffset;
  MapArea(PVector mapSize, PVector mapOffset )
  {
    this.mapSize = mapSize;
    this.mapOffset = mapOffset;
    touchList = new Hashtable(); // inits the touch list for multi touch on the map area.
    
    // create a new map, optionally specify a provider
  
  // OpenStreetMap would be like this:
  //map = new InteractiveMap(this, new OpenStreetMapProvider());
  // but it's a free open source project, so don't bother their server too much
  
  // AOL/MapQuest provides open tiles too
  // see http://developer.mapquest.com/web/products/open/map for terms
  // and this is how to use them:
  String template = "http://{S}.mqcdn.com/tiles/1.0.0/osm/{Z}/{X}/{Y}.png";
  String[] subdomains = new String[] { "otile1", "otile2", "otile3", "otile4" }; // optional
  //map = new InteractiveMap(this, new Microsoft.AerialProvider(), mapOffset.x, mapOffset.y, mapSize.x, mapSize.y );
  
  setMapProvider(0);
  
  // others would be "new Microsoft.HybridProvider()" or "new Microsoft.AerialProvider()"
  // the Google ones get blocked after a few hundred tiles
  // the Yahoo ones look terrible because they're not 256px squares :)

  // set the initial location and zoom level:
  map.setCenterZoom(locationIL, 5);  
  
  // zoom 0 is the whole world, 19 is street level
  // (try some out, or use getlatlon.com to search for more)


  // enable the mouse wheel, for zooming
//  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
//      public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
//        mouseWheel(evt.getWheelRotation());
//      }
//    }); 
//  }
  loadColors();
  }  
  void setMapProvider(int newProviderID){
    switch( newProviderID ){
      case 0: map.setMapProvider( new Microsoft.RoadProvider() ); break;
      case 1: map.setMapProvider( new Microsoft.HybridProvider() ); break;
      case 2: map.setMapProvider( new Microsoft.AerialProvider() ); break;
    }
  }
  
  void draw()
  {
    map.draw();
    
    noFill();
    stroke(10);
    strokeWeight(10);
    //rect(this.mapOffset.x,this.mapOffset.y, this.mapSize.x,this.mapSize.y);
    strokeWeight(1);
    
    // Do not use smooth() on the wall with P2D (JAVA2D ok)
    if(usingWall)
      noSmooth();
    else
      smooth();
    drawPoints();
  }
  
  void drawPoints()
  {
    
    pushStyle();
    if(pointList!=null){
      if(map.getZoom()>=11)
      {
        float ellipseSize = 10*scaleFactor;
        for(DataBean b : pointList)
        {
          Location l = new Location(b.get_Latitude_(), b.get_Longitude_());
          Point2f p = map.locationPoint(l);
          if(map.getZoom()>14)
            fill(#D32929);
          else
            fill(#D32929,50);
          noStroke();
          b.x = p.x;
          b.y = p.y;
          b.stateLevel = false;
          b.dia = ellipseSize;
          ellipse(p.x, p.y, ellipseSize, ellipseSize);
        }
        countyLevelZoom = false;
        stateLevelZoom = false;
      }
      else if(map.getZoom()<11 && map.getZoom()>=7 && (countyLevelZoom!=null && countyLevelZoom)) //Data poinst will be list of counties
      {
        float ellipseSize = map.getZoom()*5;
        for(DataBean b : pointList)
        {
          if(b==null)
            continue;
          Location l = new Location(b.get_Latitude_(), b.get_Longitude_());
          Point2f p = map.locationPoint(l);
          fill(#464545,200);
          noStroke();
          ellipse(p.x, p.y, ellipseSize, ellipseSize);
          fill(#D32929,200);
          if(b.stateCount==null)
          {
            println("b.stateCount for :"+b._State_);
            b.stateCount = 1000;
          }
          float convVal = map(b.count, 0, b.stateCount, 0, 360);
          arc(p.x,p.y,ellipseSize,ellipseSize,0,radians(convVal));
          fill(#ffffff);
          textSize(ellipseSize*0.2*scaleFactor);
          b.dia = ellipseSize;
          b.x = p.x;
          b.y = p.y;
          b.countyLevel = true;
          DecimalFormat formatter = new DecimalFormat("##,##,###");
          textAlign(CENTER,CENTER);
          text(b._countyName_+"\n"+formatter.format(b.count),p.x,p.y);
        }
      }
      else if(map.getZoom()<7) //Data points will be list of states
      {
         Boolean top10=false;
         if(map.getZoom()>4)
         {
           top10 = false;
           displayByState(top10);
         }
         else
         {
           top10 = true;
           displayByState(top10);
         }
      }
    }
    popStyle();
  }
  
  HashMap<Integer,ArrayList<DataBean>> splitPointsByCounty()
  {
    HashMap<Integer,ArrayList<DataBean>> pointsByCounty = new HashMap<Integer,ArrayList<DataBean>>();
    for(DataBean b : pointList)
    {
      if(pointsByCounty.containsKey(b._County_))
        pointsByCounty.get(b._County_).add(b);
      else
        {
          ArrayList<DataBean> k = new ArrayList<DataBean>();
          k.add(b);
          pointsByCounty.put(b._County_,k);
        }
    } 
    return pointsByCounty;
  }
  
  void loadColors() {
    
    colorArray = new int[150];
  
    colorArray[0] = 0xFFA053D4;//FF80B1D3;
    colorArray[1] = 0xFFD453B4;//FFBC80BD;
    colorArray[2] =0xFF5386D4;//FFBEBADA;
    colorArray[3] = 0xFF08C880;//FF9508C8;//FFFB8072;
    colorArray[4] = 0xFFAD0E0E;//FFC72727;//FFFF3232;//0xFFFFF232;//FFB3DE69;
    colorArray[5] = 0xFFFF8E2A;//FFFF522A;//FFFFED6F;
  
    colorArray[6] = 0xFFFA9987;//0xFFFA684C;//FFFFFFFF;
    colorArray[7] = 0xFF79B71E;//0xFF4F95AD; //0xFF359128;//0xFF332891;//0xFFA3FA2F;//FFFFFFFF;
    colorArray[8] = 0xFF2F83FA;//FFFFFFFF;
    colorArray[9] = 0xFF480DBC;//0xFF732FFA;//FFFFFFFF;
    colorArray[10] = 0xFFFA2F2F;//FFFFFFFF;
    colorArray[11] = 0xFF2F8A37;//FFFFFFFF;
    colorArray[12] = 0xFF2F8A88;//FFFFFFFF;
    colorArray[13] = 0xFF322F8A;//FFFFFFFF;
    colorArray[14] = 0xFF79288A;//0xFF7A2F8A;//FFFFFFFF;
    colorArray[15] = 0xFF8A2F4B;//FFFFFFFF;
    colorArray[16] = 0xFF075B0F;//0xFF0A8115;//0xFF0EAD1C;//FFFFB432;//FFFFFFFF;
    colorArray[17] = 0xFFFF6232;//FF531E;//FF6232;//FFFFFFFF;
  }
  
  HashMap<String,Location> mapStatesOut()
  {
    String[] m = {"Virginia", "Maryland", "District of Columbia", "Pennsylvania", "Delaware", "NewJersey", "Connecticut", "RhodeIsland", "Massachusetts", "NewHampshire", "Vermont"};
    //ArrayList<String> l = new ArrayList<String>(Arrays.asList(m));
    HashMap<String,Location> mapDisplayStateOut = new HashMap<String,Location>();
    
    Location l = new Location(32.91,-74.79);
    mapDisplayStateOut.put("DC",l);
    
    l = new Location(34.59,-71.89);
    mapDisplayStateOut.put("MD",l);
    
    l = new Location(35.74,-70.22);
    mapDisplayStateOut.put("DE",l);
    
    l = new Location(37.02,-69.08);
    mapDisplayStateOut.put("NJ",l);
    
    l = new Location(39.77,-71.19);
    mapDisplayStateOut.put("CT",l);
    
    l = new Location(38.68,-67.14);
    mapDisplayStateOut.put("RI",l);
    
    l = new Location(41.24,-67.32);
    mapDisplayStateOut.put("MA",l);
    
    return mapDisplayStateOut; 
  }
  
  void displayByState(Boolean top10)
  {
    float ellipseSize;
    if(!top10)
      ellipseSize = map.getZoom()*7.5;
    else
      ellipseSize = map.getZoom()*10;
    BiMap bm = execQuery.getDisplayStates();
    int count = 1;
    HashMap<String,Location> mapSO = mapStatesOut();
    for(DataBean b : pointList)
    {
      if(b==null)
        continue;
      if(!bm.containsKey(b._State_)) //if there is no mapping for the state name, skip the point.
        continue;
      
      if(mapSO.containsKey(bm.get(b._State_))) //check if its a state that needs to be properly mapped
      {
        Location nL = mapSO.get(bm.get(b._State_));
        Point2f p2 = map.locationPoint(nL);
        
        Location l = new Location(b.get_Latitude_(), b.get_Longitude_());
        Point2f p = map.locationPoint(l);
        pushStyle();
        fill(0);
        stroke(0);
        line(p.x,p.y,p2.x,p2.y);
        popStyle();
        
        fill(#464545,200);
        noStroke();
        ellipse(p2.x, p2.y, ellipseSize, ellipseSize);
        fill(#D32929,200);
        float convVal = map(b.count, 0, pointList.get(pointList.size()-1).count, 0, 360);
        arc(p2.x,p2.y,ellipseSize,ellipseSize,0,radians(convVal));
        fill(#ffffff);
        b.dia = ellipseSize;
        b.x = p2.x;
        b.y = p2.y;
        b.stateLevel = true;
        DecimalFormat formatter = new DecimalFormat("##,##,###");
        textSize(ellipseSize*0.2);
        textAlign(CENTER,CENTER);
        text(bm.get(b._State_)+"\n"+formatter.format(b.count),p2.x,p2.y);
        
      }
      else // do the normal thing
      {
      Location l = new Location(b.get_Latitude_(), b.get_Longitude_());
      Point2f p = map.locationPoint(l);
      fill(#464545,200);
      noStroke();
      ellipse(p.x, p.y, ellipseSize, ellipseSize);
      fill(#D32929,200);
      float convVal = map(b.count, 0, pointList.get(pointList.size()-1).count, 0, 360);
      arc(p.x,p.y,ellipseSize,ellipseSize,0,radians(convVal));
      fill(#ffffff);
      b.dia = ellipseSize;
      b.x = p.x;
      b.y = p.y;
      b.stateLevel = true;
        
      DecimalFormat formatter = new DecimalFormat("##,##,###");
      textSize(ellipseSize*0.2);
      textAlign(CENTER,CENTER);
      text(bm.get(b._State_)+"\n"+formatter.format(b.count),p.x,p.y);
      }
      
      if(top10 && count==10)
        break;
      count++;
    }
  }
}
