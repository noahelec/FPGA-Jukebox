# FPGA-Jukebox

This repository contains the design and implementation of an enhanced "simple iPod" that includes an LED strength meter to display the strength of the audio signal. The project uses an embedded PicoBlaze processor to perform real-time averaging of audio signal samples.

## Overview

In this project, the simple iPod from a previous lab is enhanced by adding an LED strength meter using an embedded PicoBlaze processor. This project demonstrates the use of embedded processors for digital signal processing (DSP) and showcases the integration of hardware and software components.

## Project Structure

The project involves the following tasks:

1. **Instantiate PicoBlaze Processor**
   - Integrate the PicoBlaze processor into the simple iPod design.
   - Merge the Lab 2 solution with the PicoBlaze in-class activity.

2. **Main Program**
   - Toggle `LEDR[0]` every 1 second.

3. **Interrupt Routine**
   - Activated each time a new audio sample is read from the Flash memory.
   - Calculate the absolute value of each sample and accumulate the sum of 256 samples.
   - Divide the accumulated sum by 256 to perform averaging.
   - Output the averaged value to `LEDG[7:0]` (or `LEDR[9:2]` for DE1-SoC).
   - Reset the accumulator for the next set of samples.


## Usage

1. **Setup Project**
   - Ensure the `pacoblaze` directory is in the project search path.
   - Merge the Lab 2 template with the PicoBlaze in-class activity.

2. **Compile and Program**
   - Compile the project using Quartus.
   - Program the FPGA with the generated bitstream.

3. **Run and Test**
   - Observe `LEDR[0]` toggling every 1 second.
   - Verify the LED strength meter displaying the average audio signal strength.



