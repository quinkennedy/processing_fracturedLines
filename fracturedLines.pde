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

int COUNT = 0;
int MIN_X = 1;
int MIN_Y = 2;
int MAX_X = 3;
int MAX_Y = 4;
void findLargestWhiteSpace(){
  loadPixels();
  int[] indices = new int[pixels.length];
  int[][] data = new int[pixels.length][5];
  color white = color(255,255,255);
  int currX = 0;
  int currY = 0;
  for(int i = 0; i < pixels.length; i++){
    indices[i] = pixels[i] == white ? i : -1;
    data[i][COUNT] = pixels[i] == white ? 1 : 0;
    data[i][MIN_X] = currX;
    data[i][MIN_Y] = currY;
    data[i][MAX_X] = currX;
    data[i][MAX_Y] = currY;
    currX++;
    if (currX >= width){
      currX = 0;
      currY++;
    }
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
      changed |= handleComparison(indices, data, onTop, i, i-width);
      changed |= handleComparison(indices, data, onRight, i, i + 1);
      changed |= handleComparison(indices, data, onBottom, i, i+width);
      changed |= handleComparison(indices, data, onLeft, i, i - 1);
    }
  }while(changed);
  
  int[] sortedIndices = getSortedIndices(data);
  
  for(int i = 0; i < pixels.length; i++){
    if (indices[i] == sortedIndices[0]){
      pixels[i] = indices[i];
    }
  }
  
  updatePixels();
  
  fill(255,100,0);
  ellipse(data[sortedIndices[0]][MIN_X],data[sortedIndices[0]][MIN_Y],5,5);
  ellipse(data[sortedIndices[0]][MAX_X],data[sortedIndices[0]][MAX_Y],5,5);
  fill(255);
  ellipse((data[sortedIndices[0]][MAX_X]-data[sortedIndices[0]][MIN_X])/2+data[sortedIndices[0]][MIN_X],(data[sortedIndices[0]][MAX_Y]-data[sortedIndices[0]][MIN_Y])/2+data[sortedIndices[0]][MIN_Y],5,5);
}

int[] getSortedIndices(int[][] data){
  ArrayList<Integer> sorted = new ArrayList<Integer>();
  int lastMaxValue = -1;
  int currMaxValue = 0;
  int currMaxIndex = 0;
  do{
    currMaxValue = 0;
    for(int i = 0; i < data.length; i++){
      if (data[i][COUNT] > currMaxValue && (lastMaxValue < 0 || lastMaxValue > data[i][COUNT])){
        currMaxIndex = i;
        currMaxValue = data[i][COUNT];
      }
    }
    if (currMaxValue == 0){
      break;
    }
    sorted.add(currMaxIndex);
    lastMaxValue = data[currMaxIndex][COUNT];
  }while(lastMaxValue > 0);
  
  int[] output = new int[sorted.size()];
  for(int i = 0; i < sorted.size(); i++){
    output[i] = sorted.get(i);
    println(data[output[i]][COUNT]);
  }
  return output;
}

boolean handleComparison(int[] indices, int[][] data, boolean onSide, int index, int checkAgainst){
  if (!onSide && indices[index] < indices[checkAgainst]){
    data[indices[index]][MIN_X] = min(data[indices[checkAgainst]][MIN_X], data[indices[index]][MIN_X]);
    data[indices[index]][MIN_Y] = min(data[indices[checkAgainst]][MIN_Y], data[indices[index]][MIN_Y]);
    data[indices[index]][MAX_X] = max(data[indices[checkAgainst]][MAX_X], data[indices[index]][MAX_X]);
    data[indices[index]][MAX_Y] = max(data[indices[checkAgainst]][MAX_Y], data[indices[index]][MAX_Y]);
    data[indices[checkAgainst]][COUNT]--;
    indices[checkAgainst] = indices[index];
    data[indices[checkAgainst]][COUNT]++;
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
  
