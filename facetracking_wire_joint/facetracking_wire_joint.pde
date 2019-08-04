import processing.serial.*;       
import gab.opencv.*;
import processing.video.*;
import java.awt.*;

int apos=90; // Servostellungen Initialisieren (0-180);
int bpos=90;
int cpos=90;

int a=0;
int b=0;
int c=0;

int ra=0;
int rb=0;
int rc=0;

Capture video;
OpenCV opencv;
Serial port; 

void setup()
{
  size(1280/10, 960/10);  //Groesse Setup
  frameRate(30);  //Frame Rate
  println(Serial.list()); // COM-ports auflisten
  port = new Serial(this, Serial.list()[2], 19200); //Port kann geändert werden je nach Gerät 
  video = new Capture(this, 1280/10, 960/10);  // Video Setup
  opencv = new OpenCV(this, 1280/10, 960/10);  //Open CV Setup
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  //Verwendete OpenCV Haarcascade 
  video.start();  //Video Start
}

void draw()
{
  opencv.loadImage(video);  //OpenCV in draw laden
  image(video, 0, 0);  //Video draw
  stroke(6,218,237);  //Stroke>1 sonst werden mehrfach gezeichnete dicker als 
  Rectangle[] faces = opencv.detect();
  println(faces.length);  //OpenCV Faces Anzahl
  
  if (faces.length == 0) {
    int a = 85;
    int b = 85;
    int c = 85;
    servo(a, b, c);  //update to servo void

  } else {
      for (int i = 0; i < faces.length; i++) {
      println("X-Face:"+faces[i].x+","+"Y-Face:"+faces[i].y);  //OpenCV Gesichter Positionen
      noFill();
      ellipse(faces[i].x+faces[i].width/2, faces[i].y+faces[i].height/2, faces[i].width, faces[i].height);  //Alle Gesichter markieren
    
      float da = faces[i].y; // distance from half the width and 0 to face(s) 
      float db = faces[i].x; // distance from height and 0 to face(s) 
      float dc = faces[i].x; // distance from width height to face(s) 
      
      int ra = round(da);  //Runden der float Werte zu int
      int rb = round(db);
      int rc = round(dc);
      
      float ma = map(ra, 0, height, 50, 0); //map distances -> servo in floats
      float mb = map(rb, 0, height, 50, 0);  
      float mc = map(rc, 0, height, 0, 50);
    
      int a = round(ma);  
      int b = round(mb);
      int c = round(mc);
      
      servo(a, b, c);  //update to servo void
      }
    }
}

void servo(int a, int b, int c){  
  println("A-Servo:"+a+",B-Servo:"+b+",A-Servo:"+c); //Debug Info Servo
  
  strokeWeight(0);  //Debug Servo Visualisierung
  fill(6,218,237);
  rect(5, 10, a, 3);  
  rect(5, 20, b, 3);  
  rect(5, 30, c, 3);  
  strokeWeight(2);
  
  apos = a; 
  bpos = b;
  cpos = c;
  
  port.write(apos+"a"); //Output Servo Position an Arduino ( from 0 to 180)
  port.write(bpos+"b");
  port.write(cpos+"c");
}

void captureEvent(Capture c) {
  c.read();
}

