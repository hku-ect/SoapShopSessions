class movingGrid {

  // --> VARS
  PVector pos;
  PVector size;
  int step = 100;
  int rows,collumns,numPoints;
  color col;
  
  PVector[] points;
  float[] alphaValues;
  float[] dotValues;

  // --> CONSTRUCTOR
  movingGrid(PVector _pos, PVector _size, color _col) {
    pos = _pos.copy();
    size = _size.copy();
    col = _col;
    rows = 1+ceil(size.y / step);
    collumns = 1+ceil(size.x / step);
    numPoints = rows * collumns;
    
    println(rows,collumns,numPoints);
    
    points = new PVector[numPoints];
    alphaValues = new float[numPoints];
    dotValues = new float[numPoints];
    
    for (int c = 0; c < collumns; c+=1)
    {
      for (int r = 0; r < rows; r+=1)
      {
        int loc = c + r * collumns;
        float x = pos.x + c*step;
        float y = pos.y + r*step;
        points[loc] = new PVector(x,y);
        alphaValues[loc] = random(20,255);
        dotValues[loc] = random(0,1);
      }
        
    }
  }


  // --> METHOD 
  void display(color col) {

    
   
    for(int i=0;i<points.length;i++)
    {
      float w = map(dotValues[i],0,1,30,70);
      //float a = map(dotValues[i],0,1,10,40);
      stroke(col,30);
      strokeWeight(w);
      
      point(points[i].x,points[i].y); 
    }
  }
  
  void display1(){
    
    strokeWeight(3);
   
    for(int i=0;i<points.length;i++)
    {
      stroke(col,alphaValues[i]);
      // X
      line(points[i].x-step/2,points[i].y,points[i].x+step/2,points[i].y);
      // Y
      line(points[i].x,points[i].y-step/2,points[i].x,points[i].y+step/2);
    }
  }

  void update()
  {
    for(int i=0;i<points.length;i++)
    {
      float b = noise(i,frameCount/20.0);
      alphaValues[i] = map(b,0,1,0,255);
      
      float a = sin(i/10+frameCount/100);
      dotValues[i] = map(a,-1,1,0,1);
    }
  }

  void run(color col) {

    update();
    
    display1();
    display(col);
  }
}



/*******************************************
 --> MovingLine
 *******************************************/
class MovingLine {

  // --> VARS
  PVector pos;
  float speed;
  int direction;
  String type;  // HORIZONTAL / VERTICAL
  color col;

  // --> CONSTRUcTOR
  MovingLine(int _direction, float _speed, String _type, color _col) {
    direction = _direction;
    pos = new PVector(0, 0);
    type = _type;
    speed = _speed;
    col = _col;

    if (direction == -1 && type.equals("HORIZONTAL") == true ) {
      pos.y = height;
      speed *= -1;
    }

    if (direction == -1 && type.equals("VERTICAL") == true) {
      pos.x = width;
      speed *= -1;
    }
  }

  // --> METHODS
  void update() {
    //println(type, pos.x, pos.y);

    if (type.equals("HORIZONTAL"))
    {
      if (direction == 1 && pos.y > height) {
        pos.y = 0;
      } else if (direction == -1 && pos.y < 0) {
        pos.y = height;
      } else {
        pos.y += speed;
      }
    }

    if (type.equals("VERTICAL")) {
      if (direction == 1 && pos.x > width) {
        pos.x = 0;
      } else if (direction == -1 && pos.x < 0) {
        pos.x = width;
      } else
      {
        pos.x += speed;
      }
    }
  }

 
  void mulitLine(int num) {
    stroke(255);
    strokeWeight(1);
    
    for (int i=0; i<num; i++)
    {
      float a =0;
      if(direction == 1){
        a= map(i,0,num,0,255);
      }else{
        a= map(i,0,num,255,0);
      }
      
      stroke(col,a);
      if (type.equals("HORIZONTAL"))
      {
         line(0, pos.y+i, width, pos.y+i);
      } 
      else if (type.equals("VERTICAL"))
      {
        line(pos.x+i, 0, pos.x+i, height);
      }
    }
  }

  void display() {
    stroke(col);
    strokeWeight(2);
    if (type.equals("HORIZONTAL"))
    {
      line(0, pos.y, width, pos.y);
    } else if (type.equals("VERTICAL"))
    {
      line(pos.x, 0, pos.x, height);
    }
  }

  void run() {
    update();
    //display();
    mulitLine(100);
  }
}
