/*
 * File       Communication class for Freenove Hexapod Robot
 * Author     Ethan Pan @ Freenove (support@freenove.com)
 * Date       2019/11/15
 * Copyright  Copyright © Freenove (http://www.freenove.com)
 * License    Creative Commons Attribution ShareAlike 3.0
 *            (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 * -----------------------------------------------------------------------------------------------*/

import processing.serial.*;
import processing.net.*; 

class Communication {
  private PApplet parent;

  Communication(PApplet pApplet) {
    parent = pApplet;
  }

  private int readTimeout = 500;

  public byte[] SendCommand(byte[] outData) {
    byte[] inData = null;

    readTimeout = 500;
    if (isSerialAvailable) {
      serial.clear();
      SerialWrite(outData);
      inData = SerialRead();
    } else if (isClientAvailable) {
      client.clear();
      ClientWrite(outData);
      inData = ClientRead();
    }
    if (inData != null) {
      if (inData[0] == Orders.orderDone) {
      } else if (inData[0] == Orders.orderStart) {
        WaitCommandDone();
      }
      return inData;
    }
    return null;
  }

  private boolean WaitCommandDone() {
    byte[] inData = null;

    readTimeout = 10000;
    if (isSerialAvailable) {
      inData = SerialRead();
    } else if (isClientAvailable) {
      inData = ClientRead();
    }
    if (inData != null)
      if (inData[0] == Orders.orderDone)
        return true;
    return false;
  }

  private Client client; 
  public boolean isClientAvailable = false;

  public boolean StartClient() {
    StopClient();
    println(Time() + "Client connection start: connect to port...");

    try {
      client = new Client(parent, "192.168.4.1", 65535);
      if (client.active())
      {
        println(Time() + "Client connection success");
        isClientAvailable = true;
        return true;
      }
    }
    catch (Exception e) {
      e.printStackTrace();
    }

    println(Time() + "Client connection failed");
    return false;
  }

  private void ClientWrite(byte[] data) {
    byte[] dataWrite = new byte[data.length + 2];
    dataWrite[0] = Orders.transStart;
    for (int i = 0; i < data.length; i++)
      dataWrite[i+1] = data[i];
    dataWrite[data.length + 1] = Orders.transEnd;
    client.write(dataWrite);
  }

  private byte[] ClientRead() {
    byte[] inData = new byte[16];
    int inDataNum = 0;
    int startTime = millis();

    while (true) {
      if (client.available() > 0) {
        byte[] inTemp = new byte[1];
        client.readBytes(inTemp);
        byte inByte = inTemp[0];

        if (inByte == Orders.transStart)
          inDataNum = 0;
        inData[inDataNum++] = inByte;
        if (inByte == Orders.transEnd)
          if (inData[0] == Orders.transStart)
            break;
        startTime = millis();
      }
      if (millis () - startTime > readTimeout) {
        println(Time() + "Client read failed: time out");
        return null;
      }
      delay(2);
    } 

    if (inData[0] == Orders.transStart && inData[inDataNum - 1] == Orders.transEnd) {
      byte[] data = new byte[inDataNum - 2];
      for (int i = 0; i < inDataNum - 2; i++)
        data[i] = inData[i + 1];
      return data;
    }

    println(Time() + "Client read failed: incorrect data format");
    return null;
  }

  public void StopClient() {
    if (isClientAvailable) {
      isClientAvailable = false;
      client.stop();
      println(Time() + "Client connection stop");
    }
  }

  private Serial serial;
  private String serialName;
  public boolean isSerialAvailable = false;

  public boolean StartSerial() {
    StopSerial();
    println(Time() + "Serial connection start: detecte serial...");
    String[] serialNames = Serial.list();
    if (serialNames.length == 0) {
      println(Time() + "Serial connection failed: no serial detected");
      return false;
    }
    print(Time() + "Serial detected: ");
    for (int i = 0; i < serialNames.length; i++)
      print(serialNames[i] + " ");
    println("");
    for (int i = 0; i < serialNames.length; i++) {
      println(Time() + "Serial connection attempt: " + serialNames[i] + "...");
      try {
        serial = new Serial(parent, serialNames[i], 115200);
        serial.clear();
        delay(2000);
        SerialWrite(serial, new byte[]{Orders.requestEcho});
        readTimeout = 500;
        byte[] data = SerialRead(serial);
        if (data != null) {
          if (data[0] == Orders.echo) {
            serialName = serialNames[i];
            println(Time() + "Serial connection success: " + this.serialName);
            isSerialAvailable = true;
            return true;
          }
        }
        serial.stop();
      }
      catch (Exception e) {
        e.printStackTrace();
      }
    }
    println(Time() + "Serial connection failed: detected serial, no serial responded");
    return false;
  }

  private boolean SerialWrite(byte[] data) {
    if (isSerialAvailable) {
      SerialWrite(serial, data);
      return true;
    } else
      println(Time() + "Serial write failed: serial is not available");
    return false;
  }

  private byte[] SerialRead() {
    if (isSerialAvailable) {
      byte[] data = SerialRead(serial);
      if (data != null)
        return data;
    } else
      println(Time() + "Serial read failed: serial is not available");
    return null;
  }

  private void SerialWrite(Serial serial, byte[] data) {
    byte[] dataWrite = new byte[data.length + 2];
    dataWrite[0] = Orders.transStart;
    for (int i = 0; i < data.length; i++)
      dataWrite[i+1] = data[i];
    dataWrite[data.length + 1] = Orders.transEnd;
    serial.write(dataWrite);
  }

  private byte[] SerialRead(Serial serial) {
    byte[] inData = new byte[16];
    int inDataNum = 0;
    int startTime = millis();

    while (true) {
      if (serial.available() > 0) {
        byte[] inTemp = new byte[1];
        serial.readBytes(inTemp);
        byte inByte = inTemp[0];

        if (inByte == Orders.transStart)
          inDataNum = 0;
        inData[inDataNum++] = inByte;
        if (inByte == Orders.transEnd)
          if (inData[0] == Orders.transStart)
            break;
        startTime = millis();
      }
      if (millis () - startTime > readTimeout) {
        println(Time() + "Serial read failed: time out");
        return null;
      }
      delay(2);
    } 

    if (inData[0] == Orders.transStart && inData[inDataNum - 1] == Orders.transEnd) {
      byte[] data = new byte[inDataNum - 2];
      for (int i = 0; i < inDataNum - 2; i++)
        data[i] = inData[i + 1];
      return data;
    }

    println(Time() + "Serial read failed: incorrect data format");
    return null;
  }

  public void StopSerial() {
    if (isSerialAvailable) {
      isSerialAvailable = false;
      serial.stop();
      println(Time() + "Serial connection stop");
    }
  }

  public String Time() {
    return hour() + ":" + minute() + ":" + second() + " ";
  }
}
