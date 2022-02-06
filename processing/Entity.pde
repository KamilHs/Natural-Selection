abstract class Entity {
    protected PVector pos;
    abstract void draw();
    abstract boolean isAlive();

    Entity(PVector pos){
        this.pos = pos;
    }
}
