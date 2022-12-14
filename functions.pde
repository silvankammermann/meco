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

// ##########################################################################################################################################

void convertToBlackAndWhite(PImage img, int imgCount)
{
  //variable to count black pixels in each column
  int whitePixels = 0;
  
  // Loop through every pixel in the image
  for (int x = 1; x < img.width-1; x++) {   // Skip top and bottom edges
  whitePixels = 0;
    for (int y = 1; y < img.height-1; y++) {  // Skip left and right edges
    
    // Determine pixel position / index
      int idx = y*img.width + x;
      
      // Greyscale
      float red = red(img.pixels[idx]); // get green channel value
      float green = green(img.pixels[idx]); // get green channel value
      float blue = blue(img.pixels[idx]); // get green channel value
     
     // If the pixel is black, set it to black
      if (red + green + blue <= 40 * 3) { // 40 * ??? 128
        img.pixels[idx] = color(0,0,0);
      }
      else {
        whitePixels++;
        img.pixels[idx] = color(255,255,255);
      }
   
      
    if (whitePixels > edgeThreshold || imgCount == 1){
      float yPos = 0;
      yPos = height / images.size() * (imgCount + 1) - whitePixels - note.height;
      noteCoords.put((int)width*imgCount+(Integer)x, (float) yPos);
    }
  }
      
    for (int y = img.height-1; y > 0; y--) { 
      // Determine pixel position / index
      int idx = y*img.width + x;
      if (whitePixels>0) {
        img.pixels[idx] = color(0,0,0);
        whitePixels--;
      } else {
         img.pixels[idx] = color(255,255,255);
      }
    }
  }
}

// ##########################################################################################################################################

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    images.add(loadImage(selection.getAbsolutePath()));
  }
}
