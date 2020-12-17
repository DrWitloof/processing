Sun sun = new Sun(new PVector(200,200),200,color(255, 247, 0, 80));

void setup() {
  size( 600, 600, P2D);
  // createCanvas(width, height);
}

void draw() {
  //blendMode(BLEND);
  background(color(102, 185, 240));
  sun.update();
  sun.display();
  
}

void test(){
  //noStroke();
  //blendMode(MULTIPLY);
  noStroke();
  color clr = color(255, 247, 0, 80);
  fill(clr);
  translate(width/2,height/2);
  drawLiq(200, 18, 50,  20,100);
  drawLiq(200, 8,  60, -25,120);
  drawLiq(200, 12, 45, 15, 150);
  drawLiq(200, 9,  70, 15, 150);
}


void drawLiq(int size, int vNnum, float nm, float sm, float fcm){
  push();
  //rotate(frameCount/fcm);
  float dr = TWO_PI/vNnum;
  beginShape();
  for(int i = 0; i  < vNnum + 3; i++){
    int ind = i%vNnum;
    float rad = dr *ind;
    float r = size*0.3 + noise((frameCount/nm + ind)/10) * size*0.1; //+ sin(frameCount/sm + ind)*height*0.0005;
    curveVertex(cos(rad)*r, sin(rad)*r);
  }
  endShape();
  pop();
}
