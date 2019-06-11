// --> IMPORTS
import processing.sound.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;

PImage[] smileys;
PVector[] pos ;
PVector targetPos;
boolean lerpPos;

int margin = 40;
int imgSize = 100;
float imgMargin = margin*2.5;

// Define the number of music samples 
int numsounds = 5;

SoundFile[] files;

int change = 0;
boolean changed = false;

int lastClass = 0;
int currentClass = 0;
float lerpAmt = 0;

// --> SETUP
void setup(){
  size(640,480);
  //fullScreen();
  background(0);
  
  frameRate(30);
  
  oscP5 = new OscP5(this, 12000);
  
  pos =new PVector[numsounds];
  pos[0] = new PVector(width/2,height/2);
  pos[1] = new PVector(imgMargin,imgMargin);
  pos[2] = new PVector(imgMargin,height-imgMargin);
  pos[3] = new PVector(width-imgMargin,height-imgMargin);
  pos[4] = new PVector(width-imgMargin,imgMargin);
  
  targetPos = pos[0].copy();
  lerpPos = false;

  
  // load images
  smileys = new PImage[numsounds];
  String[] smileyFiles = {"00_neutral.png","01_angry.png","02_sad.png","03_calm.png","04_happy.png"};
  for(int i=0;i<smileyFiles.length;i++){
    smileys[i] = loadImage(smileyFiles[i]);
  }
  
  
  // load sounds
  files = new SoundFile[numsounds];
  for (int i = 0; i< files.length; i++) {
    println(i);
 //   files[i] = new SoundFile(this, "0.mp3");
    files[i] = new SoundFile(this, i + ".mp3");
    files[i].amp(0);
    files[i].loop();
    println("Duration= " + i + files[i].duration() + i + " seconds");
  }
  
}



// --> DRAW
void draw(){
  background(50);
  imageMode(CENTER);
  
  stroke(255);
  fill(50);
  strokeWeight(4);
  rect(margin,margin,width-(2*margin),height-(2*margin));
  
  for(int i=0;i<smileys.length;i++){
    image(smileys[i],pos[i].x,pos[i].y,imgSize,imgSize);
  }
  
  pushStyle();
  noStroke();
  fill(255,160);
  ellipse(targetPos.x,targetPos.y,imgMargin/2,imgMargin/2);
  stroke(255);
  strokeWeight(4);
  noFill();
  ellipse(targetPos.x,targetPos.y,imgMargin,imgMargin);
  popStyle();
  
  if(lerpPos){
    targetPos.lerp(pos[currentClass], lerpAmt);
    lerpAmt +=0.01;
    
    if(lerpAmt > 0.95){
      lerpPos = false;
      lerpAmt = 0;
      
    }
  }
  
  
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue() - 1; // currentclass is Wekinator class minus 1 
    
    if (currentClass != lastClass) { //Only trig if current class is different from last class
      //change = currentClass;
      //changed = true;
      if(int(currentClass) < pos.length){
        lerpPos = true;
      }

      for (int i = 1; i<files.length; i++) {
        if (currentClass == i) 
        {
          println("if" + i);
          files[i].amp(0.9);
        } else 
        {
          println("else" + i);
          files[i].amp(0);
        }
      }
    }
    lastClass = currentClass;
  }
}
