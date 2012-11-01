class Tab
{
  String name;
  String label;
  float x,y,x2,y2,padding;
  float tab1w,tab1y;
  Boolean selected = false;
  color highlightcolor,basecolor,currentcolor,labelColor_unselected,labelColor_selected;
  boolean firstPage = true;
  int pageCount = 0;
  Tab(String name, String label, float x, float y,float padding)
  {
    this.label = label;
    this.name = name;
    this.x = x;
    this.y = y;
    this.padding = padding;
    this.tab1w = x+textWidth("External")+padding; //Taking the width of the word "External" because that is the longest tab name among all tab names.
    //this.tab1y = y+textAscent()+textDescent()+textDescent()*0.5;
    if(gui==null)
      println("gui is nul;;");
    this.tab1y = y+gui.tabH;
    this.x2=this.tab1w;
    this.y2=this.tab1y;
    this.highlightcolor = color(#3B3630);
    this.basecolor = color(#4B443C);
    this.currentcolor = basecolor;
    this.labelColor_unselected = color(255);
    this.labelColor_selected = color(#F0B30D);
    //currentTab = "genre";
    
    //setupTabContents(gui.controlsX1, gui.controlsY1,gui.controlsX1+gui.tabW, gui.controlsY1+gui.tabH);
  }
  
  //Setup stuff for all tabs before drawing
  void setupTabContents(float tx1, float ty1, float tx2, float ty2)
  {
    //println("setting up tab contents");      
    
    
  }
  
  
  void drawTab()
  {
    //noStroke();
    pushStyle();
    //stroke(24);
    fill(currentcolor);
    rect(x,y,tab1w,tab1y);
    popStyle();
    textAlign(CENTER,CENTER);
    pushStyle();
    strokeWeight(5);
    if(selected)
    {
      pushStyle();
      fill(labelColor_selected);
      text(label+" >",(x+(tab1w))/2,(y+tab1y)/2);
      popStyle();
    }
    else
    {
      pushStyle();
      fill(labelColor_unselected);
      text(label,(x+(tab1w))/2,(y+tab1y)/2);
      popStyle();
    }
    popStyle();
  }
  
  void updateTab(float mx, float my)
  {
    if(mx>x && mx<x2 && my>y && my<tab1y)
    {
      currentcolor = highlightcolor;
      currentTab = name;
      selected = true;
    }
    else
    {
      currentcolor = basecolor;
      selected = false;
    }
  }
  
  
  
  // Method that draws contents for different tabs like Genre, Format etc...
//  void drawTabContents(float tx1, float ty1, float tx2, float ty2)
//  {
//    if(name.contains("genre")  && currentTab.contains("genre")) // draw Genre contents
//    {
//      int startC, endC;
//      startC = 12*pageCount;
//      endC = 12+12*pageCount;
//      for(GenreButtons g : genreButtons)
//      {
//        g.visible = false;
//      }
//      for(int i=startC; i<endC && i<genreList.size(); i++)
//      {
//        genreButtons.get(i).drawButton();
//        genreButtons.get(i).visible = true;
//      }
//    }    
//  }
}
