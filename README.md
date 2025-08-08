# UART Transmitter (Verilog)

## 📌 Overview
This project implements a **UART Transmitter** in Verilog, designed for serial data communication.  
The module accepts **8-bit parallel input data**, optionally appends a **parity bit**, and transmits the data serially following the standard UART protocol.

It features:
- **Finite State Machine (FSM)** for control logic
- **Parallel-to-Serial Conversion** via a serializer
- **Configurable Parity Bit** generation
- **Multiplexer-based Output Selection**

---

## ⚙️ Features
- **8-bit parallel data input**
- **`valid_in`** signal to load data when high
- **`en_parity`** signal to enable/disable parity bit transmission
- **FSM Controller** to manage UART transmission states
- **Serializer** to convert parallel data to serial format
- **Parity Calculator** for optional error detection
- **4-to-1 MUX** for selecting:
  1. Start bit  
  2. Serialized data bits  
  3. Parity bit (if enabled)  
  4. Stop bit
- **Busy Signal** (`busy`) indicating active transmission

---

## 🖥️ Module I/O

### Inputs
| Signal       | Width | Description |
|--------------|-------|-------------|
| `clk`        | 1     | System clock |
| `reset`      | 1     | Asynchronous reset |
| `valid_in`   | 1     | High to load new parallel data |
| `en_parity`  | 1     | High to enable parity bit |
| `data_in`    | 8     | Parallel input data |

### Outputs
| Signal    | Width | Description |
|-----------|-------|-------------|
| `tx_out`  | 1     | Serial output bit stream |
| `busy`    | 1     | High while UART is transmitting |

---

## 🔄 Transmission Flow (FSM States)
The UART transmitter uses **five states**:

1. **Idle**  
   - Waits for `valid_in` to go high  
   - `busy` is low

2. **Start Bit**  
   - Outputs logic `0` for one bit period  
   - Signals the start of transmission

3. **Serialization**  
   - Shifts out the 8-bit parallel data (LSB first)  
   - Controlled by the serializer

4. **Parity** *(if enabled)*  
   - Outputs calculated parity bit  
   - Skipped if `en_parity` is low

5. **End Bit**  
   - Outputs logic `1` (stop bit)  
   - Returns to **Idle** when done

---

## 🏗️ Internal Blocks
1. **FSM Controller**  
   - Manages transitions between the five UART states  
   - Controls MUX selection and serializer enable signals

2. **Serializer**  
   - Converts 8-bit parallel data into a serial stream  
   - Controlled by FSM

3. **Parity Calculator**  
   - Generates parity bit if `en_parity` is high  
   - Default: Even parity

4. **4-to-1 MUX**  
   - Selects output between start bit, serialized data, parity bit, and stop bit  
   - Selection comes from FSM

---

## 📂 File Structure
```
NTI-Final-project-UART-TX-/
│── final project/
│ ├── uart_tx.v # UART_TX.v
│ ├── fsm_controller.v # FSM_controller.v
│ ├── serializer.v # PISO.v
│ ├── parity_calc.v # Parity_calculator.v
│ ├── mux_4to1.v # mux.v
│── final project/
│ ├── tb_uart_tx.v #  TB_UART_TX.v
│── README.md
```

---

## 🧪 Testbench
The included testbench:
- Sends various 8-bit patterns
- Tests with/without parity bit
- Verifies correct `busy` signal behavior
- Checks serial output bit sequence

---

## 🚀 How to Run
1. Clone the repository:
   ```bash
   git clone https://github.com/<your-username>/uart_tx.git
   cd uart_tx
