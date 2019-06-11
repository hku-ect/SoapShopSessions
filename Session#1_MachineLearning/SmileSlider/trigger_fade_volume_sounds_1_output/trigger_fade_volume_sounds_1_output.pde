import processing.sound.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;

// Define the number of music samples 
int numsounds = 5;

SoundFile[] files;

int change = 0;
boolean changed = false;

int lastClass = 0;
int currentClass = 0;

void setup()
{
  size(600, 400);
  oscP5 = new OscP5(this, 12000);

  files = new SoundFile[numsounds];  

  for (int i = 0; i< files.length; i++) {
    println(i);
    files[i] = new SoundFile(this, i + ".mp3");
    files[i].amp(0);
    files[i].loop();
    println("Duration= " + i + files[i].duration() + i + " seconds");
  }
}

void draw()
{
  background(0);
  textSize(64);
  text(currentClass, width/2, height/2);

}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    currentClass = (int) theOscMessage.get(0).floatValue() - 1; // currentclass is Wekinator class minus 1 
    
    if (currentClass != lastClass) { //Only trig if current class is different from last class
      //change = currentClass;
      //changed = true;

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
