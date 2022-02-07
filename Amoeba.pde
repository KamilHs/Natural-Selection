public class Amoeba extends Creature {
  float speed;
  Amoeba(PVector pos, double speed, double normalTemp) {
    super(pos);
    this.speed = (float)speed;
    energy = config.amoeba.energy.get("initial");
    energyPerFrame = config.amoeba.energy.get("lossPerFrame") +
      Math.max(
      0,
      (speed - config.amoeba.speed.get("initial")) * config.amoeba.speed.get("speedEnergyFactor")
      );
    this.normalTemp = normalTemp;
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
    age++;
    float temp = (float)config.climate.currentTemp;
    energy -= energyPerFrame +
      Math.max((temp - (normalTemp + config.amoeba.temp.get("range"))) * config.amoeba.temp.get("tempEnergyFactor"), 0) +
      Math.max(((normalTemp - config.amoeba.temp.get("range")) - temp) * config.amoeba.temp.get("tempEnergyFactor"), 0);

    if (energy < 0 || age > config.amoeba.maxAge) {
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

    double tempEpsilon;
    double maxNormalTemp;
    double minNormalTemp;

    tempEpsilon = (double)config.amoeba.temp.get("epsilon");
    maxNormalTemp = (double)config.amoeba.temp.get("max");
    minNormalTemp = (double)config.amoeba.temp.get("min");

    double newSpeed = Math.max(
      Math.min(
      speed +
      (Math.random() < 0.5 ? 1 : - 1) * config.amoeba.speed.get("epsilon") * speed,
      config.amoeba.speed.get("max")),
      config.amoeba.speed.get("min")
      );

    double newNormalTemp = Math.max(
      Math.min(
        normalTemp +
        randomGaussian() * tempEpsilon,
        maxNormalTemp
      ),
      minNormalTemp
    );

    return new Amoeba(pos.copy(), newSpeed, newNormalTemp);
  }
}
