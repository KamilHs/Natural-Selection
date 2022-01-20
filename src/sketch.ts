import P5 from "p5";
import { Bacteria } from "./classes/Bacteria";
import { Creature } from "./classes/creature";
import { Eatable } from "./classes/Eatable";
import { Flesh } from "./classes/Flesh";

import { config } from "./config";

new P5((p5: P5) => {
  const creatures: Creature[] = Array.from({
    length: config.creaturesCount,
  }).map(
    () =>
      new Bacteria(
        p5,
        p5.createVector(p5.random(p5.windowWidth), p5.random(p5.windowHeight)),
        p5.random(config.bacteria.minSpeed, config.bacteria.maxSpeed)
      )
  );
  const eatables: Eatable[] = Array.from({
    length: config.foodCount,
  }).map(
    () =>
      new Flesh(
        p5,
        p5.createVector(p5.random(p5.windowWidth), p5.random(p5.windowHeight))
      )
  );

  p5.setup = () => {
    const canvas = p5.createCanvas(p5.windowWidth, p5.windowHeight);
    canvas.parent("root");
  };

  p5.draw = () => {
    p5.background(0, 0, 0);
    eatables.forEach((eatable) => eatable.draw());
    creatures.forEach((creature) => {
      creature.draw();
      creature.live(eatables);
    });
  };
});
