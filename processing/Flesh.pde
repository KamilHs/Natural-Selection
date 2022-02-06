class Flesh extends Entity {
    double energy;
    boolean isEaten = false;
    
    Flesh() {
        super(new PVector(random(0, width),random(0, height)));
        energy = config.flesh.energy;
    }
    
    void draw() {
        push();
        fill(config.flesh.c[0],config.flesh.c[1],config.flesh.c[2]);
        ellipse(pos.x, pos.y, config.flesh.radius, config.flesh.radius);
        pop();
    }
    
    boolean isAlive() {
        return !isEaten;
    }

    void setEaten() {
        this.isEaten = true;
    }
}
