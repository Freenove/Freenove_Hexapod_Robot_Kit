/*
 * File       Communication orders for Freenove Hexapod Robot
 * Author     Ethan Pan @ Freenove (support@freenove.com)
 * Date       2018/03/27
 * Copyright  Copyright © Freenove (http://www.freenove.com)
 * License    Creative Commons Attribution ShareAlike 3.0
 *            (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 * -----------------------------------------------------------------------------------------------*/

class Orders
{
  // Format:  [transStart] [order] [data 0] [data 1] ... [data n] [transEnd]
  //          [x] is byte type and the range of [order] and [data x] is 0~127
  // Process: The requesting party send the order, then the responding party respond the order.
  //          The non blocking order will be responded immediately, and the blocking order will
  //          be responded orderStart immediately, then respond orderDone after completion.


  // Transmission control bytes, range is 128 ~ 255
  static final byte transStart = (byte)128;
  static final byte transEnd = (byte)129;


  // Orders, range is 0 ~ 127
  // Some orders have proprietary response orders, others use orderStart and orderDone
  // The even orders is sent by the requesting party, and the odd orders is sent by the 
  // responding party.


  // Non blocking orders, range 0 ~ 63

  // Request echo, to confirm the device
  static final byte requestEcho = 0;            // [order]
  // Respond echo
  static final byte echo = 1;                   // [order]

  // Request supply voltage
  static final byte requestSupplyVoltage = 10;  // [order]
  // Respond supply voltage
  static final byte supplyVoltage = 11;         // [order] [voltage * 100 / 128] [voltage * 100 % 128]

  //
  static final byte requestMoveLeg = 20;        // [order] [leg] [64 + dx] [64 + dy] [64 + dz]
  static final byte requestCalibrate = 22;      // [order]

  //
  static final byte requestChangeIO = 30;       // [order] [IOindex] [1/0]

  // Dynamic orders, range 40 ~ 63
  // The dynamic order will be responded immediately, although the order has just begun.
  static final byte requestMoveBodyTo = 40;     // [order] [64 + x] [64 + y] [64 + z]
  static final byte requestRotateBodyTo = 42;   // [order] [64 + x] [64 + y]

  // Universal responded orders
  static final byte orderStart = 21;            // [order]
  static final byte orderDone = 23;             // [order]


  // Blocking orders, range 64 ~ 127

  //
  static final byte requestCrawlForward = 64;   // [order]
  static final byte requestCrawlBackward = 66;  // [order]
  static final byte requestTurnLeft = 68;       // [order]
  static final byte requestTurnRight = 70;      // [order]
  static final byte requestActiveMode = 72;     // [order]
  static final byte requestSleepMode = 74;      // [order]
  static final byte requestSwitchMode = 76;     // [order]

  //
  static final byte requestInstallState = 80;   // [order]
  static final byte requestCalibrateState = 82; // [order]
  static final byte requestBootState = 84;      // [order]

  //
  static final byte requestCalibrateVerify = 90;// [order]

  //
  static final byte requestMoveBody = 100;      // [order] [64 + x] [64 + y] [64 + z]
  static final byte requestRotateBody = 102;    // [order] [64 + x] [64 + y]
}
