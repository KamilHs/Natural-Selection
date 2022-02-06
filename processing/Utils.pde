static class Utils {
    static double distanceTo(PVector u, PVector v) {
        return dist(u.x, u.y, v.x, v.y);
    }  
    
    static double map(int initial, int inMin, int inMax, int outMin, int outMax) {
        return Utils.map((double)initial,(double)inMin,(double)inMax,(double)outMin,(double) outMax);
    }
    
    static double map(double initial, double inMin, double inMax, double outMin, double outMax) {
        return outMin + (initial - inMin) * (outMax - outMin) / (inMax - inMin);
    }
}