import P5 from "p5";
import { Bacteria } from "./classes/Bacteria";
import { Creature } from "./classes/creature";
import { Eatable } from "./classes/Eatable";
import { Flesh } from "./classes/Flesh";

import { config } from "./config";

import "./global";

new P5((p5: P5) => {
  console.log(config.bacteria.speed.min + 10);
  
  const creatures: Creature[] = Array.from({
    length: config.creaturesCount,
  }).map(
    () =>
      new Bacteria(
        p5,
        p5.createVector(p5.random(p5.windowWidth), p5.random(p5.windowHeight)),
        // p5.random(config.bacteria.speed.min, config.bacteria.speed.max)
        config.bacteria.speed.min + 4
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
    p5.background(120);
    eatables.forEach((eatable) => eatable.draw());
    if ((p5.frameCount % config.foodInterval) === 0) {
      for (let i = 0; i < config.foodCount; i++) {
        eatables.push(
          new Flesh(
            p5,
            p5.createVector(
              p5.random(p5.windowWidth),
              p5.random(p5.windowHeight)
            )
          )
        );
      }
    }
    for (let i = 0; i < creatures.length; i++) {
      const creature = creatures[i];
      creature.draw();
      creature.live(eatables);
      if (creature.willDie()) {
        creatures.remove(i);
      }else if(creature.canDivide()){
        creatures.push(creature.divide())
      }
    }
  };
});
