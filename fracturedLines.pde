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
  findLargestWhiteSpace();
}

void findLargestWhiteSpace(){
  loadPixels();
  int[] indices = new int[pixels.length];
  int[] counts = new int[pixels.length];
  color white = color(255,255,255);
  for(int i = 0; i < pixels.length; i++){
    indices[i] = pixels[i] == white ? i : -1;
    counts[i] = pixels[i] == white ? 1 : 0;
  }
  
  boolean changed = false;
  boolean onLeft = false;
  boolean onRight = true;
  boolean onTop = true;
  boolean onBottom = height == 1;
  do{
    onBottom = height == 1;
    onTop = true;
    changed = false;
    for(int i = 0; i < indices.length; i++){
      if (onTop && i >= width){
        onTop = false;
      }
      if (!onBottom && i >= indices.length - width){
        onBottom = true;
      }
      if (onRight){
        onRight = width == 1;
        onLeft = true;
      } else if (onLeft){
        onLeft = false;
      } else {
        onRight = i % width == width - 1;
      }
      
      if (indices[i] == -1){
        continue;
      }
      int checkAgainst = i-width;
      changed |= handleComparison(indices, counts, onTop, i, i-width);
      changed |= handleComparison(indices, counts, onRight, i, i + 1);
      changed |= handleComparison(indices, counts, onBottom, i, i+width);
      changed |= handleComparison(indices, counts, onLeft, i, i - 1);
    }
  }while(changed);
  
  int[] sortedIndices = getSortedIndices(counts);
  
  for(int i = 0; i < pixels.length; i++){
    if (indices[i] == sortedIndices[0]){
      pixels[i] = indices[i];
    }
  }
  
  updatePixels();
}

int[] getSortedIndices(int[] counts){
  ArrayList<Integer> sorted = new ArrayList<Integer>();
  int lastMaxValue = -1;
  int currMaxValue = 0;
  int currMaxIndex = 0;
  do{
    currMaxValue = 0;
    for(int i = 0; i < counts.length; i++){
      if (counts[i] > currMaxValue && (lastMaxValue < 0 || lastMaxValue > counts[i])){
        currMaxIndex = i;
        currMaxValue = counts[i];
      }
    }
    if (currMaxValue == 0){
      break;
    }
    sorted.add(currMaxIndex);
    lastMaxValue = counts[currMaxIndex];
  }while(lastMaxValue > 0);
  
  int[] output = new int[sorted.size()];
  for(int i = 0; i < sorted.size(); i++){
    output[i] = sorted.get(i);
    println(counts[output[i]]);
  }
  return output;
}

boolean handleComparison(int[] indices, int[] counts, boolean onSide, int index, int checkAgainst){
  if (!onSide && indices[index] < indices[checkAgainst]){
    counts[indices[checkAgainst]]--;
    indices[checkAgainst] = indices[index];
    counts[indices[checkAgainst]]++;
    return true;
  }
  return false;
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
  
