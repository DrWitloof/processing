int cols, rows;
int w, h;

int hoogte = 150;
float delta = 0.1;

int wterrain = 2000, hterrain = 2000;
int scl = 20;
float[][] terrain;
float flying;

color fill_color_from = color(0);//color(50, 168, 74);
color green = color(50, 168, 74);//color(3, 59, 14);
color white = color(255);
color black = color(0);  
color brown = color(143, 85, 20);
color line_color = color(255);
color back_color = color(102, 185, 240); //color(5, 215, 242);

ArrayList<Cloud> clouds = new ArrayList<Cloud>();
Sun sun;

void setup()
{
  size( 600, 600, P3D);
  
  w = width;
  h = height;
  
  

  cols = wterrain/scl;
  rows = hterrain/scl;

  terrain = new float[cols][rows];
  
  for ( int i = 0; i < 2; i++) 
  {
    PVector position = new PVector( random(width), noise(random(1))*height*1/2),
            speed = new PVector(4*noise(random(i)), 0);
    //println("position " + position);
    //println("speed " + speed);
    clouds.add(new Cloud( position, speed));
  }
  sun = new Sun(new PVector(height/10,height/10),(int)3*height/10,color(255, 247, 0, 80));
  
  textSize(18);
}

void draw()
{

  background(back_color);
  //---- HUD

  flying -= delta;

  float offy = flying;
  for ( int y=0; y<rows-1; y++) {
    float offx = 0;
    for ( int x=0; x<cols; x++) {
      terrain[x][y] = map( noise(offx, offy), 0, 1, -hoogte, hoogte);
      offx += delta;
    }
    offy += delta;
  }


  translate(width/2, height/2);
  rotateX(160*PI/360);

  // color : 50, 168, 74

  translate(-cols*scl/2, -rows*scl/2-200);
  for ( int y=0; y<rows-1; y++) {
    stroke(line_color);
    //noStroke();
//    color row_color = lerpColor(fill_color_from, fill_color_to, ((float)y)/(float)rows);
//    fill(row_color);

    //fill(255*(1-((float)y/rows)));
    beginShape(TRIANGLE_STRIP);
    for ( int x=1; x<cols; x++) { //color(255*(float)y/rows)
      color vertex_color = lerpColor(green, brown, map(terrain[x][y], -100, 100, 0, 1));
      fill(vertex_color);

      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
    }
    endShape();
  }
  
  camera(); 

  hint(DISABLE_DEPTH_TEST);
  noLights();
  textMode(MODEL);
  
  // ALL 2D stuff    ...................
  for ( Cloud c : clouds)
  {
    c.update();
    c.display();
  }
  
  sun.update();
  sun.display();
  
  text(frameRate, 0, 20);

  // prepare to return to 3D 
  hint(ENABLE_DEPTH_TEST);
}
