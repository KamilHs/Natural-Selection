public class Amoeba extends Creature {
  float speed;
  Amoeba(PVector pos, double speed, double maxTempTolerance, double minTempTolerance) {
    super(pos);
    this.speed = (float)speed;
    energy = config.amoeba.energy.get("initial");
    energyPerFrame = config.amoeba.energy.get("lossPerFrame") +
      Math.max(
      0,
      (speed - config.amoeba.speed.get("initial")) * config.amoeba.speed.get("speedEnergyFactor")
      );
    this.maxTempTolerance = maxTempTolerance;
    this.minTempTolerance = minTempTolerance;
  }

  void draw() {
    push();
    translate(pos.x, pos.y);
    rotate(dir.mult(speed).heading());
    fill(255, 0, 255);
    rectMode(CENTER);
    rect(
      0,
      0,
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
    float temp = (float)config.climate.current;
    energy -= energyPerFrame +
              temp > maxTempTolerance ? (temp - maxTempTolerance) * config.bacteria.heatTolerance.get("heatEnergyFactor") : 0 +
              temp < minTempTolerance ? (minTempTolerance - temp) * config.bacteria.coldTolerance.get("coldEnergyFactor") : 0;
    println("!-------------------");
    println(temp);
    println(maxTempTolerance);
    println(minTempTolerance);

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

    double heatToleranceEpsilon;
    double minHeatTolerance;
    double maxHeatTolerance;

    double coldToleranceEpsilon;
    double minColdTolerance;
    double maxColdTolerance;

    heatToleranceEpsilon = (double)config.amoeba.heatTolerance.get("epsilon");
    minHeatTolerance = (double)config.amoeba.heatTolerance.get("min");
    maxHeatTolerance = (double)config.amoeba.heatTolerance.get("max");

    coldToleranceEpsilon = (double)config.amoeba.coldTolerance.get("epsilon");
    minColdTolerance = (double)config.amoeba.coldTolerance.get("min");
    maxColdTolerance = (double)config.amoeba.coldTolerance.get("max");

    double newSpeed = Math.max(
      Math.min(
      speed +
      (Math.random() < 0.5 ? 1 : - 1) * config.amoeba.speed.get("epsilon") * speed,
      config.amoeba.speed.get("max")),
      config.amoeba.speed.get("min")
      );
    
    double newMaxTempTolerance = Math.max(
      Math.min(
        maxTempTolerance +
        randomGaussian() * heatToleranceEpsilon,
        maxHeatTolerance
      ),
      minHeatTolerance
    );
    
    double newMinTempTolerance = Math.max(
      Math.min(
        minTempTolerance +
        randomGaussian() * coldToleranceEpsilon,
        maxColdTolerance
      ),
      minColdTolerance
    );

    return new Amoeba(pos.copy(), newSpeed, newMaxTempTolerance, newMinTempTolerance);
  }
}
