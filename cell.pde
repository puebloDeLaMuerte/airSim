class Cell {

  long parts;
  double pressure;
  double density;
  double temperature;

  ArrayList<Transition> transitions = new ArrayList();

  PVector currentFlow = new PVector(0, 0);

  public void calculateFlow() {

    currentFlow = new PVector(0, 0);

    // Iterate through each transition affecting this cell
    for (Transition t : transitions) {
      // Scale the direction vector by the amount of parts being transferred in this transition
      PVector flowContribution = t.direction.copy().mult((float)t.currentTotalPartsTransfer / (float)300000000);

      // Add this flow contribution to the current flow of the cell
      currentFlow.add(flowContribution);
    }
  }
  
  public void calculateDensity() {
    this.density = (double) this.parts / grid.cellVolume;
}

  public void calculatePressure() {

    this.pressure = (this.parts * boltzmannConstant * this.temperature ) / grid.cellVolume;
    //if( this.pressure != this.pressureLast ) println("pressurechange: " + this.pressure);
    //this.pressureLast = this.pressure;
  }


  public void transferParts(long partsDelta) {
    this.parts += partsDelta;
    //if( this.parts != this.partsLast ) println("partschange: " + this.parts + " delta: " + partsDelta);
    //this.partsLast = this.parts;
  }

  public void applyTemperatureDelta(double delta) {
    
    delta /= this.parts;
    //println("delta: " + delta );
    
    if (this.temperature > Double.MAX_VALUE - delta) {
      this.temperature = Double.MAX_VALUE-1;
      //println("max temp");
    } else {
      this.temperature += delta;
      //println("temp delta: " + delta);
    }
    if ( this.temperature < 1d ) {
      this.temperature = 1d;
      //println("min delta");
    }
  }
}
