import P5 from "p5";
import { renderPopulation } from "./charts/population";
import { Bacteria } from "./classes/Bacteria";
import { Creature } from "./classes/creature";
import { Eatable } from "./classes/Eatable";
import { Flesh } from "./classes/Flesh";

import { config } from "./config";

import "./global";

const populations = [];

new P5((p5: P5) => {
  const creatures: Creature[] = Bacteria.generate(p5, config.creaturesCount);
  const eatables: Eatable[] = Flesh.generate(p5, config.foodCount);


  p5.setup = () => {
    const canvas = p5.createCanvas(p5.windowWidth, p5.windowHeight);
    canvas.parent("root");
  };

  p5.draw = () => {
    p5.background(config.bg);
    eatables.forEach((eatable) => eatable.draw());
    if (p5.frameCount % config.foodInterval === 0) {
      eatables.push(...Flesh.generate(p5, config.foodCount));
    }
    for (let i = 0; i < creatures.length; i++) {
      const creature = creatures[i];
      creature.draw();
      creature.live(eatables);
      if (creature.willDie()) {
        creatures.remove(i);
      } else if (creature.canDivide()) {
        creatures.push(creature.divide());
      }
    }

    renderPopulation(p5, creatures.length);
  };
});
