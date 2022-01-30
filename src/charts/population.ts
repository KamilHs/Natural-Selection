import P5 from "p5";

import { config as globalConfig } from "../config";

const config = globalConfig.charts.population;

export const renderPopulation = (
  p5: P5,
  populations: number[],
  color: number[],
  offsetBottom: number = 0
) => {
  if (config.show) {
    const y0 = p5.height - offsetBottom;
    if (p5.frameCount % config.frameStep === 0) {
      if (populations.length >= p5.width / config.tick) {
        populations.shift();
      }
    }

    p5.push();
    p5.fill(config.bg);
    p5.stroke(color);
    p5.strokeWeight(config.tick);
    p5.rect(0, y0 - config.height, p5.width, config.height);

    const max = Math.max(...populations);

    populations.forEach((population, i) =>
      p5.line(
        i * config.tick,
        y0,
        i * config.tick,
        y0 - p5.map(population, 0, config.maxValue || max, 0, config.height)
      )
    );
    p5.pop();
  }
};
