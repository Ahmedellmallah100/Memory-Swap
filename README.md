# Memory-Swap
📝 Memory Swap System
📖 Introduction

In digital systems, sometimes we need to copy or swap data between memory locations without heavy processor intervention. This improves performance and efficiency for tasks like moving or exchanging data between two memory addresses.

The Memory Swap System implements this concept using:

A finite state machine (FSM) controller.

A small memory block (register file).

Multiplexers to select addresses, data, and write-enable signals.

The FSM automatically handles the sequence of read/write operations to store, copy, or swap data between two addresses.

⚙️ Description

The system contains a 2^N × BITS memory block (depth = 2^N, width = BITS).

The FSM controller generates control signals sel and w to drive the multiplexers and write-enable signal.

Multiplexers choose which address and data source are active at any time (external inputs or data read from memory).

The system supports four FSM states:

State	sel	w	Action
S0	00	0	Idle – waiting for swap signal
S1	01	1	Store *A (write to Address A)
S2	10	1	Copy from B to A
S3	11	1	Copy from A to B

After completing a cycle, the FSM automatically returns to Idle (S0).

🔌 Signals
Signal	Width	Direction	Description
clk	1	input	Positive edge system clock
rstn	1	input	Asynchronous active-low reset
swap	1	input	Enables FSM to start the swap/copy sequence
address_a	N	input	Address A
address_b	N	input	Address B
address_r	N	input	Default read address
address_w	N	input	Default write address
data_w	BITS	input	Data to be written
we	1	input	External write enable
data_r	BITS	output	Data read from memory
🧠 System Components

FSM Controller
Generates sel and w signals based on the current state.

Multiplexers

Two 4×1 muxes select read and write addresses.

One 2×1 mux selects the data input source (data_w or data_r).

One 2×1 mux selects the write enable signal (external or FSM-controlled).

Register File (Memory)
Stores the data and provides simultaneous read/write access.

📂 Project Structure
File/Folder	Description
README.md	This documentation file.
Top.v	Top-level module integrating FSM, multiplexers, and register file.
Swap_Fsm.v	FSM Controller generating control signals.
mux4_1.v	4×1 multiplexer module (parameterized width).
mux2_1.v	2×1 multiplexer module (parameterized width).
reg_file.v	Register file / memory block.
testbench.v	Testbench to verify the design.
schematic/	Contains generated block diagrams or netlists from tools (Vivado, DC).
syn/	Contains synthesis scripts and output files.
🚀 How It Works

Idle (S0): Wait for the swap signal.

Store A (S1): Write external data_w to address A.

Copy B→A (S2): Copy data from address B to address A internally.

Copy A→B (S3): Copy data from address A to address B internally.

Return to Idle (S0) automatically.

📸 Block Diagram

You can include your diagram (like the one you posted):

![Memory Swap Block Diagram](Block_diagram/memory_swap_block_diagram.png)

✅ Tips for GitHub

Save this file as README.md in the root of your repo.

Place your diagrams in a folder like Block_diagram/.

Update the file paths for your images.

Add a license (MIT, Apache 2.0, etc.) if it’s public.
