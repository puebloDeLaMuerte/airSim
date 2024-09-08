class Grid {

  Cell[][] cells;
  Transition[] transitions;
  
  int x, y;
  float cellVolume;
  float cellSize;


  public Grid(int x, int y, float cellSize, long initParts, double initTemp) {

    this.x = x;
    this.y = y;
    this.cellVolume = cellSize * cellSize;
    this.cellSize = cellSize;

    cells = new Cell[x][y];

    for ( int i = 0; i < x; i++) {
      for ( int ii = 0; ii < y; ii++) {

        cells[i][ii] = new Cell();

        if ( i >= x/2 ) cells[i][ii].parts = initParts;
        if ( ii >= y/2 ) cells[i][ii].parts = cells[i][ii].parts / 2;
        //cells[i][ii].parts = 100;

        cells[i][ii].temperature = initTemp;
      }
    }
    
    
    
    createTransitions();
  }

  private void createTransitions() {
    
    ArrayList<Transition> temptransitions = new ArrayList<>();

    // Iterate over each cell
    for (int i = 0; i < x; i++) {
      for (int ii = 0; ii < y; ii++) {

        // Array of relative neighbor positions
        int[][] neighbors = {
          {-1, -1}, {-1, 0}, {-1, 1},
          { 0, -1}, { 0, 1},
          { 1, -1}, { 1, 0}, { 1, 1}
        };

        // Create transitions for each valid neighbor
        for (int[] n : neighbors) {
          int ni = i + n[0];
          int nii = ii + n[1];

          if (ni >= 0 && ni < x && nii >= 0 && nii < y) {
            // Ensure that each transition is only created once
            if (i < ni || (i == ni && ii < nii)) {
              PVector cellACenter = new PVector(i * cellSize, ii * cellSize);
              PVector cellBCenter = new PVector(ni * cellSize, nii * cellSize);

              Transition t = new Transition(cells[i][ii], cells[ni][nii], cellACenter, cellBCenter, cellVolume, cellVolume);
              /*
              boolean doAdd = true;
              for( Transition tt : temptransitions ) {
                if( tt.cellA == t.cellA && tt.cellB == t.cellB ) {
                  doAdd = false;
                  println("securityCheck");
                  break;
                }
                if( tt.cellA == t.cellB && tt.cellB == t.cellA ) {
                  doAdd = false;
                  println("securityCheck");
                  break;
                }
              }
              if( doAdd ) temptransitions.add(t);
              */
              temptransitions.add(t);
            }
          }
        }
      }
    }
    transitions = temptransitions.toArray(new Transition[0]);
    println( transitions.length + " transitions created");
  }


  public void tick() {

    calculatePressures();
    calculateTransferAmounts();
    calculateFlowVectors();
    applyTransfers();
  }


  public void calculateFlowVectors() {
    for ( int i = 0; i < x; i++) {
      for ( int ii = 0; ii < y; ii++) {
        cells[i][ii].calculateFlow();
      }
    }
  }

  public void calculatePressures() {

    for ( int i = 0; i < x; i++) {
      for ( int ii = 0; ii < y; ii++) {
        cells[i][ii].calculatePressure();
      }
    }
  }
  
  
  public void calculateTransferAmounts() {
    for( Transition t : transitions ) {
      t.calculateTransferAmount();
    }
  }
  
  
  public void applyTransfers() {
    for( Transition t : transitions ) {
      t.applyTransfer();
    }
  }
}
