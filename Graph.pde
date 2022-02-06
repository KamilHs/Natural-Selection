abstract class Graph {
    int w;
    int h;
    int x0;
    int y0;
    int r;
    int g;
    int b;
    String label;
    
    Graph(int w, int h, int x0, int y0, int r, int g, int b, String label) {
        this.w = w;
        this.h = h;
        this.x0 = x0;
        this.y0 = y0;
        this.r = r;
        this.g = g;
        this.b = b;
        this.label = label;
    }
}