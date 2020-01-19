<p align="center">
  <img width="400" src="logo.png">
  <h3 align="center">use a Raspberry Pi with a smartphone or tablet</h3>
</p>
<br><br>

[![MIT](https://img.shields.io/badge/license-MIT-blue)](https://github.com/pmonta/gerber2graphtec/blob/master/LICENSE)
[![SHELL](https://img.shields.io/badge/language-shell-orange)](https://www.python.org)

## About

InnocentPi is a tool for creating an wifi access point on a raspberry pi, to which you can connect via **VNC** but also at the same time the raspberry pi acts as a client which allows a user to use the pi as a **fully operating computer** via a phone or an iPad.<br>

The build in wifi of the Raspberry acts as an AP and a second USB wifi adapter will be used for the client connection.


## Getting Started

Start with a clean install of the [latest release of Raspbian](https://www.raspberrypi.org/downloads/raspbian/) (currently Buster). Raspbian Buster Lite is NOT recommended.

1. Update Raspbian followed by a reboot:
```
sudo apt-get update
sudo apt-get upgrade
sudo reboot
```

2. Set the WiFi country as well as the Locale in raspi-config's **Localisation Options**: `sudo raspi-config`

3. Make sure your Wifi dongle is plugged in! A list of supported dongles can be found [here](https://elinux.org/RPi_USB_Wi-Fi_Adapters).

With the prerequisites done, you can proceed to the install section.


## Install

To be able to run this software, first you have to change the access permission:

```
chmod 755 setup.sh
```

then to install InnocentPi run the following command:

```
sudo ./setup.sh
```

## Usage

After the reboot at the end of the installation the wireless network will be configured as an access point as follows:

* IP address: **192.168.123.1**
* DHCP range: **192.168.123.2** to **192.168.123.200**
* SSID: **WIFIII**
* Password: **password**

Also VNC will be automatically activated and you can access the Raspberry Pi's desktop via a [VNC Viewer](https://www.realvnc.com/de/connect/download/viewer/) under the IP address above.

## Known issues
Due to a bug inside ghostscript, you may need to downgrade to version < 9.26 or you might 

## Credits

Thanks to the authors of the following projects:

- [raspap-webgui](https://github.com/billz/raspap-webgui/blob/master/README.md)
- [raspberrypi.org - AP](https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md)
- [raspberrypi.org - VNC](https://www.raspberrypi.org/documentation/remote-access/vnc/)