# 🚀 Static Branch Predictor for RISC-V Processor

## 📌 Overview

This project implements a **Static Branch Predictor** for a pipelined **RISC-V processor**. The predictor reduces control hazards by applying predefined static branch prediction rules based on branch direction.

Static branch prediction is a simple yet effective technique to improve pipeline performance by making fixed assumptions about branch behavior.

---

## 🧠 Prediction Strategy

The implemented predictor follows classical static branch prediction rules:

* ✅ **Forward Branch → Predicted NOT Taken**
* ✅ **Backward Branch → Predicted Taken**

Backward branches typically represent loops, therefore predicting them as taken improves execution efficiency.

---

## ⚙️ Design Description

The predictor determines branch direction by comparing:

* Current Program Counter (PC)
* Branch Target Address

### Prediction Logic

* If Target Address < Current PC → Branch is **Backward → Taken**
* If Target Address > Current PC → Branch is **Forward → Not Taken**

---

## 🏗️ Architecture Integration

The branch predictor is designed to work with a pipelined RISC-V processor and helps in:

* Reducing control hazards
* Improving instruction throughput
* Supporting efficient pipeline execution

---

## 🛠️ Tools & Technologies Used

* Verilog / SystemVerilog
* Vivado / ModelSim (Simulation & Verification)
* GTKWave (Waveform Visualization)

---

## 📂 Project Structure

```
Static-Branch-Predictor/
│
├── RTL/                # Verilog/SystemVerilog source files
├── Testbench/          # Testbench files
├── Waveforms/          # Simulation waveform results
├── Docs/               # Design explanation and notes
└── README.md
```

---

## ▶️ Simulation & Verification

The design was verified using testbenches to ensure correct branch prediction behavior under different branch conditions.

Waveforms were analyzed to confirm:

* Correct branch direction detection
* Accurate prediction signal generation
* Proper pipeline support behavior

---

## 📊 Applications

* RISC-V Processor Design
* Pipeline Hazard Reduction
* Microarchitecture Optimization
* Educational Processor Development

---

## 🔮 Future Improvements

* Dynamic Branch Prediction
* Branch Target Buffer (BTB)
* Performance Comparison with Dynamic Predictors
* Integration with Full Pipelined RISC-V Core

---

## 👩‍💻 Author

**Wayna Ali**
Electronics Engineering Student
Interest Areas: RTL Design, IC Design, Processor Microarchitecture


