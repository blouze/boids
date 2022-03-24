import peasy.*;
PeasyCam cam;

ArrayList<Boid> boids = new ArrayList<Boid>();
OctTree<Boid> oTree;

UI ui;
boolean rendering;

float ALIGNMENT  = 3.0;
float COHESION   = 3.0;
float SEPARATION = 3.5;
float TRAILS     = 0.7;
int[][] palettes = {
  { #4B93AD, #FFDEBA },
  { #BDCED9, #8C7F6C },
  { #BAFFD8, #A34D46 },
};
int PALETTE = 2;


void setup() {
  size(960, 960, P3D);
  colorMode(HSB, 1);
  smooth(8);

  cam = new PeasyCam(this, width * 2.25);
  cam.setMinimumDistance(150);
  cam.setMaximumDistance(width * 5.0);
  cam.beginHUD();
  fill(0.18);
  rect(0, 0, width, height);
  cam.endHUD();

  ui = new UI(this);

  PVector dim = new PVector(1, 1, 1).mult(width * 1.5);
  oTree = new OctTree<Boid>(new Cube(new PVector(), dim), 4);

  int num_boids = 5000;
  for (int i = 0; i < num_boids; i++) {
    PVector pos = getRandomPos();
    Boid boid = new Boid(pos);
    boid.vel = getRandomPos().normalize().mult(MAX_SPEED);
    boids.add(boid);
    oTree.insert(boid);
  }

  rendering = false;
}


void mouseClicked() {
  if (mouseButton == RIGHT) {
    rendering = true;
  }
}


void draw() {
  cam.beginHUD();
  fill(color(palettes[PALETTE][0]), 1 - TRAILS);
  rect(0, 0, width, height);
  if (!rendering) {
    cp5.draw();
  }
  cam.endHUD();
  cam.rotateX(-0.005);
  cam.rotateY(0.001);

  oTree.clear();
  for (Boid boid : boids) {
    oTree.insert(boid);
  }

  for (Boid boid : boids) {
    ArrayList<Boid> matches = new ArrayList<Boid>();
    oTree.query(new Cube(boid.pos, new PVector(1, 1, 1).mult(LOCAL_DIST)), matches);

    boid.flock(matches);
  }
  
  stroke(palettes[PALETTE][1]);
  strokeWeight(2.5);
  for (Boid boid : boids) {
    if (boid.pos.mag() > width * 0.75) {
      boid.acc.add(new PVector().sub(boid.pos).normalize().mult(MAX_FORCE));
    }
    boid.update();
    boid.show();
  }

  stroke(0);
  //oTree.show();

  if (rendering) {
    saveFrame("output/frame####.png");
  }
}


PVector getRandomPos() {
  float r = pow(random(0.0, 1.0), 1 / 3.0);
  // avoid bizarre streak of points...
  // https://karthikkaranth.me/blog/generating-random-points-in-a-sphere/
  //float theta = random(TWO_PI);
  float theta = acos(random(2) - 1);
  float sinTheta = sin(theta);
  float cosTheta = cos(theta);

  float phi = random(TWO_PI);
  float sinPhi = sin(phi);
  float cosPhi = cos(phi);

  float x = r * sinTheta * cosPhi;
  float y = r * sinTheta * sinPhi;
  float z = r * cosTheta;

  return new PVector(x, y, z).mult(width * 1.0);
}
