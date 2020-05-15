# SCHEEPDOG
Code for computer-controlled electrical stimulation to control collective cell migration

Citation: TJ Zajdel\*, G Shim\*, L Wang, A Rossello-Martinez, DJ Cohen. "SCHEEPDOG: programming electric cues to dynamically herd large-scale cell migration." *Cell Systems*, in press.

## Contents
- Instrumentation wiring diagram for two-axis setup [scheepdog_instrumentation](scheepdog_instrumentation.png)
- MATLAB script for driving two-axis stimulation

## Instrumentation used
- Keithley 2450 source meter
- Keithley 2400 source meter
- Digilent Analog Discovery 2
- Prologix GPIB-USB Controller 6.0 (for GPIB connection b/w computer and Keithley 2400)

## Code dependencies
- Mathworks Instrument Control Toolbox
- Mathworks Data Acquisition Toolbox
- Digilent Waveforms
