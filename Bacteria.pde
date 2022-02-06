public class Bacteria extends Creature {
    float speed;
    Bacteria(PVector pos, double speed) {
        super(pos);
        this.speed = (float)speed;
        energy = config.bacteria.energy.get("initial");
        energyPerFrame = config.bacteria.energy.get("lossPerFrame") +
            Math.max(
            0,
           (speed - config.bacteria.speed.get("initial")) * config.bacteria.speed.get("speedEnergyFactor")
           );
    }
    
    void draw() {
        push();
        fill(255,0,0);
        rect(
            this.pos.x - config.bacteria.width / 2,
            this.pos.y - config.bacteria.height / 2,
            config.bacteria.width,
            config.bacteria.height
           );
        pop();
    }
    
    boolean isAlive() {
        return alive;
    }
    
    void eat(double energy) {
        this.energy = Math.min(this.energy + energy, config.bacteria.energy.get("max"));
    }
    
    void hunt(ArrayList<Entity> entities) {
        double record = Double.MAX_VALUE;
        Flesh closest = null;
        
        for (Entity entity : entities) {
            if (!(entity instanceof Flesh) || !entity.isAlive()) continue;
            double distance = Utils.distanceTo(pos, entity.pos);
            
            if (record > distance) {
                record = distance;
                closest = (Flesh)entity;
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
        return energy >= config.bacteria.energy.get("minForReplicate");
    }
    
    Creature replicate() {
        energy -= config.bacteria.energy.get("lossAfterReplicate");

        boolean isAmoeba = false;

        double epsilon;
        double maxSpeed;
        double minSpeed;

        if(Math.random() < (float)config.bacteria.probOfAmoeba) {
            isAmoeba = true;
            epsilon = (double)config.amoeba.speed.get("epsilon");
            maxSpeed = (double)config.amoeba.speed.get("max");
            minSpeed = (double)config.amoeba.speed.get("min");
        } else {
            epsilon = (double)config.bacteria.speed.get("epsilon");
            maxSpeed = (double)config.bacteria.speed.get("max");
            minSpeed = (double)config.bacteria.speed.get("min");
        }

        double newSpeed = Math.max(
            Math.min(
                speed +
                (Math.random() < 0.5 ? 1 : - 1) * epsilon * speed,
                maxSpeed
            ),
            minSpeed
        );

        return isAmoeba ? new Amoeba(pos.copy(), newSpeed):new Bacteria(pos.copy(), newSpeed);
    }

    void setEaten() {
        this.alive = false;
    }
}