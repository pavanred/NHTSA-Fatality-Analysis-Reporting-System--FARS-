ArrayList<Tab> tabList;
Tab selectedTab;
class ControlsTab
{
  float tab1X;
  float tab1Y;
  float tab1W;
  float tab1H;
  float tabwidth;
  float tabLeft;
  float tabRight;
  float tabTop;
  float tabBottom;
  ArrayList<String> tabNames;
 
  ControlsTab(float x, float y, float w, float h)
  {
    this.tab1X = x;
    this.tab1Y = y;
    this.tab1W = w;
    this.tab1H = h;
    this.tabwidth = this.tab1W/7;
    this.tabLeft = x;
    this.tabRight = x+gui.tabW;
    this.tabTop = y;
    tabList = new ArrayList<Tab>();
    tabNames = new ArrayList<String>();
    tabNames.add("Person");
    tabNames.add("Vehicle");
    tabNames.add("Crash");
    tabNames.add("External");
    this.tabBottom = y+gui.tabH*tabNames.size();
    setupTabs();
  }
  
  void setupTabs()
  {
    float currentX=tab1X;
    float currentY=tab1Y;
    for(String tn : tabNames)
    {
      Tab newTab = new Tab(tn,tn,currentX,currentY,tabwidth/3);
      tabList.add(newTab);
      if(tabList.size()==1) //sets the first tab to be active by default
      {
         newTab.selected = true; 
         selectedTab = newTab;
      }
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
  
  void updateTabs(float mx, float my)
  {
    Group selectedGroup = null;
    if(mx>tabLeft && mx<tabRight && my > tabTop && my<tabBottom)
    {
      for(Tab t : tabList)
      {
        t.updateTab(mx,my);
      }
    }
    else //Update the buttons inside the  tab.
    {
      Boolean noneSelected = true;
      for(Group gp : selectedTab.groupLists)
      {
        if(gp.isSelected)
        {
          noneSelected = false;
          selectedGroup = gp;
        }
        //gp.updateGroupButton(mx,my);
      }
      if(noneSelected)
      {
        for(Group gp : selectedTab.groupLists)
        {
          gp.updateGroupButton(mx,my);
        }
      }
      else
      {
        for(Group gp : selectedTab.groupLists)
        {
          gp.updateGroupTileButtons(mx,my);
        }
        if(selectedGroup!=null && selectedGroup.isSelected)
          selectedGroup.updateGroupButton(mx,my);
      }
    }
  }
}
