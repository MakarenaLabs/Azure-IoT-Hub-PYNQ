# Azure IoT Hub PYNQ
PYNQ project for Azure IoT Hub interface. Currently compatible with [MicroZed 7010](http://zedboard.org/product/microzed) board (tested with [MicroZed Carrier Card Kit for Arduino](http://zedboard.org/product/arduino-cc)) and [Ultra96v2](http://zedboard.org/product/ultra96-v2-development-board) board (tested with [TEP0006-01 expansion pin module](http://www.trenz-electronic.de/fileadmin/docs/Trenz_Electronic/Pmods/TEP0006/REV01/Documents/TRM-TEP0006-01.pdf)). 
This project need PYNQ 2.5 minimum version (for MicroZed 7010 you can rebuild the image with [this repo](https://github.com/MakarenaLabs/PYNQ/tree/image_v2.5.4)).

## Getting Started
IMPORTANT: This project need PYNQ 2.5 minimum version (for MicroZed 7010 you can rebuild the image with [this repo](https://github.com/MakarenaLabs/PYNQ/tree/image_v2.5.4)).
- download the full repository with recurse clone on your board 
    ```
    git clone --recurse-submodules git@github.com:MakarenaLabs/Azure-IoT-Hub-PYNQ.git
    ```
- enter in the repository root and launch the setup script
    ```
    cd <path to repo>/Azure-IoT-Hub-PYNQ
    chmod 777 setup_azure_iot_hub.sh
    ./setup_azure_iot_hub.sh
    ```
    If the script finishes without errors, using PM2 list you will see only running scripts. A full command reference [here](https://pm2.io/docs/runtime/reference/pm2-cli/).
    ```
    sudo pm2 list
    ```
    NB: use bash terminal on your board.
- at the first install, the script sets some placeholder configurations (like IP address of server and Azure account), so you must launch the configuration script (for IP configuration and Azure IoT Hub credentials)
    ```
    chmod 777 ./change_settings.sh
    ./change_settings.sh
    ```
- At the end, you can see the interface on \<ip board>:3200.

## Full documentation

Full documentation 
[here](https://docs.google.com/document/d/1zusVmM8us5797ECCJanOmzfd2w4-kQgj82vszYKFV9w/edit?usp=sharing).
