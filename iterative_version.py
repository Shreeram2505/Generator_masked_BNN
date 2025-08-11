import math

# Python script to print the weighted_inputs_1 module
def main():
    verilog = """
    `timescale 1ns/1ps
    `default_nettype none
    
module weighted_inputs_1(

    input [2:0] inputs,

    input w,

    output reg [2:0] wi
);

    always @(*) begin
        if (w == 1'b0) begin
            wi = ~inputs + 1;
        end else begin
            wi = inputs;
        end
    end

endmodule
"""
    print(verilog)

if __name__ == "__main__":
    main()

# Python script to print the two LUT modules
def main():
    verilog = """module lut0 (
    input  wire a,       
    input  wire b,      
    input  wire c_in,    
    input  wire r_i,     
    output wire r_out,   
    output wire c_masked 
);
    wire carry_unmasked;

    assign carry_unmasked = (a & b) | (a & c_in) | (b & c_in);

    // Mask it:

    assign c_masked = r_i ^ carry_unmasked;

    // Pass r_i through as r_out:

    assign r_out = r_i;

endmodule

module lut1 (
    input  wire a,       
    input  wire b,      
    input  wire c_in,
    input  wire r_flow,
    input  wire r_i,     
    output wire r_out,   
    output wire c_masked 
);
    wire carry_unmasked, carry;

    assign carry = r_flow ^ c_in;

    assign carry_unmasked = (a & b) | (a & carry) | (b & carry);

    // Mask it:

    assign c_masked = r_i ^ carry_unmasked;

    // Pass r_i through as r_out:

    assign r_out = r_i;

endmodule
"""
    print(verilog)

if __name__ == "__main__":
    main()

def generate_full_adder_modules1():
    return f'''module half_adder(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adder(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adder HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adder HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNAND(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule
'''




def generate_addXbit(x):
    verilog = []
    verilog.append(f"module add{x}bit(")
    verilog.append(f"    input wire [{x-1}:0] a,")
    verilog.append(f"    input wire [{x-1}:0] b,")
    verilog.append("    input wire  cin,")
    verilog.append(f"    output wire [{x}:0] y,")
    verilog.append("    output wire cout,")
    verilog.append("    output wire cout_bar")
    verilog.append(");")
    verilog.append("")

    # Wires for carry
    verilog.append("    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;")
    for i in range(1, x+1):
        verilog.append(f"wire c{i};")
    verilog.append("")

    # Full adders
    for i in range(x):
        c_prev = "cin" if i == 0 else f"c{i}"
        verilog.append(f"full_adder fa{i}(.S(y[{i}]), .C(c{i+1}), .X(a[{i}]), .Y(b[{i}]), .Z({c_prev}));")
    verilog.append("")

    # WddlNAND gates for cout computation
    verilog.append(f"WddlNAND wn1(.A(~a[{x-1}]), .B(b[{x-1}]), .C(~c{x}), .S(s1), .S1(s1_1));")
    verilog.append(f"WddlNAND wn2(.A(a[{x-1}]), .B(~b[{x-1}]), .C(~c{x}), .S(s2), .S1(s2_1));")
    verilog.append(f"WddlNAND wn3(.A(a[{x-1}]), .B(b[{x-1}]), .C(c{x}), .S(s3), .S1(s3_1));")
    verilog.append(f"WddlNAND wn4(.A(~a[{x-1}]), .B(~b[{x-1}]), .C(c{x}), .S(s4), .S1(s4_1));")
    verilog.append("")

    # Outputs
    verilog.append("assign cout = ~(s1 & s2 & s3 & s4);")
    verilog.append("assign cout_bar = ~cout;")
    verilog.append("assign y[{0}] = cout;".format(x))
    verilog.append("")
    verilog.append("endmodule\n")
    return "\n".join(verilog)


def generate_all_adders(m, n ):
    from_bits = m
    to_bits = m + int(math.log2(n)) 

    output = [generate_full_adder_modules1()]
    for bits in range(from_bits, to_bits + 1):
        output.append(generate_addXbit(bits))
    return "\n".join(output)



def generate_full_adder_modules2():
    return f'''module half_adderbar(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adderbar(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adderbar HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adderbar HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNANDbar(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule
'''

def generate_addXbitbar(x):
    verilog = []
    verilog.append(f"module add{x}bitbar(")
    verilog.append(f"    input wire [{x-1}:0] a,")
    verilog.append(f"    input wire [{x-1}:0] b,")
    verilog.append("    input wire  cin,")
    verilog.append(f"    output wire [{x}:0] y,")
    verilog.append("    output wire cout,")
    verilog.append("    output wire cout_bar")
    verilog.append(");")
    verilog.append("")

    # Wires for carry
    verilog.append("    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;")
    for i in range(1, x+1):
        verilog.append(f"wire c{i};")
    verilog.append("")

    # Full adders
    for i in range(x):
        c_prev = "cin" if i == 0 else f"c{i}"
        verilog.append(f"full_adderbar fa{i}(.S(y[{i}]), .C(c{i+1}), .X(a[{i}]), .Y(b[{i}]), .Z({c_prev}));")
    verilog.append("")

    # WddlNAND gates for cout computation
    verilog.append(f"WddlNANDbar wn1(.A(~a[{x-1}]), .B(b[{x-1}]), .C(~c{x}), .S(s1), .S1(s1_1));")
    verilog.append(f"WddlNANDbar wn2(.A(a[{x-1}]), .B(~b[{x-1}]), .C(~c{x}), .S(s2), .S1(s2_1));")
    verilog.append(f"WddlNANDbar wn3(.A(a[{x-1}]), .B(b[{x-1}]), .C(c{x}), .S(s3), .S1(s3_1));")
    verilog.append(f"WddlNANDbar wn4(.A(~a[{x-1}]), .B(~b[{x-1}]), .C(c{x}), .S(s4), .S1(s4_1));")
    verilog.append("")

    # Outputs
    verilog.append("assign cout = ~(s1 & s2 & s3 & s4);")
    verilog.append("assign cout_bar = ~cout;")
    verilog.append("assign y[{0}] = cout_bar;".format(x))
    verilog.append("")
    verilog.append("endmodule\n")
    return "\n".join(verilog)


def generate_all_adders_bar(m, n):
    from_bits = m
    to_bits = m + int(math.log2(n)) 

    output = [generate_full_adder_modules2()]
    for bits in range(from_bits, to_bits + 1):
        output.append(generate_addXbitbar(bits))
    return "\n".join(output)



def generate_adder_tree(module_name: str,num_inputs, input_bit_width ):
    assert (num_inputs & (num_inputs - 1)) == 0, "num_inputs must be a power of 2"
    module_lines = []

    #module_name = f"adder_tree "
    max_stage = int(math.log2(num_inputs)) + input_bit_width

    module_lines.append("")
    module_lines.append(f"module {module_name} (")
    for i in range(num_inputs):
        module_lines.append(f"    input  wire [{input_bit_width - 1}:0] in{i},")
    out_width = input_bit_width + int(math.log2(num_inputs))
    module_lines.append(f"    output wire [{out_width - 1}:0] sum\n);")
    module_lines.append("")

    stage = 0
    current_nodes = [(f"in{i}", input_bit_width) for i in range(num_inputs)]
    wires, regs, logic = [], [], []
    final_wire = ""

    while len(current_nodes) > 1:
        next_nodes = []
        for i in range(0, len(current_nodes), 2):
            a, wa = current_nodes[i]
            b, wb = current_nodes[i + 1]
            width = max(wa, wb)
            adder_width = width
            next_width = adder_width + 1
            low_name = f"stage{stage}_{i//2}_lo"
            reg_name = f"stage{stage}_{i//2}"
            wires.append((low_name, next_width - 1))
            regs.append((reg_name, next_width, low_name))
            adder_mod = f"add{adder_width}bit"
            logic.append(f"    {adder_mod} u{stage}_{i//2} (.a({a}), .b({b}), .cin(1'b0), .y({low_name}), .cout(), .cout_bar());")
            next_nodes.append((reg_name, next_width))
            if len(current_nodes) == 2:
                final_wire = low_name  # Capture the final output wire name before register
        current_nodes = next_nodes
        stage += 1

    logic.append(f"\n    assign sum = {{1'b0, {final_wire}}};\n")

    for w, width in wires:
        module_lines.append(f"    wire [{width}:0] {w};")
    for r, width, _ in regs:
        module_lines.append(f"    reg  [{width - 1}:0] {r};")
    module_lines.append("")

    module_lines.extend(logic)

    module_lines.append("    always @(*) begin")
    for r, _, src in regs:
        module_lines.append(f"        {r} = {{1'b0, {src}}};")
    module_lines.append("    end\nendmodule")

    return "\n".join(module_lines)



def generate_adder_tree_bar(module_name: str,num_inputs, input_bit_width):
    assert (num_inputs & (num_inputs - 1)) == 0, "num_inputs must be a power of 2"
    module_lines = []
    
    #module_name = f"adder_tree_bar"
    max_stage = int(math.log2(num_inputs)) + input_bit_width

    module_lines.append("")
    module_lines.append(f"module {module_name} (")
    for i in range(num_inputs):
        module_lines.append(f"    input  wire [{input_bit_width - 1}:0] in{i},")
    out_width = input_bit_width + int(math.log2(num_inputs))
    module_lines.append(f"    output wire [{out_width - 1}:0] sum\n);")
    module_lines.append("")

    stage = 0
    current_nodes = [(f"in{i}", input_bit_width) for i in range(num_inputs)]
    wires, regs, logic = [], [], []
    final_wire = ""

    while len(current_nodes) > 1:
        next_nodes = []
        for i in range(0, len(current_nodes), 2):
            a, wa = current_nodes[i]
            b, wb = current_nodes[i + 1]
            width = max(wa, wb)
            adder_width = width
            next_width = adder_width + 1
            low_name = f"stage{stage}_{i//2}_lo_bar"
            reg_name = f"stage{stage}_{i//2}_bar"
            wires.append((low_name, next_width - 1))
            regs.append((reg_name, next_width, low_name))
            adder_mod = f"add{adder_width}bitbar"
            logic.append(f"    {adder_mod} u{stage}_{i//2}_bar (.a({a}), .b({b}), .cin(1'b0), .y({low_name}), .cout(), .cout_bar());")
            next_nodes.append((reg_name, next_width))
            if len(current_nodes) == 2:
                final_wire = low_name  # Capture the final output wire name before register
        current_nodes = next_nodes
        stage += 1

    logic.append(f"\n    assign sum = {{1'b0, {final_wire}}};\n")

    for w, width in wires:
        module_lines.append(f"    wire [{width}:0] {w};")
    for r, width, _ in regs:
        module_lines.append(f"    reg  [{width - 1}:0] {r};")
    module_lines.append("")

    module_lines.extend(logic)

    module_lines.append("    always @(*) begin")
    for r, _, src in regs:
        module_lines.append(f"        {r} = {{1'b0, {src}}};")
    module_lines.append("    end\nendmodule")

    return "\n".join(module_lines)
import math

def main():
    verilog = f"""module mux_1 (

    input  wire a, b, s,

    output wire y
);

assign y = (~s & a)|(s & b);

endmodule


module mux_2(
    input  [2:0] a,
    input  [2:0] b,
    input  [2:0] c,
    input  [2:0] d,
    input        s0,
    input        s1,
    output [2:0] y
);
    assign y = (s1 == 0 && s0 == 0) ? a :
               (s1 == 0 && s0 == 1) ? b :
               (s1 == 1 && s0 == 0) ? c :
               /* s1 == 1 && s0 == 1 */ d;
endmodule


module mux_3(
    input   a,
    input   b,
    input   c,
    input        s0,
    input        s1,
    output  y
);
    assign y = (s1 == 0 && s0 == 0) ? a :
               (s1 == 0 && s0 == 1) ? b :
               (s1 == 1 && s0 == 0) ? c :
               1'b0; // Default value for (s1 == 1 && s0 == 1)
endmodule


module mux_4(
    input  [2:0] a,
    input  [2:0] b,
    input  [2:0] c,
    input        s0,
    input        s1,
    output [2:0] y
);
    assign y = (s1 == 0 && s0 == 0) ? a :
               (s1 == 0 && s0 == 1) ? b :
               (s1 == 1 && s0 == 0) ? c :
               3'b000; // Default value for (s1 == 1 && s0 == 1)
endmodule

"""
    print(verilog)

if __name__ == "__main__":
    main()

import math

def gen_mux_5(num_inputs: int, input_bitsize: int) -> str:
    sum_width = input_bitsize + math.ceil(math.log2(num_inputs))
    lines = []
    lines.append("module mux_5(")
    lines.append(f"    input  [{sum_width-1}:0] a,")
    lines.append(f"    input  [{sum_width-1}:0] b,")
    lines.append(f"    input  [{sum_width-1}:0] c,")
    lines.append(f"    input  [{sum_width-1}:0] d,")
    lines.append(f"    input        s0,")
    lines.append(f"    input        s1,")
    lines.append(f"    output [{sum_width-1}:0] y")
    lines.append(");")
    lines.append("    assign y = (!s1 && !s0) ? a :")
    lines.append("               (!s1 &&  s0) ? b :")
    lines.append("               ( s1 && !s0) ? c :")
    lines.append("                              d;")
    lines.append("endmodule")
    
    
    return '\n'.join(lines)


    
def generate_activation_module(num_inputs : int , input_bitwidth : int):
    assert input_bitwidth >= 1, "Bit size must be at least 1"
    n = math.ceil(math.log2(num_inputs)) +input_bitwidth +1

    lines = []
    lines.append(f"module activation (")
    lines.append("")
    lines.append(f"    input [{n-1}:0] inputs0_0,")
    lines.append(f"    input [{n-1}:0] inputs0_1,")
    lines.append("")

    # Random mask inputs
    rand_inputs = ', '.join([f"r{i}_0" for i in range(n)])
    lines.append(f"    input {rand_inputs},")
    lines.append("")
    lines.append("    output masked_activation,")
    lines.append("    output mask")
    lines.append(");")
    lines.append("")

    # Internal wires
    lines.append(f"    wire " + ', '.join([f"r{i+1}" for i in range(n)]) + ";")
    lines.append(f"    wire " + ', '.join([f"masked_c{i}_0" for i in range(n)]) + ";")
    lines.append("")

    # LUT chain
    for i in range(n):
        if i == 0:
            lines.append(f"    lut0 l{i} (.a(inputs0_0[{i}]), .b(inputs0_1[{i}]), .c_in(1'b0), .r_i(r{i}_0), .r_out(r{i+1}), .c_masked(masked_c{i}_0));")
        else:
            lines.append(f"    lut1 l{i} (.a(inputs0_0[{i}]), .b(inputs0_1[{i}]), .c_in(masked_c{i-1}_0), .r_flow(r{i}), .r_i(r{i}_0), .r_out(r{i+1}), .c_masked(masked_c{i}_0));")
    lines.append("")

    lines.append(f"    wire carry = r{n} ^ masked_c{n-1}_0;")
    lines.append(f"    wire activation = (carry ^ inputs0_0[{n-1}] ^ inputs0_1[{n-1}]) ? 1'b0 : 1'b1;")
    lines.append("")

    lines.append("    assign masked_activation = activation ^ r{0};".format(n))
    lines.append("    assign mask = r{0};".format(n))
    lines.append("")
    lines.append("endmodule")

    return '\n'.join(lines)

def generate_activation_array_verilog(module_name: str, num_inputs:int,
                                    num_nodes:int , input_bitwidth : int) -> str:
    lines = []
    num_activations=num_nodes
    n=n = math.ceil(math.log2(num_inputs)) +input_bitwidth +1

    # Module declaration
    lines.append(f"module {module_name} (")

    # Inputs: paired inputs for each activation
    for i in range(num_activations):
        lines.append(f"    input  [{n - 1}:0] inputs{i}_0, inputs{i}_1,")

    # Random bits: 7 bits per activation
    for i in range(num_activations):
        r_bits = ", ".join([f"r{j}_{i}" for j in range(n)])
        lines.append(f"    input  {r_bits},")

    # Outputs
    for i in range(num_activations):
        lines.append(f"    output wire masked_activation{i},")
    for i in range(num_activations - 1):
        lines.append(f"    output wire mask{i},")
    lines.append(f"    output wire mask{num_activations - 1}\n);")
    lines.append("")

    # Instantiations of activation modules
    for i in range(num_activations):
        lines.append(f"    activation a{i} (")
        lines.append(f"        .inputs0_0(inputs{i}_0), .inputs0_1(inputs{i}_1),")
        for j in range(n):
            lines.append(f"        .r{j}_0(r{j}_{i}),")
        lines.append(f"        .masked_activation(masked_activation{i}),")
        lines.append(f"        .mask(mask{i})")
        lines.append("    );\n")

    lines.append("endmodule")

    return "\n".join(lines)


def generate_boolean_to_arithmetic_verilog(input_bitwidth: int ) -> str:
    verilog = []
    verilog.append("`timescale 1ns/1ps\n")
    verilog.append(f"module mux (\n")
    verilog.append("    input  wire a, b, s,\n")
    verilog.append("    output wire y\n);\n")
    verilog.append("assign y = (~s & a)|(s & b);\nendmodule\n\n")

    verilog.append(f"module boolean_arithmetic_coversion_1 (\n")
    verilog.append("    input  wire x0,\n")
    verilog.append("    input  wire x1,\n")
    verilog.append(f"    input  wire [{input_bitwidth-2}:0] r_mask,\n")
    verilog.append(f"    output wire [{input_bitwidth-1}:0] arith_share0,\n")
    verilog.append(f"    output wire [{input_bitwidth-1}:0] arith_share1\n);\n")

    verilog.append(f"    wire [{input_bitwidth-1}:0] y0;\n")
    verilog.append(f"    wire [{input_bitwidth-1}:0] y1;\n\n")

    verilog.append(f"    assign y0 = {{ r_mask, x0 }};\n")
    verilog.append(f"    assign y1 = {{ r_mask, x1 }};\n\n")

    verilog.append("    // stage1 for LSB\n")
    verilog.append("    assign arith_share0[0] = y0[0];\n\n")

    for i in range(1, input_bitwidth):
        if i == 1:
            a = f"y0[{i}]"
            b = f"y1[{i-1}] ^ y0[{i}]"
        else:
            a = f"y0[{i-1}] ^ y0[{i}]"
            b = f"y0[{i}] ^ y1[{i-1}]"
        verilog.append(f"    mux m{i}(.a({a}), .b({b}), .s(arith_share0[{i-1}]), .y(arith_share0[{i}]));\n")

    verilog.append(f"\n    assign arith_share1 = y1;\n")
    verilog.append("endmodule\n")

    return "\n".join(verilog)


def generate_bnn_layer_verilog(num_inputs, input_bitsize, num_nodes):
    
    sum_width = input_bitsize + math.ceil(math.log2(num_inputs))
    biased_sum_width = sum_width + 1

    lines = []
    # Module header and port list
    lines.append("module layer (")
    ports = []
    # control signals
    ports += [
        ("input wire", "", "clk"),
        ("input wire", "", "rst_n"),
        ("input wire", "", "start")
    ]
    # static inputs: inputsX_1
    inp_names = [f"inputs{i}_1" for i in range(num_inputs)]
    ports.append((f"input wire", f"[{input_bitsize-1}:0]", ", ".join(inp_names)))
    # act signals: act<node>_<branch>_<i>
    for node in range(num_nodes):
        for branch in [0,1]:
            act_names = [f"act{node}_{branch}_{i}" for i in range(num_inputs)]
            ports.append(("input wire", f"[{input_bitsize-1}:0]", ", ".join(act_names)))
    # weight buses (fixed 4 layers)
    for layer in range(num_nodes):
        ports.append((f"input wire", f"[{num_inputs-1}:0]", f"w{layer+1}_0_1, w{layer+1}_1_1"))
    # bias buses
    for i in range(1, num_nodes+1):
        names = [f"b{i}_{j}" for j in range(1, num_nodes+1)]
        ports.append(("input wire", f"[{sum_width-1}:0]", ", ".join(names)))
    # selector
    ports.append(("input wire", "[1:0]", "s"))
    # handshake output
    ports.append(("output reg", "", "done"))
    # registered outputs
    for node in range(num_nodes):
        names = [
            f"biased_sum{node}_0_r", f"biased_sum{node}_1_r",
            f"biased_sum{node}_0bar_r", f"biased_sum{node}_1bar_r"
        ]
        ports.append(("output reg", f"[{biased_sum_width-1}:0]", ", ".join(names)))
    for node in range(num_nodes):
        ports.append(("output reg", "", f"masked_activation{node}_1_r, masked_activation{node}bar_1_r"))
    for node in range(num_nodes):
        ports.append(("output reg", "", f"mask{node}_1_r, mask{node}bar_1_r"))

    # emit ports
    for i, (direction, width, namestr) in enumerate(ports):
        comma = "," if i < len(ports)-1 else ""
        if namestr:
            lines.append(f"  {direction} {width} {namestr}{comma}")
        else:
            lines.append(f"  {direction}{comma}")
    lines.append(");")
    lines.append("")

    # Internal wires
    lines.append("  // internal wires")
    for node in range(num_nodes):
        lines.append(f"  wire [{biased_sum_width-1}:0] biased_sum{node}_0, biased_sum{node}_1, biased_sum{node}_0bar, biased_sum{node}_1bar;")
        lines.append(f"  wire masked_activation{node}_1, masked_activation{node}bar_1;")
        lines.append(f"  wire mask{node}_1, mask{node}bar_1;")
    lines.append("  \n")
    for layer in range(num_nodes):
        for i in range(num_inputs):
            lines.append(f"  wire [{input_bitsize-1}:0] weighted_inputs{layer+1}_{i}_0, weighted_inputs{layer+1}_{i}_1;")
            lines.append(f"  wire [{input_bitsize-1}:0] new_weighted_inputs{layer+1}_{i}_0, new_weighted_inputs{layer+1}_{i}_1;")
    lines.append("  \n")
    lines.append(f"  wire [{sum_width-1}:0] sum1 [{num_nodes-1}:0], sum2 [{num_nodes-1}:0], sum1bar [{num_nodes-1}:0], sum2bar [{num_nodes-1} :0];")
    lines.append(f"  wire [{biased_sum_width-1}:0] biased_sum1 [{num_nodes-1}:0], biased_sum2 [{num_nodes-1}:0], biased_sum1bar [{num_nodes-1}:0], biased_sum2bar [{num_nodes-1}:0];")
    lines.append("  \n")
    for layer in range(num_nodes):
        for bit in range(2*num_nodes):
            for part in (1,2,3):
                lines.append(f"  wire [{input_bitsize-1}:0] act{layer}_{bit}_0_{part};")
                lines.append(f"  wire [{input_bitsize-1}:0] act{layer}_{bit}_1_{part};")
    lines.append("  \n")
    for layer in range(num_nodes):
        for bit in range(2*num_nodes):
            for part in (1,2,3):
                lines.append(f"  assign act{layer}_{bit}_0_{part}= act{layer}_0_{bit};")
                lines.append(f"  assign act{layer}_{bit}_1_{part}= act{layer}_1_{bit};")   
    lines.append(" ")

    # Weighted_inputs instantiation
    lines.append("  // weighted_inputs modules")
    for layer in range(num_nodes):
        for i in range(num_inputs):
            lines.append(f"  weighted_inputs_1 w{layer+1}_{i}    (.inputs(inputs{i}_1), .w(w{layer+1}_0_1[{i}]), .wi(weighted_inputs{layer+1}_{i}_0));")
            lines.append(f"  weighted_inputs_1 w{layer+1}_{i}_bar(.inputs(inputs{i}_1), .w(w{layer+1}_1_1[{i}]), .wi(weighted_inputs{layer+1}_{i}_1));")
    lines.append(" ")

    # Adder trees for sum1 and sum1bar
    lines.append("  // adder trees for sum1 and sum1bar")
    for node in range(num_nodes):
        for i in range(num_inputs):
            idx = node * num_inputs + i + 1
            lines.append(
                f"  mux_2 m{idx} (.a(weighted_inputs{node+1}_{i}_0), .b(act{node}_{i}_0_1), "
                f".c(act{node}_{i}_0_2), .d(act{node}_{i}_0_3), .s0(s[0]), .s1(s[1]), "
                f".y(new_weighted_inputs{node+1}_{i}_0));"
            )
        lines.append(f"  adder_tree add{node} (")
        for i in range(num_inputs):
            lines.append(f"    .in{i}(new_weighted_inputs{node+1}_{i}_0),")
        lines.append(f"    .sum(sum1[{node}])")
        lines.append("  );")
        lines.append(f"  adder_tree_bar addb{node} (")
        for i in range(num_inputs):
            lines.append(f"    .in{i}(new_weighted_inputs{node+1}_{i}_0),")
        lines.append(f"    .sum(sum1bar[{node}])")
        lines.append("  );\n")
    # Adder trees for sum2 and sum2bar
    lines.append("  // adder trees for sum2 and sum2bar")
    for node in range(num_nodes):
        base = num_nodes * num_inputs
        for i in range(num_inputs):
            idx = base + node * num_inputs + i + 1
            lines.append(
                f"  mux_2 m{idx} (.a(weighted_inputs{node+1}_{i}_1), .b(act{node}_{i}_1_1), "
                f".c(act{node}_{i}_1_2), .d(act{node}_{i}_1_3), .s0(s[0]), .s1(s[1]), "
                f".y(new_weighted_inputs{node+1}_{i}_1));"
            )
        lines.append(f"  adder_tree add{num_nodes+node} (")
        for i in range(num_inputs):
            lines.append(f"    .in{i}(new_weighted_inputs{node+1}_{i}_1),")
        lines.append(f"    .sum(sum2[{node}])")
        lines.append("  );")
        lines.append(f"  adder_tree_bar addb{num_nodes+node} (")
        for i in range(num_inputs):
            lines.append(f"    .in{i}(new_weighted_inputs{node+1}_{i}_1),")
        lines.append(f"    .sum(sum2bar[{node}])")
        lines.append("  );\n")

    #  bias
    for i in range(num_nodes):
        lines.append(f"  wire [{sum_width-1}:0] b{i+1};")
    lines.append("")
        
    # Mux for bias
    for i in range(num_nodes):
        lines.append(f"  mux_5 mux{i}  (.a(b{i+1}_1), .b(b{i+1}_2), .c(b{i+1}_3), .d(b{i+1}_4), .s0(s[0]), .s1(s[1]), .y(b{i+1}));")
    lines.append("")

    
    # Bias addition
    lines.append("  // bias addition")
    for node in range(num_nodes):
        lines.append(f"  add{sum_width}bit     u{node}  (.a(sum1[{node}]),     .b(b{node+1}), .cin(1'b0), .y(biased_sum1[{node}]));")
        lines.append(f"  add{sum_width}bitbar ub{node} (.a(sum1bar[{node}]), .b(b{node+1}), .cin(1'b0), .y(biased_sum1bar[{node}]));")
        lines.append(f"  add{sum_width}bit     u{node+num_nodes}  (.a(sum2[{node}]),     .b(b{node+1}), .cin(1'b0), .y(biased_sum2[{node}]));")
        lines.append(f"  add{sum_width}bitbar ub{node+num_nodes} (.a(sum2bar[{node}]), .b(b{node+1}), .cin(1'b0), .y(biased_sum2bar[{node}]));")
    lines.append("")


    # Output assignment
    for node in range(num_nodes):
        lines.append  (
            f"    assign biased_sum{node}_0 = biased_sum1[{node}];\n"
            f"    assign biased_sum{node}_1 = biased_sum2[{node}];\n"
            f"    assign biased_sum{node}_0bar = biased_sum1bar[{node}];\n"
            f"    assign biased_sum{node}_1bar = biased_sum2bar[{node}];\n"
        )
    lines.append("")
    
    # Debug display block
    lines.append("  always @(*) begin")
    lines.append('    $display("----- BNN LAYER  OUTPUTS -----");')
    for arr in ["sum1", "sum2", "sum1bar", "sum2bar"]:
        fmt = " ".join(["%b"] * num_nodes)
        args = ", ".join(f"{arr}[{i}]" for i in range(num_nodes))
        lines.append(f'    $display("{arr}: {fmt}", {args});')
    fmt = " ".join(["%b"] * num_nodes)
    args = ", ".join(f"b{i+1}" for i in range(num_nodes))
    lines.append(f'    $display("bias values: {fmt}", {args});')
    for arr in ["biased_sum1", "biased_sum2", "biased_sum1bar", "biased_sum2bar"]:
        fmt = " ".join(["%b"] * num_nodes)
        args = ", ".join(f"{arr}[{i}]" for i in range(num_nodes))
        lines.append(f'    $display("{arr}: {fmt}", {args});')
    lines.append("  end\n")

    # r registers and initial block
    for node in range(num_nodes):
        for r in range(biased_sum_width):
            lines.append(f"  reg r{r}_{node};")
    lines.append("\n  initial begin")
    for node in range(num_nodes):
        for r in range(biased_sum_width):
            lines.append(f"    r{r}_{node} = $random;")
    lines.append("    #1;")
    lines.append("  end\n")

    # activation arrays
    lines.append("  activation_array_1 act1 (")
    for i in range(num_nodes):
        lines.append(f"    .inputs{i}_0(biased_sum{i}_0),")
        lines.append(f"    .inputs{i}_1(biased_sum{i}_1),")
    for node in range(num_nodes):
        for r in range(biased_sum_width):
            lines.append(f"    .r{r}_{node}(r{r}_{node}),")
    for i in range(num_nodes):
        lines.append(f"    .masked_activation{i}(masked_activation{i}_1),")
    for i in range(num_nodes):
        comma = "," if i < num_nodes-1 else ""
        lines.append(f"    .mask{i}(mask{i}_1){comma}")
    lines.append("  );\n")

    lines.append("  activation_array_1 act2 (")
    for i in range(num_nodes):
        lines.append(f"    .inputs{i}_0(biased_sum{i}_0bar),")
        lines.append(f"    .inputs{i}_1(biased_sum{i}_1bar),")
    for node in range(num_nodes):
        for r in range(biased_sum_width):
            lines.append(f"    .r{r}_{node}(r{r}_{node}),")
    for i in range(num_nodes):
        lines.append(f"    .masked_activation{i}(masked_activation{i}bar_1),")
    for i in range(num_nodes):
        comma = "," if i < num_nodes-1 else ""
        lines.append(f"    .mask{i}(mask{i}bar_1){comma}")
    lines.append("  );\n")

    # Output registers and handshake logic
    lines.append("  always @(posedge clk or negedge rst_n) begin")
    lines.append("    if (!rst_n) begin")
    lines.append("      done <= 1'b0;")
    for node in range(num_nodes):
        lines.append(f"      biased_sum{node}_0_r    <= {biased_sum_width}'d0;  biased_sum{node}_1_r    <= {biased_sum_width}'d0;")
        lines.append(f"      biased_sum{node}_0bar_r <= {biased_sum_width}'d0;  biased_sum{node}_1bar_r <= {biased_sum_width}'d0;")
        lines.append(f"      masked_activation{node}_1_r <= 1'b0; masked_activation{node}bar_1_r <= 1'b0;")
        lines.append(f"      mask{node}_1_r             <= 1'b0;             mask{node}bar_1_r             <= 1'b0;")
    lines.append("    end else if (start) begin")
    lines.append("      done <= 1'b1;")
    for node in range(num_nodes):
        lines.append(f"      biased_sum{node}_0_r    <= biased_sum{node}_0;  biased_sum{node}_1_r    <= biased_sum{node}_1;")
        lines.append(f"      biased_sum{node}_0bar_r <= biased_sum{node}_0bar;  biased_sum{node}_1bar_r <= biased_sum{node}_1bar;")
        lines.append(f"      masked_activation{node}_1_r <= masked_activation{node}_1; masked_activation{node}bar_1_r <= masked_activation{node}bar_1;")
        lines.append(f"      mask{node}_1_r             <= mask{node}_1;             mask{node}bar_1_r             <= mask{node}bar_1;")
    lines.append("    end else begin")
    lines.append("      done <= 1'b0;")
    lines.append("    end")
    lines.append("  end\n")
    lines.append("endmodule")
    return "\n".join(lines)

def generate_layer_module(num_inputs: int,
                         input_bitwidth: int,
                         num_nodes: int ) -> str:
    parts = [
        generate_all_adders(input_bitwidth, num_inputs),
        generate_all_adders_bar(input_bitwidth, num_inputs),
        generate_adder_tree(f"adder_tree",num_inputs, input_bitwidth),
        generate_adder_tree_bar(f"adder_tree_bar",num_inputs, input_bitwidth),
        gen_mux_5(num_inputs, input_bitsize),
        generate_activation_module(num_inputs, input_bitwidth),
        generate_activation_array_verilog(f"activation_array_1",num_inputs, num_nodes, input_bitwidth),
        generate_bnn_layer_verilog(num_inputs , input_bitwidth, num_nodes ),        
        generate_boolean_to_arithmetic_verilog(input_bitwidth)
    ]
    return "\n\n".join(parts)

if __name__ == "__main__":
    # Parameters — adjust as needed
    num_inputs    = 16   # number of inputs per node
    input_bitsize = 3   # bit-width of each input/activation
    num_nodes     = 8   # number of parallel adder-tree nodes

    verilog_code = generate_layer_module(num_inputs, input_bitsize, num_nodes)
    print(verilog_code)

    sum_width = input_bitsize + math.ceil(math.log2(num_inputs))
    biased_sum_width = sum_width + 1
    
# ─── CONFIGURE THESE ─────────────────────────────────────────────────────────
L1 = num_nodes              # number of masked_activation/mask pairs (0…L1–1)
ROUNDS = [2,3,4]    # the three sub-round indices
WID = biased_sum_width-1             # bit-width of each weight vector
SHS = 2             # # of arithmetic-shares per node (always 2 here)
# ─────────────────────────────────────────────────────────────────────────────

def comma(i,n): return ',' if i<n-1 else ''

def main():
    # --- ports
    print("module share_boolean_arithmetic (")
    print("    // Handshake")
    print("    input  wire        clk,")
    print("    input  wire        rst_n,")
    print("    input  wire        start,")
    print("    output reg         done,")
    print()
    print("    // Masked-activation & mask inputs")
    for i in range(L1):
        print(f"    input  wire        masked_activation{i}_1,")
    for i in range(L1):
        print(f"    input  wire        mask{i}_1,")
    print()
    print("    // Weight vectors for the three sub-rounds")
    for ri,r in enumerate(ROUNDS):
        groups = []
        for g in range(1,L1+1):
            for sh in (0,1):
                groups.append(f"w{g}_{sh}_{r}")
        print(f"    input  wire [{2*(L1)-1}:0]  {', '.join(groups)},")
    print()
    print("    // Selection bits")
    print("    input  wire [1:0]  s,")
    print()
    print("    // Registered arithmetic-shares outputs (_r suffix)")
    regs = []
    total = L1 * SHS * (2 * L1)
    k = 0
    for layer in range(L1):
        for sh in range(SHS):
            for bit in range(2*L1):
                k += 1
                comma = "," if k < total else ""
                print(f"    output reg  [{input_bitsize-1}:0]act{layer}_{sh}_{bit}_r{comma}")
    print(");\n")


    # --- 1) COMBINATIONAL WIRES
    print("  //--------------------------------------------------------------------------")
    print("  // 1) COMBINATIONAL WIRES")
    print("  //--------------------------------------------------------------------------")
    print("  reg [1:0] " + ", ".join(f"ar{n}" for n in range(L1)) + ";")
    print()
    print("  initial begin")
    for n in range(L1):
        print(f"    ar{n}    = $random;")
    print("    #1;")
    print("  end\n")

    # --- Arithmetic-share wires
    print("  // Arithmetic shares driven by each converter (32 converters × 2 shares)")
    for layer in range(L1):
            for bit in range(2*L1):
                for part in (1,2,3):
                    print(f"  wire [{input_bitsize-1}:0] act{layer}_{bit}_0_{part};")
                    print(f"  wire [{input_bitsize-1}:0] act{layer}_{bit}_1_{part};")
    print()

    # --- Layer 1 intermediate wires
    for layer in range(L1):
        print(f"  // Layer 1, act{layer}")
        for bit in range(2*L1):
                print(f"  wire [{input_bitsize-1}:0] act{layer}_0_{bit};")
                print(f"  wire [{input_bitsize-1}:0] act{layer}_1_{bit};")
        print()
    # --- Weights declaration
    for i in range(L1):
        print(f"  wire [{(2*L1)-1}:0] w{i+1}_0;")
        print(f"  wire [{(2*L1)-1}:0] w{i+1}_1;")
    print()

    # --- Muxes for w*_0
    for g in range(1,L1+1):
        print(f"  // Muxes for w{g}_0")
        for b in range(2*L1):
            a,bx,c = (f"w{g}_0_{ROUNDS[i]}[{b}]" for i in range(3))
            print(f"  mux_3 m{g-1}0_{b} (.a({a}), .b({bx}), .c({c}), .s0(s[0]), .s1(s[1]), .y(w{g}_0[{b}]));")
        print()

    # --- new_masked_activation / new_mask
    print("  // Layer with weight vector _2")
    for layer in range(L1):
        MA = f"masked_activation{layer}_1"
        MK = f"mask{layer}_1"
        print(f"  wire [{biased_sum_width}:0] new_masked_activation{layer}_0 = {{")
        print(",\n".join(f"      (~^( {MA} ^ w{layer+1}_0[{2*L1-b-1}] ))" for b in range(2*L1)))
        print("  };")
        print(f"  wire [{biased_sum_width}:0] new_mask{layer}_0 = {{")
        print(",\n".join(f"      ~( {MK} ^ w{layer+1}_1[{2*L1-b-1}] )" for b in range(2*L1)))
        print("  };")
        print()

    # --- Muxes for w*_1
    for g in range(1,L1+1):
        print(f"  // Muxes for w{g}_1")
        for b in range(2*L1):
            a,bx,c = (f"w{g}_1_{ROUNDS[i]}[{b}]" for i in range(3))
            print(f"  mux_3 m{g-1}1_{b} (.a({a}), .b({bx}), .c({c}), .s0(s[0]), .s1(s[1]), .y(w{g}_1[{b}]));")
        print()

    # --- node mux_4s
    for node in range(L1):
        print(f"  // node {node+1}")
        # first share0 group
        base = node*2*WID
        for i in range(2*L1):
            print(f"  mux_4 mux{node}_0_{i} (.a(act{node}_{i}_0_1), .b(act{node}_{i}_0_2), .c(act{node}_{i}_0_3), .s0(s[0]), .s1(s[1]), .y(act{node}_0_{i}));")
        # then share1 group
        for i in range(2*L1):
            idx = node*16 + WID + i
            print(f"  mux_4 mux{node}_1_{i} (.a(act{node}_{i}_1_1), .b(act{node}_{i}_1_2), .c(act{node}_{i}_1_3), .s0(s[0]), .s1(s[1]), .y(act{node}_1_{i}));")
        print()

    # --- Boolean→Arithmetic converters
    print("  // Boolean→Arithmetic converters")
    conv = 0
    for layer in range(L1):
        for bit in range(2*L1):
            print(f"  boolean_arithmetic_coversion_1 conv{conv:02d} ("
                  f".x0(new_masked_activation{layer}_0[{bit}]),"
                  f" .x1(new_mask{layer}_0[{bit}]),"
                  f" .r_mask(ar{layer}),"
                  f" .arith_share0(act{layer}_0_{bit}),"
                  f" .arith_share1(act{layer}_1_{bit}));")
            conv += 1
        print()

    # --- always block
    print("  // snapshot into registers")
    print("  always @(posedge clk or negedge rst_n) begin")
    print("    if (!rst_n) begin")
    print("      done <= 1'b0;")
    for reg in regs:
        print(f"      {reg} <= 3'd0;")
    print("    end else begin")
    print("      if (start) begin")
    for reg in regs:
        base = reg[:-2]  # drop _r
        print(f"        {reg} <= {base};")
    print("        done <= 1'b1;")
    print("      end else begin")
    print("        done <= 1'b0;")
    print("      end")
    print("    end")
    print("  end\nendmodule")

if __name__ == "__main__":
    main()

def generate_comparator_and_subtractor(input_bitwidth:int,num_inputs:int, num_nodes: int):
    """
    Generate Verilog for:
      - comparator_N: N-bit comparator with masking LUT0/LUT1 chain
      - subtractor_{N-1}: (N-1)-bit subtractor producing N-bit result
    """
    # --- subtractor ---
    m = input_bitwidth  # Input bit-width
    n = math.ceil(math.log2(num_inputs))
    N=m+n+2# For summation width
    in_width = N - 1
    subtractor = f"""\
module subtractor (
    input  wire signed [{in_width-1}:0] A,
    input  wire signed [{in_width-1}:0] B,
    output wire signed [{in_width}:0] Result
);
    assign Result = A - B;
endmodule

"""
    # --- comparator ---
    # r signals: one per bit of the chain, idx 0..N-1
    r_ports = ", ".join(f"r{i}_0" for i in range(N))
    lut0_call = (
        f"    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0),\n"
        f"               .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));"
    )
    # build the chain of LUT1
    lut1_calls = []
    for i in range(1, N):
        prev_mask = f"masked_c{i-1}_0"
        r_flow = f"r{i}_flow" if False else f"r{i}"  # actual flow comes from previous lut r_out
        # for simplicity we keep same naming as your example: r{i} is LUT1 r_out
        lut1_calls.append(
            f"    lut1 l{i} (.a(inputs0_0[{i}]), .b(inputs0_1[{i}]), .c_in({prev_mask}),\n"
            f"               .r_flow(r{i}), .r_i(r{i}_0), .r_out(r{i+1}), .c_masked(masked_c{i}_0));"
        )
    lut_chain = "\n".join([lut0_call] + lut1_calls)

    comparator = f"""\
module comparator_1 (
    input  wire [{N-1}:0] inputs0_0,
    input  wire [{N-1}:0] inputs0_1,
    input  wire {r_ports},
    output wire comparator
);
    // internal r_out chain
    wire {" , ".join(f"r{i}" for i in range(1, N+1))};
    wire {" , ".join(f"masked_c{i}_0" for i in range(N))};

{lut_chain}

    wire carry = r{N} ^ masked_c{N-1}_0;
    // final compare: if carry ^ inputs0_0[N-1] ^ inputs0_1[N-1] == 0 → comparator = 1
    assign comparator = (carry ^ inputs0_0[{N-1}] ^ inputs0_1[{N-1}]) ? 1'b0 : 1'b1;
endmodule
"""

    return subtractor + comparator
def generate_output_layer_max_module(num_inputs: int,
                                     num_nodes: int,
                                     input_bitwidth: int ) -> str:
    assert (num_nodes & (num_nodes - 1)) == 0, "num_nodes must be a power of 2"
    assert num_nodes >= 2, "Minimum 2 nodes required"

    # width of the sums coming out of layer1
    sum_w = input_bitwidth + math.ceil(math.log2(num_inputs))

    lines = []
    # -- Module header and port list --
    lines.append(f"module output_layer (")
    # raw inputs to layer1:
    for i in range(num_nodes):
        lines.append(f"  input  wire [{sum_w}:0] biased_sum{i}_0,")
        lines.append(f"  input  wire [{sum_w}:0] biased_sum{i}_1,")
        lines.append(f"  input  wire [{sum_w}:0] biased_sum{i}_0bar,")
        lines.append(f"  input  wire [{sum_w}:0] biased_sum{i}_1bar,")
    # outputs of this max‐layer
    for i in range(num_nodes):
        lines.append(f"    output reg  a{i}, a{i}_bar,")
    # drop trailing comma on last port
    lines[-1] = lines[-1].rstrip(',')
    lines.append(");")
    lines.append("")

    # randomness wire 
    for cid in range(num_nodes - 1):
        for r in range(sum_w+2):
            lines.append(f"    reg r{r}_{cid};")
            lines.append(f"    reg r{r}_{cid}bar;")
    lines.append("\n  initial begin")
    for cid in range(num_nodes - 1):
        for r in range(sum_w+2):
            lines.append(f"     r{r}_{cid}= $random;")
            lines.append(f"     r{r}_{cid}bar = $random;")
    lines.append("    #1;")
    lines.append("  end\n")
    
    # -- Build the max‐reduction tree exactly as before --
    signals = [
        (f"biased_sum{i}_0",
         f"biased_sum{i}_1",
         f"biased_sum{i}_0bar",
         f"biased_sum{i}_1bar",
         i)
        for i in range(num_nodes)
    ]
    tree = []       # (cmp_id, left_id, right_id)
    comp_id = 0
    stage = 0

    while len(signals) > 1:
        next_signals = []
        for j in range(0, len(signals), 2):
            A0, A1, A0b, A1b, lid = signals[j]
            B0, B1, B0b, B1b, rid = signals[j+1]

            # subtractors
            lines.append(f"    wire [{sum_w+1}:0] temp{comp_id}_0, temp{comp_id}_1, temp{comp_id}_0bar, temp{comp_id}_1bar;")
            lines.append(f"    subtractor s{comp_id}a (.A({A0}), .B({B0}), .Result(temp{comp_id}_0));")
            lines.append(f"    subtractor s{comp_id}b (.A({A1}), .B({B1}), .Result(temp{comp_id}_1));")
            lines.append(f"    subtractor s{comp_id}abar (.A({A0b}), .B({B0b}), .Result(temp{comp_id}_0bar));")
            lines.append(f"    subtractor s{comp_id}bbar (.A({A1b}), .B({B1b}), .Result(temp{comp_id}_1bar));")
            lines.append(f"    wire comp{comp_id}, comp{comp_id}_bar;")

            # comparator instantiations
            lines.append(f"    comparator_1 c{comp_id} (")
            lines.append(f"        .inputs0_0(temp{comp_id}_0), .inputs0_1(temp{comp_id}_1),")
            lines.append("        " + ", ".join(f".r{r}_0(r{r}_{comp_id})" for r in range(sum_w+2)) + ",")
            lines.append(f"        .comparator(comp{comp_id})")
            lines.append("    );")
            lines.append(f"    comparator_1 c{comp_id}_bar (")
            lines.append(f"        .inputs0_0(temp{comp_id}_0bar), .inputs0_1(temp{comp_id}_1bar),")
            lines.append("        " + ", ".join(f".r{r}_0(r{r}_{comp_id}bar)" for r in range(sum_w+2)) + ",")
            lines.append(f"        .comparator(comp{comp_id}_bar)")
            lines.append("    );")

            # create the next‐stage mux regs
            mux0  = f"stage{stage+1}_{j//2}_0"
            mux1  = f"stage{stage+1}_{j//2}_1"
            mux0b = mux0 + "bar"
            mux1b = mux1 + "bar"
            lines.append(f"    reg [{sum_w}:0] {mux0}, {mux1}, {mux0b}, {mux1b};")
            lines.append("    always @(*) begin")
            lines.append(f"        if (comp{comp_id})      begin {mux0} = {A0};    {mux1} = {A1};    end")
            lines.append(f"        else                    begin {mux0} = {B0};    {mux1} = {B1};    end")
            lines.append(f"        if (comp{comp_id}_bar)  begin {mux0b} = {A0b}; {mux1b} = {A1b}; end")
            lines.append(f"        else                    begin {mux0b} = {B0b}; {mux1b} = {B1b}; end")
            lines.append("    end\n")

            tree.append((comp_id, lid, rid))
            parent_id = num_nodes + comp_id
            next_signals.append((mux0, mux1, mux0b, mux1b, parent_id))
            comp_id += 1

        signals = next_signals
        stage += 1

    # helper to trace a leaf up the tree
    def trace_path(leaf):
        p, cur = [], leaf
        for cid, l, r in tree:
            if cur == l:
                p.append((cid, 1))
                cur = num_nodes + cid
            elif cur == r:
                p.append((cid, 0))
                cur = num_nodes + cid
        return p

   # final one-hot logic
    lines.append("    always @(*) begin")
    for i in range(num_nodes):
        lines.append(f"        a{i} = 0; a{i}_bar = 0;")
    lines.append("")

    for i in range(num_nodes):
        path = trace_path(i)
        if not path:
            continue
        cond_n = " && ".join(f"comp{cid} == {val}" for cid, val in path)

        if i == 0:
            lines.append(f"        if ({cond_n}) a0     = 1;")
        elif i < num_nodes - 1:
            lines.append(f"        else if ({cond_n}) a{i}     = 1;")
        else:
            lines.append("        else             a{0}     = 1;".format(i))
    lines.append("")
    for i in range(num_nodes):
        path = trace_path(i)
        if not path:
            continue
        cond_b = " && ".join(f"comp{cid}_bar == {val}" for cid, val in path)
        if i == 0:
            lines.append(f"        if ({cond_b}) a0_bar     = 1;")
        elif i < num_nodes - 1:
            lines.append(f"        else if ({cond_b}) a{i}_bar     = 1;")
        else:
            lines.append("        else             a{0}_bar     = 1;".format(i))
            
    lines.append("    end")
    lines.append("endmodule")

    return "\n".join(lines)

def generate_last_module_design(num_inputs: int,
                         input_bitwidth: int,
                         num_nodes: int ) -> str:
    parts = [
        generate_comparator_and_subtractor(input_bitwidth,num_inputs, num_nodes),
        generate_output_layer_max_module( num_inputs, num_nodes,
                                            input_bitwidth)
    ]
    return "\n\n".join(parts)
if __name__ == "__main__":
    # specify your layer parameters here:
    num_inputs    = 16
    num_nodes     = 4
    input_bitwidth = 3
    

    verilog_code = generate_last_module_design(
        num_inputs,
        input_bitwidth,
        num_nodes
    )

    print(verilog_code)

import math

def gen_iterative_controller(num_inputs, input_bitsize, num_nodes):
    sum_width = input_bitsize + math.ceil(math.log2(num_inputs))
    biased_sum_width = sum_width + 1
    lines = []
    # Module header and port list
    print("module iterative_controller (")
    ports = []
    # control signals
    print("    input wire", "", "clk,")
    print("    input wire", "", "rst_n,")
    print("    input wire", "", "start,")
    print("    output reg ", "", "done,")

    # static inputs: inputsX_1
    for i in range(num_inputs):
        print(f"    input wire", f"[{input_bitsize-1}:0] inputs{i}_1,")
    
    # weight buses (fixed 4 layers)
    for layer in range(num_nodes):
        print(f"    input wire", f"[{num_inputs-1}:0]", f"w{layer+1}_0_1, w{layer+1}_1_1,")
        print(f"    input wire", f"[{num_inputs-1}:0]", f"w{layer+1}_0_2, w{layer+1}_1_2,")
        print(f"    input wire", f"[{num_inputs-1}:0]", f"w{layer+1}_0_3, w{layer+1}_1_3,")
        print(f"    input wire", f"[{num_inputs-1}:0]", f"w{layer+1}_0_4, w{layer+1}_1_4,")
    # bias buses
    for i in range(1, num_nodes+1):
        for j in range(1, num_nodes+1):
            print("    input wire", f"[{sum_width-1}:0] b{i}_{j},")
    total = num_nodes * 2 * (2 * num_nodes)
    k = 0
    for layer in range(num_nodes):
        for sh in range(2):
            for bit in range(2*num_nodes):
                k += 1
                comma = "," if k < total else ""
                print(f"    output wire  [{input_bitsize-1}:0]act{layer}_{sh}_{bit}_r{comma}")
    print(");\n")
    print(f"  reg  [1:0]  s_count;")
    for layer in range(num_nodes):
        for bit in range(2*num_nodes):
            print(f"  reg [{input_bitsize-1}:0] act{layer}_0_{bit}_layer;")
            print(f"  reg [{input_bitsize-1}:0] act{layer}_1_{bit}_layer;")
    print()
        # Internal wires
    print("  // internal wires")
    for node in range(num_nodes):
        print(f"  wire [{biased_sum_width-1}:0] biased_sum{node}_0, biased_sum{node}_1, biased_sum{node}_0bar, biased_sum{node}_1bar;")
        print(f"  wire masked_activation{node}_1, masked_activation{node}bar_1;")
        print(f"  wire mask{node}_1, mask{node}bar_1;")
        print(f"  wire  a{node}, a{node}_bar;")
    print("  \n")
    # state_block.py

def print_state_block():
    print("""  // state encoding
  localparam IDLE         = 3'd0,
             START_LAYER  = 3'd1,
             WAIT_LAYER   = 3'd2,
             START_SHARE  = 3'd3,
             WAIT_SHARE   = 3'd4,
             DONE_STATE   = 3'd5;

  reg [2:0]  state, next_state;
  wire       done_layer, done_share;
  wire       start_layer = (state == START_LAYER);
  wire       start_share = (state == START_SHARE);

  // state register and s_count logic
  always @(posedge clk ) begin
    if (!rst_n) begin
      state    <= IDLE;
      s_count  <= 2'b00;
    end else begin
      state <= next_state;
      if (state == WAIT_SHARE && done_share && s_count != 2'b11)
        s_count <= s_count + 1;
      if (state == DONE_STATE)
        s_count <= 2'b00;
    end
  end

  always @(*) begin
    next_state = state;
    done       = 1'b0;
    case (state)
      IDLE:         if (start)       next_state = START_LAYER;
      START_LAYER:                   next_state = WAIT_LAYER;
      WAIT_LAYER:   if (done_layer)  next_state = START_SHARE;
      START_SHARE:                  next_state = WAIT_SHARE;
      WAIT_SHARE:  if (done_share) begin
                        if (s_count == 2'b11) next_state = DONE_STATE;
                        else                  next_state = START_LAYER;
                   end
      DONE_STATE: begin
                      done       = 1'b1;
                      next_state = IDLE;
                   end
    endcase
  end""")

def gen_feedback_block(num_nodes=4, bits_per_node=8, bitwidth=3, shares=2):

    def pair_lines(prefix, rhs_fn, indent="      "):
        """Emit two assignments per line for nicer formatting."""
        lines = []
        for b in range(0, bits_per_node, 2):
            lhs0 = f"{prefix}{b}_layer"
            rhs0 = rhs_fn(b)
            if b + 1 < bits_per_node:
                lhs1 = f"{prefix}{b+1}_layer"
                rhs1 = rhs_fn(b + 1)
                lines.append(f"{indent}{lhs0} <= {rhs0};  {lhs1} <= {rhs1};")
            else:
                lines.append(f"{indent}{lhs0} <= {rhs0};")
        return lines

    w0 = f"{bitwidth}'d0"
    lines = []
    lines.append("always @(posedge clk or negedge rst_n) begin")
    lines.append("  if (!rst_n) begin")
    lines.append("      // reset all feedback regs to zero")

    # RESET section
    for node in range(num_nodes):
        for sh in range(shares):
            prefix = f"      act{node}_{sh}_"
            lines += pair_lines(prefix, rhs_fn=lambda _b: w0)
            lines.append("")  # blank line between groups
    if lines[-1] == "":  # trim trailing blank line
        lines.pop()

    # CAPTURE section
    lines.append("  end else if (state == WAIT_SHARE && done_share) begin")
    lines.append("      // capture the outputs of m2 into the next iteration's m1 inputs")
    for node in range(num_nodes):
        for sh in range(shares):
            prefix = f"      act{node}_{sh}_"
            lines += pair_lines(prefix, rhs_fn=lambda b, n=node, s=sh: f"act{n}_{s}_{b}_r")
            lines.append("")
    if lines[-1] == "":
        lines.pop()

    # HOLD section
    lines.append("  end")
    lines.append("   else begin ")
    for node in range(num_nodes):
        for sh in range(shares):
            prefix = f"      act{node}_{sh}_"
            lines += pair_lines(prefix, rhs_fn=lambda b, n=node, s=sh: f"act{n}_{s}_{b}_layer")
            lines.append("")
    if lines[-1] == "":
        lines.pop()
    lines.append("  end")
    lines.append("end")

    return "\n".join(lines)

# gen_instances.py

def _add_port(ports, name, sig, col=22):
    ports.append(f"    .{name:<{col}} ({sig}),")

def _close_block(lines):
    # remove trailing comma from the last port before closing
    for i in range(len(lines) - 1, -1, -1):
        if lines[i].strip().endswith(","):
            lines[i] = lines[i].rstrip(",")
            break

def gen_instances(num_inputs: int, bitwidth: int, num_nodes: int) -> str:
    out = []
    # ========= m1 (layer) =========
    out.append("  //— Instantiate Layer (m1) ")
    out.append("  layer m1 (")
    m1_ports = []
    _add_port(m1_ports, "clk",   "clk")
    _add_port(m1_ports, "rst_n", "rst_n")
    _add_port(m1_ports, "start", "start_layer")
    _add_port(m1_ports, "done",  "done_layer")
    m1_ports.append("")  # spacer

    # inputs0_1 .. inputs{N-1}_1
    for i in range(num_inputs):
        _add_port(m1_ports, f"inputs{i}_1", f"inputs{i}_1")
    m1_ports.append("")
    m1_ports.append("// Updated port connections – every signal previously ending in _r is now suffixed _layer")

    # act<n>_<s>_<b> (…_layer)
    for n in range(num_nodes):
        for s in range(2):  # shares 0,1
            for b in range(num_inputs):
                _add_port(m1_ports, f"act{n}_{s}_{b}", f"act{n}_{s}_{b}_layer")

    m1_ports.append("")

    # weights: w{k}_0_1 and w{k}_1_1 for k=1..num_nodes
    for k in range(1, num_nodes + 1):
        _add_port(m1_ports, f"w{k}_0_1", f"w{k}_0_1")
        _add_port(m1_ports, f"w{k}_1_1", f"w{k}_1_1")
    m1_ports.append("")

    # biases: order matches example (b1_1..b{N}_1, then b1_2.., then b1_3.., then b1_4..)
    for t in range(1, 5):
        for k in range(1, num_nodes + 1):
            _add_port(m1_ports, f"b{k}_{t}", f"b{k}_{t}")
    m1_ports.append("")
    _add_port(m1_ports, "s", "s_count")
    m1_ports.append("")

    # biased sums: per node, for channels 0 and 1, and their bar variants
    for n in range(num_nodes):
        for ch in (0, 1):
            _add_port(m1_ports, f"biased_sum{n}_{ch}_r",    f"biased_sum{n}_{ch}")
            _add_port(m1_ports, f"biased_sum{n}_{ch}bar_r", f"biased_sum{n}_{ch}bar")
    m1_ports.append("")

    # masked_activationX_1_r and bar versions (X = 0..num_nodes-1)
    for n in range(num_nodes):
        _add_port(m1_ports, f"masked_activation{n}_1_r",      f"masked_activation{n}_1")
    for n in range(num_nodes):
        _add_port(m1_ports, f"masked_activation{n}bar_1_r",   f"masked_activation{n}bar_1")
    m1_ports.append("")

    # maskX_1_r and bar versions
    for n in range(num_nodes):
        _add_port(m1_ports, f"mask{n}_1_r",      f"mask{n}_1")
    for n in range(num_nodes):
        _add_port(m1_ports, f"mask{n}bar_1_r",   f"mask{n}bar_1")

    _close_block(m1_ports)
    out.extend(m1_ports)
    out.append("  );")
    out.append("")

    # ========= m2 (share_boolean_arithmetic) =========
    out.append("  //— Instantiate Share (m2) —")
    out.append("  share_boolean_arithmetic m2 (")
    m2_ports = []
    _add_port(m2_ports, "clk",   "clk")
    _add_port(m2_ports, "rst_n", "rst_n")
    _add_port(m2_ports, "start", "start_share")
    _add_port(m2_ports, "done",  "done_share")
    m2_ports.append("")

    # masked_activations/masks in
    for n in range(num_nodes):
        _add_port(m2_ports, f"masked_activation{n}_1",    f"masked_activation{n}_1")
    for n in range(num_nodes):
        _add_port(m2_ports, f"mask{n}_1",                 f"mask{n}_1")
    m2_ports.append("")

    # weights for shares 2,3,4 (matches example)
    for share_idx in (2, 3, 4):
        for k in range(1, num_nodes + 1):
            _add_port(m2_ports, f"w{k}_0_{share_idx}", f"w{k}_0_{share_idx}")
            _add_port(m2_ports, f"w{k}_1_{share_idx}", f"w{k}_1_{share_idx}")
    m2_ports.append("")
    _add_port(m2_ports, "s", "s_count")
    m2_ports.append("")

    # act<n>_<s>_<b>_r outputs
    for n in range(num_nodes):
        for s in range(2):
            for b in range(num_inputs):
                _add_port(m2_ports, f"act{n}_{s}_{b}_r", f"act{n}_{s}_{b}_r")

    _close_block(m2_ports)
    out.extend(m2_ports)
    out.append("  );")

    return "\n".join(out)
    
def gen_output_layer_inst(num_outputs: int, inst_name: str = "dut") -> str:

    col = 16  # align the names nicely
    ind = "  "
    lines = [f"{ind}output_layer {inst_name} ("]

    # Non-bar sums: biased_sum{i}_0, biased_sum{i}_1
    for i in range(num_outputs):
        for ch in (0, 1):
            n = f"biased_sum{i}_{ch}"
            lines.append(f"{ind}  .{n:<{col}} ({n}),")

    # Bar sums: biased_sum{i}_{ch}bar
    for i in range(num_outputs):
        for ch in (0, 1):
            n = f"biased_sum{i}_{ch}bar"
            lines.append(f"{ind}  .{n:<{col}} ({n}),")

    # Outputs: a{i}
    for i in range(num_outputs):
        n = f"a{i}"
        lines.append(f"{ind}  .{n:<{col}} ({n}),")

    # Outputs: a{i}_bar  (last one without comma)
    for i in range(num_outputs):
        n = f"a{i}_bar"
        comma = "," if i != num_outputs - 1 else ""
        lines.append(f"{ind}  .{n:<{col}} ({n}){comma}")

    lines.append(f"{ind});")
    lines.append("")
    lines.append("endmodule")
    return "\n".join(lines)

if __name__ == "__main__":
    # set your parameters here
    NUM_INPUTS = 16
    INPUT_BITS = 3
    NUM_NODES  = 8
    OUT_NODES = 4

    # 1) Module header / ports (your function prints directly)
    gen_iterative_controller(NUM_INPUTS, INPUT_BITS, NUM_NODES)
    print()

    # 2) FSM / state block
    print_state_block()
    print()

    # 3) Feedback always block
    print(gen_feedback_block(
        num_nodes=NUM_NODES,
        bits_per_node=2*NUM_NODES,  # matches your act<n>_<s>_<b> pattern
        bitwidth=INPUT_BITS,
        shares=2
    ))
    print()

    # 4) m1 and m2 instantiations
    print(gen_instances(NUM_INPUTS, INPUT_BITS, NUM_NODES))
    print()

    # 5) output_layer instantiation (set how many outputs you want)
    print(gen_output_layer_inst(num_outputs=OUT_NODES, inst_name="dut"))













