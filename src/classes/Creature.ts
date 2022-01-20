import P5 from "p5";
import { Eatable } from "./Eatable";

export abstract class Creature {
  constructor(
    protected p5: P5,
    protected energy: number,
    protected energyPerFrame: number,
    public pos: P5.Vector
  ) {}

  abstract eat(energy: number): void;
  abstract draw(): void;

  protected distanceTo(target: P5.Vector) {
    return this.p5.dist(this.pos.x, this.pos.y, target.x, target.y);
  }

  abstract live(eatables: Eatable[]): boolean;
}
