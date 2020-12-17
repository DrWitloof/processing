
int nwk = 8;

// Number of columns and rows in our system
int cols, rows;
PShape lines;

void setup() 
{
  size(640, 480);

  // Initialize columns and rows
  cols = width/nwk;
  rows = height/nwk;
  
  int lineStroke = color(255);
  float xoff = 0;
  
  lines = createShape(GROUP);
  //scan image on Y axis (skipping based on vertical spacing)
  for(int y = 0 ; y < rows; y++)
  {
    //create a a shape made of lines
    PShape line = createShape();
    line.beginShape();
    // line.stroke(lineStroke);
    //line.strokeWeight(1);
    
    //scan image on X axis
    for(int x = 0; x < cols+1; x++)
    {
      line.vertex(x*nwk,y*nwk + map(noise(xoff), 0, 1, 0,nwk));
      xoff += 0.05;
    }
    //finish the lines shape and add it to the main PShape
    line.endShape();
    lines.addChild(line);
  }
}

void draw() 
{
  shape(lines);
}
