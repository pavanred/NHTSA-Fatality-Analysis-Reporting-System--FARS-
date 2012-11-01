ArrayList<Tab> tabList;
class ControlsTab
{
  float tab1X;
  float tab1Y;
  float tab1W;
  float tab1H;
  float tabwidth;
  float tabLeft;
  float tabRight;
  ArrayList<String> tabNames;
 
  ControlsTab(float x, float y, float w, float h)
  {
    this.tab1X = x;
    this.tab1Y = y;
    this.tab1W = w;
    this.tab1H = h;
    this.tabwidth = this.tab1W/7;
    this.tabLeft = x;
    this.tabRight = x+tab1W;
    tabList = new ArrayList<Tab>();
    

    tabNames = new ArrayList<String>();
    tabNames.add("Person");
    tabNames.add("Vehicle");
    tabNames.add("Crash");
    tabNames.add("External");
    setupTabs();
  }
  
  void setupTabs()
  {
    float currentX=tab1X;
    float currentY=tab1Y;
    for(String tn : tabNames)
    {
      //Tab newTab = new Tab(tn,tn,currentX,tab1Y,tabwidth/3);
      Tab newTab = new Tab(tn,tn,currentX,currentY,tabwidth/3);
      tabList.add(newTab);
      if(tabList.size()==1) //sets the first tab to be active by default
        newTab.selected = true; 
      //currentX = newTab.x2;
      currentY = newTab.y2;
    }
  }
  
  void draw()
  {
    for(Tab t : tabList)
    {
      t.drawTab();
    }    
  }
  
  /*void drawTabs()
  {
    println();
    float currentX=tab1X;
    for(String tn : langDictionary.tabNames.keySet())
    {
      Tab newTab = new Tab(langDictionary.tabNames.get(tn),currentX,tab1Y,tabwidth/4);
      tabList.add(newTab);
      if(tabList.size()==1) //sets the first tab to be active by default
        newTab.selected = true; 
      
      currentX = newTab.x2;
      newTab.drawTab();
    }
  }*/
  
  
  void updateTabs(float mx, float my)
  {
    if (mx > tabLeft && mx < tabRight) 
    {
      for(Tab t : tabList)
      {
        t.updateTab(mx,my);
      }
    }   
  }
}
