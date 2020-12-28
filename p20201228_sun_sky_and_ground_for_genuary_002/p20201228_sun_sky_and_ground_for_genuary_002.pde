int o = 15;

void setup()
{
  size( 600, 800);
}

void draw()
{
  background(254, 255, 235);
  noStroke();
  //stroke(0);

  // sky
  fill(color(160, 196, 255, 25));
  for( int i = 1; i<6; i++ ) 
  {
    rect( o, o, width-2*o, i*height / 10);
  }
  
  // land
  fill(color(187, 255, 173, 100));
  
  int landlines = 25;
  float w = float(width-2*o) / (landlines);
  for( int i = 0; i<landlines; i++ ) 
  {
    rect( o + i*w + 1, height - height/2.5, w-2, height/2.5 - o);
  }  
  
  // sun
  
  pushMatrix();
  translate(o + height / 10, o + height / 10);
  rotate(frameCount%3600*TWO_PI/3600);
  
  fill(color(247, 227, 102, 50));
  ellipse( 0, 0, height / 6, height / 6);
  
  int rays = 16, l = 20;
  for( int i = 0; i < rays; i++)
  {
    quad( height/8, - o/2, 
          height/8, + o/2, 
          l*height/8,  + l*o/2, 
          l*height/8,  - l*o/2); 
          
          
    rotate(TWO_PI/rays);
  }
  
  popMatrix();
  
  // cloud  
  randomSeed(0);
  fill(color(249, 246, 240, 100)); 
  
  drawCloud(width/2 + frameCount, height/5, 60);

  // rain  
}

void drawCloud(float x, float y, float w)
{
  if( w < 20) return;
  
  ellipse( (width+x)%width, y, w, w);

  for (int i = 0; i < 2; i++)
  {
    drawCloud(
      x + random(-2.2*w, 2.2*w), 
      y + random(-w/2.2, w/2), 
      max(1.0, w - random(10)));
  }
}
