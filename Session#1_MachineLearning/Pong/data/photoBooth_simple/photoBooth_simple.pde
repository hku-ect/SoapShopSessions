//Basic sketch showing the basics of building a conditional photo booth for Processing with a input from Wekinator
//
//Train Wekinator in classification mode with two classes:
//Class 1 is neutral and class 2 will trigg the photo booth to take a picture. 


/* combined with 
 a tool for filtering Wekinator classification outputs 
 based on stastical mode https://en.wikipedia.org/wiki/Mode_(statistics)
 
 - Outputs the mode + the relative occurrence of the mode (measured as percentage from 0-100) during windowSize
 - Outputs {-1} if mode is split between two values or mode is less than threshold (0-100 percent)
 
www.andreasrefsgaard.dk - 2018 */

import processing.video.*;
import oscP5.*;
import ddf.minim.*;
import java.util.Calendar;

Minim minim;
AudioSample sound;
OscP5 oscP5;

PFont font;

// VISUALS
movingGrid moving_grid;
MovingLine[] movinglines;

// stats add

//color[] colors = {color(20,25,117), color(103,0,98), color(186,0,91), color(219,22,6), color(255,72,3) };
color[] colors = {color(77,66,80), color(182,110,111), color(207,136,132), color(230,169,114), color(246,209,105) };


int windowSize = 15; //How many of the last outputs from Wekinator should we look at?
int[] outputs = new int[windowSize];
int count = 0;

boolean arrayIsFull = false;

int rawClass; 
float avgClass = 0;
int currentClass = -1;
int currentMode;
int currentPtc;
float threshold = 1.9; // in percentage occurance

// /stats add

// int currentClass; 
int lastClass;

PGraphics pg;
PImage lastSnapShot;


int timer = 0;
int lastSnapShotTimer = 0;
boolean showLatestPhoto = false;
boolean takePhoto = false;

Capture cam;

void setup() {
  //size(640, 480);
  fullScreen(P3D);
  pg = createGraphics(width, height);
  oscP5 = new OscP5(this, 12000);

  minim = new Minim(this);
  sound = minim.loadSample( "shutter.wav", 512);

  String[] cameras = Capture.list();
  //println( Capture.list());
  
  font = loadFont("HKU-Normal-120.vlw");
  textFont(font, 100);

  if (cameras == null) {
    //cam = new Capture(this, 640, 480);
    cam = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    cam = new Capture(this,1024,768, cameras[0]);
    cam.start();
  }
  
  frameRate(30);
  
  


  // SETUP VISUALS
  moving_grid = new movingGrid(new PVector(1,1,0), new PVector(width,height,200),colors[1]);
  
  movinglines = new MovingLine[2];
  movinglines[0] =  new MovingLine(1,random(1.6,3), "VERTICAL",colors[0]);
  movinglines[1] =  new MovingLine(-1,random(3,6), "VERTICAL",colors[0]);
  //movinglines[2] =  new MovingLine(-1,random(0.6,1.2), "VERTICAL",color(54,39,227));
  //movinglines[3] =  new MovingLine(-1,random(0.6,1.2), "HORIZONTAL",color(54,39,227));
}

void draw() {
  background(0);
  
  if (cam.available() == true) {
    cam.read();
  }
  
  // sHOW LAST PHOTO
  if (showLatestPhoto ) {
    
    pg.beginDraw();
    pg.image(lastSnapShot, 0, 0);
    pg.endDraw();
    image(pg, 0, 0);
    
    if(lastSnapShotTimer < 45){
      lastSnapShotTimer ++;
    }
    else
    {
      lastSnapShotTimer=0;
      showLatestPhoto = false;
    }
  }
  else
  {
    image(cam, 0, 0,width,height);
    
    textSize(120);
    text(rawClass, 80, 160);
    
    
    fill(colors[1],100);
    rect(0,height-80,200,80);
    
    fill(colors[4]);
    textSize(16);
    text("raw class: " + rawClass, 10, height-60);
    text("avg class: " + avgClass, 10, height-30);
    
    fill(colors[4],100);
    rect(width-40,0,40,height);
    
    fill(colors[1]);
    float h = map(avgClass,0,2,0,-height);
    rect(width-40,height,40,h);
    
    
    float h1 = map(threshold,0,2,height,0);
    stroke(colors[3]);
    strokeWeight(4);
    line(width-40,h1,width,h1);
  
  
    // DRAW VISUALS
     moving_grid.run(color(255,72,3)); 
    
    for(int i=0;i<movinglines.length;i++)
    {
      movinglines[i].run();
    }
    
    pushStyle();
    fill(colors[4]);
    textSize(100);
    textAlign(CENTER);
    text("SMILE OR ELSE...", width/2, height-130);
    popStyle();
    
    
  
  }
  
  
  
  timer++;
  
  
  // TAKe picture
  if(takePhoto){
    
      timer = 0;
      for(int i=0;i<outputs.length;i++)
      {
        outputs[i] = 0;
      }
      sound.trigger();
      lastSnapShot = get(); 
      showLatestPhoto = true;
      takePhoto = false;
      
      PImage myImage;
      myImage = createImage(cam.width, cam.height, ARGB);
      myImage.copy(cam, 0, 0, cam.width, cam.height, 0, 0, myImage.width, myImage.height);
      //myImage.save("images/portrait_"+timestamp()+ ".jpg");
      myImage.save("/Volumes/fast-style-transfer/dropdir/portrait_"+timestamp()+ ".jpg");
      
  }
  
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
 //   currentClass = (int) theOscMessage.get(0).floatValue();
    rawClass = (int) theOscMessage.get(0).floatValue();
    AddNewValue(rawClass);
    
    // get avg classs
    avgClass = 0;
    for(int i=0;i<outputs.length;i++)
    {
      avgClass += outputs[i];
    }
    avgClass = avgClass/outputs.length;
    
    // Take picture
    if(avgClass > threshold && timer > 60){
      
      takePhoto = true;
      
    }
  }
  
 
}


void AddNewValue(int val)
{
  if (count < outputs.length)
  {
    //array is not full yet
    outputs[count++] = val;
  } else
  {
    arrayIsFull = true;

    //shift all of the values, drop the first one (oldest) 
    for (int i = 0; i < outputs.length-1; i++)
    {
      outputs[i] = outputs[i+1] ;
    }
    //then add the new one
    outputs[outputs.length-1] = val;
  }
}


// timestamp
String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
