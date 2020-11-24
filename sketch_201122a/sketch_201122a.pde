// Simple 2D Maze Creator
// by Yoruk, taken from on old QBasic code made by me
// Published on the Instructables website, June 2014
// send comments to yoruk16_72  at yahoo dot fr


int startRow = 0;
int startCol = 0;

int ROWS = 80;
int COLS = 50;

int CELLSIZE = 5;

boolean use_cellsize_for_rows_and_cols = true;

int X;
int Y;

int[][] L ;  //the maze
boolean[][] RW; //right walls
boolean[][] DW; //down walls

boolean CaseTrouvee ;

boolean PasContreUnbord;


boolean GenerationTerminee;


void setup()
{
    size(640, 480); //window size in pixels
    
    init_variables();
    calculate_maze();
    draw_maze();
    save_maze();
}

void init_variables()
{
    println("init_variables()");
    
    if( use_cellsize_for_rows_and_cols)
    {
        COLS = int( (width-20) / CELLSIZE); 
        ROWS = int( (height-20) / CELLSIZE); 
    }
    
    println("Maze size : " + COLS + " x " + ROWS);
  
    RW = new boolean[COLS][ROWS];
    DW = new boolean[COLS][ROWS];
    L = new int[COLS][ROWS];

    for (int i = 0; i < ROWS; i = i+1) {
        for (int j = 0; j < COLS; j = j+1) {
            RW[j][i] = true;  //close every walls
            DW[j][i] = true;
        }
    } 
}

void calculate_maze()
{
    println("calculate_maze()");
    
    X = startCol;
    Y = startRow; 

    int K = 1, Ka = 1;

    L[X][Y] = K;
    
    int pct = (ROWS*COLS)/10;

    while( K < ROWS * COLS) {
      
        //print("checking cell ["); print(X); print(", "); print(Y); print("]"); print(" K"); print(K);  print(" Ka"); println(Ka);        

        //check if there is a possibility around the actual cell
        boolean is_there_a_not_visited_cell = false;

        if (X < COLS-1 && L[X + 1][Y] == 0) is_there_a_not_visited_cell = true;
        if (X > 0      && L[X - 1][Y] == 0) is_there_a_not_visited_cell = true;
        if (Y < ROWS-1 && L[X][Y + 1] == 0) is_there_a_not_visited_cell = true;
        if (Y > 0      && L[X][Y - 1] == 0) is_there_a_not_visited_cell = true;

        if (is_there_a_not_visited_cell) {

            do_move();          
                
            K = K + 1 ;
            L[X][Y] = K;
            Ka = K;

            if( K%pct == 0) 
            { 
                print( (10 * K)/(ROWS*COLS)); 
                println("0%"); 
            }

        }    
        else {
            //no possibility :move backwards
            
            Ka = Ka - 1;
          //  println("recul");

            for (int i = 0; i < ROWS; i = i+1) {  
                //find previous cell
                for (int j = 0; j < COLS; j = j+1) {

                    if (L[j][i] == Ka) { 
                        X = j;
                        Y = i;
                    //    println("case precedente trouvee");
                    }
                }
            }
        }
    }
    
    println("100%");
}

void do_move()
{
  int probabilities[] = 
    { (Y>0      && L[X][Y-1]==0)?(X%3==0)?3:1:0,  // up
      (X<COLS-1 && L[X+1][Y]==0)?1:0,  // right
      (Y<ROWS-1 && L[X][Y+1]==0)?1:0,  // down
      (X>0      && L[X-1][Y]==0)?1:0 } // left
      ;
      
   int total_probabilities = probabilities[0] + probabilities[1] + probabilities[2] + probabilities[3];
   
   int rand = (int) random( total_probabilities);
   
   int direction = 4;
   
   for( int i = 0; i<4; i++)
   {
     if( rand < probabilities[i]) { direction = i; break; }
     rand -= probabilities[i];
   }
   
  if( direction == 0) { DW[X][--Y] = false; }
  if( direction == 1) { RW[X++][Y] = false; }
  if( direction == 2) { DW[X][Y++] = false; }
  if( direction == 3) { RW[--X][Y] = false; }
   
  if( direction == 4) { 
    println("PANIC"); 
  }
}
          //while(true) {

          //      int direction = get_direction(X, Y);
          //      //0 up   1 right   2 down   3 left  
          //      // print("taking direction : "); print(direction);
                
          //      if( direction == 0) { int newY = Y-1; if( Y > 0       && L[X][newY] == 0) { DW[X][newY] = false; Y = newY; break; } }
          //      if( direction == 1) { int newX = X+1; if( newX < COLS && L[newX][Y] == 0) { RW[X][Y] = false;    X = newX; break; } }
          //      if( direction == 2) { int newY = Y+1; if( newY < ROWS && L[X][newY] == 0) { DW[X][Y] = false;    Y = newY; break; } }
          //      if( direction == 3) { int newX = X-1; if( X > 0       && L[newX][Y] == 0) { RW[newX][Y] = false; X = newX; break; } }
                
          //      // direction += 1;
                
          //      // println(" but no luck there");
                
          //  } 


int get_direction(int x, int y)
{
  return(int(random(4)));  
}

void draw_maze()
{
    background(255);
    rectMode(CORNERS) ;
    noFill();
    
    if( !use_cellsize_for_rows_and_cols) 
    {
        CELLSIZE = min((width-20) / COLS, (height-20) / ROWS);//compute the step size
    }
    
    int x_offset = (width - CELLSIZE*COLS)/2;
    int y_offset = (height - CELLSIZE*ROWS)/2;
    
    rect (x_offset, y_offset, x_offset + COLS * CELLSIZE, y_offset + ROWS * CELLSIZE) ;     //draw boundary    

    for (int i = 0; i < ROWS; i++) {  
        for (int j = 0; j < COLS; j++) {
            if (DW[j][i] == true)
            { 
                line( x_offset + j * CELLSIZE,        y_offset + i * CELLSIZE + CELLSIZE, 
                      x_offset + j * CELLSIZE + CELLSIZE,   y_offset + i * CELLSIZE + CELLSIZE) ;
            }
            if (RW[j][i] == true) 
            {
                 line( x_offset + j * CELLSIZE + CELLSIZE, y_offset + i * CELLSIZE, 
                       x_offset + j * CELLSIZE + CELLSIZE, y_offset + i * CELLSIZE + CELLSIZE);
            }
        }
    }

    noLoop();  // Run once and stop
}

void save_maze()
{
  String date_time = year() + nf(month(),2) + nf(day(),2) + " " +  nf(hour(), 2) + "h" + nf(minute(), 2) + "m" + nf(second(), 2) + "s";
  saveFrame("snapshot maze " + date_time + ".png");
  println( "saved at " + date_time);
}

void create_probability_matrix()
{
  PGraphics pg;
PFont f;                           

  pg = createGraphics(124, 92);
  f = createFont("",40,true); 
  
    pg.beginDraw();
    pg.background(255);
    pg.textFont(f,40);
    pg.fill(0);
    pg.textAlign(CENTER,CENTER);
    pg.text("OTTO", pg.width/2, pg.height/2);
    pg.endDraw();


}

//file end
