Grid grid;
double boltzmannConstant     = 1.380649e-23;
double viscosity             = 500000.1d;
long   flowInertiaQuotient   = 2000L;

double pMaxDisplay           = 2.14E-6 ; // 8.14E-6 ;
float  flowIndicatorLength   = 7;



float cellSizeFactor;
float drawMargin = 40;

boolean drawPressureIndicator = false;
boolean drawFlowIndicator = true;
boolean runSimulation = false;

void settings() {
  
  size( 1200, 800 );
  smooth();
  
  flowInertiaQuotientInverse = flowInertiaQuotient -1;
  
  grid = new Grid( 160, 100, 10, 100000000000000000L, 700.0);
}


void setup() {
  
  cellSizeFactor = (float)(width-drawMargin*2) / ((float)grid.x * grid.cellSize) ;
  
}



void draw() {
  
  
  if( runSimulation ) {
    for( int i = 0; i < 50; i++ ) {
      //grid.cells[10][10].parts = 100000000000000000L; // influx for testing
      grid.tick();  
    }
  }
  
  
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
      //fill(250);
      //rect( 0,0, grid.cellSize * cellSizeFactor, grid.cellSize * cellSizeFactor);
      
      if( drawPressureIndicator ) { 
        // draw cell pressure indicator
        float pressureRadius = mapDoubleToFloat( c.pressure, 0, pMaxDisplay, 0, grid.cellSize) * cellSizeFactor;
        noStroke();
        fill(127, 68);
        translate( grid.cellSize*cellSizeFactor/2, grid.cellSize*cellSizeFactor/2 );
        ellipse( 0,0, pressureRadius, pressureRadius);
      }
      
      if( drawFlowIndicator ) {
        // Draw the flow vector
        PVector flow = c.currentFlow.copy();
        flow.mult(cellSizeFactor * flowIndicatorLength); // Scale the flow vector for visualization
        stroke(0, 0, 255, 127); // Set the color for the flow vector (blue)
        //strokeWeight(2);
        line(0, 0, flow.x, flow.y);
      }
      
      popStyle();
      popMatrix();
    } 
  }
  
  popStyle();
  popMatrix();  
}
  
  
public void keyPressed() {
  
  if( key == '1' ) drawPressureIndicator = !drawPressureIndicator;
  if( key == '2' ) drawFlowIndicator = !drawFlowIndicator;
  if( key == ' ' ) runSimulation = !runSimulation;
}
