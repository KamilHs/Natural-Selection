import P5 from "p5";
import { config } from "../config";
import { Creature } from "./creature";
import { Eatable } from "./Eatable";

const width = 10;
const height = 5;

export class Bacteria extends Creature {
  private dir: P5.Vector;
  constructor(p5: P5, pos: P5.Vector, private speed: number) {
    super(p5, config.bacteria.energy, config.bacteria.energyPerFrame, pos);
    this.dir = p5.createVector(0, 0);
  }

  draw(): void {
    this.p5.fill(100, 0, 0);
    this.p5.rect(
      this.pos.x - width / 2,
      this.pos.y - height / 2,
      width,
      height
    );
  }

  eat(energy: number): void {
    this.energy = Math.max(energy + this.energy, config.bacteria.maxEnergy);
  }

  hunt(eatables: Eatable[]) {
    let record: number = Infinity;
    let closest: Eatable | null = null;

    eatables.map((eatable) => {
      const distance = this.distanceTo(eatable.pos);

      if (record > distance) {
        record = distance;
        closest = eatable;
      }
    });

    if (closest) {
      this.dir = P5.Vector.sub(closest.pos, this.pos).normalize();
    }
  }

  live(eatables: Eatable[]): boolean {
    this.energy -= this.energyPerFrame;
    // if (this.energy < 0) return false;

    this.hunt(eatables);
    this.pos.add(this.dir.x * this.speed, this.dir.y * this.speed);
    return true;
  }
}
