/* Limulo.net
 *
 * License:
 * Creative Commons,
 * Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)
 *
 *
 * 2018-09 
 * Edited by HKU ECT (https://www.hku.nl/OnderzoekEnExpertise/Expertisecentra/ExpertisecentrumCreatieveTechnologie.htm)
 * To listen to OSC messages so the Pong paddles can be controlled with OSC
 */
 
import oscP5.*;
import netP5.*;
import processing.sound.*;

SoundFile[] file;

// Define the number of samples 
int numsounds = 3;

int difficoltaIniziale = 3;

String oscTeam1 = "/wek/player1";
String oscTeam2 = "/wek/player2";

Racchetta racchetta1, racchetta2;
//Counter punteggio1, punteggio2;
int punteggio1, punteggio2;
Ball ball;

OscP5 oscP5;
NetAddress myRemoteLocation;
OscMessage myMessage;

Digit u1, d1, u2, d2;

/////////////////////////////////////////////////////////////////////////////// SETUP
void setup() {
  size(640, 480);
  smooth();
  rectMode(CENTER);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",6000);
  
  racchetta1 = new Racchetta(1, new PVector(width-50, height/2), 20, 60, 7);
  racchetta2 = new Racchetta(2, new PVector(50, height/2), 20, 60, 7);

  
  ball = new Ball(20, 20, difficoltaIniziale);
  
  int dim = 6;
  PVector punteggio1Pos = new PVector(2*width/4 + 60 , 20);
  d1 = new Digit(punteggio1Pos, dim);
  u1 = new Digit(new PVector(punteggio1Pos.x+4*dim+32, punteggio1Pos.y), dim);
  PVector punteggio2Pos = new PVector(  width/4, punteggio1Pos.y);
  d2 = new Digit(punteggio2Pos, dim);
  u2 = new Digit(new PVector(punteggio2Pos.x+4*dim+32, punteggio2Pos.y), dim);
  
   // Create an array of empty soundfiles
  file = new SoundFile[numsounds];
  // paddles
  file[0] = new SoundFile(this,"data/ping_pong_8bit_beeep.wav");
  // bottom / top
  file[1] = new SoundFile(this,"data/ping_pong_8bit_plop.wav");
  // error
  file[2] = new SoundFile(this,"data/ping_pong_8bit_peeeeeep.wav");
  
  
  
}


//////////////////////////////////////////////////////////////////////////////// DRAW
void draw() {
  background(0);

  disegnaReteCentroCampo();

  //pushStyle();
  //textFont(f);
  //textAlign(CENTER);
  //text(punteggio2.get(), width/4, height/4);
  //text(punteggio1.get(), 3*width/4, height/4);
  //popStyle();

  racchetta1.update();
  racchetta1.checkBounds();
  racchetta1.display();

  racchetta2.update();
  racchetta2.checkBounds();
  racchetta2.display();

  ball.update();
  ball.checkCollision(racchetta1);
  ball.checkCollision(racchetta2);
  ball.checkBounds(racchetta1, racchetta2);
  ball.display();
  
  //render del punteggio per il giocatore 1
  int unita   =  racchetta1.punteggio%10;
  int decine  = (racchetta1.punteggio%100) / 10;
  if ( decine > 0)
    d1.draw_digit(decine, 255);
  u1.draw_digit(unita, 255);
  
  //render del punteggio per il giocatore 2
  unita   =  racchetta2.punteggio%10;
  decine  = (racchetta2.punteggio%100) / 10;
  if ( decine > 0)
    d2.draw_digit(decine, 255);
  u2.draw_digit(unita, 255);


  // Display player
  int padding = 60;
  textSize(20);
  textAlign(CENTER);
  text("Player 1",padding,padding/2);
  text("Player 2",width-padding,padding/2);

}

///////////////////////////////////////////////////////////////////////// KEY PRESSED
void keyPressed() {
  
  switch(key) {
  case '1':
    ball.setDifficulty(1);
    break;
  case '2':
    ball.setDifficulty(2);
    break;
  case '3':
    ball.setDifficulty(3);
    break;
  case '4':
    ball.setDifficulty(4);
    break;
  case '5':
    ball.setDifficulty(5);
    break;
  case '6':
    ball.setDifficulty(6);
    break;
  case '7':
    ball.setDifficulty(7);
    break;
  case '8':
    ball.setDifficulty(8);
    break;
  case '9':
    ball.setDifficulty(9);
    break;
  case 'r':
  case 'R':
    int caso = floor(random(1, 3));
    ball.reset( caso );
    println( caso );
  default:
    racchetta1.controlPressed();
    racchetta2.controlPressed();
    break;
  }
}


//////////////////////////////////////////////////////////////////////// KEY RELEASED
void keyReleased() {
  racchetta1.controlReleased();
  racchetta2.controlReleased();
}


/////////////////////////////////////////////////////////// DISEGNA RETE CENTRO CAMPO
void disegnaReteCentroCampo() {
  pushStyle();
  float tile = width/ (25*3);
  float w = tile;
  float h = 2*tile;

  stroke(255);
  fill(255);
  for (int i = 0; i < 25; i++) {
    rect(width/2, tile/2 + i*3*tile+tile, w, h);
  } 
  popStyle();
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+theOscMessage.typetag());
  
  int step = 10;
  
  // Discrete
   if(theOscMessage.checkAddrPattern("/player1")==true){
    // get value convert to paddle position
    int p1 = int(theOscMessage.get(0).floatValue());
    println(p1);
    
    
    if(p1 == 2){
      if(racchetta2.pos.y > 0 || racchetta2.pos.y < height){
        racchetta2.pos.y -= step;
      }
    }
    else if(p1 == 3){
      if(racchetta2.pos.y > 0 || racchetta2.pos.y < height){
        racchetta2.pos.y += step;
      }
    } 
  }
  else if(theOscMessage.checkAddrPattern("/player2")==true){
    // get value convert to paddle position
   int p2 = int(theOscMessage.get(0).floatValue());
   println(p2);
    
    if(p2 == 2){
      if(racchetta1.pos.y > 0 || racchetta1.pos.y < height){
        racchetta1.pos.y -= step;
      }
    }
    else if(p2 == 3){
      if(racchetta1.pos.y > 0 || racchetta1.pos.y < height){
        racchetta1.pos.y += step;
      }
    }
    
    
  }

  // Continous
  /*
  if(theOscMessage.checkAddrPattern("/player1")==true){
    // get value convert to paddle position
    float p1 = theOscMessage.get(0).floatValue();
    racchetta2.pos.y = map(p1,0,1,height,0);
    println("Player1: "+p1);
  }
  else if(theOscMessage.checkAddrPattern("/player2")==true){
    // get value convert to paddle position
    float p2 = theOscMessage.get(0).floatValue();
    racchetta2.pos.y = map(p2,0,1,height,0);
    println("Player2: "+p2);
  }
  */
}
