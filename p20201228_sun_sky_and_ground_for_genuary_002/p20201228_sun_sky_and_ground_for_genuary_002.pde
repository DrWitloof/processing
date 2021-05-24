int o = 15;

float cloud_height;
int rain_height;

float sun_speed = 3.0;
float cloud_speed = 4.0;
float rain_speed = 6;

void setup()
{
  size( 800, 800);
  cloud_height = height/5;
  rain_height = int(height-cloud_height);
  
  createLandandskyPG();
  createSunPG();
  createCloudPG();
  createRainPG();

  println("rain : speed=" + rain_speed + " per frame - distance = " + (rainPG.height) + " ==> " + (rainPG.height)/rain_speed);
  println("sun : speed=" + sun_speed + " per frame - distance = " + 3600 + " ==> " + 3600/sun_speed);
  println("cloud : speed=" + cloud_speed + " per frame - distance = " + width + " ==> " + width/cloud_speed);
  
}

int rule30(int left, int mid, int right)
{
  if( left==1 ^ (mid + right > 0)) 
    return 1; 
  return 0;
}

void draw()
{
  background(254, 255, 235);

  // land and sky
  image(landandskyPG, o, o);
  
  // sun
  pushMatrix();
  translate(o + height / 10, o + height / 10);
  rotate((sun_speed*frameCount)%3600*TWO_PI/3600);

  image(sunPG, -sunPG.width/2, -sunPG.height/2);

  popMatrix();
  
  // rain

  int rain_from = rain_height, rain_to = rainPG.height, rain_pos = (rain_to-rain_from) - (int(rain_speed*frameCount)%(rain_to-rain_from));
  copy( rainPG.get(), 
          0, rain_pos, rainPG.width, rain_height,
          o, int(cloud_height),rainPG.width, rain_height);
  
  // cloud  
  int cloud_left = width-int(cloud_speed*frameCount)%width;
  
  copy( cloudPG.get(), 0, 0, width, cloudPG.height, cloud_left, 0, width, cloudPG.height);
  copy( cloudPG.get(), 0, 0, width, cloudPG.height, cloud_left-width, 0, width, cloudPG.height);

  

  if( 1==1)
  {
    if (frameCount < 300 ) 
      saveFrame("output/gif-"+width+"x"+height+"-"+nf(frameCount, 4)+".png");
  } 
  stroke(0);
  fill(150);
  textSize(32);
  text("fc" + frameCount, 80*width/100, 95*height/100);
  text("fr" + frameRate, 80*width/100, 98*height/100);

}

PGraphics landandskyPG;

void createLandandskyPG()
{
int landlines = 25;
float landlines_width = float(width-2*o) / (landlines);

  landandskyPG = createGraphics(width - 2*o, height - 2*o);
  
  landandskyPG.beginDraw();
  landandskyPG.noStroke();
//  landandskyPG.stroke(0);

  randomSeed(0);

  // sky
  landandskyPG.fill(color(160, 196, 255, 10));
  int skywobble = 10;
  for ( int i = 1; i<13; i++ ) 
  {
    float x,y,w,h;
    x = 0;
    y = 0;
    w = width-2*o;
    h = i*height / 20;
    landandskyPG.quad( x, y, 
          x, y + h + random(-skywobble, skywobble), 
          x + w, y + h + random(-skywobble, skywobble), 
          x + w, y);
    landandskyPG.quad( x, y, 
          x, y + h + random(-skywobble, skywobble), 
          x + w, y + h + random(-skywobble, skywobble), 
          x + w, y);
  }

  // land
  landandskyPG.fill(color(187, 255, 173, 100));

  int landwobble = 4;
  for ( int i = 0; i<landlines; i++ ) 
  {
    float x,y,w,h;
    x = i*landlines_width ;
    y = height - height/2.5  + random(-landwobble, landwobble);
    w = landlines_width;
    h = height/2.5 - o  + random(-landwobble, landwobble);
    landandskyPG.quad( x + random(-landwobble, landwobble), y, 
          x + random(-landwobble, landwobble), y + h, 
          x + w + random(-landwobble, landwobble), y + h, 
          x + w + random(-landwobble, landwobble), y);
  }  
  
  landandskyPG.endDraw();
}

PGraphics sunPG;

void createSunPG()
{
  int size = int(2*sqrt(width*width + height*height));
  sunPG = createGraphics(size,size);
  
  sunPG.beginDraw();
  sunPG.noStroke();

  sunPG.fill(color(247, 227, 102, 50));
  
  sunPG.translate(size/2, size/2);
  sunPG.ellipse( 0, 0, height / 6, height / 6);

  int rays = 18, l = 5000;
  for ( int i = 0; i < rays; i++)
  {
    sunPG.quad( height/8, - o/2, 
      height/8, + o/2, 
      l*height/8, + l*o/2, 
      l*height/8, - l*o/2); 

    sunPG.rotate(TWO_PI/rays);
  }

  sunPG.endDraw();
}

PGraphics cloudPG;

void createCloudPG()
{
  cloudPG = createGraphics(width, height/2);
  
  cloudPG.beginDraw();
  cloudPG.noStroke();

  randomSeed(0);

  cloudPG.fill(color(249, 246, 240, 100)); 

  createCloudPGRecurse(width/2 + frameCount, cloud_height, 60);

  cloudPG.endDraw();
}

void createCloudPGRecurse(float x, float y, float w)
{
  if ( w < 20) return;

  cloudPG.ellipse( x-cloudPG.width, y, w, w);
  cloudPG.ellipse( x, y, w, w);
  cloudPG.ellipse( x+cloudPG.width, y, w, w);

  for (int i = 0; i < 2; i++)
  {
    createCloudPGRecurse(
      x + random(-2.5*w, 2.5*w), 
      y + random(-w/2.2, w/1.8), 
      max(1.0, w - random(10)));
  }
}

PGraphics rainPG;

void createRainPG()
{
  int raindrops = 40;

  float raindrop_height = 18;
  float raindrops_apart = (width-2*o)/raindrops;
  float overlap_factor = 0.8;
  int rain30h = 80;
  int rain30w = rain30h * 2;
  int rain30m = rain30w / 2;
  int [][] rain30 = new int[rain30h][rain30w];

  // calculate 1th row
  for (int n=0; n < rain30w; ++n ) {
    rain30[0][n] = (n == (rain30m) ? 1 : 0);
  }
  
  println("rain30h = " + rain30h);
  println("rain30w = " + rain30w);
    
  println("rain_height = " + raindrop_height);
 
  // calculate other rows
  for( int r=1; r<rain30h; r++) {
    rain30[r][0] = 0; 
    rain30[r][rain30w-1] = 0;
    for (int n=1; n < rain30w-1; ++n ) {
      rain30[r][n] = rule30(rain30[r-1][n-1], rain30[r-1][n], rain30[r-1][n+1]);
    }
  }
  
  int rainPGh = int((rain_height)*2 + raindrop_height*overlap_factor*rain30h);
  
  rainPG = createGraphics(width - 2*o, 100+rainPGh/100*100);
  
  rainPG.beginDraw();

  rainPG.stroke(color(34, 124, 157));
  rainPG.strokeWeight(2);
  randomSeed(0);
  int rainhwobble=0;
  for( int i = 0; i < rain30h ; i++)
  {
    for( int c = 0; c < raindrops; c++)
    {
      if( rain30[i][c+rain30m-raindrops/2]==1) 
      {
        float x = (float(c)+0.5)*raindrops_apart+random(-rainhwobble, rainhwobble), y = rainPG.height - (rain_height) - 0.8*i*raindrop_height;
        rainPG.line(x,y,x,y+raindrop_height);
      }
    }
  }
  
  rainPG.endDraw();
}
