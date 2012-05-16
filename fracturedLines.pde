float diag;

void setup(){
  size(400,400,P3D);
  diag = sqrt(width*width+height*height);
  noLoop();
}

void draw(){
  background(255);
  stroke(0);
  drawFracturedLine(8,true);
}

void drawFracturedLine(int lineWidth, boolean first){
  float angle = first ? random(PI,TWO_PI) : random(TWO_PI);
  float ratioLimit = 1.0;
  float startX, startY;
  strokeWeight(lineWidth);
  pushMatrix();
    findStartPoint();
    rotate(angle);
    line(0,0,0,diag);
    if (lineWidth > 1){
      drawFracturedLine(lineWidth - 1, false);
    }
  popMatrix();
  if (!first){
    strokeWeight(lineWidth);
    angle += PI;
    pushMatrix();
      findStartPoint();
      rotate(angle);
      line(0,0,0,diag);
      if (lineWidth > 1){
        drawFracturedLine(lineWidth - 1, false);
      }
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
  }while(startX > 0 && startX < width && startY > 0 && startY < height);
}
  
