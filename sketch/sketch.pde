// Daniel Shiffman
// Depth thresholding example

// https://github.com/shiffman/OpenKinect-for-Processing
// http://shiffman.net/p5/kinect/

// Original example by Elie Zananiri
// http://www.silentlycrashing.net
import org.openkinect.freenect.*;
import org.openkinect.processing.*;

Kinect kinect;
// Depth image
PImage depthImg, testImg;

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

void setup() {
  size(800, 640);

  kinect = new Kinect(this);
  kinect.initDepth();
  angle = kinect.getTilt();
  imgColors = new int[kinect.getRawDepth().length];
  for(int i = 0; i < imgColors.length; i++) {
     imgColors[i] = 255;
  }
  depthImg = new PImage(kinect.width, kinect.height);
  frameRate(20);
}


void draw() {
  if(isCapturing) {
     //Threshold the depth image
    int[] rawDepth = kinect.getRawDepth();
    for (int i=0; i < rawDepth.length; i++) {
      if (rawDepth[i] >= minDepth && rawDepth[i] <= maxDepth) {
        if(imgColors[i] > 0) {
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
    if(counter > 100) {
      println("DONE!!!");
      isCapturing = false;
    }

    saveImage();
  }
  else {
  }
}

// Adjust the angle and the depth threshold min and max
void keyPressed() {
  if (key == 'c' && !isCapturing) {
    resetImage();
    isCapturing = true;
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
  for(int i = 0; i < imgColors.length; i++) {
     imgColors[i] = 255;
     depthImg.pixels[i] = color(imgColors[i]);
     depthImg.updatePixels();
  }
}
