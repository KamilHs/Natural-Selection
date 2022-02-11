import java.util.Arrays;

Config config;
ArrayList<Entity> entities = new ArrayList<Entity>();
ArrayList<Float> bacteriaPopulations = new ArrayList<Float>();
ArrayList<Float> amoebaPopulations = new ArrayList<Float>();
LineGraph bacteriaPopulationGraph;
LineGraph amoebaPopulationGraph;
HistogramGraph bacteriaSpeedGraph;
HistogramGraph amoebaSpeedGraph;
HistogramGraph bacteriaNormalTempGraph;
HistogramGraph amoebaNormalTempGraph;
PImage amoebaImage, bacteriaImage;
int maxBacteriaPopulation = 0;
int maxAmoebaPopulation = 0;

void setup() {
  fullScreen();
  noStroke();
  config = new Config("../config/1.json");
  bacteriaImage = loadImage("./assets/Bacteria.png");
  amoebaImage = loadImage("./assets/Amoeba.png");

  for (int i = 0; i < config.flesh.count; ++i) {
    entities.add(new Flesh());
  }
  entities.add(new Bacteria(new PVector(random(0, width), random(0, height)), config.bacteria.speed.get("initial"), config.bacteria.temp.get("initial")));
  bacteriaPopulations.add(0.0f);
  amoebaPopulations.add(0.0f);
  initializeGraphs();
}

void draw() {
  if (config.climate.currentSeason == Season.summer)
    background(config.climate.summer.bg[0], config.climate.summer.bg[1], config.climate.summer.bg[2]);
  else if (config.climate.currentSeason == Season.winter)
    background(config.climate.winter.bg[0], config.climate.winter.bg[1], config.climate.winter.bg[2]);
  else
    background(255);

  if (frameCount % config.climate.climateDuration == 0) {
    climateChange();
  }

  entities.removeIf(entity -> !entity.isAlive());

  if (frameCount % config.flesh.interval == 0) {
    for (int i = 0; i < config.flesh.count; ++i) {
      entities.add(new Flesh());
    }
  }

  ArrayList<Creature> added = new ArrayList<Creature>();
  ArrayList<Float> bacteriaSpeeds = new ArrayList<Float>();
  ArrayList<Float> amoebaSpeeds = new ArrayList<Float>();
  ArrayList<Float> bacteriaNormalTemps = new ArrayList<Float>();
  ArrayList<Float> amoebaNormalTemps = new ArrayList<Float>();

  int bacteriaCount = 0;
  int amoebaCount = 0;

  for (Entity entity : entities) {
    entity.draw();
    if (!(entity instanceof Creature)) continue;

    Creature creature = (Creature) entity;
    creature.live(entities);

    if (creature instanceof Bacteria) {
      Bacteria b = (Bacteria)creature;
      bacteriaSpeeds.add(b.speed);
      bacteriaNormalTemps.add((float)b.normalTemp);
      bacteriaCount++;
    }
    if (creature instanceof Amoeba) {
      Amoeba a= (Amoeba)creature;
      amoebaSpeeds.add(a.speed);
      amoebaNormalTemps.add((float)a.normalTemp);
      amoebaCount++;
    }
    if (creature.canReplicate()) {
      added.add(creature.replicate());
    }
  }

  if (frameCount % 5 == 0) {
    bacteriaPopulations.add((float)bacteriaCount);
    amoebaPopulations.add((float)amoebaCount);
    maxBacteriaPopulation = max(bacteriaCount, maxBacteriaPopulation);
    maxAmoebaPopulation = max(amoebaCount, maxAmoebaPopulation);
  }

  if (bacteriaPopulations.size() > displayWidth / 2) {
    bacteriaPopulations.remove(0);
  }

  if (amoebaPopulations.size() > displayWidth / 2) {
    amoebaPopulations.remove(0);
  }

  entities.addAll(added);
  bacteriaPopulationGraph.draw(bacteriaPopulations.toArray(new Float[0]), 0, maxBacteriaPopulation);
  amoebaPopulationGraph.draw(amoebaPopulations.toArray(new Float[0]), 0, maxAmoebaPopulation);
  bacteriaNormalTempGraph.draw(bacteriaNormalTemps.toArray(new Float[0]));
  amoebaNormalTempGraph.draw(amoebaNormalTemps.toArray(new Float[0]));
  bacteriaSpeedGraph.draw(bacteriaSpeeds.toArray(new Float[0]));
  amoebaSpeedGraph.draw(amoebaSpeeds.toArray(new Float[0]));

  int[] tempColor = Utils.getColorByTemp(config.climate.currentTemp, config.climate.winter.min, config.climate.summer.max);

  bacteriaNormalTempGraph.drawConstant((float)config.climate.currentTemp, tempColor);
  amoebaNormalTempGraph.drawConstant((float)config.climate.currentTemp, tempColor);
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    config.showLabels = !config.showLabels;
  }
}

void climateChange() {
  if (config.climate.currentSeason == Season.spring) {
    config.climate.currentSeason = Season.summer;
    config.climate.currentTemp = random((float)config.climate.summer.min, (float)config.climate.summer.max);
  } else if (config.climate.currentSeason == Season.summer) {
    config.climate.currentSeason = Season.autumn;
    config.climate.currentTemp = random((float)config.climate.winter.max, (float)config.climate.summer.min);
  } else if (config.climate.currentSeason == Season.autumn) {
    config.climate.currentSeason = Season.winter;
    config.climate.currentTemp = random((float)config.climate.winter.min, (float)config.climate.winter.max);
  } else {
    config.climate.currentSeason = Season.spring;
    config.climate.currentTemp = config.climate.normalTemp;
  }
}


void initializeGraphs() {
  bacteriaPopulationGraph = new LineGraph(
    displayWidth / config.bacteriaPopulation.width,
    config.bacteriaPopulation.height,
    config.bacteriaPopulation.x0,
    displayHeight - config.bacteriaPopulation.y0,
    config.bacteriaPopulation.tick,
    config.bacteriaPopulation.grColor[0],
    config.bacteriaPopulation.grColor[1],
    config.bacteriaPopulation.grColor[2],
    config.bacteriaPopulation.label);
  amoebaPopulationGraph = new LineGraph(
    displayWidth / config.amoebaPopulation.width,
    config.amoebaPopulation.height,
    config.amoebaPopulation.x0,
    displayHeight - config.amoebaPopulation.y0,
    config.amoebaPopulation.tick,
    config.amoebaPopulation.grColor[0],
    config.amoebaPopulation.grColor[1],
    config.amoebaPopulation.grColor[2],
    config.amoebaPopulation.label);
  bacteriaSpeedGraph = new HistogramGraph(
    config.bacteriaSpeed.width,
    config.bacteriaSpeed.height,
    displayWidth / config.bacteriaSpeed.x0,
    displayHeight - config.bacteriaSpeed.y0,
    config.bacteria.speed.get("min").floatValue(),
    config.bacteria.speed.get("max").floatValue(),
    config.bacteriaSpeed.grColor[0],
    config.bacteriaSpeed.grColor[1],
    config.bacteriaSpeed.grColor[2],
    config.bacteriaSpeed.label);
  amoebaSpeedGraph = new HistogramGraph(
    config.amoebaSpeed.width,
    config.amoebaSpeed.height,
    displayWidth / config.amoebaSpeed.x0,
    displayHeight - config.amoebaSpeed.y0,
    config.amoeba.speed.get("min").floatValue(),
    config.amoeba.speed.get("max").floatValue(),
    config.amoebaSpeed.grColor[0],
    config.amoebaSpeed.grColor[1],
    config.amoebaSpeed.grColor[2],
    config.amoebaSpeed.label);
  bacteriaNormalTempGraph = new HistogramGraph(
    360,
    100,
    displayWidth / 2 + 100,
    displayHeight - 140,
    config.bacteria.temp.get("min").floatValue(),
    config.bacteria.temp.get("max").floatValue(),
    config.bacteriaSpeed.grColor[0],
    config.bacteriaSpeed.grColor[1],
    config.bacteriaSpeed.grColor[2],
    config.bacteriaSpeed.label);
  amoebaNormalTempGraph = new HistogramGraph(
    360,
    100,
    displayWidth / 2 + 100,
    displayHeight - 240,
    config.amoeba.temp.get("min").floatValue(),
    config.amoeba.temp.get("max").floatValue(),
    config.amoebaSpeed.grColor[0], config.amoebaSpeed.grColor[1], config.amoebaSpeed.grColor[2], config.amoebaSpeed.label);
}
