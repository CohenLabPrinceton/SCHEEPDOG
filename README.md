# SCHEEPDOG
Code for computer-controlled electrical stimulation to guide collective cell migration

Citation: TJ Zajdel\*, G Shim\*, L Wang, A Rossello-Martinez, DJ Cohen. "SCHEEPDOG: programming electric cues to dynamically herd large-scale cell migration." *Cell Systems*, in press.

## Contents
- Instrumentation wiring diagram for two-axis setup ([scheepdog_instrumentation.png](scheepdog_instrumentation.png))
- MATLAB script for driving two-axis stimulation ([scheepdog_driver.m](scheepdog_driver.m))
- Design files for laser-cut acrylic components for the two-axis SCHEEPDOG device ([scheepdog_drawings.pdf](scheepdog_drawings.pdf))
- Silhouette studio file to cut silicone stencil for two-axis SCHEEPDOG stimulation ([scheepdog_stencil.studio3](scheepdog_stencil.studio3))
- Design files for laser-cut acrylic components for the convergent field stimulation device ([convergent_field_drawings.pdf](convergent_field_drawings.pdf))
- Silhouette studio file to cut silicone stencil for convergent field stimulation ([convergent_field_stencil.studio3](convergent_field_stencil.studio3))

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
