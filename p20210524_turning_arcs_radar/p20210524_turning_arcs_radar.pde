color fc = color(236, 221, 123);
int aantal = 10;

float osc( int t, float A, float f, float fi) {   return A * cos(TWO_PI*t/f + fi);  }

void setup()
{
  size(600,600);
  strokeWeight(5);
}

void draw()
{
  background(0);
  fill(fc);
  stroke(fc);
  
  //circle(  width / (aantal+1), height / 2, 100); 
  
  for( int i = 0; i < aantal; i++)
  {    
    //circle( (i+1)* width / (aantal+1), height / 2, 10);
    noFill();
    float arclength = osc(frameCount, QUARTER_PI, 100.0, 0.0) * (((int)frameCount/50)%2==0?1:-1);
    float arcstart = (i<(aantal/2)?PI:0) - QUARTER_PI*((int)frameCount/50);
    
    arc( width/2, height/2,
         2*(abs(0.5+i-(aantal/2))) * width / (aantal+1),
         2*(abs(0.5+i-(aantal/2))) * width / (aantal+1),
         min(arcstart, arcstart + arclength), 
         max(arcstart, arcstart + arclength));
  }
  
    if( 1==1)
  {
    if (frameCount < 300 ) 
      saveFrame("output/gif-"+width+"x"+height+"-####.png");
  } 
  stroke(0);
  fill(150);
  textSize(32);
  text("fc" + frameCount, 80*width/100, 95*height/100);
  text("fr" + frameRate, 80*width/100, 98*height/100);

}

//noFill();
//arc(50, 55, 60, 60, HALF_PI, PI);
//arc(50, 55, 70, 70, PI, PI+QUARTER_PI);
//arc(50, 55, 80, 80, PI+QUARTER_PI, TWO_PI);
