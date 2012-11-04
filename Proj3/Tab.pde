HashMap<String,String> selectedFilters = new HashMap<String,String>();
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
  ArrayList<Group> groupLists;
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
    groupLists = new ArrayList<Group>();
    setupTabContents(gui.controlsX1+gui.tabW, gui.controlsY1,gui.controlsX2, gui.controlsY2);
  }
  
  //Setup stuff for all tabs before drawing
  void setupTabContents(float tx1, float ty1, float tx2, float ty2)
  {
    println("Tab::"+name);
    if(name=="Person")
    {
      float tcx1 = x+tab1w;
      float tcy1 = y;
      float tcx2 = tab1w+tab1w;
      float tcy2 = tab1y;
      
      Group nG1 = new Group("Age", tcx1, tcy1, tcx2, tcy2, bimap.getAgeBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      Group nG2 = new Group("Alcohol", tcx1, tcy1, tcx2, tcy2, bimap.getAlcoholBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      Group nG3 = new Group("Sex", tcx1, tcy1, tcx2, tcy2, bimap.getSexBimap());
      groupLists.add(nG1);
      //nG1.isSelected = true;
      groupLists.add(nG2);
      groupLists.add(nG3);
    }
    
    else if(name=="Vehicle")
    {
      float tcx1 = tabList.get(0).x+tab1w;
      float tcy1 = tabList.get(0).y;
      float tcx2 = tabList.get(0).tab1w+tabList.get(0).tab1w;
      float tcy2 = tabList.get(0).tab1y;
      
      Group nG1 = new Group("Vehicle Type", tcx1, tcy1, tcx2, tcy2, bimap.getVehicleBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      Group nG2 = new Group("Speed", tcx1, tcy1, tcx2, tcy2, bimap.getSpeedBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      groupLists.add(nG1);
      //nG1.isSelected = true;
      groupLists.add(nG2);
      
    }
    
    else if(name=="Crash")
    {
      float tcx1 = tabList.get(0).x+tab1w;
      float tcy1 = tabList.get(0).y;
      float tcx2 = tabList.get(0).tab1w+tabList.get(0).tab1w;
      float tcy2 = tabList.get(0).tab1y;
      
      Group nG1 = new Group("Day", tcx1, tcy1, tcx2, tcy2, bimap.getDayBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      Group nG2 = new Group("Month", tcx1, tcy1, tcx2, tcy2, bimap.getMonthBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      Group nG3 = new Group("Hour of Day", tcx1, tcy1, tcx2, tcy2, bimap.getHourOfDayBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      
      groupLists.add(nG1);
      groupLists.add(nG2);
      groupLists.add(nG3);
    }
    
    else if(name=="External")
    {
      float tcx1 = tabList.get(0).x+tab1w;
      float tcy1 = tabList.get(0).y;
      float tcx2 = tabList.get(0).tab1w+tabList.get(0).tab1w;
      float tcy2 = tabList.get(0).tab1y;
      
      Group nG1 = new Group("Weather", tcx1, tcy1, tcx2, tcy2, bimap.getWeatherBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      Group nG2 = new Group("Light Condition", tcx1, tcy1, tcx2, tcy2, bimap.getLightBimap());
      tcx1 += tab1w;
      tcx2 += tab1w;
      
      groupLists.add(nG1);
      groupLists.add(nG2);
    }
  }
  
  void drawTabContents()
  {
    for(int i=groupLists.size()-1; i>=0; i--)
    {
      groupLists.get(i).draw();
    }
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
      drawTabContents();
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
      selectedTab = this;
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
//      
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

class Group
{
  float gx1,gx2,gy1,gy2;
  String name;
  int value;
  BiMap<Integer,String> itemsList;
  Boolean isSelected = false;
  color highlightcolor,basecolor,currentcolor,labelColor_unselected,labelColor_selected;
  ArrayList<TileButton> tb;
  TileButton selectedTileButton;
  
  Group(String groupName, float gx1, float gy1, float gx2, float gy2,BiMap<Integer,String> itemsList)
  {
    this.name = groupName;
    this.gx1 = gx1;
    this.gy1 = gy1;
    this.gx2 = gx2;
    this.gy2 = gy2;
    this.itemsList = itemsList;
    this.highlightcolor = color(#3B3630);
    this.basecolor = color(#4B443C);
    this.currentcolor = basecolor;
    this.labelColor_unselected = color(255);
    this.labelColor_selected = color(#F0B30D);
    tb = new ArrayList<TileButton>();
    this.value = bimap.getFiltersBimap().get(name);
    setup();
  }
  
  void setup()
  {
      float itemWidth = gx2-gx1;
      float currentX = gx1 + (gx2-gx1);
      int itemCountHalf = itemsList.size()/2;
      float itemHeight = (gy2-gy1)/2;
      float currentY = gy1-(itemHeight*itemCountHalf);    
      for(Integer item : itemsList.keySet())
      {
        TileButton b = new TileButton(currentX,currentY,currentX+itemWidth,currentY+itemHeight,itemsList.get(item));
        b.value = item;
        tb.add(b);
        currentY += itemHeight;
      }
  }
  
  void draw()
  {
    pushStyle();
    fill(this.basecolor);
    strokeWeight(1);
    rect(gx1,gy1,gx2,gy2);
    if(isSelected)
      fill(this.labelColor_selected);
    else
      fill(this.labelColor_unselected);
    text(name,gx1,gy1,gx2,gy2);
    if(isSelected)
    {
      for(TileButton b : tb)
      {
        b.draw();
      }
    }
    popStyle();
  }
  
  void updateGroupButton(float mx, float my)
  {
    if(mx>gx1 && mx<gx2 && my>gy1 && my<gy2)
    {
      currentcolor = highlightcolor;
      currentTab = name;
      if(!isSelected)
      {
        isSelected = true;
        searchCriteria.setSelectedButton(bimap.getFiltersBimap().get(name));
      }
      else
        isSelected = false;
    }
    else
    {
      currentcolor = basecolor;
      isSelected = false;
    }
  }

  void updateGroupTileButtons(float mx, float my)
  {
    for(TileButton tileButton : tb)
    {
      if(tileButton.touch(mx,my)==1)
      {
        selectedTileButton = tileButton;
        println("tileButton::"+tileButton.label);
        HashMap<Integer,ArrayList<Integer>> f = searchCriteria.searchFilter;
        if(f.containsKey(value))
        {
          ArrayList<Integer> l = f.get(value);
          l.add(tileButton.value);
        }
        else
        {
          ArrayList<Integer> l = new ArrayList<Integer>();
          l.add(tileButton.value);
          f.put(value,l);
        }
      }
    }
    println("searchCriteria.searchFilter::"+searchCriteria.searchFilter);    
  }
}
