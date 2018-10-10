class Ball {
  PVector pos;
  float w;
  float h;
  PVector vel;
  float velMag;
  float initialVelMag = 1.6;
  
  // *** COSTRUTTORE ****************************************************************************
  Ball (float w_, float h_, int level) {
    pos = new PVector(width/2, height/2);
    w = w_;
    h = h_;
    vel = new PVector( 1.0, 0.0 );
    velMag = level * initialVelMag;
    reset(floor(random(2, 3)) );  
  }
  
  void setDifficulty(int level) {
    velMag = level * 0.8;
    //println("difficolta':"+velMag);
    //println(vel.x+" "+vel.y);
  }
    
  // *** UPDATE *********************************************************************************
  void update() {
    pos.add(vel);
  }  
  
  // *** DISPLAY ********************************************************************************
  void display() {
    pushStyle();
    strokeWeight(1);
    stroke(255);
    fill(255);
    rect(pos.x, pos.y, w, h);
    
    // contorno e crocera
    //stroke(255, 0, 0, 60);
    //noFill();
    //rect(pos.x, pos.y, w, h);
    //line(pos.x, 0, pos.x, height);
    //line(0, pos.y, width, pos.y);
    
    popStyle();
  }
  
  
  // *** RESET **********************************************************************************
  void reset(int direction) {
    // è importante che la direzione (1 o 2) 
    // venga passata come argomento perchè è 
    // la palla viene resettata anche quando va fuori
    pos.set(width/2, random( height/3, 2*(height/3)) );
    
    float angle = atan((float)width/ (float)height);
    angle = random(-angle, angle);
    vel.normalize();
    vel.set( cos(angle), sin(angle) );
    vel.setMag(velMag);
    
    if(direction == 1) {
      // giocatore 1 batte
      // la pallina si dirige verso sinistra
      // verso il campo del giocatore 2
      vel.x *= -1;
    } else {
      // giocatore 2 batte
      // la pallina si dirige verso destra
      // verso il campo del giocatore 1
      //vel.x * = 1;
    }
  }
    
  // *** CHECK COLLISION ************************************************************************
  void checkCollision(Racchetta r) {

    float dxMax = w/2 + r.w/2;
    float dyMax = h/2 + r.h/2;
    float K = dyMax/dxMax;
    
    float dx = pos.x - r.pos.x;
    float dy = pos.y - r.pos.y;
    if(dx == 0)
      dx = 0.00001;
    float k = abs(dy/dx);
    
    //println(K + " - " + k);
    r.limitMovement(0, 0);
    
    if(abs(dx) < dxMax && abs(dy) < dyMax) {
      // sta avvenendo una collisione
      if( k >= K ) {
        // collisione da sopra o sotto
        if(dy <= 0) {
          //println("COLLISIONE DA SOPRA su giocatore "+r.player);
          // la palla proviene dall'alto, oppure la racchetta si alza
          r.limitMovement(h, 0);
          pos.y = r.pos.y - dyMax;
          // potrebbe essere che la collisione sia dovuta ad un movimento della 
          // racchetta nella stessa direzione nella quale la palla si sta muovendo. 
          // Se la racchetta si muove più velocemente della palla allora si 
          // verificherà una collisione ma la velocità della palla non dovrà essere 
          // girata.
          if(vel.y >= 0)
            vel.y *= -1;
          //vel.add(r.vel);
          
          file[1].play();
        } else {
          // la palla proviene dal basso, oppure la racchetta si abbassa
          //println("COLLISIONE DA SOTTO su giocatore "+r.player);
          r.limitMovement(0, h);
          pos.y = r.pos.y + dyMax;
          if(vel.y < 0)
            vel.y *= -1;
          //vel.add(r.vel); 
          
          file[1].play();
        }
      } else { // if( k >= K )
        // collisione dai lati
        if(dx <= 0) {
          // la palla proviene si trova a sinistra
          //println("COLLISIONE DA SINISTRA su giocatore "+r.player);
          //println("l'impatto è avvenuto alla distanza "+dy+" dal centro della racchetta");
          
          // ASSEGNO UNA NUOVA POSIZIONE
          pos.x = r.pos.x - dxMax;      
          
          // ASSEGNO UNA NUOVA DIREZIONE
          // se la pallina collide nella metà inferiore della racchetta essa,
          // rimbalzando, si diregerà poi nella metà campo avversario opposta (superiore).
          // viceversa se la pallina rimbalza sull'altra estremità della racchetta.
          float angoloRimbalzo = 0.0;
          if(dy >= 0) {
            // la pallina collide sulla parte laterale inferiore
            //println("\testremità INFERIORE");
            angoloRimbalzo = map(dy, 0, dyMax, 0, -r.alfa);
            
          } else {
            // la pallina collide sulla parte laterale superiore
            //println("\testremità SUPERIORE");
            angoloRimbalzo = map(dy, 0, -dyMax, 0,  r.beta);
            
          }
          //println("\tangolo di rimbalzo: "+degrees(angoloRimbalzo) );
          velMag = vel.mag();
          vel.y = velMag * sin( angoloRimbalzo );
          vel.x = velMag * -cos( angoloRimbalzo );
          //println("\t"+vel.x + " " + vel.y);
          
          /*
          // come modificare la velocità della pallina
          PVector tmpV = r.vel;
          tmpV.normalize();
          tmpV.mult(0.8);
          vel.add(tmpV);
          vel.x *= -1;
          */
          
          file[0].play();
          
        } else {
          // la palla proviene si trova a destra
          //println("COLLISIONE DA DESTRA su giocatore "+r.player);
          //println("l'impatto è avvenuto alla distanza "+dy+" dal centro della racchetta");
          
          // ASSEGNO UNA NUOVA POSIZIONE
          pos.x = r.pos.x + dxMax;    
          
          // ASSEGNO UNA NUOVA DIREZIONE
          float angoloRimbalzo = 0.0;
          if(dy >= 0) {
            // la pallina collide sulla parte laterale inferiore
            //println("\testremità INFERIORE");
            angoloRimbalzo = map(dy, 0, dyMax, 0, -r.alfa);
            
          } else {
            // la pallina collide sulla parte laterale superiore
            //println("\testremità SUPERIORE");
            angoloRimbalzo = map(dy, 0, -dyMax, 0, r.beta);
            
          }
          //println("\tangolo di rimbalzo: "+degrees(angoloRimbalzo) );
          velMag = vel.mag();
          vel.y = velMag * sin( angoloRimbalzo );
          vel.x = velMag * cos( angoloRimbalzo );
          //println("\t"+vel.x + " " + vel.y);
                   
          /*
          // come modificare la velocità della pallina
          PVector tmpV = r.vel;
          tmpV.normalize();
          tmpV.mult(0.8);
          vel.add(tmpV);
          vel.x *= -1;
          */
          
          file[0].play();
          
        } 
        // emetti suono
        myMessage = new OscMessage("/impatto/paletta");
        myMessage.add("bang"); /* add an int to the osc message */
        oscP5.send(myMessage, myRemoteLocation); // send the message 
        
      }
    }
  }
  
  // *** CHECK BOUNDS ***************************************************************************
  void checkBounds(Racchetta r1_, Racchetta r2_) {
    if(pos.y-h/2 < 0 ) {
      // la pallina tocca il soffitto
      pos.y = h/2;
      vel.y *= -1;
      //emetti suono
      myMessage = new OscMessage("/impatto/bordo");
      myMessage.add("bang"); /* add an int to the osc message */
      oscP5.send(myMessage, myRemoteLocation); // send the message
      
      file[1].play();
    } else if(pos.y+h/2>height) {
      // la pallina tocca il suolo
      pos.y = height-h/2;
      vel.y *= -1;
      //emetti suono
      myMessage = new OscMessage("/impatto/bordo");
      myMessage.add("bang"); /* add an int to the osc message */
      oscP5.send(myMessage, myRemoteLocation); // send the message
      
      file[1].play();
      
    } else if (pos.x+w/2 > width){
      // campo lato giocatore 1
      // la palla esce fuori campo
      // - il giocatore 2 fa punto
      // - il giocatore 2 che deve battere
      
      //emetti suono
      myMessage = new OscMessage("/fuori");
      myMessage.add("bang"); /* add an int to the osc message */
      oscP5.send(myMessage, myRemoteLocation); // send the message
      
      file[2].play();
      
      r2_.punteggio ++;
      reset(2);
      //pos.x = width-w/2;
      //vel.x *= -1;
    } if (pos.x+w/2 < 0 ) {
      // campo lato giocatore 2
      // la palla esce fuori campo
      // - il giocatore 1 fa punto
      // - il giocatore 1 che deve battere
      
      //emetti suono
      myMessage = new OscMessage("/fuori");
      myMessage.add("bang"); /* add an int to the osc message */
      oscP5.send(myMessage, myRemoteLocation); // send the message
      
      file[2].play();
      
      r1_.punteggio ++;
      reset(1);
    }
    
  }
  
  
}
