PImage img_1;
PImage img_2;
PImage img_3;
color colResult;
 boolean i=true;

/*This is an example of an "image convolution" using a kernel (small matrix)
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
  img_1 = loadImage("02_landscape.jpg");
  img_2=loadImage("flower02.png");
  img_3=loadImage("splash.jpg");
  
} 

PImage convertToDetectEdges(PImage image)
{
  PImage grayImg = image.copy();
  //change color to greyscale
  grayImg.filter(GRAY);
  
  // Create an opaque image of the same size as the original
  PImage edgeImg = createImage(grayImg.width, grayImg.height, RGB);
  
  // Loop through every pixel in the image
  for (int y = 1; y < grayImg.height-1; y++) {   // Skip top and bottom edges
    for (int x = 1; x < grayImg.width-1; x++) {  // Skip left and right edges
  
      // Starting from zero will show only high edges on black.
      float sum = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          // Calculate the adjacent pixel for this kernel point
          int pos1 = (y + ky)*grayImg.width + (x + kx);

          // Image is grayscale, red/green/blue are identical
          float val = blue(grayImg.pixels[pos1]);
          // Multiply adjacent pixels based on the kernel values
          sum += kernel[ky+1][kx+1] * val;
        }
      }
      // For this pixel in the new image, set the output value
      // based on the sum from the kernel
      edgeImg.pixels[y*edgeImg.width + x] = color(sum);
    }
  }
  
  return edgeImg;
}

void countBlackPixels(PImage grayImg)
{
  //variable to count black pixels in each column
  int blackPixels = 0;
  
  // Loop through every pixel in the image
  for (int x = 1; x < grayImg.width-1; x++) {   // Skip top and bottom edges
  blackPixels = 0;
    for (int y = 1; y < grayImg.height-1; y++) {  // Skip left and right edges
    
    // Determine pixel position / index
      int idx = y*grayImg.width + x;
      
      // Greyscale
      float red = red(grayImg.pixels[idx]); // get green channel value
      float green = green(grayImg.pixels[idx]); // get green channel value
      float blue = blue(grayImg.pixels[idx]); // get green channel value
     
      if(red==0 && green ==0 && blue==0){
        blackPixels++;
      }
    }
    
    for (int y = grayImg.height-1; y > 0; y--) { 
      // Determine pixel position / index
      int idx = y*grayImg.width + x;
       if(blackPixels>0){
         grayImg.pixels[idx] = color(0,0,0);
         blackPixels--;
       }else{
         grayImg.pixels[idx] = color(255,255,255);
       }
    }
  }
}


void draw()
{
  if(i){
    i=false;
    img_1.resize(width, height/3);
    img_2.resize(width, height/3);
    img_3.resize(width, height/3);
    
    img_1=convertToDetectEdges(img_1);
    img_2=convertToDetectEdges(img_2);
    img_3=convertToDetectEdges(img_3);
    
    
    countBlackPixels(img_1);
    countBlackPixels(img_2);
    countBlackPixels(img_3);
    
    
    img_1.updatePixels();
    img_2.updatePixels();
    img_3.updatePixels();
    
    // Display the images at positions (0,0)
    image(img_1, 0, 0); 
    image(img_2, 0, height/3);
    image(img_3, 0, height*2/3);
  }
  

}
