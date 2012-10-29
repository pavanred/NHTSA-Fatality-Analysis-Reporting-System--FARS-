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