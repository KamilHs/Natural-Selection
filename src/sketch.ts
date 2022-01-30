import P5 from "p5";
import { renderPopulation } from "./charts/population";
import { renderSpeeds } from "./charts/speed";
import { Bacteria } from "./classes/Bacteria";
import { Creature } from "./classes/creature";
import { Eatable } from "./classes/Eatable";
import { Flesh } from "./classes/Flesh";

import { config } from "./config";

import "./global";

const populations = {
  amoeba: [],
  bacteria: [],
};

new P5((p5: P5) => {
  const creatures: Creature[] = Bacteria.generate(p5, config.creaturesCount);
  const eatables: Eatable[] = Flesh.generate(p5, config.foodCount);

  p5.setup = () => {
    const canvas = p5.createCanvas(p5.windowWidth, p5.windowHeight);
    canvas.parent("root");
  };

  p5.draw = () => {
    p5.background(config.bg);
    for (let i = 0; i < eatables.length; i++) {
      const eatable = eatables[i];
      if (eatable.eaten) {
        eatables.remove(i);
        i--;
      }
      eatable.draw();
    }
    eatables.forEach((eatable) => eatable.draw());
    if (p5.frameCount % config.foodInterval === 0) {
      eatables.push(...Flesh.generate(p5, config.foodCount));
    }
    for (let i = 0; i < creatures.length; i++) {
      const creature = creatures[i];
      creature.draw();
      creature.live([...eatables, ...creatures]);
      if (creature.willDie()) {
        creatures.remove(i);
        i--;
      } else if (creature.canDivide()) {
        creatures.push(creature.divide());
      }
    }

    renderSpeeds(p5, creatures);
    if (config.charts.population.show) {
      Object.entries(
        creatures.reduce(
          (acc, creature) => {
            const key = creature instanceof Bacteria ? "bacteria" : "amoeba";
            return { ...acc, [key]: acc[key] + 1 };
          },
          { bacteria: 0, amoeba: 0 }
        )
      ).forEach(([species, value], index) => {
        if (p5.frameCount % config.charts.population.frameStep === 0) {
          populations[species].push(value);
        }

        renderPopulation(
          p5,
          populations[species],
          config[species].color,
          index * config.charts.population.height
        );
      });
    }
  };
});
