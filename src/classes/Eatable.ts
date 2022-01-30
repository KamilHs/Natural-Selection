import P5 from "p5";
import { Entity } from "./Entity";

export abstract class Eatable extends Entity {
  public eaten: boolean = false;
  constructor(protected p5: P5, public energy: number, public pos: P5.Vector) {
    super();
  }

  public setEaten(): void {
    this.eaten = true;
  }
}
