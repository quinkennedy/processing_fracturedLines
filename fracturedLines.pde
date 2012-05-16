float diag;
color[] colors = new color[]{color(0,0,0),color(0,0,0),color(255,100,100),color(100,255,100),color(100,100,255),color(255,255,0),color(0,255,255),color(255,0,255)};

void setup(){
  size(400,600,P3D);
  diag = sqrt(width*width+height*height);
  noLoop();
}

void draw(){
  background(255);
  stroke(0);
  smooth();
  fill(248);
  pushMatrix();
    translate(width-250, 70);
    scale(8);
    text("QUIN");
  popMatrix();
  drawFracturedLine(7,true);
}

void drawFracturedLine(int lineWidth, boolean first){
  float angle = first ? random(PI,TWO_PI) : random(TWO_PI);
  float ratioLimit = 1.0;
  float startX, startY;
  color myColor = colors[(int)random(colors.length)];
  pushMatrix();
    findStartPoint();
    rotate(angle);
    if (lineWidth > 2){
      drawFracturedLine(lineWidth - 2, false);
    }
    stroke(myColor);
    strokeWeight(lineWidth);
    line(0,0,0,diag);
  popMatrix();
  if (!first){
    angle += PI;
    pushMatrix();
      findStartPoint();
      rotate(angle);
      if (lineWidth > 2){
        drawFracturedLine(lineWidth - 2, false);
      }
      stroke(myColor);
      strokeWeight(lineWidth);
      line(0,0,0,diag);
    popMatrix();
  }
}

void findStartPoint(){
  float startRatio,startX,startY,ratioLimit = 1.0;
  do {
    popMatrix();
    startRatio = random(ratioLimit);
    pushMatrix();
    translate(0,diag*startRatio);
    startX = modelX(0,0,0);
    startY = modelY(0,0,0);
    ratioLimit = startRatio;
  }while(startX < 0 || startX > width || startY < 0 || startY > height);
}
  
