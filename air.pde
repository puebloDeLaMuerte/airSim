Grid grid;
double boltzmannConstant = 1.380649e-23;
double viscosity = 500000.1d;
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
  
  grid.cells[10][10].parts = 100000000000000000L;
  //println("frame");
  
  grid.tick();
  
  drawGrid();
}



void drawGrid() {
  
  background(255);
  
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
      //ellipse( 0,0, pressureRadius, pressureRadius);
      
      // Draw the flow vector
      PVector flow = c.currentFlow.copy();
      flow.mult(cellSizeFactor * 0.5f); // Scale the flow vector for visualization
      stroke(0, 0, 255); // Set the color for the flow vector (blue)
      //strokeWeight(2);
      line(0, 0, flow.x, flow.y);
      
      popStyle();
      popMatrix();
    } 
  }
  
  popStyle();
  popMatrix();  
}
  
  
