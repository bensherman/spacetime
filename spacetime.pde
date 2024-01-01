ArrayList<Particle> particles = new ArrayList<Particle>();

float ACCELERATION = 1.0007;

float SHRINK_BY = .85;
float MAX_VELOCITY = 5;
float MIN_SIZE = 2;
PVector INITIAL_VELOCITY = new PVector(1/MAX_VELOCITY,1/MAX_VELOCITY);

long MAX_PARTICLES = 20000;

String dir_name = year() + month() + day() + "-" + hour() + minute() + second() + "/";


void setup() {
  //fullScreen();
  size(540, 540);
  //noSmooth();
  rectMode(RADIUS);
  strokeWeight(0);
  //surface.setResizable(true);
  create_particle();
  background(0);
  println("dir_name: ", dir_name);
}

void draw() {
  background(0);
  update_particles();
  if (frameCount % 100 == 0) {
    println("Frame Count: ", frameCount);
    println("Particle Size: ", particles.size());
    println("Frame Rate: ", frameRate);
    println("last velocity magnitude: ", particles.get(particles.size() - 1).velocity.mag());
    println("accelleration: ", ACCELERATION);
  }
  // saveFrame(dir_name + "frame-####.jpg");
}

void create_particle() {
  Particle p = new Particle();
  p.velocity = INITIAL_VELOCITY.copy();
  p.velocity.rotate(random( -PI, PI));
  particles.add(p);
}

void update_particles() {
  ArrayList<Particle> new_particles = new ArrayList<Particle>();
  for (Particle p : particles) {
    p.velocity.mult(ACCELERATION + random(ACCELERATION - 1));
    p.position.add(p.velocity);
    if (p.off_screen()) {
      if (p.too_fast()) {
        p.slow_down();
      }
      if (particles.size() < MAX_PARTICLES + frameCount) {
        Particle p_2 = p.copy();
        p_2.reset();
        new_particles.add(p_2);
      }
      p.reset();
    } else {
      fill(p.c);
      rect(p.position.x, p.position.y, p.size.x, p.size.y);
    }
  }
  particles.addAll(new_particles);
}

class Particle {
  PVector position;
  PVector velocity;
  PVector size;
  color c;

  Particle() {
    position = new PVector(width / 2, height / 2);
    velocity = INITIAL_VELOCITY.copy();
    size = new PVector(width / 4, width / 4);
    randomize_color();
  }

  Particle copy() {
    Particle p = new Particle();
    p.position = position.copy();
    p.velocity = velocity.copy();
    p.size = size.copy();
    p.c = c;
    return p;
  }

  void randomize_color() {
    c = color(int(random(10)) * 25, int(random(10)) * 25, int(random(10)) * 25);
  }

  boolean off_screen() {
    return position.x - size.x < 0 ||
    position.y - size.y < 0 ||
    position.x + size.x > width ||
    position.y + size.y > height;
  }

  boolean invisible() {
    return size.x < MIN_SIZE || size.y < MIN_SIZE;
  }

  void resize() {
    size.mult(SHRINK_BY);
    if (invisible()) {
      size.x = MIN_SIZE;
      size.y = MIN_SIZE;
    }
  }

  void slow_down() {
    velocity = INITIAL_VELOCITY.copy();
    velocity.rotate(random(PI,2* PI));
  }

  boolean too_fast() {
    return velocity.mag() > MAX_VELOCITY;
  }

  void recenter() {
    //if (mouseButton == LEFT) {
    //  position.x = mouseX;
    //  position.y = mouseY;
    //} else {
    //  position = new PVector((width / 2),(height / 2));
    //}
    position.x = width / 2;
    position.y = height / 2;
    velocity.rotate(random( -PI, PI));
  }

  void reset() {
    recenter();
    resize();
    randomize_color();
  }
}
