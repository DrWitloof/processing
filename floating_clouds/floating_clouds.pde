PImage sky;
ArrayList<Cloud> clouds = new ArrayList<Cloud>(); 
PFont f;
float soff = 5000;

void setup()
{
  size(800, 600, P2D);
  frameRate(60);
  rectMode(CENTER);
  noStroke();

  f = createFont("Arial", 16, true); // STEP 2 Create Font

  sky = createImage(width, height, RGB);
  for (int i = 0; i < width; i++)
  {
    for (int j = 0; j < height; j++)
    {
      sky.pixels[i + j * width] = lerpColor(#157ABC, #66B9F0, (float)j/height);
    }
  }

  for ( int i = 0; i < 5; i++) 
  {
    clouds.add(new Cloud(random(width), random(height), new PVector(3*noise(soff), 0)));
    soff += 0.3;
  }
}

void mouseReleased()
{
  clouds.remove(0);
  clouds.add(new Cloud(mouseX, mouseY, new PVector(3*noise(soff), 0)));
  soff += 0.3;
}

void draw()
{
  //background(sky);
  background(#157ABC);

  for ( Cloud c : clouds)
  {
    c.update();
    c.display();
  }

  textFont(f, 30);                  // STEP 3 Specify font to be used
  fill(0);                         // STEP 4 Specify font color 
  text("" + frameRate, 10, 50);
}
