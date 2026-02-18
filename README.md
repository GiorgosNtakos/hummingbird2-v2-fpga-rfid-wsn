# HB-2 v2 FPGA Implementations for Secure RFID and Wireless Sensor Networks

![Language](https://img.shields.io/badge/HDL-VHDL-blue)
![FPGA](https://img.shields.io/badge/Target-Xilinx%20Artix--7-orange)
![Toolchain](https://img.shields.io/badge/Vivado-2019.2-green)
![Simulation](https://img.shields.io/badge/ModelSim-10.5b-purple)
![License](https://img.shields.io/badge/License-BSD--3--Clause-yellow)
[![DOI](https://img.shields.io/badge/DOI-10.1109%2FMOCAST65744.2025.11083910-blue)](https://doi.org/10.1109/MOCAST65744.2025.11083910)



## Overview

This repository provides FPGA implementations of an enhanced Hummingbird-2 lightweight cryptographic design (HB-2 v2), targeting secure communication in RFID systems and wireless sensor networks (WSNs).

Two architectural approaches are explored:

- **Unrolled architecture** — maximizes parallelism and throughput
- **Rolled architecture** — minimizes hardware area

Both approaches are also evaluated with pipelining optimizations.

---

## Publication

This work corresponds to the conference paper:

**Optimizing Lightweight Cryptographic Schemes for Enhanced Security in RFID and Wireless Sensor Networks**  
MoCAST 2025 — International Conference on Modern Circuits and Systems Technologies  

DOI: https://doi.org/10.1109/MOCAST65744.2025.11083910  

**Authors:**  
George Ntakos  
Evangelia Konstantopoulou  
Nicolas Sklavos  

SCYTALE Group  
Department of Computer Engineering & Informatics  
University of Patras, Greece  

👉 The official publication is available via IEEE Xplore.

*Note: The publisher PDF is not redistributed in this repository.*

---

## Implemented Architectures

### Full Unrolled Architecture
- Fully parallel implementation
- Highest throughput potential
- Increased hardware resource consumption

### Full Rolled Architecture
- Iterative round-based design
- Reduced area footprint
- Lower throughput compared to unrolled design

### Pipelined Variants
Pipeline stages are introduced to increase operating frequency and throughput at the cost of additional registers.

---

## FPGA Implementation Results

### Hardware Utilization

| Algorithm | Key Size | Block Size | LUTs | FFs | Slices | Device |
|----------|----------|------------|------|-----|--------|--------|
| HB2_v2 (full unrolled) | 128 | 16 | 1190 | 64 | 376 | Artix-7 |
| HB2_v2 (full rolled) | 128 | 16 | 575 | 83 | 171 | Artix-7 |
| HB2_v2 (full unrolled & pipelined) | 128 | 16 | 1497 | 736 | 429 | Artix-7 |
| HB2_v2 (full rolled & pipelined) | 128 | 16 | 701 | 635 | 251 | Artix-7 |

---

### Performance

| Algorithm | Frequency (MHz) | Throughput (Mbps) | Efficiency |
|----------|------------------|-------------------|------------|
| HB2_v2 (full unrolled) | 71.429 | 285.716 | 0.75 |
| HB2_v2 (full rolled) | 285.714 | 142.857 | 0.83 |
| HB2_v2 (full unrolled & pipelined) | 384.615 | 6153.84 | 14.34 |
| HB2_v2 (full rolled & pipelined) | 454.545 | 427.807 | 1.7 |

---

## Verification

Reference verification vectors are provided in:

test_vectors/


These vectors were used for functional validation of all implementations.

---

## Comparison: HB-2 v1 vs HB-2 v2

### Security Motivation

The original Hummingbird-2 design (HB-2 v1) has been shown to be vulnerable to related-key attacks under certain conditions. To address these weaknesses, an enhanced version (HB-2 v2) was developed with architectural and structural modifications aimed at improving resistance to such attacks while maintaining suitability for resource-constrained environments.

HB-2 v2 implementations were evaluated using multiple architectural strategies and compared against baseline HB-2 implementations.

---

### Architectural Differences

**HB-2 v1**
- Baseline implementation from the original design
- Pipeline-oriented architectures
- Optimized primarily for performance

**HB-2 v2**
- Redesigned structure to improve resistance to related-key attacks
- Two main architectural approaches:
  - Fully unrolled (parallel)
  - Fully rolled (iterative)
- Optional pipelining for performance scaling
- Explicit area vs throughput trade-off exploration

---

### FPGA Implementation Comparison

#### HB-2 v1 (Baseline)

| Architecture | Frequency (MHz) | Throughput (Mbps) |
|--------------|------------------|-------------------|
| Pipeline | 243.9 | 1951.21 |
| Encryption pipeline | 317.46 | 5079.36 |

---

#### HB-2 v2 (This Work)

| Architecture | Frequency (MHz) | Throughput (Mbps) | LUTs | Slices |
|--------------|------------------|-------------------|------|--------|
| Full unrolled | 71.429 | 285.716 | 1190 | 376 |
| Full rolled | 285.714 | 142.857 | 575 | 171 |
| Full unrolled & pipelined | 384.615 | 6153.84 | 1497 | 429 |
| Full rolled & pipelined | 454.545 | 427.807 | 701 | 251 |

---

### Discussion

The redesigned HB-2 v2 introduces a broader design space enabling different optimization goals:

- **Unrolled architectures** achieve high parallelism and throughput but require more hardware resources.
- **Rolled architectures** significantly reduce area, making them suitable for highly constrained devices.
- **Pipelining** substantially increases operating frequency and throughput at the cost of additional registers.

Compared to the baseline HB-2 v1 implementations:

- HB-2 v2 offers improved flexibility in performance-area trade-offs.
- The pipelined unrolled variant achieves the highest throughput among all evaluated designs.
- Rolled variants provide minimal area footprints suitable for low-cost RFID and sensor nodes.
- Security improvements against related-key attacks are obtained with manageable hardware overhead.

---

### Design Trade-offs

HB-2 v2 demonstrates that enhanced security can be achieved without sacrificing implementability in constrained hardware platforms, though performance characteristics vary depending on architectural choices.

This makes HB-2 v2 adaptable to a wide spectrum of IoT deployments, from high-performance gateways to ultra-low-cost sensor devices.

---

## Toolchain

- HDL: VHDL  
- Simulation: ModelSim – Intel FPGA Starter Edition 10.5b  
- Synthesis & Implementation: Xilinx Vivado 2019.2 WebPACK Edition  
- Target FPGA: Xilinx Artix-7 (xc7a200tffg1156-3)

---

## Applications

- Secure RFID systems  
- Wireless sensor networks  
- Resource-constrained IoT devices  
- Embedded security modules  

---

## License

This project is licensed under the BSD 3-Clause License.

This repository contains research implementations developed within
the SCYTALE Research Group, Department of Computer Engineering and
Informatics (CEID), University of Patras, Greece.

Supervision: Prof. Nikolaos Sklavos

This work is associated with the conference publication:

"Optimizing Lightweight Cryptographic Schemes for Enhanced Security
in RFID and Wireless Sensor Networks"
MoCAST 2025 — International Conference on Modern Circuits and
Systems Technologies
DOI: 10.1109/MOCAST65744.2025.11083910

The views expressed in this repository are solely those of the
authors and do not necessarily reflect the views of the University
of Patras, the Department, or the SCYTALE Research Group.

The publisher’s version of the paper is not distributed in this
repository. Please refer to the official conference proceedings
or IEEE Xplore for the published article.

© Copyright of the implementation and repository content:
Georgios Ntakos, Evangelia Konstantopoulou,
Nicolas Sklavos, 2025

All rights reserved.
