class Chart{ 
  
  Float X; 
  Float Y;
  Float Width;
  Float Height;
  Float marginwl;  //margin width left
  Float marginwr;
  Float marginht;  //margin height top
  Float marginhb;
  
  Float plotWidth;
  Float plotHeight;
  
  //axis range
  int xminValue;  
  int xmaxValue;
  
  int yminValue;  
  int ymaxValue;
  
  String labelx;
  String labely;
  String title;
  
  Float[] dataset;// = new Float[30];
  
  String font = "Verdana";

  Chart(float _x,float _y, float _Width, float _Height, float _marginwl, float _marginwr, float _marginht, float _marginhb){
    
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

  void getData(ArrayList<Float> data, float _xminValue, float _xmaxValue){
    
    dataset = new Float[data.size()];
    dataset = data.toArray(new Float[data.size()]);
   
    // test data  
    /*dataset = new Float[10];
    Random rand = new Random();
    
    for(int i=0;i<10;i++){      
      dataset[i] = (rand.nextFloat()*500);
    } */        
    // test data

   xminValue = floor(getMinValue(dataset));
   ymaxValue = ceil(getMaxValue(dataset));  
   
   xminValue = floor(_xminValue);
   xmaxValue = ceil(_xmaxValue);   
  }
  
  void drawChart(int chartType, color c, int xintervals, int yintervals, String _labelx, String _labely, String _title) {  //1 - linechart, 2 - barchart
       
    labely = _labely;
    labelx = _labelx;
    title = _title; 
            
    stroke(255);
    strokeWeight(2 * scaleFactor);
    //line(X, Y - percentY(4), X, Y + plotHeight);
    //line(X, Y + plotHeight, X + plotWidth + percentX(2), Y + plotHeight);
    
    fill(255);
    textFont(createFont(font, 12 * scaleFactor));
    textAlign(CENTER); 
    
    fill(c);
    stroke(c);
    beginShape();
    
    vertex(X,Y + plotHeight);
    
    int difference = ceil(ymaxValue) - floor(yminValue);
    
    int intervals = floor(difference/yintervals);
    
    if(intervals == 0)
      intervals = 1;
      
    float finalXVal = X;
    
    for (int val = xminValue, index = 0; val < xmaxValue; val++, index++) {
        Float value = dataset[index];

        Float xVal = (plotWidth * index)/(xmaxValue-xminValue); 
        Float yVal = (plotHeight * value)/difference;
        
        strokeWeight(2 * scaleFactor);        
        vertex(X + xVal, Y + plotHeight - yVal); 
        point(X + xVal, Y + plotHeight - yVal);
        finalXVal = xVal;
        //println(xVal +" , "+ yVal);  
    }
       
    vertex(X + finalXVal,Y + plotHeight);
    
    endShape();
    smooth();
    stroke(255);
    
    //axis
    
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
           
          text(str(value),X - percentX(1), Y + plotHeight - (index * plotHeight/difference));
          
          strokeWeight(2 * scaleFactor);
          line(X,Y + plotHeight - (index * plotHeight/difference),X - percentX(1)/2,Y + plotHeight - (index * plotHeight/difference));
        }
     }
     
     textFont(createFont(font, 12 * scaleFactor));
      
     text(labely,X - marginwl/4, Y - marginht*2); 
          
     intervals = (xmaxValue-xminValue)/xintervals;
     
     if (intervals == 0)
       intervals = 1;
     
     for (int value = xminValue, index = 0; value < xmaxValue; value++, index++) {
        
        if(index % intervals == 0){

          stroke(255);
          textFont(createFont(font, 11 * scaleFactor));
          textAlign(CENTER, TOP);
          text(str(value),X + (index * plotWidth/(xmaxValue-xminValue)),Y + plotHeight + percentY(3));
          //println(plotWidth);
          
          strokeWeight(2 * scaleFactor);
          line(X + (index * plotWidth/(xmaxValue-xminValue)),Y + plotHeight,X + (index * plotWidth/(xmaxValue-xminValue)),Y + plotHeight + percentY(3));    
    
            if(value > xminValue){
            stroke(#545454);
            strokeWeight(1 * scaleFactor);
            line(X + (index * plotWidth/(xmaxValue-xminValue)),Y + plotHeight,X + (index * plotWidth/(xmaxValue-xminValue)),Y - percentY(5));
          }      
          
        }
     }
     
    stroke(255);
    strokeWeight(2 * scaleFactor);
    line(X, Y - percentY(4), X, Y + plotHeight);
    line(X, Y + plotHeight, X + plotWidth + percentX(1), Y + plotHeight);
    noStroke();
    
    textFont(createFont(font, 12 * scaleFactor));
    textAlign(RIGHT);    
    text(labelx,X + plotWidth, Y + plotHeight + percentY(10));
    noFill();
  } 
  
  
  public Float getMaxValue(Float[] numbers){  
  Float maxValue = numbers[0];  
  
  for(int i=1;i < numbers.length;i++){  
    if(numbers[i] > maxValue){  
      maxValue = numbers[i];  
    }  
  }  
    
  return maxValue;  
}  
  
public Float getMinValue(Float[] numbers){  
  Float minValue = numbers[0];  
  
  for(int i=1;i<numbers.length;i++){  
    if(numbers[i] < minValue){  
      minValue = numbers[i];  
    }  
  }  
  
  return minValue;  
}  

}


