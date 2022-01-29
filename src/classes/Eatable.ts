import P5 from "p5";

export abstract class Eatable {
  constructor(protected p5: P5, public energy: number, public pos: P5.Vector) {}

  abstract draw(): void;
}
