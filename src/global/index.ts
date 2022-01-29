export {};

declare global {
  interface Array<T> {
    remove(index: number): void;
  }
}

if (!Array.prototype.remove) {
  Array.prototype.remove = function (i: number) {
    const self = this as Array<unknown>;
    self[i] = self[self.length - 1];
    self.pop();
  };
}
