import P5 from "p5";
import { Eatable } from "./Eatable";

export abstract class Creature {
  protected dead: boolean = false;
  constructor(
    protected p5: P5,
    protected energy: number,
    protected energyPerFrame: number,
    public pos: P5.Vector,
    public speed: number
  ) {}

  abstract eat(energy: number): void;
  abstract draw(): void;
  abstract canDivide(): boolean;
  abstract willDie(): boolean;
  abstract live(eatables: Eatable[]): void;
  protected die(): void {
    this.dead = true;
  }
  abstract divide(): Creature;

  protected distanceTo(target: P5.Vector) {
    return this.p5.dist(this.pos.x, this.pos.y, target.x, target.y);
  }
}
