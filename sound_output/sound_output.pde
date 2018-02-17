import processing.sound.*;
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;
SinOsc sine;

SoundFile file;

int called = 0;
float[] last_seen = new float[20];

void setup() {
  
  oscP5 = new OscP5(this, 9000); //listen for OSC messages on port 12000 (Wekinator default)
  
  size(640, 360);
  background(255);
}      

void playSound(float instrumentCode, float amplitude)
{
  if (instrumentCode == 1.0)
  {
    sine = new SinOsc(this);
    sine.play();
    sine.freq(200);
    sine.amp(amplitude);

  }
  else
  {
    sine = new SinOsc(this);
    sine.play();
    sine.freq(800);
    sine.amp(amplitude);
  }
}

float most_seen(float[] seen_msgs) {
  int code_1 = 0;
  int code_2 = 0;
 for (int i = 0; i < seen_msgs.length; i++){
   if (seen_msgs[i] == 1.0){
     code_1 = code_1 + 1;
   }else{
     code_2 = code_2 + 1;
 }
 }
 
 if (code_1 > code_2){
   return 1.0;
 }else{
   return 2.0;
 }
}


//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 if (theOscMessage.checkAddrPattern("/wek/outputs")==true) {
        called = called + 1;
        
        float instrumentCode = theOscMessage.get(0).floatValue();//get this parameter
        float amplitude = theOscMessage.get(1).floatValue();
        last_seen = append(last_seen, instrumentCode);
        //println(theOscMessage.get(1).floatValue());
        if (called % 20 == 0){
          instrumentCode = most_seen(last_seen);
          println(instrumentCode);
         playSound(instrumentCode, amplitude);
         last_seen = new float[20];
        }
        
 }
}

void draw() {
}