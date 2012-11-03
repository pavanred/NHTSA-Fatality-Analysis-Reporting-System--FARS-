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
      if(map.getZoom()>=12)
      {
        float ellipseSize = 10*scaleFactor;
        for(DataBean b : pointList)
        {
          Location l = new Location(b.get_Latitude_(), b.get_Longitude_());
          Point2f p = map.locationPoint(l);
          fill(#D32929,40);
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
      else if(map.getZoom()<12 && map.getZoom()>=7 && (countyLevelZoom!=null && countyLevelZoom)) //Data poinst will be list of counties
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
            float convVal = map(b.count, 0, b.stateCount, 0, 360);
            arc(p.x,p.y,ellipseSize,ellipseSize,0,radians(convVal));
            fill(#ffffff);
            textSize(ellipseSize*0.2*scaleFactor);
            b.dia = ellipseSize;
            b.x = p.x;
            b.y = p.y;
            b.countyLevel = true;
            textAlign(CENTER,CENTER);
            text(b._countyName_+"\n"+b.count,p.x,p.y);
          }
      }
      else if(stateLevelZoom) //Data points will be list of states
      {
          float ellipseSize = map.getZoom()*10;
          for(DataBean b : pointList)
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
            textSize(ellipseSize*0.2*scaleFactor);
            b.dia = ellipseSize;
            b.x = p.x;
            b.y = p.y;
            b.stateLevel = true;
            textAlign(CENTER,CENTER);
            text(stateHashMap.get(b._State_)+"\n"+b.count,p.x,p.y);
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
}
