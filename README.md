<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Memory Swap System — README</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <style>
    :root{
      --bg:#f7f8fb; --card:#ffffff; --muted:#6b7280; --accent:#0b6efd;
      --mono: "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }
    body{
      font-family: var(--mono);
      background: linear-gradient(180deg,#f7f8fb 0%, #eef2f7 100%);
      margin:0; padding:32px; color:#0f172a;
    }
    .container{ max-width:900px; margin:0 auto; }
    header{ display:flex; align-items:center; gap:16px; margin-bottom:20px; }
    header h1{ margin:0; font-size:28px; }
    header p{ margin:0; color:var(--muted); }
    .card{ background:var(--card); border-radius:12px; padding:22px; box-shadow:0 6px 18px rgba(15,23,42,0.06); margin-bottom:18px;}
    h2{ margin-top:0; }
    table{ width:100%; border-collapse:collapse; margin-top:12px; }
    th,td{ text-align:left; padding:8px 10px; border-bottom:1px solid #eef2f7; font-size:14px; }
    th{ background:#fbfdff; color:#0b1220; font-weight:600; }
    pre.code{ background:#0b122040; padding:12px; border-radius:8px; color:#021124; overflow:auto; }
    .small{ color:var(--muted); font-size:14px; }
    .cols{ display:grid; grid-template-columns:1fr 1fr; gap:12px; align-items:start;}
    .diagram img{ max-width:100%; border-radius:8px; border:1px solid #eef2f7; }
    ul{ margin:8px 0 0 18px; }
    .state-svg{ width:100%; max-width:420px; display:block; margin-top:8px; }
    footer{ text-align:center; margin-top:20px; color:var(--muted); font-size:13px; }
    @media (max-width:720px){ .cols{ grid-template-columns:1fr; } header{flex-direction:column;align-items:start} }
  </style>
</head>
<body>
  <div class="container">
    <header>
      <div>
        <h1>Memory Swap System</h1>
        <p class="small">Top-level FSM + multiplexers + register-file design for copying/swapping memory locations.</p>
      </div>
    </header>

    <section class="card">
      <h2>Introduction</h2>
      <p class="small">
        This project implements an automatic memory swap/copy mechanism. The design uses a small memory block (register file),
        a finite state machine (FSM) controller and several multiplexers to perform store/copy/swap operations between two user-specified
        addresses. The FSM sequences read/write steps so the host CPU doesn't need to manage every action.
      </p>
    </section>

    <section class="card">
      <h2>Description</h2>
      <div class="small">
        <p>
          - Memory is <strong>2<sup>N</sup> × BITS</strong> (depth = 2^N rows, width = BITS bits per row).<br>
          - FSM Controller produces control outputs <code>sel</code> (2 bits) and <code>w</code> (1 bit) to drive multiplexers and write-enable behavior.<br>
          - Multiplexers choose the active read/write addresses and the source for <code>data_w</code> (external input or data read from memory).<br>
          - Typical FSM states (S0..S3) implement Idle / store A / copy B→A / copy A→B. After a cycle FSM returns to Idle.
        </p>

        <table aria-label="FSM states">
          <thead>
            <tr><th>State</th><th>sel</th><th>w</th><th>Action</th></tr>
          </thead>
          <tbody>
            <tr><td>S0</td><td>00</td><td>0</td><td>Idle — wait for <code>swap</code></td></tr>
            <tr><td>S1</td><td>01</td><td>1</td><td>Store external <code>data_w</code> to Address A</td></tr>
            <tr><td>S2</td><td>10</td><td>1</td><td>Copy data from Address B → Address A</td></tr>
            <tr><td>S3</td><td>11</td><td>1</td><td>Copy data from Address A → Address B</td></tr>
          </tbody>
        </table>
      </div>
    </section>

    <section class="card">
      <h2>Signals</h2>
      <table>
        <thead>
          <tr><th>Signal</th><th>Width</th><th>Direction</th><th>Description</th></tr>
        </thead>
        <tbody>
          <tr><td><code>clk</code></td><td>1</td><td>input</td><td>Positive-edge system clock</td></tr>
          <tr><td><code>rstn</code></td><td>1</td><td>input</td><td>Asynchronous active-low reset</td></tr>
          <tr><td><code>swap</code></td><td>1</td><td>input</td><td>Start copy/swap FSM sequence</td></tr>
          <tr><td><code>address_a</code></td><td>N</td><td>input</td><td>Address A</td></tr>
          <tr><td><code>address_b</code></td><td>N</td><td>input</td><td>Address B</td></tr>
          <tr><td><code>address_r</code></td><td>N</td><td>input</td><td>Default read address</td></tr>
          <tr><td><code>address_w</code></td><td>N</td><td>input</td><td>Default write address</td></tr>
          <tr><td><code>data_w</code></td><td>BITS</td><td>input</td><td>Write data (external)</td></tr>
          <tr><td><code>we</code></td><td>1</td><td>input</td><td>External write-enable</td></tr>
          <tr><td><code>data_r</code></td><td>BITS</td><td>output</td><td>Data read from memory</td></tr>
        </tbody>
      </table>
    </section>

    <section class="card cols">
      <div>
        <h2>System Components</h2>
        <ul>
          <li><strong>FSM Controller</strong> — generates <code>sel</code>, <code>w</code> and sequences the procedure.</li>
          <li><strong>4×1 mux (read addr)</strong> — chooses between default read addr, A, B, or 0.</li>
          <li><strong>4×1 mux (write addr)</strong> — chooses between default write addr, 0, A, or B.</li>
          <li><strong>2×1 mux (data)</strong> — selects external <code>data_w</code> or <code>data_r</code> (internal feedback).</li>
          <li><strong>2×1 mux (we)</strong> — selects between external <code>we</code> or FSM-driven write enable.</li>
          <li><strong>Register File</strong> — the memory block (2<sup>N</sup> × BITS).</li>
        </ul>
      </div>

      <div class="diagram">
        <h3>Block Diagram</h3>
        <!-- put your diagram at 'Block_diagram/memory_swap_block_diagram.png' -->
        <img src="Block_diagram/memory_swap_block_diagram.png" alt="Memory Swap Block Diagram">
        <p class="small">Place the block diagram image at <code>Block_diagram/memory_swap_block_diagram.png</code>.</p>
      </div>
    </section>

    <section class="card">
      <h2>Project Structure</h2>
      <table>
        <thead><tr><th>File / Folder</th><th>Description</th></tr></thead>
        <tbody>
          <tr><td><code>README.html</code></td><td>This HTML documentation (you can also keep a plain <code>README.md</code>).</td></tr>
          <tr><td><code>Top.v</code></td><td>Top-level module (FSM + muxes + reg_file).</td></tr>
          <tr><td><code>Swap_Fsm.v</code></td><td>FSM controller implementation.</td></tr>
          <tr><td><code>mux4_1.v</code></td><td>Parameterized 4:1 multiplexer module.</td></tr>
          <tr><td><code>mux2_1.v</code></td><td>Parameterized 2:1 multiplexer module.</td></tr>
          <tr><td><code>reg_file.v</code></td><td>Register file / memory implementation.</td></tr>
          <tr><td><code>testbench.v</code></td><td>Testbench for simulation.</td></tr>
          <tr><td><code>Block_diagram/</code></td><td>Folder for visual diagrams (PNG/SVG).</td></tr>
          <tr><td><code>syn/</code></td><td>Synthesis scripts & outputs.</td></tr>
        </tbody>
      </table>
    </section>

    <section class="card">
      <h2>How it works (quick)</h2>
      <ol>
        <li>Idle (S0) — wait for <code>swap</code> to become high.</li>
        <li>S1 — store the external <code>data_w</code> into Address A (write enabled by FSM).</li>
        <li>S2 — use internal read <code>data_r</code> to copy Address B → Address A.</li>
        <li>S3 — use internal read <code>data_r</code> to copy Address A → Address B.</li>
        <li>FSM returns to S0 and waits for next command.</li>
      </ol>

      <h3>Small inline FSM diagram</h3>
      <!-- Simple SVG depiction of the 4-state loop -->
      <svg class="state-svg" viewBox="0 0 520 160" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="FSM diagram">
        <defs><style> .s{fill:#ffffff;stroke:#0b6efd;stroke-width:2} .t{font:14px/1.2 sans-serif; fill:#07203b} .arrow{stroke:#0b6efd; stroke-width:2; fill:none; marker-end:url(#m);} </style></defs>
        <marker id="m" markerWidth="8" markerHeight="8" refX="7" refY="4" orient="auto"><path d="M0,0 L8,4 L0,8 z" fill="#0b6efd"/></marker>
        <rect class="s" x="18" y="18" width="110" height="60" rx="8"/><text class="t" x="34" y="50">S0 (idle)  sel=00</text>
        <rect class="s" x="140" y="18" width="110" height="60" rx="8"/><text class="t" x="156" y="44">S1  sel=01  w=1</text>
        <rect class="s" x="262" y="18" width="110" height="60" rx="8"/><text class="t" x="278" y="44">S2  sel=10  w=1</text>
        <rect class="s" x="384" y="18" width="110" height="60" rx="8"/><text class="t" x="400" y="44">S3  sel=11  w=1</text>
        <path class="arrow" d="M128,48 L140,48" />
        <path class="arrow" d="M250,48 L262,48" />
        <path class="arrow" d="M372,48 L384,48" />
        <path class="arrow" d="M494,48 L528,48" />
        <!-- return arrow -->
        <path class="arrow" d="M528,48 C520,48 520,120 260,120 C140,120 18,92 18,78" marker-end="url(#m)"/>
      </svg>

      <p class="small">Note: The SVG above is a simple illustration — replace with your diagram if you prefer.</p>
    </section>

    <section class="card">
      <h2>Notes & Tips</h2>
      <ul class="small">
        <li>Make sure parameter widths match across modules (e.g., use <code>{width{1'b0}}</code> to zero-extend single-bit constants when connecting to N-bit ports).</li>
        <li>Do not directly drive top-level <code>input</code> nets from internal module outputs — use internal <code>wire</code>s for mux outputs and feed the register file from those wires.</li>
        <li>Place testbenches in a dedicated folder and exclude them from synthesis flows.</li>
      </ul>
    </section>

    <footer>
      <p>© Memory Swap — Project README. Place images in <code>Block_diagram/</code> and update paths if required.</p>
    </footer>
  </div>
</body>
</html>
