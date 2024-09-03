Grid grid;
double boltzmannConstant = 1.380649e-23;
double viscosity = 100000.1d;
double pMaxDisplay = 8.14E-6 ;

float cellSizeFactor;
float drawMargin = 40;

void settings() {
  
  size( 900, 600 );
  grid = new Grid( 80, 50, 10, 100000000000000000L, 300.0);
}


void setup() {
  
  cellSizeFactor = (float)(width-drawMargin*2) / ((float)grid.x * grid.cellSize) ;
  
}



void draw() {
  
  //println("frame");
  
  grid.tick();
  
  drawGrid();
}



void drawGrid() {
  
  pushMatrix();
  pushStyle();
  translate(drawMargin,drawMargin);
  
  for( int i = 0; i < grid.x; i++) {
    for( int ii = 0; ii < grid.y; ii++) {
      
      Cell c = grid.cells[i][ii];
      
      pushMatrix();
      pushStyle();
      
      // where to draw the cell
      translate( i * grid.cellSize * cellSizeFactor, ii * grid.cellSize * cellSizeFactor );
      
      // draw the cell boundaries
      //stroke(0);
      noStroke();
      int amount = mapLongToInt(c.parts, 25000000000000000L, 100000000000000000L, 0, 255);
      //fill( amount);
      fill(250);
      rect( 0,0, grid.cellSize * cellSizeFactor, grid.cellSize * cellSizeFactor);
      
      // draw cell pressure indicator
      float pressureRadius = mapDoubleToFloat( c.pressure, 0, pMaxDisplay, 0, grid.cellSize) * cellSizeFactor;
      noStroke();
      fill(127);
      translate( grid.cellSize*cellSizeFactor/2, grid.cellSize*cellSizeFactor/2 );
      ellipse( 0,0, pressureRadius, pressureRadius);
      
      
      popStyle();
      popMatrix();
    } 
  }
  
  popStyle();
  popMatrix();  
}
  
  
