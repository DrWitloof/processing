
void setup() {
  size(500, 500);
}

void draw() {
  // Before we deal with pixels
  loadPixels();  
  // Loop through every pixel
  for (int i = 0; i < pixels.length; i++) {
    // Pick a random number, 0 to 255
    float r1 = random(255);
    float r2 = random(255);
    float r3 = random(255);
    float r4 = random(255);
    // Create a grayscale color based on random number
    color c = color(r1, r2, r3, r4);
    // Set pixel at that location to random color
    pixels[i] = c;
  }
  // When we are finished dealing with pixels
  updatePixels(); 
}
