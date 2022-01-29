export const config = {
  creaturesCount: 1,
  foodInterval: 60,
  foodCount: 60,
  bacteria: {
    energy : {
      max: 1,
      initial: 0.8,
      minForDivide: 0.9,
      lossAfterDivide: 0.5,
      lossPerFrame: 0.01
    },
    speed: {
      min: 1,
      max: 10,
      epsilon: 0.2,
      speedEnergyFactor: 0.0000
    },
    width: 14,
    height: 7,
  },
};
