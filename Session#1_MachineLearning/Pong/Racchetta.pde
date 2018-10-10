class Racchetta {
  PVector pos;
  PVector vel;
  int velMag;
  float w;
  float h;
  float limitBottom;
  float limitTop;
  
  float alfa, beta;
  
  int player;
  
  boolean bMoveUP, bMoveDOWN;
  
  int punteggio;
  
  
  // *** COSTRUTTORE ****************************************************************************
  Racchetta(int player_, PVector pos_, float w_, float h_, int velMag_) {
    player = player_;
    pos = pos_;
    w = w_;
    h = h_;
    vel = new PVector(0, 0);
    velMag = velMag_;
    bMoveUP = false;
    bMoveDOWN = false;
    limitTop = 0.0;
    limitBottom = 0.0;
    alfa = 0.0;
    beta = 0.0;
    punteggio = 0;
  }
  
  // *** UPDATE *********************************************************************************
  void update() {
    
    float A1 = (pos.y - h/2) - 0;
    float A2;
    if (player == 2)
      A2 = width/2 - (pos.x);
    else
      A2 = pos.x - width/2;
    float B1 = height - (pos.y + h/2);
    float B2 = A2;
    alfa = atan(A1 / A2 );
    beta = atan(B1 / B2 );
    //println("giocatore "+player+") angolo alfa = "+int(degrees(alfa))+" angolo beta = "+int(degrees(beta))+"; ");
    
    if(bMoveUP) {
      vel.set(0, -velMag);
    } else if(bMoveDOWN) {
      vel.set(0,  velMag);
    } else {
      vel.set(0, 0);
    }
    pos.add(vel);
    //println("r.vel("+ vel.x +", "+ vel.y +");"); 
    

    
    
  }
  
  // *** DISPLAY ********************************************************************************
  void display() {
    pushStyle();
    strokeWeight(1);
    stroke(255);
    fill(255);
    rect(pos.x, pos.y, w, h);
    
    // contorno e crocera
    //stroke(0, 255, 0, 60);
    //noFill();
    //rect(pos.x, pos.y, w, h);
    //line(pos.x, 0, pos.x, height);
    //line(0, pos.y, width, pos.y);
    
    popStyle();
  }
  
  // *** CONTROL PRESSED ************************************************************************
  void controlPressed() {
    if (player == 1) {
      if (key == CODED) {
        switch(keyCode) {
          case UP:
            bMoveUP = true;
          break;
          case DOWN:
            bMoveDOWN = true;
          break;
          default: 
          break;
        }
      }   
    } 
    
    if (player == 2) {
      switch(key) {
        case 'w':
        case 'W':
          bMoveUP = true;
        break;
        case 's':
        case 'S':
          bMoveDOWN = true;
        break;
        default: 
        break;
      }
    }    
  }
  
  // *** CONTROL RELEASED ***********************************************************************
  void controlReleased() {
    
    if (player == 1) {
      if (key == CODED) {
        switch(keyCode) {
          case UP:
            bMoveUP = false;
          break;
          case DOWN:
            bMoveDOWN = false;
          break;
          default: 
          break;
        }
      }  
    } 
    
    if (player == 2) {
      switch(key) {
        case 'w':
        case 'W':
          bMoveUP = false;
        break;
        case 's':
        case 'S':
          bMoveDOWN = false;
        break;
        default: 
        break;
      }     
    }
  }
  
  
  // *** LIMIT MOVEMENTS ************************************************************************
  void limitMovement(float lt, float lb) {
    limitTop = lt;
    limitBottom = lb;
    //println("top:" + limitTop + "; bottom: "+limitBottom);
  }
   
  // *** CHECK BOUNDS ***************************************************************************
  void checkBounds() {
    if (pos.y - h/2< 0 + limitTop)
      pos.y = 0 + h/2 + limitTop;
           
     if (pos.y + h/2> height - limitBottom)
       pos.y = height - h/2 - limitBottom;
    /*
    if (pos.x - w/2< 0)
      pos.x = 0 + w/2;
            
    if ( pos.x + w/2> width)
      pos.x = width - w/2;
    */
  }


}

