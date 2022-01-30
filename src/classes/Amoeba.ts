import P5 from "p5";
import { config as globalConfig } from "../config";
import { Bacteria } from "./Bacteria";
import { Creature } from "./creature";
import { Entity } from "./Entity";

const config = globalConfig.amoeba;

export class Amoeba extends Creature {
  private dir: P5.Vector;
  private prey: Bacteria | null = null;
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

  static generate(p5: P5, count: number): Amoeba[] {
    return Array.from({
      length: count,
    }).map(
      () =>
        new Amoeba(
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

  hunt(entities: Entity[]) {
    let record: number = Infinity;
    let closest: Bacteria | null = null;

    if (!this.prey || !this.prey.alive) {
      entities.forEach((entity) => {
        if (!(entity instanceof Bacteria)) return;
        const distance = this.distanceTo(entity.pos);

        if (record > distance + 10) {
          record = distance;
          closest = entity;
        }
      });

      this.prey = closest;
    }

    if (this.prey && this.prey.alive) {
      this.dir = P5.Vector.sub(this.prey.pos, this.pos).normalize();

      if (this.distanceTo(this.prey.pos) < this.speed) {
        this.eat(this.prey.kill());
        this.prey = null;
      }
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

  divide(): Amoeba {
    this.energy -= config.energy.lossAfterDivide;

    const speed = Math.max(
      Math.min(
        this.speed +
          (Math.random() < 0.5 ? 1 : -1) * config.speed.epsilon * this.speed,
        config.speed.max
      ),
      config.speed.min
    );

    return new Amoeba(this.p5, this.pos.copy(), speed);
  }

  live(entities: Entity[]): void {
    this.energy -= this.energyPerFrame;
    this.hunt(entities);
    this.pos.add(this.dir.x * this.speed, this.dir.y * this.speed);
  }
}
