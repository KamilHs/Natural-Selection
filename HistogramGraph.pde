public class HistogramGraph extends Graph {
    int tick;
    float min;
    float max;
    HistogramGraph(int w, int h, int x0, int y0, float min, float max, int r, int g, int b, String label) {
        super(w, h, x0, y0, r, g, b, label);
        this.tick = (int)(w / (max - min + 1));
        this.min = min;
        this.max = max;
    }
    
    void draw(Float[] data) {
        push();
        fill(255);
        stroke(0);
        rect(x0, y0, w, h);
        noStroke();
        fill(r, g, b);

        int total = data.length;
        
        HashMap<Integer, Integer> hm = new HashMap<Integer, Integer>();
        for (float s : data) {
            int key = (int) Math.floor(s);
            hm.put(key, hm.getOrDefault(key, 0) + 1);
        }
        
        hm.forEach((k, v) -> {
            rect(
               (k - min) * tick + x0,
                y0 + h,
                tick,
                -map(v, 0, total, 0, h)
               );
        });
        if(config.showLabels){
            fill(0);
            textSize(24);
            text(label, x0, y0 + 24);
        }
        pop();
    }
}
