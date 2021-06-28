# SCHEEPDOG
Code for computer-controlled electrical stimulation to guide collective cell migration

Citations:
1. TJ Zajdel\*, G Shim\*, L Wang, A Rossello-Martinez, DJ Cohen. "[SCHEEPDOG: programming electric cues to dynamically herd large-scale cell migration](https://doi.org/10.1016/j.cels.2020.05.009)." *Cell Systems*,  vol. 10, no. 6, pp. 506-514, 2020.
2. TJ Zajdel, G Shim, DJ Cohen. "[Come together: bioelectric healing-on-a-chip](https://doi.org/10.1101/2020.12.29.424578)." *bioRxiv*, 2020.

## Contents
- CAD and code supporting two-axis SCHEEPDOG device (ref 1)
  - Instrumentation wiring diagram for two-axis setup ([scheepdog_instrumentation.png](scheepdog_instrumentation.png))
  - MATLAB script for driving two-axis stimulation ([scheepdog_driver.m](scheepdog_driver.m))
  - Design file for laser-cut acrylic components for the two-axis SCHEEPDOG device ([scheepdog_drawings.pdf](scheepdog_drawings.pdf))
  - Silhouette studio file to cut silicone stencil for two-axis SCHEEPDOG stimulation ([scheepdog_stencil.studio3](scheepdog_stencil.studio3))
- CAD and code supporting convergent stimulation (ref 2)
  - Design files for laser-cut acrylic components for the convergent field stimulation device ([convergent_field_drawings.pdf](convergent_field_drawings.pdf))
  - Silhouette studio file to cut silicone stencil for convergent field stimulation ([convergent_field_stencil.studio3](convergent_field_stencil.studio3))
- CAD and code supporting single-axis stimulation for dynamics studies
  - Design files for laser-cut acrylic components for the single-axis field stimulation device ([single_axis_drawings.pdf](single_axis_drawings.pdf))
  - Silhouette studio file to cut silicone stencil for single-axis field stimulation ([single_axis_stencil.studio3](single_axis_stencil.studio3))
  
## Instrumentation used
Note that this is just the instrumentation that we had available. You may use any pair of source meters with similar specs (e.g. two Keithley 2400s) and whichever interface cables you require or prefer.
- Keithley 2450 source meter - x-axis stimulation
- Keithley 2400 source meter - y-axis stimulation
- Digilent Analog Discovery 2 - digital multimeter
- Prologix GPIB-USB Controller 6.0 (for GPIB connection b/w computer and Keithley 2400)

## Code dependencies
- [Instrument Control Toolbox](https://www.mathworks.com/products/instrument.html)
- [Data Acquisition Toolbox](https://www.mathworks.com/products/data-acquisition.html)
- [Digilent Analog Discovery Support from MATLAB](https://www.mathworks.com/hardware-support/digilent-analog-discovery.html)
