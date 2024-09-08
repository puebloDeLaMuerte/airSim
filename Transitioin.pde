class Transition {
  
  Cell cellA, cellB;
  int id;
  
  double weight;
  PVector direction;
  
  double currentPressureDifferential;
  long currentPartsTransfer;
  long previousPartsTransfer;
  double currentTransferTemperature;
  
  
  public Transition( Cell cA, Cell cB, PVector cellACenter, PVector cellBCenter, float cellAVolume, float cellBVolume ) {
    
    this.cellA = cA;
    this.cellB = cB;
    
    cellA.transitions.add(this);
    cellB.transitions.add(this);
    this.direction = PVector.sub(cellBCenter,cellACenter);
    this.direction.setMag(1);
    
    this.id = (int)random(999999999);
    
    float distance = PVector.dist(cellACenter, cellBCenter);
    float volumeRatio = cellAVolume / cellBVolume;
    
    this.weight = (1.0f / distance) * volumeRatio;
  }
  
  
  public void calculateTransferAmount() {
    
    currentPressureDifferential = cellA.pressure - cellB.pressure; // positive if A has more pressure.
    
    if( currentPressureDifferential > 0 ) {
      currentPartsTransfer = (long)(currentPressureDifferential * weight * cellA.parts * viscosity);
    } else if( currentPressureDifferential < 0 ) {
      currentPartsTransfer = (long)(currentPressureDifferential * weight * cellB.parts * viscosity);
    } else currentPartsTransfer = 0;
    
    currentPartsTransfer = (currentPartsTransfer / flowInertiaQuotient) + (previousPartsTransfer / flowInertiaQuotient * flowInertiaQuotientInverse); 
    
    previousPartsTransfer = currentPartsTransfer;
  }
  
  
  public void applyTransfer() {
    
    cellA.transferParts( -currentPartsTransfer );
    //cellA.parts -= currentPartsTransfer;
    cellB.transferParts( currentPartsTransfer );
    //cellB.parts += currentPartsTransfer;
    
    //currentPressureDifferential = 0;
    //currentPartsTransfer = 0;
  }
}
