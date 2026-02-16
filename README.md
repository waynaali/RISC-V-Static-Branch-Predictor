# 🚀 Static Branch Predictor for RISC-V Processor

## 📌 Overview

This project implements a **Static Branch Predictor** integrated with a pipelined **RISC-V processor datapath**.

The predictor reduces control hazards by applying predefined static branch prediction rules based on branch direction.

Static branch prediction is a simple yet effective technique to improve pipeline performance by making fixed assumptions about branch behavior.

---

## 🏗️ Architecture Diagram

![Architecture Diagram](Docs/architecture.png)

The static branch predictor is integrated within the control path of the processor and assists in early branch decision making to minimize pipeline stalls.

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

* If `Target Address < Current PC` → **Backward Branch → Taken**
* If `Target Address > Current PC` → **Forward Branch → Not Taken**

The prediction signal is generated combinationally and integrated into the processor control flow.

---

## 📈 Simulation Results

![Waveform Output](Docs/waveform.png)

Waveform analysis verifies:

* Correct branch direction detection
* Accurate prediction signal generation
* Proper integration with pipeline behavior

---

## 🛠️ Tools & Technologies Used

* SystemVerilog
* ModelSim / Vivado
* GTKWave

---

## 📂 Project Structure

```
RISC-V-Static-Branch-Predictor/
│
├── RTL/
├── Testbench/
├── Memories/
├── Docs/
└── README.md
```

---

## 📊 Applications

* RISC-V Processor Design
* Pipeline Hazard Reduction
* Microarchitecture Exploration
* Educational RTL-Based CPU Design

---

## 🔮 Future Improvements

* Dynamic Branch Prediction
* Branch Target Buffer (BTB)
* Performance comparison with dynamic predictors
* Integration with full 5-stage pipelined RISC-V core

---

## 👩‍💻 Author

**Wayna Ali**
Electronics Engineering Student
Interest Areas: RTL Design, IC Design, Processor Microarchitecture



