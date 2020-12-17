static float W = 70;
static float H = 100;
static float O = 5;
static int TEXTSIZE = 15;
static int S2OFFSET = int(6*(W+O));

public class Card 
{
  Card(int _x, int _y, String _c) 
  { 
    x = _x; 
    y = _y; 
    vs = _c.charAt(1) == '?'?"AKQJ098765432".toCharArray():new char[] { _c.charAt(1) }; 
    ss = _c.charAt(0) == '?'?"HKRS".toCharArray():new char[] { _c.charAt(0) };
  }

  boolean certain;
  char[] vs ;
  char[] ss ;

  void rem_value(char v) { 
    for (int i = 0; i<vs.length; i++) if (vs[i]==v) { 
      vs[i]=' '; 
      return;
    }
  }
  void rem_suit(char s) { 
    for (int i = 0; i<ss.length; i++) if (ss[i]==s) { 
      ss[i]=' '; 
      return;
    }
  }

  boolean has_v(char v) { 
    for (int i = 0; i<vs.length; i++) if (vs[i]==v) return true; 
    return false;
  }
  boolean has_s(char s) { 
    for (int i = 0; i<ss.length; i++) if (ss[i]==s) return true; 
    return false;
  }

  boolean active_up, active_dn;

  void activate_up() { 
    active_up = true; 
    active_dn = false;
  }
  void activate_dn() { 
    active_up = false; 
    active_dn = true;
  }
  void deactivate() { 
    active_up = false; 
    active_dn = false;
  }

  void flip( char c) 
  {
    if ( active_up)
    {
      int i = "AKQJ098765432".indexOf(c);
      if ( i>-1) vs[i]=vs[i]==' '?c:' ';
    }
    if ( active_dn)
    {
      int i = "HKRS".indexOf(c);
      if ( i>-1) ss[i]=ss[i]==' '?c:' ';
    }
  }

  void draw() 
  {
    fill(active_up?200:255);
    rect(x, y, W, H/2);
    fill(active_dn?200:255);
    rect(x, y+H/2, W, H/2);

    fill(0);
    text(new String(vs), x+1, y, W, H);
    text(new String(ss), x+1, (int)(y+H-TEXTSIZE-1), W, H);
  }

  int x, y;
}

class Set
{
  Card[][] set;
  Set( int offset, String[][] m) 
  { 
    set = new Card[5][5];

    for (int i=0; i<5; i++)
      for (int j=0; j<5; j++)
        set[i][j] = new Card(int(offset + O+j*(W+O)), int( O+i*(H+O)), m[i][j]);
  }

  void draw()
  {
    for (int i=0; i<5; i++)
      for (int j=0; j<5; j++)
        set[i][j].draw();
  }

  Card ca;

  void activate( int r, int c, boolean up) 
  {
    if ( ca != null) ca.deactivate();
    ca = set[r][c];
    if (up) ca.activate_up(); 
    else ca.activate_dn();
  }

  void deactivate() { 
    if ( ca != null) ca.deactivate(); 
    ca = null;
  }

  void flip( char c) { 
    if ( ca != null) ca.flip(c);
  }
}

Set s1, s2, sa;

void setup()
{
  size(1200, 800); //window size in pixels
  textSize(TEXTSIZE);

  String[][] m1 = {{"??", "??", "??", "??", "?0"}, 
    {"?0", "R3", "??", "K?", "?6"}, 
    {"?3", "??", "H3", "K?", "??"}, 
    {"H?", "??", "?9", "??", "?7"}, 
    {"S?", "SK", "??", "SJ", "?0"}};

  String[][] m2 = {{"??", "?J", "H9", "?2", "KA"}, 
    {"H?", "??", "?8", "HQ", "?6"}, 
    {"??", "?Q", "??", "??", "?A"}, 
    {"??", "?8", "H?", "?5", "??"}, 
    {"??", "??", "?6", "S?", "??"}}; 


  s1 = new Set(0, m1); 
  s2 = new Set(S2OFFSET, m2);
}

void draw()
{
  //c1.draw(int(10),int(30));
  s1.draw();
  s2.draw();
}

void mouseClicked() 
{
  Set sd; 
  int x = mouseX, y = mouseY;

  if ( x > S2OFFSET) { 
    sa = s2; 
    sd = s1; 
    x -= S2OFFSET;
  } else { 
    sa = s1; 
    sd = s2;
  } 

  int col = int(x / (W+O));
  int row = int(y / (H+O));
  int dy = y%int(H+O);

  if ( col<5 & row<5) { 
    sa.activate(row, col, dy<(int(H+O)/2)); 
    sd.deactivate();
  } else { 
    sa.deactivate(); 
    sd.deactivate();
  }
}

void keyPressed()
{
  if ( sa != null) sa.flip(("" + key).toUpperCase().charAt(0));
  println("keyPressed " + key);
}
