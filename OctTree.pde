class OctTree<T extends Location> {
  Cube boundary;
  int capacity;
  boolean divided = false;
  ArrayList<T> points = new ArrayList<T>();
  OctTree northwestpos;
  OctTree northwestneg;
  OctTree northeastpos;
  OctTree northeastneg;
  OctTree southwestpos;
  OctTree southwestneg;
  OctTree southeastpos;
  OctTree southeastneg;

  OctTree(Cube boundary, int capacity) {
    this.boundary = boundary;
    this.capacity = capacity;
  }

  void show() {
    strokeWeight(0.1);
    noFill();
    push();
    translate(boundary.pos.x, boundary.pos.y, boundary.pos.z);
    box(boundary.dim.x, boundary.dim.y, boundary.dim.z);
    pop();
    if (this.divided) {
      northwestpos.show();
      northwestneg.show();
      northeastpos.show();
      northeastneg.show();
      southwestpos.show();
      southwestneg.show();
      southeastpos.show();
      southeastneg.show();
    }

    strokeWeight(4);
    for (T p : points) {
      //point(p.x, p.y);
    }
  }

  boolean insert(T p) {
    if (!this.boundary.contains(p.pos)) {
      return false;
    }

    if (points.size() < this.capacity) {
      points.add(p);
      return true;
    } else {
      if (!this.divided) subdivide();

      boolean result = false;
      if (this.northwestpos.insert(p)) result = true;
      else if (this.northwestneg.insert(p)) result = true;
      else if (this.northeastpos.insert(p)) result = true;
      else if (this.northeastneg.insert(p)) result = true;
      else if (this.southwestpos.insert(p)) result = true;
      else if (this.southwestneg.insert(p)) result = true;
      else if (this.southeastpos.insert(p)) result = true;
      else if (this.southeastneg.insert(p)) result = true;

      return result;
    }
  }

  void clear() {
    this.points = new ArrayList<T>();
    this.divided = false;
    this.northwestpos = null;
    this.northwestneg = null;
    this.northeastpos = null;
    this.northeastneg = null;
    this.southwestpos = null;
    this.southwestneg = null;
    this.southeastpos = null;
    this.southeastneg = null;
  }

  void subdivide() {
    PVector boundPos = this.boundary.pos.copy();
    PVector boundDim = this.boundary.dim.copy().div(2);

    this.northwestpos = new OctTree(new Cube(
      boundPos.copy().add(new PVector(-boundDim.x / 2, -boundDim.y / 2, boundDim.z / 2)),
      boundDim.copy()), this.capacity);
    this.northwestneg = new OctTree(new Cube(
      boundPos.copy().add(new PVector(-boundDim.x / 2, -boundDim.y / 2, -boundDim.z / 2)),
      boundDim.copy()), this.capacity);
    this.northeastpos = new OctTree(new Cube(
      boundPos.copy().add(new PVector(boundDim.x / 2, -boundDim.y / 2, boundDim.z / 2)),
      boundDim.copy()), this.capacity);
    this.northeastneg = new OctTree(new Cube(
      boundPos.copy().add(new PVector(boundDim.x / 2, -boundDim.y / 2, -boundDim.z / 2)),
      boundDim.copy()), this.capacity);
    this.southwestpos = new OctTree(new Cube(
      boundPos.copy().add(new PVector(-boundDim.x / 2, boundDim.y / 2, boundDim.z / 2)),
      boundDim.copy()), this.capacity);
    this.southwestneg = new OctTree(new Cube(
      boundPos.copy().add(new PVector(-boundDim.x / 2, boundDim.y / 2, -boundDim.z / 2)),
      boundDim.copy()), this.capacity);
    this.southeastpos = new OctTree(new Cube(
      boundPos.copy().add(new PVector(boundDim.x / 2, boundDim.y / 2, boundDim.z / 2)),
      boundDim.copy()), this.capacity);
    this.southeastneg = new OctTree(new Cube(
      boundPos.copy().add(new PVector(boundDim.x / 2, boundDim.y / 2, -boundDim.z / 2)),
      boundDim.copy()), this.capacity);

    this.divided = true;
  }

  ArrayList<T> query(Cube range, ArrayList<T> matches) {
    if (!this.boundary.intersects(range)) {
      return matches;
    } else {
      for (T p : points) {
        if (range.contains(p.pos)) {
          matches.add(p);
        }
      }

      if (this.divided) {
        this.northwestpos.query(range, matches);
        this.northwestneg.query(range, matches);
        this.northeastpos.query(range, matches);
        this.northeastneg.query(range, matches);
        this.southwestpos.query(range, matches);
        this.southwestneg.query(range, matches);
        this.southeastpos.query(range, matches);
        this.southeastneg.query(range, matches);
      }
    }

    return matches;
  }
}


class Cube {
  PVector pos;
  PVector dim;

  Cube(PVector pos, PVector dim) {
    this.pos = pos;
    this.dim = dim;
  }

  boolean contains(PVector p) {
    return p.x > this.pos.x - this.dim.x / 2 &&
      p.x < this.pos.x + this.dim.x / 2 &&
      p.y > this.pos.y - this.dim.y / 2 &&
      p.y < this.pos.y + this.dim.y / 2 &&
      p.z > this.pos.z - this.dim.z / 2 &&
      p.z < this.pos.z + this.dim.z / 2;
  }

  boolean intersects(Cube range) {
    return !(range.pos.x - range.dim.x / 2 > this.pos.x + this.dim.x / 2 ||
      range.pos.x + range.dim.x / 2 < this.pos.x - this.dim.x / 2 ||
      range.pos.y - range.dim.y / 2 > this.pos.y + this.dim.y / 2 ||
      range.pos.y + range.dim.y / 2 < this.pos.y - this.dim.y / 2 ||
      range.pos.z - range.dim.z / 2 > this.pos.z + this.dim.z / 2 ||
      range.pos.z + range.dim.z / 2 < this.pos.z - this.dim.z / 2);
  }
}


class Location {
  PVector pos;
}
