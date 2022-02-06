enum GraphType {
    line,
    hist
}

class Graph {
    GraphType type;
    int w;
    int h;
    int x0;
    int y0;
    int tick;
    int r;
    int g;
    int b;
    
    Graph(int w, int h, int x0, int y0, int tick, GraphType type, int r, int g, int b) {
        this.type = type;
        this.w = w;
        this.h = h;
        this.x0 = x0;
        this.y0 = y0;
        this.tick = tick;
        this.r = r;
        this.g = g;
        this.b = b;
    }
    
    Graph(int w, int h, int x0, int y0) {
        this(w, h, x0, y0, 1, GraphType.line, 255, 255, 255);
    }    
    
    void draw(Float[] data) {
        push();
        fill(255);
        rect(x0, y0, w, h);
        
        if (type == GraphType.line)
            drawLineGraph(data);
        pop();
    }
    
    private void drawLineGraph(Float[] data) {
        float min = Float.MAX_VALUE;
        float max = Float.MIN_VALUE;
        
        for (Float d : data) {
            min = Math.min(min,(float) d);
            max = Math.max(max,(float) d);
        }
        
        fill(r, g, b);
        for (int i = 0; i < data.length; ++i) {
            float mapped = map((float)data[i],(float)min,(float) max, 0, h);
            rect(x0 + i * tick, y0 + h, tick,(int) - mapped);
        }
    } 
}