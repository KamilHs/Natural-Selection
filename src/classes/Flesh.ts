import P5 from "p5";
import { Eatable } from "./Eatable";

const energy = 0.2;
const r = 5;

export class Flesh extends Eatable {
  public color: number = 0;
  constructor(p5: P5, pos: P5.Vector) {
    super(p5, energy, pos);
  }

  draw(): void {
    this.p5.push();
    this.p5.noStroke();
    this.p5.fill(this.color, 0, 255);
    this.p5.ellipse(this.pos.x, this.pos.y, r, r);
    this.p5.pop();
  }
}
