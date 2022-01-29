import P5 from "p5";
import { config as globalConfig } from "../config";
import { Eatable } from "./Eatable";

const config = globalConfig.flesh;
export class Flesh extends Eatable {
  constructor(p5: P5, pos: P5.Vector) {
    super(p5, config.energy, pos);
  }

  static generate(p5: P5, count: number): Flesh[] {
    return Array.from({
      length: count,
    }).map(
      () =>
        new Flesh(
          p5,
          p5.createVector(p5.random(p5.windowWidth), p5.random(p5.windowHeight))
        )
    );
  }

  draw(): void {
    this.p5.push();
    this.p5.noStroke();
    this.p5.fill(config.color);
    this.p5.ellipse(this.pos.x, this.pos.y, config.radius, config.radius);
    this.p5.pop();
  }
}
