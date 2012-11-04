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
      }
      else
      {
        isSelected = true;
        
      }
      return 1;
    }
    return 0;
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
