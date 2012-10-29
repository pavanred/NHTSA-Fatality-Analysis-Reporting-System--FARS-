/*
Main GUI Class that does all the drawing on the canvas.
*/
class GUI
{
  float x1,y1,x2,y2; 
  float graphX1,graphY1,graphX2,graphY2;
  float controlsX1,controlsY1,controlsX2,controlsY2;
  float mapX1,mapY1,mapX2,mapY2;
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
    
    this.mapX1 = graphX2;
    this.mapY1 = y1;
    this.mapX2 = x2;
    this.mapY2 = y2;
    
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

    rect(controlsX1,controlsY1,controlsX2,controlsY2);
    
    popStyle();
    
    popStyle();    
  }
}
