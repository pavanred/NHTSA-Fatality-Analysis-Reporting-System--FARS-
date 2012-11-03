class BarChart{ 
  
  float X; 
  float Y;
  float Width;
  float Height;
  float marginwl;  //margin width left
  float marginwr;
  float marginht;  //margin height top
  float marginhb;
  
  float plotWidth;
  float plotHeight;
  
  //axis range
  int xminValue;  
  int xmaxValue;
  
  int yminValue;  
  int ymaxValue;
  
  String labelx;
  String labely;
  String title;
  
  float[] dataset;
  int[] xIds; 
  
  String font = "Verdana";

  BarChart(float _x,float _y, float _Width, float _Height, float _marginwl, float _marginwr, float _marginht, float _marginhb){
    
    X = _x + _marginwl;
    Y = _y + _marginht;
    Width = _Width;
    Height = _Height;
    marginwl = _marginwl;
    marginwr = _marginwr;
    marginht = _marginht;
    marginhb = _marginhb;

    plotWidth = Width - marginwl - marginwr;
    plotHeight = Height - marginht - marginhb;

  }
  
  void getData(ArrayList<KeyValue> data){  //integer is discrete x axis id, float is actual value

   dataset = new float[data.size()];
   xIds = new int[data.size()];
   
   for(int index = 0; index < data.size(); index++){
    
    dataset[index] = data.get(index).Value;
    xIds[index] = data.get(index).Key;
     
   }
        
   //Float[] dataset = new Float[]{10.0,20.0,30.0,40.0};
   //int[] xIds = new int[]{0,1,2,3};

   //yminValue = floor(getMinValue(dataset));
   yminValue = 0; // to avoid data misinterpretation   
   ymaxValue = ceil(getMaxValue(dataset)); 
     
  }
  
  void drawChart(color c, int xintervals, int yintervals, String _labelx, String _labely, String _title, float textPadding) {  
       
    float padding = 0;
    
    labely = _labely;
    labelx = _labelx;
    title = _title; 
    
    fill(255);
    textFont(createFont(font, 12 * scaleFactor));
    textAlign(CENTER); 
    
    int difference = ceil(ymaxValue) - floor(yminValue);
    
    int intervals = floor(difference/yintervals);
    
    if(intervals == 0)
      intervals = 1;
      
    padding = (plotWidth/xIds.length);
    
    for (int index = 0; index < xIds.length; index++) {
        
        Float value = dataset[index];

        Float xVal = ((plotWidth * index)/xIds.length);
        Float yVal = (plotHeight * (value - yminValue))/difference;
        stroke(c);
        fill(c);
        strokeWeight(2 * scaleFactor); 
        
        rect(X + xVal + padding/2,Y + plotHeight - yVal,X + xVal + padding,Y + plotHeight);
        
        stroke(255);
        fill(255);
        pushMatrix();
        translate(X + xVal + (padding*0.75), Y + plotHeight + textPadding);
        rotate(radians(-45));
        text ("test",0,0);
        popMatrix();
     
    }
 
   for (int value = floor(yminValue), index = 0; value <= ceil(ymaxValue); value++, index++) {
       
     if (intervals == 0)
       intervals = 1; 
        
      if(index % intervals == 0){

          textFont(createFont(font, 11 * scaleFactor));
          
          if(value == floor(yminValue)){
            textAlign(RIGHT, BOTTOM);
          }
          else
            textAlign(RIGHT, CENTER);
           
          fill(255); 
          stroke(255);
          text(str(value),X - percentX(1), Y + plotHeight - (index * plotHeight/difference));
          
          strokeWeight(2 * scaleFactor);
          line(X,Y + plotHeight - (index * plotHeight/difference),X - percentX(1)/2,Y + plotHeight - (index * plotHeight/difference));
        }
     }   
    
    stroke(255);
    strokeWeight(2 * scaleFactor);
    line(X, Y - percentY(4), X, Y + plotHeight);
    line(X, Y + plotHeight, X + plotWidth + percentX(2), Y + plotHeight);
    
    noStroke();
    noFill();
    
  }   
 
 
   public float getMaxValue(float[] numbers){  
    float maxValue = numbers[0];  
    
    for(int i=1;i < numbers.length;i++){  
      if(numbers[i] > maxValue){  
        maxValue = numbers[i];  
      }  
    }  
      
    return maxValue;  
  }  
    
  public float getMinValue(float[] numbers){  
    float minValue = numbers[0];  
    
    for(int i=1;i<numbers.length;i++){  
      if(numbers[i] < minValue){  
        minValue = numbers[i];  
      }  
    }  
    
    return minValue;  
  }   
}
