
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
  map.setCenterZoom(locationChicago, 11);  
  
  // zoom 0 is the whole world, 19 is street level
  // (try some out, or use getlatlon.com to search for more)


  // enable the mouse wheel, for zooming
//  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
//      public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
//        mouseWheel(evt.getWheelRotation());
//      }
//    }); 
//  }
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
  }
}
