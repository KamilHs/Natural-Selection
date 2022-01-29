import P5 from "p5";
import { Creature } from "../classes/creature";

import { config as globalConfig } from "../config";

const chartConfig = globalConfig.charts.speed;

export const renderSpeeds = (p5: P5, creatures: Creature[]) => {
  if (chartConfig.show) {
    const x0 = p5.width - chartConfig.width;
    const y0 = 0;

    const hist: Record<number, number> = creatures.reduce((acc, creature) => {
      let intSpeed = p5.floor(creature.speed);
      return { ...acc, [intSpeed]: (acc[intSpeed] ?? 0) + 1 };
    }, {});
    const total = creatures.length;
    const tick =
      chartConfig.width /
      (globalConfig.bacteria.speed.max - globalConfig.bacteria.speed.min + 1);
    p5.push();
    p5.noStroke();
    p5.fill(chartConfig.bg);
    p5.rect(x0, y0, chartConfig.width, chartConfig.height);
    p5.fill(chartConfig.itemColor);

    Object.entries(hist).forEach(([v, f]) => {
      p5.rect(
        (+v - globalConfig.bacteria.speed.min) * tick + x0,
        y0 + chartConfig.height,
        tick,
        -p5.map(f, 0, total, 0, chartConfig.height)
      );
    });
    p5.pop();
  }
};
