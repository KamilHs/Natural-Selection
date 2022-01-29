import P5 from "p5";
import { config as globalConfig } from "../config";
import { Creature } from "./creature";
import { Eatable } from "./Eatable";

const config = globalConfig.bacteria;

export class Bacteria extends Creature {
  private dir: P5.Vector;
  constructor(p5: P5, pos: P5.Vector, speed: number) {
    super(
      p5,
      config.energy.initial,
      config.energy.lossPerFrame +
        Math.max(
          0,
          (speed - config.speed.initial) * config.speed.speedEnergyFactor
        ),
      pos,
      speed
    );

    this.dir = p5.createVector(0, 0);
  }

  static generate(p5: P5, count: number): Bacteria[] {
    return Array.from({
      length: count,
    }).map(
      () =>
        new Bacteria(
          p5,
          p5.createVector(
            p5.random(p5.windowWidth),
            p5.random(p5.windowHeight)
          ),
          p5.random(config.speed.min, config.speed.max)
        )
    );
  }

  draw(): void {
    this.p5.push();
    this.p5.noStroke();
    this.p5.fill(config.color);
    this.p5.rect(
      this.pos.x - config.width / 2,
      this.pos.y - config.height / 2,
      config.width,
      config.height
    );
    this.p5.pop();
  }

  eat(energy: number): void {
    this.energy = Math.min(energy + this.energy, config.energy.max);
  }

  hunt(eatables: Eatable[]) {
    let record: number = Infinity;
    let closestIndex: number | null = null;

    eatables.map((eatable, i) => {
      const distance = this.distanceTo(eatable.pos);

      if (record > distance + 10) {
        record = distance;
        closestIndex = i;
      }
    });

    const closest = eatables[closestIndex];

    if (closest) {
      if (record < this.speed) {
        this.eat(closest.energy);
        eatables.remove(closestIndex);
      }
      this.dir = P5.Vector.sub(closest.pos, this.pos).normalize();
    } else {
      this.dir = this.p5.createVector(0, 0);
    }
  }

  canDivide(): boolean {
    return this.energy > config.energy.minForDivide;
  }

  willDie(): boolean {
    return this.energy < 0;
  }

  divide(): Creature {
    this.energy -= config.energy.lossAfterDivide;

    const speed = Math.max(
      Math.min(
        this.speed +
          (Math.random() < 0.5 ? 1 : -1) * config.speed.epsilon * this.speed,
        config.speed.max
      ),
      config.speed.min
    );

    return new Bacteria(this.p5, this.pos.copy(), speed);
  }

  live(eatables: Eatable[]): void {
    this.energy -= this.energyPerFrame;
    this.hunt(eatables);
    this.pos.add(this.dir.x * this.speed, this.dir.y * this.speed);
  }
}
