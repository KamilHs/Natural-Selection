import java.util.Arrays;

Config config;
ArrayList<Entity> entities = new ArrayList<Entity>();
ArrayList<Float> populations = new ArrayList<Float>();
Graph populationGraph;

void setup() {
    fullScreen();
    noStroke();
    config = new Config("../config/1.json");
    for (int i = 0; i < config.flesh.count; ++i) {
        entities.add(new Flesh());
    }
    entities.add(new Bacteria(new PVector(random(0, width),random(0, height)), config.bacteria.speed.get("max")));
    populations.add(0.0f);
    populationGraph = new Graph(displayWidth, 100, 0, displayHeight - 140, 1, GraphType.line, 255, 0, 0);
}

void draw() {
    background(255);
    
    entities.removeIf(entity -> !entity.isAlive());
    
    if (frameCount % config.flesh.interval == 0) {
        for (int i = 0; i < config.flesh.count; ++i) {
            entities.add(new Flesh());
        }
    }
    
    ArrayList<Creature> added = new ArrayList<Creature>();
    
    float creaturesCount = 0;
    for (Entity entity : entities) {
        entity.draw();
        if (!(entity instanceof Creature)) continue;
        
        Creature creature = (Creature) entity;
        creature.live(entities);
        creaturesCount++;
        if (creature.canReplicate()) {
            added.add(creature.replicate());
        }
    }
    
    if (frameCount % 5 == 0) {
        populations.add(creaturesCount);
    }
    if (populations.size() > displayWidth) {
        populations.remove(0);
    }
    entities.addAll(added);
    populationGraph.draw(populations.toArray(new Float[0]));
}
