int   LOCAL_DIST = 70;
float MAX_FORCE = 0.25;
float MAX_SPEED = 3;


class Boid extends Location {
  PVector vel, acc;


  Boid(PVector _pos) {
    pos = _pos;
    vel = new PVector();
    acc = new PVector();
  }


  void flock(ArrayList<Boid> boids) {
    int total = 0;

    PVector alignment = new PVector();
    PVector cohesion = new PVector();
    PVector separation = new PVector();

    for (Boid other : boids) {
      float d = pos.dist(other.pos);
      if (other != this && d < LOCAL_DIST) {
        alignment.add(other.vel);
        cohesion.add(other.pos);
        separation.add(pos.copy().sub(other.pos).div(d));
        total++;
      }
    }

    if (total > 0) {
      alignment.div(total)
        .setMag(MAX_SPEED)
        .sub(vel)
        .limit(MAX_FORCE)
        .mult(ALIGNMENT);
      cohesion.div(total)
        .sub(pos)
        .setMag(MAX_SPEED)
        .sub(vel)
        .limit(MAX_FORCE)
        .mult(COHESION);
      separation.div(total)
        .setMag(MAX_SPEED)
        .sub(vel)
        .limit(MAX_FORCE)
        .mult(SEPARATION);
    }

    acc.add(alignment).add(cohesion).add(separation);
  }


  void update() {
    vel.add(acc).setMag(MAX_SPEED);
    pos.add(vel);
    acc.mult(0);
  }


  void show() {
    point(pos.x, pos.y, pos.z);
  }
}
