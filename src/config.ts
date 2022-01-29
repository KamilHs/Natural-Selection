export const config = {
  bg: [230],
  creaturesCount: 1,
  foodInterval: 30,
  foodCount: 60,
  flesh: {
    energy: 0.2,
    radius: 5,
    color: [0, 0, 255],
  },
  bacteria: {
    color: [255, 0, 0],
    energy: {
      max: 1,
      initial: 0.8,
      minForDivide: 0.9,
      lossAfterDivide: 0.5,
      lossPerFrame: 0.005,
    },
    speed: {
      min: 1,
      initial: 4,
      max: 10,
      epsilon: 0.2,
      speedEnergyFactor: 0.005,
    },
    width: 14,
    height: 7,
  },
};
