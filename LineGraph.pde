public class LineGraph extends Graph {
    int tick;
    LineGraph(int w, int h, int x0, int y0, int tick, int r, int g, int b, String label) {
        super(w,h,x0,y0,r,g,b,label);
        this.tick = tick;
    }
    
    void draw(Float[] data) {
        push();
        fill(255);
        stroke(0);
        rect(x0, y0, w, h);
        noStroke();
        fill(r, g, b);
        
        float min = Float.MAX_VALUE;
        float max = Float.MIN_VALUE;
        
        for (Float d : data) {
            min = Math.min(min,(float) d);
            max = Math.max(max,(float) d);
        }
        
        for (int i = 0; i < data.length; ++i) {
            float mapped = map((float)data[i],(float)min,(float) max, 0, h);
            rect(x0 + i * tick, y0 + h, tick,(int) - mapped);
        }
        if(config.showLabels){
            fill(0);
            textSize(24);
            text(label, x0, y0 + 24);
        }
        pop();
    } 
}