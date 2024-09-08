class Cell {
  
  long parts;
  //long partsLast;
  double pressure;
  //double pressureLast;
  double temperature;
  
  ArrayList<Transition> transitions = new ArrayList();
  
  PVector currentFlow = new PVector(0,0);
  
  public void calculateFlow() {
    
    currentFlow = new PVector(0, 0);

    // Iterate through each transition affecting this cell
    for (Transition t : transitions) {
        // Scale the direction vector by the amount of parts being transferred in this transition
        PVector flowContribution = t.direction.copy().mult(t.currentPartsTransfer / 30000000000000L);

        // Add this flow contribution to the current flow of the cell
        currentFlow.add(flowContribution);
    }    
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
}
