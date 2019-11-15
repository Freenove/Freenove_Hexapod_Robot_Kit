/*
 * File       Control robot class for Freenove Hexapod Robot
 * Author     Ethan Pan @ Freenove (support@freenove.com)
 * Date       2019/11/15
 * Copyright  Copyright © Freenove (http://www.freenove.com)
 * License    Creative Commons Attribution ShareAlike 3.0
 *            (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 * -----------------------------------------------------------------------------------------------*/

class ControlRobot {
  Communication communication;

  ControlRobot(PApplet pApplet) {
    communication = new Communication(pApplet);
  }

  public void BootState() {
    communication.SendCommand(new byte[]{Orders.requestBootState});
  }

  public void CalibrateState() {
    communication.SendCommand(new byte[]{Orders.requestCalibrateState});
  }

  public void InstallState() {
    communication.SendCommand(new byte[]{Orders.requestInstallState});
  }

  public float GetVoltage() {
    byte[] inData = communication.SendCommand(new byte[]{Orders.requestSupplyVoltage});

    if (inData != null) {
      if (inData[0] == Orders.supplyVoltage) {
        return (inData[1] * 128 + inData[2]) / 100.0;
      }
    }
    return 0;
  }

  public void CrawlForward() {
    communication.SendCommand(new byte[]{Orders.requestCrawlForward});
  }

  public void CrawlBackward() {
    communication.SendCommand(new byte[]{Orders.requestCrawlBackward});
  }

  public void CrawlLeft() {
    communication.SendCommand(new byte[]{Orders.requestCrawlLeft});
  }

  public void CrawlRight() {
    communication.SendCommand(new byte[]{Orders.requestCrawlRight});
  }

  public void TurnLeft() {
    communication.SendCommand(new byte[]{Orders.requestTurnLeft});
  }

  public void TurnRight() {
    communication.SendCommand(new byte[]{Orders.requestTurnRight});
  }

  public void ActiveMode() {
    communication.SendCommand(new byte[]{Orders.requestActiveMode});
  }

  public void SwitchMode() {
    communication.SendCommand(new byte[]{Orders.requestSwitchMode});
  }

  public void SleepMode() {
    communication.SendCommand(new byte[]{Orders.requestSleepMode});
  }

  public void ChangeBodyHeight(int height) {
    communication.SendCommand(
      new byte[]{Orders.requestChangeBodyHeight, 
      (byte)(64 + height)});
  }

  public void ChangeIO(int IO, boolean status) {
    communication.SendCommand(
      new byte[]{Orders.requestChangeIO, 
      (byte)IO, 
      (byte)(status ? 1 : 0)});
  }

  public void MoveBody(int x, int y, int z) {
    communication.SendCommand(
      new byte[]{Orders.requestMoveBody, 
      (byte)(64 + x), 
      (byte)(64 + y), 
      (byte)(64 + z)});
  }

  public void RotateBody(int x, int y, int z) {
    communication.SendCommand(
      new byte[]{Orders.requestRotateBody, 
      (byte)(64 + x), 
      (byte)(64 + y), 
      (byte)(64 + z)});
  }

  public void TwistBody(int xMove, int yMove, int zMove, int xRotate, int yRotate, int zRotate) {
    communication.SendCommand(
      new byte[]{Orders.requestTwistBody, 
      (byte)(64 + xMove), 
      (byte)(64 + yMove), 
      (byte)(64 + zMove),
      (byte)(64 + xRotate), 
      (byte)(64 + yRotate), 
      (byte)(64 + zRotate)});
  }

  public void MoveLeg(int leg, int dx, int dy, int dz) {
    communication.SendCommand(
      new byte[]{Orders.requestMoveLeg, 
      (byte)(leg), 
      (byte)(64 + dx), 
      (byte)(64 + dy), 
      (byte)(64 + dz)});
  }

  public void Calibrate() {
    communication.SendCommand(new byte[]{Orders.requestCalibrate});
  }

  public void CalibrateVerify() {
    communication.SendCommand(new byte[]{Orders.requestCalibrateVerify});
  }
}
