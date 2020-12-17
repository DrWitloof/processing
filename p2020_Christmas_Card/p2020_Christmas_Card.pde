static int SHOW_PUZZLE = 0, 
  SHOW_COLORS = 1, 
  SHOW_LINES  = 2, 
  SHOW_SOLUTION = 3, 
  SHOW_MAX = 4;

int modus = SHOW_PUZZLE;

PShape hex_shape;
PVector hex_size;
PShape little_flake_start, little_flake_end;

PVector snowflake_mid;
PVector snowflake_size;
PVector snowflake_offset;

PFont snowflake_font;
PFont explanation_font;
PFont title_font;

color red = color( 233, 32, 46), 
  orange = color( 232, 156, 27), 
  yellow = color( 255, 230, 79), 
  green = color( 50, 232, 117), 
  blue = color( 34, 124, 157), 
  violet = color( 138, 94, 158), 
  white = color( 255), 
  grey = color( 28, 40, 38), 
  lightgrey = color( 220, 225, 230), 
  black = color( 0);


void setup()
{
  size( 600, 800, P2D);

  textAlign(CENTER, BASELINE);

  snowflake_font = createFont("Inter-SemiBold.ttf", width/25);
  explanation_font = createFont("Inter-SemiBold.ttf", width * 3/150); 
  title_font = createFont("Inter-SemiBold.ttf", width * 4/100); 
  textFont(snowflake_font);

  setup_hex();
  setup_snowflake();

  frameRate(10);
  
  little_flake_start = loadShape("little_flake_start.svg");
  little_flake_end = loadShape("little_flake_end.svg");
}

void draw() 
{
  draw_background();
  draw_explanation();
  draw_snowflake();
  draw_solution();
  draw_solution_lines();
}

void setup_hex()
{
  float size = width / 35; 

  hex_shape = createShape();
  hex_shape.beginShape();
  for ( int i = 0; i < 6; i++ ) {
    float x = cos( i * THIRD_PI ) * size;
    float y = sin( i * THIRD_PI ) * size;
    hex_shape.vertex( x, y );
  }
  hex_shape.endShape( CLOSE );

  hex_size = new PVector(size*2, sin(THIRD_PI) * size * 2);
}

void setup_snowflake()
{
  float snowflake_hex_width = 11.5;
  float snowflake_hex_height = 12;

  snowflake_mid = new PVector(width/2, height/2);
  snowflake_size = new PVector(snowflake_hex_width*hex_size.x, snowflake_hex_height*hex_size.y);
  snowflake_offset = snowflake_mid.copy()
    .sub(snowflake_size.copy().div(2))
    .add(hex_size.copy().div(2));

  for ( int i = 0; i<solution.length(); i++)
  {
    snowflake[solution_positions[i*2]] = replaceCharAt(snowflake[solution_positions[i*2]], solution_positions[i*2+1], solution.charAt(i));
  }
}

void draw_background()
{
  background( grey);
  push();

  noFill();
  stroke(white);
  strokeWeight(15);
  rect(0,0,width,height);
  
  stroke(black);
  strokeWeight(1);
  rect(0,0,width,height);
  pop();
}

void draw_explanation() {
  push();

  
  fill(white);
  textFont(title_font);
  text("Bakkerij BREAD PITT herdenkt bakker Witloof", width/2, height/16 + 0*textAscent());

  fill(lightgrey);
  textFont(explanation_font);
  
  String t1 = "Colour in the snowflake so that each circle";
  String t2 = "of six hexagons surrounding a grey hexagon";
  String t3 = "uses each of the six colours once.";
  
  t1 = "Kleur de sneeuwvlok, zodat elke cirkel";
  t2 = "van 6 zeshoeken rond een grijze zeshoek";
  t3 = "elk van de 6 kleuren 1 keer gebruikt.";
  
  text(t1, width/2, height/15 + 2*textAscent());
  text(t2, width/2, height/15 + 3.5*textAscent());
  text(t3, width/2, height/15 + 5*textAscent());
  pop();
}

String[] snowflake = {
  "---NOU---RYC---", 
  "---I R-M-E N---", 
  "----Q C E R----", 
  "---CHNJNEOIS---", 
  "-A-G T T F T-A-", 
  "E T A N A F M N", 
  "FOYRIAOITEOAENA", 
  "---S E Y A H---", 
  "----V Y E G----", 
  "---MERAEYMPP---", 
  "---F F---E D---", 
  "----R-----N----"
};

String[] snowflake_initial_colors = {
  "   WRO   RYG   ", 
  "   V W Y W W   ", 
  "    G W G B    ", 
  "   WOWWBWWWG   ", 
  " B W W W W W O ", 
  "R W W W W W R W", 
  "WGVOWGWWWYWWWBG", 
  "   W W W W W   ", 
  "    W W W W    ", 
  "   BGWWBWOYV   ", 
  "   W V   R W   ", 
  "    Y     B    "
};

String[] snowflake_solution_colors = {
  "   YRO   RYG   ", 
  "   V B Y V O   ", 
  "    G V G B    ", 
  "   ROYRBOYRG   ", 
  " B G V G V B O ", 
  "R Y B O R O R V", 
  "OGVORGYVBYGVYBG", 
  "   Y B O R O   ", 
  "    V R G B    ", 
  "   BGOYBVOYV   ", 
  "   R V   R G   ", 
  "    Y     B    "
};

int[] solution_positions = { 
  10, 3,    6, 4,    3, 6, 
   1, 11,   3, 8,    6, 0, 
   6, 12,   6, 9,    7, 3, 
   4, 7,   10, 11, 
   5, 4,    8, 10, 
   1, 9,    5, 14};

void draw_snowflake()
{
  String[] colors = modus<SHOW_COLORS?snowflake_initial_colors : snowflake_solution_colors;

  int r = 0;
  for (String row : snowflake)
  {
    int i = 0;
    for (char letter : row.toCharArray())
    {
      if ( letter != '-')
        draw_hex( 
          snowflake_offset.x + i*(hex_size.x*3/4), 
          snowflake_offset.y + r*hex_size.y + (i%2)*hex_size.y/2, 
          char2color(colors[r].charAt(i)), 
          letter);
      i++;
    }
    r++;
  }
}

String solution_colors = "RRROOOYYYGGBBVV";
//String solution =        "HAPPY HOLLIDAYS";
//String solution =          "GODJULGODTNYTÅR";
String solution =          "WWOLVES GO HOME";
String empty =           "               ";

void draw_solution()
{
  int solution_width = solution.length();
  String display_string = modus < SHOW_SOLUTION?empty:solution;
  float x_offset = (width - solution_width*hex_size.x)/2 + hex_size.x/2;
  float y_offset = height * 9/10;

  for (int i = 0; i<solution_width; i++)
  {
    draw_hex( x_offset + i*(hex_size.x), 
      y_offset, 
      char2color(solution_colors.charAt(i)), 
      display_string.charAt(i));
  }
}

void draw_solution_lines()
{
  draw_solution_line(new PVector(-4, 8), new PVector( 0.5, -8.5), red);
  draw_solution_line(new PVector( 5, -5), new PVector(-8, 2), orange);
  draw_solution_line(new PVector( 8, 0), new PVector(-6, 2.3), yellow);
  draw_solution_line(new PVector(-3, -8), new PVector( 4, 7), green);
  draw_solution_line(new PVector(-6, -3), new PVector( 5, 4), blue);
  draw_solution_line(new PVector(-1, -6), new PVector( 7, 1), violet);
}

void draw_solution_line(PVector from, PVector to, color c)
{
  stroke(c);
  fill(c);
  PVector f = new PVector(snowflake_mid.x + from.x*hex_size.x, snowflake_mid.y + from.y*hex_size.y);
  PVector t = new PVector(snowflake_mid.x + to.x*hex_size.x, snowflake_mid.y + to.y*hex_size.y);

  little_flake_start.setFill(c);
  shape(little_flake_start, f.x-hex_size.x/2, f.y-hex_size.x/2-2, hex_size.x, hex_size.x );
  little_flake_end.setFill(c);
  shape(little_flake_end, t.x-hex_size.x/2-2, t.y-hex_size.x/2, hex_size.x, hex_size.x+2);

  if (modus >= SHOW_LINES) 
  {
    push();
    strokeWeight(2);
    line(f.x, f.y, t.x, t.y);
    pop();
  }
}

void draw_hex(float x, float y, color c, char letter)
{
  push();
  translate( x, y);

  hex_shape.setFill(c);
  shape( hex_shape);
  fill( black);
  text( letter, -textWidth("I")*.05, textAscent()*.3333);

  pop();
}

color char2color(char c) {
  if ( c == 'R') return red;
  if ( c == 'O') return orange;
  if ( c == 'Y') return yellow;
  if ( c == 'G') return green;
  if ( c == 'B') return blue;
  if ( c == 'V') return violet;
  if ( c == 'W') return white;
  if ( c == ' ') return lightgrey;
  return white;
}

void mousePressed()
{
  modus = (modus+1)%SHOW_MAX;
}


void keyPressed() {
  String date_time = year() + nf(month(),2) + nf(day(),2) + " " +  nf(hour(), 2) + "h" + nf(minute(), 2) + "m" + nf(second(), 2) + "s";
  saveFrame("output/xmas " + date_time + ".png");
  println("printed at " + date_time);
}

String replaceCharAt(String s, int pos, char c) {
  char[] ch = new char[s.length()];
  s.getChars(0, ch.length, ch, 0);
  ch[pos] = c;
  return new String(ch);
}
