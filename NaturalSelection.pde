import java.util.Arrays;

Config config;
ArrayList<Entity> entities = new ArrayList<Entity>();
ArrayList<Float> bacteriaPopulations = new ArrayList<Float>();
ArrayList<Float> amoebaPopulations = new ArrayList<Float>();
Graph bacteriaPopulationGraph;
Graph amoebaPopulationGraph;

void setup() {
    fullScreen();
    noStroke();
    config = new Config("../config/1.json");
    for (int i = 0; i < config.flesh.count; ++i) {
        entities.add(new Flesh());
    }
    entities.add(new Bacteria(new PVector(random(0, width),random(0, height)), config.bacteria.speed.get("initial")));
    bacteriaPopulations.add(0.0f);
    bacteriaPopulationGraph = new Graph(displayWidth, 100, 0, displayHeight - 140, 1, GraphType.line, 255, 0, 0);
    amoebaPopulationGraph = new Graph(displayWidth, 100, 0, displayHeight - 240, 1, GraphType.line, 255, 0, 255);
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
    
    float bacteriaCount = 0;
    float amoebaCount = 0;
    for (Entity entity : entities) {
        entity.draw();
        if (!(entity instanceof Creature)) continue;
        
        Creature creature = (Creature) entity;
        creature.live(entities);
        
        if (creature instanceof Bacteria)
            bacteriaCount++;
        if (creature instanceof Amoeba)
            amoebaCount++;
        if (creature.canReplicate()) {
            added.add(creature.replicate());
        }
    }
    
    if (frameCount % 5 == 0) {
        bacteriaPopulations.add(bacteriaCount);
        amoebaPopulations.add(amoebaCount);
        println(amoebaCount);
    }
    if (bacteriaPopulations.size() > displayWidth) {
        bacteriaPopulations.remove(0);
    }
    if (amoebaPopulations.size() > displayWidth) {
        amoebaPopulations.remove(0);
    }
    entities.addAll(added);
    bacteriaPopulationGraph.draw(bacteriaPopulations.toArray(new Float[0]));
    amoebaPopulationGraph.draw(amoebaPopulations.toArray(new Float[0]));
}