public class Amoeba extends Creature {
    float speed;
    Amoeba(PVector pos, double speed) {
        super(pos);
        this.speed = (float)speed;
        energy = config.amoeba.energy.get("initial");
        energyPerFrame = config.amoeba.energy.get("lossPerFrame") +
            Math.max(
            0,
           (speed - config.amoeba.speed.get("initial")) * config.amoeba.speed.get("speedEnergyFactor")
           );
    }
    
    void draw() {
        push();
        fill(255,0,255);
        rect(
            this.pos.x - config.amoeba.width / 2,
            this.pos.y - config.amoeba.height / 2,
            config.amoeba.width,
            config.amoeba.height
           );
        pop();
    }
    
    boolean isAlive() {
        return alive;
    }
    
    void eat(double energy) {
        this.energy = Math.min(this.energy + energy, config.amoeba.energy.get("max"));
    }
    
    void hunt(ArrayList<Entity> entities) {
        double record = Double.MAX_VALUE;
        Bacteria closest = null;
        
        for (Entity entity : entities) {
            if (!(entity instanceof Bacteria) || !entity.isAlive()) continue;
            double distance = Utils.distanceTo(pos, entity.pos);
            
            if (record > distance) {
                record = distance;
                closest = (Bacteria)entity;
            }
        }
        
        if (closest != null) {
            dir = PVector.sub(closest.pos, pos).normalize();
            
            if (Utils.distanceTo(pos, closest.pos) < speed) {
                closest.setEaten();
                eat(closest.energy);
            }
        } else {
            dir = new PVector(0, 0);
        }
    }
    
    void live(ArrayList<Entity> entities) {
        if (!alive) return;
        energy -= energyPerFrame;

        if (energy < 0) {
            alive = false;
        }
        
        hunt(entities);
        
        pos.add(dir.x * speed, dir.y * speed);
    }
    
    boolean canReplicate() {
        return energy >= config.amoeba.energy.get("minForReplicate");
    }
    
    Creature replicate() {
        energy -= config.amoeba.energy.get("lossAfterReplicate");
        
        double newSpeed = Math.max(
            Math.min(
            speed +
           (Math.random() < 0.5 ? 1 : - 1) * config.amoeba.speed.get("epsilon") * speed,
            config.amoeba.speed.get("max")),
            config.amoeba.speed.get("min")
           );
        
        return new Amoeba(pos.copy(), newSpeed);
    }
}
