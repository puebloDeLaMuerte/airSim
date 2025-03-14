class Transition {

  Cell cellA, cellB;
  int id;
  boolean isVertical;

  double weight;
  PVector direction;

  double currentPressureDifferential;
  long currentPressurePartsTransfer;
  long currentBuoyancyPartsTransfer;
  long currentTotalPartsTransfer;
  long previousTotalPartsTransfer;
  double currentTotalTransferTemperature;


  public Transition( Cell cA, Cell cB, PVector cellACenter, PVector cellBCenter, float cellAVolume, float cellBVolume ) {

    this.cellA = cA;
    this.cellB = cB;

    cellA.transitions.add(this);
    cellB.transitions.add(this);
    this.direction = PVector.sub(cellBCenter, cellACenter);
    this.direction.setMag(1);

    this.id = (int)random(999999999);

    float distance = PVector.dist(cellACenter, cellBCenter);
    float volumeRatio = cellAVolume / cellBVolume;

    this.weight = (1.0f / distance) * volumeRatio;
    this.isVertical = (cellACenter.x == cellBCenter.x) && (cellACenter.y != cellBCenter.y);
  }


  public void calculateBuoyancyTransferAmount() {
    
    double densityDifference = cellA.density - cellB.density;

    if (isVertical) {
        // Positive transfer (from A to B) when A is denser (densityDifference > 0)
        // Negative transfer (from B to A) when B is denser (densityDifference < 0)
        currentBuoyancyPartsTransfer = (long)(densityDifference * weight * buoyancyFactor);
    } else {
        currentBuoyancyPartsTransfer = 0;
    }
}


  public void calculatePressureTransferAmount() {

    currentPressureDifferential = cellA.pressure - cellB.pressure; // positive if A has more pressure.

    if ( currentPressureDifferential > 0 ) {
      currentPressurePartsTransfer = (long)(currentPressureDifferential * weight * cellA.parts * viscosity);
    } else if ( currentPressureDifferential < 0 ) {
      currentPressurePartsTransfer = (long)(currentPressureDifferential * weight * cellB.parts * viscosity);
    } else currentPressurePartsTransfer = 0;
  }



  public void calculateTotalPartsTransfer() {
    
    currentTotalPartsTransfer = currentPressurePartsTransfer + currentBuoyancyPartsTransfer;
    
    currentTotalPartsTransfer = (currentTotalPartsTransfer / flowInertiaQuotient) + (previousTotalPartsTransfer / flowInertiaQuotient * flowInertiaQuotientInverse);

    previousTotalPartsTransfer = currentTotalPartsTransfer;
  }
  


  public void applyTransfer() {

    cellA.transferParts( -currentTotalPartsTransfer );
    //cellA.parts -= currentPartsTransfer;
    cellB.transferParts( currentTotalPartsTransfer );
    //cellB.parts += currentPartsTransfer;

    //currentPressureDifferential = 0;
    //currentPartsTransfer = 0;
  }

  public void applyTotalPartsTransfer() {

    if (currentTotalPartsTransfer == 0) {
      // No transfer, so nothing to do
      return;
    }

    Cell source = currentTotalPartsTransfer > 0 ? cellA : cellB;
    Cell destination = currentTotalPartsTransfer > 0 ? cellB : cellA;

    long transferAmount = Math.abs(currentTotalPartsTransfer);
    
    if( transferAmount > source.parts ) {
      //println("saveguard particle transfer");
      transferAmount = source.parts;
    }

    long particlesInDestPre = destination.parts;  // Particles before the transfer for temp calculation

    // Apply particle transfer
    source.transferParts(-transferAmount);
    destination.transferParts(transferAmount);

    // Recalculate temperature

    long particlesInDestPost = destination.parts;  // Particles after the transfer

    if (particlesInDestPost > 0) {
      // New temperature is weighted by the particles in the destination and the transferred particles from the source
      destination.temperature = ((particlesInDestPre * destination.temperature) +
        (transferAmount * source.temperature)) / particlesInDestPost;
    }
  }
}
