class Sun
{
  PVector pos;
  int size;
  color clr;
  float soff = 0.0;
  float soff_delta = 0.01;
  //    color clr = color(255, 247, 0, 80);

  Sun( PVector pos, int size, color clr)
  {
    this.pos = pos;
    this.size = size;
    this.clr = clr;
  }

  void update()
  {
    soff += soff_delta;
  }

  void display()
  {
    translate(pos.x, pos.y);
    push();

    drawLiq(18);
    drawLiq(8);
    drawLiq(12);
    drawLiq(15);

    pop();
  }

  void drawLiq(int nbr_vertices) {
    float dr = TWO_PI/nbr_vertices;
    beginShape();
    noStroke();
    fill(clr);

    for (int i = 0; i  < nbr_vertices + 3; i++) {
      float rad = dr * (i % nbr_vertices);
      float r = size*.5 + noise(nbr_vertices + soff + (i*0.001)) * size*0.1; //+ sin(frameCount/sm + ind)*height*0.0005;
      curveVertex(cos(rad)*r, sin(rad)*r);
    }
    endShape();
  }
}
