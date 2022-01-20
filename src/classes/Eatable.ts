import P5 from "p5";

export abstract class Eatable {
  constructor(protected p5: P5, protected energy: number, public pos: P5.Vector) {}

  abstract draw(): void;
}
