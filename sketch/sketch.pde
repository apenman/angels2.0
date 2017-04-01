// Daniel Shiffman
// Depth thresholding example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Original example by Elie Zananiri
// http://www.silentlycrashing.net


// TODO:
// 1. Clean up code
// 2. Use osc to send signal from node webpage to processing to start/save
  //  a. Use js to remove files if save is not clicked
  //  b. Use js to create gif / open in browser

// TODO LATER:
// 1. Reverse colors -- starts white and background fades to black
import controlP5.*;
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
// Depth image
PImage depthImg, testImg;
ControlP5 control;

// Which pixels do we care about?
int minDepth = 0;
int maxDepth = 800;
int counter = 0;
int[] imgColors;
int gifCounter = 0;
int frameCounter = 0;
// What is the kinect's angle
float angle;
boolean isCapturing = false;
boolean isCountingDown = false;
int countDownBuffer = 20;
int countdownStart = 0;

void setup() {
  size(800, 640);
  
  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();
  imgColors = new int[kinect.getRawDepth().length];
  for (int i = 0; i < imgColors.length; i++) {
    imgColors[i] = 255;
  }
  depthImg = new PImage(kinect.width, kinect.height);
  frameRate(20);

  // Set up controls
  control = new ControlP5(this);
  control.addButton("start")
   .setValue(0)
   .setPosition(100,100)
   .setSize(100,19);
   control.addButton("save")
    .setValue(0)
    .setPosition(250,100)
    .setSize(100,19);
   control.setAutoDraw(false);
}

// Button listeners
public void start() {
  println("START THIS");
  startCountdown();
}

public void save() {
  println("SAVE IT");
}

void draw() {
  if (isCountingDown) {
    displayCountdown();
  } else if (isCapturing) {
    //Threshold the depth image
    int[] rawDepth = kinect.getRawDepth();
    for (int i=0; i < rawDepth.length; i++) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        if (imgColors[i] > 0) {
          imgColors[i] -= 5;
        }
        depthImg.pixels[i] = color(imgColors[i]);
      } else {
      }
    }

    //Draw the thresholded image
    depthImg.updatePixels();
    image(depthImg, 0, 0);

    //fill(0);
    //text("TILT: " + angle, 10, 20);
    //text("THRESHOLD: [" + minDepth + ", " + maxDepth + "]", 10, 36);
    counter++;
    if (counter > 100) {
      println("DONE!!!");
      isCapturing = false;
    }

    saveImage();
  } else {
    // Draw the controls
    control.draw();
  }
}

// Adjust the angle and the depth threshold min and max
void keyPressed() {
  if (key == 'c' && !isCapturing && !isCountingDown) {
    startCountdown();
  }
}

// Create gif from command line:
// convert -loop 0 *.jpg myimage.gif
void saveImage() {
  String path = savePath(gifCounter + "/angel" + "_" + String.format ("%05d", frameCounter) + ".jpg");
  frameCounter++;
  // println("SAVING TO: " + path);
  depthImg.save(path);
}

void resetImage() {
  counter = 0;
  gifCounter++;
  frameCounter = 0;
  for (int i = 0; i < imgColors.length; i++) {
    imgColors[i] = 255;
    depthImg.pixels[i] = color(imgColors[i]);
    depthImg.updatePixels();
  }
}

void startCountdown() {
  countdownStart = frameCount;
  isCountingDown = true;
}

void displayCountdown() {
  background(255);
  int elapsed = frameCount - countdownStart;
  fill(0, 102, 153);
  textSize(32);
  if (elapsed < 21) {
    text("3", 10, 30);
  } else if (elapsed < 41) {
    text("2", 10, 30);
  } else if (elapsed < 61) {
    text("1", 10, 30);
  } else {
    background(255);
    isCountingDown = false;
    resetImage();
    isCapturing = true;
  }
}