/*
 * File       Control orders for Freenove Hexapod Robot
 * Author     Ethan Pan @ Freenove (support@freenove.com)
 * Date       2019/11/15
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

  // Data stream control orders, range is 128 ~ 255
  // These orders are used to control data stream.

  static final byte transStart = (byte)128;
  static final byte transEnd = (byte)129;


  // Orders, range is 0 ~ 127
  // Orders are used to control target.
  // Some orders have proprietary response orders, others use orderStart and orderDone.
  // The even orders is sent by the requesting party, and the odd orders is sent by the responding party.

  // Non blocking orders, range is 0 ~ 63

  // Connection
  // Request echo, to confirm the target
  static final byte requestEcho = 0;                // [order]
  // Respond echo
  static final byte echo = 1;                       // [order]

  // Function
  // Request supply voltage
  static final byte requestSupplyVoltage = 10;      // [order]
  // Respond supply voltage
  static final byte supplyVoltage = 11;             // [order] [voltage * 100 / 128] [voltage * 100 % 128]
  // Request change I/O port state
  static final byte requestChangeIO = 20;           // [order] [IOindex] [1/0]

  // Installation
  static final byte requestMoveLeg = 30;            // [order] [leg] [64 + dx] [64 + dy] [64 + dz]
  static final byte requestCalibrate = 32;          // [order]

  // Blocking orders, range is 64 ~ 127

  // Installation
  static final byte requestInstallState = 64;       // [order]
  static final byte requestCalibrateState = 66;     // [order]
  static final byte requestBootState = 68;          // [order]
  static final byte requestCalibrateVerify = 70;    // [order]

  // Simple action
  static final byte requestCrawlForward = 80;       // [order]
  static final byte requestCrawlBackward = 82;      // [order]
  static final byte requestCrawlLeft = 84;          // [order]
  static final byte requestCrawlRight = 86;         // [order]
  static final byte requestTurnLeft = 88;           // [order]
  static final byte requestTurnRight = 90;          // [order]
  static final byte requestActiveMode = 92;         // [order]
  static final byte requestSleepMode = 94;          // [order]
  static final byte requestSwitchMode = 96;         // [order]

  // Complex action
  static final byte requestCrawl = 110;             // [order] [64 + x] [64 + y] [64 + angle]
  static final byte requestChangeBodyHeight = 112;  // [order] [64 + height]
  static final byte requestMoveBody = 114;          // [order] [64 + x] [64 + y] [64 + z]
  static final byte requestRotateBody = 116;        // [order] [64 + x] [64 + y] [64 + z]
  static final byte requestTwistBody = 118;         // [order] [64 + xMove] [64 + yMove] [64 + zMove] [64 + xRotate] [64 + yRotate] [64 + zRotate]

  // Universal responded orders, range is 21 ~ 127
  // These orders are used to respond orders without proprietary response orders.

  static final byte orderStart = 21;                // [order]
  static final byte orderDone = 23;                 // [order]
}
