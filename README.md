# VGA Display on FPGA (DE10-Lite)

This project implements a **VGA (Video Graphics Array) controller** on an FPGA to display 8 vertical color bars on a monitor. 

The design is written in SystemVerilog and targets a standard resolution of 640x480 @ 60Hz.

It demonstrates fundamental digital logic concepts, including clock management via PLL (using IP Catalog), synchronous counters, and combinational color-mapping logic.

## Features

- **Resolution:** 640x480 pixels with a 60Hz refresh rate.
- **Clock Management:** Utilizes an on-chip PLL to derive a 25 MHz pixel clock from a 50 MHz input clock.
- **Synchronous Design:** Features a robust reset mechanism linked to the PLL lock signal to ensure stability.
- **Modular Architecture:** Separated into distinct modules for horizontal/vertical counting, pattern generation, and top-level integration.

## System Architecture

1. **PLL Module:** Down-converts the 50MHz system clock to the required 25MHz pixel clock.
2. **Horizontal Counter:** Tracks the current pixel in a row (0-799) and generates the enable signal for the vertical counter.
3. **Vertical Counter:** Tracks the current line (0-524).
4. **Pattern Generator:** Combinational logic that assigns RGB values based on the current X,Y coordinates.

## Color Bar Logic

The screen is divided into 8 vertical bars.

The VGA_pattern_generator module uses the H_Count_Value and V_Count_Value to determine the active display area and toggle the 4-bit Red, Green, and Blue outputs.

**Display Sequence:**
1. White 2. Red 3. Green 4. Blue 5. Black 6. Yellow 7. Pink 8. Azure

## RTL Structure

VGA_top.sv (Top Level)

 PLL.sv (IP Core)
 
 horizontal_counter.sv
 
 vertical_counter.sv
 
 VGA_pattern_generator.sv

## Requirements for implementation

- FPGA development board (with a VGA port).
- VGA to VGA or VGA to HDMI cable.
- Screen for display.

## Usage

1. **Connect** the cable between the FGPA and the screen.
2. **Compile and program** the SystemVerilog code onto the FPGA board using your preferred tool (Vivado, Quartus, etc.).
3. The FPGA board will **display** the pattern on the screen (Watch).

## Options for further implementation

- Implement dynamic pattern movement.
- Add an image buffer using Block RAM (BRAM).
- Develope a GIF using several images.
