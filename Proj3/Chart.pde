class Chart{ 
  
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
  
  float[] dataset = new float[30];
  
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
    
    //dataset = data.toArray(new int[data.size()]);
    
    // test data  
    Random rand = new Random();
    
    for(int i=0;i<10;i++){      
      dataset[i] = (rand.nextFloat()*500);
    }         
    // test data

   yminValue = floor(min(dataset));
   ymaxValue = ceil(max(dataset));  
   
   xminValue = floor(_xminValue);
   xmaxValue = ceil(_xmaxValue);   
  }
  
  void drawChart(int chartType, color c, int xintervals, int yintervals, String _labelx, String _labely, String _title) {  //1 - linechart, 2 - barchart
       
    labely = _labely;
    labelx = _labelx;
    title = _title; 
            
    stroke(255);
    strokeWeight(2 * scaleFactor);
    line(X, Y - percentY(4), X, Y + plotHeight);
    line(X, Y + plotHeight, X + plotWidth + percentX(2), Y + plotHeight);
    
    fill(255);
    textFont(createFont(font, 12 * scaleFactor));
    textAlign(CENTER); 
    
    noFill();
    stroke(c);
    beginShape();
    int difference = ceil(ymaxValue) - floor(yminValue);
    
    int intervals = floor(difference/yintervals);
    
    if(intervals == 0)
      intervals = 1;
    
    for (int val = xminValue, index = 0; val <= xmaxValue; val++, index++) {
        float value = dataset[index];

        float xVal = (plotWidth * index)/(xmaxValue-xminValue); 
        float yVal = (plotHeight * value)/difference;
        
        strokeWeight(2 * scaleFactor);        
        vertex(X + xVal, Y + plotHeight - yVal);        
    }
       
    endShape();
    smooth();
    stroke(255);
    
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
     
     for (int value = xminValue, index = 0; value <= xmaxValue; value++, index++) {
        
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
    
    textFont(createFont(font, 12 * scaleFactor));
    textAlign(RIGHT);    
    text(labelx,X + plotWidth, Y + plotHeight + percentY(10));
    noFill();
  } 

}


