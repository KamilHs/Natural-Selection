import P5 from "p5";

export abstract class Eatable {
  public eaten: boolean = false;
  constructor(protected p5: P5, public energy: number, public pos: P5.Vector) {}

  public setEaten(): void {
    this.eaten = true;
  }

  abstract draw(): void;
}
