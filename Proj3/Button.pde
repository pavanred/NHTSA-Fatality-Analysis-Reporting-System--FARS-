PImage usmap;
public class Button
{
	//MIGHT WANT TO ADD A BOOL FOR BEING VISIBLE IF WE WILL BE HAVING
	//MULTIPLE SCREEN TYPES TO SWITCH ACROSS
        private int scaleFactor;
	private float xPos1;
        private float xPos2;
	private float yPos1;
        private float yPos2;
	private float width;
	private float height;
	private String label;
	public boolean isSelected;

	public Button(float x, float y, float w, float h, String l, int sF)
	{
                scaleFactor = sF;
		xPos1 = x*sF;
		yPos1 = y*sF;
		xPos2 = w*sF;
		yPos2 = h*sF;
		label = l;
                isSelected = false;
	}

	public void draw()
	{
		if (isSelected)
			fill(64);
		else
			fill(128);
		
		rectMode(CORNERS);
		rect(xPos1, yPos1, xPos2, yPos2);
		textAlign(CENTER);
                fill(128+64+32+16);
                textSize(12+2*scaleFactor);
		text(label, xPos1 - .5*(xPos1-xPos2), yPos1-.5*(yPos1-yPos2)+4*scaleFactor);
		
	}

	// returns 1 if the touch coordinates matched, 0 if not
	// also toggles isSelected if it was touched
	public int touch(float x, float y)
	{
          println(x+","+y);
          println(xPos1+","+yPos1+","+xPos2+","+yPos2);
		if ( (x >= xPos1 && x <=xPos2 ) && (y >= yPos1 && y <= yPos2) )
		{
			if (isSelected)
				isSelected = false;
			else
				isSelected = true;
			return 1;
		}
		return 0;
	}
}

public class TileButton
{
  private int scaleFactor;
  private float xPos1;
  private float xPos2;
  private float yPos1;
  private float yPos2;
  private float width;
  private float height;
  private String label;
  public boolean isSelected;
  private int value;
  color highlightcolor,basecolor,currentcolor,labelColor_unselected,labelColor_selected;
  
  public TileButton(float x, float y, float x2, float y2, String label)
  {
    this.xPos1 = x;
    this.yPos1 = y;
    this.xPos2 = x2;
    this.yPos2 = y2;
    this.label = label;
    this.isSelected = false;
    this.highlightcolor = color(#3B3630);
    this.basecolor = color(#4B443C);
    this.currentcolor = basecolor;
    this.labelColor_unselected = color(255);
    this.labelColor_selected = color(#F0B30D);
    usmap = loadImage("usmap.png");
  }
  
  public void draw()
  {
    pushStyle();
    rectMode(CORNERS);
    fill(basecolor);
    rect(xPos1,yPos1,xPos2,yPos2,5);
    textAlign(CENTER,CENTER);
    
    if (isSelected)
    {
        fill(labelColor_selected);
        text(label,xPos1,yPos1,xPos2,yPos2);
        if(label.equals("Help")) //draw help window.
        {
          drawHelpBox();
        }
        if(label.equals("Events")) //draw help window.
        {
          drawEventBox();
        }
        if(label.equals("Popul."))
        {
          drawUSMAP();
        }
        
    }
    else
    {
      fill(labelColor_unselected);
      text(label,xPos1,yPos1,xPos2,yPos2);
    }
    
    popStyle();
  }
  
  public int touch(float x, float y)
  {
    if ( (x >= xPos1 && x <=xPos2 ) && (y >= yPos1 && y <= yPos2) )
    {
      if (isSelected)
      {
        isSelected = false;
        if(label.equals("Road"))
        {
          map.setMapProvider( new Microsoft.RoadProvider() );
        }
        if(label.equals("Hybrid"))
        {
          map.setMapProvider( new Microsoft.HybridProvider() );
        }
        if(label.equals("Aerial"))
        {
          map.setMapProvider( new Microsoft.AerialProvider() );
        }
      }
      else
      {
        isSelected = true;
        
      }
      return 1;
    }
    return 0;
  }
  
  public void drawHelpBox()
  {
    pushStyle();
    fill(0,250);
    noStroke();
    rect(gui.graphX1,gui.graphY1,gui.graphX2,gui.graphY2,4);
    float xvalHead = gui.graphX1 + percentX(25);
    float xval = gui.graphX1 + percentX(1);
    float yval = gui.graphY1 + percentY(2);
    float widthval = gui.graphX2 - gui.graphX1;
    float heightval = gui.graphY2 - gui.graphY1;
    fill(255);
    //text("Help and Credits",gui.graphX1,gui.graphY1,gui.graphX2,gui.graphY2);
    text("How to use this visualization",xvalHead,yval);
    textAlign(LEFT);
    yval = yval + percentY(8);    
    text("Map - Use multitouch to zoom in/out. Touch on any specific glyph to get more information about it",xval,yval);
    yval = yval + percentY(4);    
    text("    - Touch and drag to pan across locations on the map ",xval,yval);
    yval = yval + percentY(4); 
    text("Tabs - Touch on tabs Crash, Person, Vehicle etc to see the categorised buttons displayed.",xval,yval);
    yval = yval + percentY(4);    
    text("     - Touch on these buttons to see a sub menu appear. These items can be touched to select multiple options",xval,yval);   
    yval = yval + percentY(4);    
    text("Year slider - Touch and move over the slider to choose a range of time period to filter data",xval,yval);
    yval = yval + percentY(4);    
    text("Apply button - After choosing the search criteria in the menus, click this button to apply the filters",xval,yval);
    yval = yval + percentY(8);    
    text("Credits - Pavan Reddy, Richard Stahmer, Venkateswaran Ganesan - UIC",xval,yval);
     yval = yval + percentY(4);    
    text("Data - National Highway Traffic Safety Administration, USA Census, US General Services Administartion",xval,yval);
    popStyle();
  }
  
  public void drawUSMAP()
  {
    float ex1 = chartArea.c.X;//gui.sliderX1;
    float ey1 = gui.graphY1;//gui.sliderY1-percentY(4);
    float ex2 = chartArea.c.X+chartArea.c.plotWidth;//gui.sliderX2;
    float ey2 = gui.graphY2;
    pushStyle();
    fill(#ffffff);
    rect(ex1,ey1,ex2,ey2,4);
    image(usmap,ex1,ey1,ex2-percentX(10),ey2-percentY(10));
    popStyle();
  }
  
  public void drawEventBox()
  {
    println("drawing events:");
    //X + (index * plotWidth/(xmaxValue-xminValue))
    float ex1 = chartArea.c.X;//gui.sliderX1;
    float ey1 = chartArea.c.Y;//gui.sliderY1-percentY(4);
    float ex2 = chartArea.c.X+chartArea.c.plotWidth -percentX(4);//gui.sliderX2;
    float ey2 = chartArea.c.Y+chartArea.c.plotHeight;;//chartArea.c.Y+chartArea.c.plotHeight;//gui.sliderY2-percentY(4);
    
    for(Events event : eventList)
    {
      float x = map(event.year,searchCriteria.currentMinYear,searchCriteria.currentMaxYear,ex1,ex2);
      if(isBoundedByPlot(x,ey2))
      {
        println("Event:"+event);
        pushStyle();
        fill(#ffffff);
        strokeWeight(5);
        stroke(#ffffff);
        float ew = (ex2-ex1)/5;
        float eh = (ey2-ey1)/5;
        rect(x,ey2,x+ew,ey2+eh);
        stroke(#ffffff);
        line(x,ey1,x,ey2);
        textAlign(CENTER,CENTER);
        fill(0);
        //textSize(10);
        text(event.txt,x,ey2,x+ew,ey2+eh);
        popStyle();
      }
    }
  }
  
  boolean isBoundedByPlot(float x, float y){
    float ex1 = chartArea.c.X;//gui.sliderX1;
    float ey1 = chartArea.c.Y;//gui.sliderY1-percentY(4);
    float ex2 = chartArea.c.X+chartArea.c.plotWidth -percentX(4);//gui.sliderX2;
    float ey2 = chartArea.c.Y+chartArea.c.plotHeight;//gui.sliderY2-percentY(4);
    println(ex1+","+ey1+","+ex2+","+ey2);
    println(x+","+y);
    if((x>=ex1) && (x <= ex2) && (y <= ey2) && (y>= ey1))
      return true;
    else
      return false;
  }
}

class BangButton
{
  private float xPos1;
  private float xPos2;
  private float yPos1;
  private float yPos2;
  private float width;
  private float height;
  private String label;
  color basecolor,labelColor_selected;
  
  BangButton(float x, float y, float x2, float y2, String label)
  {
    this.xPos1 = x;
    this.yPos1 = y;
    this.xPos2 = x2;
    this.yPos2 = y2;
    this.label = label;
    this.basecolor = color(#4B443C);
    this.labelColor_selected = color(#F0B30D);
  }
  
  public void draw()
  {
    pushStyle();
    rectMode(CORNERS);
    fill(basecolor);
    rect(xPos1,yPos1,xPos2,yPos2,5);
    textAlign(CENTER,CENTER);
    fill(labelColor_selected);
    text(label,xPos1,yPos1,xPos2,yPos2);
    popStyle();
  }
  
  public boolean touch(float x, float y)
  {
    if ( (x >= xPos1 && x <=xPos2 ) && (y >= yPos1 && y <= yPos2) )
    {
      return true;
    }
    else return false;
  }
}

class Events
{
  String txt;
  int year;
  

  Events(int year,String txt)
  {
    this.year = year;
    this.txt = txt;
  }
}

  
  


