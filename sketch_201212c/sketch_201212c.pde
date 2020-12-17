PGraphics pg;
PFont font;

PGraphics pg2;

PGraphics buffer;

PImage img;
PImage img2;

int screensize, fontsize;
String tekst = "loop!";

int gridsize = 33;
int flexsize = 20;
float flexspeedfactor = 0.05; 

void setup() {
  size(800, 800, P2D);
  screensize = 500;

  fontsize = int( (screensize) / map(tekst.length(),1,10,1,8));
  println(fontsize);
  font = createFont("RobotoMono-Regular.ttf", fontsize);

  pg = createGraphics(screensize, screensize, P2D);
  pg2 = createGraphics(width, height, P2D);
  
  img = loadImage("panorama-loop-black-rock-canyon-17-1030x243.jpg");
    
  create_pg_image();
}

void draw() {
  background(0);

  //pg.beginDraw();
  //pg.rotate(frameCount);
  //pg.endDraw();
  create_pg_image();
  copy_pg_image();
  
  pushMatrix();
  

  image(pg2,0,0);

  popMatrix();

  
}

void copy_pg_image()
{
  pg2.beginDraw();
  pg2.background(0);

//  pg2.pushMatrix();
  
//  pg2.translate(width/2, height/2);
//  pg2.rotate(frameCount * 0.005);
//  pg2.translate(-width/2, -height/2);
    
  int tilesX = gridsize;
  int tilesY = gridsize;

  int tileW = int(screensize/tilesX);
  int tileH = int(screensize/tilesY);

  for (int y = 0; y < tilesY; y++) {
    for (int x = 0; x < tilesX; x++) {
      
      float square_offset_factor = ((float(tilesX)/2-x) * (float(tilesY)/2-y) ) * 0.1;
      int wave1 = int(sin(frameCount * flexspeedfactor + square_offset_factor) * flexsize);
      int wave2 = int(sin(frameCount * flexspeedfactor + 0.2 + square_offset_factor) * flexsize);

      // SOURCE
      int sx = x*tileW + wave1;      
      int sy = y*tileH + wave2;
      int sw = tileW;
      int sh = tileH;

      // DESTINATION
      int dx = x*tileW;
      int dy = y*tileH;
      int dw = tileW;
      int dh = tileH;
      
      pg2.copy(pg, sx, sy, sw, sh, dx, dy, dw, dh);
    }
  }
  pg2.endDraw();
}

void create_pg_image()
{
  pg.beginDraw();
  pg.background(0);
  pg.fill(255);
  pg.textFont(font);
  pg.textSize(fontsize);
  pg.pushMatrix();
  pg.translate(screensize/2, screensize/2);
  pg.rotate(frameCount * 0.005);
  pg.translate(0, -int(fontsize/4));
  pg.textAlign(CENTER, CENTER);
  pg.text(tekst, 0, 0);
  pg.popMatrix();
  pg.endDraw();
}
