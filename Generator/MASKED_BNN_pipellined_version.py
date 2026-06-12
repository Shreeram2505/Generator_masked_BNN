import math

# Python script to print the weighted_inputs_1 module
def weighted_func1(input_bitsize=9):
    verilog = f"""
module weighted_inputs_1
#(parameter input_bitsize = {input_bitsize})
(
    input  [{input_bitsize-1}:0] inputs,
    input  w,
    input  [{input_bitsize-1}:0] w_mask_1,

    output reg [{input_bitsize}:0] wi,
    output reg [{input_bitsize}:0] w_i_mask
);

wire [{input_bitsize-1}:0] neg_input;
wire [{input_bitsize-1}:0] neg_w_mask;

wire [{input_bitsize}:0] wi_1, wi_2 , w_m;

assign neg_input = (~inputs + 1);
assign neg_w_mask = (~w_mask_1 + 1);

add{input_bitsize}bit_1 w1 (.a(neg_input), .b(neg_w_mask), .cin(1'b0), .y(wi_1), .cout(), .cout_bar());
add{input_bitsize}bit_1 w2 (.a(inputs), .b(neg_w_mask), .cin(1'b0), .y(wi_2), .cout(), .cout_bar());

assign w_m = {{1'b0, neg_w_mask}};

always @(*) begin
    if (w == 1'b0)
        wi = wi_1;
    else
        wi = wi_2;
end

always @(*) begin
    if (w_mask_1[{input_bitsize-1}] == 1'b0)
        w_i_mask = {{1'b0, w_mask_1}};
    else
        w_i_mask = (~w_m + 1);
end

endmodule
"""
    return verilog


def weighted_func2(layer_no):
    verilog = f"""module weighted_inputs_{layer_no}(

    input  inputs,

    input w,

    input  [2:0] w_mask_2,

    output  [3:0] wi,
    output  reg  [3:0] w_i_mask

);

wire  weighted_input;

wire [2:0] neg_w_mask;

reg [2:0] wi_1;

wire [3:0] wi_2 , w_m;

assign weighted_input = ~(inputs ^ w);

assign neg_w_mask = (~w_mask_2 + 1);


    always @(*) begin
        if (weighted_input == 1'b0) begin
            wi_1 = 3'b111;
        end else begin
            wi_1 = 3'b001;
        end
    end

add3bit_2 w1 (.a(wi_1), .b(neg_w_mask), .cin(1'b0), .y(wi_2), .cout(), .cout_bar());

assign wi = wi_2;

assign w_m = {{1'b0, neg_w_mask}};

always @(*) begin
    if (w_mask_2[2] == 1'b0)
        w_i_mask = {{1'b0, w_mask_2}};
    else
        w_i_mask = (~w_m + 1);
end

endmodule
"""
    return verilog



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

def generate_full_adder_modules1(layer_no:int):
    return f'''module half_adder_{layer_no}(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adder_{layer_no}(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adder_{layer_no} HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adder_{layer_no} HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNAND_{layer_no}(
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




def generate_addXbit(x,layer_no):
    verilog = []
    verilog.append(f"module add{x}bit_{layer_no}(")
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
        verilog.append(f"full_adder_{layer_no} fa{i}(.S(y[{i}]), .C(c{i+1}), .X(a[{i}]), .Y(b[{i}]), .Z({c_prev}));")
    verilog.append("")

    # WddlNAND gates for cout computation
    verilog.append(f"WddlNAND_{layer_no} wn1(.A(~a[{x-1}]), .B(b[{x-1}]), .C(~c{x}), .S(s1), .S1(s1_1));")
    verilog.append(f"WddlNAND_{layer_no} wn2(.A(a[{x-1}]), .B(~b[{x-1}]), .C(~c{x}), .S(s2), .S1(s2_1));")
    verilog.append(f"WddlNAND_{layer_no} wn3(.A(a[{x-1}]), .B(b[{x-1}]), .C(c{x}), .S(s3), .S1(s3_1));")
    verilog.append(f"WddlNAND_{layer_no} wn4(.A(~a[{x-1}]), .B(~b[{x-1}]), .C(c{x}), .S(s4), .S1(s4_1));")
    verilog.append("")

    # Outputs
    verilog.append("assign cout = ~(s1 & s2 & s3 & s4);")
    verilog.append("assign cout_bar = ~cout;")
    verilog.append("assign y[{0}] = cout;".format(x))
    verilog.append("")
    verilog.append("endmodule\n")
    return "\n".join(verilog)


def generate_all_adders(m, n ,layer_no:int):
    from_bits = m 
    to_bits = m + int(math.log2(n))+1

    output = [generate_full_adder_modules1(layer_no)]
    for bits in range(from_bits, to_bits + 1):
        output.append(generate_addXbit(bits,layer_no))
    return "\n".join(output)



def generate_full_adder_modules2(layer_no):
    return f'''module half_adderbar_{layer_no}(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adderbar_{layer_no}(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adderbar_{layer_no} HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adderbar_{layer_no} HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNANDbar_{layer_no}(
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

def generate_addXbitbar(x,layer_no):
    verilog = []
    verilog.append(f"module add{x}bitbar_{layer_no}(")
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
        verilog.append(f"full_adderbar_{layer_no} fa{i}(.S(y[{i}]), .C(c{i+1}), .X(a[{i}]), .Y(b[{i}]), .Z({c_prev}));")
    verilog.append("")

    # WddlNAND gates for cout computation
    verilog.append(f"WddlNANDbar_{layer_no} wn1(.A(~a[{x-1}]), .B(b[{x-1}]), .C(~c{x}), .S(s1), .S1(s1_1));")
    verilog.append(f"WddlNANDbar_{layer_no} wn2(.A(a[{x-1}]), .B(~b[{x-1}]), .C(~c{x}), .S(s2), .S1(s2_1));")
    verilog.append(f"WddlNANDbar_{layer_no} wn3(.A(a[{x-1}]), .B(b[{x-1}]), .C(c{x}), .S(s3), .S1(s3_1));")
    verilog.append(f"WddlNANDbar_{layer_no} wn4(.A(~a[{x-1}]), .B(~b[{x-1}]), .C(c{x}), .S(s4), .S1(s4_1));")
    verilog.append("")

    # Outputs
    verilog.append("assign cout = ~(s1 & s2 & s3 & s4);")
    verilog.append("assign cout_bar = ~cout;")
    verilog.append("assign y[{0}] = cout_bar;".format(x))
    verilog.append("")
    verilog.append("endmodule\n")
    return "\n".join(verilog)


def generate_all_adders_bar(m, n, layer_no: int):
    from_bits = m 
    to_bits = m + int(math.log2(n))+1

    output = [generate_full_adder_modules2(layer_no)]
    for bits in range(from_bits, to_bits + 1):
        output.append(generate_addXbitbar(bits,layer_no))
    return "\n".join(output)



def generate_adder_tree(module_name: str,num_inputs, input_bit_width,layer_no :int ):
    assert (num_inputs & (num_inputs - 1)) == 0, "num_inputs must be a power of 2"
    module_lines = []

    #module_name = f"adder_tree_{num_inputs}"
    max_stage = int(math.log2(num_inputs)) + input_bit_width+1

    module_lines.append("")
    module_lines.append(f"module {module_name} (")
    
    module_lines.append("    input  wire   clk, ")
    for i in range(num_inputs):
        module_lines.append(f"    input  wire [{input_bit_width}:0] in{i},")
    out_width = input_bit_width + int(math.log2(num_inputs))+1
    module_lines.append(f"    output wire [{out_width - 1}:0] sum\n);")
    module_lines.append("")

    stage = 0
    current_nodes = [(f"in{i}", input_bit_width+1) for i in range(num_inputs)]
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
            low_name = f"stage{stage}_{i//2}_lo_{layer_no}"
            reg_name = f"stage{stage}_{i//2}_{layer_no}"
            wires.append((low_name, next_width - 1))
            regs.append((reg_name, next_width, low_name))
            adder_mod = f"add{adder_width}bit_{layer_no}"
            logic.append(f"    {adder_mod} u{stage}_{i//2} (.a({a}), .b({b}), .cin(1'b0), .y({low_name}), .cout(), .cout_bar());")
            next_nodes.append((reg_name, next_width))
            if len(current_nodes) == 2:
                final_wire = low_name  # Capture the final output wire name before register
        current_nodes = next_nodes
        stage += 1

    logic.append(f"\n    assign sum =  {final_wire};\n")

    for w, width in wires:
        module_lines.append(f"    wire [{width}:0] {w};")
    for r, width, _ in regs:
        module_lines.append(f"    reg  [{width - 1}:0] {r};")
    module_lines.append("")

    module_lines.extend(logic)

    module_lines.append("    always @(posedge clk) begin")
    for r, _, src in regs:
        module_lines.append(f"        {r} <=  {src};")
    module_lines.append("    end\nendmodule")

    return "\n".join(module_lines)



def generate_adder_tree_bar(module_name: str,num_inputs, input_bit_width,layer_no : int):
    assert (num_inputs & (num_inputs - 1)) == 0, "num_inputs must be a power of 2"
    module_lines = []

    #module_name = f"adder_tree_{num_inputs}bar"
    max_stage = int(math.log2(num_inputs)) + input_bit_width+1

    module_lines.append("")
    module_lines.append(f"module {module_name} (")
    module_lines.append("    input  wire   clk, ")
    for i in range(num_inputs):
        module_lines.append(f"    input  wire [{input_bit_width}:0] in{i},")
    out_width = input_bit_width + int(math.log2(num_inputs))+1
    module_lines.append(f"    output wire [{out_width - 1}:0] sum\n);")
    module_lines.append("")

    stage = 0
    current_nodes = [(f"in{i}", input_bit_width+1) for i in range(num_inputs)]
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
            low_name = f"stage{stage}_{i//2}_lo_bar_{layer_no}"
            reg_name = f"stage{stage}_{i//2}_bar_{layer_no}"
            wires.append((low_name, next_width - 1))
            regs.append((reg_name, next_width, low_name))
            adder_mod = f"add{adder_width}bitbar_{layer_no}"
            logic.append(f"    {adder_mod} u{stage}_{i//2}_bar (.a({a}), .b({b}), .cin(1'b0), .y({low_name}), .cout(), .cout_bar());")
            next_nodes.append((reg_name, next_width))
            if len(current_nodes) == 2:
                final_wire = low_name  # Capture the final output wire name before register
        current_nodes = next_nodes
        stage += 1

    logic.append(f"\n    assign sum =  {final_wire};\n")

    for w, width in wires:
        module_lines.append(f"    wire [{width}:0] {w};")
    for r, width, _ in regs:
        module_lines.append(f"    reg  [{width - 1}:0] {r};")
    module_lines.append("")

    module_lines.extend(logic)

    module_lines.append("    always @(posedge clk) begin")
    for r, _, src in regs:
        module_lines.append(f"        {r} <=  {src};")
    module_lines.append("    end\nendmodule")

    return "\n".join(module_lines)
import math

def generate_bnn_layer_verilog1(module_name: str, num_inputs: int, num_nodes: int, input_bitwidth :int, layer_no:int) -> str:
    m = input_bitwidth  # Input bit-width
    n = math.ceil(math.log2(num_inputs))  # For summation width
    sum_width = m + n + 1
    biased_width = sum_width + 1
    adder_bit = sum_width  # Width needed for bias

    verilog = f"""\

module {module_name}(
    input clk,
    input [{m-1}:0] {" , ".join([f"inputs{i}_{layer_no}" for i in range(num_inputs)])},
    input [{input_bitwidth-1}:0] {", ".join([f"w_mask{i+1}_1" for i in range(num_nodes)])},
    input [{num_inputs-1}:0] {", ".join([f"w{i+1}_{layer_no}" for i in range(num_nodes)])},
    input [{sum_width-1}:0] {", ".join([f"b{i+1}_0_{layer_no},b{i+1}_1_{layer_no}" for i in range(num_nodes)])},
    output [{biased_width-1}:0] {", ".join(
        [f"biased_sum{i}_0, biased_sum{i}_1, biased_sum{i}_0bar, biased_sum{i}_1bar" for i in range(num_nodes)]
    )}
);
"""

    # Weighted input wires
    
    for node in range(num_nodes):
        for i in range(num_inputs):
            verilog += f"    wire [{m}:0] weighted_inputs{node+1}_{i}_0, weighted_inputs{node+1}_{i}_1;\n"

    verilog += f"""
    wire [{sum_width-1}:0] sum1 [{num_nodes-1}:0];
    wire [{sum_width-1}:0] sum2 [{num_nodes-1}:0];
    wire [{biased_width-1}:0] biased_sum1 [{num_nodes-1}:0];
    wire [{biased_width-1}:0] biased_sum2 [{num_nodes-1}:0];
    wire [{sum_width-1}:0] sum1bar [{num_nodes-1}:0];
    wire [{sum_width-1}:0] sum2bar [{num_nodes-1}:0];
    wire [{biased_width-1}:0] biased_sum1bar [{num_nodes-1}:0];
    wire [{biased_width-1}:0] biased_sum2bar [{num_nodes-1}:0];
"""

    # Weighted input instances
    for node in range(num_nodes):
        for i in range(num_inputs):
            idx = node * num_inputs + i
            verilog += (
                f"    weighted_inputs_1 w{idx} (.inputs(inputs{i}_{layer_no}), .w(w{node+1}_{layer_no}[{num_inputs-i-1}]), .w_mask_1(w_mask{node+1}_1), .wi(weighted_inputs{node+1}_{i}_0), .w_i_mask(weighted_inputs{node+1}_{i}_1));\n"
            )

    # Adder tree instantiations
    for node in range(num_nodes):
        # Phase 0 tree
        verilog += f"    adder_tree_{layer_no} add{node}(\n"
        verilog += f"        .clk(clk), \n    "
        for i in range(num_inputs):
            verilog += f"        .in{i}(weighted_inputs{node+1}_{i}_0),\n"
        verilog += f"        .sum(sum1[{node}])\n    );\n"

        # Phase 1 tree
        verilog += f"    adder_tree_{layer_no} add{node+num_nodes}(\n"
        verilog += f"        .clk(clk), \n    "
        for i in range(num_inputs):
            verilog += f"        .in{i}(weighted_inputs{node+1}_{i}_1),\n"
        verilog += f"        .sum(sum2[{node}])\n    );\n"

        # Bar phase 0 tree
        verilog += f"    adder_tree_bar_{layer_no} addb{node}(\n"
        verilog += f"        .clk(clk), \n    "
        for i in range(num_inputs):
            verilog += f"        .in{i}(weighted_inputs{node+1}_{i}_0),\n"
        verilog += f"        .sum(sum1bar[{node}])\n    );\n"

        # Bar phase 1 tree
        verilog += f"    adder_tree_bar_{layer_no} addb{node+num_nodes}(\n"
        verilog += f"        .clk(clk), \n    "
        for i in range(num_inputs):
            verilog += f"        .in{i}(weighted_inputs{node+1}_{i}_1),\n"
        verilog += f"        .sum(sum2bar[{node}])\n    );\n"

    # Bias addition
    for node in range(num_nodes):
        verilog += (
            f"    add{adder_bit}bit_{layer_no} u{node} (.a(sum1[{node}]), .b(b{node+1}_0_{layer_no}), .cin(1'b0), .y(biased_sum1[{node}]));\n"
            f"    add{adder_bit}bit_{layer_no} u{node+num_nodes} (.a(sum2[{node}]), .b(b{node+1}_1_{layer_no}), .cin(1'b0), .y(biased_sum2[{node}]));\n"
            f"    add{adder_bit}bitbar_{layer_no} ub{node} (.a(sum1bar[{node}]), .b(b{node+1}_0_{layer_no}), .cin(1'b0), .y(biased_sum1bar[{node}]));\n"
            f"    add{adder_bit}bitbar_{layer_no} ub{node+num_nodes} (.a(sum2bar[{node}]), .b(b{node+1}_1_{layer_no}), .cin(1'b0), .y(biased_sum2bar[{node}]));\n"
        )

    # Output assignment
    for node in range(num_nodes):
        verilog += (
            f"    assign biased_sum{node}_0 = biased_sum1[{node}];\n"
            f"    assign biased_sum{node}_1 = biased_sum2[{node}];\n"
            f"    assign biased_sum{node}_0bar = biased_sum1bar[{node}];\n"
            f"    assign biased_sum{node}_1bar = biased_sum2bar[{node}];\n"
        )

   # Display block
    verilog += "    always @(posedge clk) begin\n"
    verilog += f'        $display("----- BNN LAYER {layer_no} OUTPUTS -----");\n'

    # Inputs
    fmt_in = " ".join(["%b"]*num_inputs)
    sig_in = ", ".join(f"inputs{i}_{layer_no}" for i in range(num_inputs))
    verilog += f'        $display("Inputs : {fmt_in}", {sig_in});\n'

    # Weights:
    fmt_w = " ".join(["%b"]*num_nodes)
    sig_w = ", ".join(f"w{j+1}_{layer_no}" for j in range(num_nodes))
    verilog += f'        $display("Weights: {fmt_w}", {sig_w});\n'

    # Intermediate sums and biased sums
    for arr,label in [("sum1","sum1"),("sum2","sum2"),("sum1bar","sum1bar"),("sum2bar","sum2bar"),
                      ("biased_sum1","biased_sum1"),("biased_sum2","biased_sum2"),
                      ("biased_sum1bar","biased_sum1bar"),("biased_sum2bar","biased_sum2bar")]:
        fmt = " ".join(["%b"]*num_nodes)
        sig = ", ".join(f"{arr}[{j}]" for j in range(num_nodes))
        verilog += f'        $display("{label}: {fmt}", {sig});\n'

    verilog += "    end\nendmodule\n"
    return verilog


def generate_bnn_layer_verilog2(module_name: str, num_inputs: int, num_nodes: int, input_bitwidth :int, layer_no:int) -> str:
    m = input_bitwidth  # Input bit-width
    n = math.ceil(math.log2(num_inputs))  # For summation width
    sum_width = m + n +1+2
    biased_width = sum_width + 1
    adder_bit = sum_width  # Width needed for bias

    verilog = f"""\

module {module_name}(
    input clk,
    input [{m-1}:0] {" , ".join([f"inputs{i}_{layer_no}" for i in range(num_inputs)])},
    input [2:0] {", ".join([f"w_mask{i+1}_2" for i in range(num_nodes)])},
    input [{num_inputs-1}:0] {", ".join([f"w{i+1}_{layer_no}" for i in range(num_nodes)])},
    input [{sum_width-1}:0] {", ".join([f"b{i+1}_0_{layer_no}, b{i+1}_1_{layer_no}" for i in range(num_nodes)])},
    output [{biased_width-1}:0] {", ".join(
        [f"biased_sum{i}_0, biased_sum{i}_1, biased_sum{i}_0bar, biased_sum{i}_1bar" for i in range(num_nodes)]
    )}
);
"""

    # Weighted input wires
    for node in range(num_nodes):
        for i in range(num_inputs):
            verilog += f"    wire [3:0] weighted_inputs{node+1}_{i}_0, weighted_inputs{node+1}_{i}_1;\n"

    verilog += f"""
    wire [{sum_width-1}:0] sum1 [{num_nodes-1}:0];
    wire [{sum_width-1}:0] sum2 [{num_nodes-1}:0];
    wire [{biased_width-1}:0] biased_sum1 [{num_nodes-1}:0];
    wire [{biased_width-1}:0] biased_sum2 [{num_nodes-1}:0];
    wire [{sum_width-1}:0] sum1bar [{num_nodes-1}:0];
    wire [{sum_width-1}:0] sum2bar [{num_nodes-1}:0];
    wire [{biased_width-1}:0] biased_sum1bar [{num_nodes-1}:0];
    wire [{biased_width-1}:0] biased_sum2bar [{num_nodes-1}:0];
"""

    # Weighted input instances
    for node in range(num_nodes):
        for i in range(num_inputs):
            idx = node * num_inputs + i
            verilog += (
                f"    weighted_inputs_{layer_no} w{idx} (.inputs(inputs{i}_{layer_no}), .w(w{node+1}_{layer_no}[{num_inputs-i-1}]),.w_mask_2(w_mask{node+1}_2), .wi(weighted_inputs{node+1}_{i}_0) , .w_i_mask(weighted_inputs{node+1}_{i}_1));\n"
            )

    # Adder tree instantiations
    for node in range(num_nodes):
        # Phase 0 tree
        verilog += f"    adder_tree_{layer_no} add{node}(\n"
        verilog += f"    .clk(clk), \n"
        for i in range(num_inputs):
            verilog += f"        .in{i}(weighted_inputs{node+1}_{i}_0),\n"
        verilog += f"        .sum(sum1[{node}])\n    );\n"

        # Phase 1 tree
        verilog += f"    adder_tree_{layer_no} add{node+num_nodes}(\n"
        verilog += f"    .clk(clk), \n"
        for i in range(num_inputs):
            verilog += f"        .in{i}(weighted_inputs{node+1}_{i}_1),\n"
        verilog += f"        .sum(sum2[{node}])\n    );\n"

        # Bar phase 0 tree
        verilog += f"    adder_tree_bar_{layer_no} addb{node}(\n"
        verilog += f"    .clk(clk), \n"
        for i in range(num_inputs):
            verilog += f"        .in{i}(weighted_inputs{node+1}_{i}_0),\n"
        verilog += f"        .sum(sum1bar[{node}])\n    );\n"

        # Bar phase 1 tree
        verilog += f"    adder_tree_bar_{layer_no} addb{node+num_nodes}(\n"
        verilog += f"    .clk(clk), \n"
        for i in range(num_inputs):
            verilog += f"        .in{i}(weighted_inputs{node+1}_{i}_1),\n"
        verilog += f"        .sum(sum2bar[{node}])\n    );\n"

    # Bias addition
    for node in range(num_nodes):
        verilog += (
            f"    add{adder_bit}bit_{layer_no} u{node} (.a(sum1[{node}]), .b(b{node+1}_0_{layer_no}), .cin(1'b0), .y(biased_sum1[{node}]));\n"
            f"    add{adder_bit}bit_{layer_no} u{node+num_nodes} (.a(sum2[{node}]), .b(b{node+1}_1_{layer_no}), .cin(1'b0), .y(biased_sum2[{node}]));\n"
            f"    add{adder_bit}bitbar_{layer_no} ub{node} (.a(sum1bar[{node}]), .b(b{node+1}_0_{layer_no}), .cin(1'b0), .y(biased_sum1bar[{node}]));\n"
            f"    add{adder_bit}bitbar_{layer_no} ub{node+num_nodes} (.a(sum2bar[{node}]), .b(b{node+1}_1_{layer_no}), .cin(1'b0), .y(biased_sum2bar[{node}]));\n"
        )

    # Output assignment
    for node in range(num_nodes):
        verilog += (
            f"    assign biased_sum{node}_0 = biased_sum1[{node}];\n"
            f"    assign biased_sum{node}_1 = biased_sum2[{node}];\n"
            f"    assign biased_sum{node}_0bar = biased_sum1bar[{node}];\n"
            f"    assign biased_sum{node}_1bar = biased_sum2bar[{node}];\n"
        )

   # Display block
    verilog += "    always @(posedge clk) begin\n"
    verilog += f'        $display("----- BNN LAYER {layer_no} OUTPUTS -----");\n'

    # Inputs
    fmt_in = " ".join(["%b"]*num_inputs)
    sig_in = ", ".join(f"inputs{i}_{layer_no}" for i in range(num_inputs))
    verilog += f'        $display("Inputs : {fmt_in}", {sig_in});\n'

    # Weights
    fmt_w = " ".join(["%b"]*num_nodes)
    sig_w = ", ".join(f"w{j+1}_{layer_no}" for j in range(num_nodes))
    verilog += f'        $display("Weights: {fmt_w}", {sig_w});\n'

    # Intermediate sums and biased sums
    for arr,label in [("sum1","sum1"),("sum2","sum2"),("sum1bar","sum1bar"),("sum2bar","sum2bar"),
                      ("biased_sum1","biased_sum1"),("biased_sum2","biased_sum2"),
                      ("biased_sum1bar","biased_sum1bar"),("biased_sum2bar","biased_sum2bar")]:
        fmt = " ".join(["%b"]*num_nodes)
        sig = ", ".join(f"{arr}[{j}]" for j in range(num_nodes))
        verilog += f'        $display("{label}: {fmt}", {sig});\n'

    verilog += "    end\nendmodule\n"
    return verilog


def generate_activation_module(num_inputs : int , input_bitwidth : int,layer_no : int):
    assert input_bitwidth >= 1, "Bit size must be at least 1"
    n = math.ceil(math.log2(num_inputs)) +input_bitwidth +2

    lines = []
    lines.append(f"module activation_{layer_no} (")
    lines.append("")
    lines.append(f"    input [{n-1}:0] inputs0_0,")
    lines.append(f"    input [{n-1}:0] inputs0_1,")
    lines.append("")

    # Random mask inputs
    rand_inputs = ', '.join([f"r{i}_0" for i in range(n)])
    lines.append(f"    input {rand_inputs},")
    lines.append("")
    lines.append("    output  masked_activation ")
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
    lines.append(f"    assign masked_activation = (carry ^ inputs0_0[{n-1}] ^ inputs0_1[{n-1}]) ? 1'b0 : 1'b1;")
    lines.append("")

    lines.append("endmodule")

    return '\n'.join(lines)

def generate_activation_array_verilog(module_name: str, num_inputs:int,
                                    num_nodes:int , input_bitwidth : int,layer_no :int) -> str:
    lines = []
    num_activations=num_nodes
    n=n = math.ceil(math.log2(num_inputs)) +input_bitwidth +2

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
    for i in range(num_activations - 1):
        lines.append(f"    output wire masked_activation{i},")
    lines.append(f"    output wire  masked_activation{num_activations - 1}\n);")
    lines.append("")

    # Instantiations of activation modules
    for i in range(num_activations):
        lines.append(f"    activation_{layer_no} a{i} (")
        lines.append(f"        .inputs0_0(inputs{i}_0), .inputs0_1(inputs{i}_1),")
        for j in range(n):
            lines.append(f"        .r{j}_0(r{j}_{i}),")
        lines.append(f"        .masked_activation(masked_activation{i})")
        lines.append("    );\n")

    lines.append("endmodule")

    return "\n".join(lines)



def generate_activation_and_conversion_module(num_inputs: int, input_bitwidth: int, num_nodes: int,layer_no :int ) -> str:
    weight_bitwidth = num_inputs
    bias_bitwidth = input_bitwidth + int(math.log2(num_inputs))+1
    biased_sum_width = bias_bitwidth + 1
    activa_bitwidth = biased_sum_width
    mask_bits = input_bitwidth-1
    act_bits = mask_bits + 1


    def clk_decl():
        return f"input  wire clk, "
        
    def wmask1_decl():
        return "\n  ".join([f"input  wire [{input_bitwidth-1}:0] w_mask{j}_1, " for j in range(1, num_nodes+1)])
        
    def inputs_decl():
        return "\n  ".join([f"input  wire [{input_bitwidth-1}:0] inputs{i}_{layer_no}," for i in range(num_inputs)])

    def weights_decl():
        return "\n  ".join([f"input  wire [{weight_bitwidth-1}:0] w{j}_{layer_no}, " for j in range(1, num_nodes+1)])

    def biases_decl():
        return f"input  wire [{bias_bitwidth-1}:0] " + ", ".join([f"b{j}_0_{layer_no},b{j}_1_{layer_no}" for j in range(1, num_nodes+1)]) + ","

    def masks_decl():
        return "\n  ".join([f"input  wire r{r}_{n}," for n in range(num_nodes) for r in range(activa_bitwidth)])

    def masked_activation_outputs():
        lines = []
        for j in range(num_nodes):
            line = f"output wire  masked_activation{j}_{layer_no}, masked_activation{j}bar_{layer_no}"
            if j != num_nodes - 1:
                line += ","
            lines.append(line)
        return "\n  ".join(lines)

    def wire_decls():
        return "\n  ".join([
            f"wire [{biased_sum_width-1}:0] biased_sum{j}_{k}, biased_sum{j}_{k}bar;"
            for j in range(num_nodes) for k in [0,1]
        ])

    def layer1_inst():
        lines = [f"  layer{layer_no} l1 ("]
        lines += [f"    .clk(clk),"]
        lines += [f"    .w_mask{j}_1(w_mask{j}_1)," for j in range(1, num_nodes+1)]
        lines += [f"    .inputs{i}_{layer_no}(inputs{i}_{layer_no})," for i in range(num_inputs)]
        lines += [f"    .w{j}_{layer_no}(w{j}_{layer_no})," for j in range(1, num_nodes+1)]
        lines += [f"    .b{j}_0_{layer_no}(b{j}_0_{layer_no})," for j in range(1, num_nodes+1)]
        lines += [f"    .b{j}_1_{layer_no}(b{j}_1_{layer_no})," for j in range(1, num_nodes+1)]
        lines += [f"    .biased_sum{j}_{k}(biased_sum{j}_{k})," for j in range(num_nodes) for k in [0,1]]
        lines += [f"    .biased_sum{j}_{k}bar(biased_sum{j}_{k}bar)," for j in range(num_nodes) for k in [0,1]]
        lines[-1] = lines[-1][:-1]  # remove trailing comma
        lines.append("  );")
        return "\n".join(lines)

    def activation_array_instance(name, suffix):
        suffix_str = "" if suffix == "" else "bar"
        lines = [f"  activation_array_{layer_no} {name} ("]
        lines += [f"    .inputs{j}_{k}(biased_sum{j}_{k}{suffix_str})," for j in range(num_nodes) for k in [0,1]]
        lines += [f"    .r{r}_{j}(r{r}_{j})," for j in range(num_nodes) for r in range(activa_bitwidth)]
        lines += [f"    .masked_activation{j}(masked_activation{j}{suffix_str}_{layer_no})," for j in range(num_nodes)]
        lines[-1] = lines[-1][:-1]  # remove trailing comma
        lines.append("  );")
        return "\n".join(lines)

    def display_block():
        def disp_row(label, signals):
            fmt = ' '.join(['%b'] * len(signals))
            sigs = ', '.join(signals)
            return f'    $display("{label} : {fmt}", {sigs});'
        lines = [
            "  always @(posedge clk) begin",
            f'    $display("----- LAYER {layer_no}   boolean activations -----");',
            disp_row("masked_activation", [f"masked_activation{j}_{layer_no}" for j in range(num_nodes)]),
            disp_row("masked_activationbar", [f"masked_activation{j}bar_{layer_no}" for j in range(num_nodes)]),
            "  end\n"
        ]
        return "\n".join(lines)

    return f"""\


module activation_and_conversion_{layer_no}(
  {clk_decl()}
  {wmask1_decl()}
  {inputs_decl()}
  {weights_decl()}
  {biases_decl()}
  {masks_decl()}
  {masked_activation_outputs()}
);

  {wire_decls()}

  {layer1_inst()}

  {activation_array_instance("act1", "")}

  {activation_array_instance("act2", "bar")}

  {display_block()}

endmodule
"""

def generate_activation_and_conversion_module2(num_inputs: int, input_bitwidth: int, num_nodes: int,layer_no :int ) -> str:
    weight_bitwidth = num_inputs
    bias_bitwidth = input_bitwidth + int(math.log2(num_inputs))+1 +2
    biased_sum_width = bias_bitwidth + 1 
    activa_bitwidth = biased_sum_width
    mask_bits = input_bitwidth-1
    act_bits = mask_bits + 1


    def clk_decl():
        return f"input  wire clk, "
    
        
    def wmask2_decl():
        return "\n  ".join([f"input  wire [2:0] w_mask{j}_2, " for j in range(1, num_nodes+1)])
        
    def inputs_decl():
        return "\n  ".join([f"input  wire [{input_bitwidth-1}:0] inputs{i}_{layer_no}," for i in range(num_inputs)])

    def weights_decl():
        return "\n  ".join([f"input  wire [{weight_bitwidth-1}:0] w{j}_{layer_no}, " for j in range(1, num_nodes+1)])

    def biases_decl():
        return f"input  wire [{bias_bitwidth-1}:0] " + ", ".join([f"b{j}_0_{layer_no},b{j}_1_{layer_no}" for j in range(1, num_nodes+1)]) + ","

    def masks_decl():
        return "\n  ".join([f"input  wire r{r}_{n}," for n in range(num_nodes) for r in range(activa_bitwidth)])

    def masked_activation_outputs():
        lines = []
        for j in range(num_nodes):
            line = f"output wire  masked_activation{j}_{layer_no}, masked_activation{j}bar_{layer_no}"
            if j != num_nodes - 1:
                line += ","
            lines.append(line)
        return "\n  ".join(lines)

    def wire_decls():
        return "\n  ".join([
            f"wire [{biased_sum_width-1}:0] biased_sum{j}_{k}, biased_sum{j}_{k}bar;"
            for j in range(num_nodes) for k in [0,1]
        ])

    def layer1_inst():
        lines = [f"  layer{layer_no} l1 ("]
        lines += [f"    .clk(clk),"]
        lines += [f"    .w_mask{j}_2(w_mask{j}_2)," for j in range(1, num_nodes+1)]
        lines += [f"    .inputs{i}_{layer_no}(inputs{i}_{layer_no})," for i in range(num_inputs)]
        lines += [f"    .w{j}_{layer_no}(w{j}_{layer_no})," for j in range(1, num_nodes+1)]
        lines += [f"    .b{j}_0_{layer_no}(b{j}_0_{layer_no})," for j in range(1, num_nodes+1)]
        lines += [f"    .b{j}_1_{layer_no}(b{j}_1_{layer_no})," for j in range(1, num_nodes+1)]
        lines += [f"    .biased_sum{j}_{k}(biased_sum{j}_{k})," for j in range(num_nodes) for k in [0,1]]
        lines += [f"    .biased_sum{j}_{k}bar(biased_sum{j}_{k}bar)," for j in range(num_nodes) for k in [0,1]]
        lines[-1] = lines[-1][:-1]  # remove trailing comma
        lines.append("  );")
        return "\n".join(lines)

    def activation_array_instance(name, suffix):
        suffix_str = "" if suffix == "" else "bar"
        lines = [f"  activation_array_{layer_no} {name} ("]
        lines += [f"    .inputs{j}_{k}(biased_sum{j}_{k}{suffix_str})," for j in range(num_nodes) for k in [0,1]]
        lines += [f"    .r{r}_{j}(r{r}_{j})," for j in range(num_nodes) for r in range(activa_bitwidth)]
        lines += [f"    .masked_activation{j}(masked_activation{j}{suffix_str}_{layer_no})," for j in range(num_nodes)]
        lines[-1] = lines[-1][:-1]  # remove trailing comma
        lines.append("  );")
        return "\n".join(lines)

    def display_block():
        def disp_row(label, signals):
            fmt = ' '.join(['%b'] * len(signals))
            sigs = ', '.join(signals)
            return f'    $display("{label} : {fmt}", {sigs});'
        lines = [
            "  always @(posedge clk) begin",
            f'    $display("----- LAYER {layer_no}   boolean activations -----");',
            disp_row("masked_activation", [f"masked_activation{j}_{layer_no}" for j in range(num_nodes)]),
            disp_row("masked_activationbar", [f"masked_activation{j}bar_{layer_no}" for j in range(num_nodes)]),
            "  end\n"
        ]
        return "\n".join(lines)

    return f"""\


module activation_and_conversion_{layer_no}(
  {clk_decl()}
  {wmask2_decl()}
  {inputs_decl()}
  {weights_decl()}
  {biases_decl()}
  {masks_decl()}
  {masked_activation_outputs()}
);

  {wire_decls()}

  {layer1_inst()}

  {activation_array_instance("act1", "")}

  {activation_array_instance("act2", "bar")}

  {display_block()}

endmodule
"""

def generate_full_design1(num_inputs: int,
                         input_bitwidth: int,
                         num_nodes: int ,layer_no : int) -> str:
    parts = [
        generate_all_adders(input_bitwidth, num_inputs,layer_no),
        generate_all_adders_bar(input_bitwidth, num_inputs,layer_no),
        weighted_func1(input_bitwidth),
        generate_adder_tree(f"adder_tree_{layer_no}",num_inputs, input_bitwidth,layer_no),
        generate_adder_tree_bar(f"adder_tree_bar_{layer_no}",num_inputs, input_bitwidth,layer_no),
        generate_bnn_layer_verilog1(f"layer{layer_no}",
                                   num_inputs, num_nodes , input_bitwidth,layer_no ),
        generate_activation_module(num_inputs, input_bitwidth,layer_no),
        generate_activation_array_verilog(f"activation_array_{layer_no}",num_inputs, num_nodes, input_bitwidth,layer_no),
        
        generate_activation_and_conversion_module(num_inputs, input_bitwidth, num_nodes,layer_no)
    ]
    return "\n\n".join(parts)


def generate_full_design2(num_inputs: int,
                         input_bitwidth: int,
                         num_nodes: int ,layer_no : int) -> str:
    parts = [
        generate_all_adders(input_bitwidth+2, num_inputs,layer_no),
        generate_all_adders_bar(input_bitwidth+2, num_inputs,layer_no),
        weighted_func2(layer_no),
        generate_adder_tree(f"adder_tree_{layer_no}",num_inputs, input_bitwidth+2,layer_no),
        generate_adder_tree_bar(f"adder_tree_bar_{layer_no}",num_inputs, input_bitwidth+2,layer_no),
        generate_bnn_layer_verilog2(f"layer{layer_no}",
                                   num_inputs, num_nodes , input_bitwidth,layer_no ),
        generate_activation_module(num_inputs, input_bitwidth+2,layer_no),
        generate_activation_array_verilog(f"activation_array_{layer_no}",num_inputs, num_nodes, input_bitwidth+2,layer_no),
        
        generate_activation_and_conversion_module2(num_inputs, input_bitwidth, num_nodes,layer_no)
    ]
    return "\n\n".join(parts)




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


import math

def generate_output_layer_max_module(num_inputs: int,
                                     num_nodes: int,
                                     input_bitwidth: int, layer_no:int ) -> str:
    assert (num_nodes & (num_nodes - 1)) == 0, "num_nodes must be a power of 2"
    assert num_nodes >= 2, "Minimum 2 nodes required"

    # width of the sums coming out of layer1
    sum_w = input_bitwidth + math.ceil(math.log2(num_inputs))+1+2

    lines = []
    # -- Module header and port list --
    lines.append(f"module output_layer_max (")
    # raw inputs to layer1:
    lines.append(f"  input  clk, ")
    for j in range(1, num_nodes+1):
        lines.append(f"    input  wire [2:0] w_mask{j}_2,")
    for i in range(num_inputs):
        lines.append(f"  input  wire [{input_bitwidth-1}:0] inputs{i}_{layer_no},")
    # weights for layer1:
    for j in range(1, num_nodes+1):
        lines.append(f"    input  wire [{num_inputs-1}:0] w{j}_{layer_no},")
    # biases for layer1:
    for j in range(1, num_nodes+1):
        lines.append(f"    input  wire [{sum_w-1}:0] b{j}_0_{layer_no},b{j}_1_{layer_no},")
    # randomness for each of (num_nodes−1) comparators
    for cid in range(num_nodes - 1):
        for r in range(sum_w+2):
            lines.append(f"    input  wire r{r}_{cid},")
            lines.append(f"    input  wire r{r}_{cid}bar,")
    # outputs of this max‐layer
    for i in range(num_nodes):
        lines.append(f"    output reg  a{i}, a{i}_bar,")
    # drop trailing comma on last port
    lines[-1] = lines[-1].rstrip(',')
    lines.append(");")
    lines.append("")

    # -- Instantiate layer1 to produce all the biased_sum wires --
    # first declare them
    for j in range(num_nodes):
        lines.append(
            f"    wire [{sum_w}:0] "
            f"biased_sum{j}_0, biased_sum{j}_1, "
            f"biased_sum{j}_0bar, biased_sum{j}_1bar;"
        )
    lines.append("")

    # nested helper to emit the layer1 instantiation
    def layer1_inst():
        stmt = [f"    layer{layer_no} l1 ("]
        # inputs
        stmt.append(f"        .clk(clk),")
        for j in range(1, num_nodes+1):
            stmt.append(f"        .w_mask{j}_2(w_mask{j}_2),")
        for i in range(num_inputs):
            stmt.append(f"        .inputs{i}_{layer_no}(inputs{i}_{layer_no}),")
        # weights
        for j in range(1, num_nodes+1):
            stmt.append(f"        .w{j}_{layer_no}(w{j}_{layer_no}),")
        # biases
        for j in range(1, num_nodes+1):
            stmt.append(f"        .b{j}_0_{layer_no}(b{j}_0_{layer_no}),")
        for j in range(1, num_nodes+1):
            stmt.append(f"        .b{j}_1_{layer_no}(b{j}_1_{layer_no}),")
        # biased_sum outputs
        for j in range(num_nodes):
            for k in (0,1):
                stmt.append(f"        .biased_sum{j}_{k}(biased_sum{j}_{k}),")
        for j in range(num_nodes):
            for k in (0,1):
                stmt.append(f"        .biased_sum{j}_{k}bar(biased_sum{j}_{k}bar),")
        # remove trailing comma
        stmt[-1] = stmt[-1].rstrip(',')
        stmt.append("    );")
        return "\n".join(stmt)

    lines.append(layer1_inst())
    lines.append("")

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
            lines.append("    always @(posedge clk) begin")
            lines.append(f"        if (comp{comp_id})      begin {mux0} <= {A0};    {mux1} <= {A1};    end")
            lines.append(f"        else                    begin {mux0} <= {B0};    {mux1} <= {B1};    end")
            lines.append(f"        if (comp{comp_id}_bar)  begin {mux0b} <= {A0b}; {mux1b} <= {A1b}; end")
            lines.append(f"        else                    begin {mux0b} <= {B0b}; {mux1b} <= {B1b}; end")
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
    lines.append("    always @(posedge clk) begin")
    for i in range(num_nodes):
        lines.append(f"        a{i} <= 0; a{i}_bar <= 0;")
    lines.append("")

    for i in range(num_nodes):
        path = trace_path(i)
        if not path:
            continue
        cond_n = " && ".join(f"comp{cid} == {val}" for cid, val in path)

        if i == 0:
            lines.append(f"        if ({cond_n}) a0     <= 1;")
        elif i < num_nodes - 1:
            lines.append(f"        else if ({cond_n}) a{i}     <= 1;")
        else:
            lines.append("        else             a{0}     <= 1;".format(i))
    lines.append("")
    for i in range(num_nodes):
        path = trace_path(i)
        if not path:
            continue
        cond_b = " && ".join(f"comp{cid}_bar == {val}" for cid, val in path)
        if i == 0:
            lines.append(f"        if ({cond_b}) a0_bar     <= 1;")
        elif i < num_nodes - 1:
            lines.append(f"        else if ({cond_b}) a{i}_bar     <= 1;")
        else:
            lines.append("        else             a{0}_bar     <= 1;".format(i))
            
    lines.append("    end")
    lines.append("endmodule")

    return "\n".join(lines)

def generate_last_module_design(num_inputs: int,
                         input_bitwidth: int,
                         num_nodes: int ,layer_no : int) -> str:
    parts = [
        generate_all_adders(input_bitwidth+2, num_inputs,layer_no),
        generate_all_adders_bar(input_bitwidth+2, num_inputs,layer_no),
        weighted_func2(layer_no),
        generate_adder_tree(f"adder_tree_{layer_no}",num_inputs, input_bitwidth+2,layer_no),
        generate_adder_tree_bar(f"adder_tree_bar_{layer_no}",num_inputs, input_bitwidth+2,layer_no),
        generate_bnn_layer_verilog2(f"layer{layer_no}",
                                   num_inputs, num_nodes , input_bitwidth,layer_no ),
        generate_comparator_and_subtractor(input_bitwidth+3,num_inputs, num_nodes),
        generate_output_layer_max_module( num_inputs, num_nodes,
                                            input_bitwidth,layer_no)
    ]
    return "\n\n".join(parts)


def generate_connector(
    num_inputs,      
    input_bitwidth1,
    input_bitwidth2,
    input_bitwidth3,
    input_bitwidth4,
    num_nodes1,      
    num_nodes2,      
    num_nodes3,
    num_nodes4,
    layer_no1,       
    layer_no2,       
    layer_no3,
    layer_no4 
):
    m1 = input_bitwidth1
    m2 = input_bitwidth2
    m3 = input_bitwidth3
    m4 = input_bitwidth4
    
    n = math.ceil(math.log2(num_inputs))
    sum1_w = m1 + n+1
    bias1_w = sum1_w 

    k2 =  num_nodes1 
    sum2_w = m2 + math.ceil(math.log2(k2))+1+2
    bias2_w = sum2_w 

    k3 =  num_nodes2 
    sum3_w = m3 + math.ceil(math.log2(k3))+1+2
    bias3_w = sum3_w

    k4 =  num_nodes3 
    sum4_w = m4 + math.ceil(math.log2(k4))+1+2
    bias4_w = sum4_w 

    lines = []
    lines.append("module connector(")

    # --- Layer-1 ports ---
    lines.append("    // Layer-1 inputs")
    lines.append(f"    input  wire clk ,")
    for i in range(num_inputs):
        lines.append(f"    input  wire [{m1-1}:0] inputs{i}_{layer_no1},")
    lines.append("    // Layer-1 weights & biases")
    for n1 in range(1, num_nodes1+1):
        lines.append(f"    input  wire [{num_inputs-1}:0] w{n1}_{layer_no1},")
    lines.append(f"    input  wire [{bias1_w-1}:0] " +
                 ", ".join(f"b{n1}_0_{layer_no1},b{n1}_1_{layer_no1}" for n1 in range(1, num_nodes1+1)) + ",")

    # --- Layer-2 ports ---
    lines.append("\n    // Layer-2 weights & biases")
    for n2 in range(1, num_nodes2+1):
        lines.append(f"    input  wire [{k2-1}:0] w{n2}_{layer_no2},")
    lines.append(f"    input  wire [{bias2_w-1}:0] " +
                 ", ".join(f"b{n2}_0_{layer_no2},b{n2}_1_{layer_no2}" for n2 in range(1, num_nodes2+1)) + ",")

    # --- Layer-3 (output) ports ---
    lines.append("\n    // Layer-3 weights & biases (output layer)")
    for n3 in range(1, num_nodes3+1):
        lines.append(f"    input  wire [{k3-1}:0] w{n3}_{layer_no3},")
    for n3 in range(1, num_nodes3+1):
        lines.append(f"    input  wire [{bias3_w-1}:0] b{n3}_0_{layer_no3},b{n3}_1_{layer_no3},")
        
    # --- Layer-4 (output) ports ---
    lines.append("\n    // Layer-4 weights & biases (output layer)")
    for n3 in range(1, num_nodes4+1):
        lines.append(f"    input  wire [{k4-1}:0] w{n3}_{layer_no4}, ")
    for n3 in range(1, num_nodes4+1):
        lines.append(f"    input  wire [{bias4_w-1}:0] b{n3}_0_{layer_no4},b{n3}_1_{layer_no4},")

    # --- Final outputs ---
    lines.append("\n    // Final outputs")
    for o in range(num_nodes4):
        suffix = "," if o < num_nodes4-1 else ""
        lines.append(f"    output wire a{o}, a{o}_bar{suffix}")

    lines.append(");\n")

    # --- Layer-1 randomness taps and instantiation ---
    lines.append("  //--------------------------------------------------------------------------")
    lines.append("  // Layer-1 randomness taps")
    lines.append("  //--------------------------------------------------------------------------")
# declare regs
    taps1 = num_nodes1 
    taps2= bias1_w+1
    for t in range(taps1):
        for m in range(taps2):
            lines.append(f"  reg  r{m}_{t}_{layer_no1};")
    lines.append("  initial begin")
    for t in range(taps1):
        for m in range(taps2):
            lines.append(f"    r{m}_{t}_{layer_no1} = $random;")
    lines.append("    #1;")
    lines.append("  end\n")
    
    
    for t in range(taps1):
        lines.append(f"  reg signed [{m1-1}:0] w_mask{t+1}_1;")
    lines.append("  initial begin")
    for t in range(taps1):
        lines.append(f"    w_mask{t+1}_1 = ($urandom % {2**(m1-1) - 1}) - {2**(m1-1) - 1 - 1 + 1};")
    lines.append("    #1;")
    lines.append("  end\n")

# maskdeclaration
    for j in range(num_nodes1):
        lines.append(f" wire  masked_activation{j}_{layer_no1}, masked_activation{j}bar_{layer_no1};")  
        

    for j in range(num_nodes1):
        lines.append(f" reg   masked_activationr{j}_{layer_no1}, masked_activationr{j}bar_{layer_no1};")  
        
        

# instantiate layer-1
    lines.append(f"  activation_and_conversion_{layer_no1} layer{layer_no1}_inst (")
# inputs
    lines.append(f"    .clk(clk),")
    for n1 in range(1, num_nodes1+1):
        lines.append(f"    .w_mask{n1}_1(w_mask{n1}_1),")
    for i in range(num_inputs):
        lines.append(f"    .inputs{i}_{layer_no1}(inputs{i}_{layer_no1}),")
# weights & biases
    for n1 in range(1, num_nodes1+1):
        lines.append(f"    .w{n1}_{layer_no1}(w{n1}_{layer_no1}),")
    lines.append("    " + ", ".join(f".b{n1}_0_{layer_no1}(b{n1}_0_{layer_no1})" for n1 in range(1, num_nodes1+1)) + ",")
    lines.append("    " + ", ".join(f".b{n1}_1_{layer_no1}(b{n1}_1_{layer_no1})" for n1 in range(1, num_nodes1+1)) + ",")
# randomness taps
    for t in range(taps1):
        for m in range(taps2):
            lines.append(f"    .r{m}_{t}(r{m}_{t}_{layer_no1}),")
# masked‐boolean outputs & masks
    for n1 in range(num_nodes1):
        lines.append(f"    .masked_activation{n1}_{layer_no1}(masked_activation{n1}_{layer_no1}), "
                 f".masked_activation{n1}bar_{layer_no1}(masked_activation{n1}bar_{layer_no1}),")
                 
    # strip the trailing comma on the last port
    lines[-1] = lines[-1].rstrip(',')
    # close instance
    lines.append(f"  );\n")
    
    lines.append("  always @(posedge clk) begin")
    for n1 in range(num_nodes1):
        lines.append(f"    masked_activationr{n1}_{layer_no1} <= masked_activation{n1}_{layer_no1};")
    for n1 in range(num_nodes1):
        lines.append(f"    masked_activationr{n1}bar_{layer_no1} <= masked_activation{n1}_{layer_no1};")
    lines.append("  end\n")

    # --- Layer-2 randomness taps and instantiation (same pattern) ---
    lines.append("  //--------------------------------------------------------------------------")
    lines.append("  // Layer-2 randomness taps")
    lines.append("  //--------------------------------------------------------------------------")
    taps3 = num_nodes2 
    taps4= bias2_w+1
    for x in range(taps3):
        for y in range(taps4):
            lines.append(f"  reg  r{y}_{x}_{layer_no2};")
    lines.append("  initial begin")
    for x in range(taps3):
        for y in range(taps4):
            lines.append(f"    r{y}_{x}_{layer_no2} = $random;")
    lines.append("    #1;")
    lines.append("  end\n")
    
    
    for t in range(taps3):
        lines.append(f"  reg [2:0] w_mask{t+1}_2;")
    lines.append("  initial begin")
    for t in range(taps3):
        lines.append(f"    w_mask{t+1}_2 = ($urandom % 7) - 3;")
    lines.append("    #1;")
    lines.append("  end\n")
    
# maskdeclaration
    for j in range(num_nodes2):
        lines.append(f" wire  masked_activation{j}_{layer_no2}, masked_activation{j}bar_{layer_no2};")  
        
    for j in range(num_nodes2):
        lines.append(f" reg  masked_activationr{j}_{layer_no2}, masked_activationr{j}bar_{layer_no2};")  
        
        

    lines.append(f"  activation_and_conversion_{layer_no2} layer{layer_no2}_inst (")
    # inputs: act outputs from layer1
    
    lines.append(f"    .clk(clk),")
    for n2 in range(1, num_nodes2+1):
        lines.append(f"    .w_mask{n2}_2(w_mask{n2}_2),")
    for i in range(num_nodes1):
        lines.append(f"    .inputs{i}_{layer_no2}(masked_activation{i}_{layer_no1}),")
    # weights & biases
    for n2 in range(1, num_nodes2+1):
        lines.append(f"    .w{n2}_{layer_no2}(w{n2}_{layer_no2}),")
    lines.append("    " + ", ".join(f".b{n2}_0_{layer_no2}(b{n2}_0_{layer_no2})" for n2 in range(1, num_nodes2+1)) + ",")
    lines.append("    " + ", ".join(f".b{n2}_1_{layer_no2}(b{n2}_1_{layer_no2})" for n2 in range(1, num_nodes2+1)) + ",")
    # randomness taps
    for x in range(taps3):
        for y in range(taps4):
            lines.append(f"    .r{y}_{x}(r{y}_{x}_{layer_no2}),")
        
    # masked‐boolean outputs & masks
    for n1 in range(num_nodes2):
        lines.append(f"    .masked_activation{n1}_{layer_no2}(masked_activation{n1}_{layer_no2}), "
                 f".masked_activation{n1}bar_{layer_no2}(masked_activation{n1}bar_{layer_no2}),")
                
    # strip the trailing comma on the last port
    lines[-1] = lines[-1].rstrip(',')
    # close instance
    lines.append(f"  );\n")
    
    lines.append("  always @(posedge clk) begin")
    for n1 in range(num_nodes2):
        lines.append(f"    masked_activationr{n1}_{layer_no2} <= masked_activation{n1}_{layer_no2};")
        
    for n1 in range(num_nodes2):
        lines.append(f"    masked_activationr{n1}bar_{layer_no2} <= masked_activation{n1}_{layer_no2};")
    lines.append("  end\n")


# --- Layer-3 randomness taps and instantiation (same pattern) ---
    lines.append("  //--------------------------------------------------------------------------")
    lines.append("  // Layer-3 randomness taps")
    lines.append("  //--------------------------------------------------------------------------")
    taps5 = num_nodes3 
    taps6= bias3_w+1
    for x in range(taps5):
        for y in range(taps6):
            lines.append(f"  reg  r{y}_{x}_{layer_no3};")
    lines.append("  initial begin")
    for x in range(taps5):
        for y in range(taps6):
            lines.append(f"    r{y}_{x}_{layer_no3} = $random;")
    lines.append("    #1;")
    lines.append("  end\n")


    for t in range(taps5):
        lines.append(f"  reg [2:0] w_mask{t+1}_3;")
    lines.append("  initial begin")
    for t in range(taps5):
        lines.append(f"    w_mask{t+1}_3 = ($urandom % 7) - 3;")
    lines.append("    #1;")
    lines.append("  end\n")
    
# maskdeclaration
    for j in range(num_nodes3):
        lines.append(f" wire  masked_activation{j}_{layer_no3}, masked_activation{j}bar_{layer_no3};")  
        
    for j in range(num_nodes3):
        lines.append(f" reg  masked_activationr{j}_{layer_no3}, masked_activationr{j}bar_{layer_no3};")  
        


    lines.append(f"  activation_and_conversion_{layer_no3} layer{layer_no3}_inst (")
    # inputs: act outputs from layer1
    
    lines.append(f"    .clk(clk),")
    for n2 in range(1, num_nodes3+1):
        lines.append(f"    .w_mask{n2}_2(w_mask{n2}_3),")
    for i in range(num_nodes2):
        lines.append(f"    .inputs{i}_{layer_no3}(masked_activation{i}_{layer_no2}),")
    # weights & biases
    for n2 in range(1, num_nodes3+1):
        lines.append(f"    .w{n2}_{layer_no3}(w{n2}_{layer_no3}),")
    lines.append("    " + ", ".join(f".b{n2}_0_{layer_no3}(b{n2}_0_{layer_no3})" for n2 in range(1, num_nodes3+1)) + ",")
    lines.append("    " + ", ".join(f".b{n2}_1_{layer_no3}(b{n2}_1_{layer_no3})" for n2 in range(1, num_nodes3+1)) + ",")
    # randomness taps
    for x in range(taps5):
        for y in range(taps6):
            lines.append(f"    .r{y}_{x}(r{y}_{x}_{layer_no3}),")
        
    # masked‐boolean outputs & masks
    for n1 in range(num_nodes3):
        lines.append(f"    .masked_activation{n1}_{layer_no3}(masked_activation{n1}_{layer_no3}), "
                 f".masked_activation{n1}bar_{layer_no3}(masked_activation{n1}bar_{layer_no3}),")
    # strip the trailing comma on the last port
    lines[-1] = lines[-1].rstrip(',')
    # close instance
    lines.append(f"  );\n")
    
    lines.append("  always @(posedge clk) begin")
    for n1 in range(num_nodes3):
        lines.append(f"    masked_activationr{n1}_{layer_no3} <= masked_activation{n1}_{layer_no3};")
    for n1 in range(num_nodes3):
        lines.append(f"    masked_activationr{n1}bar_{layer_no3} <= masked_activation{n1}_{layer_no3};")
    lines.append("  end\n")

    # --- Layer-4 (output) randomness taps and instantiation ---
    lines.append("  //--------------------------------------------------------------------------")
    lines.append("  // Layer-4 randomness taps")
    lines.append("  //--------------------------------------------------------------------------")
    taps7 = bias4_w+2
    for cid in range(num_nodes4 - 1):
        for r in range(taps7):
            lines.append(f"    reg r{r}_{cid};")
            lines.append(f"    reg r{r}_{cid}bar;")    
    lines.append("  initial begin")
    for cid in range(num_nodes4 - 1):
        for r in range(taps7):
            lines.append(f"    r{r}_{cid} = $random;")
            lines.append(f"    r{r}_{cid}bar = $random;")
    lines.append("    #1;")
    lines.append("  end\n")
    
    for t in range(taps7):
        lines.append(f"  reg [2:0] w_mask{t+1}_4;")
    lines.append("  initial begin")
    for t in range(taps7):
        lines.append(f"    w_mask{t+1}_4 = ($urandom % 7) - 3;")
    lines.append("    #1;")
    lines.append("  end\n")

    for t in range(num_nodes4):
        lines.append(f" reg a{t}_reg ;")  
        
    for t in range(num_nodes4):
        lines.append(f" reg a{t}_bar_reg ;")
        
    lines.append(f"  output_layer_max layer{layer_no4} (")
    # inputs: act outputs from layer2
    
    lines.append(f"    .clk(clk),")
    for n2 in range(1, num_nodes4+1):
        lines.append(f"    .w_mask{n2}_2(w_mask{n2}_4),")
    for i in range(num_nodes3):
        lines.append(f"    .inputs{i}_{layer_no4}(masked_activation{i}_{layer_no3}),")
        
    # weights & biases
    for n2 in range(1, num_nodes4+1):
        lines.append(f"    .w{n2}_{layer_no4}(w{n2}_{layer_no4}),")
        
    lines.append("    " + ", ".join(f".b{n2}_0_{layer_no4}(b{n2}_0_{layer_no4})" for n2 in range(1, num_nodes4+1)) + ",")
    lines.append("    " + ", ".join(f".b{n2}_1_{layer_no4}(b{n2}_1_{layer_no4})" for n2 in range(1, num_nodes4+1)) + ",")   
    # randomness taps
    # randomness for each of (num_nodes−1) comparators
    for cid in range(num_nodes4 - 1):
        for r in range(taps7):
            lines.append(f"    .r{r}_{cid}(r{r}_{cid}), .r{r}_{cid}bar(r{r}_{cid}bar),")
    # final output
    for t in range(num_nodes4):
        lines.append(f"    .a{t}(a{t}), .a{t}_bar(a{t}_bar),")
    # strip the trailing comma on the last port
    lines[-1] = lines[-1].rstrip(',')
    lines.append("  );\n")
    
    lines.append("  always @(posedge clk) begin")
    for t in range(num_nodes4):
        lines.append(f"    a{t}_reg <= a{t};")
    for t in range(num_nodes4):
        lines.append(f"    a{t}_bar_reg <= a{t}_bar;")
    lines.append("  end\n")

    lines.append("endmodule")
    lines.append("`default_nettype wire")
    return "\n".join(lines)



                               
                                    
    # ——— Example usage ——————————————————————————————————————————————

if __name__ == "__main__":
    # list out exactly the shape of each layer you want to generate
    layer_specs = [
        { "layer_no":      1,
          "num_inputs":    64,
          "input_bitwidth": 9,
          "num_nodes":     8 }

        # …
    ]

    # now iterate over them
    for spec in layer_specs:
        code = generate_full_design1(
            num_inputs=     spec["num_inputs"],
            input_bitwidth= spec["input_bitwidth"],
            num_nodes=      spec["num_nodes"],
            layer_no=       spec["layer_no"],
        )
        print(f"// ----- LAYER {spec['layer_no']} -----")
        print(code)
        print("\n\n")
        
if __name__ == "__main__":
    # list out exactly the shape of each layer you want to generate
    layer_specs = [
        { "layer_no":      2,
          "num_inputs":    8,
          "input_bitwidth": 1, # fixed (do not change this value)
          "num_nodes":     8 },
        { "layer_no":      3,
          "num_inputs":    8,
          "input_bitwidth": 1, # fixed (do not change this value)
          "num_nodes":     8 }

        # …
    ]

    # now iterate over them
    for spec in layer_specs:
        code = generate_full_design2(
            num_inputs=     spec["num_inputs"],
            input_bitwidth= spec["input_bitwidth"],
            num_nodes=      spec["num_nodes"],
            layer_no=       spec["layer_no"],
        )
        print(f"// ----- LAYER {spec['layer_no']} -----")
        print(code)
        print("\n\n")

if __name__ == "__main__":
    # specify your layer parameters here:
    num_inputs    = 8
    num_nodes     = 4
    input_bitwidth = 1 # fixed (do not change this value)
    layer_no=4
    

    verilog_code = generate_last_module_design(
        num_inputs,
        input_bitwidth,
        num_nodes,
        layer_no
    )

    print(verilog_code)


if __name__ == "__main__":
    num_inputs      = 64
    input_bitwidth1  = 9
    input_bitwidth2  = 1  # fixed (do not change this value)
    input_bitwidth3  = 1  # fixed (do not change this value)
    input_bitwidth4  = 1  # fixed (do not change this value)
    num_nodes1      = 8
    num_nodes2      = 8
    num_nodes3      = 8
    num_nodes4      = 4
    layer_no1       = 1
    layer_no2       = 2
    layer_no3       = 3
    layer_no4       = 4

    verilog = generate_connector(
        num_inputs, input_bitwidth1,input_bitwidth2,input_bitwidth3,input_bitwidth4,
        num_nodes1, num_nodes2, num_nodes3, num_nodes4,
        layer_no1, layer_no2, layer_no3, layer_no4
    )
    print(verilog)
