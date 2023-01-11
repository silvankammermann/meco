import processing.sound.*;
SoundFile soundFile;

ArrayList<PImage> images = new ArrayList<PImage>();
ArrayList<PImage> imagesNote = new ArrayList<PImage>();
HashMap<Integer, Float> noteCoords = new HashMap<Integer, Float>();
PImage note;
float t;
int edgeThreshold = 20;

/* This is an example of an "image convolution" using a kernel (small matrix)
 * to analyze and transform a pixel based on the values of its neighbors.
 *
 * This kernel describes a "Laplacian Edge Detector".
 */
float[][] kernel = {{ -1, -1, -1},
                    { -1,  8, -1},
                    { -1, -1, -1}};

void settings()
{
  size(1000, 560);
}

void setup()
{
  
  
  images.add(loadImage("02_landscape.jpg"));
  images.add(loadImage("flower02.png"));
  images.add(loadImage("splash.jpg"));
  
  note = loadImage("musiknote.png");
  note.resize(50, 50);
  for(int i=0; i<images.size(); i++){
    imagesNote.add(note);
  }
  
  soundFile = new SoundFile(this, "BD.wav");
  // selectInput("Select a file to process:", "fileSelected");
  for (int i = 0; i < images.size(); i++) {
    PImage img = images.get(i);
    img.resize(width, height / images.size());
    img = convertToDetectEdges(img);
    convertToBlackAndWhite(img, i);
    img.updatePixels();
    image(img, 0, i * height / images.size());
  }

}

void draw()
{
  t = millis() * 0.1f;
 
  /*
  for (Integer x : noteCoords.keySet()) {
    int imgCount = x / width;
    // if (noteCoords.get((int) (i * width + t)) != null) {
    //   moveNote(imgNote, t, noteCoords.get((int) (i * width + t)));
    // } else {
    //   moveNote(imgNote, t, height / images.size() * (imgCount + 1) - note.height);
    // }
  }/**/  
  
  background(0);
  
  for (int i = 0; i < images.size(); i++) {
    push();
    translate(t, height / images.size() * (i + 1) - note.height);
    image(note, 0, 0);
    pop();
  }
 
}

void moveNote(PImage note, float x, float y) 
{
  push();
  if (note.width + x < width) {
    translate(x, y);
  }
  else {
    translate(width - note.width, y); 
  }
  
  image(note, 0, 0);
  pop();
}
