import processing.pdf.*;

String[] pieces = new String[]{
"quinkennedy@gmail.com",
"coding&stuff",
"quinkennedy.com"};
float diag;
//color[] colors = new color[]{color(0), color(255), color(255,0,255)};
color[] colors = new color[]{color(0), color(255, 0, 255), color(255, 255, 0)};
//new color[]{color(0,0,0),color(0,0,0,100),color(0,0,0,200),color(255),color(255,255,255,100), color(255,255,255,200)};
//new color[]{color(0,0,0),color(0,0,0),color(255,100,100),color(100,255,100),color(100,100,255),color(255,255,0),color(0,255,255),color(255,0,255)};
PGraphics test;
static float BUSINESS_CARD_LONG = 3.5;
static float BUSINESS_CARD_SHORT = 2;
static int PPI_VIEW = 113;//200;//113
static int PPI_TEST = 50;//200;
static int PPI_PDF = 300;
static int START_WIDTH_ACTUAL = 7;
static int STEP_SIZE_ACTUAL = 2;
static float TEST_RATIO = ((float)PPI_TEST) / PPI_VIEW;
static float PDF_RATIO = ((float)PPI_PDF) / PPI_VIEW;
PImage imgBack;
static int TEXT_SIZE = 12;
static int TEXT_V_SPACING = 4;
color headerColor = color(0, 0, 0, 50);// color(255,255,255,50);//,150,20);//248
color textColor = color(0);
PGraphicsPDF pdf;

void setup(){
  size((int)(PPI_VIEW * BUSINESS_CARD_SHORT),(int)(PPI_VIEW * BUSINESS_CARD_LONG),P2D);
  test = createGraphics((int)(PPI_TEST * BUSINESS_CARD_SHORT),(int)(PPI_TEST * BUSINESS_CARD_LONG),P3D);
  pdf = (PGraphicsPDF)createGraphics((int)(300*BUSINESS_CARD_SHORT),(int)(300*BUSINESS_CARD_LONG),PDF,"output.pdf");
  strokeCap(ROUND);
  //pdf.strokeCap(ROUND);
  diag = sqrt(width*width+height*height);
  loadBackgroundImg();
  //imgBack = loadImage("background.jpg");
  //textSize(TEXT_SIZE);
  noLoop();
}

void loadBackgroundImg(){
  String imgname = (int)random(15)+"-cropped.jpg";
  println(imgname);
  imgBack = loadImage(imgname);
}

void drawBackground(){
  //background(255);
  //float imgBackRatio = PPI_VIEW/350.0f;
  //int imgBackYOffset = -(int)random(imgBack.height*imgBackRatio-height);
  //image(imgBack, 0, imgBackYOffset, imgBackRatio*imgBack.width, imgBackRatio*imgBack.height);
//  background(imgBack);
  boolean bRotate = random(1) < .5;
  int backgroundHeight = bRotate ? imgBack.width : imgBack.height;
  int backgroundWidth = bRotate ? imgBack.height : imgBack.width;
//  float minSize = ;
//  float maxSize = ;
//  float backgroundSize = random(minSize, maxSize);
  test.background(255);
  pdf.background(255);
  return;/*
  pdf.background(204);
  pushMatrix();
  pdf.pushMatrix();
    translate(width/2, height/2);
    pdf.translate(pdf.width/2, pdf.height/2);
    if (bRotate){
      rotate(PI/2);
      pdf.rotate(PI/2);
    }
    imageMode(CENTER);
    pdf.imageMode(CENTER);
    float imgBackRatio = (float)max(height,width)/imgBack.width;
    image(imgBack, 0, 0, imgBackRatio*imgBack.width, imgBackRatio*imgBack.height);
    imgBackRatio *= PDF_RATIO;
    pdf.image(imgBack, 0, 0, imgBackRatio*imgBack.width, imgBackRatio*imgBack.height);
  popMatrix();
  pdf.popMatrix();*/
 // pdf.image(imgBack, 0, imgBackYOffset*PDF_RATIO, 
 //   imgBackRatio*imgBack.width*PDF_RATIO, 
 //   imgBackRatio*imgBack.height*PDF_RATIO);
}

void draw(){
  test.beginDraw();
  pdf.beginDraw();
  drawBackground();
  smooth();
  pdf.smooth();
  fill(headerColor);
  pdf.fill(headerColor);
  pushMatrix();
  pdf.pushMatrix();
    translate(width-(PPI_VIEW-5)/*250*/, PPI_VIEW/3.3f/*70*/);
    pdf.translate(pdf.width-((int)((PPI_VIEW-5)*PDF_RATIO)),((int)(PPI_VIEW/3.3f*PDF_RATIO)));
    scale(PPI_VIEW*8/200);
    pdf.scale(((int)(PPI_VIEW*8/200*PDF_RATIO)));
    text("QUIN", 0, 0);
    pdf.text("QUIN", 0, 0);
  popMatrix();
  pdf.popMatrix();
  pushMatrix();
  pdf.pushMatrix();
    translate(-7, PPI_VIEW*(BUSINESS_CARD_LONG));
    pdf.translate(-7*PDF_RATIO, (PPI_VIEW*(BUSINESS_CARD_LONG)*PDF_RATIO));
    scale(PPI_VIEW*8/200);
    pdf.scale(PPI_VIEW*8/200*PDF_RATIO);
    text("KENNEDY", 0, 0);
    pdf.text("KENNEDY", 0, 0);
  popMatrix();
  pdf.popMatrix();
  drawFracturedLine(START_WIDTH_ACTUAL,true);
  test.endDraw();
  int[][] result = findLargeWhiteSpaces();
  
  int[] textOffset = getTextOffset();
  
  textAlign(LEFT);
  pdf.textAlign(LEFT);
  fill(textColor);
  pdf.fill(textColor);
  textLeading(TEXT_SIZE + TEXT_V_SPACING);
  String textLines = collectText();
  pushMatrix();
  pdf.textSize(14*PDF_RATIO);
  pdf.pushMatrix();
    float textTranslateX = result[0][COG_X]/TEST_RATIO+textOffset[0];
    float textTranslateY = result[0][COG_Y]/TEST_RATIO+textOffset[1];
    translate(textTranslateX,textTranslateY);
    pdf.translate(textTranslateX*PDF_RATIO, textTranslateY*PDF_RATIO);
    text(textLines, 0, 0);
    pdf.text(textLines, 0, 0);
  popMatrix();
  pdf.popMatrix();
//  for(int i = 0; i < pieces.length && i < result.length; i++){
//    pushMatrix();
//      translate(result[i][COG_X]/TEST_RATIO,result[i][COG_Y]/TEST_RATIO);
//      //rotate(result[i][MAX_X] - result[i][MIN_X] < result[i][MAX_Y] - result[i][MIN_Y] ? (random(2) < 1 ? PI/2 : PI*3/2) : (random(2) < 1 ? 0 : PI));
//      text(pieces[i],0,0);
//    popMatrix();
//  }
  //image(test,0,0,width, height);
  pdf.dispose();
  pdf.endDraw();
}

String collectText(){
  String output = "";
  for(int i = 0; i < pieces.length; i++){
    output += pieces[i] + (i == pieces.length - 1 ? "" : "\n");
  }
  return output;
}

int TEXT_MIN_X = 0;
int TEXT_MIN_Y = 1;
int TEXT_WIDTH = 2;
int TEXT_HEIGHT = 3;
int[] getTextOffset(){
  int widthSum = 0;
  int maxWidth = 0;
  int currWidth;
  for(int i = 0; i < pieces.length; i++){
    currWidth = (int)textWidth(pieces[i]);
    widthSum += currWidth;
    if (currWidth > maxWidth){
      maxWidth = currWidth;
    }
  }
  int allTextHeight = (TEXT_SIZE + TEXT_V_SPACING)*pieces.length;
  return new int[]{
    -widthSum/pieces.length/2, 
    -allTextHeight/2,
    maxWidth,
    allTextHeight};
}

int COUNT = 0;
int MIN_X = 1;
int MIN_Y = 2;
int MAX_X = 3;
int MAX_Y = 4;
int COG_X = 5;
int COG_Y = 6;
int SUM_X = 0;
int SUM_Y = 1;
int[][] findLargeWhiteSpaces(){
  test.loadPixels();
  int[] indices = new int[test.pixels.length];
  int[][] data = new int[test.pixels.length][7];
  double[][] data2 = new double[test.pixels.length][2];
  color white = color(255,255,255);
  int currX = 0;
  int currY = 0;
  for(int i = 0; i < test.pixels.length; i++){
    indices[i] = test.pixels[i] == white ? i : -1;
    data[i][COUNT] = test.pixels[i] == white ? 1 : 0;
    data[i][MIN_X] = currX;
    data[i][MIN_Y] = currY;
    data[i][MAX_X] = currX;
    data[i][MAX_Y] = currY;
    data2[i][SUM_X] = currX;
    data2[i][SUM_Y] = currY;
    currX++;
    if (currX >= test.width){
      currX = 0;
      currY++;
    }
  }
  
  boolean changed = false;
  boolean onLeft = false;
  boolean onRight = true;
  boolean onTop = true;
  boolean onBottom = test.height == 1;
  do{
    onBottom = test.height == 1;
    onTop = true;
    changed = false;
    for(int i = 0; i < indices.length; i++){
      if (onTop && i >= test.width){
        onTop = false;
      }
      if (!onBottom && i >= indices.length - test.width){
        onBottom = true;
      }
      if (onRight){
        onRight = test.width == 1;
        onLeft = true;
      } else if (onLeft){
        onLeft = false;
      } else {
        onRight = i % test.width == test.width - 1;
      }
      
      if (indices[i] == -1){
        continue;
      }
      changed |= handleComparison(indices, data, data2, onTop, i, i-test.width);
      changed |= handleComparison(indices, data, data2, onRight, i, i + 1);
      changed |= handleComparison(indices, data, data2, onBottom, i, i+test.width);
      changed |= handleComparison(indices, data, data2, onLeft, i, i - 1);
    }
  }while(changed);
  for(int i = 0; i < data.length; i++){
    data[i][COG_X] = (int)(data2[i][SUM_X]/data[i][COUNT]);
    data[i][COG_Y] = (int)(data2[i][SUM_Y]/data[i][COUNT]);
  }
  
  int[] sortedIndices = getSortedIndices(data);
  int[][] output = new int[sortedIndices.length][data[0].length];
  
//  for(int i = 0; i < test.pixels.length; i++){
//    if (indices[i] == sortedIndices[0]){
//      test.pixels[i] = indices[i];
//    }
//  }
//  
//  test.updatePixels();
  for(int i = 0; i < sortedIndices.length; i++){
    for(int j = 0; j < data[0].length; j++){
      output[i][j] = data[sortedIndices[i]][j];
    }
  }
  
//  fill(255,100,0);
//  ellipse(output[0][MIN_X]/TEST_RATIO,output[0][MIN_Y]/TEST_RATIO,5,5);
//  ellipse(output[0][MAX_X]/TEST_RATIO,output[0][MAX_Y]/TEST_RATIO,5,5);
//  fill(255);
//  ellipse(((output[0][MAX_X]-output[0][MIN_X])/2+output[0][MIN_X])/TEST_RATIO,((output[0][MAX_Y]-output[0][MIN_Y])/2+output[0][MIN_Y])/TEST_RATIO,5,5);
//  //stroke(0);
//  fill(0);
//  ellipse(output[0][COG_X]/TEST_RATIO,output[0][COG_Y]/TEST_RATIO,5,5);
  return output;
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
    //println(data[output[i]][COUNT]);
  }
  return output;
}

int[] indexToVertex(int index){
  return new int[]{index % test.width, index / test.width};
}

boolean handleComparison(int[] indices, int[][] data, double[][] data2, boolean onSide, int index, int checkAgainst){
  if (!onSide && indices[index] < indices[checkAgainst]){
    data[indices[index]][MIN_X] = min(data[indices[checkAgainst]][MIN_X], data[indices[index]][MIN_X]);
    data[indices[index]][MIN_Y] = min(data[indices[checkAgainst]][MIN_Y], data[indices[index]][MIN_Y]);
    data[indices[index]][MAX_X] = max(data[indices[checkAgainst]][MAX_X], data[indices[index]][MAX_X]);
    data[indices[index]][MAX_Y] = max(data[indices[checkAgainst]][MAX_Y], data[indices[index]][MAX_Y]);
    int[] checkAgainstVertex = indexToVertex(checkAgainst);
    data2[indices[index]][SUM_X] += checkAgainstVertex[0];
    data2[indices[index]][SUM_Y] += checkAgainstVertex[1];
    data2[indices[checkAgainst]][SUM_X] -= checkAgainstVertex[0];
    data2[indices[checkAgainst]][SUM_Y] -= checkAgainstVertex[1];
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
  int myAlpha = 255*lineWidth/START_WIDTH_ACTUAL;
  myColor = (myColor & 0x00FFFFFF) | (myAlpha << 24);
  pushMatrix();
  test.pushMatrix();
  pdf.pushMatrix();
    findStartPoint();
    rotate(angle);
    test.rotate(angle);
    pdf.rotate(angle);
    if (lineWidth > 2){
      drawFracturedLine(lineWidth - STEP_SIZE_ACTUAL, false);
    }
    stroke(myColor);
    pdf.stroke(myColor);
    strokeWeight(lineWidth);
    pdf.strokeWeight(lineWidth*PDF_RATIO);
    test.strokeWeight(lineWidth*TEST_RATIO);
    line(0,0,0,diag);
    test.line(0,0,0,diag*TEST_RATIO);
    pdf.line(0,0,0,diag*PDF_RATIO);
  popMatrix();
  test.popMatrix();
  pdf.popMatrix();
  if (!first){
    angle += PI;
    pushMatrix();
    test.pushMatrix();
    pdf.pushMatrix();
      findStartPoint();
      rotate(angle);
      test.rotate(angle);
      pdf.rotate(angle);
      if (lineWidth > 2){
        drawFracturedLine(lineWidth - STEP_SIZE_ACTUAL, false);
      }
      stroke(myColor);
      pdf.stroke(myColor);
      strokeWeight(lineWidth);
      test.strokeWeight(lineWidth*TEST_RATIO);
      pdf.strokeWeight(lineWidth*PDF_RATIO);
      line(0,0,0,diag);
      test.line(0,0,0,diag*TEST_RATIO);
      pdf.line(0,0,0,diag*PDF_RATIO);
    popMatrix();
    test.popMatrix();
    pdf.popMatrix();
  }
}

void findStartPoint(){
  float startRatio,startX,startY,ratioLimit = 1.0;
  do {
    test.popMatrix();
    startRatio = random(ratioLimit);
    test.pushMatrix();
    test.translate(0,diag*startRatio);
    startX = test.modelX(0,0,0);
    startY = test.modelY(0,0,0);
    ratioLimit = startRatio;
  }while(startX < 0 || startX > test.width || startY < 0 || startY > test.height);
  translate(0,diag*startRatio/TEST_RATIO);
  pdf.translate(0,diag*startRatio/TEST_RATIO*PDF_RATIO);
}
  
