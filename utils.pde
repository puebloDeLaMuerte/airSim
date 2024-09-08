long flowInertiaQuotientInverse;

float mapDoubleToFloat(double value, double start1, double stop1, float start2, float stop2) {
    return (float)((value - start1) / (stop1 - start1) * (stop2 - start2) + start2);
}

int mapLongToInt(long value, long fromLow, long fromHigh, int toLow, int toHigh) {
    return (int)((value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow);
}
