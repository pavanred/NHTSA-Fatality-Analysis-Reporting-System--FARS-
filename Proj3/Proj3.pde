boolean usingWall = false;

int scaleFactor = 1;

import processing.net.*;
import omicronAPI.*;

OmicronAPI omicronManager;
TouchListener touchListener;

// Link to this Processing applet - used for touchDown() callback example
PApplet applet;

PFont plotFont;

// Override of PApplet init() which is called before setup()
public void init() {
  super.init();
  
  // Creates the OmicronAPI object. This is placed in init() since we want to use fullscreen
  omicronManager = new OmicronAPI(this);
  
  // Removes the title bar for full screen mode (present mode will not work on Cyber-commons wall)
  omicronManager.setFullscreen(true);
}

void setup()
{
  // For almost any Processing application size() should be called before anything else in setup()
  if( usingWall ) 
    size( 8160, 2304, P3D ); // Cyber-Commons wall (P3D renderer is recommended for running on the wall)
  else
    size( 1350, 382 );
  
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
  plotFont = createFont("DroidSans-Bold.ttf",12*scaleFactor);
  textFont(plotFont);
}

void draw()
{
  background(20);
  omicronManager.process();
  
}

// Touch events
void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth){
  noFill();
  stroke(255,0,0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
}// touchDown

void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth){
  noFill();
  stroke(0,255,0);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
}// touchMove

void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth){
  noFill();
  stroke(0,0,255);
  ellipse( xPos, yPos, xWidth * 2, yWidth * 2 );
}// touchUp

