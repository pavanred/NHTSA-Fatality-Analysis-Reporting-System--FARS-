

//Consider buttons rather than scrollbar as a faster alternative?
public class ListBox
{
  //for now we'll say it always displays 6 things.
  private int scaleFactor;
  private float xPos1;
  private float xPos2;
  private float yPos1;
  private float yPos2; 
  public ArrayList<String> labels;
  public ArrayList<Boolean> selected;
  private int numButtons = 8;
  public Button[] buttons = new Button[numButtons];
  private float scrollY;
  private int curDisplay;

  public ListBox(float x1, float y1, float x2, float y2, int sF)
  {
    scaleFactor = sF;
    xPos1 = x1*sF;
    yPos1 = y1*sF;
    xPos2 = x2*sF;
    yPos2 = y2*sF;
    scrollY = yPos1+(4*scaleFactor);
    
    //now set up the buttons
    float height = yPos2-yPos1 - (scaleFactor*4);
    
    float temp = height/numButtons;
    
    for (int i = 0; i < numButtons; i++)
      buttons[i] = new Button(x1+4*scaleFactor, y1+(i*temp)+(4*scaleFactor), x2-(4+15)*scaleFactor, y1+((i+1)*temp), 
                          "test" + i, scaleFactor);
    
    curDisplay = 0;
    labels = new ArrayList<String>();
    selected = new ArrayList<Boolean>();
    /*for (int i=0; i<64; i++){
      labels.add("bleh" + i);
      selected.add(false);
    }*/
  }

  public void addItem(String str)
  {
    labels.add(str);
  }

  public void draw()
  {
    fill(64);
    
    rectMode(CORNERS);
    rect(xPos1, yPos1, xPos2, yPos2);
           
    for (int i = 0; i < numButtons; i++)
    {
      buttons[i].label = labels.get(curDisplay+i);
      buttons[i].draw();
    }
    
    fill(128);
    rect(xPos2-(2+15)*scaleFactor, scrollY, xPos2-2*scaleFactor, scrollY+(15*scaleFactor) );
  } 

  // returns string of button touched if the touch coordinates matched, null if not
  // also toggles isSelected on the button if it was touched.
  public String touch(float x, float y)
  {
    if (x >= xPos2-(2+15)*scaleFactor && x <= xPos2-2*scaleFactor &&
        y >= yPos1+(4*scaleFactor) && y <= yPos2-4*scaleFactor){ //touch on scrollbar track
      float trackHeight = yPos2 - yPos1 - (8+15)*scaleFactor;
      float yInc = trackHeight/((labels.size()-numButtons)/numButtons*2);
      for (int i = 0; i<numButtons; i++)
        buttons[i].isSelected = false;
      if (y >= scrollY+15 && y < yPos2 - (4*scaleFactor)){ //touch beneath it
        curDisplay += numButtons/2;
        scrollY += yInc;
      }
      else if (y <= scrollY && y>=yPos1 + (4*scaleFactor)){ //touch above it
        curDisplay -= numButtons/2;
        scrollY -= yInc;
      }
      for (int i = 0; i<numButtons; i++)
       if (selected.get(i+curDisplay))
        buttons[i].isSelected = true;
    }
    
    for (int i = 0; i<numButtons; i++)
      if (buttons[i].touch(x, y) == 1)
      {
        if (selected.get(i)){
          selected.remove(i);
          selected.add(i, false);
        }
        else
        {
          selected.remove(i);
          selected.add(i, true);
        }
        return buttons[i].label;
      }
    
    return null;
  }
  
  public void touchMove(float x, float y)
  {
    if (x >= xPos2-(2+15)*scaleFactor && x <= xPos2-2*scaleFactor &&
        y >= yPos1+(4*scaleFactor) && y <= yPos2-4*scaleFactor){ //touch on scrollbar track
      float trackHeight = yPos2 - yPos1 - (8+15)*scaleFactor;
      float yInc = trackHeight/(labels.size()-numButtons);
      for (int i = 0; i<numButtons; i++)
        buttons[i].isSelected = false;
      if (y >= scrollY+yInc && y <= yPos2 - (4*scaleFactor)){ //touch beneath it
        curDisplay += 1;
        scrollY += yInc;
      }
      else if (y <= scrollY-yInc && y >= yPos1 + (4*scaleFactor)){ //touch above it
        curDisplay -= 1;
        scrollY -= yInc;
      }
    }
    
  }
  
  
  
}
