# 📝 Memory Swap System

## 📖 Introduction
In digital systems, we sometimes need to **copy or swap data between memory locations** without heavy processor intervention.  
This improves performance and efficiency for tasks like moving or exchanging data between two memory addresses.

The **Memory Swap System** implements this concept using:

- 🧠 **Finite State Machine (FSM) Controller**
- 💾 **Small Memory Block (Register File)**
- 🔀 **Multiplexers** to select addresses, data, and write-enable signals

The FSM automatically handles the **sequence of read/write operations** to store, copy, or swap data between two addresses.

---

## ⚙️ Description

- The system contains a **2^N × BITS** memory block  
  *(Depth = 2^N, Width = BITS)*.
- The **FSM Controller** generates control signals `sel` and `w` to drive the multiplexers and write-enable signal.
- **Multiplexers** choose which address and data source are active at any time (external inputs or data read from memory).

### FSM States

| State | sel | w | Action                          |
|-------|-----|---|---------------------------------|
| **S0** | 00  | 0 | Idle – waiting for `swap` signal |
| **S1** | 01  | 1 | Store *A (write to Address A)   |
| **S2** | 10  | 1 | Copy from **B → A**             |
| **S3** | 11  | 1 | Copy from **A → B**             |

After completing a cycle, the FSM automatically **returns to Idle (S0)**.

---

## 🔌 Signals

| Signal      | Width | Direction | Description                                      |
|-------------|-------|-----------|--------------------------------------------------|
| `clk`       | 1     | input     | Positive-edge system clock                       |
| `rstn`      | 1     | input     | Asynchronous active-low reset                    |
| `swap`      | 1     | input     | Enables FSM to start the swap/copy sequence      |
| `address_a` | N     | input     | Address A                                       |
| `address_b` | N     | input     | Address B                                       |
| `address_r` | N     | input     | Default read address                            |
| `address_w` | N     | input     | Default write address                           |
| `data_w`    | BITS  | input     | Data to be written                              |
| `we`        | 1     | input     | External write enable                           |
| `data_r`    | BITS  | output    | Data read from memory                           |

---

## 🧠 System Components

### FSM Controller  
Generates `sel` and `w` signals based on the current state.

### Multiplexers  
- **Two 4×1 muxes** select read and write addresses.  
- **One 2×1 mux** selects the data input source (`data_w` or `data_r`).  
- **One 2×1 mux** selects the write enable signal (external or FSM-controlled).

### Register File (Memory)  
Stores the data and provides simultaneous read/write access.

---

## 📂 Project Structure

| File/Folder          | Description                                              |
|----------------------|----------------------------------------------------------|
| `README.md`          | This documentation file                                  |
| `Top.v`              | Top-level module integrating FSM, multiplexers, and register file |
| `Swap_Fsm.v`         | FSM Controller generating control signals                 |
| `mux4_1.v`           | 4×1 multiplexer module (parameterized width)              |
| `mux2_1.v`           | 2×1 multiplexer module (parameterized width)              |
| `reg_file.v`         | Register file / memory block                              |
| `testbench.v`        | Testbench to verify the design                           |
| `schematic/`         | Contains generated block diagrams or netlists (Vivado, DC)|
| `syn/`               | Contains synthesis scripts and output files              |

---

## 🚀 How It Works

1. **Idle (S0):** Wait for the `swap` signal.  
2. **Store A (S1):** Write external `data_w` to address A.  
3. **Copy B→A (S2):** Copy data from address B to address A internally.  
4. **Copy A→B (S3):** Copy data from address A to address B internally.  
5. **Return to Idle (S0):** FSM automatically returns to Idle state.  

---

## 📸 Block Diagram  

Include your block diagram here:

![Memory Swap Block Diagram](Memory-Swap/Screenshot 2025-09-24 202413.png)


