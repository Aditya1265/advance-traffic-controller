# Traffic Light Controller - FSM Based (Verilog)

This project implements a **Finite State Machine (FSM)** based traffic light controller using **Verilog HDL**. It simulates a real-world intersection that handles:

- North-South and East-West traffic lights
- Pedestrian crossing requests
- Emergency vehicle prioritization

---

## Files

| File                           | Description                                       |
|--------------------------------|---------------------------------------------------|
| `traffic_light_controller.v`   | Main FSM module with pedestrian and emergency logic |
| `tb_traffic_light_controller.v`| Testbench to simulate and generate waveforms      |
| `traffic_light.vcd`            | Generated VCD file for waveform viewing (after simulation) |

---

## Features

- 4-way traffic light system (NS & EW)
- Pedestrian request handling (extends green light)
- Emergency vehicle override for either direction
- Clean state-based control using Moore FSM

---

## FSM States

| State Code       | Meaning               |
|------------------|-----------------------|
| `S0`             | NS Green              |
| `S1`             | NS Yellow             |
| `S2`             | EW Green              |
| `S3`             | EW Yellow             |
| `S4`             | Emergency NS Green    |
| `S5`             | Emergency EW Green    |

---

## How to Simulate (Icarus Verilog + GTKWave)

### 1. Compile
```bash
iverilog -o traffic_sim tb_traffic_light_controller.v traffic_light_controller.v
