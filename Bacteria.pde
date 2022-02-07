public class Bacteria extends Creature {
  float speed;
  Bacteria(PVector pos, double speed, double normalTemp) {
    super(pos);
    this.speed = (float)speed;
    energy = config.bacteria.energy.get("initial");
    energyPerFrame = config.bacteria.energy.get("lossPerFrame") +
      Math.max(
      0,
      (speed - config.bacteria.speed.get("initial")) * config.bacteria.speed.get("speedEnergyFactor")
      );
    this.normalTemp = normalTemp;
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
              Math.max((temp - (normalTemp + config.bacteria.temp.get("range"))) * config.bacteria.temp.get("tempEnergyFactor"),0)+
              Math.max(((normalTemp - config.bacteria.temp.get("range")) - temp) * config.bacteria.temp.get("tempEnergyFactor"),0);

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

    double tempEpsilon;
    double maxNormalTemp;
    double minNormalTemp;

    if (Math.random() < (float)config.bacteria.probOfAmoeba) {
      isAmoeba = true;
      speedEpsilon = (double)config.amoeba.speed.get("epsilon");
      maxSpeed = (double)config.amoeba.speed.get("max");
      minSpeed = (double)config.amoeba.speed.get("min");

      tempEpsilon = (double)config.amoeba.temp.get("epsilon");
      maxNormalTemp = (double)config.amoeba.temp.get("max");
      minNormalTemp = (double)config.amoeba.temp.get("min");
    } else {
      speedEpsilon = (double)config.bacteria.speed.get("epsilon");
      maxSpeed = (double)config.bacteria.speed.get("max");
      minSpeed = (double)config.bacteria.speed.get("min");

      tempEpsilon = (double)config.bacteria.temp.get("epsilon");
      maxNormalTemp = (double)config.bacteria.temp.get("max");
      minNormalTemp = (double)config.bacteria.temp.get("min");
    }

    double newSpeed = Math.max(
      Math.min(
      speed +
      (Math.random() < 0.5 ? 1 : - 1) * speedEpsilon * speed,
      maxSpeed
      ),
      minSpeed
      );

    double newNormalTemp = Math.max(
      Math.min(
        normalTemp +
        randomGaussian() * tempEpsilon,
        maxNormalTemp
      ),
      minNormalTemp
    );

    return isAmoeba ? new Amoeba(pos.copy(), newSpeed, newNormalTemp) : new Bacteria(pos.copy(), newSpeed, newNormalTemp);
  }

  void setEaten() {
    this.alive = false;
  }
}
