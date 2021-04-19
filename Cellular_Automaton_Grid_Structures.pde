/*

 * Cidori CA
 
 ******************************************
 * Copyright (c) 2017 Nikolaos Argyros
 ******************************************
 
 * This code is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 
 * Based on a sketch by Alasdair Turner
 
 */

import peasy.*;
import processing.opengl.*;
import controlP5.*;
PeasyCam cam;

ControlP5 ui;

int[][][] state;
int[][] newstate;
int time = 0;               
int numCellsX, numCellsY;
boolean s = false;

int DIMX = 1000; // Box Dimensions.
int DIMY = 1000;
int DIMZ = 1000;

int cellSize = DIMZ/30;

int sliderValue = 200;
int sliderValue2 = 200;
int sliderValue3 = 200;
int sliderValue4 = 5;

boolean toggleValue = true;
boolean toggleValue2 = false;
boolean toggleValue3 = false;
boolean toggleValue4 = false;
boolean toggleValue5 = false;
boolean toggleValue6 = false;
boolean toggleValue7 = false;
boolean toggleValue8 = false;
boolean toggleValue9 = false;
boolean toggleValue10 = false;
boolean toggleValue11 = false;
boolean toggleValue12 = false;
boolean toggleValue13 = false;
boolean toggleValue14 = true;
boolean toggleValue15 = false;

PImage reference;

void setup()
{
  size (1280, 720, P3D);

  ui = new ControlP5(this);

  camera_init();

  numCellsX = DIMX/cellSize;
  numCellsY = DIMZ/cellSize;

  state    = new int[1][numCellsX][numCellsY];
  newstate = new int[numCellsX][numCellsY];

  for (int i=0; i<numCellsX; i++)
  {
    for (int j=0; j<numCellsY; j++)
    { 
      if (random(1.0)<0.4) state[0][i][j] = 1;     //Start with a random % of cells being full
    }
  }

  reference = loadImage("ref.png");

  ui.addToggle("toggleValue").setSize(100, 17).setPosition(10, 30).setCaptionLabel("ON/OFF").setColorLabel(0);
  ui.addSlider("sliderValue").setSize(100, 17).setPosition(10, 60).setRange(0, 255).setCaptionLabel("Fill").setValue(0).setColorLabel(0) ;
  ui.addSlider("sliderValue2").setSize(100, 17).setPosition(10, 90).setRange(0, 255).setCaptionLabel("Transparency").setValue(255).setColorLabel(0) ;
  ui.addSlider("sliderValue3").setSize(100, 17).setPosition(10, 120).setRange(0, 255).setCaptionLabel("Stroke").setValue(255).setColorLabel(0) ;
  ui.addToggle("toggleValue2").setSize(17, 17).setPosition(20, 190).setCaptionLabel("A").setColorLabel(0) ;
  ui.addToggle("toggleValue3").setSize(17, 17).setPosition(40, 190).setCaptionLabel("B").setColorLabel(0) ;
  ui.addToggle("toggleValue4").setSize(17, 17).setPosition(60, 190).setCaptionLabel("C").setColorLabel(0) ;
  ui.addToggle("toggleValue5").setSize(17, 17).setPosition(80, 190).setCaptionLabel("D").setColorLabel(0) ;
  ui.addToggle("toggleValue6").setSize(17, 17).setPosition(20, 230).setCaptionLabel("E").setColorLabel(0) ;
  ui.addToggle("toggleValue7").setSize(17, 17).setPosition(40, 230).setCaptionLabel("F").setColorLabel(0) ;
  ui.addToggle("toggleValue8").setSize(17, 17).setPosition(60, 230).setCaptionLabel("G").setColorLabel(0) ;
  ui.addToggle("toggleValue9").setSize(17, 17).setPosition(80, 230).setCaptionLabel("H").setColorLabel(0) ;
  ui.addToggle("toggleValue10").setSize(17, 17).setPosition(20, 270).setCaptionLabel("I").setColorLabel(0) ;
  ui.addToggle("toggleValue11").setSize(17, 17).setPosition(40, 270).setCaptionLabel("J").setColorLabel(0) ;
  ui.addToggle("toggleValue12").setSize(17, 17).setPosition(60, 270).setCaptionLabel("K").setColorLabel(0) ;
  ui.addToggle("toggleValue13").setSize(17, 17).setPosition(80, 270).setCaptionLabel("L").setColorLabel(0) ;
  ui.addToggle("toggleValue14").setSize(30, 30).setPosition(20, 330).setCaptionLabel("BOX").setColorLabel(0) ;
  ui.addToggle("toggleValue15").setSize(30, 30).setPosition(60, 330).setCaptionLabel("FRAME").setColorLabel(0) ;
  ui.addButton("RESET").setPosition(23, 155).updateSize() ;
  ui.setAutoDraw(false);
}

void draw()
{
  background(225);
  buildBox(DIMX, DIMY, DIMZ);

  if (time < 30)
  { 
    if (toggleValue==false) {
      fill(sliderValue, sliderValue2);
      stroke(sliderValue3);
      strokeWeight(1);
      drawCells();
    } else {
      stroke(0);
      strokeWeight(1);
      drawPoints();
    }
    if (frameCount%10==0) nextStep();                         //Only move to the next time step every 10 frames - slows down 3D growth
  } else {
    if (toggleValue==true) {
      fill(sliderValue, sliderValue2);
      stroke(sliderValue3);
      //noStroke();
      strokeWeight(1);
      drawCells();
    } else {
      stroke(0);
      strokeWeight(1);
      drawPoints();
    }
  }
  initUI();
  //saveFrame("Cidori-######.tga");
}

public void RESET() 
{
  cam.beginHUD();
  time = 0;
  setup();     
  cam.endHUD();
}

void initUI() {  
  hint(DISABLE_DEPTH_TEST);
  cam.beginHUD();
  ui.draw();
  image(reference, 10, 400, 100, 110);
  cam.endHUD();
  hint(ENABLE_DEPTH_TEST);
}

void nextStep()
{
  for (int i=1; i<numCellsX-1; i++)
  {
    for (int j=1; j<numCellsY-1; j++)
    {
      int number = 0;
      for (int m=-1; m<=1; m++)
      {
        for (int n=-1; n<=1; n++)
        {
          if (! (m==0 && n==0))
          {
            if (state[time][i+m][j+n]==1) number++;
          }
        }
      }
      if (state[time][i][j]==1)
      {
        if (number<2 || number>3) newstate[i][j] = 0;
        else                      newstate[i][j] = 1;
      } else
      {
        if (number==3) newstate[i][j] = 1;
        else           newstate[i][j] = 0;
      }
    }
  }

  time ++;

  state = (int[][][]) expand(state, state.length+1);   //Expand the array to hold the next time step
  state[time] = new int[numCellsX][numCellsY];         //Initialize the new array
  for (int i=0; i<numCellsX; i++)                      //Copy all the data from newstate and store it in the new state array (different dimensions)
  {
    for (int j=0; j<numCellsY; j++)
    {
      state[time][i][j] = newstate[i][j];
    }
  }
}

void drawCells()  //Just draw the cells
{
  for (int t=0; t<state.length; t++)
  { 
    for (int i=0; i<numCellsX; i++)
    {
      for (int j=0; j<numCellsY; j++)
      {
        if (state[t][i][j] == 1)
        {
          if (toggleValue15==true) 
          {
            if (toggleValue2==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(cellSize/2+(0.5), (0.5), 1);
              box(cellSize, 2, 2);
              popMatrix();
            }
            if (toggleValue3==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(cellSize/2+(0.5), (0.5), cellSize-1);
              box(cellSize, 2, 2);
              popMatrix();
            }
            if (toggleValue4==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(cellSize-1, (0.5), cellSize/2+(0.5));
              box(2, 2, cellSize);
              popMatrix();
            }
            if (toggleValue5==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(1, (0.5), cellSize/2+(0.5));
              box(2, 2, cellSize);
              popMatrix();
            }
            if (toggleValue6==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(cellSize/2+(0.5), cellSize-(1.5), 1);
              box(cellSize, 2, 2);
              popMatrix();
            }
            if (toggleValue7==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(cellSize/2+(0.5), cellSize-(1.5), cellSize-1);
              box(cellSize, 2, 2);
              popMatrix();
            }
            if (toggleValue8==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(cellSize-1, cellSize-(1.5), cellSize/2+(0.5));
              box(2, 2, cellSize);
              popMatrix();
            }
            if (toggleValue9==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(1, cellSize-(1.5), cellSize/2+(0.5));
              box(2, 2, cellSize);
              popMatrix();
            }
            if (toggleValue10==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(2, cellSize/2, 2);
              box(2, cellSize, 2);
              popMatrix();
            }
            if (toggleValue11==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(cellSize-1, cellSize/2, 1);
              box(2, cellSize, 2);
              popMatrix();
            }
            if (toggleValue12==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(cellSize-1, cellSize/2, cellSize-1);
              box(2, cellSize, 2);
              popMatrix();
            }
            if (toggleValue13==true) 
            {
              pushMatrix();
              translate(i*cellSize, t*cellSize, j*cellSize);
              translate(1, cellSize/2, cellSize-1);
              box(2, cellSize, 2);
              popMatrix();
            }
          }
          if (toggleValue14==true) 
          {
            pushMatrix();
            translate(i*cellSize, t*cellSize, j*cellSize);
            translate(cellSize/2, cellSize/2, cellSize/2);
            box(cellSize, cellSize, cellSize);
            popMatrix();
          }
        }
      }
    }
  }
}

void drawPoints()  //Draw the Points
{
  for (int t=1; t<state.length; t++)
  { 
    for (int i=1; i<numCellsX; i++)
    {
      for (int j=1; j<numCellsY; j++)
      {
        if (state[t][i][j] == 1)
        {    
          PVector pos = new PVector(i*cellSize, (t)*cellSize, j*cellSize);
          point(pos.x, pos.y, pos.z);
        }
      }
    }
  }
}

void buildBox(float x, float y, float z) 
{
  noFill();
  stroke(255);
  strokeWeight(0.001);
  pushMatrix();
  translate(500, 500, 500);
  scale(x, y, z);
  box(1);
  popMatrix();
}
