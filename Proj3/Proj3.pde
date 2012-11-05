
boolean usingWall = false;

int scaleFactor = 1;

// Global vars 
InteractiveMap map;
Hashtable touchList;
Location locationChicago = new Location(41.9f, -87.6f); // to set the initial location on the map.
Location locationUSA = new Location(38.962f, -93.928); // Use with zoom level 6
Location locationIL = new Location(40.43f,-88.92f);
PVector mapSize;
PVector mapOffset;
MapArea mapArea;
ControlsTab tabs;
String currentTab;
private static Map<String, Integer> weatherHashMap;
private static Map<Integer, String> stateHashMap;
Bimaps bimap;

ChartArea chartArea;
ArrayList<Float> chartData = new ArrayList<Float>();
BarChartArea barChartArea;
ArrayList<KeyValue> barChartData = new ArrayList<KeyValue>();

ArrayList<BangButton> buttons;
Button qButton;
ArrayList<DataBean> pointList,statePointList;
Filters searchCriteria;
int selectedChartType = 1;

QueryBuilder execQuery;

Boolean stateLevelZoom = null;
Boolean countyLevelZoom = null;

int lastZoom;

DataBean selectedPoint = null;
//End of global vars

//=================================
import processing.net.*;
import omicronAPI.*;
//stuff for modest maps
import processing.opengl.*;
import com.modestmaps.*;
import com.modestmaps.core.*;
import com.modestmaps.geo.*;
import com.modestmaps.providers.*;
import com.google.common.*;
//--end of stuff for modest maps

OmicronAPI omicronManager;
TouchListener touchListener;

// Link to this Processing applet - used for touchDown() callback example
PApplet applet;

PFont plotFont;

//===============Global vars====================
GUI gui;
//===============End of Global vars=============

// Override of PApplet init() which is called before setup()
public void init() {
  super.init();
  
  // Creates the OmicronAPI object. This is placed in init() since we want to use fullscreen
  omicronManager = new OmicronAPI(this);
  
  // Removes the title bar for full screen mode (present mode will not work on Cyber-commons wall)
  omicronManager.setFullscreen(false);
}

void setup()
{
  // For almost any Processing application size() should be called before anything else in setup()
  if( usingWall ) 
  {
    size( 8160, 2304, P2D ); // Cyber-Commons wall (P3D renderer is recommended for running on the wall)
    noSmooth();
  }
  else
  {
    size( 1350, 382 );    
    smooth();
  }
  
  setupGUIElements();
  
  // Make the connection to the tracker machine (Comment this out if testing with only mouse)
  //omicronManager.ConnectToTracker(7001, 7340, "131.193.77.159");
  
  // Create a listener to get events
  touchListener = new TouchListener();
  
  // Register listener with OmicronAPI (This will still get mouse input without connecting to the tracker)
  omicronManager.setTouchListener(touchListener);

  // Sets applet to this sketch
  applet = this;
}

//Method can be used to prepare all GUI Elements to be drawn
void setupGUIElements()
{
  //plotFont = createFont("DroidSans-Bold.ttf",12*scaleFactor);
  plotFont = createFont("Serif",12*scaleFactor);
  textFont(plotFont);
  
  // init map
  bimap = new Bimaps();
  
  //filters 
  //searchCriteria = new Filters(99, 1, 99, -1, -1, 1, 1, 1);
  searchCriteria = new Filters(getDefaultFilter(),bimap.getFiltersBimap().get("Age"));
  
  //sets width and height for the entire drawing canvas.
  float windowX1 = width*0.01;
  float windowX2 = width*0.99;
  float windowY1 = height*0.05;
  float windowY2 = height*0.95;
  gui = new GUI(windowX1,windowY1,windowX2,windowY2);
  
  mapSize = new PVector( width/2, height );
  mapOffset = new PVector(width/2, 0 );  
  println(gui.mapY2-gui.mapY1);
  map = new InteractiveMap(this, new Microsoft.AerialProvider(),mapOffset.x, mapOffset.y, mapSize.x, mapSize.y ); // does not work when put inside MapArea constructor
  mapArea = new MapArea(mapSize,mapOffset);
  
  addMouseWheelListener(new java.awt.event.MouseWheelListener() {
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
    }
  }); 
  execQuery = new QueryBuilder();
  execQuery.checking();
  applyChartFilters();
  tabs = new ControlsTab(gui.controlsX1,gui.controlsY1,gui.controlsX2,gui.tabH);
  lastZoom = 5;
  

  //searchCriteria.setSelectedButton(bimap.getFiltersBimap().get("Weather"));

}

void draw()
{
  background(20);
  gui.draw();
  pushStyle();
  omicronManager.process(); // always keep this at the end.
  popStyle();
  
}

//==========================================EVENT HANDLING================================


// Touch position at last frame
PVector lastTouchPos = new PVector();
PVector lastTouchPos2 = new PVector();
int touchID1;
int touchID2;

PVector initTouchPos = new PVector();
PVector initTouchPos2 = new PVector();

void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth){
  noFill();
  stroke(255,0,0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
  
  checkButtons(xPos,yPos);
  // Update the last touch position
  lastTouchPos.x = xPos;
  lastTouchPos.y = yPos;
  
  // Add a new touch ID to the list
  Touch t = new Touch( ID, xPos, yPos, xWidth, yWidth );
  touchList.put(ID,t);
  
  if( touchList.size() == 1 ){ // If one touch record initial position (for dragging). Saving ID 1 for later
    touchID1 = ID;
    initTouchPos.x = xPos;
    initTouchPos.y = yPos;
  }
  else if( touchList.size() == 2 ){ // If second touch record initial position (for zooming). Saving ID 2 for later
    touchID2 = ID;
    initTouchPos2.x = xPos;
    initTouchPos2.y = yPos;
  }
}// touchDown

void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth){
  noFill();
  stroke(0,255,0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
  gui.slider.updateSlider(xPos,yPos);
  //Acts on the map only if lies within map area.
  if(isWithinMap(xPos,yPos)){
    if( touchList.size() < 2 ){
      // Only one touch, drag map based on last position
      map.tx += (xPos - lastTouchPos.x)/map.sc;
      map.ty += (yPos - lastTouchPos.y)/map.sc;
      applyChanges();
    } else if( touchList.size() == 2 ){
      int zin = map.getZoom();
      // Only two touch, scale map based on midpoint and distance from initial touch positions
      
      float sc = dist(lastTouchPos.x, lastTouchPos.y, lastTouchPos2.x, lastTouchPos2.y);
      float initPos = dist(initTouchPos.x, initTouchPos.y, initTouchPos2.x, initTouchPos2.y);
      
      PVector midpoint = new PVector( (lastTouchPos.x+lastTouchPos2.x)/2, (lastTouchPos.y+lastTouchPos2.y)/2 );
      sc -= initPos;
      sc /= 5000;
      sc += 1;
      //println(sc);
      float mx = (midpoint.x - mapOffset.x) - mapSize.x/2;
      float my = (midpoint.y - mapOffset.y) - mapSize.y/2;
      map.tx -= mx/map.sc;
      map.ty -= my/map.sc;
      map.sc *= sc;
      map.tx += mx/map.sc;
      map.ty += my/map.sc;
      int zout = map.getZoom();
      if(zin-zout != 0)
        applyChanges();
    } else if( touchList.size() >= 5 ){
      
      // Zoom to entire USA
      map.setCenterZoom(locationUSA, 6);  
      applyChanges();
    }
    
    // Update touch IDs 1 and 2
    if( ID == touchID1 ){
      lastTouchPos.x = xPos;
      lastTouchPos.y = yPos;
    } else if( ID == touchID2 ){
      lastTouchPos2.x = xPos;
      lastTouchPos2.y = yPos;
    } 
    
    // Update touch list
    Touch t = new Touch( ID, xPos, yPos, xWidth, yWidth );
    touchList.put(ID,t);
  }
}// touchMove

void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth){
  noFill();
  stroke(0,0,255);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
  
  // Remove touch and ID from list
  touchList.remove(ID);
}// touchUp



//END OF TOUCH EVENTS

// zoom in or out: using mouse wheel
void mouseWheel(int delta) {
  int zin = map.getZoom();
  if(isWithinMap(mouseX,mouseY)){
    //applyChanges();
    float sc = 1.0;
    if (delta < 0) {
      sc = 1.05;
    }
    else if (delta > 0) {
      sc = 1.0/1.05; 
    }
    float mx = (mouseX - mapOffset.x) - mapSize.x/2;
    float my = (mouseY - mapOffset.y) - mapSize.y/2;
    map.tx -= mx/map.sc;
    map.ty -= my/map.sc;
    map.sc *= sc;
    map.tx += mx/map.sc;
    map.ty += my/map.sc;
  }
  int zout = map.getZoom();
  if(zin-zout != 0)
    applyChanges();
}

//==========================================END OF EVENT HANDLING================================


boolean isWithinMap(float x, float y) // checks if the touch is within map area before doing zoom or pan
{
  if ( (x >= mapOffset.x && x <=mapOffset.x+mapSize.x) && (y >= mapOffset.y && y <= mapOffset.y+mapSize.y) )
    return true;
  else 
    return false;
}

// checks if any of the buttons are pressed. If pressed does the appropriate operation.
void checkButtons(float xPos, float yPos) 
{
  for(BangButton b : buttons)
  {
    if(b.touch(xPos,yPos))
    {
      if(b.label.equals("Apply"))
        applyChartFilters();
    }
  }
  if(pointList!=null)
  {
    for(DataBean b : pointList)
    {
      if(b.updateButton(xPos,yPos))
      {
        selectedPoint = b;       
      }
    }
  }
  tabs.updateTabs(xPos,yPos);
  
  gui.slider.updateSlider(xPos,yPos);
}

//Called whenever there is a zoom in/out. to call DB.
void applyChanges()
{
    println("mapzoom:"+map.getZoom());
    if(map.getZoom()>=11  && map.getZoom()!= lastZoom) //get point level data only if the map is zoomed > 5
    {
      println("ZOOOM IN:"+map.getZoom());
      pointList = execQuery.getPointsFromDB();
      lastZoom = map.getZoom();
      
    }
    //else if(map.getZoom()>=7 && map.getZoom()<12 && (countyLevelZoom==null || !countyLevelZoom))
    else if(map.getZoom()>=7 && map.getZoom()<11 && map.getZoom()!= lastZoom)
    {
      println("County zoom IN:"+map.getZoom());
      pointList = execQuery.getCountyPointsFromDB();
      lastZoom = map.getZoom();
    }
    //else if(map.getZoom()<=6 && (stateLevelZoom==null || !stateLevelZoom))
    else if(map.getZoom()<=6 && map.getZoom()!= lastZoom)
    {
      println("ZOOOM:"+map.getZoom());
      //pointList = execQuery.getStatePointsFromDB(2001);
        //statePointList = pointList;
      lastZoom = map.getZoom();
      if(statePointList==null)
      {
        pointList = execQuery.getStatePointsFromDB();
        statePointList = pointList;
      }
      else
      {
        println("size:"+statePointList.size());
        pointList = statePointList;
      }
    }

    //chartData = execQuery.getCrashesByYear();    
    //barChartData = execQuery.getCrashesByGroup();
}

void applyChartFilters()
{
  if(map.getZoom()>=11  ) //get point level data only if the map is zoomed > 5
    {
      println("ZOOOM IN:"+map.getZoom());
      pointList = execQuery.getPointsFromDB();
      lastZoom = map.getZoom();
      
    }
    //else if(map.getZoom()>=7 && map.getZoom()<12 && (countyLevelZoom==null || !countyLevelZoom))
    else if(map.getZoom()>=7 && map.getZoom()<11 )
    {
      println("County zoom IN:"+map.getZoom());
      pointList = execQuery.getCountyPointsFromDB();
      lastZoom = map.getZoom();
    }
    //else if(map.getZoom()<=6 && (stateLevelZoom==null || !stateLevelZoom))
    else if(map.getZoom()<=6 )
    {
      println("ZOOOM:"+map.getZoom());
      //pointList = execQuery.getStatePointsFromDB(2001);
        //statePointList = pointList;
      lastZoom = map.getZoom();
      if(statePointList==null)
      {
        pointList = execQuery.getStatePointsFromDB();
        statePointList = pointList;
      }
      else
      {
        println("size:"+statePointList.size());
        pointList = statePointList;
      }
    }

    chartData = execQuery.getCrashesByYear();    
    barChartData = execQuery.getCrashesByGroup();
}
