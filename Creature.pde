abstract class Creature extends Entity {
  protected double energy;
  protected double energyPerFrame;
  protected PVector dir;
  protected boolean alive = true;
  protected double normalTemp;
  protected int age = 0;

  Creature(PVector pos) {
    super(pos);
    this.dir = new PVector(0, 0);
  }

  abstract void live(ArrayList<Entity> entities);

  protected boolean canReplicate() {
    return false;
  }

  protected Creature replicate() {
    return null;
  }
}
