/*
 * Sketch     Sketch for control Freenove Hexapod Robot
 * Brief      This sketch is used to control Freenove Hexapod Robot through Serial or WIFI.
 *            To use Serial, the robot should connect to the device run this sketch.
 *            To use WIFI, the device run this sketch should connect to the WIFI of the robot.
 * Author     Ethan Pan @ Freenove (support@freenove.com)
 * Date       2018/03/27
 * Copyright  Copyright © Freenove (http://www.freenove.com)
 * License    Creative Commons Attribution ShareAlike 3.0
 *            (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 * -----------------------------------------------------------------------------------------------*/

// control robot
ControlRobot controlRobot = new ControlRobot(this);
// gui
import controlP5.*;
ControlP5 cp5;
PFont font;
Textlabel textlabelInfo;
Textlabel textlabelVoltage;
Slider2D slider2dMove;
Slider2D slider2dRotate;
// images for gui
PImage pImageControl;
PImage pImageCalibration;
PImage pImageInstallation;
PImage pImageMoveBody;
PImage pImageRotateBody;
// constants for gui
final color backgroundColor = color(128);
final color globalTabColor = color(102);
final int globalTapHeight = 100;
final int tabWidth = 128;
final int tabHeight = 24;
// event
int eventId = 0;
boolean isProcessEvent = false;
// voltage
int lastGetVoltage = 0;

void setup() {
  size(800, 600);
  noStroke();
  font = createFont("Lucida Sans Regular", 16);
  textFont(font);
  textAlign(CENTER, CENTER);
  pImageControl = loadImage("control.png");
  pImageCalibration = loadImage("calibration.png");
  pImageInstallation = loadImage("installation.png");
  pImageMoveBody = loadImage("moveBody.png");
  pImageRotateBody = loadImage("rotateBody.png");

  setControlP5();
}

void draw() {
  background(backgroundColor);
  fill(globalTabColor);
  rect(0, tabHeight, width, globalTapHeight);
  rect(0, height - tabHeight, width, tabHeight);
  fill(255, 255, 255);
  text("Press Enter to visit www.freenove.com", width / 2, height - tabHeight / 2);

  if (cp5.getTab("default").isActive()) {
    image(pImageControl, 0, tabHeight + globalTapHeight);
  } else if (cp5.getTab("calibration").isActive()) {
    image(pImageCalibration, 0, tabHeight + globalTapHeight);
  } else if (cp5.getTab("installation").isActive()) {
    image(pImageInstallation, 0, tabHeight + globalTapHeight);
  } else if (cp5.getTab("move body").isActive()) {
    image(pImageMoveBody, 0, tabHeight + globalTapHeight);
  } else if (cp5.getTab("rotate body").isActive()) {
    image(pImageRotateBody, 0, tabHeight + globalTapHeight);
  }

  getVoltage();
  processEvent();
}

void getVoltage() {
  if (millis() - lastGetVoltage > 1500) {
    float voltage = controlRobot.GetVoltage();
    textlabelVoltage.setText(String.valueOf(voltage) + "V");
    lastGetVoltage = millis();
  }
}

void processEvent() {
  if (isProcessEvent) {
    processEvent(eventId);
    isProcessEvent = false;
    eventId = 0;
    textlabelInfo.setText("Ready");
  }
  if (eventId != 0) {
    isProcessEvent = true;
    textlabelInfo.setText("Processing...");
  }
}

void setEvent(int id) {
  if (eventId == 0) {
    eventId = id;
  }
}

void setControlP5() {
  cp5 = new ControlP5(this);
  cp5.setFont(font);  

  setControlP5Tab();
  setControlP5Key();
}

void setControlP5Tab() {
  setControlP5TabGlobal();

  cp5.getTab("default")
    .setId(2)
    .setCaptionLabel("control")
    .setHeight(tabHeight)
    .setWidth(tabWidth)
    .activateEvent(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  setControlP5TabControl();

  cp5.addTab("calibration")
    .setId(3)
    .setHeight(tabHeight)
    .setWidth(tabWidth)
    .activateEvent(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  setControlP5TabCalibration();

  cp5.addTab("installation")
    .setId(4)
    .setHeight(tabHeight)
    .setWidth(tabWidth)
    .activateEvent(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addTab("move body")
    .setId(5)
    .setHeight(tabHeight)
    .setWidth(tabWidth)
    .activateEvent(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  setControlP5TabMoveBody();

  cp5.addTab("rotate body")
    .setId(6)
    .setHeight(tabHeight)
    .setWidth(tabWidth)
    .activateEvent(true)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  setControlP5TabRotateBody();
}

void setControlP5TabRotateBody() {
  slider2dRotate = cp5.addSlider2D("rotate")
    .setId(601)
    .setPosition(24, 200)
    .setSize(200, 200)
    .setMinMax(-10, 10, 10, -10)
    .setValue(0, 0)
    .moveTo("rotate body")
    ;
}

void setControlP5TabMoveBody() {
  slider2dMove = cp5.addSlider2D("move")
    .setId(501)
    .setPosition(24, 200)
    .setSize(200, 200)
    .setMinMax(30, 30, -30, -30)
    .setValue(0, 0)
    .moveTo("move body")
    ;

  cp5.addSlider("z")
    .setPosition(260, 200)
    .setId(502)
    .setSize(20, 200)
    .setRange(-15, 45)
    .setDecimalPrecision(0) 
    .setValue(0)
    .moveTo("move body")
    ;
}

void setControlP5TabGlobal() {
  cp5.addRadioButton("radioButton1")
    .setId(101)
    .setPosition(4, tabHeight + 11)
    .setSize(20, 20)
    .setItemsPerRow(2)
    .setSpacingRow(4)
    .setSpacingColumn(60)
    .addItem("serial", 1)
    .addItem("wifi", 2)
    .activate(0)
    .moveTo("global")
    ;

  cp5.addButton("connect")
    .setId(102)
    .setPosition(4, tabHeight + 11 + 20 + 10)
    .setSize(128, 48)
    .moveTo("global")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  textlabelInfo = cp5.addTextlabel("labelInfo")
    .setText(" ")
    .setPosition(4 + 128 + 24, tabHeight + 11 + 20 + 14)
    .setFont(createFont("Lucida Sans Regular", 32))
    .moveTo("global")
    ;

  textlabelVoltage = cp5.addTextlabel("labelVoltage")
    .setText("0.0V")
    .setPosition(width - 128, tabHeight + 11 + 20 + 14)
    .setFont(createFont("Lucida Sans Regular", 32))
    .moveTo("global")
    ;
}

void setControlP5TabControl() {
  ////
  int buttonWidth = 128;
  int buttonHeight = 48;
  int buttonSpacingX = 4;
  int buttonSpacingY = 4;
  //
  cp5.addButton("Forward(W)")
    .setId(201)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 1, 136 + (buttonHeight + buttonSpacingY) * 0)
    .setSize(buttonWidth, buttonHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("Backward(S)")
    .setId(202)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 1, 136 + (buttonHeight + buttonSpacingY) * 2)
    .setSize(buttonWidth, buttonHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("Turn left(A)")
    .setId(203)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 0, 136 + (buttonHeight + buttonSpacingY) * 1)
    .setSize(buttonWidth, buttonHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("Turn right(D)")
    .setId(204)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 2, 136 + (buttonHeight + buttonSpacingY) * 1)
    .setSize(buttonWidth, buttonHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  //
  cp5.addButton("activate(z)")
    .setId(205)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 0, 136 + (buttonHeight + buttonSpacingY) * 4)
    .setSize(buttonWidth, buttonHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("switch(x)")
    .setId(206)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 1, 136 + (buttonHeight + buttonSpacingY) * 4)
    .setSize(buttonWidth, buttonHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("deactivate(c)")
    .setId(207)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 2, 136 + (buttonHeight + buttonSpacingY) * 4)
    .setSize(buttonWidth, buttonHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
  ////
  int toggleWidth = 95;
  int toggleHeight = 32;
  int toggleSpacingX = 4;
  int toggleSpacingY = 4;

  cp5.addToggle("20")
    .setId(208)
    .setPosition(4 + (toggleWidth + toggleSpacingX) * 0, 448 + (toggleHeight + toggleSpacingY) * 0)
    .setSize(toggleWidth, toggleHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addToggle("21")
    .setId(209)
    .setPosition(4 + (toggleWidth + toggleSpacingX) * 1, 448 + (toggleHeight + toggleSpacingY) * 0)
    .setSize(toggleWidth, toggleHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addToggle("a0")
    .setId(210)
    .setPosition(4 + (toggleWidth + toggleSpacingX) * 2, 448 + (toggleHeight + toggleSpacingY) * 0)
    .setSize(toggleWidth, toggleHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addToggle("a1")
    .setId(211)
    .setPosition(4 + (toggleWidth + toggleSpacingX) * 3, 448 + (toggleHeight + toggleSpacingY) * 0)
    .setSize(toggleWidth, toggleHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addToggle("15")
    .setId(212)
    .setPosition(4 + (toggleWidth + toggleSpacingX) * 0, 448 + (toggleHeight + toggleSpacingY) * 1)
    .setSize(toggleWidth, toggleHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addToggle("14")
    .setId(213)
    .setPosition(4 + (toggleWidth + toggleSpacingX) * 1, 448 + (toggleHeight + toggleSpacingY) * 1)
    .setSize(toggleWidth, toggleHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addToggle("2")
    .setId(214)
    .setPosition(4 + (toggleWidth + toggleSpacingX) * 2, 448 + (toggleHeight + toggleSpacingY) * 1)
    .setSize(toggleWidth, toggleHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addToggle("3")
    .setId(215)
    .setPosition(4 + (toggleWidth + toggleSpacingX) * 3, 448 + (toggleHeight + toggleSpacingY) * 1)
    .setSize(toggleWidth, toggleHeight)
    .getCaptionLabel().align(CENTER, CENTER)
    ;
}

void setControlP5TabCalibration() {
  cp5.addRadioButton("radioButton2")
    .setId(301)
    .setPosition(4, 136)
    .setSize(20, 20)
    .setItemsPerRow(6)
    .setSpacingRow(4)
    .setSpacingColumn(60)
    .addItem("leg1", 1)
    .addItem("leg2", 2)
    .addItem("leg3", 3)
    .addItem("leg4", 4)
    .addItem("leg5", 5)
    .addItem("leg6", 6)
    .activate(0)
    .moveTo("calibration")
    ;

  ////
  int buttonWidth = 64;
  int buttonHeight = 48;
  int buttonSpacingX = 4;
  int buttonSpacingY = 4;
  //
  cp5.addButton("y+(w)")
    .setId(302)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 1, 136 + (buttonHeight + buttonSpacingY) * 1)
    .setSize(buttonWidth, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("y-(s)")
    .setId(303)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 1, 136 + (buttonHeight + buttonSpacingY) * 3)
    .setSize(buttonWidth, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("x+(a)")
    .setId(304)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 0, 136 + (buttonHeight + buttonSpacingY) * 2)
    .setSize(buttonWidth, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("x-(d)")
    .setId(305)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 2, 136 + (buttonHeight + buttonSpacingY) * 2)
    .setSize(buttonWidth, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("z+(r)")
    .setId(306)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 3.5, 136 + (buttonHeight + buttonSpacingY) * 1)
    .setSize(buttonWidth, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("z-(f)")
    .setId(307)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 3.5, 136 + (buttonHeight + buttonSpacingY) * 3)
    .setSize(buttonWidth, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("confirm")
    .setId(308)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 0, 136 + (buttonHeight + buttonSpacingY) * 4.5)
    .setSize(buttonWidth * 2 + buttonSpacingX, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("cancel")
    .setId(309)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 2.5, 136 + (buttonHeight + buttonSpacingY) * 4.5)
    .setSize(buttonWidth * 2 + buttonSpacingX, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;

  cp5.addButton("verify")
    .setId(310)
    .setPosition(4 + (buttonWidth + buttonSpacingX) * 0, 136 + (buttonHeight + buttonSpacingY) * 6.5)
    .setSize(buttonWidth * 2 + buttonSpacingX, buttonHeight)
    .moveTo("calibration")
    .getCaptionLabel().align(CENTER, CENTER)
    ;
}

void setControlP5Key() {
  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("default").isActive()) {
        setEvent(201);
      } else if (cp5.getTab("calibration").isActive()) {
        setEvent(302);
      }
    }
  }
  , 'w');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("default").isActive()) {
        setEvent(202);
      } else if (cp5.getTab("calibration").isActive()) {
        setEvent(303);
      }
    }
  }
  , 's');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("default").isActive()) {
        setEvent(203);
      } else if (cp5.getTab("calibration").isActive()) {
        setEvent(304);
      }
    }
  }
  , 'a');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("default").isActive()) {
        setEvent(204);
      } else if (cp5.getTab("calibration").isActive()) {
        setEvent(305);
      }
    }
  }
  , 'd');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("default").isActive()) {
        setEvent(205);
      }
    }
  }
  , 'z');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("default").isActive()) {
        setEvent(206);
      }
    }
  }
  , 'x');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("default").isActive()) {
        setEvent(207);
      }
    }
  }
  , 'c');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("calibration").isActive()) {
        setEvent(306);
      }
    }
  }
  , 'r');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      if (cp5.getTab("calibration").isActive()) {
        setEvent(307);
      }
    }
  }
  , 'f');

  // press Enter to visit www.freenove.com
  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      link("http://www.freenove.com");
    }
  }
  , '\n');

  cp5.mapKeyFor(new ControlKey() {
    public void keyEvent() {
      link("http://www.freenove.com");
    }
  }
  , '\r');
}

public void controlEvent(ControlEvent theEvent) {
  setEvent(theEvent.getId());
}

public void processEvent(int id) {
  final int dL = 1;

  float value[];
  float z;

  switch(id) {
    // connect
    case(102):
    if (cp5.getGroup("radioButton1").getValue() == 1) {
      if (!controlRobot.communication.isSerialAvailable) {
        if (controlRobot.communication.StartSerial())
        {
          cp5.getController("connect").setCaptionLabel("disconnect");
          cp5.getGroup("radioButton1").getController("serial").lock();
          cp5.getGroup("radioButton1").getController("wifi").lock();
          cp5.getGroup("radioButton1").getController("serial").setColorLabel(160);
          cp5.getGroup("radioButton1").getController("wifi").setColorLabel(160);

          if (cp5.getTab("default").isActive()) {
            processEvent(2);
          } else if (cp5.getTab("calibration").isActive()) {
            processEvent(3);
          } else if (cp5.getTab("installation").isActive()) {
            processEvent(4);
          }
        }
      } else {
        controlRobot.communication.StopSerial();
        cp5.getController("connect").setCaptionLabel("connect");
        cp5.getGroup("radioButton1").getController("serial").unlock();
        cp5.getGroup("radioButton1").getController("wifi").unlock();
        cp5.getGroup("radioButton1").getController("serial").setColorLabel(255);
        cp5.getGroup("radioButton1").getController("wifi").setColorLabel(255);
      }
    } else {
      if (!controlRobot.communication.isClientAvailable) {
        if (controlRobot.communication.StartClient())
        {
          cp5.getController("connect").setCaptionLabel("disconnect");
          cp5.getGroup("radioButton1").getController("serial").lock();
          cp5.getGroup("radioButton1").getController("wifi").lock();
          cp5.getGroup("radioButton1").getController("serial").setColorLabel(160);
          cp5.getGroup("radioButton1").getController("wifi").setColorLabel(160);

          if (cp5.getTab("default").isActive()) {
            processEvent(2);
          } else if (cp5.getTab("calibration").isActive()) {
            processEvent(3);
          } else if (cp5.getTab("installation").isActive()) {
            processEvent(4);
          }
        }
      } else {
        controlRobot.communication.StopClient();
        cp5.getController("connect").setCaptionLabel("connect");
        cp5.getGroup("radioButton1").getController("serial").unlock();
        cp5.getGroup("radioButton1").getController("wifi").unlock();
        cp5.getGroup("radioButton1").getController("serial").setColorLabel(255);
        cp5.getGroup("radioButton1").getController("wifi").setColorLabel(255);
      }
    }
    break;

    // switch state
    case(2):
    controlRobot.BootState();
    break;
    case(3):
    controlRobot.CalibrateState();
    cp5.getController("confirm").unlock();
    cp5.getController("confirm").setColorLabel(255);
    break;
    case(4):
    controlRobot.InstallState();
    break;
    case(5):
    slider2dMove.setValue(0, 0);
    cp5.getController("z").setValue(0);
    controlRobot.MoveBody(0, 0, 0);
    break;
    case(6):
    slider2dRotate.setValue(0, 0);
    controlRobot.RotateBody(0, 0);
    break;

    // move robot
    // available in BootState
    case(201):
    controlRobot.CrawlForward();
    break;
    case(202):
    controlRobot.CrawlBackward();
    break;
    case(203):
    controlRobot.TurnLeft();
    break;
    case(204):
    controlRobot.TurnRight();
    break;
    case(205):
    controlRobot.ActiveMode();
    break;
    case(206):
    controlRobot.SwitchMode();
    break;
    case(207):
    controlRobot.SleepMode();
    break;

    // change IO
    // available in BootState
    case(208):
    controlRobot.ChangeIO(0, cp5.getController("20").getValue() == 1 ? true : false);
    break;
    case(209):
    controlRobot.ChangeIO(1, cp5.getController("21").getValue() == 1 ? true : false);
    break;
    case(210):
    controlRobot.ChangeIO(2, cp5.getController("a0").getValue() == 1 ? true : false);
    break;
    case(211):
    controlRobot.ChangeIO(3, cp5.getController("a1").getValue() == 1 ? true : false);
    break;
    case(212):
    controlRobot.ChangeIO(4, cp5.getController("15").getValue() == 1 ? true : false);
    break;
    case(213):
    controlRobot.ChangeIO(5, cp5.getController("14").getValue() == 1 ? true : false);
    break;
    case(214):
    controlRobot.ChangeIO(6, cp5.getController("2").getValue() == 1 ? true : false);
    break;
    case(215):
    controlRobot.ChangeIO(7, cp5.getController("3").getValue() == 1 ? true : false);
    break;

    // move leg
    // available in CalibrateState
    case(302):
    controlRobot.MoveLeg((int)(cp5.getGroup("radioButton2").getValue()), 0, dL, 0);
    break;
    case(303):
    controlRobot.MoveLeg((int)(cp5.getGroup("radioButton2").getValue()), 0, -dL, 0);
    break;
    case(304):
    controlRobot.MoveLeg((int)(cp5.getGroup("radioButton2").getValue()), dL, 0, 0);
    break;
    case(305):
    controlRobot.MoveLeg((int)(cp5.getGroup("radioButton2").getValue()), -dL, 0, 0);
    break;
    case(306):
    controlRobot.MoveLeg((int)(cp5.getGroup("radioButton2").getValue()), 0, 0, dL);
    break;
    case(307):
    controlRobot.MoveLeg((int)(cp5.getGroup("radioButton2").getValue()), 0, 0, -dL);
    break;

    // calibrate
    // available in CalibrateState
    case(308):
    controlRobot.Calibrate();
    break;
    case(309):
    controlRobot.CalibrateState();
    cp5.getController("confirm").unlock();
    cp5.getController("confirm").setColorLabel(255);
    break;
    case(310):
    controlRobot.CalibrateVerify();
    cp5.getController("confirm").lock();
    cp5.getController("confirm").setColorLabel(160);
    break;

    // move body
    // available in move body
    case(501):
    case(502):
    value = cp5.getController("move").getArrayValue();
    z = cp5.getController("z").getValue();
    controlRobot.MoveBody((int)value[0], (int)value[1], (int)z);
    break;

    // rotate body
    // available in rotate body
    case(601):
    value = cp5.getController("rotate").getArrayValue();
    controlRobot.RotateBody((int)value[1], (int)value[0]);
    break;
  }
}
