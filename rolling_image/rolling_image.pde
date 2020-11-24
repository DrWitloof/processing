// inpired by from https://www.openprocessing.org/sketch/181261 //
// https://timrodenbroeker.de/processing-tutorial-programming-posters/ //
// https://rsms.me/inter/ //

/* @pjs preload="eiffeltoren.jpg"; */

final int nbW = 40;
int imageW, imageH, mode = 1;
float l, theta, i;
float angle = PI/6;
PImage pi;
PGraphics pg;

void setup()
{
  size(1000, 800, P3D);
  noStroke();
  pi = loadImage("eiffeltoren.jpg");
  PVector diagonal1 = new PVector(pi.width/2, pi.height/2);
  diagonal1.rotate(-angle);
  PVector diagonal2 = new PVector(pi.width/2, -pi.height/2);
  diagonal2.rotate(-angle);
  float factor = min(
    min((float) (width/2)/diagonal1.x, 
    (float) (height/2)/diagonal1.y), 
    min((float) (width/2)/diagonal2.x, 
    (float) (-height/2)/diagonal2.y)); // factor to scale to desired final width, after rotation
  pi.resize(int(pi.width*factor), int(pi.height*factor));  
  pg = createGraphics(width, height);
  pg.beginDraw();
  pg.translate(pg.width/2, pg.height/2);
  pg.rotate(angle);
  pg.image(pi, -pi.width/2, -pi.height/2);
  pg.endDraw();
  imageW = pg.width;
  imageH = pg.height;
  l = (float)imageW/nbW;
}

void draw()
{
  background(255);
  push();

  translate(width/2, height/2);
  rotate(-angle);
  translate(-width/2, -height/2);

  PVector prev, curr;
  beginShape(QUAD);
  texture(pg);  
  tint(255, map(mouseX, 0, width, 120, 255));
  theta = 0;
  prev = new PVector(0, 0, 0);
  curr = prev.copy();
  for (i = 0; i < nbW; i ++)
  {
    if (mode == 1 && i>float(mouseX)*nbW/width)
      theta += map(i, 0, nbW-1, PI/15, PI/6);
    else if (mode == 0)
      theta += i*map(mouseX, 0, width, HALF_PI*.6, 0)/nbW;

    curr.x = prev.x + l * cos(theta);
    curr.z = prev.z + l * sin(theta);

    vertex(prev.x, 0, prev.z, i*imageW/nbW, 0);
    vertex(curr.x, 0, curr.z, (i+1)*imageW/nbW, 0);
    vertex(curr.x, imageH, curr.z, (i+1)*imageW/nbW, imageH);
    vertex(prev.x, imageH, prev.z, i*imageW/nbW, imageH);

    prev = curr.copy();
  }
  endShape();
  pop();
}

void mousePressed()
{
  mode = (mode+1)%2;
}
