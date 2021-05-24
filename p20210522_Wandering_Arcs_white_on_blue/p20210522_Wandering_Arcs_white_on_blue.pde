  int cols = 60;
  int rows = 10;
  int scale = 18;
  
  int w_offset, h_offset;

void setup() {
  size (1200, 800);
  
  scale = height / rows;
  cols = 1+ width / scale;
  rows = 1+ height / scale;
  
  w_offset = (width - scale*cols) / 2;
  h_offset = (height - scale*rows) / 2;
}

void draw() {
  drawgrid();
}

void drawgrid() {

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      int x = w_offset + i * scale;
      int y = h_offset + j * scale;
      fill(#add8e6);
      noStroke();
      //stroke(0);
      rect(x, y, scale, scale);
      
      float arc_offset = TWO_PI * noise(float(i)/200, float(j)/20 + float(frameCount)/100);
      float arc_length = QUARTER_PI + PI * noise(float(i)/200, float(j)/20 + float(frameCount)/100);
      boolean show = .6 < noise(float(i*cols + j) + float(frameCount)/1000);
      float shape = noise(200 + float(i*cols + j) + float(frameCount)/1000);

      
      //fill(255);
      //stroke(0);
      if(show)
      {
        fill(255);
        if( shape > 0.5)
        {
          arc(x, y, scale, scale, arc_offset+arc_length, TWO_PI+arc_offset);
        }
        else
        {
          arc(x, y, scale, scale, arc_offset, arc_offset+arc_length);
        }
      }
    }
  }
}
