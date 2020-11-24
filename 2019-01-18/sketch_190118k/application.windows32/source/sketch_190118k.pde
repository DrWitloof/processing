PImage img;       // The source image
int cellsize = 1; // Dimensions of each cell in the grid
int cols, rows;   // Number of columns and rows in our system
int row_offset;

void setup() {
  size(500, 500, P3D); 
  img  = loadImage("P1030284.JPG");
  
  img.resize(500, img.height * 500/img.width);
  
  //img.resize(500,500); // Load the image
  cols = width/cellsize;             // Calculate # of columns
  rows = img.height/cellsize;            // Calculate # of rows
  row_offset = (height/cellsize - rows)/2;
}

void draw() {
  background(0);
  loadPixels();
  // Begin loop for columns
  for ( int i = 0; i < cols;i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows;j++) {
      int x = i*cellsize + cellsize/2; // x position
      int y = j*cellsize + cellsize/2; // y position
      int loc = x + y*width;           // Pixel array location
      color c = img.pixels[loc];       // Grab the color
      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (mouseX/(float)width) * brightness(img.pixels[loc]) * 2 - 200.0;
      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();
      translate(x,row_offset+y,z);
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(0,0,cellsize,cellsize);
      popMatrix();
    }
  }
}
