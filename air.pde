Grid grid;

double boltzmannConstant     = 1.380649e-23;
double viscosity             = 500000.1d;
long   flowInertiaQuotient   = 2000L;

float  pressureRadiusMax     = 30f;
double pMaxDisplay           = 2.14E-6 ; // 8.14E-6 ;
float  flowIndicatorLength   = 7;


float cellSizeFactor;
float drawMargin = 40;

boolean drawMassIndicator = true;
boolean drawPressureIndicator = false;
boolean drawFlowIndicator = true;
boolean drawTemperatureIndicator = false;

boolean runSimulation = false;
boolean applyThermicEnvironment = false;

void settings() {
  
  size( 1200, 800 );
  smooth();
  
  grid = new Grid( 160, 100, 10, 100000000000000000L, 700.0);
}


void setup() {
  
  // calculate some runtime-constants
  flowInertiaQuotientInverse = flowInertiaQuotient -1;
  cellSizeFactor = (float)(width-drawMargin*2) / ((float)grid.x * grid.cellSize);
}



void draw() {
  
  if( runSimulation ) {
    for( int i = 0; i < 50; i++ ) {
      //grid.cells[10][10].parts = 100000000000000000L; // influx for testing
      grid.tick();
    }
  }
  
  drawGrid();
  
  
  
  long min = Long.MAX_VALUE;
  long max = 0;
  long total = 0;
  long over = 0;
  
  for( int i = 0; i < grid.x; i++) {
    for( int ii = 0; ii < grid.y; ii++) {
      
      Cell c = grid.cells[i][ii];
      
      if( c.parts < min ) min = c.parts;
      if( c.parts > max ) max = c.parts;
      
      long sum = total + c.parts;
      
      if( sum < total ) over ++;
      
      total += c.parts;
    }
  }
  println( "over: " + over + " total: " + total );
  println( "min: " + min + " max: " + max );
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
      
      
      int r = 127;
      int b = 127;
      
      if( drawTemperatureIndicator ) {
        
        r += (int)((c.temperature - 700d) * 0.2d);
        b += (int)((700d - c.temperature) * 0.2d);
      }
      
      // draw the cell mass
      if( drawMassIndicator ) {
      
        //stroke(0);
        noStroke();
        float amount = mapLongToInt(c.parts, 30000000000000000L, 40000000000000000L, 170, 85);
        if( amount > 255 ) amount = 255;
        if( amount < 0 ) amount = 0;
        fill( amount );
        if( drawTemperatureIndicator ) stroke( r, 127, b );
        else noStroke();
        //fill(250);
        rect( 0,0, grid.cellSize * cellSizeFactor, grid.cellSize * cellSizeFactor, grid.cellSize * cellSizeFactor / 4);
      }
      
      
      
      if( drawPressureIndicator ) { 
      
        
      
        // draw cell pressure indicator
        float pressureRadius = mapDoubleToFloat( c.pressure, 0, pMaxDisplay, 0, grid.cellSize) * cellSizeFactor;
        
        if( pressureRadius > pressureRadiusMax || pressureRadius < -pressureRadiusMax ) {
          pressureRadius = pressureRadiusMax;
          stroke(0);
        } else {
          noStroke();
        }
        
        fill(r, 127, b, 68);
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
  
  if( key == '1' ) drawMassIndicator = !drawMassIndicator;
  if( key == '2' ) drawPressureIndicator = !drawPressureIndicator;
  if( key == '3' ) drawFlowIndicator = !drawFlowIndicator;
  if( key == '4' ) drawTemperatureIndicator = !drawTemperatureIndicator;
  if( key == 't' ) {
    applyThermicEnvironment = !applyThermicEnvironment;
    if( applyThermicEnvironment ) drawTemperatureIndicator = true;
  }
  if( key == ' ' ) runSimulation = !runSimulation;
}
