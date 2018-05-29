/*
 * File       Control class for Freenove Hexapod Robot
 * Author     Ethan Pan @ Freenove (support@freenove.com)
 * Date       2018/03/27
 * Copyright  Copyright © Freenove (http://www.freenove.com)
 * License    Creative Commons Attribution ShareAlike 3.0
 *            (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 * -----------------------------------------------------------------------------------------------*/

class ControlRobot {
  Communication communication;

  ControlRobot(PApplet pApplet) {
    communication = new Communication(pApplet);
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

  public void ChangeIO(int IO, boolean status) {
    communication.SendCommand(
      new byte[]{Orders.requestChangeIO, 
      (byte)IO, 
      (byte)(status ? 1 : 0)});
  }

  public void CrawlForward() {
    communication.SendCommand(new byte[]{Orders.requestCrawlForward});
  }

  public void CrawlBackward() {
    communication.SendCommand(new byte[]{Orders.requestCrawlBackward});
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

  public void InstallState() {
    communication.SendCommand(new byte[]{Orders.requestInstallState});
  }

  public void CalibrateState() {
    communication.SendCommand(new byte[]{Orders.requestCalibrateState});
  }

  public void BootState() {
    communication.SendCommand(new byte[]{Orders.requestBootState});
  }

  public void CalibrateVerify() {
    communication.SendCommand(new byte[]{Orders.requestCalibrateVerify});
  }

  public void MoveBody(int x, int y, int z) {
    communication.SendCommand(
      new byte[]{Orders.requestMoveBodyTo, 
      (byte)(64 + x), 
      (byte)(64 + y), 
      (byte)(64 + z)});
  }

  public void RotateBody(int x, int y) {
    communication.SendCommand(
      new byte[]{Orders.requestRotateBodyTo, 
      (byte)(64 + x), 
      (byte)(64 + y)});
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
}
