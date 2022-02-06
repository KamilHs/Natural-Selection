public class Bacteria extends Creature {
  float speed;
  Bacteria(PVector pos, double speed, double maxTempTolerance, double minTempTolerance) {
    super(pos);
    this.speed = (float)speed;
    energy = config.bacteria.energy.get("initial");
    energyPerFrame = config.bacteria.energy.get("lossPerFrame") +
      Math.max(
      0,
      (speed - config.bacteria.speed.get("initial")) * config.bacteria.speed.get("speedEnergyFactor")
      );
    this.maxTempTolerance = maxTempTolerance;
    this.minTempTolerance = minTempTolerance;
  }

  void draw() {
    push();
    translate(pos.x, pos.y);
    rotate(dir.heading());
    fill(255, 0, 0);
    rectMode(CENTER);
    rect(
      0,
      0,
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
    age++;
    float temp = (float)config.climate.currentTemp;
    energy -= energyPerFrame +
              Math.max((temp - maxTempTolerance) * config.bacteria.heatTolerance.get("heatEnergyFactor"),0)+
              Math.max((minTempTolerance - temp) * config.bacteria.coldTolerance.get("coldEnergyFactor"),0);

    if (energy < 0 || age > config.bacteria.maxAge) {
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

    double speedEpsilon;
    double maxSpeed;
    double minSpeed;

    double heatToleranceEpsilon;
    double minHeatTolerance;
    double maxHeatTolerance;

    double coldToleranceEpsilon;
    double minColdTolerance;
    double maxColdTolerance;

    if (Math.random() < (float)config.bacteria.probOfAmoeba) {
      isAmoeba = true;
      speedEpsilon = (double)config.amoeba.speed.get("epsilon");
      maxSpeed = (double)config.amoeba.speed.get("max");
      minSpeed = (double)config.amoeba.speed.get("min");

      heatToleranceEpsilon = (double)config.amoeba.heatTolerance.get("epsilon");
      minHeatTolerance = (double)config.amoeba.heatTolerance.get("min");
      maxHeatTolerance = (double)config.amoeba.heatTolerance.get("max");

      coldToleranceEpsilon = (double)config.amoeba.coldTolerance.get("epsilon");
      minColdTolerance = (double)config.amoeba.coldTolerance.get("min");
      maxColdTolerance = (double)config.amoeba.coldTolerance.get("max");
    } else {
      speedEpsilon = (double)config.bacteria.speed.get("epsilon");
      maxSpeed = (double)config.bacteria.speed.get("max");
      minSpeed = (double)config.bacteria.speed.get("min");

      heatToleranceEpsilon = (double)config.bacteria.heatTolerance.get("epsilon");
      minHeatTolerance = (double)config.bacteria.heatTolerance.get("min");
      maxHeatTolerance = (double)config.bacteria.heatTolerance.get("max");

      coldToleranceEpsilon = (double)config.bacteria.coldTolerance.get("epsilon");
      minColdTolerance = (double)config.bacteria.coldTolerance.get("min");
      maxColdTolerance = (double)config.bacteria.coldTolerance.get("max");
    }
  
    double newSpeed = Math.max(
      Math.min(
      speed +
      (Math.random() < 0.5 ? 1 : - 1) * speedEpsilon * speed,
      maxSpeed
      ),
      minSpeed
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

    return isAmoeba ? new Amoeba(pos.copy(), newSpeed, newMaxTempTolerance, newMinTempTolerance):new Bacteria(pos.copy(), newSpeed, newMaxTempTolerance, newMinTempTolerance);
  }

  void setEaten() {
    this.alive = false;
  }
}
