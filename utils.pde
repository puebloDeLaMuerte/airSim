long flowInertiaQuotientInverse;

float mapDoubleToFloat(double value, double start1, double stop1, float start2, float stop2) {
    return (float)((value - start1) / (stop1 - start1) * (stop2 - start2) + start2);
}

int mapLongToInt(long value, long fromLow, long fromHigh, int toLow, int toHigh) {
    return (int)((value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow);
}


float mapLongToFloat(long value, long fromLow, long fromHigh, float toLow, float toHigh) {
    return (float)((value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow);
}




void printStats() {
  long min = Long.MAX_VALUE;
  long max = 0;
  long total = 0;
  long over = 0;

  for ( int i = 0; i < grid.x; i++) {
    for ( int ii = 0; ii < grid.y; ii++) {

      Cell c = grid.cells[i][ii];

      if ( c.parts < min ) min = c.parts;
      if ( c.parts > max ) max = c.parts;

      long sum = total + c.parts;

      if ( sum < total ) over ++;

      total += c.parts;
    }
  }
  println( "over: " + over + " total: " + total );
  println( "min: " + min + " max: " + max );
}
