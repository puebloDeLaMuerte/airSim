Grid grid;

double boltzmannConstant     = 1.380649e-23;
double viscosity             = 500000.1d;
long   flowInertiaQuotient   = 2000L;

float  pressureRadiusMax     = 30f;
double pMaxDisplay           = 2.14E-6 ; // 8.14E-6 ;
float  flowIndicatorLength   = 15;


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

  if ( runSimulation ) {
    for ( int i = 0; i < 50; i++ ) {
      //grid.cells[10][10].parts = 100000000000000000L; // influx for testing
      grid.tick();
    }
  }

  drawGrid();



  //printStats();
}



void drawGrid() {

  background(255);

  pushMatrix();
  pushStyle();
  translate(drawMargin, drawMargin);

  for ( int i = 0; i < grid.x; i++) {
    for ( int ii = 0; ii < grid.y; ii++) {

      Cell c = grid.cells[i][ii];

      pushMatrix();
      pushStyle();

      // where to draw the cell
      translate( i * grid.cellSize * cellSizeFactor, ii * grid.cellSize * cellSizeFactor );


      int r = 127;
      int b = 127;

      if ( drawTemperatureIndicator ) {

        r += (int)((c.temperature - 700d) * 0.2d);
        b += (int)((700d - c.temperature) * 0.2d);
      }

      // draw the cell mass
      if ( drawMassIndicator ) {

        //stroke(0);
        noStroke();
        float amount = mapLongToInt(c.parts, 30000000000000000L, 40000000000000000L, 170, 85);
        if ( amount > 255 ) amount = 255;
        if ( amount < 0 ) amount = 0;
        fill( amount );
        if ( drawTemperatureIndicator ) stroke( r, 127, b );
        else noStroke();
        //fill(250);
        rect( 0, 0, grid.cellSize * cellSizeFactor, grid.cellSize * cellSizeFactor, grid.cellSize * cellSizeFactor / 4);
      }



      if ( drawPressureIndicator ) {


        // draw cell pressure indicator
        float pressureRadius = mapDoubleToFloat( c.pressure, 0, pMaxDisplay, 0, grid.cellSize) * cellSizeFactor;

        if ( pressureRadius > pressureRadiusMax || pressureRadius < -pressureRadiusMax ) {
          pressureRadius = pressureRadiusMax;
          stroke(0);
        } else {
          noStroke();
        }

        fill(r, 127, b, 68);
        translate( grid.cellSize*cellSizeFactor/2, grid.cellSize*cellSizeFactor/2 );
        ellipse( 0, 0, pressureRadius, pressureRadius);
      }




      if ( drawFlowIndicator ) {
        
        drawLowFlowIndicator(c);
        //drawHighFlowIndicator(c);
      }

      popStyle();
      popMatrix();
    }
  }

  popStyle();
  popMatrix();
}


public void drawLowFlowIndicator(Cell c) {
  
  // Low flow dial (sensitive to low input values, always visible)
    PVector lowFlow = c.currentFlow.copy();
    double lowFlowMagnitude = lowFlow.mag();
    float lowFlowMaxLength = cellSizeFactor * flowIndicatorLength;
    float lowFlowScale = mapDoubleToFloat(lowFlowMagnitude,  0d, 0.001d,  0, lowFlowMaxLength); // Sensible scaling for small values
    lowFlowScale = min(lowFlowScale, lowFlowMaxLength);
    lowFlow.normalize().mult(lowFlowScale); // Scale the low flow vector
    stroke(0, 0, 255, 127); // Blue color for low flow
    strokeWeight(1); // Thin line for low flow
    line(0, 0, lowFlow.x, lowFlow.y);

}

public void drawHighFlowIndicator(Cell c) {
  
// Draw the high current flow vector (only scaled if current is very high)
    PVector highFlow = c.currentFlow.copy();
    float highFlowMagnitude = highFlow.mag();
    if (highFlowMagnitude > 10 * cellSizeFactor) { // Threshold for higher flows
        float highFlowScale = map(highFlowMagnitude, 10 * cellSizeFactor, 30 * cellSizeFactor, 0, cellSizeFactor * 10); // Scale for higher flows
        highFlow.normalize().mult(highFlowScale); // Scale the high flow vector
        stroke(255, 0, 0, 127); // Red color for high flow
        strokeWeight(2); // Thicker line for high flow
        line(0, 0, highFlow.x, highFlow.y);
    }
}


public void keyPressed() {

  if ( key == '1' ) drawMassIndicator = !drawMassIndicator;
  if ( key == '2' ) drawPressureIndicator = !drawPressureIndicator;
  if ( key == '3' ) drawFlowIndicator = !drawFlowIndicator;
  if ( key == '4' ) drawTemperatureIndicator = !drawTemperatureIndicator;
  if ( key == 't' ) {
    applyThermicEnvironment = !applyThermicEnvironment;
    if ( applyThermicEnvironment ) drawTemperatureIndicator = true;
  }
  if ( key == ' ' ) runSimulation = !runSimulation;
}
