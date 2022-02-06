import java.util.Arrays;

Config config;
ArrayList<Entity> entities = new ArrayList<Entity>();
ArrayList<Float> bacteriaPopulations = new ArrayList<Float>();
ArrayList<Float> amoebaPopulations = new ArrayList<Float>();
LineGraph bacteriaPopulationGraph;
LineGraph amoebaPopulationGraph;
HistogramGraph bacteriaSpeedGraph;
HistogramGraph amoebaSpeedGraph;

void setup() {
    fullScreen();
    noStroke();
    config = new Config("../config/1.json");
    for (int i = 0; i < config.flesh.count; ++i) {
        entities.add(new Flesh());
}
    entities.add(new Bacteria(new PVector(random(0, width), random(0, height)), config.bacteria.speed.get("initial"), config.bacteria.heatTolerance.get("initial"), config.bacteria.coldTolerance.get("initial")));
    bacteriaPopulations.add(0.0f);
    amoebaPopulations.add(0.0f);
    bacteriaPopulationGraph = new LineGraph(displayWidth / 2, 100, 0, displayHeight - 140, 1, 255, 0, 0, "Bacteria population");
    amoebaPopulationGraph = new LineGraph(displayWidth / 2, 100, 0, displayHeight - 240, 1, 255, 0, 255, "Amoeba population");
    bacteriaSpeedGraph = new HistogramGraph(100, 100, displayWidth / 2, displayHeight - 140, config.bacteria.speed.get("min").floatValue(), config.bacteria.speed.get("max").floatValue(), 255, 0, 0, "Bacteria speed");
    amoebaSpeedGraph = new HistogramGraph(100, 100, displayWidth / 2, displayHeight - 240, config.amoeba.speed.get("min").floatValue(), config.amoeba.speed.get("max").floatValue(), 255, 0, 255, "Amoeba speed");
}

void draw() {
    background(255);
    
    entities.removeIf(entity -> !entity.isAlive());
    
    if(frameCount % config.flesh.interval == 0) {
        for (int i = 0; i < config.flesh.count; ++i) {
            entities.add(new Flesh());
        }
}
    
    ArrayList<Creature> added = new ArrayList<Creature>();
    ArrayList<Float> bacteriaSpeeds = new ArrayList<Float>();
    ArrayList<Float> amoebaSpeeds = new ArrayList<Float>();
    
    float bacteriaCount = 0;
    float amoebaCount = 0;
    for (Entity entity : entities) {
        entity.draw();
        if (!(entity instanceof Creature)) continue;
        
        Creature creature = (Creature) entity;
        creature.live(entities);
        
        if (creature instanceof Bacteria) {
            Bacteria b = (Bacteria)creature;
            bacteriaSpeeds.add(b.speed);
            bacteriaCount++;
        }
        if (creature instanceof Amoeba) {
            Amoeba a = (Amoeba)creature;
            amoebaSpeeds.add(a.speed);
            amoebaCount++;
        }
        if (creature.canReplicate()) {
            added.add(creature.replicate());
        }
}
    
    if(frameCount % 5 == 0) {
        bacteriaPopulations.add(bacteriaCount);
        amoebaPopulations.add(amoebaCount);
}
    if(bacteriaPopulations.size() > displayWidth / 2) {
        bacteriaPopulations.remove(0);
}
    if(amoebaPopulations.size() > displayWidth / 2) {
        amoebaPopulations.remove(0);
}
    entities.addAll(added);
    bacteriaPopulationGraph.draw(bacteriaPopulations.toArray(new Float[0]));
    amoebaPopulationGraph.draw(amoebaPopulations.toArray(new Float[0]));
    bacteriaSpeedGraph.draw(bacteriaSpeeds.toArray(new Float[0]));
    amoebaSpeedGraph.draw(amoebaSpeeds.toArray(new Float[0]));
}

void keyPressed() {
    if (key == 't' || key == 'T') {
        config.showLabels = !config.showLabels;
    }
}