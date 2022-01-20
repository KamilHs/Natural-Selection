import P5 from "p5";

new P5((p5: P5) => {
  p5.setup = () => {
    const canvas = p5.createCanvas(p5.windowWidth, p5.windowHeight);
    canvas.parent("root");
  };

  p5.draw = () => {
    p5.background(100, 0, 0);
  };
});
