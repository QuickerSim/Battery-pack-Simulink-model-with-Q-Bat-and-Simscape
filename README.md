
# Battery With Heat Transfer Modeled with ROM from Q-Bat
[![View Battery pack Simulink model with Q-Bat and Simscape on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/103870-battery-pack-simulink-model-with-q-bat-and-simscape)

This repository shows how to model electrothermal behavior of a battery 
with a cooling system by combining Simscape&trade; from MathWorks&reg; and Q-Bat 
from QuickerSim.  A 14-cell battery model with temperature dependent
behavior is connected to a reduced-order model (ROM) to model heat transfer
in 3D geometry.  The ROM models the battery cells, tabs, cooling plate, and
coolant flowing through the cooling plate.

### :arrow_down: Please use this link instead of the download button: [Download link](https://github.com/QuickerSim/Battery-pack-Simulink-model-with-Q-Bat-and-Simscape/releases/download/1.0.0/BatteryPackModel.zip) :arrow_down:


Run startup_ssc_battery_rom_qbat.m to get started 
* Please visit the [Q-Bat](https://www.mathworks.com/products/connections/product_detail/quickersim-q-bat.html) and [QuickerSim](https://emobility.quickersim.com/) 
page to learn more about modeling heat transfer in 3-D systems.
* Please visit the [Simscape Electrical](https://www.mathworks.com/products/simscape-electrical.html) 
page to learn more about modeling electrical systems.

## **Simulation Results with One Faulted Cell**
![](Images/temperature_contour_map_Simscape_data.png)
![](Images/cell_mean_temps_fault_cell6.png)

## **Simulation Model in Simulink**
![](Images/ssc_battery_rom_qbat_01_top_level.png)
![](Images/ssc_battery_rom_qbat_02_electrothermal_exchange.png)
![](Images/ssc_battery_rom_qbat_03_electrical_cells.png)
