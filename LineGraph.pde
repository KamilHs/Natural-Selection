public class LineGraph extends Graph {
    int tick;
    LineGraph(int w, int h, int x0, int y0, int tick, int r, int g, int b) {
        super(w,h,x0,y0,r,g,b);
        this.tick = tick;
    }
    
    void draw(Float[] data) {
        push();
        fill(255);
        rect(x0, y0, w, h);
        
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
        pop();
    } 
}