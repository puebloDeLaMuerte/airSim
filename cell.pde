class Cell {
  
  long parts;
  //long partsLast;
  double pressure;
  //double pressureLast;
  double temperature;
  
  
  
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
