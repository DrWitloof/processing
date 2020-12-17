/*

ffmpeg -i gif-%04d.png -c:v libx264 -vf "fps=25,format=yuv420p" -loop=0 out.mp4
// ffmpeg -i out.mp4 -vf "scale=600:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=24:stats_mode=diff[p];[s1][p]paletteuse=dither=bayer:bayer_scale=2" out.gif

// https://imagemagick.org/script/download.php#windows
// convert -delay 1x30 gif-*.png dos1x30-1000.gif -remap gif-0001.png -coalesce

/*

convert -delay 1x30 gif-*.png ^
          \( -clone 0--1 -background none +append ^
              -quantize transparent  -colors 63  -unique-colors ^
             -write mpr:cmap    +delete \) ^
          -map mpr:cmap      dos1x30-1000.gif


convert dos1x30-1000.gif -layers OptimizeTransparency \( -clone 0--1 -background none +append  -quantize transparent  -colors 63  -unique-colors  -write mpr:cmap    +delete \)   -map mpr:cmap dos1x30-1000-2.gif

*/
PVector location;
PShape triple_loop;
PShape text_shape; int text_size;
float SCALE;
static int total_steps = 1000;
static int steps_per_frame = 1;

PFont font;

PGraphics txt1,txt2,txt3;

color color_background, color_line, color_text;

void setup()
{
  size(600,600, P3D);
  SCALE = float(width)/2;
  text_size = width/40;
  
  font = createFont("RobotoMono-Regular.ttf", text_size);
  
  textFont(font);
  textSize(text_size);
  textAlign(LEFT,TOP);
  
  color_background = color(189, 178, 255); // maximum blue purple
  color_background = color(55,77,66);
  color_line = color(255, 255, 252); // baby powder
  color_text = color(202, 255, 191); // tea green
  // color(255, 214, 165); // deep champagne
  // color_text = color(255, 173, 173); // light pink
  
  calculate_triple_loop();
  
  txt1 = create_text_img( "Genuary #001");
  txt2 = create_text_img( "// triple nested loop");
  txt3 = create_text_img( "- drwitloof -");
  //text_image = loadImage("test.png");
  
  frameRate(25);
}

void draw()
{
  background(color_background);
  fill(color_line);

  pushMatrix();

  translate(width/2,height/2);
  shape(triple_loop, 0, 0);

  shape(calculate_text_shape(0.0, txt1), 0, 0);
  shape(calculate_text_shape(1.0/3, txt2), 0, 0);
  //shape(calculate_text_shape(2.0/3, txt3), 0, 0);
  
  //image(txt1,0,0);
  //image(txt2,0,txt1.height);
  //image(txt3,0,txt1.height + txt2.height);
  
  popMatrix();
  
  if( 1==1)
  {
    if (steps_per_frame*frameCount < (1+total_steps)) 
      saveFrame("output/gif-"+nf(frameCount, 4)+".png");
    else text("" + frameRate, 0,0);
  } else text("" + frameRate, 0,0);
}

PVector osc_v( int step, int freq, float a, float phi_offset)
{
  int steps = total_steps/freq;
  float phi = phi_offset +  2.0*PI * float(step%steps) / steps;
  return new PVector( a*sin(phi), a*cos(phi));
}

void calculate_triple_loop()
{
  triple_loop = createShape();
  triple_loop.beginShape();
  triple_loop.noFill();
  triple_loop.stroke(color_line);

  for( int i = 0; i<total_steps; i++) 
  {
    location = osc_v(i, 1, 0.4, PI/3).add(osc_v(i, 4, 0.5, 0.0));//.add(osc(i, 500, 0.02,0.02));
    triple_loop.vertex(SCALE*location.x, SCALE*location.y);
    if( i%50 == 0) { println(i); println(location); }
  }
  
  triple_loop.endShape(CLOSE);
}

PShape calculate_text_shape(float offset, PGraphics txt)
{
  int start_point=(steps_per_frame*frameCount) + int(offset*total_steps);
  int text_shape_length = total_steps/20;

  PShape text_shape = createShape();

//  text_shape.beginShape();
  text_shape.beginShape(TRIANGLE_STRIP);
  // text_shape.noFill();
  // text_shape.stroke(color_text);
  // text_shape.strokeWeight(3);
  text_shape.noStroke();
  text_shape.texture(txt);

  int vi = (start_point -1) % total_steps;
  PVector v = triple_loop.getVertex(vi);
  int vi_next = (start_point -1 + 5) % total_steps;
  PVector v_next = triple_loop.getVertex(vi_next);
  PVector v2 = v_next.copy().sub(v).normalize().rotate(HALF_PI).setMag(text_size*4/3).add(v);

  text_shape.vertex(v2.x, v2.y, 1.0*txt.width, 0.0);

  for( int i = 0; i<text_shape_length; i+=1) 
  {
    vi = (start_point + i) % total_steps;
    v = triple_loop.getVertex(vi);
    vi_next = (start_point + i + 1) % total_steps;
    v_next = triple_loop.getVertex(vi_next);
    
    v2 = v_next.copy().sub(v).normalize().rotate(HALF_PI).setMag(text_size*4/3).add(v_next);
    
    float pct1 = 1.0 - float(i)/float(text_shape_length);
    float pct2 = 1.0 - float(i+1)/float(text_shape_length);

    text_shape.vertex(v2.x, v2.y, pct2*txt.width, 0.0);
    text_shape.vertex(v.x, v.y, pct1*txt.width, 1.0*txt.height);
  }

  text_shape.vertex(v_next.x, v_next.y, 0.0, 1.0*txt.height);
  
  text_shape.endShape();
  
  return text_shape;
}

PGraphics create_text_img(String text)
{
  int text_width = int(textWidth(text));
  PGraphics pg = createGraphics(text_width, int(textAscent() + textDescent()), P2D);
  
  pg.beginDraw();
//  text_image.background(color(123,55,35));
  pg.fill(color_text);
//  text_image.stroke();
  pg.textFont(font);
  pg.textSize(text_size);
  pg.textAlign(LEFT,TOP);
  pg.text(text, 0, 0);
  pg.endDraw();
  
  return pg;
}
