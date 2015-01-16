#IoT Starter for iOS
IoT Starter is a demo application for interacting with the IBM Internet of Things Foundation.
The application turns your mobile device into a sensor that publishes and receives data to and from
the cloud using the MQTT protocol.

##Short description
The IBM Internet of Things (IoT) Foundation is a cloud service for managing all of your connected devices.
It provides functionality for creating recipes which determine how devices communicate with each other.
This application works as one of those connected devices, and provides a variety of events and commands
that it can publish or receive to and from.

The application can publish data to the following event topics:
- Accelerometer
- Touchmove
- Text
- Gamepad (Currently disabled)

The application can receive data on the following command topics:
- Color
- Light
- Text
- Alert

For more information on IoT Foundation, refer to https://internetofthings.ibmcloud.com/#/

##How it works
A device that is registered with IoT Foundation may publish and subscribe to data that is presented as either an event or command using the MQTT protocol.
The IBM WebSphere iOS MQTT Client is used to publish and subscribe to IoT Foundation. This client can be downloaded as part of the Mobile Messaging & M2M Client Pack, available at:

https://www.ibm.com/developerworks/community/blogs/c565c720-fe84-4f63-873f-607d87787327/entry/download?lang=en

MQTT is a lightweight messaging protocol that supports publish/subscribe messaging. With MQTT, an application publishes
messages to a topic. These messages may then be received by another application that is subscribed to that topic. This
allows for a detached messaging network where the subscribers and publishers do not need to be aware of each other.
The topics used by this application can be seen in the table below:
##Topics
|Topic|Sample Topic|Sample Message|
|:---------- |:---------- |:------------|
|iot-2/evt/<event>/fmt/json|iot-2/evt/touchmove/fmt/json|{"d":{"screenX":0,"screenY":0,"deltaX":0,"deltaY":0}}|
|iot-2/cmd/<command>/fmt/json|iot-2/cmd/light/fmt/json|{"d":{"light":"toggle"}}|

For more information on the MQTT protocol, see http://mqtt.org/

##Try it
In order to try the application, you must have an IoT Foundation organization. For instructions, refer https://internetofthings.ibmcloud.com/#/. Once registered, you must register your device with your organization.

On launching the application for the first time, you will need to enter your credentials to connect your device to the IoT Foundation. The required information to connect your device includes:
- Your Organization ID, e.g. ab1cd
- Your Device ID, e.g. the MAC Address of your device. This should be the same ID as the device that you registered in your IoT Foundation organization.
- Your device authorization token. This is returned when registering your device with the IoT Foundation.

Once you have entered the necessary credentials, you may activate your device as a sensor. Pressing the 'Activate Sensor' button will connect the device to the IoT Foundation and allow it to begin publishing and receiving data.

##Prerequisites
Required:
- An IBM Internet of Things Foundation organization. https://internetofthings.ibmcloud.com/#/

##Installation
To install this application, import the IoTstarter.xcodeproj project into XCode. Nothing else should need to be done if you are just going to run the application on the iOS simulator. If you want to run the application on a real device, you must configure the build settings to use the appropriate code signing.

