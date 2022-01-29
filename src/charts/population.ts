import P5 from "p5";

import { config as globalConfig } from "../config";

const config = globalConfig.charts.population;

const populations = [];

export const renderPopulation = (p5: P5, population: number) => {
  if (config.show) {
    if (p5.frameCount % config.frameStep) {
      populations.push(population);
      if (populations.length >= p5.width / config.tick) {
        populations.shift();
      }
    }

    p5.push();
    p5.fill(config.bg);
    p5.stroke(config.itemColor);
    p5.strokeWeight(config.tick);
    p5.rect(0, p5.height - config.height, p5.width, config.height);

    const max = Math.max(...populations);

    populations.forEach((population, i) =>
      p5.line(
        i * config.tick,
        p5.height,
        i * config.tick,
        p5.height -
          p5.map(population, 0, config.maxValue || max, 0, config.height)
      )
    );
    p5.pop();
  }
};
