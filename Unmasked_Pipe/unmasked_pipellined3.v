module weighted_inputs_1(

    input [7:0] inputs,

    input w,

    output reg [7:0] wi
);

    always @(*) begin
        if (w == 1'b0) begin
            wi = ~inputs + 1;
        end else begin
            wi = inputs;
        end
    end

endmodule

module weighted_inputs_2(

    input [0:0] inputs,

    input w,

    output reg [0:0] wi
);

    always @(*) begin
        if (w == 1'b0) begin
            wi = ~inputs + 1;
        end else begin
            wi = inputs;
        end
    end

endmodule

module lut0 (
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

// ----- LAYER 1 -----
module half_adder_1(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adder_1(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adder_1 HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adder_1 HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNAND_1(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule

module add8bit_1(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire  cin,
    output wire [8:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;
wire c6;
wire c7;
wire c8;

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));

WddlNAND_1 wn1(.A(~a[7]), .B(b[7]), .C(~c8), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[7]), .B(~b[7]), .C(~c8), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[7]), .B(b[7]), .C(c8), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[7]), .B(~b[7]), .C(c8), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[8] = cout;

endmodule

module add9bit_1(
    input wire [8:0] a,
    input wire [8:0] b,
    input wire  cin,
    output wire [9:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;
wire c6;
wire c7;
wire c8;
wire c9;

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adder_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));

WddlNAND_1 wn1(.A(~a[8]), .B(b[8]), .C(~c9), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[8]), .B(~b[8]), .C(~c9), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[8]), .B(b[8]), .C(c9), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[8]), .B(~b[8]), .C(c9), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[9] = cout;

endmodule

module add10bit_1(
    input wire [9:0] a,
    input wire [9:0] b,
    input wire  cin,
    output wire [10:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;
wire c6;
wire c7;
wire c8;
wire c9;
wire c10;

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adder_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adder_1 fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));

WddlNAND_1 wn1(.A(~a[9]), .B(b[9]), .C(~c10), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[9]), .B(~b[9]), .C(~c10), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[9]), .B(b[9]), .C(c10), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[9]), .B(~b[9]), .C(c10), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[10] = cout;

endmodule

module add11bit_1(
    input wire [10:0] a,
    input wire [10:0] b,
    input wire  cin,
    output wire [11:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;
wire c6;
wire c7;
wire c8;
wire c9;
wire c10;
wire c11;

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adder_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adder_1 fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));
full_adder_1 fa10(.S(y[10]), .C(c11), .X(a[10]), .Y(b[10]), .Z(c10));

WddlNAND_1 wn1(.A(~a[10]), .B(b[10]), .C(~c11), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[10]), .B(~b[10]), .C(~c11), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[10]), .B(b[10]), .C(c11), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[10]), .B(~b[10]), .C(c11), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[11] = cout;

endmodule

module add12bit_1(
    input wire [11:0] a,
    input wire [11:0] b,
    input wire  cin,
    output wire [12:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;
wire c6;
wire c7;
wire c8;
wire c9;
wire c10;
wire c11;
wire c12;

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adder_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adder_1 fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));
full_adder_1 fa10(.S(y[10]), .C(c11), .X(a[10]), .Y(b[10]), .Z(c10));
full_adder_1 fa11(.S(y[11]), .C(c12), .X(a[11]), .Y(b[11]), .Z(c11));

WddlNAND_1 wn1(.A(~a[11]), .B(b[11]), .C(~c12), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[11]), .B(~b[11]), .C(~c12), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[11]), .B(b[11]), .C(c12), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[11]), .B(~b[11]), .C(c12), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[12] = cout;

endmodule

module add13bit_1(
    input wire [12:0] a,
    input wire [12:0] b,
    input wire  cin,
    output wire [13:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;
wire c6;
wire c7;
wire c8;
wire c9;
wire c10;
wire c11;
wire c12;
wire c13;

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adder_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adder_1 fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));
full_adder_1 fa10(.S(y[10]), .C(c11), .X(a[10]), .Y(b[10]), .Z(c10));
full_adder_1 fa11(.S(y[11]), .C(c12), .X(a[11]), .Y(b[11]), .Z(c11));
full_adder_1 fa12(.S(y[12]), .C(c13), .X(a[12]), .Y(b[12]), .Z(c12));

WddlNAND_1 wn1(.A(~a[12]), .B(b[12]), .C(~c13), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[12]), .B(~b[12]), .C(~c13), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[12]), .B(b[12]), .C(c13), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[12]), .B(~b[12]), .C(c13), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[13] = cout;

endmodule



module adder_tree_1 (
    input  wire   clk, 
    input  wire [7:0] in0,
    input  wire [7:0] in1,
    input  wire [7:0] in2,
    input  wire [7:0] in3,
    input  wire [7:0] in4,
    input  wire [7:0] in5,
    input  wire [7:0] in6,
    input  wire [7:0] in7,
    input  wire [7:0] in8,
    input  wire [7:0] in9,
    input  wire [7:0] in10,
    input  wire [7:0] in11,
    input  wire [7:0] in12,
    input  wire [7:0] in13,
    input  wire [7:0] in14,
    input  wire [7:0] in15,
    input  wire [7:0] in16,
    input  wire [7:0] in17,
    input  wire [7:0] in18,
    input  wire [7:0] in19,
    input  wire [7:0] in20,
    input  wire [7:0] in21,
    input  wire [7:0] in22,
    input  wire [7:0] in23,
    input  wire [7:0] in24,
    input  wire [7:0] in25,
    input  wire [7:0] in26,
    input  wire [7:0] in27,
    input  wire [7:0] in28,
    input  wire [7:0] in29,
    input  wire [7:0] in30,
    input  wire [7:0] in31,
    output wire [12:0] sum
);

    wire [8:0] stage0_0_lo_1;
    wire [8:0] stage0_1_lo_1;
    wire [8:0] stage0_2_lo_1;
    wire [8:0] stage0_3_lo_1;
    wire [8:0] stage0_4_lo_1;
    wire [8:0] stage0_5_lo_1;
    wire [8:0] stage0_6_lo_1;
    wire [8:0] stage0_7_lo_1;
    wire [8:0] stage0_8_lo_1;
    wire [8:0] stage0_9_lo_1;
    wire [8:0] stage0_10_lo_1;
    wire [8:0] stage0_11_lo_1;
    wire [8:0] stage0_12_lo_1;
    wire [8:0] stage0_13_lo_1;
    wire [8:0] stage0_14_lo_1;
    wire [8:0] stage0_15_lo_1;
    wire [9:0] stage1_0_lo_1;
    wire [9:0] stage1_1_lo_1;
    wire [9:0] stage1_2_lo_1;
    wire [9:0] stage1_3_lo_1;
    wire [9:0] stage1_4_lo_1;
    wire [9:0] stage1_5_lo_1;
    wire [9:0] stage1_6_lo_1;
    wire [9:0] stage1_7_lo_1;
    wire [10:0] stage2_0_lo_1;
    wire [10:0] stage2_1_lo_1;
    wire [10:0] stage2_2_lo_1;
    wire [10:0] stage2_3_lo_1;
    wire [11:0] stage3_0_lo_1;
    wire [11:0] stage3_1_lo_1;
    wire [12:0] stage4_0_lo_1;
    reg  [8:0] stage0_0_1;
    reg  [8:0] stage0_1_1;
    reg  [8:0] stage0_2_1;
    reg  [8:0] stage0_3_1;
    reg  [8:0] stage0_4_1;
    reg  [8:0] stage0_5_1;
    reg  [8:0] stage0_6_1;
    reg  [8:0] stage0_7_1;
    reg  [8:0] stage0_8_1;
    reg  [8:0] stage0_9_1;
    reg  [8:0] stage0_10_1;
    reg  [8:0] stage0_11_1;
    reg  [8:0] stage0_12_1;
    reg  [8:0] stage0_13_1;
    reg  [8:0] stage0_14_1;
    reg  [8:0] stage0_15_1;
    reg  [9:0] stage1_0_1;
    reg  [9:0] stage1_1_1;
    reg  [9:0] stage1_2_1;
    reg  [9:0] stage1_3_1;
    reg  [9:0] stage1_4_1;
    reg  [9:0] stage1_5_1;
    reg  [9:0] stage1_6_1;
    reg  [9:0] stage1_7_1;
    reg  [10:0] stage2_0_1;
    reg  [10:0] stage2_1_1;
    reg  [10:0] stage2_2_1;
    reg  [10:0] stage2_3_1;
    reg  [11:0] stage3_0_1;
    reg  [11:0] stage3_1_1;
    reg  [12:0] stage4_0_1;

    add8bit_1 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_8 (.a(in16), .b(in17), .cin(1'b0), .y(stage0_8_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_9 (.a(in18), .b(in19), .cin(1'b0), .y(stage0_9_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_10 (.a(in20), .b(in21), .cin(1'b0), .y(stage0_10_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_11 (.a(in22), .b(in23), .cin(1'b0), .y(stage0_11_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_12 (.a(in24), .b(in25), .cin(1'b0), .y(stage0_12_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_13 (.a(in26), .b(in27), .cin(1'b0), .y(stage0_13_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_14 (.a(in28), .b(in29), .cin(1'b0), .y(stage0_14_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_15 (.a(in30), .b(in31), .cin(1'b0), .y(stage0_15_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_0 (.a(stage0_0_1), .b(stage0_1_1), .cin(1'b0), .y(stage1_0_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_1 (.a(stage0_2_1), .b(stage0_3_1), .cin(1'b0), .y(stage1_1_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_2 (.a(stage0_4_1), .b(stage0_5_1), .cin(1'b0), .y(stage1_2_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_3 (.a(stage0_6_1), .b(stage0_7_1), .cin(1'b0), .y(stage1_3_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_4 (.a(stage0_8_1), .b(stage0_9_1), .cin(1'b0), .y(stage1_4_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_5 (.a(stage0_10_1), .b(stage0_11_1), .cin(1'b0), .y(stage1_5_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_6 (.a(stage0_12_1), .b(stage0_13_1), .cin(1'b0), .y(stage1_6_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_7 (.a(stage0_14_1), .b(stage0_15_1), .cin(1'b0), .y(stage1_7_lo_1), .cout(), .cout_bar());
    add10bit_1 u2_0 (.a(stage1_0_1), .b(stage1_1_1), .cin(1'b0), .y(stage2_0_lo_1), .cout(), .cout_bar());
    add10bit_1 u2_1 (.a(stage1_2_1), .b(stage1_3_1), .cin(1'b0), .y(stage2_1_lo_1), .cout(), .cout_bar());
    add10bit_1 u2_2 (.a(stage1_4_1), .b(stage1_5_1), .cin(1'b0), .y(stage2_2_lo_1), .cout(), .cout_bar());
    add10bit_1 u2_3 (.a(stage1_6_1), .b(stage1_7_1), .cin(1'b0), .y(stage2_3_lo_1), .cout(), .cout_bar());
    add11bit_1 u3_0 (.a(stage2_0_1), .b(stage2_1_1), .cin(1'b0), .y(stage3_0_lo_1), .cout(), .cout_bar());
    add11bit_1 u3_1 (.a(stage2_2_1), .b(stage2_3_1), .cin(1'b0), .y(stage3_1_lo_1), .cout(), .cout_bar());
    add12bit_1 u4_0 (.a(stage3_0_1), .b(stage3_1_1), .cin(1'b0), .y(stage4_0_lo_1), .cout(), .cout_bar());

    assign sum =  stage4_0_lo_1;

    always @(posedge clk) begin
        stage0_0_1 <=  stage0_0_lo_1;
        stage0_1_1 <=  stage0_1_lo_1;
        stage0_2_1 <=  stage0_2_lo_1;
        stage0_3_1 <=  stage0_3_lo_1;
        stage0_4_1 <=  stage0_4_lo_1;
        stage0_5_1 <=  stage0_5_lo_1;
        stage0_6_1 <=  stage0_6_lo_1;
        stage0_7_1 <=  stage0_7_lo_1;
        stage0_8_1 <=  stage0_8_lo_1;
        stage0_9_1 <=  stage0_9_lo_1;
        stage0_10_1 <=  stage0_10_lo_1;
        stage0_11_1 <=  stage0_11_lo_1;
        stage0_12_1 <=  stage0_12_lo_1;
        stage0_13_1 <=  stage0_13_lo_1;
        stage0_14_1 <=  stage0_14_lo_1;
        stage0_15_1 <=  stage0_15_lo_1;
        stage1_0_1 <=  stage1_0_lo_1;
        stage1_1_1 <=  stage1_1_lo_1;
        stage1_2_1 <=  stage1_2_lo_1;
        stage1_3_1 <=  stage1_3_lo_1;
        stage1_4_1 <=  stage1_4_lo_1;
        stage1_5_1 <=  stage1_5_lo_1;
        stage1_6_1 <=  stage1_6_lo_1;
        stage1_7_1 <=  stage1_7_lo_1;
        stage2_0_1 <=  stage2_0_lo_1;
        stage2_1_1 <=  stage2_1_lo_1;
        stage2_2_1 <=  stage2_2_lo_1;
        stage2_3_1 <=  stage2_3_lo_1;
        stage3_0_1 <=  stage3_0_lo_1;
        stage3_1_1 <=  stage3_1_lo_1;
        stage4_0_1 <=  stage4_0_lo_1;
    end
endmodule


module layer1(
    input clk,
    input [7:0] inputs0_1 , inputs1_1 , inputs2_1 , inputs3_1 , inputs4_1 , inputs5_1 , inputs6_1 , inputs7_1 , inputs8_1 , inputs9_1 , inputs10_1 , inputs11_1 , inputs12_1 , inputs13_1 , inputs14_1 , inputs15_1 , inputs16_1 , inputs17_1 , inputs18_1 , inputs19_1 , inputs20_1 , inputs21_1 , inputs22_1 , inputs23_1 , inputs24_1 , inputs25_1 , inputs26_1 , inputs27_1 , inputs28_1 , inputs29_1 , inputs30_1 , inputs31_1,
    input [31:0] w1_1, w2_1, w3_1, w4_1, w5_1, w6_1, w7_1, w8_1, w9_1, w10_1, w11_1, w12_1, w13_1, w14_1, w15_1, w16_1,
    input [12:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1, b9_1, b10_1, b11_1, b12_1, b13_1, b14_1, b15_1, b16_1,
    output [13:0] biased_sum0_0, biased_sum1_0, biased_sum2_0, biased_sum3_0, biased_sum4_0, biased_sum5_0, biased_sum6_0, biased_sum7_0, biased_sum8_0, biased_sum9_0, biased_sum10_0, biased_sum11_0, biased_sum12_0, biased_sum13_0, biased_sum14_0, biased_sum15_0
);
    wire [7:0] weighted_inputs1_0;
    wire [7:0] weighted_inputs1_1;
    wire [7:0] weighted_inputs1_2;
    wire [7:0] weighted_inputs1_3;
    wire [7:0] weighted_inputs1_4;
    wire [7:0] weighted_inputs1_5;
    wire [7:0] weighted_inputs1_6;
    wire [7:0] weighted_inputs1_7;
    wire [7:0] weighted_inputs1_8;
    wire [7:0] weighted_inputs1_9;
    wire [7:0] weighted_inputs1_10;
    wire [7:0] weighted_inputs1_11;
    wire [7:0] weighted_inputs1_12;
    wire [7:0] weighted_inputs1_13;
    wire [7:0] weighted_inputs1_14;
    wire [7:0] weighted_inputs1_15;
    wire [7:0] weighted_inputs1_16;
    wire [7:0] weighted_inputs1_17;
    wire [7:0] weighted_inputs1_18;
    wire [7:0] weighted_inputs1_19;
    wire [7:0] weighted_inputs1_20;
    wire [7:0] weighted_inputs1_21;
    wire [7:0] weighted_inputs1_22;
    wire [7:0] weighted_inputs1_23;
    wire [7:0] weighted_inputs1_24;
    wire [7:0] weighted_inputs1_25;
    wire [7:0] weighted_inputs1_26;
    wire [7:0] weighted_inputs1_27;
    wire [7:0] weighted_inputs1_28;
    wire [7:0] weighted_inputs1_29;
    wire [7:0] weighted_inputs1_30;
    wire [7:0] weighted_inputs1_31;
    wire [7:0] weighted_inputs2_0;
    wire [7:0] weighted_inputs2_1;
    wire [7:0] weighted_inputs2_2;
    wire [7:0] weighted_inputs2_3;
    wire [7:0] weighted_inputs2_4;
    wire [7:0] weighted_inputs2_5;
    wire [7:0] weighted_inputs2_6;
    wire [7:0] weighted_inputs2_7;
    wire [7:0] weighted_inputs2_8;
    wire [7:0] weighted_inputs2_9;
    wire [7:0] weighted_inputs2_10;
    wire [7:0] weighted_inputs2_11;
    wire [7:0] weighted_inputs2_12;
    wire [7:0] weighted_inputs2_13;
    wire [7:0] weighted_inputs2_14;
    wire [7:0] weighted_inputs2_15;
    wire [7:0] weighted_inputs2_16;
    wire [7:0] weighted_inputs2_17;
    wire [7:0] weighted_inputs2_18;
    wire [7:0] weighted_inputs2_19;
    wire [7:0] weighted_inputs2_20;
    wire [7:0] weighted_inputs2_21;
    wire [7:0] weighted_inputs2_22;
    wire [7:0] weighted_inputs2_23;
    wire [7:0] weighted_inputs2_24;
    wire [7:0] weighted_inputs2_25;
    wire [7:0] weighted_inputs2_26;
    wire [7:0] weighted_inputs2_27;
    wire [7:0] weighted_inputs2_28;
    wire [7:0] weighted_inputs2_29;
    wire [7:0] weighted_inputs2_30;
    wire [7:0] weighted_inputs2_31;
    wire [7:0] weighted_inputs3_0;
    wire [7:0] weighted_inputs3_1;
    wire [7:0] weighted_inputs3_2;
    wire [7:0] weighted_inputs3_3;
    wire [7:0] weighted_inputs3_4;
    wire [7:0] weighted_inputs3_5;
    wire [7:0] weighted_inputs3_6;
    wire [7:0] weighted_inputs3_7;
    wire [7:0] weighted_inputs3_8;
    wire [7:0] weighted_inputs3_9;
    wire [7:0] weighted_inputs3_10;
    wire [7:0] weighted_inputs3_11;
    wire [7:0] weighted_inputs3_12;
    wire [7:0] weighted_inputs3_13;
    wire [7:0] weighted_inputs3_14;
    wire [7:0] weighted_inputs3_15;
    wire [7:0] weighted_inputs3_16;
    wire [7:0] weighted_inputs3_17;
    wire [7:0] weighted_inputs3_18;
    wire [7:0] weighted_inputs3_19;
    wire [7:0] weighted_inputs3_20;
    wire [7:0] weighted_inputs3_21;
    wire [7:0] weighted_inputs3_22;
    wire [7:0] weighted_inputs3_23;
    wire [7:0] weighted_inputs3_24;
    wire [7:0] weighted_inputs3_25;
    wire [7:0] weighted_inputs3_26;
    wire [7:0] weighted_inputs3_27;
    wire [7:0] weighted_inputs3_28;
    wire [7:0] weighted_inputs3_29;
    wire [7:0] weighted_inputs3_30;
    wire [7:0] weighted_inputs3_31;
    wire [7:0] weighted_inputs4_0;
    wire [7:0] weighted_inputs4_1;
    wire [7:0] weighted_inputs4_2;
    wire [7:0] weighted_inputs4_3;
    wire [7:0] weighted_inputs4_4;
    wire [7:0] weighted_inputs4_5;
    wire [7:0] weighted_inputs4_6;
    wire [7:0] weighted_inputs4_7;
    wire [7:0] weighted_inputs4_8;
    wire [7:0] weighted_inputs4_9;
    wire [7:0] weighted_inputs4_10;
    wire [7:0] weighted_inputs4_11;
    wire [7:0] weighted_inputs4_12;
    wire [7:0] weighted_inputs4_13;
    wire [7:0] weighted_inputs4_14;
    wire [7:0] weighted_inputs4_15;
    wire [7:0] weighted_inputs4_16;
    wire [7:0] weighted_inputs4_17;
    wire [7:0] weighted_inputs4_18;
    wire [7:0] weighted_inputs4_19;
    wire [7:0] weighted_inputs4_20;
    wire [7:0] weighted_inputs4_21;
    wire [7:0] weighted_inputs4_22;
    wire [7:0] weighted_inputs4_23;
    wire [7:0] weighted_inputs4_24;
    wire [7:0] weighted_inputs4_25;
    wire [7:0] weighted_inputs4_26;
    wire [7:0] weighted_inputs4_27;
    wire [7:0] weighted_inputs4_28;
    wire [7:0] weighted_inputs4_29;
    wire [7:0] weighted_inputs4_30;
    wire [7:0] weighted_inputs4_31;
    wire [7:0] weighted_inputs5_0;
    wire [7:0] weighted_inputs5_1;
    wire [7:0] weighted_inputs5_2;
    wire [7:0] weighted_inputs5_3;
    wire [7:0] weighted_inputs5_4;
    wire [7:0] weighted_inputs5_5;
    wire [7:0] weighted_inputs5_6;
    wire [7:0] weighted_inputs5_7;
    wire [7:0] weighted_inputs5_8;
    wire [7:0] weighted_inputs5_9;
    wire [7:0] weighted_inputs5_10;
    wire [7:0] weighted_inputs5_11;
    wire [7:0] weighted_inputs5_12;
    wire [7:0] weighted_inputs5_13;
    wire [7:0] weighted_inputs5_14;
    wire [7:0] weighted_inputs5_15;
    wire [7:0] weighted_inputs5_16;
    wire [7:0] weighted_inputs5_17;
    wire [7:0] weighted_inputs5_18;
    wire [7:0] weighted_inputs5_19;
    wire [7:0] weighted_inputs5_20;
    wire [7:0] weighted_inputs5_21;
    wire [7:0] weighted_inputs5_22;
    wire [7:0] weighted_inputs5_23;
    wire [7:0] weighted_inputs5_24;
    wire [7:0] weighted_inputs5_25;
    wire [7:0] weighted_inputs5_26;
    wire [7:0] weighted_inputs5_27;
    wire [7:0] weighted_inputs5_28;
    wire [7:0] weighted_inputs5_29;
    wire [7:0] weighted_inputs5_30;
    wire [7:0] weighted_inputs5_31;
    wire [7:0] weighted_inputs6_0;
    wire [7:0] weighted_inputs6_1;
    wire [7:0] weighted_inputs6_2;
    wire [7:0] weighted_inputs6_3;
    wire [7:0] weighted_inputs6_4;
    wire [7:0] weighted_inputs6_5;
    wire [7:0] weighted_inputs6_6;
    wire [7:0] weighted_inputs6_7;
    wire [7:0] weighted_inputs6_8;
    wire [7:0] weighted_inputs6_9;
    wire [7:0] weighted_inputs6_10;
    wire [7:0] weighted_inputs6_11;
    wire [7:0] weighted_inputs6_12;
    wire [7:0] weighted_inputs6_13;
    wire [7:0] weighted_inputs6_14;
    wire [7:0] weighted_inputs6_15;
    wire [7:0] weighted_inputs6_16;
    wire [7:0] weighted_inputs6_17;
    wire [7:0] weighted_inputs6_18;
    wire [7:0] weighted_inputs6_19;
    wire [7:0] weighted_inputs6_20;
    wire [7:0] weighted_inputs6_21;
    wire [7:0] weighted_inputs6_22;
    wire [7:0] weighted_inputs6_23;
    wire [7:0] weighted_inputs6_24;
    wire [7:0] weighted_inputs6_25;
    wire [7:0] weighted_inputs6_26;
    wire [7:0] weighted_inputs6_27;
    wire [7:0] weighted_inputs6_28;
    wire [7:0] weighted_inputs6_29;
    wire [7:0] weighted_inputs6_30;
    wire [7:0] weighted_inputs6_31;
    wire [7:0] weighted_inputs7_0;
    wire [7:0] weighted_inputs7_1;
    wire [7:0] weighted_inputs7_2;
    wire [7:0] weighted_inputs7_3;
    wire [7:0] weighted_inputs7_4;
    wire [7:0] weighted_inputs7_5;
    wire [7:0] weighted_inputs7_6;
    wire [7:0] weighted_inputs7_7;
    wire [7:0] weighted_inputs7_8;
    wire [7:0] weighted_inputs7_9;
    wire [7:0] weighted_inputs7_10;
    wire [7:0] weighted_inputs7_11;
    wire [7:0] weighted_inputs7_12;
    wire [7:0] weighted_inputs7_13;
    wire [7:0] weighted_inputs7_14;
    wire [7:0] weighted_inputs7_15;
    wire [7:0] weighted_inputs7_16;
    wire [7:0] weighted_inputs7_17;
    wire [7:0] weighted_inputs7_18;
    wire [7:0] weighted_inputs7_19;
    wire [7:0] weighted_inputs7_20;
    wire [7:0] weighted_inputs7_21;
    wire [7:0] weighted_inputs7_22;
    wire [7:0] weighted_inputs7_23;
    wire [7:0] weighted_inputs7_24;
    wire [7:0] weighted_inputs7_25;
    wire [7:0] weighted_inputs7_26;
    wire [7:0] weighted_inputs7_27;
    wire [7:0] weighted_inputs7_28;
    wire [7:0] weighted_inputs7_29;
    wire [7:0] weighted_inputs7_30;
    wire [7:0] weighted_inputs7_31;
    wire [7:0] weighted_inputs8_0;
    wire [7:0] weighted_inputs8_1;
    wire [7:0] weighted_inputs8_2;
    wire [7:0] weighted_inputs8_3;
    wire [7:0] weighted_inputs8_4;
    wire [7:0] weighted_inputs8_5;
    wire [7:0] weighted_inputs8_6;
    wire [7:0] weighted_inputs8_7;
    wire [7:0] weighted_inputs8_8;
    wire [7:0] weighted_inputs8_9;
    wire [7:0] weighted_inputs8_10;
    wire [7:0] weighted_inputs8_11;
    wire [7:0] weighted_inputs8_12;
    wire [7:0] weighted_inputs8_13;
    wire [7:0] weighted_inputs8_14;
    wire [7:0] weighted_inputs8_15;
    wire [7:0] weighted_inputs8_16;
    wire [7:0] weighted_inputs8_17;
    wire [7:0] weighted_inputs8_18;
    wire [7:0] weighted_inputs8_19;
    wire [7:0] weighted_inputs8_20;
    wire [7:0] weighted_inputs8_21;
    wire [7:0] weighted_inputs8_22;
    wire [7:0] weighted_inputs8_23;
    wire [7:0] weighted_inputs8_24;
    wire [7:0] weighted_inputs8_25;
    wire [7:0] weighted_inputs8_26;
    wire [7:0] weighted_inputs8_27;
    wire [7:0] weighted_inputs8_28;
    wire [7:0] weighted_inputs8_29;
    wire [7:0] weighted_inputs8_30;
    wire [7:0] weighted_inputs8_31;
    wire [7:0] weighted_inputs9_0;
    wire [7:0] weighted_inputs9_1;
    wire [7:0] weighted_inputs9_2;
    wire [7:0] weighted_inputs9_3;
    wire [7:0] weighted_inputs9_4;
    wire [7:0] weighted_inputs9_5;
    wire [7:0] weighted_inputs9_6;
    wire [7:0] weighted_inputs9_7;
    wire [7:0] weighted_inputs9_8;
    wire [7:0] weighted_inputs9_9;
    wire [7:0] weighted_inputs9_10;
    wire [7:0] weighted_inputs9_11;
    wire [7:0] weighted_inputs9_12;
    wire [7:0] weighted_inputs9_13;
    wire [7:0] weighted_inputs9_14;
    wire [7:0] weighted_inputs9_15;
    wire [7:0] weighted_inputs9_16;
    wire [7:0] weighted_inputs9_17;
    wire [7:0] weighted_inputs9_18;
    wire [7:0] weighted_inputs9_19;
    wire [7:0] weighted_inputs9_20;
    wire [7:0] weighted_inputs9_21;
    wire [7:0] weighted_inputs9_22;
    wire [7:0] weighted_inputs9_23;
    wire [7:0] weighted_inputs9_24;
    wire [7:0] weighted_inputs9_25;
    wire [7:0] weighted_inputs9_26;
    wire [7:0] weighted_inputs9_27;
    wire [7:0] weighted_inputs9_28;
    wire [7:0] weighted_inputs9_29;
    wire [7:0] weighted_inputs9_30;
    wire [7:0] weighted_inputs9_31;
    wire [7:0] weighted_inputs10_0;
    wire [7:0] weighted_inputs10_1;
    wire [7:0] weighted_inputs10_2;
    wire [7:0] weighted_inputs10_3;
    wire [7:0] weighted_inputs10_4;
    wire [7:0] weighted_inputs10_5;
    wire [7:0] weighted_inputs10_6;
    wire [7:0] weighted_inputs10_7;
    wire [7:0] weighted_inputs10_8;
    wire [7:0] weighted_inputs10_9;
    wire [7:0] weighted_inputs10_10;
    wire [7:0] weighted_inputs10_11;
    wire [7:0] weighted_inputs10_12;
    wire [7:0] weighted_inputs10_13;
    wire [7:0] weighted_inputs10_14;
    wire [7:0] weighted_inputs10_15;
    wire [7:0] weighted_inputs10_16;
    wire [7:0] weighted_inputs10_17;
    wire [7:0] weighted_inputs10_18;
    wire [7:0] weighted_inputs10_19;
    wire [7:0] weighted_inputs10_20;
    wire [7:0] weighted_inputs10_21;
    wire [7:0] weighted_inputs10_22;
    wire [7:0] weighted_inputs10_23;
    wire [7:0] weighted_inputs10_24;
    wire [7:0] weighted_inputs10_25;
    wire [7:0] weighted_inputs10_26;
    wire [7:0] weighted_inputs10_27;
    wire [7:0] weighted_inputs10_28;
    wire [7:0] weighted_inputs10_29;
    wire [7:0] weighted_inputs10_30;
    wire [7:0] weighted_inputs10_31;
    wire [7:0] weighted_inputs11_0;
    wire [7:0] weighted_inputs11_1;
    wire [7:0] weighted_inputs11_2;
    wire [7:0] weighted_inputs11_3;
    wire [7:0] weighted_inputs11_4;
    wire [7:0] weighted_inputs11_5;
    wire [7:0] weighted_inputs11_6;
    wire [7:0] weighted_inputs11_7;
    wire [7:0] weighted_inputs11_8;
    wire [7:0] weighted_inputs11_9;
    wire [7:0] weighted_inputs11_10;
    wire [7:0] weighted_inputs11_11;
    wire [7:0] weighted_inputs11_12;
    wire [7:0] weighted_inputs11_13;
    wire [7:0] weighted_inputs11_14;
    wire [7:0] weighted_inputs11_15;
    wire [7:0] weighted_inputs11_16;
    wire [7:0] weighted_inputs11_17;
    wire [7:0] weighted_inputs11_18;
    wire [7:0] weighted_inputs11_19;
    wire [7:0] weighted_inputs11_20;
    wire [7:0] weighted_inputs11_21;
    wire [7:0] weighted_inputs11_22;
    wire [7:0] weighted_inputs11_23;
    wire [7:0] weighted_inputs11_24;
    wire [7:0] weighted_inputs11_25;
    wire [7:0] weighted_inputs11_26;
    wire [7:0] weighted_inputs11_27;
    wire [7:0] weighted_inputs11_28;
    wire [7:0] weighted_inputs11_29;
    wire [7:0] weighted_inputs11_30;
    wire [7:0] weighted_inputs11_31;
    wire [7:0] weighted_inputs12_0;
    wire [7:0] weighted_inputs12_1;
    wire [7:0] weighted_inputs12_2;
    wire [7:0] weighted_inputs12_3;
    wire [7:0] weighted_inputs12_4;
    wire [7:0] weighted_inputs12_5;
    wire [7:0] weighted_inputs12_6;
    wire [7:0] weighted_inputs12_7;
    wire [7:0] weighted_inputs12_8;
    wire [7:0] weighted_inputs12_9;
    wire [7:0] weighted_inputs12_10;
    wire [7:0] weighted_inputs12_11;
    wire [7:0] weighted_inputs12_12;
    wire [7:0] weighted_inputs12_13;
    wire [7:0] weighted_inputs12_14;
    wire [7:0] weighted_inputs12_15;
    wire [7:0] weighted_inputs12_16;
    wire [7:0] weighted_inputs12_17;
    wire [7:0] weighted_inputs12_18;
    wire [7:0] weighted_inputs12_19;
    wire [7:0] weighted_inputs12_20;
    wire [7:0] weighted_inputs12_21;
    wire [7:0] weighted_inputs12_22;
    wire [7:0] weighted_inputs12_23;
    wire [7:0] weighted_inputs12_24;
    wire [7:0] weighted_inputs12_25;
    wire [7:0] weighted_inputs12_26;
    wire [7:0] weighted_inputs12_27;
    wire [7:0] weighted_inputs12_28;
    wire [7:0] weighted_inputs12_29;
    wire [7:0] weighted_inputs12_30;
    wire [7:0] weighted_inputs12_31;
    wire [7:0] weighted_inputs13_0;
    wire [7:0] weighted_inputs13_1;
    wire [7:0] weighted_inputs13_2;
    wire [7:0] weighted_inputs13_3;
    wire [7:0] weighted_inputs13_4;
    wire [7:0] weighted_inputs13_5;
    wire [7:0] weighted_inputs13_6;
    wire [7:0] weighted_inputs13_7;
    wire [7:0] weighted_inputs13_8;
    wire [7:0] weighted_inputs13_9;
    wire [7:0] weighted_inputs13_10;
    wire [7:0] weighted_inputs13_11;
    wire [7:0] weighted_inputs13_12;
    wire [7:0] weighted_inputs13_13;
    wire [7:0] weighted_inputs13_14;
    wire [7:0] weighted_inputs13_15;
    wire [7:0] weighted_inputs13_16;
    wire [7:0] weighted_inputs13_17;
    wire [7:0] weighted_inputs13_18;
    wire [7:0] weighted_inputs13_19;
    wire [7:0] weighted_inputs13_20;
    wire [7:0] weighted_inputs13_21;
    wire [7:0] weighted_inputs13_22;
    wire [7:0] weighted_inputs13_23;
    wire [7:0] weighted_inputs13_24;
    wire [7:0] weighted_inputs13_25;
    wire [7:0] weighted_inputs13_26;
    wire [7:0] weighted_inputs13_27;
    wire [7:0] weighted_inputs13_28;
    wire [7:0] weighted_inputs13_29;
    wire [7:0] weighted_inputs13_30;
    wire [7:0] weighted_inputs13_31;
    wire [7:0] weighted_inputs14_0;
    wire [7:0] weighted_inputs14_1;
    wire [7:0] weighted_inputs14_2;
    wire [7:0] weighted_inputs14_3;
    wire [7:0] weighted_inputs14_4;
    wire [7:0] weighted_inputs14_5;
    wire [7:0] weighted_inputs14_6;
    wire [7:0] weighted_inputs14_7;
    wire [7:0] weighted_inputs14_8;
    wire [7:0] weighted_inputs14_9;
    wire [7:0] weighted_inputs14_10;
    wire [7:0] weighted_inputs14_11;
    wire [7:0] weighted_inputs14_12;
    wire [7:0] weighted_inputs14_13;
    wire [7:0] weighted_inputs14_14;
    wire [7:0] weighted_inputs14_15;
    wire [7:0] weighted_inputs14_16;
    wire [7:0] weighted_inputs14_17;
    wire [7:0] weighted_inputs14_18;
    wire [7:0] weighted_inputs14_19;
    wire [7:0] weighted_inputs14_20;
    wire [7:0] weighted_inputs14_21;
    wire [7:0] weighted_inputs14_22;
    wire [7:0] weighted_inputs14_23;
    wire [7:0] weighted_inputs14_24;
    wire [7:0] weighted_inputs14_25;
    wire [7:0] weighted_inputs14_26;
    wire [7:0] weighted_inputs14_27;
    wire [7:0] weighted_inputs14_28;
    wire [7:0] weighted_inputs14_29;
    wire [7:0] weighted_inputs14_30;
    wire [7:0] weighted_inputs14_31;
    wire [7:0] weighted_inputs15_0;
    wire [7:0] weighted_inputs15_1;
    wire [7:0] weighted_inputs15_2;
    wire [7:0] weighted_inputs15_3;
    wire [7:0] weighted_inputs15_4;
    wire [7:0] weighted_inputs15_5;
    wire [7:0] weighted_inputs15_6;
    wire [7:0] weighted_inputs15_7;
    wire [7:0] weighted_inputs15_8;
    wire [7:0] weighted_inputs15_9;
    wire [7:0] weighted_inputs15_10;
    wire [7:0] weighted_inputs15_11;
    wire [7:0] weighted_inputs15_12;
    wire [7:0] weighted_inputs15_13;
    wire [7:0] weighted_inputs15_14;
    wire [7:0] weighted_inputs15_15;
    wire [7:0] weighted_inputs15_16;
    wire [7:0] weighted_inputs15_17;
    wire [7:0] weighted_inputs15_18;
    wire [7:0] weighted_inputs15_19;
    wire [7:0] weighted_inputs15_20;
    wire [7:0] weighted_inputs15_21;
    wire [7:0] weighted_inputs15_22;
    wire [7:0] weighted_inputs15_23;
    wire [7:0] weighted_inputs15_24;
    wire [7:0] weighted_inputs15_25;
    wire [7:0] weighted_inputs15_26;
    wire [7:0] weighted_inputs15_27;
    wire [7:0] weighted_inputs15_28;
    wire [7:0] weighted_inputs15_29;
    wire [7:0] weighted_inputs15_30;
    wire [7:0] weighted_inputs15_31;
    wire [7:0] weighted_inputs16_0;
    wire [7:0] weighted_inputs16_1;
    wire [7:0] weighted_inputs16_2;
    wire [7:0] weighted_inputs16_3;
    wire [7:0] weighted_inputs16_4;
    wire [7:0] weighted_inputs16_5;
    wire [7:0] weighted_inputs16_6;
    wire [7:0] weighted_inputs16_7;
    wire [7:0] weighted_inputs16_8;
    wire [7:0] weighted_inputs16_9;
    wire [7:0] weighted_inputs16_10;
    wire [7:0] weighted_inputs16_11;
    wire [7:0] weighted_inputs16_12;
    wire [7:0] weighted_inputs16_13;
    wire [7:0] weighted_inputs16_14;
    wire [7:0] weighted_inputs16_15;
    wire [7:0] weighted_inputs16_16;
    wire [7:0] weighted_inputs16_17;
    wire [7:0] weighted_inputs16_18;
    wire [7:0] weighted_inputs16_19;
    wire [7:0] weighted_inputs16_20;
    wire [7:0] weighted_inputs16_21;
    wire [7:0] weighted_inputs16_22;
    wire [7:0] weighted_inputs16_23;
    wire [7:0] weighted_inputs16_24;
    wire [7:0] weighted_inputs16_25;
    wire [7:0] weighted_inputs16_26;
    wire [7:0] weighted_inputs16_27;
    wire [7:0] weighted_inputs16_28;
    wire [7:0] weighted_inputs16_29;
    wire [7:0] weighted_inputs16_30;
    wire [7:0] weighted_inputs16_31;

    wire [12:0] sum1 [15:0];
    wire [13:0] biased_sum1 [15:0];

    weighted_inputs_1 w0 (.inputs(inputs0_1), .w(w1_1[0]), .wi(weighted_inputs1_0));
    weighted_inputs_1 w1 (.inputs(inputs1_1), .w(w1_1[1]), .wi(weighted_inputs1_1));
    weighted_inputs_1 w2 (.inputs(inputs2_1), .w(w1_1[2]), .wi(weighted_inputs1_2));
    weighted_inputs_1 w3 (.inputs(inputs3_1), .w(w1_1[3]), .wi(weighted_inputs1_3));
    weighted_inputs_1 w4 (.inputs(inputs4_1), .w(w1_1[4]), .wi(weighted_inputs1_4));
    weighted_inputs_1 w5 (.inputs(inputs5_1), .w(w1_1[5]), .wi(weighted_inputs1_5));
    weighted_inputs_1 w6 (.inputs(inputs6_1), .w(w1_1[6]), .wi(weighted_inputs1_6));
    weighted_inputs_1 w7 (.inputs(inputs7_1), .w(w1_1[7]), .wi(weighted_inputs1_7));
    weighted_inputs_1 w8 (.inputs(inputs8_1), .w(w1_1[8]), .wi(weighted_inputs1_8));
    weighted_inputs_1 w9 (.inputs(inputs9_1), .w(w1_1[9]), .wi(weighted_inputs1_9));
    weighted_inputs_1 w10 (.inputs(inputs10_1), .w(w1_1[10]), .wi(weighted_inputs1_10));
    weighted_inputs_1 w11 (.inputs(inputs11_1), .w(w1_1[11]), .wi(weighted_inputs1_11));
    weighted_inputs_1 w12 (.inputs(inputs12_1), .w(w1_1[12]), .wi(weighted_inputs1_12));
    weighted_inputs_1 w13 (.inputs(inputs13_1), .w(w1_1[13]), .wi(weighted_inputs1_13));
    weighted_inputs_1 w14 (.inputs(inputs14_1), .w(w1_1[14]), .wi(weighted_inputs1_14));
    weighted_inputs_1 w15 (.inputs(inputs15_1), .w(w1_1[15]), .wi(weighted_inputs1_15));
    weighted_inputs_1 w16 (.inputs(inputs16_1), .w(w1_1[16]), .wi(weighted_inputs1_16));
    weighted_inputs_1 w17 (.inputs(inputs17_1), .w(w1_1[17]), .wi(weighted_inputs1_17));
    weighted_inputs_1 w18 (.inputs(inputs18_1), .w(w1_1[18]), .wi(weighted_inputs1_18));
    weighted_inputs_1 w19 (.inputs(inputs19_1), .w(w1_1[19]), .wi(weighted_inputs1_19));
    weighted_inputs_1 w20 (.inputs(inputs20_1), .w(w1_1[20]), .wi(weighted_inputs1_20));
    weighted_inputs_1 w21 (.inputs(inputs21_1), .w(w1_1[21]), .wi(weighted_inputs1_21));
    weighted_inputs_1 w22 (.inputs(inputs22_1), .w(w1_1[22]), .wi(weighted_inputs1_22));
    weighted_inputs_1 w23 (.inputs(inputs23_1), .w(w1_1[23]), .wi(weighted_inputs1_23));
    weighted_inputs_1 w24 (.inputs(inputs24_1), .w(w1_1[24]), .wi(weighted_inputs1_24));
    weighted_inputs_1 w25 (.inputs(inputs25_1), .w(w1_1[25]), .wi(weighted_inputs1_25));
    weighted_inputs_1 w26 (.inputs(inputs26_1), .w(w1_1[26]), .wi(weighted_inputs1_26));
    weighted_inputs_1 w27 (.inputs(inputs27_1), .w(w1_1[27]), .wi(weighted_inputs1_27));
    weighted_inputs_1 w28 (.inputs(inputs28_1), .w(w1_1[28]), .wi(weighted_inputs1_28));
    weighted_inputs_1 w29 (.inputs(inputs29_1), .w(w1_1[29]), .wi(weighted_inputs1_29));
    weighted_inputs_1 w30 (.inputs(inputs30_1), .w(w1_1[30]), .wi(weighted_inputs1_30));
    weighted_inputs_1 w31 (.inputs(inputs31_1), .w(w1_1[31]), .wi(weighted_inputs1_31));
    weighted_inputs_1 w32 (.inputs(inputs0_1), .w(w2_1[0]), .wi(weighted_inputs2_0));
    weighted_inputs_1 w33 (.inputs(inputs1_1), .w(w2_1[1]), .wi(weighted_inputs2_1));
    weighted_inputs_1 w34 (.inputs(inputs2_1), .w(w2_1[2]), .wi(weighted_inputs2_2));
    weighted_inputs_1 w35 (.inputs(inputs3_1), .w(w2_1[3]), .wi(weighted_inputs2_3));
    weighted_inputs_1 w36 (.inputs(inputs4_1), .w(w2_1[4]), .wi(weighted_inputs2_4));
    weighted_inputs_1 w37 (.inputs(inputs5_1), .w(w2_1[5]), .wi(weighted_inputs2_5));
    weighted_inputs_1 w38 (.inputs(inputs6_1), .w(w2_1[6]), .wi(weighted_inputs2_6));
    weighted_inputs_1 w39 (.inputs(inputs7_1), .w(w2_1[7]), .wi(weighted_inputs2_7));
    weighted_inputs_1 w40 (.inputs(inputs8_1), .w(w2_1[8]), .wi(weighted_inputs2_8));
    weighted_inputs_1 w41 (.inputs(inputs9_1), .w(w2_1[9]), .wi(weighted_inputs2_9));
    weighted_inputs_1 w42 (.inputs(inputs10_1), .w(w2_1[10]), .wi(weighted_inputs2_10));
    weighted_inputs_1 w43 (.inputs(inputs11_1), .w(w2_1[11]), .wi(weighted_inputs2_11));
    weighted_inputs_1 w44 (.inputs(inputs12_1), .w(w2_1[12]), .wi(weighted_inputs2_12));
    weighted_inputs_1 w45 (.inputs(inputs13_1), .w(w2_1[13]), .wi(weighted_inputs2_13));
    weighted_inputs_1 w46 (.inputs(inputs14_1), .w(w2_1[14]), .wi(weighted_inputs2_14));
    weighted_inputs_1 w47 (.inputs(inputs15_1), .w(w2_1[15]), .wi(weighted_inputs2_15));
    weighted_inputs_1 w48 (.inputs(inputs16_1), .w(w2_1[16]), .wi(weighted_inputs2_16));
    weighted_inputs_1 w49 (.inputs(inputs17_1), .w(w2_1[17]), .wi(weighted_inputs2_17));
    weighted_inputs_1 w50 (.inputs(inputs18_1), .w(w2_1[18]), .wi(weighted_inputs2_18));
    weighted_inputs_1 w51 (.inputs(inputs19_1), .w(w2_1[19]), .wi(weighted_inputs2_19));
    weighted_inputs_1 w52 (.inputs(inputs20_1), .w(w2_1[20]), .wi(weighted_inputs2_20));
    weighted_inputs_1 w53 (.inputs(inputs21_1), .w(w2_1[21]), .wi(weighted_inputs2_21));
    weighted_inputs_1 w54 (.inputs(inputs22_1), .w(w2_1[22]), .wi(weighted_inputs2_22));
    weighted_inputs_1 w55 (.inputs(inputs23_1), .w(w2_1[23]), .wi(weighted_inputs2_23));
    weighted_inputs_1 w56 (.inputs(inputs24_1), .w(w2_1[24]), .wi(weighted_inputs2_24));
    weighted_inputs_1 w57 (.inputs(inputs25_1), .w(w2_1[25]), .wi(weighted_inputs2_25));
    weighted_inputs_1 w58 (.inputs(inputs26_1), .w(w2_1[26]), .wi(weighted_inputs2_26));
    weighted_inputs_1 w59 (.inputs(inputs27_1), .w(w2_1[27]), .wi(weighted_inputs2_27));
    weighted_inputs_1 w60 (.inputs(inputs28_1), .w(w2_1[28]), .wi(weighted_inputs2_28));
    weighted_inputs_1 w61 (.inputs(inputs29_1), .w(w2_1[29]), .wi(weighted_inputs2_29));
    weighted_inputs_1 w62 (.inputs(inputs30_1), .w(w2_1[30]), .wi(weighted_inputs2_30));
    weighted_inputs_1 w63 (.inputs(inputs31_1), .w(w2_1[31]), .wi(weighted_inputs2_31));
    weighted_inputs_1 w64 (.inputs(inputs0_1), .w(w3_1[0]), .wi(weighted_inputs3_0));
    weighted_inputs_1 w65 (.inputs(inputs1_1), .w(w3_1[1]), .wi(weighted_inputs3_1));
    weighted_inputs_1 w66 (.inputs(inputs2_1), .w(w3_1[2]), .wi(weighted_inputs3_2));
    weighted_inputs_1 w67 (.inputs(inputs3_1), .w(w3_1[3]), .wi(weighted_inputs3_3));
    weighted_inputs_1 w68 (.inputs(inputs4_1), .w(w3_1[4]), .wi(weighted_inputs3_4));
    weighted_inputs_1 w69 (.inputs(inputs5_1), .w(w3_1[5]), .wi(weighted_inputs3_5));
    weighted_inputs_1 w70 (.inputs(inputs6_1), .w(w3_1[6]), .wi(weighted_inputs3_6));
    weighted_inputs_1 w71 (.inputs(inputs7_1), .w(w3_1[7]), .wi(weighted_inputs3_7));
    weighted_inputs_1 w72 (.inputs(inputs8_1), .w(w3_1[8]), .wi(weighted_inputs3_8));
    weighted_inputs_1 w73 (.inputs(inputs9_1), .w(w3_1[9]), .wi(weighted_inputs3_9));
    weighted_inputs_1 w74 (.inputs(inputs10_1), .w(w3_1[10]), .wi(weighted_inputs3_10));
    weighted_inputs_1 w75 (.inputs(inputs11_1), .w(w3_1[11]), .wi(weighted_inputs3_11));
    weighted_inputs_1 w76 (.inputs(inputs12_1), .w(w3_1[12]), .wi(weighted_inputs3_12));
    weighted_inputs_1 w77 (.inputs(inputs13_1), .w(w3_1[13]), .wi(weighted_inputs3_13));
    weighted_inputs_1 w78 (.inputs(inputs14_1), .w(w3_1[14]), .wi(weighted_inputs3_14));
    weighted_inputs_1 w79 (.inputs(inputs15_1), .w(w3_1[15]), .wi(weighted_inputs3_15));
    weighted_inputs_1 w80 (.inputs(inputs16_1), .w(w3_1[16]), .wi(weighted_inputs3_16));
    weighted_inputs_1 w81 (.inputs(inputs17_1), .w(w3_1[17]), .wi(weighted_inputs3_17));
    weighted_inputs_1 w82 (.inputs(inputs18_1), .w(w3_1[18]), .wi(weighted_inputs3_18));
    weighted_inputs_1 w83 (.inputs(inputs19_1), .w(w3_1[19]), .wi(weighted_inputs3_19));
    weighted_inputs_1 w84 (.inputs(inputs20_1), .w(w3_1[20]), .wi(weighted_inputs3_20));
    weighted_inputs_1 w85 (.inputs(inputs21_1), .w(w3_1[21]), .wi(weighted_inputs3_21));
    weighted_inputs_1 w86 (.inputs(inputs22_1), .w(w3_1[22]), .wi(weighted_inputs3_22));
    weighted_inputs_1 w87 (.inputs(inputs23_1), .w(w3_1[23]), .wi(weighted_inputs3_23));
    weighted_inputs_1 w88 (.inputs(inputs24_1), .w(w3_1[24]), .wi(weighted_inputs3_24));
    weighted_inputs_1 w89 (.inputs(inputs25_1), .w(w3_1[25]), .wi(weighted_inputs3_25));
    weighted_inputs_1 w90 (.inputs(inputs26_1), .w(w3_1[26]), .wi(weighted_inputs3_26));
    weighted_inputs_1 w91 (.inputs(inputs27_1), .w(w3_1[27]), .wi(weighted_inputs3_27));
    weighted_inputs_1 w92 (.inputs(inputs28_1), .w(w3_1[28]), .wi(weighted_inputs3_28));
    weighted_inputs_1 w93 (.inputs(inputs29_1), .w(w3_1[29]), .wi(weighted_inputs3_29));
    weighted_inputs_1 w94 (.inputs(inputs30_1), .w(w3_1[30]), .wi(weighted_inputs3_30));
    weighted_inputs_1 w95 (.inputs(inputs31_1), .w(w3_1[31]), .wi(weighted_inputs3_31));
    weighted_inputs_1 w96 (.inputs(inputs0_1), .w(w4_1[0]), .wi(weighted_inputs4_0));
    weighted_inputs_1 w97 (.inputs(inputs1_1), .w(w4_1[1]), .wi(weighted_inputs4_1));
    weighted_inputs_1 w98 (.inputs(inputs2_1), .w(w4_1[2]), .wi(weighted_inputs4_2));
    weighted_inputs_1 w99 (.inputs(inputs3_1), .w(w4_1[3]), .wi(weighted_inputs4_3));
    weighted_inputs_1 w100 (.inputs(inputs4_1), .w(w4_1[4]), .wi(weighted_inputs4_4));
    weighted_inputs_1 w101 (.inputs(inputs5_1), .w(w4_1[5]), .wi(weighted_inputs4_5));
    weighted_inputs_1 w102 (.inputs(inputs6_1), .w(w4_1[6]), .wi(weighted_inputs4_6));
    weighted_inputs_1 w103 (.inputs(inputs7_1), .w(w4_1[7]), .wi(weighted_inputs4_7));
    weighted_inputs_1 w104 (.inputs(inputs8_1), .w(w4_1[8]), .wi(weighted_inputs4_8));
    weighted_inputs_1 w105 (.inputs(inputs9_1), .w(w4_1[9]), .wi(weighted_inputs4_9));
    weighted_inputs_1 w106 (.inputs(inputs10_1), .w(w4_1[10]), .wi(weighted_inputs4_10));
    weighted_inputs_1 w107 (.inputs(inputs11_1), .w(w4_1[11]), .wi(weighted_inputs4_11));
    weighted_inputs_1 w108 (.inputs(inputs12_1), .w(w4_1[12]), .wi(weighted_inputs4_12));
    weighted_inputs_1 w109 (.inputs(inputs13_1), .w(w4_1[13]), .wi(weighted_inputs4_13));
    weighted_inputs_1 w110 (.inputs(inputs14_1), .w(w4_1[14]), .wi(weighted_inputs4_14));
    weighted_inputs_1 w111 (.inputs(inputs15_1), .w(w4_1[15]), .wi(weighted_inputs4_15));
    weighted_inputs_1 w112 (.inputs(inputs16_1), .w(w4_1[16]), .wi(weighted_inputs4_16));
    weighted_inputs_1 w113 (.inputs(inputs17_1), .w(w4_1[17]), .wi(weighted_inputs4_17));
    weighted_inputs_1 w114 (.inputs(inputs18_1), .w(w4_1[18]), .wi(weighted_inputs4_18));
    weighted_inputs_1 w115 (.inputs(inputs19_1), .w(w4_1[19]), .wi(weighted_inputs4_19));
    weighted_inputs_1 w116 (.inputs(inputs20_1), .w(w4_1[20]), .wi(weighted_inputs4_20));
    weighted_inputs_1 w117 (.inputs(inputs21_1), .w(w4_1[21]), .wi(weighted_inputs4_21));
    weighted_inputs_1 w118 (.inputs(inputs22_1), .w(w4_1[22]), .wi(weighted_inputs4_22));
    weighted_inputs_1 w119 (.inputs(inputs23_1), .w(w4_1[23]), .wi(weighted_inputs4_23));
    weighted_inputs_1 w120 (.inputs(inputs24_1), .w(w4_1[24]), .wi(weighted_inputs4_24));
    weighted_inputs_1 w121 (.inputs(inputs25_1), .w(w4_1[25]), .wi(weighted_inputs4_25));
    weighted_inputs_1 w122 (.inputs(inputs26_1), .w(w4_1[26]), .wi(weighted_inputs4_26));
    weighted_inputs_1 w123 (.inputs(inputs27_1), .w(w4_1[27]), .wi(weighted_inputs4_27));
    weighted_inputs_1 w124 (.inputs(inputs28_1), .w(w4_1[28]), .wi(weighted_inputs4_28));
    weighted_inputs_1 w125 (.inputs(inputs29_1), .w(w4_1[29]), .wi(weighted_inputs4_29));
    weighted_inputs_1 w126 (.inputs(inputs30_1), .w(w4_1[30]), .wi(weighted_inputs4_30));
    weighted_inputs_1 w127 (.inputs(inputs31_1), .w(w4_1[31]), .wi(weighted_inputs4_31));
    weighted_inputs_1 w128 (.inputs(inputs0_1), .w(w5_1[0]), .wi(weighted_inputs5_0));
    weighted_inputs_1 w129 (.inputs(inputs1_1), .w(w5_1[1]), .wi(weighted_inputs5_1));
    weighted_inputs_1 w130 (.inputs(inputs2_1), .w(w5_1[2]), .wi(weighted_inputs5_2));
    weighted_inputs_1 w131 (.inputs(inputs3_1), .w(w5_1[3]), .wi(weighted_inputs5_3));
    weighted_inputs_1 w132 (.inputs(inputs4_1), .w(w5_1[4]), .wi(weighted_inputs5_4));
    weighted_inputs_1 w133 (.inputs(inputs5_1), .w(w5_1[5]), .wi(weighted_inputs5_5));
    weighted_inputs_1 w134 (.inputs(inputs6_1), .w(w5_1[6]), .wi(weighted_inputs5_6));
    weighted_inputs_1 w135 (.inputs(inputs7_1), .w(w5_1[7]), .wi(weighted_inputs5_7));
    weighted_inputs_1 w136 (.inputs(inputs8_1), .w(w5_1[8]), .wi(weighted_inputs5_8));
    weighted_inputs_1 w137 (.inputs(inputs9_1), .w(w5_1[9]), .wi(weighted_inputs5_9));
    weighted_inputs_1 w138 (.inputs(inputs10_1), .w(w5_1[10]), .wi(weighted_inputs5_10));
    weighted_inputs_1 w139 (.inputs(inputs11_1), .w(w5_1[11]), .wi(weighted_inputs5_11));
    weighted_inputs_1 w140 (.inputs(inputs12_1), .w(w5_1[12]), .wi(weighted_inputs5_12));
    weighted_inputs_1 w141 (.inputs(inputs13_1), .w(w5_1[13]), .wi(weighted_inputs5_13));
    weighted_inputs_1 w142 (.inputs(inputs14_1), .w(w5_1[14]), .wi(weighted_inputs5_14));
    weighted_inputs_1 w143 (.inputs(inputs15_1), .w(w5_1[15]), .wi(weighted_inputs5_15));
    weighted_inputs_1 w144 (.inputs(inputs16_1), .w(w5_1[16]), .wi(weighted_inputs5_16));
    weighted_inputs_1 w145 (.inputs(inputs17_1), .w(w5_1[17]), .wi(weighted_inputs5_17));
    weighted_inputs_1 w146 (.inputs(inputs18_1), .w(w5_1[18]), .wi(weighted_inputs5_18));
    weighted_inputs_1 w147 (.inputs(inputs19_1), .w(w5_1[19]), .wi(weighted_inputs5_19));
    weighted_inputs_1 w148 (.inputs(inputs20_1), .w(w5_1[20]), .wi(weighted_inputs5_20));
    weighted_inputs_1 w149 (.inputs(inputs21_1), .w(w5_1[21]), .wi(weighted_inputs5_21));
    weighted_inputs_1 w150 (.inputs(inputs22_1), .w(w5_1[22]), .wi(weighted_inputs5_22));
    weighted_inputs_1 w151 (.inputs(inputs23_1), .w(w5_1[23]), .wi(weighted_inputs5_23));
    weighted_inputs_1 w152 (.inputs(inputs24_1), .w(w5_1[24]), .wi(weighted_inputs5_24));
    weighted_inputs_1 w153 (.inputs(inputs25_1), .w(w5_1[25]), .wi(weighted_inputs5_25));
    weighted_inputs_1 w154 (.inputs(inputs26_1), .w(w5_1[26]), .wi(weighted_inputs5_26));
    weighted_inputs_1 w155 (.inputs(inputs27_1), .w(w5_1[27]), .wi(weighted_inputs5_27));
    weighted_inputs_1 w156 (.inputs(inputs28_1), .w(w5_1[28]), .wi(weighted_inputs5_28));
    weighted_inputs_1 w157 (.inputs(inputs29_1), .w(w5_1[29]), .wi(weighted_inputs5_29));
    weighted_inputs_1 w158 (.inputs(inputs30_1), .w(w5_1[30]), .wi(weighted_inputs5_30));
    weighted_inputs_1 w159 (.inputs(inputs31_1), .w(w5_1[31]), .wi(weighted_inputs5_31));
    weighted_inputs_1 w160 (.inputs(inputs0_1), .w(w6_1[0]), .wi(weighted_inputs6_0));
    weighted_inputs_1 w161 (.inputs(inputs1_1), .w(w6_1[1]), .wi(weighted_inputs6_1));
    weighted_inputs_1 w162 (.inputs(inputs2_1), .w(w6_1[2]), .wi(weighted_inputs6_2));
    weighted_inputs_1 w163 (.inputs(inputs3_1), .w(w6_1[3]), .wi(weighted_inputs6_3));
    weighted_inputs_1 w164 (.inputs(inputs4_1), .w(w6_1[4]), .wi(weighted_inputs6_4));
    weighted_inputs_1 w165 (.inputs(inputs5_1), .w(w6_1[5]), .wi(weighted_inputs6_5));
    weighted_inputs_1 w166 (.inputs(inputs6_1), .w(w6_1[6]), .wi(weighted_inputs6_6));
    weighted_inputs_1 w167 (.inputs(inputs7_1), .w(w6_1[7]), .wi(weighted_inputs6_7));
    weighted_inputs_1 w168 (.inputs(inputs8_1), .w(w6_1[8]), .wi(weighted_inputs6_8));
    weighted_inputs_1 w169 (.inputs(inputs9_1), .w(w6_1[9]), .wi(weighted_inputs6_9));
    weighted_inputs_1 w170 (.inputs(inputs10_1), .w(w6_1[10]), .wi(weighted_inputs6_10));
    weighted_inputs_1 w171 (.inputs(inputs11_1), .w(w6_1[11]), .wi(weighted_inputs6_11));
    weighted_inputs_1 w172 (.inputs(inputs12_1), .w(w6_1[12]), .wi(weighted_inputs6_12));
    weighted_inputs_1 w173 (.inputs(inputs13_1), .w(w6_1[13]), .wi(weighted_inputs6_13));
    weighted_inputs_1 w174 (.inputs(inputs14_1), .w(w6_1[14]), .wi(weighted_inputs6_14));
    weighted_inputs_1 w175 (.inputs(inputs15_1), .w(w6_1[15]), .wi(weighted_inputs6_15));
    weighted_inputs_1 w176 (.inputs(inputs16_1), .w(w6_1[16]), .wi(weighted_inputs6_16));
    weighted_inputs_1 w177 (.inputs(inputs17_1), .w(w6_1[17]), .wi(weighted_inputs6_17));
    weighted_inputs_1 w178 (.inputs(inputs18_1), .w(w6_1[18]), .wi(weighted_inputs6_18));
    weighted_inputs_1 w179 (.inputs(inputs19_1), .w(w6_1[19]), .wi(weighted_inputs6_19));
    weighted_inputs_1 w180 (.inputs(inputs20_1), .w(w6_1[20]), .wi(weighted_inputs6_20));
    weighted_inputs_1 w181 (.inputs(inputs21_1), .w(w6_1[21]), .wi(weighted_inputs6_21));
    weighted_inputs_1 w182 (.inputs(inputs22_1), .w(w6_1[22]), .wi(weighted_inputs6_22));
    weighted_inputs_1 w183 (.inputs(inputs23_1), .w(w6_1[23]), .wi(weighted_inputs6_23));
    weighted_inputs_1 w184 (.inputs(inputs24_1), .w(w6_1[24]), .wi(weighted_inputs6_24));
    weighted_inputs_1 w185 (.inputs(inputs25_1), .w(w6_1[25]), .wi(weighted_inputs6_25));
    weighted_inputs_1 w186 (.inputs(inputs26_1), .w(w6_1[26]), .wi(weighted_inputs6_26));
    weighted_inputs_1 w187 (.inputs(inputs27_1), .w(w6_1[27]), .wi(weighted_inputs6_27));
    weighted_inputs_1 w188 (.inputs(inputs28_1), .w(w6_1[28]), .wi(weighted_inputs6_28));
    weighted_inputs_1 w189 (.inputs(inputs29_1), .w(w6_1[29]), .wi(weighted_inputs6_29));
    weighted_inputs_1 w190 (.inputs(inputs30_1), .w(w6_1[30]), .wi(weighted_inputs6_30));
    weighted_inputs_1 w191 (.inputs(inputs31_1), .w(w6_1[31]), .wi(weighted_inputs6_31));
    weighted_inputs_1 w192 (.inputs(inputs0_1), .w(w7_1[0]), .wi(weighted_inputs7_0));
    weighted_inputs_1 w193 (.inputs(inputs1_1), .w(w7_1[1]), .wi(weighted_inputs7_1));
    weighted_inputs_1 w194 (.inputs(inputs2_1), .w(w7_1[2]), .wi(weighted_inputs7_2));
    weighted_inputs_1 w195 (.inputs(inputs3_1), .w(w7_1[3]), .wi(weighted_inputs7_3));
    weighted_inputs_1 w196 (.inputs(inputs4_1), .w(w7_1[4]), .wi(weighted_inputs7_4));
    weighted_inputs_1 w197 (.inputs(inputs5_1), .w(w7_1[5]), .wi(weighted_inputs7_5));
    weighted_inputs_1 w198 (.inputs(inputs6_1), .w(w7_1[6]), .wi(weighted_inputs7_6));
    weighted_inputs_1 w199 (.inputs(inputs7_1), .w(w7_1[7]), .wi(weighted_inputs7_7));
    weighted_inputs_1 w200 (.inputs(inputs8_1), .w(w7_1[8]), .wi(weighted_inputs7_8));
    weighted_inputs_1 w201 (.inputs(inputs9_1), .w(w7_1[9]), .wi(weighted_inputs7_9));
    weighted_inputs_1 w202 (.inputs(inputs10_1), .w(w7_1[10]), .wi(weighted_inputs7_10));
    weighted_inputs_1 w203 (.inputs(inputs11_1), .w(w7_1[11]), .wi(weighted_inputs7_11));
    weighted_inputs_1 w204 (.inputs(inputs12_1), .w(w7_1[12]), .wi(weighted_inputs7_12));
    weighted_inputs_1 w205 (.inputs(inputs13_1), .w(w7_1[13]), .wi(weighted_inputs7_13));
    weighted_inputs_1 w206 (.inputs(inputs14_1), .w(w7_1[14]), .wi(weighted_inputs7_14));
    weighted_inputs_1 w207 (.inputs(inputs15_1), .w(w7_1[15]), .wi(weighted_inputs7_15));
    weighted_inputs_1 w208 (.inputs(inputs16_1), .w(w7_1[16]), .wi(weighted_inputs7_16));
    weighted_inputs_1 w209 (.inputs(inputs17_1), .w(w7_1[17]), .wi(weighted_inputs7_17));
    weighted_inputs_1 w210 (.inputs(inputs18_1), .w(w7_1[18]), .wi(weighted_inputs7_18));
    weighted_inputs_1 w211 (.inputs(inputs19_1), .w(w7_1[19]), .wi(weighted_inputs7_19));
    weighted_inputs_1 w212 (.inputs(inputs20_1), .w(w7_1[20]), .wi(weighted_inputs7_20));
    weighted_inputs_1 w213 (.inputs(inputs21_1), .w(w7_1[21]), .wi(weighted_inputs7_21));
    weighted_inputs_1 w214 (.inputs(inputs22_1), .w(w7_1[22]), .wi(weighted_inputs7_22));
    weighted_inputs_1 w215 (.inputs(inputs23_1), .w(w7_1[23]), .wi(weighted_inputs7_23));
    weighted_inputs_1 w216 (.inputs(inputs24_1), .w(w7_1[24]), .wi(weighted_inputs7_24));
    weighted_inputs_1 w217 (.inputs(inputs25_1), .w(w7_1[25]), .wi(weighted_inputs7_25));
    weighted_inputs_1 w218 (.inputs(inputs26_1), .w(w7_1[26]), .wi(weighted_inputs7_26));
    weighted_inputs_1 w219 (.inputs(inputs27_1), .w(w7_1[27]), .wi(weighted_inputs7_27));
    weighted_inputs_1 w220 (.inputs(inputs28_1), .w(w7_1[28]), .wi(weighted_inputs7_28));
    weighted_inputs_1 w221 (.inputs(inputs29_1), .w(w7_1[29]), .wi(weighted_inputs7_29));
    weighted_inputs_1 w222 (.inputs(inputs30_1), .w(w7_1[30]), .wi(weighted_inputs7_30));
    weighted_inputs_1 w223 (.inputs(inputs31_1), .w(w7_1[31]), .wi(weighted_inputs7_31));
    weighted_inputs_1 w224 (.inputs(inputs0_1), .w(w8_1[0]), .wi(weighted_inputs8_0));
    weighted_inputs_1 w225 (.inputs(inputs1_1), .w(w8_1[1]), .wi(weighted_inputs8_1));
    weighted_inputs_1 w226 (.inputs(inputs2_1), .w(w8_1[2]), .wi(weighted_inputs8_2));
    weighted_inputs_1 w227 (.inputs(inputs3_1), .w(w8_1[3]), .wi(weighted_inputs8_3));
    weighted_inputs_1 w228 (.inputs(inputs4_1), .w(w8_1[4]), .wi(weighted_inputs8_4));
    weighted_inputs_1 w229 (.inputs(inputs5_1), .w(w8_1[5]), .wi(weighted_inputs8_5));
    weighted_inputs_1 w230 (.inputs(inputs6_1), .w(w8_1[6]), .wi(weighted_inputs8_6));
    weighted_inputs_1 w231 (.inputs(inputs7_1), .w(w8_1[7]), .wi(weighted_inputs8_7));
    weighted_inputs_1 w232 (.inputs(inputs8_1), .w(w8_1[8]), .wi(weighted_inputs8_8));
    weighted_inputs_1 w233 (.inputs(inputs9_1), .w(w8_1[9]), .wi(weighted_inputs8_9));
    weighted_inputs_1 w234 (.inputs(inputs10_1), .w(w8_1[10]), .wi(weighted_inputs8_10));
    weighted_inputs_1 w235 (.inputs(inputs11_1), .w(w8_1[11]), .wi(weighted_inputs8_11));
    weighted_inputs_1 w236 (.inputs(inputs12_1), .w(w8_1[12]), .wi(weighted_inputs8_12));
    weighted_inputs_1 w237 (.inputs(inputs13_1), .w(w8_1[13]), .wi(weighted_inputs8_13));
    weighted_inputs_1 w238 (.inputs(inputs14_1), .w(w8_1[14]), .wi(weighted_inputs8_14));
    weighted_inputs_1 w239 (.inputs(inputs15_1), .w(w8_1[15]), .wi(weighted_inputs8_15));
    weighted_inputs_1 w240 (.inputs(inputs16_1), .w(w8_1[16]), .wi(weighted_inputs8_16));
    weighted_inputs_1 w241 (.inputs(inputs17_1), .w(w8_1[17]), .wi(weighted_inputs8_17));
    weighted_inputs_1 w242 (.inputs(inputs18_1), .w(w8_1[18]), .wi(weighted_inputs8_18));
    weighted_inputs_1 w243 (.inputs(inputs19_1), .w(w8_1[19]), .wi(weighted_inputs8_19));
    weighted_inputs_1 w244 (.inputs(inputs20_1), .w(w8_1[20]), .wi(weighted_inputs8_20));
    weighted_inputs_1 w245 (.inputs(inputs21_1), .w(w8_1[21]), .wi(weighted_inputs8_21));
    weighted_inputs_1 w246 (.inputs(inputs22_1), .w(w8_1[22]), .wi(weighted_inputs8_22));
    weighted_inputs_1 w247 (.inputs(inputs23_1), .w(w8_1[23]), .wi(weighted_inputs8_23));
    weighted_inputs_1 w248 (.inputs(inputs24_1), .w(w8_1[24]), .wi(weighted_inputs8_24));
    weighted_inputs_1 w249 (.inputs(inputs25_1), .w(w8_1[25]), .wi(weighted_inputs8_25));
    weighted_inputs_1 w250 (.inputs(inputs26_1), .w(w8_1[26]), .wi(weighted_inputs8_26));
    weighted_inputs_1 w251 (.inputs(inputs27_1), .w(w8_1[27]), .wi(weighted_inputs8_27));
    weighted_inputs_1 w252 (.inputs(inputs28_1), .w(w8_1[28]), .wi(weighted_inputs8_28));
    weighted_inputs_1 w253 (.inputs(inputs29_1), .w(w8_1[29]), .wi(weighted_inputs8_29));
    weighted_inputs_1 w254 (.inputs(inputs30_1), .w(w8_1[30]), .wi(weighted_inputs8_30));
    weighted_inputs_1 w255 (.inputs(inputs31_1), .w(w8_1[31]), .wi(weighted_inputs8_31));
    weighted_inputs_1 w256 (.inputs(inputs0_1), .w(w9_1[0]), .wi(weighted_inputs9_0));
    weighted_inputs_1 w257 (.inputs(inputs1_1), .w(w9_1[1]), .wi(weighted_inputs9_1));
    weighted_inputs_1 w258 (.inputs(inputs2_1), .w(w9_1[2]), .wi(weighted_inputs9_2));
    weighted_inputs_1 w259 (.inputs(inputs3_1), .w(w9_1[3]), .wi(weighted_inputs9_3));
    weighted_inputs_1 w260 (.inputs(inputs4_1), .w(w9_1[4]), .wi(weighted_inputs9_4));
    weighted_inputs_1 w261 (.inputs(inputs5_1), .w(w9_1[5]), .wi(weighted_inputs9_5));
    weighted_inputs_1 w262 (.inputs(inputs6_1), .w(w9_1[6]), .wi(weighted_inputs9_6));
    weighted_inputs_1 w263 (.inputs(inputs7_1), .w(w9_1[7]), .wi(weighted_inputs9_7));
    weighted_inputs_1 w264 (.inputs(inputs8_1), .w(w9_1[8]), .wi(weighted_inputs9_8));
    weighted_inputs_1 w265 (.inputs(inputs9_1), .w(w9_1[9]), .wi(weighted_inputs9_9));
    weighted_inputs_1 w266 (.inputs(inputs10_1), .w(w9_1[10]), .wi(weighted_inputs9_10));
    weighted_inputs_1 w267 (.inputs(inputs11_1), .w(w9_1[11]), .wi(weighted_inputs9_11));
    weighted_inputs_1 w268 (.inputs(inputs12_1), .w(w9_1[12]), .wi(weighted_inputs9_12));
    weighted_inputs_1 w269 (.inputs(inputs13_1), .w(w9_1[13]), .wi(weighted_inputs9_13));
    weighted_inputs_1 w270 (.inputs(inputs14_1), .w(w9_1[14]), .wi(weighted_inputs9_14));
    weighted_inputs_1 w271 (.inputs(inputs15_1), .w(w9_1[15]), .wi(weighted_inputs9_15));
    weighted_inputs_1 w272 (.inputs(inputs16_1), .w(w9_1[16]), .wi(weighted_inputs9_16));
    weighted_inputs_1 w273 (.inputs(inputs17_1), .w(w9_1[17]), .wi(weighted_inputs9_17));
    weighted_inputs_1 w274 (.inputs(inputs18_1), .w(w9_1[18]), .wi(weighted_inputs9_18));
    weighted_inputs_1 w275 (.inputs(inputs19_1), .w(w9_1[19]), .wi(weighted_inputs9_19));
    weighted_inputs_1 w276 (.inputs(inputs20_1), .w(w9_1[20]), .wi(weighted_inputs9_20));
    weighted_inputs_1 w277 (.inputs(inputs21_1), .w(w9_1[21]), .wi(weighted_inputs9_21));
    weighted_inputs_1 w278 (.inputs(inputs22_1), .w(w9_1[22]), .wi(weighted_inputs9_22));
    weighted_inputs_1 w279 (.inputs(inputs23_1), .w(w9_1[23]), .wi(weighted_inputs9_23));
    weighted_inputs_1 w280 (.inputs(inputs24_1), .w(w9_1[24]), .wi(weighted_inputs9_24));
    weighted_inputs_1 w281 (.inputs(inputs25_1), .w(w9_1[25]), .wi(weighted_inputs9_25));
    weighted_inputs_1 w282 (.inputs(inputs26_1), .w(w9_1[26]), .wi(weighted_inputs9_26));
    weighted_inputs_1 w283 (.inputs(inputs27_1), .w(w9_1[27]), .wi(weighted_inputs9_27));
    weighted_inputs_1 w284 (.inputs(inputs28_1), .w(w9_1[28]), .wi(weighted_inputs9_28));
    weighted_inputs_1 w285 (.inputs(inputs29_1), .w(w9_1[29]), .wi(weighted_inputs9_29));
    weighted_inputs_1 w286 (.inputs(inputs30_1), .w(w9_1[30]), .wi(weighted_inputs9_30));
    weighted_inputs_1 w287 (.inputs(inputs31_1), .w(w9_1[31]), .wi(weighted_inputs9_31));
    weighted_inputs_1 w288 (.inputs(inputs0_1), .w(w10_1[0]), .wi(weighted_inputs10_0));
    weighted_inputs_1 w289 (.inputs(inputs1_1), .w(w10_1[1]), .wi(weighted_inputs10_1));
    weighted_inputs_1 w290 (.inputs(inputs2_1), .w(w10_1[2]), .wi(weighted_inputs10_2));
    weighted_inputs_1 w291 (.inputs(inputs3_1), .w(w10_1[3]), .wi(weighted_inputs10_3));
    weighted_inputs_1 w292 (.inputs(inputs4_1), .w(w10_1[4]), .wi(weighted_inputs10_4));
    weighted_inputs_1 w293 (.inputs(inputs5_1), .w(w10_1[5]), .wi(weighted_inputs10_5));
    weighted_inputs_1 w294 (.inputs(inputs6_1), .w(w10_1[6]), .wi(weighted_inputs10_6));
    weighted_inputs_1 w295 (.inputs(inputs7_1), .w(w10_1[7]), .wi(weighted_inputs10_7));
    weighted_inputs_1 w296 (.inputs(inputs8_1), .w(w10_1[8]), .wi(weighted_inputs10_8));
    weighted_inputs_1 w297 (.inputs(inputs9_1), .w(w10_1[9]), .wi(weighted_inputs10_9));
    weighted_inputs_1 w298 (.inputs(inputs10_1), .w(w10_1[10]), .wi(weighted_inputs10_10));
    weighted_inputs_1 w299 (.inputs(inputs11_1), .w(w10_1[11]), .wi(weighted_inputs10_11));
    weighted_inputs_1 w300 (.inputs(inputs12_1), .w(w10_1[12]), .wi(weighted_inputs10_12));
    weighted_inputs_1 w301 (.inputs(inputs13_1), .w(w10_1[13]), .wi(weighted_inputs10_13));
    weighted_inputs_1 w302 (.inputs(inputs14_1), .w(w10_1[14]), .wi(weighted_inputs10_14));
    weighted_inputs_1 w303 (.inputs(inputs15_1), .w(w10_1[15]), .wi(weighted_inputs10_15));
    weighted_inputs_1 w304 (.inputs(inputs16_1), .w(w10_1[16]), .wi(weighted_inputs10_16));
    weighted_inputs_1 w305 (.inputs(inputs17_1), .w(w10_1[17]), .wi(weighted_inputs10_17));
    weighted_inputs_1 w306 (.inputs(inputs18_1), .w(w10_1[18]), .wi(weighted_inputs10_18));
    weighted_inputs_1 w307 (.inputs(inputs19_1), .w(w10_1[19]), .wi(weighted_inputs10_19));
    weighted_inputs_1 w308 (.inputs(inputs20_1), .w(w10_1[20]), .wi(weighted_inputs10_20));
    weighted_inputs_1 w309 (.inputs(inputs21_1), .w(w10_1[21]), .wi(weighted_inputs10_21));
    weighted_inputs_1 w310 (.inputs(inputs22_1), .w(w10_1[22]), .wi(weighted_inputs10_22));
    weighted_inputs_1 w311 (.inputs(inputs23_1), .w(w10_1[23]), .wi(weighted_inputs10_23));
    weighted_inputs_1 w312 (.inputs(inputs24_1), .w(w10_1[24]), .wi(weighted_inputs10_24));
    weighted_inputs_1 w313 (.inputs(inputs25_1), .w(w10_1[25]), .wi(weighted_inputs10_25));
    weighted_inputs_1 w314 (.inputs(inputs26_1), .w(w10_1[26]), .wi(weighted_inputs10_26));
    weighted_inputs_1 w315 (.inputs(inputs27_1), .w(w10_1[27]), .wi(weighted_inputs10_27));
    weighted_inputs_1 w316 (.inputs(inputs28_1), .w(w10_1[28]), .wi(weighted_inputs10_28));
    weighted_inputs_1 w317 (.inputs(inputs29_1), .w(w10_1[29]), .wi(weighted_inputs10_29));
    weighted_inputs_1 w318 (.inputs(inputs30_1), .w(w10_1[30]), .wi(weighted_inputs10_30));
    weighted_inputs_1 w319 (.inputs(inputs31_1), .w(w10_1[31]), .wi(weighted_inputs10_31));
    weighted_inputs_1 w320 (.inputs(inputs0_1), .w(w11_1[0]), .wi(weighted_inputs11_0));
    weighted_inputs_1 w321 (.inputs(inputs1_1), .w(w11_1[1]), .wi(weighted_inputs11_1));
    weighted_inputs_1 w322 (.inputs(inputs2_1), .w(w11_1[2]), .wi(weighted_inputs11_2));
    weighted_inputs_1 w323 (.inputs(inputs3_1), .w(w11_1[3]), .wi(weighted_inputs11_3));
    weighted_inputs_1 w324 (.inputs(inputs4_1), .w(w11_1[4]), .wi(weighted_inputs11_4));
    weighted_inputs_1 w325 (.inputs(inputs5_1), .w(w11_1[5]), .wi(weighted_inputs11_5));
    weighted_inputs_1 w326 (.inputs(inputs6_1), .w(w11_1[6]), .wi(weighted_inputs11_6));
    weighted_inputs_1 w327 (.inputs(inputs7_1), .w(w11_1[7]), .wi(weighted_inputs11_7));
    weighted_inputs_1 w328 (.inputs(inputs8_1), .w(w11_1[8]), .wi(weighted_inputs11_8));
    weighted_inputs_1 w329 (.inputs(inputs9_1), .w(w11_1[9]), .wi(weighted_inputs11_9));
    weighted_inputs_1 w330 (.inputs(inputs10_1), .w(w11_1[10]), .wi(weighted_inputs11_10));
    weighted_inputs_1 w331 (.inputs(inputs11_1), .w(w11_1[11]), .wi(weighted_inputs11_11));
    weighted_inputs_1 w332 (.inputs(inputs12_1), .w(w11_1[12]), .wi(weighted_inputs11_12));
    weighted_inputs_1 w333 (.inputs(inputs13_1), .w(w11_1[13]), .wi(weighted_inputs11_13));
    weighted_inputs_1 w334 (.inputs(inputs14_1), .w(w11_1[14]), .wi(weighted_inputs11_14));
    weighted_inputs_1 w335 (.inputs(inputs15_1), .w(w11_1[15]), .wi(weighted_inputs11_15));
    weighted_inputs_1 w336 (.inputs(inputs16_1), .w(w11_1[16]), .wi(weighted_inputs11_16));
    weighted_inputs_1 w337 (.inputs(inputs17_1), .w(w11_1[17]), .wi(weighted_inputs11_17));
    weighted_inputs_1 w338 (.inputs(inputs18_1), .w(w11_1[18]), .wi(weighted_inputs11_18));
    weighted_inputs_1 w339 (.inputs(inputs19_1), .w(w11_1[19]), .wi(weighted_inputs11_19));
    weighted_inputs_1 w340 (.inputs(inputs20_1), .w(w11_1[20]), .wi(weighted_inputs11_20));
    weighted_inputs_1 w341 (.inputs(inputs21_1), .w(w11_1[21]), .wi(weighted_inputs11_21));
    weighted_inputs_1 w342 (.inputs(inputs22_1), .w(w11_1[22]), .wi(weighted_inputs11_22));
    weighted_inputs_1 w343 (.inputs(inputs23_1), .w(w11_1[23]), .wi(weighted_inputs11_23));
    weighted_inputs_1 w344 (.inputs(inputs24_1), .w(w11_1[24]), .wi(weighted_inputs11_24));
    weighted_inputs_1 w345 (.inputs(inputs25_1), .w(w11_1[25]), .wi(weighted_inputs11_25));
    weighted_inputs_1 w346 (.inputs(inputs26_1), .w(w11_1[26]), .wi(weighted_inputs11_26));
    weighted_inputs_1 w347 (.inputs(inputs27_1), .w(w11_1[27]), .wi(weighted_inputs11_27));
    weighted_inputs_1 w348 (.inputs(inputs28_1), .w(w11_1[28]), .wi(weighted_inputs11_28));
    weighted_inputs_1 w349 (.inputs(inputs29_1), .w(w11_1[29]), .wi(weighted_inputs11_29));
    weighted_inputs_1 w350 (.inputs(inputs30_1), .w(w11_1[30]), .wi(weighted_inputs11_30));
    weighted_inputs_1 w351 (.inputs(inputs31_1), .w(w11_1[31]), .wi(weighted_inputs11_31));
    weighted_inputs_1 w352 (.inputs(inputs0_1), .w(w12_1[0]), .wi(weighted_inputs12_0));
    weighted_inputs_1 w353 (.inputs(inputs1_1), .w(w12_1[1]), .wi(weighted_inputs12_1));
    weighted_inputs_1 w354 (.inputs(inputs2_1), .w(w12_1[2]), .wi(weighted_inputs12_2));
    weighted_inputs_1 w355 (.inputs(inputs3_1), .w(w12_1[3]), .wi(weighted_inputs12_3));
    weighted_inputs_1 w356 (.inputs(inputs4_1), .w(w12_1[4]), .wi(weighted_inputs12_4));
    weighted_inputs_1 w357 (.inputs(inputs5_1), .w(w12_1[5]), .wi(weighted_inputs12_5));
    weighted_inputs_1 w358 (.inputs(inputs6_1), .w(w12_1[6]), .wi(weighted_inputs12_6));
    weighted_inputs_1 w359 (.inputs(inputs7_1), .w(w12_1[7]), .wi(weighted_inputs12_7));
    weighted_inputs_1 w360 (.inputs(inputs8_1), .w(w12_1[8]), .wi(weighted_inputs12_8));
    weighted_inputs_1 w361 (.inputs(inputs9_1), .w(w12_1[9]), .wi(weighted_inputs12_9));
    weighted_inputs_1 w362 (.inputs(inputs10_1), .w(w12_1[10]), .wi(weighted_inputs12_10));
    weighted_inputs_1 w363 (.inputs(inputs11_1), .w(w12_1[11]), .wi(weighted_inputs12_11));
    weighted_inputs_1 w364 (.inputs(inputs12_1), .w(w12_1[12]), .wi(weighted_inputs12_12));
    weighted_inputs_1 w365 (.inputs(inputs13_1), .w(w12_1[13]), .wi(weighted_inputs12_13));
    weighted_inputs_1 w366 (.inputs(inputs14_1), .w(w12_1[14]), .wi(weighted_inputs12_14));
    weighted_inputs_1 w367 (.inputs(inputs15_1), .w(w12_1[15]), .wi(weighted_inputs12_15));
    weighted_inputs_1 w368 (.inputs(inputs16_1), .w(w12_1[16]), .wi(weighted_inputs12_16));
    weighted_inputs_1 w369 (.inputs(inputs17_1), .w(w12_1[17]), .wi(weighted_inputs12_17));
    weighted_inputs_1 w370 (.inputs(inputs18_1), .w(w12_1[18]), .wi(weighted_inputs12_18));
    weighted_inputs_1 w371 (.inputs(inputs19_1), .w(w12_1[19]), .wi(weighted_inputs12_19));
    weighted_inputs_1 w372 (.inputs(inputs20_1), .w(w12_1[20]), .wi(weighted_inputs12_20));
    weighted_inputs_1 w373 (.inputs(inputs21_1), .w(w12_1[21]), .wi(weighted_inputs12_21));
    weighted_inputs_1 w374 (.inputs(inputs22_1), .w(w12_1[22]), .wi(weighted_inputs12_22));
    weighted_inputs_1 w375 (.inputs(inputs23_1), .w(w12_1[23]), .wi(weighted_inputs12_23));
    weighted_inputs_1 w376 (.inputs(inputs24_1), .w(w12_1[24]), .wi(weighted_inputs12_24));
    weighted_inputs_1 w377 (.inputs(inputs25_1), .w(w12_1[25]), .wi(weighted_inputs12_25));
    weighted_inputs_1 w378 (.inputs(inputs26_1), .w(w12_1[26]), .wi(weighted_inputs12_26));
    weighted_inputs_1 w379 (.inputs(inputs27_1), .w(w12_1[27]), .wi(weighted_inputs12_27));
    weighted_inputs_1 w380 (.inputs(inputs28_1), .w(w12_1[28]), .wi(weighted_inputs12_28));
    weighted_inputs_1 w381 (.inputs(inputs29_1), .w(w12_1[29]), .wi(weighted_inputs12_29));
    weighted_inputs_1 w382 (.inputs(inputs30_1), .w(w12_1[30]), .wi(weighted_inputs12_30));
    weighted_inputs_1 w383 (.inputs(inputs31_1), .w(w12_1[31]), .wi(weighted_inputs12_31));
    weighted_inputs_1 w384 (.inputs(inputs0_1), .w(w13_1[0]), .wi(weighted_inputs13_0));
    weighted_inputs_1 w385 (.inputs(inputs1_1), .w(w13_1[1]), .wi(weighted_inputs13_1));
    weighted_inputs_1 w386 (.inputs(inputs2_1), .w(w13_1[2]), .wi(weighted_inputs13_2));
    weighted_inputs_1 w387 (.inputs(inputs3_1), .w(w13_1[3]), .wi(weighted_inputs13_3));
    weighted_inputs_1 w388 (.inputs(inputs4_1), .w(w13_1[4]), .wi(weighted_inputs13_4));
    weighted_inputs_1 w389 (.inputs(inputs5_1), .w(w13_1[5]), .wi(weighted_inputs13_5));
    weighted_inputs_1 w390 (.inputs(inputs6_1), .w(w13_1[6]), .wi(weighted_inputs13_6));
    weighted_inputs_1 w391 (.inputs(inputs7_1), .w(w13_1[7]), .wi(weighted_inputs13_7));
    weighted_inputs_1 w392 (.inputs(inputs8_1), .w(w13_1[8]), .wi(weighted_inputs13_8));
    weighted_inputs_1 w393 (.inputs(inputs9_1), .w(w13_1[9]), .wi(weighted_inputs13_9));
    weighted_inputs_1 w394 (.inputs(inputs10_1), .w(w13_1[10]), .wi(weighted_inputs13_10));
    weighted_inputs_1 w395 (.inputs(inputs11_1), .w(w13_1[11]), .wi(weighted_inputs13_11));
    weighted_inputs_1 w396 (.inputs(inputs12_1), .w(w13_1[12]), .wi(weighted_inputs13_12));
    weighted_inputs_1 w397 (.inputs(inputs13_1), .w(w13_1[13]), .wi(weighted_inputs13_13));
    weighted_inputs_1 w398 (.inputs(inputs14_1), .w(w13_1[14]), .wi(weighted_inputs13_14));
    weighted_inputs_1 w399 (.inputs(inputs15_1), .w(w13_1[15]), .wi(weighted_inputs13_15));
    weighted_inputs_1 w400 (.inputs(inputs16_1), .w(w13_1[16]), .wi(weighted_inputs13_16));
    weighted_inputs_1 w401 (.inputs(inputs17_1), .w(w13_1[17]), .wi(weighted_inputs13_17));
    weighted_inputs_1 w402 (.inputs(inputs18_1), .w(w13_1[18]), .wi(weighted_inputs13_18));
    weighted_inputs_1 w403 (.inputs(inputs19_1), .w(w13_1[19]), .wi(weighted_inputs13_19));
    weighted_inputs_1 w404 (.inputs(inputs20_1), .w(w13_1[20]), .wi(weighted_inputs13_20));
    weighted_inputs_1 w405 (.inputs(inputs21_1), .w(w13_1[21]), .wi(weighted_inputs13_21));
    weighted_inputs_1 w406 (.inputs(inputs22_1), .w(w13_1[22]), .wi(weighted_inputs13_22));
    weighted_inputs_1 w407 (.inputs(inputs23_1), .w(w13_1[23]), .wi(weighted_inputs13_23));
    weighted_inputs_1 w408 (.inputs(inputs24_1), .w(w13_1[24]), .wi(weighted_inputs13_24));
    weighted_inputs_1 w409 (.inputs(inputs25_1), .w(w13_1[25]), .wi(weighted_inputs13_25));
    weighted_inputs_1 w410 (.inputs(inputs26_1), .w(w13_1[26]), .wi(weighted_inputs13_26));
    weighted_inputs_1 w411 (.inputs(inputs27_1), .w(w13_1[27]), .wi(weighted_inputs13_27));
    weighted_inputs_1 w412 (.inputs(inputs28_1), .w(w13_1[28]), .wi(weighted_inputs13_28));
    weighted_inputs_1 w413 (.inputs(inputs29_1), .w(w13_1[29]), .wi(weighted_inputs13_29));
    weighted_inputs_1 w414 (.inputs(inputs30_1), .w(w13_1[30]), .wi(weighted_inputs13_30));
    weighted_inputs_1 w415 (.inputs(inputs31_1), .w(w13_1[31]), .wi(weighted_inputs13_31));
    weighted_inputs_1 w416 (.inputs(inputs0_1), .w(w14_1[0]), .wi(weighted_inputs14_0));
    weighted_inputs_1 w417 (.inputs(inputs1_1), .w(w14_1[1]), .wi(weighted_inputs14_1));
    weighted_inputs_1 w418 (.inputs(inputs2_1), .w(w14_1[2]), .wi(weighted_inputs14_2));
    weighted_inputs_1 w419 (.inputs(inputs3_1), .w(w14_1[3]), .wi(weighted_inputs14_3));
    weighted_inputs_1 w420 (.inputs(inputs4_1), .w(w14_1[4]), .wi(weighted_inputs14_4));
    weighted_inputs_1 w421 (.inputs(inputs5_1), .w(w14_1[5]), .wi(weighted_inputs14_5));
    weighted_inputs_1 w422 (.inputs(inputs6_1), .w(w14_1[6]), .wi(weighted_inputs14_6));
    weighted_inputs_1 w423 (.inputs(inputs7_1), .w(w14_1[7]), .wi(weighted_inputs14_7));
    weighted_inputs_1 w424 (.inputs(inputs8_1), .w(w14_1[8]), .wi(weighted_inputs14_8));
    weighted_inputs_1 w425 (.inputs(inputs9_1), .w(w14_1[9]), .wi(weighted_inputs14_9));
    weighted_inputs_1 w426 (.inputs(inputs10_1), .w(w14_1[10]), .wi(weighted_inputs14_10));
    weighted_inputs_1 w427 (.inputs(inputs11_1), .w(w14_1[11]), .wi(weighted_inputs14_11));
    weighted_inputs_1 w428 (.inputs(inputs12_1), .w(w14_1[12]), .wi(weighted_inputs14_12));
    weighted_inputs_1 w429 (.inputs(inputs13_1), .w(w14_1[13]), .wi(weighted_inputs14_13));
    weighted_inputs_1 w430 (.inputs(inputs14_1), .w(w14_1[14]), .wi(weighted_inputs14_14));
    weighted_inputs_1 w431 (.inputs(inputs15_1), .w(w14_1[15]), .wi(weighted_inputs14_15));
    weighted_inputs_1 w432 (.inputs(inputs16_1), .w(w14_1[16]), .wi(weighted_inputs14_16));
    weighted_inputs_1 w433 (.inputs(inputs17_1), .w(w14_1[17]), .wi(weighted_inputs14_17));
    weighted_inputs_1 w434 (.inputs(inputs18_1), .w(w14_1[18]), .wi(weighted_inputs14_18));
    weighted_inputs_1 w435 (.inputs(inputs19_1), .w(w14_1[19]), .wi(weighted_inputs14_19));
    weighted_inputs_1 w436 (.inputs(inputs20_1), .w(w14_1[20]), .wi(weighted_inputs14_20));
    weighted_inputs_1 w437 (.inputs(inputs21_1), .w(w14_1[21]), .wi(weighted_inputs14_21));
    weighted_inputs_1 w438 (.inputs(inputs22_1), .w(w14_1[22]), .wi(weighted_inputs14_22));
    weighted_inputs_1 w439 (.inputs(inputs23_1), .w(w14_1[23]), .wi(weighted_inputs14_23));
    weighted_inputs_1 w440 (.inputs(inputs24_1), .w(w14_1[24]), .wi(weighted_inputs14_24));
    weighted_inputs_1 w441 (.inputs(inputs25_1), .w(w14_1[25]), .wi(weighted_inputs14_25));
    weighted_inputs_1 w442 (.inputs(inputs26_1), .w(w14_1[26]), .wi(weighted_inputs14_26));
    weighted_inputs_1 w443 (.inputs(inputs27_1), .w(w14_1[27]), .wi(weighted_inputs14_27));
    weighted_inputs_1 w444 (.inputs(inputs28_1), .w(w14_1[28]), .wi(weighted_inputs14_28));
    weighted_inputs_1 w445 (.inputs(inputs29_1), .w(w14_1[29]), .wi(weighted_inputs14_29));
    weighted_inputs_1 w446 (.inputs(inputs30_1), .w(w14_1[30]), .wi(weighted_inputs14_30));
    weighted_inputs_1 w447 (.inputs(inputs31_1), .w(w14_1[31]), .wi(weighted_inputs14_31));
    weighted_inputs_1 w448 (.inputs(inputs0_1), .w(w15_1[0]), .wi(weighted_inputs15_0));
    weighted_inputs_1 w449 (.inputs(inputs1_1), .w(w15_1[1]), .wi(weighted_inputs15_1));
    weighted_inputs_1 w450 (.inputs(inputs2_1), .w(w15_1[2]), .wi(weighted_inputs15_2));
    weighted_inputs_1 w451 (.inputs(inputs3_1), .w(w15_1[3]), .wi(weighted_inputs15_3));
    weighted_inputs_1 w452 (.inputs(inputs4_1), .w(w15_1[4]), .wi(weighted_inputs15_4));
    weighted_inputs_1 w453 (.inputs(inputs5_1), .w(w15_1[5]), .wi(weighted_inputs15_5));
    weighted_inputs_1 w454 (.inputs(inputs6_1), .w(w15_1[6]), .wi(weighted_inputs15_6));
    weighted_inputs_1 w455 (.inputs(inputs7_1), .w(w15_1[7]), .wi(weighted_inputs15_7));
    weighted_inputs_1 w456 (.inputs(inputs8_1), .w(w15_1[8]), .wi(weighted_inputs15_8));
    weighted_inputs_1 w457 (.inputs(inputs9_1), .w(w15_1[9]), .wi(weighted_inputs15_9));
    weighted_inputs_1 w458 (.inputs(inputs10_1), .w(w15_1[10]), .wi(weighted_inputs15_10));
    weighted_inputs_1 w459 (.inputs(inputs11_1), .w(w15_1[11]), .wi(weighted_inputs15_11));
    weighted_inputs_1 w460 (.inputs(inputs12_1), .w(w15_1[12]), .wi(weighted_inputs15_12));
    weighted_inputs_1 w461 (.inputs(inputs13_1), .w(w15_1[13]), .wi(weighted_inputs15_13));
    weighted_inputs_1 w462 (.inputs(inputs14_1), .w(w15_1[14]), .wi(weighted_inputs15_14));
    weighted_inputs_1 w463 (.inputs(inputs15_1), .w(w15_1[15]), .wi(weighted_inputs15_15));
    weighted_inputs_1 w464 (.inputs(inputs16_1), .w(w15_1[16]), .wi(weighted_inputs15_16));
    weighted_inputs_1 w465 (.inputs(inputs17_1), .w(w15_1[17]), .wi(weighted_inputs15_17));
    weighted_inputs_1 w466 (.inputs(inputs18_1), .w(w15_1[18]), .wi(weighted_inputs15_18));
    weighted_inputs_1 w467 (.inputs(inputs19_1), .w(w15_1[19]), .wi(weighted_inputs15_19));
    weighted_inputs_1 w468 (.inputs(inputs20_1), .w(w15_1[20]), .wi(weighted_inputs15_20));
    weighted_inputs_1 w469 (.inputs(inputs21_1), .w(w15_1[21]), .wi(weighted_inputs15_21));
    weighted_inputs_1 w470 (.inputs(inputs22_1), .w(w15_1[22]), .wi(weighted_inputs15_22));
    weighted_inputs_1 w471 (.inputs(inputs23_1), .w(w15_1[23]), .wi(weighted_inputs15_23));
    weighted_inputs_1 w472 (.inputs(inputs24_1), .w(w15_1[24]), .wi(weighted_inputs15_24));
    weighted_inputs_1 w473 (.inputs(inputs25_1), .w(w15_1[25]), .wi(weighted_inputs15_25));
    weighted_inputs_1 w474 (.inputs(inputs26_1), .w(w15_1[26]), .wi(weighted_inputs15_26));
    weighted_inputs_1 w475 (.inputs(inputs27_1), .w(w15_1[27]), .wi(weighted_inputs15_27));
    weighted_inputs_1 w476 (.inputs(inputs28_1), .w(w15_1[28]), .wi(weighted_inputs15_28));
    weighted_inputs_1 w477 (.inputs(inputs29_1), .w(w15_1[29]), .wi(weighted_inputs15_29));
    weighted_inputs_1 w478 (.inputs(inputs30_1), .w(w15_1[30]), .wi(weighted_inputs15_30));
    weighted_inputs_1 w479 (.inputs(inputs31_1), .w(w15_1[31]), .wi(weighted_inputs15_31));
    weighted_inputs_1 w480 (.inputs(inputs0_1), .w(w16_1[0]), .wi(weighted_inputs16_0));
    weighted_inputs_1 w481 (.inputs(inputs1_1), .w(w16_1[1]), .wi(weighted_inputs16_1));
    weighted_inputs_1 w482 (.inputs(inputs2_1), .w(w16_1[2]), .wi(weighted_inputs16_2));
    weighted_inputs_1 w483 (.inputs(inputs3_1), .w(w16_1[3]), .wi(weighted_inputs16_3));
    weighted_inputs_1 w484 (.inputs(inputs4_1), .w(w16_1[4]), .wi(weighted_inputs16_4));
    weighted_inputs_1 w485 (.inputs(inputs5_1), .w(w16_1[5]), .wi(weighted_inputs16_5));
    weighted_inputs_1 w486 (.inputs(inputs6_1), .w(w16_1[6]), .wi(weighted_inputs16_6));
    weighted_inputs_1 w487 (.inputs(inputs7_1), .w(w16_1[7]), .wi(weighted_inputs16_7));
    weighted_inputs_1 w488 (.inputs(inputs8_1), .w(w16_1[8]), .wi(weighted_inputs16_8));
    weighted_inputs_1 w489 (.inputs(inputs9_1), .w(w16_1[9]), .wi(weighted_inputs16_9));
    weighted_inputs_1 w490 (.inputs(inputs10_1), .w(w16_1[10]), .wi(weighted_inputs16_10));
    weighted_inputs_1 w491 (.inputs(inputs11_1), .w(w16_1[11]), .wi(weighted_inputs16_11));
    weighted_inputs_1 w492 (.inputs(inputs12_1), .w(w16_1[12]), .wi(weighted_inputs16_12));
    weighted_inputs_1 w493 (.inputs(inputs13_1), .w(w16_1[13]), .wi(weighted_inputs16_13));
    weighted_inputs_1 w494 (.inputs(inputs14_1), .w(w16_1[14]), .wi(weighted_inputs16_14));
    weighted_inputs_1 w495 (.inputs(inputs15_1), .w(w16_1[15]), .wi(weighted_inputs16_15));
    weighted_inputs_1 w496 (.inputs(inputs16_1), .w(w16_1[16]), .wi(weighted_inputs16_16));
    weighted_inputs_1 w497 (.inputs(inputs17_1), .w(w16_1[17]), .wi(weighted_inputs16_17));
    weighted_inputs_1 w498 (.inputs(inputs18_1), .w(w16_1[18]), .wi(weighted_inputs16_18));
    weighted_inputs_1 w499 (.inputs(inputs19_1), .w(w16_1[19]), .wi(weighted_inputs16_19));
    weighted_inputs_1 w500 (.inputs(inputs20_1), .w(w16_1[20]), .wi(weighted_inputs16_20));
    weighted_inputs_1 w501 (.inputs(inputs21_1), .w(w16_1[21]), .wi(weighted_inputs16_21));
    weighted_inputs_1 w502 (.inputs(inputs22_1), .w(w16_1[22]), .wi(weighted_inputs16_22));
    weighted_inputs_1 w503 (.inputs(inputs23_1), .w(w16_1[23]), .wi(weighted_inputs16_23));
    weighted_inputs_1 w504 (.inputs(inputs24_1), .w(w16_1[24]), .wi(weighted_inputs16_24));
    weighted_inputs_1 w505 (.inputs(inputs25_1), .w(w16_1[25]), .wi(weighted_inputs16_25));
    weighted_inputs_1 w506 (.inputs(inputs26_1), .w(w16_1[26]), .wi(weighted_inputs16_26));
    weighted_inputs_1 w507 (.inputs(inputs27_1), .w(w16_1[27]), .wi(weighted_inputs16_27));
    weighted_inputs_1 w508 (.inputs(inputs28_1), .w(w16_1[28]), .wi(weighted_inputs16_28));
    weighted_inputs_1 w509 (.inputs(inputs29_1), .w(w16_1[29]), .wi(weighted_inputs16_29));
    weighted_inputs_1 w510 (.inputs(inputs30_1), .w(w16_1[30]), .wi(weighted_inputs16_30));
    weighted_inputs_1 w511 (.inputs(inputs31_1), .w(w16_1[31]), .wi(weighted_inputs16_31));
    adder_tree_1 add0(
        .clk(clk), 
        .in0(weighted_inputs1_0),
        .in1(weighted_inputs1_1),
        .in2(weighted_inputs1_2),
        .in3(weighted_inputs1_3),
        .in4(weighted_inputs1_4),
        .in5(weighted_inputs1_5),
        .in6(weighted_inputs1_6),
        .in7(weighted_inputs1_7),
        .in8(weighted_inputs1_8),
        .in9(weighted_inputs1_9),
        .in10(weighted_inputs1_10),
        .in11(weighted_inputs1_11),
        .in12(weighted_inputs1_12),
        .in13(weighted_inputs1_13),
        .in14(weighted_inputs1_14),
        .in15(weighted_inputs1_15),
        .in16(weighted_inputs1_16),
        .in17(weighted_inputs1_17),
        .in18(weighted_inputs1_18),
        .in19(weighted_inputs1_19),
        .in20(weighted_inputs1_20),
        .in21(weighted_inputs1_21),
        .in22(weighted_inputs1_22),
        .in23(weighted_inputs1_23),
        .in24(weighted_inputs1_24),
        .in25(weighted_inputs1_25),
        .in26(weighted_inputs1_26),
        .in27(weighted_inputs1_27),
        .in28(weighted_inputs1_28),
        .in29(weighted_inputs1_29),
        .in30(weighted_inputs1_30),
        .in31(weighted_inputs1_31),
        .sum(sum1[0])
    );
    adder_tree_1 add1(
        .clk(clk), 
        .in0(weighted_inputs2_0),
        .in1(weighted_inputs2_1),
        .in2(weighted_inputs2_2),
        .in3(weighted_inputs2_3),
        .in4(weighted_inputs2_4),
        .in5(weighted_inputs2_5),
        .in6(weighted_inputs2_6),
        .in7(weighted_inputs2_7),
        .in8(weighted_inputs2_8),
        .in9(weighted_inputs2_9),
        .in10(weighted_inputs2_10),
        .in11(weighted_inputs2_11),
        .in12(weighted_inputs2_12),
        .in13(weighted_inputs2_13),
        .in14(weighted_inputs2_14),
        .in15(weighted_inputs2_15),
        .in16(weighted_inputs2_16),
        .in17(weighted_inputs2_17),
        .in18(weighted_inputs2_18),
        .in19(weighted_inputs2_19),
        .in20(weighted_inputs2_20),
        .in21(weighted_inputs2_21),
        .in22(weighted_inputs2_22),
        .in23(weighted_inputs2_23),
        .in24(weighted_inputs2_24),
        .in25(weighted_inputs2_25),
        .in26(weighted_inputs2_26),
        .in27(weighted_inputs2_27),
        .in28(weighted_inputs2_28),
        .in29(weighted_inputs2_29),
        .in30(weighted_inputs2_30),
        .in31(weighted_inputs2_31),
        .sum(sum1[1])
    );
    adder_tree_1 add2(
        .clk(clk), 
        .in0(weighted_inputs3_0),
        .in1(weighted_inputs3_1),
        .in2(weighted_inputs3_2),
        .in3(weighted_inputs3_3),
        .in4(weighted_inputs3_4),
        .in5(weighted_inputs3_5),
        .in6(weighted_inputs3_6),
        .in7(weighted_inputs3_7),
        .in8(weighted_inputs3_8),
        .in9(weighted_inputs3_9),
        .in10(weighted_inputs3_10),
        .in11(weighted_inputs3_11),
        .in12(weighted_inputs3_12),
        .in13(weighted_inputs3_13),
        .in14(weighted_inputs3_14),
        .in15(weighted_inputs3_15),
        .in16(weighted_inputs3_16),
        .in17(weighted_inputs3_17),
        .in18(weighted_inputs3_18),
        .in19(weighted_inputs3_19),
        .in20(weighted_inputs3_20),
        .in21(weighted_inputs3_21),
        .in22(weighted_inputs3_22),
        .in23(weighted_inputs3_23),
        .in24(weighted_inputs3_24),
        .in25(weighted_inputs3_25),
        .in26(weighted_inputs3_26),
        .in27(weighted_inputs3_27),
        .in28(weighted_inputs3_28),
        .in29(weighted_inputs3_29),
        .in30(weighted_inputs3_30),
        .in31(weighted_inputs3_31),
        .sum(sum1[2])
    );
    adder_tree_1 add3(
        .clk(clk), 
        .in0(weighted_inputs4_0),
        .in1(weighted_inputs4_1),
        .in2(weighted_inputs4_2),
        .in3(weighted_inputs4_3),
        .in4(weighted_inputs4_4),
        .in5(weighted_inputs4_5),
        .in6(weighted_inputs4_6),
        .in7(weighted_inputs4_7),
        .in8(weighted_inputs4_8),
        .in9(weighted_inputs4_9),
        .in10(weighted_inputs4_10),
        .in11(weighted_inputs4_11),
        .in12(weighted_inputs4_12),
        .in13(weighted_inputs4_13),
        .in14(weighted_inputs4_14),
        .in15(weighted_inputs4_15),
        .in16(weighted_inputs4_16),
        .in17(weighted_inputs4_17),
        .in18(weighted_inputs4_18),
        .in19(weighted_inputs4_19),
        .in20(weighted_inputs4_20),
        .in21(weighted_inputs4_21),
        .in22(weighted_inputs4_22),
        .in23(weighted_inputs4_23),
        .in24(weighted_inputs4_24),
        .in25(weighted_inputs4_25),
        .in26(weighted_inputs4_26),
        .in27(weighted_inputs4_27),
        .in28(weighted_inputs4_28),
        .in29(weighted_inputs4_29),
        .in30(weighted_inputs4_30),
        .in31(weighted_inputs4_31),
        .sum(sum1[3])
    );
    adder_tree_1 add4(
        .clk(clk), 
        .in0(weighted_inputs5_0),
        .in1(weighted_inputs5_1),
        .in2(weighted_inputs5_2),
        .in3(weighted_inputs5_3),
        .in4(weighted_inputs5_4),
        .in5(weighted_inputs5_5),
        .in6(weighted_inputs5_6),
        .in7(weighted_inputs5_7),
        .in8(weighted_inputs5_8),
        .in9(weighted_inputs5_9),
        .in10(weighted_inputs5_10),
        .in11(weighted_inputs5_11),
        .in12(weighted_inputs5_12),
        .in13(weighted_inputs5_13),
        .in14(weighted_inputs5_14),
        .in15(weighted_inputs5_15),
        .in16(weighted_inputs5_16),
        .in17(weighted_inputs5_17),
        .in18(weighted_inputs5_18),
        .in19(weighted_inputs5_19),
        .in20(weighted_inputs5_20),
        .in21(weighted_inputs5_21),
        .in22(weighted_inputs5_22),
        .in23(weighted_inputs5_23),
        .in24(weighted_inputs5_24),
        .in25(weighted_inputs5_25),
        .in26(weighted_inputs5_26),
        .in27(weighted_inputs5_27),
        .in28(weighted_inputs5_28),
        .in29(weighted_inputs5_29),
        .in30(weighted_inputs5_30),
        .in31(weighted_inputs5_31),
        .sum(sum1[4])
    );
    adder_tree_1 add5(
        .clk(clk), 
        .in0(weighted_inputs6_0),
        .in1(weighted_inputs6_1),
        .in2(weighted_inputs6_2),
        .in3(weighted_inputs6_3),
        .in4(weighted_inputs6_4),
        .in5(weighted_inputs6_5),
        .in6(weighted_inputs6_6),
        .in7(weighted_inputs6_7),
        .in8(weighted_inputs6_8),
        .in9(weighted_inputs6_9),
        .in10(weighted_inputs6_10),
        .in11(weighted_inputs6_11),
        .in12(weighted_inputs6_12),
        .in13(weighted_inputs6_13),
        .in14(weighted_inputs6_14),
        .in15(weighted_inputs6_15),
        .in16(weighted_inputs6_16),
        .in17(weighted_inputs6_17),
        .in18(weighted_inputs6_18),
        .in19(weighted_inputs6_19),
        .in20(weighted_inputs6_20),
        .in21(weighted_inputs6_21),
        .in22(weighted_inputs6_22),
        .in23(weighted_inputs6_23),
        .in24(weighted_inputs6_24),
        .in25(weighted_inputs6_25),
        .in26(weighted_inputs6_26),
        .in27(weighted_inputs6_27),
        .in28(weighted_inputs6_28),
        .in29(weighted_inputs6_29),
        .in30(weighted_inputs6_30),
        .in31(weighted_inputs6_31),
        .sum(sum1[5])
    );
    adder_tree_1 add6(
        .clk(clk), 
        .in0(weighted_inputs7_0),
        .in1(weighted_inputs7_1),
        .in2(weighted_inputs7_2),
        .in3(weighted_inputs7_3),
        .in4(weighted_inputs7_4),
        .in5(weighted_inputs7_5),
        .in6(weighted_inputs7_6),
        .in7(weighted_inputs7_7),
        .in8(weighted_inputs7_8),
        .in9(weighted_inputs7_9),
        .in10(weighted_inputs7_10),
        .in11(weighted_inputs7_11),
        .in12(weighted_inputs7_12),
        .in13(weighted_inputs7_13),
        .in14(weighted_inputs7_14),
        .in15(weighted_inputs7_15),
        .in16(weighted_inputs7_16),
        .in17(weighted_inputs7_17),
        .in18(weighted_inputs7_18),
        .in19(weighted_inputs7_19),
        .in20(weighted_inputs7_20),
        .in21(weighted_inputs7_21),
        .in22(weighted_inputs7_22),
        .in23(weighted_inputs7_23),
        .in24(weighted_inputs7_24),
        .in25(weighted_inputs7_25),
        .in26(weighted_inputs7_26),
        .in27(weighted_inputs7_27),
        .in28(weighted_inputs7_28),
        .in29(weighted_inputs7_29),
        .in30(weighted_inputs7_30),
        .in31(weighted_inputs7_31),
        .sum(sum1[6])
    );
    adder_tree_1 add7(
        .clk(clk), 
        .in0(weighted_inputs8_0),
        .in1(weighted_inputs8_1),
        .in2(weighted_inputs8_2),
        .in3(weighted_inputs8_3),
        .in4(weighted_inputs8_4),
        .in5(weighted_inputs8_5),
        .in6(weighted_inputs8_6),
        .in7(weighted_inputs8_7),
        .in8(weighted_inputs8_8),
        .in9(weighted_inputs8_9),
        .in10(weighted_inputs8_10),
        .in11(weighted_inputs8_11),
        .in12(weighted_inputs8_12),
        .in13(weighted_inputs8_13),
        .in14(weighted_inputs8_14),
        .in15(weighted_inputs8_15),
        .in16(weighted_inputs8_16),
        .in17(weighted_inputs8_17),
        .in18(weighted_inputs8_18),
        .in19(weighted_inputs8_19),
        .in20(weighted_inputs8_20),
        .in21(weighted_inputs8_21),
        .in22(weighted_inputs8_22),
        .in23(weighted_inputs8_23),
        .in24(weighted_inputs8_24),
        .in25(weighted_inputs8_25),
        .in26(weighted_inputs8_26),
        .in27(weighted_inputs8_27),
        .in28(weighted_inputs8_28),
        .in29(weighted_inputs8_29),
        .in30(weighted_inputs8_30),
        .in31(weighted_inputs8_31),
        .sum(sum1[7])
    );
    adder_tree_1 add8(
        .clk(clk), 
        .in0(weighted_inputs9_0),
        .in1(weighted_inputs9_1),
        .in2(weighted_inputs9_2),
        .in3(weighted_inputs9_3),
        .in4(weighted_inputs9_4),
        .in5(weighted_inputs9_5),
        .in6(weighted_inputs9_6),
        .in7(weighted_inputs9_7),
        .in8(weighted_inputs9_8),
        .in9(weighted_inputs9_9),
        .in10(weighted_inputs9_10),
        .in11(weighted_inputs9_11),
        .in12(weighted_inputs9_12),
        .in13(weighted_inputs9_13),
        .in14(weighted_inputs9_14),
        .in15(weighted_inputs9_15),
        .in16(weighted_inputs9_16),
        .in17(weighted_inputs9_17),
        .in18(weighted_inputs9_18),
        .in19(weighted_inputs9_19),
        .in20(weighted_inputs9_20),
        .in21(weighted_inputs9_21),
        .in22(weighted_inputs9_22),
        .in23(weighted_inputs9_23),
        .in24(weighted_inputs9_24),
        .in25(weighted_inputs9_25),
        .in26(weighted_inputs9_26),
        .in27(weighted_inputs9_27),
        .in28(weighted_inputs9_28),
        .in29(weighted_inputs9_29),
        .in30(weighted_inputs9_30),
        .in31(weighted_inputs9_31),
        .sum(sum1[8])
    );
    adder_tree_1 add9(
        .clk(clk), 
        .in0(weighted_inputs10_0),
        .in1(weighted_inputs10_1),
        .in2(weighted_inputs10_2),
        .in3(weighted_inputs10_3),
        .in4(weighted_inputs10_4),
        .in5(weighted_inputs10_5),
        .in6(weighted_inputs10_6),
        .in7(weighted_inputs10_7),
        .in8(weighted_inputs10_8),
        .in9(weighted_inputs10_9),
        .in10(weighted_inputs10_10),
        .in11(weighted_inputs10_11),
        .in12(weighted_inputs10_12),
        .in13(weighted_inputs10_13),
        .in14(weighted_inputs10_14),
        .in15(weighted_inputs10_15),
        .in16(weighted_inputs10_16),
        .in17(weighted_inputs10_17),
        .in18(weighted_inputs10_18),
        .in19(weighted_inputs10_19),
        .in20(weighted_inputs10_20),
        .in21(weighted_inputs10_21),
        .in22(weighted_inputs10_22),
        .in23(weighted_inputs10_23),
        .in24(weighted_inputs10_24),
        .in25(weighted_inputs10_25),
        .in26(weighted_inputs10_26),
        .in27(weighted_inputs10_27),
        .in28(weighted_inputs10_28),
        .in29(weighted_inputs10_29),
        .in30(weighted_inputs10_30),
        .in31(weighted_inputs10_31),
        .sum(sum1[9])
    );
    adder_tree_1 add10(
        .clk(clk), 
        .in0(weighted_inputs11_0),
        .in1(weighted_inputs11_1),
        .in2(weighted_inputs11_2),
        .in3(weighted_inputs11_3),
        .in4(weighted_inputs11_4),
        .in5(weighted_inputs11_5),
        .in6(weighted_inputs11_6),
        .in7(weighted_inputs11_7),
        .in8(weighted_inputs11_8),
        .in9(weighted_inputs11_9),
        .in10(weighted_inputs11_10),
        .in11(weighted_inputs11_11),
        .in12(weighted_inputs11_12),
        .in13(weighted_inputs11_13),
        .in14(weighted_inputs11_14),
        .in15(weighted_inputs11_15),
        .in16(weighted_inputs11_16),
        .in17(weighted_inputs11_17),
        .in18(weighted_inputs11_18),
        .in19(weighted_inputs11_19),
        .in20(weighted_inputs11_20),
        .in21(weighted_inputs11_21),
        .in22(weighted_inputs11_22),
        .in23(weighted_inputs11_23),
        .in24(weighted_inputs11_24),
        .in25(weighted_inputs11_25),
        .in26(weighted_inputs11_26),
        .in27(weighted_inputs11_27),
        .in28(weighted_inputs11_28),
        .in29(weighted_inputs11_29),
        .in30(weighted_inputs11_30),
        .in31(weighted_inputs11_31),
        .sum(sum1[10])
    );
    adder_tree_1 add11(
        .clk(clk), 
        .in0(weighted_inputs12_0),
        .in1(weighted_inputs12_1),
        .in2(weighted_inputs12_2),
        .in3(weighted_inputs12_3),
        .in4(weighted_inputs12_4),
        .in5(weighted_inputs12_5),
        .in6(weighted_inputs12_6),
        .in7(weighted_inputs12_7),
        .in8(weighted_inputs12_8),
        .in9(weighted_inputs12_9),
        .in10(weighted_inputs12_10),
        .in11(weighted_inputs12_11),
        .in12(weighted_inputs12_12),
        .in13(weighted_inputs12_13),
        .in14(weighted_inputs12_14),
        .in15(weighted_inputs12_15),
        .in16(weighted_inputs12_16),
        .in17(weighted_inputs12_17),
        .in18(weighted_inputs12_18),
        .in19(weighted_inputs12_19),
        .in20(weighted_inputs12_20),
        .in21(weighted_inputs12_21),
        .in22(weighted_inputs12_22),
        .in23(weighted_inputs12_23),
        .in24(weighted_inputs12_24),
        .in25(weighted_inputs12_25),
        .in26(weighted_inputs12_26),
        .in27(weighted_inputs12_27),
        .in28(weighted_inputs12_28),
        .in29(weighted_inputs12_29),
        .in30(weighted_inputs12_30),
        .in31(weighted_inputs12_31),
        .sum(sum1[11])
    );
    adder_tree_1 add12(
        .clk(clk), 
        .in0(weighted_inputs13_0),
        .in1(weighted_inputs13_1),
        .in2(weighted_inputs13_2),
        .in3(weighted_inputs13_3),
        .in4(weighted_inputs13_4),
        .in5(weighted_inputs13_5),
        .in6(weighted_inputs13_6),
        .in7(weighted_inputs13_7),
        .in8(weighted_inputs13_8),
        .in9(weighted_inputs13_9),
        .in10(weighted_inputs13_10),
        .in11(weighted_inputs13_11),
        .in12(weighted_inputs13_12),
        .in13(weighted_inputs13_13),
        .in14(weighted_inputs13_14),
        .in15(weighted_inputs13_15),
        .in16(weighted_inputs13_16),
        .in17(weighted_inputs13_17),
        .in18(weighted_inputs13_18),
        .in19(weighted_inputs13_19),
        .in20(weighted_inputs13_20),
        .in21(weighted_inputs13_21),
        .in22(weighted_inputs13_22),
        .in23(weighted_inputs13_23),
        .in24(weighted_inputs13_24),
        .in25(weighted_inputs13_25),
        .in26(weighted_inputs13_26),
        .in27(weighted_inputs13_27),
        .in28(weighted_inputs13_28),
        .in29(weighted_inputs13_29),
        .in30(weighted_inputs13_30),
        .in31(weighted_inputs13_31),
        .sum(sum1[12])
    );
    adder_tree_1 add13(
        .clk(clk), 
        .in0(weighted_inputs14_0),
        .in1(weighted_inputs14_1),
        .in2(weighted_inputs14_2),
        .in3(weighted_inputs14_3),
        .in4(weighted_inputs14_4),
        .in5(weighted_inputs14_5),
        .in6(weighted_inputs14_6),
        .in7(weighted_inputs14_7),
        .in8(weighted_inputs14_8),
        .in9(weighted_inputs14_9),
        .in10(weighted_inputs14_10),
        .in11(weighted_inputs14_11),
        .in12(weighted_inputs14_12),
        .in13(weighted_inputs14_13),
        .in14(weighted_inputs14_14),
        .in15(weighted_inputs14_15),
        .in16(weighted_inputs14_16),
        .in17(weighted_inputs14_17),
        .in18(weighted_inputs14_18),
        .in19(weighted_inputs14_19),
        .in20(weighted_inputs14_20),
        .in21(weighted_inputs14_21),
        .in22(weighted_inputs14_22),
        .in23(weighted_inputs14_23),
        .in24(weighted_inputs14_24),
        .in25(weighted_inputs14_25),
        .in26(weighted_inputs14_26),
        .in27(weighted_inputs14_27),
        .in28(weighted_inputs14_28),
        .in29(weighted_inputs14_29),
        .in30(weighted_inputs14_30),
        .in31(weighted_inputs14_31),
        .sum(sum1[13])
    );
    adder_tree_1 add14(
        .clk(clk), 
        .in0(weighted_inputs15_0),
        .in1(weighted_inputs15_1),
        .in2(weighted_inputs15_2),
        .in3(weighted_inputs15_3),
        .in4(weighted_inputs15_4),
        .in5(weighted_inputs15_5),
        .in6(weighted_inputs15_6),
        .in7(weighted_inputs15_7),
        .in8(weighted_inputs15_8),
        .in9(weighted_inputs15_9),
        .in10(weighted_inputs15_10),
        .in11(weighted_inputs15_11),
        .in12(weighted_inputs15_12),
        .in13(weighted_inputs15_13),
        .in14(weighted_inputs15_14),
        .in15(weighted_inputs15_15),
        .in16(weighted_inputs15_16),
        .in17(weighted_inputs15_17),
        .in18(weighted_inputs15_18),
        .in19(weighted_inputs15_19),
        .in20(weighted_inputs15_20),
        .in21(weighted_inputs15_21),
        .in22(weighted_inputs15_22),
        .in23(weighted_inputs15_23),
        .in24(weighted_inputs15_24),
        .in25(weighted_inputs15_25),
        .in26(weighted_inputs15_26),
        .in27(weighted_inputs15_27),
        .in28(weighted_inputs15_28),
        .in29(weighted_inputs15_29),
        .in30(weighted_inputs15_30),
        .in31(weighted_inputs15_31),
        .sum(sum1[14])
    );
    adder_tree_1 add15(
        .clk(clk), 
        .in0(weighted_inputs16_0),
        .in1(weighted_inputs16_1),
        .in2(weighted_inputs16_2),
        .in3(weighted_inputs16_3),
        .in4(weighted_inputs16_4),
        .in5(weighted_inputs16_5),
        .in6(weighted_inputs16_6),
        .in7(weighted_inputs16_7),
        .in8(weighted_inputs16_8),
        .in9(weighted_inputs16_9),
        .in10(weighted_inputs16_10),
        .in11(weighted_inputs16_11),
        .in12(weighted_inputs16_12),
        .in13(weighted_inputs16_13),
        .in14(weighted_inputs16_14),
        .in15(weighted_inputs16_15),
        .in16(weighted_inputs16_16),
        .in17(weighted_inputs16_17),
        .in18(weighted_inputs16_18),
        .in19(weighted_inputs16_19),
        .in20(weighted_inputs16_20),
        .in21(weighted_inputs16_21),
        .in22(weighted_inputs16_22),
        .in23(weighted_inputs16_23),
        .in24(weighted_inputs16_24),
        .in25(weighted_inputs16_25),
        .in26(weighted_inputs16_26),
        .in27(weighted_inputs16_27),
        .in28(weighted_inputs16_28),
        .in29(weighted_inputs16_29),
        .in30(weighted_inputs16_30),
        .in31(weighted_inputs16_31),
        .sum(sum1[15])
    );
    add13bit_1 u0 (.a(sum1[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1[0]));
    add13bit_1 u1 (.a(sum1[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1[1]));
    add13bit_1 u2 (.a(sum1[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1[2]));
    add13bit_1 u3 (.a(sum1[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1[3]));
    add13bit_1 u4 (.a(sum1[4]), .b(b5_1), .cin(1'b0), .y(biased_sum1[4]));
    add13bit_1 u5 (.a(sum1[5]), .b(b6_1), .cin(1'b0), .y(biased_sum1[5]));
    add13bit_1 u6 (.a(sum1[6]), .b(b7_1), .cin(1'b0), .y(biased_sum1[6]));
    add13bit_1 u7 (.a(sum1[7]), .b(b8_1), .cin(1'b0), .y(biased_sum1[7]));
    add13bit_1 u8 (.a(sum1[8]), .b(b9_1), .cin(1'b0), .y(biased_sum1[8]));
    add13bit_1 u9 (.a(sum1[9]), .b(b10_1), .cin(1'b0), .y(biased_sum1[9]));
    add13bit_1 u10 (.a(sum1[10]), .b(b11_1), .cin(1'b0), .y(biased_sum1[10]));
    add13bit_1 u11 (.a(sum1[11]), .b(b12_1), .cin(1'b0), .y(biased_sum1[11]));
    add13bit_1 u12 (.a(sum1[12]), .b(b13_1), .cin(1'b0), .y(biased_sum1[12]));
    add13bit_1 u13 (.a(sum1[13]), .b(b14_1), .cin(1'b0), .y(biased_sum1[13]));
    add13bit_1 u14 (.a(sum1[14]), .b(b15_1), .cin(1'b0), .y(biased_sum1[14]));
    add13bit_1 u15 (.a(sum1[15]), .b(b16_1), .cin(1'b0), .y(biased_sum1[15]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    assign biased_sum4_0 = biased_sum1[4];
    assign biased_sum5_0 = biased_sum1[5];
    assign biased_sum6_0 = biased_sum1[6];
    assign biased_sum7_0 = biased_sum1[7];
    assign biased_sum8_0 = biased_sum1[8];
    assign biased_sum9_0 = biased_sum1[9];
    assign biased_sum10_0 = biased_sum1[10];
    assign biased_sum11_0 = biased_sum1[11];
    assign biased_sum12_0 = biased_sum1[12];
    assign biased_sum13_0 = biased_sum1[13];
    assign biased_sum14_0 = biased_sum1[14];
    assign biased_sum15_0 = biased_sum1[15];
    always @(posedge clk) begin
        $display("----- BNN LAYER 1 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_1, inputs1_1, inputs2_1, inputs3_1, inputs4_1, inputs5_1, inputs6_1, inputs7_1, inputs8_1, inputs9_1, inputs10_1, inputs11_1, inputs12_1, inputs13_1, inputs14_1, inputs15_1, inputs16_1, inputs17_1, inputs18_1, inputs19_1, inputs20_1, inputs21_1, inputs22_1, inputs23_1, inputs24_1, inputs25_1, inputs26_1, inputs27_1, inputs28_1, inputs29_1, inputs30_1, inputs31_1);
        $display("Weights: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", w1_1, w2_1, w3_1, w4_1, w5_1, w6_1, w7_1, w8_1, w9_1, w10_1, w11_1, w12_1, w13_1, w14_1, w15_1, w16_1);
        $display("sum1: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7], sum1[8], sum1[9], sum1[10], sum1[11], sum1[12], sum1[13], sum1[14], sum1[15]);
        $display("biased_sum1: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7], biased_sum1[8], biased_sum1[9], biased_sum1[10], biased_sum1[11], biased_sum1[12], biased_sum1[13], biased_sum1[14], biased_sum1[15]);
    end
endmodule


module activation_1 (

    input [13:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[13] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_1 (
    input  [13:0] inputs0_0,
    input  [13:0] inputs1_0,
    input  [13:0] inputs2_0,
    input  [13:0] inputs3_0,
    input  [13:0] inputs4_0,
    input  [13:0] inputs5_0,
    input  [13:0] inputs6_0,
    input  [13:0] inputs7_0,
    input  [13:0] inputs8_0,
    input  [13:0] inputs9_0,
    input  [13:0] inputs10_0,
    input  [13:0] inputs11_0,
    input  [13:0] inputs12_0,
    input  [13:0] inputs13_0,
    input  [13:0] inputs14_0,
    input  [13:0] inputs15_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3,
    output wire activation4,
    output wire activation5,
    output wire activation6,
    output wire activation7,
    output wire activation8,
    output wire activation9,
    output wire activation10,
    output wire activation11,
    output wire activation12,
    output wire activation13,
    output wire activation14,
    output wire activation15
);

    activation_1 a0 (
        .inputs0_0(inputs0_0),
        .activation(activation0)
    );

    activation_1 a1 (
        .inputs0_0(inputs1_0),
        .activation(activation1)
    );

    activation_1 a2 (
        .inputs0_0(inputs2_0),
        .activation(activation2)
    );

    activation_1 a3 (
        .inputs0_0(inputs3_0),
        .activation(activation3)
    );

    activation_1 a4 (
        .inputs0_0(inputs4_0),
        .activation(activation4)
    );

    activation_1 a5 (
        .inputs0_0(inputs5_0),
        .activation(activation5)
    );

    activation_1 a6 (
        .inputs0_0(inputs6_0),
        .activation(activation6)
    );

    activation_1 a7 (
        .inputs0_0(inputs7_0),
        .activation(activation7)
    );

    activation_1 a8 (
        .inputs0_0(inputs8_0),
        .activation(activation8)
    );

    activation_1 a9 (
        .inputs0_0(inputs9_0),
        .activation(activation9)
    );

    activation_1 a10 (
        .inputs0_0(inputs10_0),
        .activation(activation10)
    );

    activation_1 a11 (
        .inputs0_0(inputs11_0),
        .activation(activation11)
    );

    activation_1 a12 (
        .inputs0_0(inputs12_0),
        .activation(activation12)
    );

    activation_1 a13 (
        .inputs0_0(inputs13_0),
        .activation(activation13)
    );

    activation_1 a14 (
        .inputs0_0(inputs14_0),
        .activation(activation14)
    );

    activation_1 a15 (
        .inputs0_0(inputs15_0),
        .activation(activation15)
    );

endmodule



module activation_and_conversion_1(
  input  wire clk, 
  input  wire [7:0] inputs0_1,
  input  wire [7:0] inputs1_1,
  input  wire [7:0] inputs2_1,
  input  wire [7:0] inputs3_1,
  input  wire [7:0] inputs4_1,
  input  wire [7:0] inputs5_1,
  input  wire [7:0] inputs6_1,
  input  wire [7:0] inputs7_1,
  input  wire [7:0] inputs8_1,
  input  wire [7:0] inputs9_1,
  input  wire [7:0] inputs10_1,
  input  wire [7:0] inputs11_1,
  input  wire [7:0] inputs12_1,
  input  wire [7:0] inputs13_1,
  input  wire [7:0] inputs14_1,
  input  wire [7:0] inputs15_1,
  input  wire [7:0] inputs16_1,
  input  wire [7:0] inputs17_1,
  input  wire [7:0] inputs18_1,
  input  wire [7:0] inputs19_1,
  input  wire [7:0] inputs20_1,
  input  wire [7:0] inputs21_1,
  input  wire [7:0] inputs22_1,
  input  wire [7:0] inputs23_1,
  input  wire [7:0] inputs24_1,
  input  wire [7:0] inputs25_1,
  input  wire [7:0] inputs26_1,
  input  wire [7:0] inputs27_1,
  input  wire [7:0] inputs28_1,
  input  wire [7:0] inputs29_1,
  input  wire [7:0] inputs30_1,
  input  wire [7:0] inputs31_1,
  input  wire [31:0] w1_1,
  input  wire [31:0] w2_1,
  input  wire [31:0] w3_1,
  input  wire [31:0] w4_1,
  input  wire [31:0] w5_1,
  input  wire [31:0] w6_1,
  input  wire [31:0] w7_1,
  input  wire [31:0] w8_1,
  input  wire [31:0] w9_1,
  input  wire [31:0] w10_1,
  input  wire [31:0] w11_1,
  input  wire [31:0] w12_1,
  input  wire [31:0] w13_1,
  input  wire [31:0] w14_1,
  input  wire [31:0] w15_1,
  input  wire [31:0] w16_1,
  input  wire [12:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1, b9_1, b10_1, b11_1, b12_1, b13_1, b14_1, b15_1, b16_1,
  output wire activation0_1, 

  output wire activation1_1, 

  output wire activation2_1, 

  output wire activation3_1, 

  output wire activation4_1, 

  output wire activation5_1, 

  output wire activation6_1, 

  output wire activation7_1, 

  output wire activation8_1, 

  output wire activation9_1, 

  output wire activation10_1, 

  output wire activation11_1, 

  output wire activation12_1, 

  output wire activation13_1, 

  output wire activation14_1, 

  output wire activation15_1
);

  wire [13:0] biased_sum0_0;
  wire [13:0] biased_sum1_0;
  wire [13:0] biased_sum2_0;
  wire [13:0] biased_sum3_0;
  wire [13:0] biased_sum4_0;
  wire [13:0] biased_sum5_0;
  wire [13:0] biased_sum6_0;
  wire [13:0] biased_sum7_0;
  wire [13:0] biased_sum8_0;
  wire [13:0] biased_sum9_0;
  wire [13:0] biased_sum10_0;
  wire [13:0] biased_sum11_0;
  wire [13:0] biased_sum12_0;
  wire [13:0] biased_sum13_0;
  wire [13:0] biased_sum14_0;
  wire [13:0] biased_sum15_0;

    layer1 l1 (
    .clk(clk),
    .inputs0_1(inputs0_1),
    .inputs1_1(inputs1_1),
    .inputs2_1(inputs2_1),
    .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1),
    .inputs5_1(inputs5_1),
    .inputs6_1(inputs6_1),
    .inputs7_1(inputs7_1),
    .inputs8_1(inputs8_1),
    .inputs9_1(inputs9_1),
    .inputs10_1(inputs10_1),
    .inputs11_1(inputs11_1),
    .inputs12_1(inputs12_1),
    .inputs13_1(inputs13_1),
    .inputs14_1(inputs14_1),
    .inputs15_1(inputs15_1),
    .inputs16_1(inputs16_1),
    .inputs17_1(inputs17_1),
    .inputs18_1(inputs18_1),
    .inputs19_1(inputs19_1),
    .inputs20_1(inputs20_1),
    .inputs21_1(inputs21_1),
    .inputs22_1(inputs22_1),
    .inputs23_1(inputs23_1),
    .inputs24_1(inputs24_1),
    .inputs25_1(inputs25_1),
    .inputs26_1(inputs26_1),
    .inputs27_1(inputs27_1),
    .inputs28_1(inputs28_1),
    .inputs29_1(inputs29_1),
    .inputs30_1(inputs30_1),
    .inputs31_1(inputs31_1),
    .w1_1(w1_1),
    .w2_1(w2_1),
    .w3_1(w3_1),
    .w4_1(w4_1),
    .w5_1(w5_1),
    .w6_1(w6_1),
    .w7_1(w7_1),
    .w8_1(w8_1),
    .w9_1(w9_1),
    .w10_1(w10_1),
    .w11_1(w11_1),
    .w12_1(w12_1),
    .w13_1(w13_1),
    .w14_1(w14_1),
    .w15_1(w15_1),
    .w16_1(w16_1),
    .b1_1(b1_1),
    .b2_1(b2_1),
    .b3_1(b3_1),
    .b4_1(b4_1),
    .b5_1(b5_1),
    .b6_1(b6_1),
    .b7_1(b7_1),
    .b8_1(b8_1),
    .b9_1(b9_1),
    .b10_1(b10_1),
    .b11_1(b11_1),
    .b12_1(b12_1),
    .b13_1(b13_1),
    .b14_1(b14_1),
    .b15_1(b15_1),
    .b16_1(b16_1),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0),
    .biased_sum4_0(biased_sum4_0),
    .biased_sum5_0(biased_sum5_0),
    .biased_sum6_0(biased_sum6_0),
    .biased_sum7_0(biased_sum7_0),
    .biased_sum8_0(biased_sum8_0),
    .biased_sum9_0(biased_sum9_0),
    .biased_sum10_0(biased_sum10_0),
    .biased_sum11_0(biased_sum11_0),
    .biased_sum12_0(biased_sum12_0),
    .biased_sum13_0(biased_sum13_0),
    .biased_sum14_0(biased_sum14_0),
    .biased_sum15_0(biased_sum15_0)
  );

    activation_array_1 act1 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .inputs4_0(biased_sum4_0),
    .inputs5_0(biased_sum5_0),
    .inputs6_0(biased_sum6_0),
    .inputs7_0(biased_sum7_0),
    .inputs8_0(biased_sum8_0),
    .inputs9_0(biased_sum9_0),
    .inputs10_0(biased_sum10_0),
    .inputs11_0(biased_sum11_0),
    .inputs12_0(biased_sum12_0),
    .inputs13_0(biased_sum13_0),
    .inputs14_0(biased_sum14_0),
    .inputs15_0(biased_sum15_0),
    .activation0(activation0_1),
    .activation1(activation1_1),
    .activation2(activation2_1),
    .activation3(activation3_1),
    .activation4(activation4_1),
    .activation5(activation5_1),
    .activation6(activation6_1),
    .activation7(activation7_1),
    .activation8(activation8_1),
    .activation9(activation9_1),
    .activation10(activation10_1),
    .activation11(activation11_1),
    .activation12(activation12_1),
    .activation13(activation13_1),
    .activation14(activation14_1),
    .activation15(activation15_1)
  );

    activation_array_1 act2 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .inputs4_0(biased_sum4_0),
    .inputs5_0(biased_sum5_0),
    .inputs6_0(biased_sum6_0),
    .inputs7_0(biased_sum7_0),
    .inputs8_0(biased_sum8_0),
    .inputs9_0(biased_sum9_0),
    .inputs10_0(biased_sum10_0),
    .inputs11_0(biased_sum11_0),
    .inputs12_0(biased_sum12_0),
    .inputs13_0(biased_sum13_0),
    .inputs14_0(biased_sum14_0),
    .inputs15_0(biased_sum15_0),
    .activation0(activation0_1),
    .activation1(activation1_1),
    .activation2(activation2_1),
    .activation3(activation3_1),
    .activation4(activation4_1),
    .activation5(activation5_1),
    .activation6(activation6_1),
    .activation7(activation7_1),
    .activation8(activation8_1),
    .activation9(activation9_1),
    .activation10(activation10_1),
    .activation11(activation11_1),
    .activation12(activation12_1),
    .activation13(activation13_1),
    .activation14(activation14_1),
    .activation15(activation15_1)
  );

    always @(posedge clk) begin
    $display("----- LAYER 1   boolean activations -----");
    $display("activation : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", activation0_1, activation1_1, activation2_1, activation3_1, activation4_1, activation5_1, activation6_1, activation7_1, activation8_1, activation9_1, activation10_1, activation11_1, activation12_1, activation13_1, activation14_1, activation15_1);
  end


endmodule




// ----- LAYER 2 -----
module half_adder_2(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adder_2(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adder_2 HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adder_2 HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNAND_2(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule

module add1bit_2(
    input wire [0:0] a,
    input wire [0:0] b,
    input wire  cin,
    output wire [1:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;

full_adder_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));

WddlNAND_2 wn1(.A(~a[0]), .B(b[0]), .C(~c1), .S(s1), .S1(s1_1));
WddlNAND_2 wn2(.A(a[0]), .B(~b[0]), .C(~c1), .S(s2), .S1(s2_1));
WddlNAND_2 wn3(.A(a[0]), .B(b[0]), .C(c1), .S(s3), .S1(s3_1));
WddlNAND_2 wn4(.A(~a[0]), .B(~b[0]), .C(c1), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[1] = cout;

endmodule

module add2bit_2(
    input wire [1:0] a,
    input wire [1:0] b,
    input wire  cin,
    output wire [2:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;

full_adder_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));

WddlNAND_2 wn1(.A(~a[1]), .B(b[1]), .C(~c2), .S(s1), .S1(s1_1));
WddlNAND_2 wn2(.A(a[1]), .B(~b[1]), .C(~c2), .S(s2), .S1(s2_1));
WddlNAND_2 wn3(.A(a[1]), .B(b[1]), .C(c2), .S(s3), .S1(s3_1));
WddlNAND_2 wn4(.A(~a[1]), .B(~b[1]), .C(c2), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[2] = cout;

endmodule

module add3bit_2(
    input wire [2:0] a,
    input wire [2:0] b,
    input wire  cin,
    output wire [3:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;

full_adder_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNAND_2 wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNAND_2 wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNAND_2 wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNAND_2 wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout;

endmodule

module add4bit_2(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire  cin,
    output wire [4:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;

full_adder_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNAND_2 wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNAND_2 wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNAND_2 wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNAND_2 wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout;

endmodule

module add5bit_2(
    input wire [4:0] a,
    input wire [4:0] b,
    input wire  cin,
    output wire [5:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;

full_adder_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_2 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNAND_2 wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNAND_2 wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNAND_2 wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNAND_2 wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout;

endmodule



module adder_tree_2 (
    input  wire   clk, 
    input  wire [0:0] in0,
    input  wire [0:0] in1,
    input  wire [0:0] in2,
    input  wire [0:0] in3,
    input  wire [0:0] in4,
    input  wire [0:0] in5,
    input  wire [0:0] in6,
    input  wire [0:0] in7,
    input  wire [0:0] in8,
    input  wire [0:0] in9,
    input  wire [0:0] in10,
    input  wire [0:0] in11,
    input  wire [0:0] in12,
    input  wire [0:0] in13,
    input  wire [0:0] in14,
    input  wire [0:0] in15,
    output wire [4:0] sum
);

    wire [1:0] stage0_0_lo_2;
    wire [1:0] stage0_1_lo_2;
    wire [1:0] stage0_2_lo_2;
    wire [1:0] stage0_3_lo_2;
    wire [1:0] stage0_4_lo_2;
    wire [1:0] stage0_5_lo_2;
    wire [1:0] stage0_6_lo_2;
    wire [1:0] stage0_7_lo_2;
    wire [2:0] stage1_0_lo_2;
    wire [2:0] stage1_1_lo_2;
    wire [2:0] stage1_2_lo_2;
    wire [2:0] stage1_3_lo_2;
    wire [3:0] stage2_0_lo_2;
    wire [3:0] stage2_1_lo_2;
    wire [4:0] stage3_0_lo_2;
    reg  [1:0] stage0_0_2;
    reg  [1:0] stage0_1_2;
    reg  [1:0] stage0_2_2;
    reg  [1:0] stage0_3_2;
    reg  [1:0] stage0_4_2;
    reg  [1:0] stage0_5_2;
    reg  [1:0] stage0_6_2;
    reg  [1:0] stage0_7_2;
    reg  [2:0] stage1_0_2;
    reg  [2:0] stage1_1_2;
    reg  [2:0] stage1_2_2;
    reg  [2:0] stage1_3_2;
    reg  [3:0] stage2_0_2;
    reg  [3:0] stage2_1_2;
    reg  [4:0] stage3_0_2;

    add1bit_2 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_2), .cout(), .cout_bar());
    add2bit_2 u1_0 (.a(stage0_0_2), .b(stage0_1_2), .cin(1'b0), .y(stage1_0_lo_2), .cout(), .cout_bar());
    add2bit_2 u1_1 (.a(stage0_2_2), .b(stage0_3_2), .cin(1'b0), .y(stage1_1_lo_2), .cout(), .cout_bar());
    add2bit_2 u1_2 (.a(stage0_4_2), .b(stage0_5_2), .cin(1'b0), .y(stage1_2_lo_2), .cout(), .cout_bar());
    add2bit_2 u1_3 (.a(stage0_6_2), .b(stage0_7_2), .cin(1'b0), .y(stage1_3_lo_2), .cout(), .cout_bar());
    add3bit_2 u2_0 (.a(stage1_0_2), .b(stage1_1_2), .cin(1'b0), .y(stage2_0_lo_2), .cout(), .cout_bar());
    add3bit_2 u2_1 (.a(stage1_2_2), .b(stage1_3_2), .cin(1'b0), .y(stage2_1_lo_2), .cout(), .cout_bar());
    add4bit_2 u3_0 (.a(stage2_0_2), .b(stage2_1_2), .cin(1'b0), .y(stage3_0_lo_2), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_2;

    always @(posedge clk) begin
        stage0_0_2 <=  stage0_0_lo_2;
        stage0_1_2 <=  stage0_1_lo_2;
        stage0_2_2 <=  stage0_2_lo_2;
        stage0_3_2 <=  stage0_3_lo_2;
        stage0_4_2 <=  stage0_4_lo_2;
        stage0_5_2 <=  stage0_5_lo_2;
        stage0_6_2 <=  stage0_6_lo_2;
        stage0_7_2 <=  stage0_7_lo_2;
        stage1_0_2 <=  stage1_0_lo_2;
        stage1_1_2 <=  stage1_1_lo_2;
        stage1_2_2 <=  stage1_2_lo_2;
        stage1_3_2 <=  stage1_3_lo_2;
        stage2_0_2 <=  stage2_0_lo_2;
        stage2_1_2 <=  stage2_1_lo_2;
        stage3_0_2 <=  stage3_0_lo_2;
    end
endmodule


module layer2(
    input clk,
    input [0:0] inputs0_2 , inputs1_2 , inputs2_2 , inputs3_2 , inputs4_2 , inputs5_2 , inputs6_2 , inputs7_2 , inputs8_2 , inputs9_2 , inputs10_2 , inputs11_2 , inputs12_2 , inputs13_2 , inputs14_2 , inputs15_2,
    input [15:0] w1_2, w2_2, w3_2, w4_2, w5_2, w6_2, w7_2, w8_2, w9_2, w10_2, w11_2, w12_2, w13_2, w14_2, w15_2, w16_2,
    input [4:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2, b9_2, b10_2, b11_2, b12_2, b13_2, b14_2, b15_2, b16_2,
    output [5:0] biased_sum0_0 , biased_sum1_0 , biased_sum2_0 , biased_sum3_0 , biased_sum4_0 , biased_sum5_0 , biased_sum6_0 , biased_sum7_0 , biased_sum8_0 , biased_sum9_0 , biased_sum10_0 , biased_sum11_0 , biased_sum12_0 , biased_sum13_0 , biased_sum14_0 , biased_sum15_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs1_4;
    wire [0:0] weighted_inputs1_5;
    wire [0:0] weighted_inputs1_6;
    wire [0:0] weighted_inputs1_7;
    wire [0:0] weighted_inputs1_8;
    wire [0:0] weighted_inputs1_9;
    wire [0:0] weighted_inputs1_10;
    wire [0:0] weighted_inputs1_11;
    wire [0:0] weighted_inputs1_12;
    wire [0:0] weighted_inputs1_13;
    wire [0:0] weighted_inputs1_14;
    wire [0:0] weighted_inputs1_15;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;
    wire [0:0] weighted_inputs2_4;
    wire [0:0] weighted_inputs2_5;
    wire [0:0] weighted_inputs2_6;
    wire [0:0] weighted_inputs2_7;
    wire [0:0] weighted_inputs2_8;
    wire [0:0] weighted_inputs2_9;
    wire [0:0] weighted_inputs2_10;
    wire [0:0] weighted_inputs2_11;
    wire [0:0] weighted_inputs2_12;
    wire [0:0] weighted_inputs2_13;
    wire [0:0] weighted_inputs2_14;
    wire [0:0] weighted_inputs2_15;
    wire [0:0] weighted_inputs3_0;
    wire [0:0] weighted_inputs3_1;
    wire [0:0] weighted_inputs3_2;
    wire [0:0] weighted_inputs3_3;
    wire [0:0] weighted_inputs3_4;
    wire [0:0] weighted_inputs3_5;
    wire [0:0] weighted_inputs3_6;
    wire [0:0] weighted_inputs3_7;
    wire [0:0] weighted_inputs3_8;
    wire [0:0] weighted_inputs3_9;
    wire [0:0] weighted_inputs3_10;
    wire [0:0] weighted_inputs3_11;
    wire [0:0] weighted_inputs3_12;
    wire [0:0] weighted_inputs3_13;
    wire [0:0] weighted_inputs3_14;
    wire [0:0] weighted_inputs3_15;
    wire [0:0] weighted_inputs4_0;
    wire [0:0] weighted_inputs4_1;
    wire [0:0] weighted_inputs4_2;
    wire [0:0] weighted_inputs4_3;
    wire [0:0] weighted_inputs4_4;
    wire [0:0] weighted_inputs4_5;
    wire [0:0] weighted_inputs4_6;
    wire [0:0] weighted_inputs4_7;
    wire [0:0] weighted_inputs4_8;
    wire [0:0] weighted_inputs4_9;
    wire [0:0] weighted_inputs4_10;
    wire [0:0] weighted_inputs4_11;
    wire [0:0] weighted_inputs4_12;
    wire [0:0] weighted_inputs4_13;
    wire [0:0] weighted_inputs4_14;
    wire [0:0] weighted_inputs4_15;
    wire [0:0] weighted_inputs5_0;
    wire [0:0] weighted_inputs5_1;
    wire [0:0] weighted_inputs5_2;
    wire [0:0] weighted_inputs5_3;
    wire [0:0] weighted_inputs5_4;
    wire [0:0] weighted_inputs5_5;
    wire [0:0] weighted_inputs5_6;
    wire [0:0] weighted_inputs5_7;
    wire [0:0] weighted_inputs5_8;
    wire [0:0] weighted_inputs5_9;
    wire [0:0] weighted_inputs5_10;
    wire [0:0] weighted_inputs5_11;
    wire [0:0] weighted_inputs5_12;
    wire [0:0] weighted_inputs5_13;
    wire [0:0] weighted_inputs5_14;
    wire [0:0] weighted_inputs5_15;
    wire [0:0] weighted_inputs6_0;
    wire [0:0] weighted_inputs6_1;
    wire [0:0] weighted_inputs6_2;
    wire [0:0] weighted_inputs6_3;
    wire [0:0] weighted_inputs6_4;
    wire [0:0] weighted_inputs6_5;
    wire [0:0] weighted_inputs6_6;
    wire [0:0] weighted_inputs6_7;
    wire [0:0] weighted_inputs6_8;
    wire [0:0] weighted_inputs6_9;
    wire [0:0] weighted_inputs6_10;
    wire [0:0] weighted_inputs6_11;
    wire [0:0] weighted_inputs6_12;
    wire [0:0] weighted_inputs6_13;
    wire [0:0] weighted_inputs6_14;
    wire [0:0] weighted_inputs6_15;
    wire [0:0] weighted_inputs7_0;
    wire [0:0] weighted_inputs7_1;
    wire [0:0] weighted_inputs7_2;
    wire [0:0] weighted_inputs7_3;
    wire [0:0] weighted_inputs7_4;
    wire [0:0] weighted_inputs7_5;
    wire [0:0] weighted_inputs7_6;
    wire [0:0] weighted_inputs7_7;
    wire [0:0] weighted_inputs7_8;
    wire [0:0] weighted_inputs7_9;
    wire [0:0] weighted_inputs7_10;
    wire [0:0] weighted_inputs7_11;
    wire [0:0] weighted_inputs7_12;
    wire [0:0] weighted_inputs7_13;
    wire [0:0] weighted_inputs7_14;
    wire [0:0] weighted_inputs7_15;
    wire [0:0] weighted_inputs8_0;
    wire [0:0] weighted_inputs8_1;
    wire [0:0] weighted_inputs8_2;
    wire [0:0] weighted_inputs8_3;
    wire [0:0] weighted_inputs8_4;
    wire [0:0] weighted_inputs8_5;
    wire [0:0] weighted_inputs8_6;
    wire [0:0] weighted_inputs8_7;
    wire [0:0] weighted_inputs8_8;
    wire [0:0] weighted_inputs8_9;
    wire [0:0] weighted_inputs8_10;
    wire [0:0] weighted_inputs8_11;
    wire [0:0] weighted_inputs8_12;
    wire [0:0] weighted_inputs8_13;
    wire [0:0] weighted_inputs8_14;
    wire [0:0] weighted_inputs8_15;
    wire [0:0] weighted_inputs9_0;
    wire [0:0] weighted_inputs9_1;
    wire [0:0] weighted_inputs9_2;
    wire [0:0] weighted_inputs9_3;
    wire [0:0] weighted_inputs9_4;
    wire [0:0] weighted_inputs9_5;
    wire [0:0] weighted_inputs9_6;
    wire [0:0] weighted_inputs9_7;
    wire [0:0] weighted_inputs9_8;
    wire [0:0] weighted_inputs9_9;
    wire [0:0] weighted_inputs9_10;
    wire [0:0] weighted_inputs9_11;
    wire [0:0] weighted_inputs9_12;
    wire [0:0] weighted_inputs9_13;
    wire [0:0] weighted_inputs9_14;
    wire [0:0] weighted_inputs9_15;
    wire [0:0] weighted_inputs10_0;
    wire [0:0] weighted_inputs10_1;
    wire [0:0] weighted_inputs10_2;
    wire [0:0] weighted_inputs10_3;
    wire [0:0] weighted_inputs10_4;
    wire [0:0] weighted_inputs10_5;
    wire [0:0] weighted_inputs10_6;
    wire [0:0] weighted_inputs10_7;
    wire [0:0] weighted_inputs10_8;
    wire [0:0] weighted_inputs10_9;
    wire [0:0] weighted_inputs10_10;
    wire [0:0] weighted_inputs10_11;
    wire [0:0] weighted_inputs10_12;
    wire [0:0] weighted_inputs10_13;
    wire [0:0] weighted_inputs10_14;
    wire [0:0] weighted_inputs10_15;
    wire [0:0] weighted_inputs11_0;
    wire [0:0] weighted_inputs11_1;
    wire [0:0] weighted_inputs11_2;
    wire [0:0] weighted_inputs11_3;
    wire [0:0] weighted_inputs11_4;
    wire [0:0] weighted_inputs11_5;
    wire [0:0] weighted_inputs11_6;
    wire [0:0] weighted_inputs11_7;
    wire [0:0] weighted_inputs11_8;
    wire [0:0] weighted_inputs11_9;
    wire [0:0] weighted_inputs11_10;
    wire [0:0] weighted_inputs11_11;
    wire [0:0] weighted_inputs11_12;
    wire [0:0] weighted_inputs11_13;
    wire [0:0] weighted_inputs11_14;
    wire [0:0] weighted_inputs11_15;
    wire [0:0] weighted_inputs12_0;
    wire [0:0] weighted_inputs12_1;
    wire [0:0] weighted_inputs12_2;
    wire [0:0] weighted_inputs12_3;
    wire [0:0] weighted_inputs12_4;
    wire [0:0] weighted_inputs12_5;
    wire [0:0] weighted_inputs12_6;
    wire [0:0] weighted_inputs12_7;
    wire [0:0] weighted_inputs12_8;
    wire [0:0] weighted_inputs12_9;
    wire [0:0] weighted_inputs12_10;
    wire [0:0] weighted_inputs12_11;
    wire [0:0] weighted_inputs12_12;
    wire [0:0] weighted_inputs12_13;
    wire [0:0] weighted_inputs12_14;
    wire [0:0] weighted_inputs12_15;
    wire [0:0] weighted_inputs13_0;
    wire [0:0] weighted_inputs13_1;
    wire [0:0] weighted_inputs13_2;
    wire [0:0] weighted_inputs13_3;
    wire [0:0] weighted_inputs13_4;
    wire [0:0] weighted_inputs13_5;
    wire [0:0] weighted_inputs13_6;
    wire [0:0] weighted_inputs13_7;
    wire [0:0] weighted_inputs13_8;
    wire [0:0] weighted_inputs13_9;
    wire [0:0] weighted_inputs13_10;
    wire [0:0] weighted_inputs13_11;
    wire [0:0] weighted_inputs13_12;
    wire [0:0] weighted_inputs13_13;
    wire [0:0] weighted_inputs13_14;
    wire [0:0] weighted_inputs13_15;
    wire [0:0] weighted_inputs14_0;
    wire [0:0] weighted_inputs14_1;
    wire [0:0] weighted_inputs14_2;
    wire [0:0] weighted_inputs14_3;
    wire [0:0] weighted_inputs14_4;
    wire [0:0] weighted_inputs14_5;
    wire [0:0] weighted_inputs14_6;
    wire [0:0] weighted_inputs14_7;
    wire [0:0] weighted_inputs14_8;
    wire [0:0] weighted_inputs14_9;
    wire [0:0] weighted_inputs14_10;
    wire [0:0] weighted_inputs14_11;
    wire [0:0] weighted_inputs14_12;
    wire [0:0] weighted_inputs14_13;
    wire [0:0] weighted_inputs14_14;
    wire [0:0] weighted_inputs14_15;
    wire [0:0] weighted_inputs15_0;
    wire [0:0] weighted_inputs15_1;
    wire [0:0] weighted_inputs15_2;
    wire [0:0] weighted_inputs15_3;
    wire [0:0] weighted_inputs15_4;
    wire [0:0] weighted_inputs15_5;
    wire [0:0] weighted_inputs15_6;
    wire [0:0] weighted_inputs15_7;
    wire [0:0] weighted_inputs15_8;
    wire [0:0] weighted_inputs15_9;
    wire [0:0] weighted_inputs15_10;
    wire [0:0] weighted_inputs15_11;
    wire [0:0] weighted_inputs15_12;
    wire [0:0] weighted_inputs15_13;
    wire [0:0] weighted_inputs15_14;
    wire [0:0] weighted_inputs15_15;
    wire [0:0] weighted_inputs16_0;
    wire [0:0] weighted_inputs16_1;
    wire [0:0] weighted_inputs16_2;
    wire [0:0] weighted_inputs16_3;
    wire [0:0] weighted_inputs16_4;
    wire [0:0] weighted_inputs16_5;
    wire [0:0] weighted_inputs16_6;
    wire [0:0] weighted_inputs16_7;
    wire [0:0] weighted_inputs16_8;
    wire [0:0] weighted_inputs16_9;
    wire [0:0] weighted_inputs16_10;
    wire [0:0] weighted_inputs16_11;
    wire [0:0] weighted_inputs16_12;
    wire [0:0] weighted_inputs16_13;
    wire [0:0] weighted_inputs16_14;
    wire [0:0] weighted_inputs16_15;

    wire [4:0] sum1 [15:0];
    wire [5:0] biased_sum1 [15:0];

    weighted_inputs_2 w0 (.inputs(inputs0_2), .w(w1_2[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_2), .w(w1_2[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_2), .w(w1_2[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_2), .w(w1_2[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs4_2), .w(w1_2[4]), .wi(weighted_inputs1_4));
    weighted_inputs_2 w5 (.inputs(inputs5_2), .w(w1_2[5]), .wi(weighted_inputs1_5));
    weighted_inputs_2 w6 (.inputs(inputs6_2), .w(w1_2[6]), .wi(weighted_inputs1_6));
    weighted_inputs_2 w7 (.inputs(inputs7_2), .w(w1_2[7]), .wi(weighted_inputs1_7));
    weighted_inputs_2 w8 (.inputs(inputs8_2), .w(w1_2[8]), .wi(weighted_inputs1_8));
    weighted_inputs_2 w9 (.inputs(inputs9_2), .w(w1_2[9]), .wi(weighted_inputs1_9));
    weighted_inputs_2 w10 (.inputs(inputs10_2), .w(w1_2[10]), .wi(weighted_inputs1_10));
    weighted_inputs_2 w11 (.inputs(inputs11_2), .w(w1_2[11]), .wi(weighted_inputs1_11));
    weighted_inputs_2 w12 (.inputs(inputs12_2), .w(w1_2[12]), .wi(weighted_inputs1_12));
    weighted_inputs_2 w13 (.inputs(inputs13_2), .w(w1_2[13]), .wi(weighted_inputs1_13));
    weighted_inputs_2 w14 (.inputs(inputs14_2), .w(w1_2[14]), .wi(weighted_inputs1_14));
    weighted_inputs_2 w15 (.inputs(inputs15_2), .w(w1_2[15]), .wi(weighted_inputs1_15));
    weighted_inputs_2 w16 (.inputs(inputs0_2), .w(w2_2[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w17 (.inputs(inputs1_2), .w(w2_2[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w18 (.inputs(inputs2_2), .w(w2_2[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w19 (.inputs(inputs3_2), .w(w2_2[3]), .wi(weighted_inputs2_3));
    weighted_inputs_2 w20 (.inputs(inputs4_2), .w(w2_2[4]), .wi(weighted_inputs2_4));
    weighted_inputs_2 w21 (.inputs(inputs5_2), .w(w2_2[5]), .wi(weighted_inputs2_5));
    weighted_inputs_2 w22 (.inputs(inputs6_2), .w(w2_2[6]), .wi(weighted_inputs2_6));
    weighted_inputs_2 w23 (.inputs(inputs7_2), .w(w2_2[7]), .wi(weighted_inputs2_7));
    weighted_inputs_2 w24 (.inputs(inputs8_2), .w(w2_2[8]), .wi(weighted_inputs2_8));
    weighted_inputs_2 w25 (.inputs(inputs9_2), .w(w2_2[9]), .wi(weighted_inputs2_9));
    weighted_inputs_2 w26 (.inputs(inputs10_2), .w(w2_2[10]), .wi(weighted_inputs2_10));
    weighted_inputs_2 w27 (.inputs(inputs11_2), .w(w2_2[11]), .wi(weighted_inputs2_11));
    weighted_inputs_2 w28 (.inputs(inputs12_2), .w(w2_2[12]), .wi(weighted_inputs2_12));
    weighted_inputs_2 w29 (.inputs(inputs13_2), .w(w2_2[13]), .wi(weighted_inputs2_13));
    weighted_inputs_2 w30 (.inputs(inputs14_2), .w(w2_2[14]), .wi(weighted_inputs2_14));
    weighted_inputs_2 w31 (.inputs(inputs15_2), .w(w2_2[15]), .wi(weighted_inputs2_15));
    weighted_inputs_2 w32 (.inputs(inputs0_2), .w(w3_2[0]), .wi(weighted_inputs3_0));
    weighted_inputs_2 w33 (.inputs(inputs1_2), .w(w3_2[1]), .wi(weighted_inputs3_1));
    weighted_inputs_2 w34 (.inputs(inputs2_2), .w(w3_2[2]), .wi(weighted_inputs3_2));
    weighted_inputs_2 w35 (.inputs(inputs3_2), .w(w3_2[3]), .wi(weighted_inputs3_3));
    weighted_inputs_2 w36 (.inputs(inputs4_2), .w(w3_2[4]), .wi(weighted_inputs3_4));
    weighted_inputs_2 w37 (.inputs(inputs5_2), .w(w3_2[5]), .wi(weighted_inputs3_5));
    weighted_inputs_2 w38 (.inputs(inputs6_2), .w(w3_2[6]), .wi(weighted_inputs3_6));
    weighted_inputs_2 w39 (.inputs(inputs7_2), .w(w3_2[7]), .wi(weighted_inputs3_7));
    weighted_inputs_2 w40 (.inputs(inputs8_2), .w(w3_2[8]), .wi(weighted_inputs3_8));
    weighted_inputs_2 w41 (.inputs(inputs9_2), .w(w3_2[9]), .wi(weighted_inputs3_9));
    weighted_inputs_2 w42 (.inputs(inputs10_2), .w(w3_2[10]), .wi(weighted_inputs3_10));
    weighted_inputs_2 w43 (.inputs(inputs11_2), .w(w3_2[11]), .wi(weighted_inputs3_11));
    weighted_inputs_2 w44 (.inputs(inputs12_2), .w(w3_2[12]), .wi(weighted_inputs3_12));
    weighted_inputs_2 w45 (.inputs(inputs13_2), .w(w3_2[13]), .wi(weighted_inputs3_13));
    weighted_inputs_2 w46 (.inputs(inputs14_2), .w(w3_2[14]), .wi(weighted_inputs3_14));
    weighted_inputs_2 w47 (.inputs(inputs15_2), .w(w3_2[15]), .wi(weighted_inputs3_15));
    weighted_inputs_2 w48 (.inputs(inputs0_2), .w(w4_2[0]), .wi(weighted_inputs4_0));
    weighted_inputs_2 w49 (.inputs(inputs1_2), .w(w4_2[1]), .wi(weighted_inputs4_1));
    weighted_inputs_2 w50 (.inputs(inputs2_2), .w(w4_2[2]), .wi(weighted_inputs4_2));
    weighted_inputs_2 w51 (.inputs(inputs3_2), .w(w4_2[3]), .wi(weighted_inputs4_3));
    weighted_inputs_2 w52 (.inputs(inputs4_2), .w(w4_2[4]), .wi(weighted_inputs4_4));
    weighted_inputs_2 w53 (.inputs(inputs5_2), .w(w4_2[5]), .wi(weighted_inputs4_5));
    weighted_inputs_2 w54 (.inputs(inputs6_2), .w(w4_2[6]), .wi(weighted_inputs4_6));
    weighted_inputs_2 w55 (.inputs(inputs7_2), .w(w4_2[7]), .wi(weighted_inputs4_7));
    weighted_inputs_2 w56 (.inputs(inputs8_2), .w(w4_2[8]), .wi(weighted_inputs4_8));
    weighted_inputs_2 w57 (.inputs(inputs9_2), .w(w4_2[9]), .wi(weighted_inputs4_9));
    weighted_inputs_2 w58 (.inputs(inputs10_2), .w(w4_2[10]), .wi(weighted_inputs4_10));
    weighted_inputs_2 w59 (.inputs(inputs11_2), .w(w4_2[11]), .wi(weighted_inputs4_11));
    weighted_inputs_2 w60 (.inputs(inputs12_2), .w(w4_2[12]), .wi(weighted_inputs4_12));
    weighted_inputs_2 w61 (.inputs(inputs13_2), .w(w4_2[13]), .wi(weighted_inputs4_13));
    weighted_inputs_2 w62 (.inputs(inputs14_2), .w(w4_2[14]), .wi(weighted_inputs4_14));
    weighted_inputs_2 w63 (.inputs(inputs15_2), .w(w4_2[15]), .wi(weighted_inputs4_15));
    weighted_inputs_2 w64 (.inputs(inputs0_2), .w(w5_2[0]), .wi(weighted_inputs5_0));
    weighted_inputs_2 w65 (.inputs(inputs1_2), .w(w5_2[1]), .wi(weighted_inputs5_1));
    weighted_inputs_2 w66 (.inputs(inputs2_2), .w(w5_2[2]), .wi(weighted_inputs5_2));
    weighted_inputs_2 w67 (.inputs(inputs3_2), .w(w5_2[3]), .wi(weighted_inputs5_3));
    weighted_inputs_2 w68 (.inputs(inputs4_2), .w(w5_2[4]), .wi(weighted_inputs5_4));
    weighted_inputs_2 w69 (.inputs(inputs5_2), .w(w5_2[5]), .wi(weighted_inputs5_5));
    weighted_inputs_2 w70 (.inputs(inputs6_2), .w(w5_2[6]), .wi(weighted_inputs5_6));
    weighted_inputs_2 w71 (.inputs(inputs7_2), .w(w5_2[7]), .wi(weighted_inputs5_7));
    weighted_inputs_2 w72 (.inputs(inputs8_2), .w(w5_2[8]), .wi(weighted_inputs5_8));
    weighted_inputs_2 w73 (.inputs(inputs9_2), .w(w5_2[9]), .wi(weighted_inputs5_9));
    weighted_inputs_2 w74 (.inputs(inputs10_2), .w(w5_2[10]), .wi(weighted_inputs5_10));
    weighted_inputs_2 w75 (.inputs(inputs11_2), .w(w5_2[11]), .wi(weighted_inputs5_11));
    weighted_inputs_2 w76 (.inputs(inputs12_2), .w(w5_2[12]), .wi(weighted_inputs5_12));
    weighted_inputs_2 w77 (.inputs(inputs13_2), .w(w5_2[13]), .wi(weighted_inputs5_13));
    weighted_inputs_2 w78 (.inputs(inputs14_2), .w(w5_2[14]), .wi(weighted_inputs5_14));
    weighted_inputs_2 w79 (.inputs(inputs15_2), .w(w5_2[15]), .wi(weighted_inputs5_15));
    weighted_inputs_2 w80 (.inputs(inputs0_2), .w(w6_2[0]), .wi(weighted_inputs6_0));
    weighted_inputs_2 w81 (.inputs(inputs1_2), .w(w6_2[1]), .wi(weighted_inputs6_1));
    weighted_inputs_2 w82 (.inputs(inputs2_2), .w(w6_2[2]), .wi(weighted_inputs6_2));
    weighted_inputs_2 w83 (.inputs(inputs3_2), .w(w6_2[3]), .wi(weighted_inputs6_3));
    weighted_inputs_2 w84 (.inputs(inputs4_2), .w(w6_2[4]), .wi(weighted_inputs6_4));
    weighted_inputs_2 w85 (.inputs(inputs5_2), .w(w6_2[5]), .wi(weighted_inputs6_5));
    weighted_inputs_2 w86 (.inputs(inputs6_2), .w(w6_2[6]), .wi(weighted_inputs6_6));
    weighted_inputs_2 w87 (.inputs(inputs7_2), .w(w6_2[7]), .wi(weighted_inputs6_7));
    weighted_inputs_2 w88 (.inputs(inputs8_2), .w(w6_2[8]), .wi(weighted_inputs6_8));
    weighted_inputs_2 w89 (.inputs(inputs9_2), .w(w6_2[9]), .wi(weighted_inputs6_9));
    weighted_inputs_2 w90 (.inputs(inputs10_2), .w(w6_2[10]), .wi(weighted_inputs6_10));
    weighted_inputs_2 w91 (.inputs(inputs11_2), .w(w6_2[11]), .wi(weighted_inputs6_11));
    weighted_inputs_2 w92 (.inputs(inputs12_2), .w(w6_2[12]), .wi(weighted_inputs6_12));
    weighted_inputs_2 w93 (.inputs(inputs13_2), .w(w6_2[13]), .wi(weighted_inputs6_13));
    weighted_inputs_2 w94 (.inputs(inputs14_2), .w(w6_2[14]), .wi(weighted_inputs6_14));
    weighted_inputs_2 w95 (.inputs(inputs15_2), .w(w6_2[15]), .wi(weighted_inputs6_15));
    weighted_inputs_2 w96 (.inputs(inputs0_2), .w(w7_2[0]), .wi(weighted_inputs7_0));
    weighted_inputs_2 w97 (.inputs(inputs1_2), .w(w7_2[1]), .wi(weighted_inputs7_1));
    weighted_inputs_2 w98 (.inputs(inputs2_2), .w(w7_2[2]), .wi(weighted_inputs7_2));
    weighted_inputs_2 w99 (.inputs(inputs3_2), .w(w7_2[3]), .wi(weighted_inputs7_3));
    weighted_inputs_2 w100 (.inputs(inputs4_2), .w(w7_2[4]), .wi(weighted_inputs7_4));
    weighted_inputs_2 w101 (.inputs(inputs5_2), .w(w7_2[5]), .wi(weighted_inputs7_5));
    weighted_inputs_2 w102 (.inputs(inputs6_2), .w(w7_2[6]), .wi(weighted_inputs7_6));
    weighted_inputs_2 w103 (.inputs(inputs7_2), .w(w7_2[7]), .wi(weighted_inputs7_7));
    weighted_inputs_2 w104 (.inputs(inputs8_2), .w(w7_2[8]), .wi(weighted_inputs7_8));
    weighted_inputs_2 w105 (.inputs(inputs9_2), .w(w7_2[9]), .wi(weighted_inputs7_9));
    weighted_inputs_2 w106 (.inputs(inputs10_2), .w(w7_2[10]), .wi(weighted_inputs7_10));
    weighted_inputs_2 w107 (.inputs(inputs11_2), .w(w7_2[11]), .wi(weighted_inputs7_11));
    weighted_inputs_2 w108 (.inputs(inputs12_2), .w(w7_2[12]), .wi(weighted_inputs7_12));
    weighted_inputs_2 w109 (.inputs(inputs13_2), .w(w7_2[13]), .wi(weighted_inputs7_13));
    weighted_inputs_2 w110 (.inputs(inputs14_2), .w(w7_2[14]), .wi(weighted_inputs7_14));
    weighted_inputs_2 w111 (.inputs(inputs15_2), .w(w7_2[15]), .wi(weighted_inputs7_15));
    weighted_inputs_2 w112 (.inputs(inputs0_2), .w(w8_2[0]), .wi(weighted_inputs8_0));
    weighted_inputs_2 w113 (.inputs(inputs1_2), .w(w8_2[1]), .wi(weighted_inputs8_1));
    weighted_inputs_2 w114 (.inputs(inputs2_2), .w(w8_2[2]), .wi(weighted_inputs8_2));
    weighted_inputs_2 w115 (.inputs(inputs3_2), .w(w8_2[3]), .wi(weighted_inputs8_3));
    weighted_inputs_2 w116 (.inputs(inputs4_2), .w(w8_2[4]), .wi(weighted_inputs8_4));
    weighted_inputs_2 w117 (.inputs(inputs5_2), .w(w8_2[5]), .wi(weighted_inputs8_5));
    weighted_inputs_2 w118 (.inputs(inputs6_2), .w(w8_2[6]), .wi(weighted_inputs8_6));
    weighted_inputs_2 w119 (.inputs(inputs7_2), .w(w8_2[7]), .wi(weighted_inputs8_7));
    weighted_inputs_2 w120 (.inputs(inputs8_2), .w(w8_2[8]), .wi(weighted_inputs8_8));
    weighted_inputs_2 w121 (.inputs(inputs9_2), .w(w8_2[9]), .wi(weighted_inputs8_9));
    weighted_inputs_2 w122 (.inputs(inputs10_2), .w(w8_2[10]), .wi(weighted_inputs8_10));
    weighted_inputs_2 w123 (.inputs(inputs11_2), .w(w8_2[11]), .wi(weighted_inputs8_11));
    weighted_inputs_2 w124 (.inputs(inputs12_2), .w(w8_2[12]), .wi(weighted_inputs8_12));
    weighted_inputs_2 w125 (.inputs(inputs13_2), .w(w8_2[13]), .wi(weighted_inputs8_13));
    weighted_inputs_2 w126 (.inputs(inputs14_2), .w(w8_2[14]), .wi(weighted_inputs8_14));
    weighted_inputs_2 w127 (.inputs(inputs15_2), .w(w8_2[15]), .wi(weighted_inputs8_15));
    weighted_inputs_2 w128 (.inputs(inputs0_2), .w(w9_2[0]), .wi(weighted_inputs9_0));
    weighted_inputs_2 w129 (.inputs(inputs1_2), .w(w9_2[1]), .wi(weighted_inputs9_1));
    weighted_inputs_2 w130 (.inputs(inputs2_2), .w(w9_2[2]), .wi(weighted_inputs9_2));
    weighted_inputs_2 w131 (.inputs(inputs3_2), .w(w9_2[3]), .wi(weighted_inputs9_3));
    weighted_inputs_2 w132 (.inputs(inputs4_2), .w(w9_2[4]), .wi(weighted_inputs9_4));
    weighted_inputs_2 w133 (.inputs(inputs5_2), .w(w9_2[5]), .wi(weighted_inputs9_5));
    weighted_inputs_2 w134 (.inputs(inputs6_2), .w(w9_2[6]), .wi(weighted_inputs9_6));
    weighted_inputs_2 w135 (.inputs(inputs7_2), .w(w9_2[7]), .wi(weighted_inputs9_7));
    weighted_inputs_2 w136 (.inputs(inputs8_2), .w(w9_2[8]), .wi(weighted_inputs9_8));
    weighted_inputs_2 w137 (.inputs(inputs9_2), .w(w9_2[9]), .wi(weighted_inputs9_9));
    weighted_inputs_2 w138 (.inputs(inputs10_2), .w(w9_2[10]), .wi(weighted_inputs9_10));
    weighted_inputs_2 w139 (.inputs(inputs11_2), .w(w9_2[11]), .wi(weighted_inputs9_11));
    weighted_inputs_2 w140 (.inputs(inputs12_2), .w(w9_2[12]), .wi(weighted_inputs9_12));
    weighted_inputs_2 w141 (.inputs(inputs13_2), .w(w9_2[13]), .wi(weighted_inputs9_13));
    weighted_inputs_2 w142 (.inputs(inputs14_2), .w(w9_2[14]), .wi(weighted_inputs9_14));
    weighted_inputs_2 w143 (.inputs(inputs15_2), .w(w9_2[15]), .wi(weighted_inputs9_15));
    weighted_inputs_2 w144 (.inputs(inputs0_2), .w(w10_2[0]), .wi(weighted_inputs10_0));
    weighted_inputs_2 w145 (.inputs(inputs1_2), .w(w10_2[1]), .wi(weighted_inputs10_1));
    weighted_inputs_2 w146 (.inputs(inputs2_2), .w(w10_2[2]), .wi(weighted_inputs10_2));
    weighted_inputs_2 w147 (.inputs(inputs3_2), .w(w10_2[3]), .wi(weighted_inputs10_3));
    weighted_inputs_2 w148 (.inputs(inputs4_2), .w(w10_2[4]), .wi(weighted_inputs10_4));
    weighted_inputs_2 w149 (.inputs(inputs5_2), .w(w10_2[5]), .wi(weighted_inputs10_5));
    weighted_inputs_2 w150 (.inputs(inputs6_2), .w(w10_2[6]), .wi(weighted_inputs10_6));
    weighted_inputs_2 w151 (.inputs(inputs7_2), .w(w10_2[7]), .wi(weighted_inputs10_7));
    weighted_inputs_2 w152 (.inputs(inputs8_2), .w(w10_2[8]), .wi(weighted_inputs10_8));
    weighted_inputs_2 w153 (.inputs(inputs9_2), .w(w10_2[9]), .wi(weighted_inputs10_9));
    weighted_inputs_2 w154 (.inputs(inputs10_2), .w(w10_2[10]), .wi(weighted_inputs10_10));
    weighted_inputs_2 w155 (.inputs(inputs11_2), .w(w10_2[11]), .wi(weighted_inputs10_11));
    weighted_inputs_2 w156 (.inputs(inputs12_2), .w(w10_2[12]), .wi(weighted_inputs10_12));
    weighted_inputs_2 w157 (.inputs(inputs13_2), .w(w10_2[13]), .wi(weighted_inputs10_13));
    weighted_inputs_2 w158 (.inputs(inputs14_2), .w(w10_2[14]), .wi(weighted_inputs10_14));
    weighted_inputs_2 w159 (.inputs(inputs15_2), .w(w10_2[15]), .wi(weighted_inputs10_15));
    weighted_inputs_2 w160 (.inputs(inputs0_2), .w(w11_2[0]), .wi(weighted_inputs11_0));
    weighted_inputs_2 w161 (.inputs(inputs1_2), .w(w11_2[1]), .wi(weighted_inputs11_1));
    weighted_inputs_2 w162 (.inputs(inputs2_2), .w(w11_2[2]), .wi(weighted_inputs11_2));
    weighted_inputs_2 w163 (.inputs(inputs3_2), .w(w11_2[3]), .wi(weighted_inputs11_3));
    weighted_inputs_2 w164 (.inputs(inputs4_2), .w(w11_2[4]), .wi(weighted_inputs11_4));
    weighted_inputs_2 w165 (.inputs(inputs5_2), .w(w11_2[5]), .wi(weighted_inputs11_5));
    weighted_inputs_2 w166 (.inputs(inputs6_2), .w(w11_2[6]), .wi(weighted_inputs11_6));
    weighted_inputs_2 w167 (.inputs(inputs7_2), .w(w11_2[7]), .wi(weighted_inputs11_7));
    weighted_inputs_2 w168 (.inputs(inputs8_2), .w(w11_2[8]), .wi(weighted_inputs11_8));
    weighted_inputs_2 w169 (.inputs(inputs9_2), .w(w11_2[9]), .wi(weighted_inputs11_9));
    weighted_inputs_2 w170 (.inputs(inputs10_2), .w(w11_2[10]), .wi(weighted_inputs11_10));
    weighted_inputs_2 w171 (.inputs(inputs11_2), .w(w11_2[11]), .wi(weighted_inputs11_11));
    weighted_inputs_2 w172 (.inputs(inputs12_2), .w(w11_2[12]), .wi(weighted_inputs11_12));
    weighted_inputs_2 w173 (.inputs(inputs13_2), .w(w11_2[13]), .wi(weighted_inputs11_13));
    weighted_inputs_2 w174 (.inputs(inputs14_2), .w(w11_2[14]), .wi(weighted_inputs11_14));
    weighted_inputs_2 w175 (.inputs(inputs15_2), .w(w11_2[15]), .wi(weighted_inputs11_15));
    weighted_inputs_2 w176 (.inputs(inputs0_2), .w(w12_2[0]), .wi(weighted_inputs12_0));
    weighted_inputs_2 w177 (.inputs(inputs1_2), .w(w12_2[1]), .wi(weighted_inputs12_1));
    weighted_inputs_2 w178 (.inputs(inputs2_2), .w(w12_2[2]), .wi(weighted_inputs12_2));
    weighted_inputs_2 w179 (.inputs(inputs3_2), .w(w12_2[3]), .wi(weighted_inputs12_3));
    weighted_inputs_2 w180 (.inputs(inputs4_2), .w(w12_2[4]), .wi(weighted_inputs12_4));
    weighted_inputs_2 w181 (.inputs(inputs5_2), .w(w12_2[5]), .wi(weighted_inputs12_5));
    weighted_inputs_2 w182 (.inputs(inputs6_2), .w(w12_2[6]), .wi(weighted_inputs12_6));
    weighted_inputs_2 w183 (.inputs(inputs7_2), .w(w12_2[7]), .wi(weighted_inputs12_7));
    weighted_inputs_2 w184 (.inputs(inputs8_2), .w(w12_2[8]), .wi(weighted_inputs12_8));
    weighted_inputs_2 w185 (.inputs(inputs9_2), .w(w12_2[9]), .wi(weighted_inputs12_9));
    weighted_inputs_2 w186 (.inputs(inputs10_2), .w(w12_2[10]), .wi(weighted_inputs12_10));
    weighted_inputs_2 w187 (.inputs(inputs11_2), .w(w12_2[11]), .wi(weighted_inputs12_11));
    weighted_inputs_2 w188 (.inputs(inputs12_2), .w(w12_2[12]), .wi(weighted_inputs12_12));
    weighted_inputs_2 w189 (.inputs(inputs13_2), .w(w12_2[13]), .wi(weighted_inputs12_13));
    weighted_inputs_2 w190 (.inputs(inputs14_2), .w(w12_2[14]), .wi(weighted_inputs12_14));
    weighted_inputs_2 w191 (.inputs(inputs15_2), .w(w12_2[15]), .wi(weighted_inputs12_15));
    weighted_inputs_2 w192 (.inputs(inputs0_2), .w(w13_2[0]), .wi(weighted_inputs13_0));
    weighted_inputs_2 w193 (.inputs(inputs1_2), .w(w13_2[1]), .wi(weighted_inputs13_1));
    weighted_inputs_2 w194 (.inputs(inputs2_2), .w(w13_2[2]), .wi(weighted_inputs13_2));
    weighted_inputs_2 w195 (.inputs(inputs3_2), .w(w13_2[3]), .wi(weighted_inputs13_3));
    weighted_inputs_2 w196 (.inputs(inputs4_2), .w(w13_2[4]), .wi(weighted_inputs13_4));
    weighted_inputs_2 w197 (.inputs(inputs5_2), .w(w13_2[5]), .wi(weighted_inputs13_5));
    weighted_inputs_2 w198 (.inputs(inputs6_2), .w(w13_2[6]), .wi(weighted_inputs13_6));
    weighted_inputs_2 w199 (.inputs(inputs7_2), .w(w13_2[7]), .wi(weighted_inputs13_7));
    weighted_inputs_2 w200 (.inputs(inputs8_2), .w(w13_2[8]), .wi(weighted_inputs13_8));
    weighted_inputs_2 w201 (.inputs(inputs9_2), .w(w13_2[9]), .wi(weighted_inputs13_9));
    weighted_inputs_2 w202 (.inputs(inputs10_2), .w(w13_2[10]), .wi(weighted_inputs13_10));
    weighted_inputs_2 w203 (.inputs(inputs11_2), .w(w13_2[11]), .wi(weighted_inputs13_11));
    weighted_inputs_2 w204 (.inputs(inputs12_2), .w(w13_2[12]), .wi(weighted_inputs13_12));
    weighted_inputs_2 w205 (.inputs(inputs13_2), .w(w13_2[13]), .wi(weighted_inputs13_13));
    weighted_inputs_2 w206 (.inputs(inputs14_2), .w(w13_2[14]), .wi(weighted_inputs13_14));
    weighted_inputs_2 w207 (.inputs(inputs15_2), .w(w13_2[15]), .wi(weighted_inputs13_15));
    weighted_inputs_2 w208 (.inputs(inputs0_2), .w(w14_2[0]), .wi(weighted_inputs14_0));
    weighted_inputs_2 w209 (.inputs(inputs1_2), .w(w14_2[1]), .wi(weighted_inputs14_1));
    weighted_inputs_2 w210 (.inputs(inputs2_2), .w(w14_2[2]), .wi(weighted_inputs14_2));
    weighted_inputs_2 w211 (.inputs(inputs3_2), .w(w14_2[3]), .wi(weighted_inputs14_3));
    weighted_inputs_2 w212 (.inputs(inputs4_2), .w(w14_2[4]), .wi(weighted_inputs14_4));
    weighted_inputs_2 w213 (.inputs(inputs5_2), .w(w14_2[5]), .wi(weighted_inputs14_5));
    weighted_inputs_2 w214 (.inputs(inputs6_2), .w(w14_2[6]), .wi(weighted_inputs14_6));
    weighted_inputs_2 w215 (.inputs(inputs7_2), .w(w14_2[7]), .wi(weighted_inputs14_7));
    weighted_inputs_2 w216 (.inputs(inputs8_2), .w(w14_2[8]), .wi(weighted_inputs14_8));
    weighted_inputs_2 w217 (.inputs(inputs9_2), .w(w14_2[9]), .wi(weighted_inputs14_9));
    weighted_inputs_2 w218 (.inputs(inputs10_2), .w(w14_2[10]), .wi(weighted_inputs14_10));
    weighted_inputs_2 w219 (.inputs(inputs11_2), .w(w14_2[11]), .wi(weighted_inputs14_11));
    weighted_inputs_2 w220 (.inputs(inputs12_2), .w(w14_2[12]), .wi(weighted_inputs14_12));
    weighted_inputs_2 w221 (.inputs(inputs13_2), .w(w14_2[13]), .wi(weighted_inputs14_13));
    weighted_inputs_2 w222 (.inputs(inputs14_2), .w(w14_2[14]), .wi(weighted_inputs14_14));
    weighted_inputs_2 w223 (.inputs(inputs15_2), .w(w14_2[15]), .wi(weighted_inputs14_15));
    weighted_inputs_2 w224 (.inputs(inputs0_2), .w(w15_2[0]), .wi(weighted_inputs15_0));
    weighted_inputs_2 w225 (.inputs(inputs1_2), .w(w15_2[1]), .wi(weighted_inputs15_1));
    weighted_inputs_2 w226 (.inputs(inputs2_2), .w(w15_2[2]), .wi(weighted_inputs15_2));
    weighted_inputs_2 w227 (.inputs(inputs3_2), .w(w15_2[3]), .wi(weighted_inputs15_3));
    weighted_inputs_2 w228 (.inputs(inputs4_2), .w(w15_2[4]), .wi(weighted_inputs15_4));
    weighted_inputs_2 w229 (.inputs(inputs5_2), .w(w15_2[5]), .wi(weighted_inputs15_5));
    weighted_inputs_2 w230 (.inputs(inputs6_2), .w(w15_2[6]), .wi(weighted_inputs15_6));
    weighted_inputs_2 w231 (.inputs(inputs7_2), .w(w15_2[7]), .wi(weighted_inputs15_7));
    weighted_inputs_2 w232 (.inputs(inputs8_2), .w(w15_2[8]), .wi(weighted_inputs15_8));
    weighted_inputs_2 w233 (.inputs(inputs9_2), .w(w15_2[9]), .wi(weighted_inputs15_9));
    weighted_inputs_2 w234 (.inputs(inputs10_2), .w(w15_2[10]), .wi(weighted_inputs15_10));
    weighted_inputs_2 w235 (.inputs(inputs11_2), .w(w15_2[11]), .wi(weighted_inputs15_11));
    weighted_inputs_2 w236 (.inputs(inputs12_2), .w(w15_2[12]), .wi(weighted_inputs15_12));
    weighted_inputs_2 w237 (.inputs(inputs13_2), .w(w15_2[13]), .wi(weighted_inputs15_13));
    weighted_inputs_2 w238 (.inputs(inputs14_2), .w(w15_2[14]), .wi(weighted_inputs15_14));
    weighted_inputs_2 w239 (.inputs(inputs15_2), .w(w15_2[15]), .wi(weighted_inputs15_15));
    weighted_inputs_2 w240 (.inputs(inputs0_2), .w(w16_2[0]), .wi(weighted_inputs16_0));
    weighted_inputs_2 w241 (.inputs(inputs1_2), .w(w16_2[1]), .wi(weighted_inputs16_1));
    weighted_inputs_2 w242 (.inputs(inputs2_2), .w(w16_2[2]), .wi(weighted_inputs16_2));
    weighted_inputs_2 w243 (.inputs(inputs3_2), .w(w16_2[3]), .wi(weighted_inputs16_3));
    weighted_inputs_2 w244 (.inputs(inputs4_2), .w(w16_2[4]), .wi(weighted_inputs16_4));
    weighted_inputs_2 w245 (.inputs(inputs5_2), .w(w16_2[5]), .wi(weighted_inputs16_5));
    weighted_inputs_2 w246 (.inputs(inputs6_2), .w(w16_2[6]), .wi(weighted_inputs16_6));
    weighted_inputs_2 w247 (.inputs(inputs7_2), .w(w16_2[7]), .wi(weighted_inputs16_7));
    weighted_inputs_2 w248 (.inputs(inputs8_2), .w(w16_2[8]), .wi(weighted_inputs16_8));
    weighted_inputs_2 w249 (.inputs(inputs9_2), .w(w16_2[9]), .wi(weighted_inputs16_9));
    weighted_inputs_2 w250 (.inputs(inputs10_2), .w(w16_2[10]), .wi(weighted_inputs16_10));
    weighted_inputs_2 w251 (.inputs(inputs11_2), .w(w16_2[11]), .wi(weighted_inputs16_11));
    weighted_inputs_2 w252 (.inputs(inputs12_2), .w(w16_2[12]), .wi(weighted_inputs16_12));
    weighted_inputs_2 w253 (.inputs(inputs13_2), .w(w16_2[13]), .wi(weighted_inputs16_13));
    weighted_inputs_2 w254 (.inputs(inputs14_2), .w(w16_2[14]), .wi(weighted_inputs16_14));
    weighted_inputs_2 w255 (.inputs(inputs15_2), .w(w16_2[15]), .wi(weighted_inputs16_15));
    adder_tree_2 add0(
    .clk(clk), 
        .in0(weighted_inputs1_0),
        .in1(weighted_inputs1_1),
        .in2(weighted_inputs1_2),
        .in3(weighted_inputs1_3),
        .in4(weighted_inputs1_4),
        .in5(weighted_inputs1_5),
        .in6(weighted_inputs1_6),
        .in7(weighted_inputs1_7),
        .in8(weighted_inputs1_8),
        .in9(weighted_inputs1_9),
        .in10(weighted_inputs1_10),
        .in11(weighted_inputs1_11),
        .in12(weighted_inputs1_12),
        .in13(weighted_inputs1_13),
        .in14(weighted_inputs1_14),
        .in15(weighted_inputs1_15),
        .sum(sum1[0])
    );
    adder_tree_2 add1(
    .clk(clk), 
        .in0(weighted_inputs2_0),
        .in1(weighted_inputs2_1),
        .in2(weighted_inputs2_2),
        .in3(weighted_inputs2_3),
        .in4(weighted_inputs2_4),
        .in5(weighted_inputs2_5),
        .in6(weighted_inputs2_6),
        .in7(weighted_inputs2_7),
        .in8(weighted_inputs2_8),
        .in9(weighted_inputs2_9),
        .in10(weighted_inputs2_10),
        .in11(weighted_inputs2_11),
        .in12(weighted_inputs2_12),
        .in13(weighted_inputs2_13),
        .in14(weighted_inputs2_14),
        .in15(weighted_inputs2_15),
        .sum(sum1[1])
    );
    adder_tree_2 add2(
    .clk(clk), 
        .in0(weighted_inputs3_0),
        .in1(weighted_inputs3_1),
        .in2(weighted_inputs3_2),
        .in3(weighted_inputs3_3),
        .in4(weighted_inputs3_4),
        .in5(weighted_inputs3_5),
        .in6(weighted_inputs3_6),
        .in7(weighted_inputs3_7),
        .in8(weighted_inputs3_8),
        .in9(weighted_inputs3_9),
        .in10(weighted_inputs3_10),
        .in11(weighted_inputs3_11),
        .in12(weighted_inputs3_12),
        .in13(weighted_inputs3_13),
        .in14(weighted_inputs3_14),
        .in15(weighted_inputs3_15),
        .sum(sum1[2])
    );
    adder_tree_2 add3(
    .clk(clk), 
        .in0(weighted_inputs4_0),
        .in1(weighted_inputs4_1),
        .in2(weighted_inputs4_2),
        .in3(weighted_inputs4_3),
        .in4(weighted_inputs4_4),
        .in5(weighted_inputs4_5),
        .in6(weighted_inputs4_6),
        .in7(weighted_inputs4_7),
        .in8(weighted_inputs4_8),
        .in9(weighted_inputs4_9),
        .in10(weighted_inputs4_10),
        .in11(weighted_inputs4_11),
        .in12(weighted_inputs4_12),
        .in13(weighted_inputs4_13),
        .in14(weighted_inputs4_14),
        .in15(weighted_inputs4_15),
        .sum(sum1[3])
    );
    adder_tree_2 add4(
    .clk(clk), 
        .in0(weighted_inputs5_0),
        .in1(weighted_inputs5_1),
        .in2(weighted_inputs5_2),
        .in3(weighted_inputs5_3),
        .in4(weighted_inputs5_4),
        .in5(weighted_inputs5_5),
        .in6(weighted_inputs5_6),
        .in7(weighted_inputs5_7),
        .in8(weighted_inputs5_8),
        .in9(weighted_inputs5_9),
        .in10(weighted_inputs5_10),
        .in11(weighted_inputs5_11),
        .in12(weighted_inputs5_12),
        .in13(weighted_inputs5_13),
        .in14(weighted_inputs5_14),
        .in15(weighted_inputs5_15),
        .sum(sum1[4])
    );
    adder_tree_2 add5(
    .clk(clk), 
        .in0(weighted_inputs6_0),
        .in1(weighted_inputs6_1),
        .in2(weighted_inputs6_2),
        .in3(weighted_inputs6_3),
        .in4(weighted_inputs6_4),
        .in5(weighted_inputs6_5),
        .in6(weighted_inputs6_6),
        .in7(weighted_inputs6_7),
        .in8(weighted_inputs6_8),
        .in9(weighted_inputs6_9),
        .in10(weighted_inputs6_10),
        .in11(weighted_inputs6_11),
        .in12(weighted_inputs6_12),
        .in13(weighted_inputs6_13),
        .in14(weighted_inputs6_14),
        .in15(weighted_inputs6_15),
        .sum(sum1[5])
    );
    adder_tree_2 add6(
    .clk(clk), 
        .in0(weighted_inputs7_0),
        .in1(weighted_inputs7_1),
        .in2(weighted_inputs7_2),
        .in3(weighted_inputs7_3),
        .in4(weighted_inputs7_4),
        .in5(weighted_inputs7_5),
        .in6(weighted_inputs7_6),
        .in7(weighted_inputs7_7),
        .in8(weighted_inputs7_8),
        .in9(weighted_inputs7_9),
        .in10(weighted_inputs7_10),
        .in11(weighted_inputs7_11),
        .in12(weighted_inputs7_12),
        .in13(weighted_inputs7_13),
        .in14(weighted_inputs7_14),
        .in15(weighted_inputs7_15),
        .sum(sum1[6])
    );
    adder_tree_2 add7(
    .clk(clk), 
        .in0(weighted_inputs8_0),
        .in1(weighted_inputs8_1),
        .in2(weighted_inputs8_2),
        .in3(weighted_inputs8_3),
        .in4(weighted_inputs8_4),
        .in5(weighted_inputs8_5),
        .in6(weighted_inputs8_6),
        .in7(weighted_inputs8_7),
        .in8(weighted_inputs8_8),
        .in9(weighted_inputs8_9),
        .in10(weighted_inputs8_10),
        .in11(weighted_inputs8_11),
        .in12(weighted_inputs8_12),
        .in13(weighted_inputs8_13),
        .in14(weighted_inputs8_14),
        .in15(weighted_inputs8_15),
        .sum(sum1[7])
    );
    adder_tree_2 add8(
    .clk(clk), 
        .in0(weighted_inputs9_0),
        .in1(weighted_inputs9_1),
        .in2(weighted_inputs9_2),
        .in3(weighted_inputs9_3),
        .in4(weighted_inputs9_4),
        .in5(weighted_inputs9_5),
        .in6(weighted_inputs9_6),
        .in7(weighted_inputs9_7),
        .in8(weighted_inputs9_8),
        .in9(weighted_inputs9_9),
        .in10(weighted_inputs9_10),
        .in11(weighted_inputs9_11),
        .in12(weighted_inputs9_12),
        .in13(weighted_inputs9_13),
        .in14(weighted_inputs9_14),
        .in15(weighted_inputs9_15),
        .sum(sum1[8])
    );
    adder_tree_2 add9(
    .clk(clk), 
        .in0(weighted_inputs10_0),
        .in1(weighted_inputs10_1),
        .in2(weighted_inputs10_2),
        .in3(weighted_inputs10_3),
        .in4(weighted_inputs10_4),
        .in5(weighted_inputs10_5),
        .in6(weighted_inputs10_6),
        .in7(weighted_inputs10_7),
        .in8(weighted_inputs10_8),
        .in9(weighted_inputs10_9),
        .in10(weighted_inputs10_10),
        .in11(weighted_inputs10_11),
        .in12(weighted_inputs10_12),
        .in13(weighted_inputs10_13),
        .in14(weighted_inputs10_14),
        .in15(weighted_inputs10_15),
        .sum(sum1[9])
    );
    adder_tree_2 add10(
    .clk(clk), 
        .in0(weighted_inputs11_0),
        .in1(weighted_inputs11_1),
        .in2(weighted_inputs11_2),
        .in3(weighted_inputs11_3),
        .in4(weighted_inputs11_4),
        .in5(weighted_inputs11_5),
        .in6(weighted_inputs11_6),
        .in7(weighted_inputs11_7),
        .in8(weighted_inputs11_8),
        .in9(weighted_inputs11_9),
        .in10(weighted_inputs11_10),
        .in11(weighted_inputs11_11),
        .in12(weighted_inputs11_12),
        .in13(weighted_inputs11_13),
        .in14(weighted_inputs11_14),
        .in15(weighted_inputs11_15),
        .sum(sum1[10])
    );
    adder_tree_2 add11(
    .clk(clk), 
        .in0(weighted_inputs12_0),
        .in1(weighted_inputs12_1),
        .in2(weighted_inputs12_2),
        .in3(weighted_inputs12_3),
        .in4(weighted_inputs12_4),
        .in5(weighted_inputs12_5),
        .in6(weighted_inputs12_6),
        .in7(weighted_inputs12_7),
        .in8(weighted_inputs12_8),
        .in9(weighted_inputs12_9),
        .in10(weighted_inputs12_10),
        .in11(weighted_inputs12_11),
        .in12(weighted_inputs12_12),
        .in13(weighted_inputs12_13),
        .in14(weighted_inputs12_14),
        .in15(weighted_inputs12_15),
        .sum(sum1[11])
    );
    adder_tree_2 add12(
    .clk(clk), 
        .in0(weighted_inputs13_0),
        .in1(weighted_inputs13_1),
        .in2(weighted_inputs13_2),
        .in3(weighted_inputs13_3),
        .in4(weighted_inputs13_4),
        .in5(weighted_inputs13_5),
        .in6(weighted_inputs13_6),
        .in7(weighted_inputs13_7),
        .in8(weighted_inputs13_8),
        .in9(weighted_inputs13_9),
        .in10(weighted_inputs13_10),
        .in11(weighted_inputs13_11),
        .in12(weighted_inputs13_12),
        .in13(weighted_inputs13_13),
        .in14(weighted_inputs13_14),
        .in15(weighted_inputs13_15),
        .sum(sum1[12])
    );
    adder_tree_2 add13(
    .clk(clk), 
        .in0(weighted_inputs14_0),
        .in1(weighted_inputs14_1),
        .in2(weighted_inputs14_2),
        .in3(weighted_inputs14_3),
        .in4(weighted_inputs14_4),
        .in5(weighted_inputs14_5),
        .in6(weighted_inputs14_6),
        .in7(weighted_inputs14_7),
        .in8(weighted_inputs14_8),
        .in9(weighted_inputs14_9),
        .in10(weighted_inputs14_10),
        .in11(weighted_inputs14_11),
        .in12(weighted_inputs14_12),
        .in13(weighted_inputs14_13),
        .in14(weighted_inputs14_14),
        .in15(weighted_inputs14_15),
        .sum(sum1[13])
    );
    adder_tree_2 add14(
    .clk(clk), 
        .in0(weighted_inputs15_0),
        .in1(weighted_inputs15_1),
        .in2(weighted_inputs15_2),
        .in3(weighted_inputs15_3),
        .in4(weighted_inputs15_4),
        .in5(weighted_inputs15_5),
        .in6(weighted_inputs15_6),
        .in7(weighted_inputs15_7),
        .in8(weighted_inputs15_8),
        .in9(weighted_inputs15_9),
        .in10(weighted_inputs15_10),
        .in11(weighted_inputs15_11),
        .in12(weighted_inputs15_12),
        .in13(weighted_inputs15_13),
        .in14(weighted_inputs15_14),
        .in15(weighted_inputs15_15),
        .sum(sum1[14])
    );
    adder_tree_2 add15(
    .clk(clk), 
        .in0(weighted_inputs16_0),
        .in1(weighted_inputs16_1),
        .in2(weighted_inputs16_2),
        .in3(weighted_inputs16_3),
        .in4(weighted_inputs16_4),
        .in5(weighted_inputs16_5),
        .in6(weighted_inputs16_6),
        .in7(weighted_inputs16_7),
        .in8(weighted_inputs16_8),
        .in9(weighted_inputs16_9),
        .in10(weighted_inputs16_10),
        .in11(weighted_inputs16_11),
        .in12(weighted_inputs16_12),
        .in13(weighted_inputs16_13),
        .in14(weighted_inputs16_14),
        .in15(weighted_inputs16_15),
        .sum(sum1[15])
    );
    add5bit_2 u0 (.a(sum1[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1[0]));
    add5bit_2 u1 (.a(sum1[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1[1]));
    add5bit_2 u2 (.a(sum1[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1[2]));
    add5bit_2 u3 (.a(sum1[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1[3]));
    add5bit_2 u4 (.a(sum1[4]), .b(b5_2), .cin(1'b0), .y(biased_sum1[4]));
    add5bit_2 u5 (.a(sum1[5]), .b(b6_2), .cin(1'b0), .y(biased_sum1[5]));
    add5bit_2 u6 (.a(sum1[6]), .b(b7_2), .cin(1'b0), .y(biased_sum1[6]));
    add5bit_2 u7 (.a(sum1[7]), .b(b8_2), .cin(1'b0), .y(biased_sum1[7]));
    add5bit_2 u8 (.a(sum1[8]), .b(b9_2), .cin(1'b0), .y(biased_sum1[8]));
    add5bit_2 u9 (.a(sum1[9]), .b(b10_2), .cin(1'b0), .y(biased_sum1[9]));
    add5bit_2 u10 (.a(sum1[10]), .b(b11_2), .cin(1'b0), .y(biased_sum1[10]));
    add5bit_2 u11 (.a(sum1[11]), .b(b12_2), .cin(1'b0), .y(biased_sum1[11]));
    add5bit_2 u12 (.a(sum1[12]), .b(b13_2), .cin(1'b0), .y(biased_sum1[12]));
    add5bit_2 u13 (.a(sum1[13]), .b(b14_2), .cin(1'b0), .y(biased_sum1[13]));
    add5bit_2 u14 (.a(sum1[14]), .b(b15_2), .cin(1'b0), .y(biased_sum1[14]));
    add5bit_2 u15 (.a(sum1[15]), .b(b16_2), .cin(1'b0), .y(biased_sum1[15]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    assign biased_sum4_0 = biased_sum1[4];
    assign biased_sum5_0 = biased_sum1[5];
    assign biased_sum6_0 = biased_sum1[6];
    assign biased_sum7_0 = biased_sum1[7];
    assign biased_sum8_0 = biased_sum1[8];
    assign biased_sum9_0 = biased_sum1[9];
    assign biased_sum10_0 = biased_sum1[10];
    assign biased_sum11_0 = biased_sum1[11];
    assign biased_sum12_0 = biased_sum1[12];
    assign biased_sum13_0 = biased_sum1[13];
    assign biased_sum14_0 = biased_sum1[14];
    assign biased_sum15_0 = biased_sum1[15];
    always @(posedge clk) begin
        $display("----- BNN LAYER 2 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_2, inputs1_2, inputs2_2, inputs3_2, inputs4_2, inputs5_2, inputs6_2, inputs7_2, inputs8_2, inputs9_2, inputs10_2, inputs11_2, inputs12_2, inputs13_2, inputs14_2, inputs15_2);
        $display("Weights: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", w1_2, w2_2, w3_2, w4_2, w5_2, w6_2, w7_2, w8_2, w9_2, w10_2, w11_2, w12_2, w13_2, w14_2, w15_2, w16_2);
        $display("sum1: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7], sum1[8], sum1[9], sum1[10], sum1[11], sum1[12], sum1[13], sum1[14], sum1[15]);
        $display("biased_sum1: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7], biased_sum1[8], biased_sum1[9], biased_sum1[10], biased_sum1[11], biased_sum1[12], biased_sum1[13], biased_sum1[14], biased_sum1[15]);
    end
endmodule


module activation_2 (

    input [5:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[5] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_2 (
    input  [5:0] inputs0_0,
    input  [5:0] inputs1_0,
    input  [5:0] inputs2_0,
    input  [5:0] inputs3_0,
    input  [5:0] inputs4_0,
    input  [5:0] inputs5_0,
    input  [5:0] inputs6_0,
    input  [5:0] inputs7_0,
    input  [5:0] inputs8_0,
    input  [5:0] inputs9_0,
    input  [5:0] inputs10_0,
    input  [5:0] inputs11_0,
    input  [5:0] inputs12_0,
    input  [5:0] inputs13_0,
    input  [5:0] inputs14_0,
    input  [5:0] inputs15_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3,
    output wire activation4,
    output wire activation5,
    output wire activation6,
    output wire activation7,
    output wire activation8,
    output wire activation9,
    output wire activation10,
    output wire activation11,
    output wire activation12,
    output wire activation13,
    output wire activation14,
    output wire activation15
);

    activation_2 a0 (
        .inputs0_0(inputs0_0),
        .activation(activation0)
    );

    activation_2 a1 (
        .inputs0_0(inputs1_0),
        .activation(activation1)
    );

    activation_2 a2 (
        .inputs0_0(inputs2_0),
        .activation(activation2)
    );

    activation_2 a3 (
        .inputs0_0(inputs3_0),
        .activation(activation3)
    );

    activation_2 a4 (
        .inputs0_0(inputs4_0),
        .activation(activation4)
    );

    activation_2 a5 (
        .inputs0_0(inputs5_0),
        .activation(activation5)
    );

    activation_2 a6 (
        .inputs0_0(inputs6_0),
        .activation(activation6)
    );

    activation_2 a7 (
        .inputs0_0(inputs7_0),
        .activation(activation7)
    );

    activation_2 a8 (
        .inputs0_0(inputs8_0),
        .activation(activation8)
    );

    activation_2 a9 (
        .inputs0_0(inputs9_0),
        .activation(activation9)
    );

    activation_2 a10 (
        .inputs0_0(inputs10_0),
        .activation(activation10)
    );

    activation_2 a11 (
        .inputs0_0(inputs11_0),
        .activation(activation11)
    );

    activation_2 a12 (
        .inputs0_0(inputs12_0),
        .activation(activation12)
    );

    activation_2 a13 (
        .inputs0_0(inputs13_0),
        .activation(activation13)
    );

    activation_2 a14 (
        .inputs0_0(inputs14_0),
        .activation(activation14)
    );

    activation_2 a15 (
        .inputs0_0(inputs15_0),
        .activation(activation15)
    );

endmodule



module activation_and_conversion_2(
  input  wire clk, 
  input  wire [0:0] inputs0_2,
  input  wire [0:0] inputs1_2,
  input  wire [0:0] inputs2_2,
  input  wire [0:0] inputs3_2,
  input  wire [0:0] inputs4_2,
  input  wire [0:0] inputs5_2,
  input  wire [0:0] inputs6_2,
  input  wire [0:0] inputs7_2,
  input  wire [0:0] inputs8_2,
  input  wire [0:0] inputs9_2,
  input  wire [0:0] inputs10_2,
  input  wire [0:0] inputs11_2,
  input  wire [0:0] inputs12_2,
  input  wire [0:0] inputs13_2,
  input  wire [0:0] inputs14_2,
  input  wire [0:0] inputs15_2,
  input  wire [15:0] w1_2,
  input  wire [15:0] w2_2,
  input  wire [15:0] w3_2,
  input  wire [15:0] w4_2,
  input  wire [15:0] w5_2,
  input  wire [15:0] w6_2,
  input  wire [15:0] w7_2,
  input  wire [15:0] w8_2,
  input  wire [15:0] w9_2,
  input  wire [15:0] w10_2,
  input  wire [15:0] w11_2,
  input  wire [15:0] w12_2,
  input  wire [15:0] w13_2,
  input  wire [15:0] w14_2,
  input  wire [15:0] w15_2,
  input  wire [15:0] w16_2,
  input  wire [4:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2, b9_2, b10_2, b11_2, b12_2, b13_2, b14_2, b15_2, b16_2,
  output wire activation0_2, 

  output wire activation1_2, 

  output wire activation2_2, 

  output wire activation3_2, 

  output wire activation4_2, 

  output wire activation5_2, 

  output wire activation6_2, 

  output wire activation7_2, 

  output wire activation8_2, 

  output wire activation9_2, 

  output wire activation10_2, 

  output wire activation11_2, 

  output wire activation12_2, 

  output wire activation13_2, 

  output wire activation14_2, 

  output wire activation15_2
);

  wire [5:0] biased_sum0_0;
  wire [5:0] biased_sum1_0;
  wire [5:0] biased_sum2_0;
  wire [5:0] biased_sum3_0;
  wire [5:0] biased_sum4_0;
  wire [5:0] biased_sum5_0;
  wire [5:0] biased_sum6_0;
  wire [5:0] biased_sum7_0;
  wire [5:0] biased_sum8_0;
  wire [5:0] biased_sum9_0;
  wire [5:0] biased_sum10_0;
  wire [5:0] biased_sum11_0;
  wire [5:0] biased_sum12_0;
  wire [5:0] biased_sum13_0;
  wire [5:0] biased_sum14_0;
  wire [5:0] biased_sum15_0;

    layer2 l1 (
    .clk(clk),
    .inputs0_2(inputs0_2),
    .inputs1_2(inputs1_2),
    .inputs2_2(inputs2_2),
    .inputs3_2(inputs3_2),
    .inputs4_2(inputs4_2),
    .inputs5_2(inputs5_2),
    .inputs6_2(inputs6_2),
    .inputs7_2(inputs7_2),
    .inputs8_2(inputs8_2),
    .inputs9_2(inputs9_2),
    .inputs10_2(inputs10_2),
    .inputs11_2(inputs11_2),
    .inputs12_2(inputs12_2),
    .inputs13_2(inputs13_2),
    .inputs14_2(inputs14_2),
    .inputs15_2(inputs15_2),
    .w1_2(w1_2),
    .w2_2(w2_2),
    .w3_2(w3_2),
    .w4_2(w4_2),
    .w5_2(w5_2),
    .w6_2(w6_2),
    .w7_2(w7_2),
    .w8_2(w8_2),
    .w9_2(w9_2),
    .w10_2(w10_2),
    .w11_2(w11_2),
    .w12_2(w12_2),
    .w13_2(w13_2),
    .w14_2(w14_2),
    .w15_2(w15_2),
    .w16_2(w16_2),
    .b1_2(b1_2),
    .b2_2(b2_2),
    .b3_2(b3_2),
    .b4_2(b4_2),
    .b5_2(b5_2),
    .b6_2(b6_2),
    .b7_2(b7_2),
    .b8_2(b8_2),
    .b9_2(b9_2),
    .b10_2(b10_2),
    .b11_2(b11_2),
    .b12_2(b12_2),
    .b13_2(b13_2),
    .b14_2(b14_2),
    .b15_2(b15_2),
    .b16_2(b16_2),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0),
    .biased_sum4_0(biased_sum4_0),
    .biased_sum5_0(biased_sum5_0),
    .biased_sum6_0(biased_sum6_0),
    .biased_sum7_0(biased_sum7_0),
    .biased_sum8_0(biased_sum8_0),
    .biased_sum9_0(biased_sum9_0),
    .biased_sum10_0(biased_sum10_0),
    .biased_sum11_0(biased_sum11_0),
    .biased_sum12_0(biased_sum12_0),
    .biased_sum13_0(biased_sum13_0),
    .biased_sum14_0(biased_sum14_0),
    .biased_sum15_0(biased_sum15_0)
  );

    activation_array_2 act1 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .inputs4_0(biased_sum4_0),
    .inputs5_0(biased_sum5_0),
    .inputs6_0(biased_sum6_0),
    .inputs7_0(biased_sum7_0),
    .inputs8_0(biased_sum8_0),
    .inputs9_0(biased_sum9_0),
    .inputs10_0(biased_sum10_0),
    .inputs11_0(biased_sum11_0),
    .inputs12_0(biased_sum12_0),
    .inputs13_0(biased_sum13_0),
    .inputs14_0(biased_sum14_0),
    .inputs15_0(biased_sum15_0),
    .activation0(activation0_2),
    .activation1(activation1_2),
    .activation2(activation2_2),
    .activation3(activation3_2),
    .activation4(activation4_2),
    .activation5(activation5_2),
    .activation6(activation6_2),
    .activation7(activation7_2),
    .activation8(activation8_2),
    .activation9(activation9_2),
    .activation10(activation10_2),
    .activation11(activation11_2),
    .activation12(activation12_2),
    .activation13(activation13_2),
    .activation14(activation14_2),
    .activation15(activation15_2)
  );

    activation_array_2 act2 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .inputs4_0(biased_sum4_0),
    .inputs5_0(biased_sum5_0),
    .inputs6_0(biased_sum6_0),
    .inputs7_0(biased_sum7_0),
    .inputs8_0(biased_sum8_0),
    .inputs9_0(biased_sum9_0),
    .inputs10_0(biased_sum10_0),
    .inputs11_0(biased_sum11_0),
    .inputs12_0(biased_sum12_0),
    .inputs13_0(biased_sum13_0),
    .inputs14_0(biased_sum14_0),
    .inputs15_0(biased_sum15_0),
    .activation0(activation0_2),
    .activation1(activation1_2),
    .activation2(activation2_2),
    .activation3(activation3_2),
    .activation4(activation4_2),
    .activation5(activation5_2),
    .activation6(activation6_2),
    .activation7(activation7_2),
    .activation8(activation8_2),
    .activation9(activation9_2),
    .activation10(activation10_2),
    .activation11(activation11_2),
    .activation12(activation12_2),
    .activation13(activation13_2),
    .activation14(activation14_2),
    .activation15(activation15_2)
  );

    always @(posedge clk) begin
    $display("----- LAYER 2   boolean activations -----");
    $display("activation : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", activation0_2, activation1_2, activation2_2, activation3_2, activation4_2, activation5_2, activation6_2, activation7_2, activation8_2, activation9_2, activation10_2, activation11_2, activation12_2, activation13_2, activation14_2, activation15_2);
  end


endmodule




// ----- LAYER 3 -----
module half_adder_3(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adder_3(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adder_3 HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adder_3 HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNAND_3(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule

module add1bit_3(
    input wire [0:0] a,
    input wire [0:0] b,
    input wire  cin,
    output wire [1:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;

full_adder_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));

WddlNAND_3 wn1(.A(~a[0]), .B(b[0]), .C(~c1), .S(s1), .S1(s1_1));
WddlNAND_3 wn2(.A(a[0]), .B(~b[0]), .C(~c1), .S(s2), .S1(s2_1));
WddlNAND_3 wn3(.A(a[0]), .B(b[0]), .C(c1), .S(s3), .S1(s3_1));
WddlNAND_3 wn4(.A(~a[0]), .B(~b[0]), .C(c1), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[1] = cout;

endmodule

module add2bit_3(
    input wire [1:0] a,
    input wire [1:0] b,
    input wire  cin,
    output wire [2:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;

full_adder_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));

WddlNAND_3 wn1(.A(~a[1]), .B(b[1]), .C(~c2), .S(s1), .S1(s1_1));
WddlNAND_3 wn2(.A(a[1]), .B(~b[1]), .C(~c2), .S(s2), .S1(s2_1));
WddlNAND_3 wn3(.A(a[1]), .B(b[1]), .C(c2), .S(s3), .S1(s3_1));
WddlNAND_3 wn4(.A(~a[1]), .B(~b[1]), .C(c2), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[2] = cout;

endmodule

module add3bit_3(
    input wire [2:0] a,
    input wire [2:0] b,
    input wire  cin,
    output wire [3:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;

full_adder_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNAND_3 wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNAND_3 wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNAND_3 wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNAND_3 wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout;

endmodule

module add4bit_3(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire  cin,
    output wire [4:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;

full_adder_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_3 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNAND_3 wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNAND_3 wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNAND_3 wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNAND_3 wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout;

endmodule

module add5bit_3(
    input wire [4:0] a,
    input wire [4:0] b,
    input wire  cin,
    output wire [5:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;

full_adder_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_3 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_3 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNAND_3 wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNAND_3 wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNAND_3 wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNAND_3 wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout;

endmodule



module adder_tree_3 (
    input  wire   clk, 
    input  wire [0:0] in0,
    input  wire [0:0] in1,
    input  wire [0:0] in2,
    input  wire [0:0] in3,
    input  wire [0:0] in4,
    input  wire [0:0] in5,
    input  wire [0:0] in6,
    input  wire [0:0] in7,
    input  wire [0:0] in8,
    input  wire [0:0] in9,
    input  wire [0:0] in10,
    input  wire [0:0] in11,
    input  wire [0:0] in12,
    input  wire [0:0] in13,
    input  wire [0:0] in14,
    input  wire [0:0] in15,
    output wire [4:0] sum
);

    wire [1:0] stage0_0_lo_3;
    wire [1:0] stage0_1_lo_3;
    wire [1:0] stage0_2_lo_3;
    wire [1:0] stage0_3_lo_3;
    wire [1:0] stage0_4_lo_3;
    wire [1:0] stage0_5_lo_3;
    wire [1:0] stage0_6_lo_3;
    wire [1:0] stage0_7_lo_3;
    wire [2:0] stage1_0_lo_3;
    wire [2:0] stage1_1_lo_3;
    wire [2:0] stage1_2_lo_3;
    wire [2:0] stage1_3_lo_3;
    wire [3:0] stage2_0_lo_3;
    wire [3:0] stage2_1_lo_3;
    wire [4:0] stage3_0_lo_3;
    reg  [1:0] stage0_0_3;
    reg  [1:0] stage0_1_3;
    reg  [1:0] stage0_2_3;
    reg  [1:0] stage0_3_3;
    reg  [1:0] stage0_4_3;
    reg  [1:0] stage0_5_3;
    reg  [1:0] stage0_6_3;
    reg  [1:0] stage0_7_3;
    reg  [2:0] stage1_0_3;
    reg  [2:0] stage1_1_3;
    reg  [2:0] stage1_2_3;
    reg  [2:0] stage1_3_3;
    reg  [3:0] stage2_0_3;
    reg  [3:0] stage2_1_3;
    reg  [4:0] stage3_0_3;

    add1bit_3 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_3), .cout(), .cout_bar());
    add2bit_3 u1_0 (.a(stage0_0_3), .b(stage0_1_3), .cin(1'b0), .y(stage1_0_lo_3), .cout(), .cout_bar());
    add2bit_3 u1_1 (.a(stage0_2_3), .b(stage0_3_3), .cin(1'b0), .y(stage1_1_lo_3), .cout(), .cout_bar());
    add2bit_3 u1_2 (.a(stage0_4_3), .b(stage0_5_3), .cin(1'b0), .y(stage1_2_lo_3), .cout(), .cout_bar());
    add2bit_3 u1_3 (.a(stage0_6_3), .b(stage0_7_3), .cin(1'b0), .y(stage1_3_lo_3), .cout(), .cout_bar());
    add3bit_3 u2_0 (.a(stage1_0_3), .b(stage1_1_3), .cin(1'b0), .y(stage2_0_lo_3), .cout(), .cout_bar());
    add3bit_3 u2_1 (.a(stage1_2_3), .b(stage1_3_3), .cin(1'b0), .y(stage2_1_lo_3), .cout(), .cout_bar());
    add4bit_3 u3_0 (.a(stage2_0_3), .b(stage2_1_3), .cin(1'b0), .y(stage3_0_lo_3), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_3;

    always @(posedge clk) begin
        stage0_0_3 <=  stage0_0_lo_3;
        stage0_1_3 <=  stage0_1_lo_3;
        stage0_2_3 <=  stage0_2_lo_3;
        stage0_3_3 <=  stage0_3_lo_3;
        stage0_4_3 <=  stage0_4_lo_3;
        stage0_5_3 <=  stage0_5_lo_3;
        stage0_6_3 <=  stage0_6_lo_3;
        stage0_7_3 <=  stage0_7_lo_3;
        stage1_0_3 <=  stage1_0_lo_3;
        stage1_1_3 <=  stage1_1_lo_3;
        stage1_2_3 <=  stage1_2_lo_3;
        stage1_3_3 <=  stage1_3_lo_3;
        stage2_0_3 <=  stage2_0_lo_3;
        stage2_1_3 <=  stage2_1_lo_3;
        stage3_0_3 <=  stage3_0_lo_3;
    end
endmodule


module layer3(
    input clk,
    input [0:0] inputs0_3 , inputs1_3 , inputs2_3 , inputs3_3 , inputs4_3 , inputs5_3 , inputs6_3 , inputs7_3 , inputs8_3 , inputs9_3 , inputs10_3 , inputs11_3 , inputs12_3 , inputs13_3 , inputs14_3 , inputs15_3,
    input [15:0] w1_3, w2_3, w3_3, w4_3, w5_3, w6_3, w7_3, w8_3, w9_3, w10_3, w11_3, w12_3, w13_3, w14_3, w15_3, w16_3,
    input [4:0] b1_3, b2_3, b3_3, b4_3, b5_3, b6_3, b7_3, b8_3, b9_3, b10_3, b11_3, b12_3, b13_3, b14_3, b15_3, b16_3,
    output [5:0] biased_sum0_0 , biased_sum1_0 , biased_sum2_0 , biased_sum3_0 , biased_sum4_0 , biased_sum5_0 , biased_sum6_0 , biased_sum7_0 , biased_sum8_0 , biased_sum9_0 , biased_sum10_0 , biased_sum11_0 , biased_sum12_0 , biased_sum13_0 , biased_sum14_0 , biased_sum15_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs1_4;
    wire [0:0] weighted_inputs1_5;
    wire [0:0] weighted_inputs1_6;
    wire [0:0] weighted_inputs1_7;
    wire [0:0] weighted_inputs1_8;
    wire [0:0] weighted_inputs1_9;
    wire [0:0] weighted_inputs1_10;
    wire [0:0] weighted_inputs1_11;
    wire [0:0] weighted_inputs1_12;
    wire [0:0] weighted_inputs1_13;
    wire [0:0] weighted_inputs1_14;
    wire [0:0] weighted_inputs1_15;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;
    wire [0:0] weighted_inputs2_4;
    wire [0:0] weighted_inputs2_5;
    wire [0:0] weighted_inputs2_6;
    wire [0:0] weighted_inputs2_7;
    wire [0:0] weighted_inputs2_8;
    wire [0:0] weighted_inputs2_9;
    wire [0:0] weighted_inputs2_10;
    wire [0:0] weighted_inputs2_11;
    wire [0:0] weighted_inputs2_12;
    wire [0:0] weighted_inputs2_13;
    wire [0:0] weighted_inputs2_14;
    wire [0:0] weighted_inputs2_15;
    wire [0:0] weighted_inputs3_0;
    wire [0:0] weighted_inputs3_1;
    wire [0:0] weighted_inputs3_2;
    wire [0:0] weighted_inputs3_3;
    wire [0:0] weighted_inputs3_4;
    wire [0:0] weighted_inputs3_5;
    wire [0:0] weighted_inputs3_6;
    wire [0:0] weighted_inputs3_7;
    wire [0:0] weighted_inputs3_8;
    wire [0:0] weighted_inputs3_9;
    wire [0:0] weighted_inputs3_10;
    wire [0:0] weighted_inputs3_11;
    wire [0:0] weighted_inputs3_12;
    wire [0:0] weighted_inputs3_13;
    wire [0:0] weighted_inputs3_14;
    wire [0:0] weighted_inputs3_15;
    wire [0:0] weighted_inputs4_0;
    wire [0:0] weighted_inputs4_1;
    wire [0:0] weighted_inputs4_2;
    wire [0:0] weighted_inputs4_3;
    wire [0:0] weighted_inputs4_4;
    wire [0:0] weighted_inputs4_5;
    wire [0:0] weighted_inputs4_6;
    wire [0:0] weighted_inputs4_7;
    wire [0:0] weighted_inputs4_8;
    wire [0:0] weighted_inputs4_9;
    wire [0:0] weighted_inputs4_10;
    wire [0:0] weighted_inputs4_11;
    wire [0:0] weighted_inputs4_12;
    wire [0:0] weighted_inputs4_13;
    wire [0:0] weighted_inputs4_14;
    wire [0:0] weighted_inputs4_15;
    wire [0:0] weighted_inputs5_0;
    wire [0:0] weighted_inputs5_1;
    wire [0:0] weighted_inputs5_2;
    wire [0:0] weighted_inputs5_3;
    wire [0:0] weighted_inputs5_4;
    wire [0:0] weighted_inputs5_5;
    wire [0:0] weighted_inputs5_6;
    wire [0:0] weighted_inputs5_7;
    wire [0:0] weighted_inputs5_8;
    wire [0:0] weighted_inputs5_9;
    wire [0:0] weighted_inputs5_10;
    wire [0:0] weighted_inputs5_11;
    wire [0:0] weighted_inputs5_12;
    wire [0:0] weighted_inputs5_13;
    wire [0:0] weighted_inputs5_14;
    wire [0:0] weighted_inputs5_15;
    wire [0:0] weighted_inputs6_0;
    wire [0:0] weighted_inputs6_1;
    wire [0:0] weighted_inputs6_2;
    wire [0:0] weighted_inputs6_3;
    wire [0:0] weighted_inputs6_4;
    wire [0:0] weighted_inputs6_5;
    wire [0:0] weighted_inputs6_6;
    wire [0:0] weighted_inputs6_7;
    wire [0:0] weighted_inputs6_8;
    wire [0:0] weighted_inputs6_9;
    wire [0:0] weighted_inputs6_10;
    wire [0:0] weighted_inputs6_11;
    wire [0:0] weighted_inputs6_12;
    wire [0:0] weighted_inputs6_13;
    wire [0:0] weighted_inputs6_14;
    wire [0:0] weighted_inputs6_15;
    wire [0:0] weighted_inputs7_0;
    wire [0:0] weighted_inputs7_1;
    wire [0:0] weighted_inputs7_2;
    wire [0:0] weighted_inputs7_3;
    wire [0:0] weighted_inputs7_4;
    wire [0:0] weighted_inputs7_5;
    wire [0:0] weighted_inputs7_6;
    wire [0:0] weighted_inputs7_7;
    wire [0:0] weighted_inputs7_8;
    wire [0:0] weighted_inputs7_9;
    wire [0:0] weighted_inputs7_10;
    wire [0:0] weighted_inputs7_11;
    wire [0:0] weighted_inputs7_12;
    wire [0:0] weighted_inputs7_13;
    wire [0:0] weighted_inputs7_14;
    wire [0:0] weighted_inputs7_15;
    wire [0:0] weighted_inputs8_0;
    wire [0:0] weighted_inputs8_1;
    wire [0:0] weighted_inputs8_2;
    wire [0:0] weighted_inputs8_3;
    wire [0:0] weighted_inputs8_4;
    wire [0:0] weighted_inputs8_5;
    wire [0:0] weighted_inputs8_6;
    wire [0:0] weighted_inputs8_7;
    wire [0:0] weighted_inputs8_8;
    wire [0:0] weighted_inputs8_9;
    wire [0:0] weighted_inputs8_10;
    wire [0:0] weighted_inputs8_11;
    wire [0:0] weighted_inputs8_12;
    wire [0:0] weighted_inputs8_13;
    wire [0:0] weighted_inputs8_14;
    wire [0:0] weighted_inputs8_15;
    wire [0:0] weighted_inputs9_0;
    wire [0:0] weighted_inputs9_1;
    wire [0:0] weighted_inputs9_2;
    wire [0:0] weighted_inputs9_3;
    wire [0:0] weighted_inputs9_4;
    wire [0:0] weighted_inputs9_5;
    wire [0:0] weighted_inputs9_6;
    wire [0:0] weighted_inputs9_7;
    wire [0:0] weighted_inputs9_8;
    wire [0:0] weighted_inputs9_9;
    wire [0:0] weighted_inputs9_10;
    wire [0:0] weighted_inputs9_11;
    wire [0:0] weighted_inputs9_12;
    wire [0:0] weighted_inputs9_13;
    wire [0:0] weighted_inputs9_14;
    wire [0:0] weighted_inputs9_15;
    wire [0:0] weighted_inputs10_0;
    wire [0:0] weighted_inputs10_1;
    wire [0:0] weighted_inputs10_2;
    wire [0:0] weighted_inputs10_3;
    wire [0:0] weighted_inputs10_4;
    wire [0:0] weighted_inputs10_5;
    wire [0:0] weighted_inputs10_6;
    wire [0:0] weighted_inputs10_7;
    wire [0:0] weighted_inputs10_8;
    wire [0:0] weighted_inputs10_9;
    wire [0:0] weighted_inputs10_10;
    wire [0:0] weighted_inputs10_11;
    wire [0:0] weighted_inputs10_12;
    wire [0:0] weighted_inputs10_13;
    wire [0:0] weighted_inputs10_14;
    wire [0:0] weighted_inputs10_15;
    wire [0:0] weighted_inputs11_0;
    wire [0:0] weighted_inputs11_1;
    wire [0:0] weighted_inputs11_2;
    wire [0:0] weighted_inputs11_3;
    wire [0:0] weighted_inputs11_4;
    wire [0:0] weighted_inputs11_5;
    wire [0:0] weighted_inputs11_6;
    wire [0:0] weighted_inputs11_7;
    wire [0:0] weighted_inputs11_8;
    wire [0:0] weighted_inputs11_9;
    wire [0:0] weighted_inputs11_10;
    wire [0:0] weighted_inputs11_11;
    wire [0:0] weighted_inputs11_12;
    wire [0:0] weighted_inputs11_13;
    wire [0:0] weighted_inputs11_14;
    wire [0:0] weighted_inputs11_15;
    wire [0:0] weighted_inputs12_0;
    wire [0:0] weighted_inputs12_1;
    wire [0:0] weighted_inputs12_2;
    wire [0:0] weighted_inputs12_3;
    wire [0:0] weighted_inputs12_4;
    wire [0:0] weighted_inputs12_5;
    wire [0:0] weighted_inputs12_6;
    wire [0:0] weighted_inputs12_7;
    wire [0:0] weighted_inputs12_8;
    wire [0:0] weighted_inputs12_9;
    wire [0:0] weighted_inputs12_10;
    wire [0:0] weighted_inputs12_11;
    wire [0:0] weighted_inputs12_12;
    wire [0:0] weighted_inputs12_13;
    wire [0:0] weighted_inputs12_14;
    wire [0:0] weighted_inputs12_15;
    wire [0:0] weighted_inputs13_0;
    wire [0:0] weighted_inputs13_1;
    wire [0:0] weighted_inputs13_2;
    wire [0:0] weighted_inputs13_3;
    wire [0:0] weighted_inputs13_4;
    wire [0:0] weighted_inputs13_5;
    wire [0:0] weighted_inputs13_6;
    wire [0:0] weighted_inputs13_7;
    wire [0:0] weighted_inputs13_8;
    wire [0:0] weighted_inputs13_9;
    wire [0:0] weighted_inputs13_10;
    wire [0:0] weighted_inputs13_11;
    wire [0:0] weighted_inputs13_12;
    wire [0:0] weighted_inputs13_13;
    wire [0:0] weighted_inputs13_14;
    wire [0:0] weighted_inputs13_15;
    wire [0:0] weighted_inputs14_0;
    wire [0:0] weighted_inputs14_1;
    wire [0:0] weighted_inputs14_2;
    wire [0:0] weighted_inputs14_3;
    wire [0:0] weighted_inputs14_4;
    wire [0:0] weighted_inputs14_5;
    wire [0:0] weighted_inputs14_6;
    wire [0:0] weighted_inputs14_7;
    wire [0:0] weighted_inputs14_8;
    wire [0:0] weighted_inputs14_9;
    wire [0:0] weighted_inputs14_10;
    wire [0:0] weighted_inputs14_11;
    wire [0:0] weighted_inputs14_12;
    wire [0:0] weighted_inputs14_13;
    wire [0:0] weighted_inputs14_14;
    wire [0:0] weighted_inputs14_15;
    wire [0:0] weighted_inputs15_0;
    wire [0:0] weighted_inputs15_1;
    wire [0:0] weighted_inputs15_2;
    wire [0:0] weighted_inputs15_3;
    wire [0:0] weighted_inputs15_4;
    wire [0:0] weighted_inputs15_5;
    wire [0:0] weighted_inputs15_6;
    wire [0:0] weighted_inputs15_7;
    wire [0:0] weighted_inputs15_8;
    wire [0:0] weighted_inputs15_9;
    wire [0:0] weighted_inputs15_10;
    wire [0:0] weighted_inputs15_11;
    wire [0:0] weighted_inputs15_12;
    wire [0:0] weighted_inputs15_13;
    wire [0:0] weighted_inputs15_14;
    wire [0:0] weighted_inputs15_15;
    wire [0:0] weighted_inputs16_0;
    wire [0:0] weighted_inputs16_1;
    wire [0:0] weighted_inputs16_2;
    wire [0:0] weighted_inputs16_3;
    wire [0:0] weighted_inputs16_4;
    wire [0:0] weighted_inputs16_5;
    wire [0:0] weighted_inputs16_6;
    wire [0:0] weighted_inputs16_7;
    wire [0:0] weighted_inputs16_8;
    wire [0:0] weighted_inputs16_9;
    wire [0:0] weighted_inputs16_10;
    wire [0:0] weighted_inputs16_11;
    wire [0:0] weighted_inputs16_12;
    wire [0:0] weighted_inputs16_13;
    wire [0:0] weighted_inputs16_14;
    wire [0:0] weighted_inputs16_15;

    wire [4:0] sum1 [15:0];
    wire [5:0] biased_sum1 [15:0];

    weighted_inputs_2 w0 (.inputs(inputs0_3), .w(w1_3[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_3), .w(w1_3[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_3), .w(w1_3[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_3), .w(w1_3[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs4_3), .w(w1_3[4]), .wi(weighted_inputs1_4));
    weighted_inputs_2 w5 (.inputs(inputs5_3), .w(w1_3[5]), .wi(weighted_inputs1_5));
    weighted_inputs_2 w6 (.inputs(inputs6_3), .w(w1_3[6]), .wi(weighted_inputs1_6));
    weighted_inputs_2 w7 (.inputs(inputs7_3), .w(w1_3[7]), .wi(weighted_inputs1_7));
    weighted_inputs_2 w8 (.inputs(inputs8_3), .w(w1_3[8]), .wi(weighted_inputs1_8));
    weighted_inputs_2 w9 (.inputs(inputs9_3), .w(w1_3[9]), .wi(weighted_inputs1_9));
    weighted_inputs_2 w10 (.inputs(inputs10_3), .w(w1_3[10]), .wi(weighted_inputs1_10));
    weighted_inputs_2 w11 (.inputs(inputs11_3), .w(w1_3[11]), .wi(weighted_inputs1_11));
    weighted_inputs_2 w12 (.inputs(inputs12_3), .w(w1_3[12]), .wi(weighted_inputs1_12));
    weighted_inputs_2 w13 (.inputs(inputs13_3), .w(w1_3[13]), .wi(weighted_inputs1_13));
    weighted_inputs_2 w14 (.inputs(inputs14_3), .w(w1_3[14]), .wi(weighted_inputs1_14));
    weighted_inputs_2 w15 (.inputs(inputs15_3), .w(w1_3[15]), .wi(weighted_inputs1_15));
    weighted_inputs_2 w16 (.inputs(inputs0_3), .w(w2_3[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w17 (.inputs(inputs1_3), .w(w2_3[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w18 (.inputs(inputs2_3), .w(w2_3[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w19 (.inputs(inputs3_3), .w(w2_3[3]), .wi(weighted_inputs2_3));
    weighted_inputs_2 w20 (.inputs(inputs4_3), .w(w2_3[4]), .wi(weighted_inputs2_4));
    weighted_inputs_2 w21 (.inputs(inputs5_3), .w(w2_3[5]), .wi(weighted_inputs2_5));
    weighted_inputs_2 w22 (.inputs(inputs6_3), .w(w2_3[6]), .wi(weighted_inputs2_6));
    weighted_inputs_2 w23 (.inputs(inputs7_3), .w(w2_3[7]), .wi(weighted_inputs2_7));
    weighted_inputs_2 w24 (.inputs(inputs8_3), .w(w2_3[8]), .wi(weighted_inputs2_8));
    weighted_inputs_2 w25 (.inputs(inputs9_3), .w(w2_3[9]), .wi(weighted_inputs2_9));
    weighted_inputs_2 w26 (.inputs(inputs10_3), .w(w2_3[10]), .wi(weighted_inputs2_10));
    weighted_inputs_2 w27 (.inputs(inputs11_3), .w(w2_3[11]), .wi(weighted_inputs2_11));
    weighted_inputs_2 w28 (.inputs(inputs12_3), .w(w2_3[12]), .wi(weighted_inputs2_12));
    weighted_inputs_2 w29 (.inputs(inputs13_3), .w(w2_3[13]), .wi(weighted_inputs2_13));
    weighted_inputs_2 w30 (.inputs(inputs14_3), .w(w2_3[14]), .wi(weighted_inputs2_14));
    weighted_inputs_2 w31 (.inputs(inputs15_3), .w(w2_3[15]), .wi(weighted_inputs2_15));
    weighted_inputs_2 w32 (.inputs(inputs0_3), .w(w3_3[0]), .wi(weighted_inputs3_0));
    weighted_inputs_2 w33 (.inputs(inputs1_3), .w(w3_3[1]), .wi(weighted_inputs3_1));
    weighted_inputs_2 w34 (.inputs(inputs2_3), .w(w3_3[2]), .wi(weighted_inputs3_2));
    weighted_inputs_2 w35 (.inputs(inputs3_3), .w(w3_3[3]), .wi(weighted_inputs3_3));
    weighted_inputs_2 w36 (.inputs(inputs4_3), .w(w3_3[4]), .wi(weighted_inputs3_4));
    weighted_inputs_2 w37 (.inputs(inputs5_3), .w(w3_3[5]), .wi(weighted_inputs3_5));
    weighted_inputs_2 w38 (.inputs(inputs6_3), .w(w3_3[6]), .wi(weighted_inputs3_6));
    weighted_inputs_2 w39 (.inputs(inputs7_3), .w(w3_3[7]), .wi(weighted_inputs3_7));
    weighted_inputs_2 w40 (.inputs(inputs8_3), .w(w3_3[8]), .wi(weighted_inputs3_8));
    weighted_inputs_2 w41 (.inputs(inputs9_3), .w(w3_3[9]), .wi(weighted_inputs3_9));
    weighted_inputs_2 w42 (.inputs(inputs10_3), .w(w3_3[10]), .wi(weighted_inputs3_10));
    weighted_inputs_2 w43 (.inputs(inputs11_3), .w(w3_3[11]), .wi(weighted_inputs3_11));
    weighted_inputs_2 w44 (.inputs(inputs12_3), .w(w3_3[12]), .wi(weighted_inputs3_12));
    weighted_inputs_2 w45 (.inputs(inputs13_3), .w(w3_3[13]), .wi(weighted_inputs3_13));
    weighted_inputs_2 w46 (.inputs(inputs14_3), .w(w3_3[14]), .wi(weighted_inputs3_14));
    weighted_inputs_2 w47 (.inputs(inputs15_3), .w(w3_3[15]), .wi(weighted_inputs3_15));
    weighted_inputs_2 w48 (.inputs(inputs0_3), .w(w4_3[0]), .wi(weighted_inputs4_0));
    weighted_inputs_2 w49 (.inputs(inputs1_3), .w(w4_3[1]), .wi(weighted_inputs4_1));
    weighted_inputs_2 w50 (.inputs(inputs2_3), .w(w4_3[2]), .wi(weighted_inputs4_2));
    weighted_inputs_2 w51 (.inputs(inputs3_3), .w(w4_3[3]), .wi(weighted_inputs4_3));
    weighted_inputs_2 w52 (.inputs(inputs4_3), .w(w4_3[4]), .wi(weighted_inputs4_4));
    weighted_inputs_2 w53 (.inputs(inputs5_3), .w(w4_3[5]), .wi(weighted_inputs4_5));
    weighted_inputs_2 w54 (.inputs(inputs6_3), .w(w4_3[6]), .wi(weighted_inputs4_6));
    weighted_inputs_2 w55 (.inputs(inputs7_3), .w(w4_3[7]), .wi(weighted_inputs4_7));
    weighted_inputs_2 w56 (.inputs(inputs8_3), .w(w4_3[8]), .wi(weighted_inputs4_8));
    weighted_inputs_2 w57 (.inputs(inputs9_3), .w(w4_3[9]), .wi(weighted_inputs4_9));
    weighted_inputs_2 w58 (.inputs(inputs10_3), .w(w4_3[10]), .wi(weighted_inputs4_10));
    weighted_inputs_2 w59 (.inputs(inputs11_3), .w(w4_3[11]), .wi(weighted_inputs4_11));
    weighted_inputs_2 w60 (.inputs(inputs12_3), .w(w4_3[12]), .wi(weighted_inputs4_12));
    weighted_inputs_2 w61 (.inputs(inputs13_3), .w(w4_3[13]), .wi(weighted_inputs4_13));
    weighted_inputs_2 w62 (.inputs(inputs14_3), .w(w4_3[14]), .wi(weighted_inputs4_14));
    weighted_inputs_2 w63 (.inputs(inputs15_3), .w(w4_3[15]), .wi(weighted_inputs4_15));
    weighted_inputs_2 w64 (.inputs(inputs0_3), .w(w5_3[0]), .wi(weighted_inputs5_0));
    weighted_inputs_2 w65 (.inputs(inputs1_3), .w(w5_3[1]), .wi(weighted_inputs5_1));
    weighted_inputs_2 w66 (.inputs(inputs2_3), .w(w5_3[2]), .wi(weighted_inputs5_2));
    weighted_inputs_2 w67 (.inputs(inputs3_3), .w(w5_3[3]), .wi(weighted_inputs5_3));
    weighted_inputs_2 w68 (.inputs(inputs4_3), .w(w5_3[4]), .wi(weighted_inputs5_4));
    weighted_inputs_2 w69 (.inputs(inputs5_3), .w(w5_3[5]), .wi(weighted_inputs5_5));
    weighted_inputs_2 w70 (.inputs(inputs6_3), .w(w5_3[6]), .wi(weighted_inputs5_6));
    weighted_inputs_2 w71 (.inputs(inputs7_3), .w(w5_3[7]), .wi(weighted_inputs5_7));
    weighted_inputs_2 w72 (.inputs(inputs8_3), .w(w5_3[8]), .wi(weighted_inputs5_8));
    weighted_inputs_2 w73 (.inputs(inputs9_3), .w(w5_3[9]), .wi(weighted_inputs5_9));
    weighted_inputs_2 w74 (.inputs(inputs10_3), .w(w5_3[10]), .wi(weighted_inputs5_10));
    weighted_inputs_2 w75 (.inputs(inputs11_3), .w(w5_3[11]), .wi(weighted_inputs5_11));
    weighted_inputs_2 w76 (.inputs(inputs12_3), .w(w5_3[12]), .wi(weighted_inputs5_12));
    weighted_inputs_2 w77 (.inputs(inputs13_3), .w(w5_3[13]), .wi(weighted_inputs5_13));
    weighted_inputs_2 w78 (.inputs(inputs14_3), .w(w5_3[14]), .wi(weighted_inputs5_14));
    weighted_inputs_2 w79 (.inputs(inputs15_3), .w(w5_3[15]), .wi(weighted_inputs5_15));
    weighted_inputs_2 w80 (.inputs(inputs0_3), .w(w6_3[0]), .wi(weighted_inputs6_0));
    weighted_inputs_2 w81 (.inputs(inputs1_3), .w(w6_3[1]), .wi(weighted_inputs6_1));
    weighted_inputs_2 w82 (.inputs(inputs2_3), .w(w6_3[2]), .wi(weighted_inputs6_2));
    weighted_inputs_2 w83 (.inputs(inputs3_3), .w(w6_3[3]), .wi(weighted_inputs6_3));
    weighted_inputs_2 w84 (.inputs(inputs4_3), .w(w6_3[4]), .wi(weighted_inputs6_4));
    weighted_inputs_2 w85 (.inputs(inputs5_3), .w(w6_3[5]), .wi(weighted_inputs6_5));
    weighted_inputs_2 w86 (.inputs(inputs6_3), .w(w6_3[6]), .wi(weighted_inputs6_6));
    weighted_inputs_2 w87 (.inputs(inputs7_3), .w(w6_3[7]), .wi(weighted_inputs6_7));
    weighted_inputs_2 w88 (.inputs(inputs8_3), .w(w6_3[8]), .wi(weighted_inputs6_8));
    weighted_inputs_2 w89 (.inputs(inputs9_3), .w(w6_3[9]), .wi(weighted_inputs6_9));
    weighted_inputs_2 w90 (.inputs(inputs10_3), .w(w6_3[10]), .wi(weighted_inputs6_10));
    weighted_inputs_2 w91 (.inputs(inputs11_3), .w(w6_3[11]), .wi(weighted_inputs6_11));
    weighted_inputs_2 w92 (.inputs(inputs12_3), .w(w6_3[12]), .wi(weighted_inputs6_12));
    weighted_inputs_2 w93 (.inputs(inputs13_3), .w(w6_3[13]), .wi(weighted_inputs6_13));
    weighted_inputs_2 w94 (.inputs(inputs14_3), .w(w6_3[14]), .wi(weighted_inputs6_14));
    weighted_inputs_2 w95 (.inputs(inputs15_3), .w(w6_3[15]), .wi(weighted_inputs6_15));
    weighted_inputs_2 w96 (.inputs(inputs0_3), .w(w7_3[0]), .wi(weighted_inputs7_0));
    weighted_inputs_2 w97 (.inputs(inputs1_3), .w(w7_3[1]), .wi(weighted_inputs7_1));
    weighted_inputs_2 w98 (.inputs(inputs2_3), .w(w7_3[2]), .wi(weighted_inputs7_2));
    weighted_inputs_2 w99 (.inputs(inputs3_3), .w(w7_3[3]), .wi(weighted_inputs7_3));
    weighted_inputs_2 w100 (.inputs(inputs4_3), .w(w7_3[4]), .wi(weighted_inputs7_4));
    weighted_inputs_2 w101 (.inputs(inputs5_3), .w(w7_3[5]), .wi(weighted_inputs7_5));
    weighted_inputs_2 w102 (.inputs(inputs6_3), .w(w7_3[6]), .wi(weighted_inputs7_6));
    weighted_inputs_2 w103 (.inputs(inputs7_3), .w(w7_3[7]), .wi(weighted_inputs7_7));
    weighted_inputs_2 w104 (.inputs(inputs8_3), .w(w7_3[8]), .wi(weighted_inputs7_8));
    weighted_inputs_2 w105 (.inputs(inputs9_3), .w(w7_3[9]), .wi(weighted_inputs7_9));
    weighted_inputs_2 w106 (.inputs(inputs10_3), .w(w7_3[10]), .wi(weighted_inputs7_10));
    weighted_inputs_2 w107 (.inputs(inputs11_3), .w(w7_3[11]), .wi(weighted_inputs7_11));
    weighted_inputs_2 w108 (.inputs(inputs12_3), .w(w7_3[12]), .wi(weighted_inputs7_12));
    weighted_inputs_2 w109 (.inputs(inputs13_3), .w(w7_3[13]), .wi(weighted_inputs7_13));
    weighted_inputs_2 w110 (.inputs(inputs14_3), .w(w7_3[14]), .wi(weighted_inputs7_14));
    weighted_inputs_2 w111 (.inputs(inputs15_3), .w(w7_3[15]), .wi(weighted_inputs7_15));
    weighted_inputs_2 w112 (.inputs(inputs0_3), .w(w8_3[0]), .wi(weighted_inputs8_0));
    weighted_inputs_2 w113 (.inputs(inputs1_3), .w(w8_3[1]), .wi(weighted_inputs8_1));
    weighted_inputs_2 w114 (.inputs(inputs2_3), .w(w8_3[2]), .wi(weighted_inputs8_2));
    weighted_inputs_2 w115 (.inputs(inputs3_3), .w(w8_3[3]), .wi(weighted_inputs8_3));
    weighted_inputs_2 w116 (.inputs(inputs4_3), .w(w8_3[4]), .wi(weighted_inputs8_4));
    weighted_inputs_2 w117 (.inputs(inputs5_3), .w(w8_3[5]), .wi(weighted_inputs8_5));
    weighted_inputs_2 w118 (.inputs(inputs6_3), .w(w8_3[6]), .wi(weighted_inputs8_6));
    weighted_inputs_2 w119 (.inputs(inputs7_3), .w(w8_3[7]), .wi(weighted_inputs8_7));
    weighted_inputs_2 w120 (.inputs(inputs8_3), .w(w8_3[8]), .wi(weighted_inputs8_8));
    weighted_inputs_2 w121 (.inputs(inputs9_3), .w(w8_3[9]), .wi(weighted_inputs8_9));
    weighted_inputs_2 w122 (.inputs(inputs10_3), .w(w8_3[10]), .wi(weighted_inputs8_10));
    weighted_inputs_2 w123 (.inputs(inputs11_3), .w(w8_3[11]), .wi(weighted_inputs8_11));
    weighted_inputs_2 w124 (.inputs(inputs12_3), .w(w8_3[12]), .wi(weighted_inputs8_12));
    weighted_inputs_2 w125 (.inputs(inputs13_3), .w(w8_3[13]), .wi(weighted_inputs8_13));
    weighted_inputs_2 w126 (.inputs(inputs14_3), .w(w8_3[14]), .wi(weighted_inputs8_14));
    weighted_inputs_2 w127 (.inputs(inputs15_3), .w(w8_3[15]), .wi(weighted_inputs8_15));
    weighted_inputs_2 w128 (.inputs(inputs0_3), .w(w9_3[0]), .wi(weighted_inputs9_0));
    weighted_inputs_2 w129 (.inputs(inputs1_3), .w(w9_3[1]), .wi(weighted_inputs9_1));
    weighted_inputs_2 w130 (.inputs(inputs2_3), .w(w9_3[2]), .wi(weighted_inputs9_2));
    weighted_inputs_2 w131 (.inputs(inputs3_3), .w(w9_3[3]), .wi(weighted_inputs9_3));
    weighted_inputs_2 w132 (.inputs(inputs4_3), .w(w9_3[4]), .wi(weighted_inputs9_4));
    weighted_inputs_2 w133 (.inputs(inputs5_3), .w(w9_3[5]), .wi(weighted_inputs9_5));
    weighted_inputs_2 w134 (.inputs(inputs6_3), .w(w9_3[6]), .wi(weighted_inputs9_6));
    weighted_inputs_2 w135 (.inputs(inputs7_3), .w(w9_3[7]), .wi(weighted_inputs9_7));
    weighted_inputs_2 w136 (.inputs(inputs8_3), .w(w9_3[8]), .wi(weighted_inputs9_8));
    weighted_inputs_2 w137 (.inputs(inputs9_3), .w(w9_3[9]), .wi(weighted_inputs9_9));
    weighted_inputs_2 w138 (.inputs(inputs10_3), .w(w9_3[10]), .wi(weighted_inputs9_10));
    weighted_inputs_2 w139 (.inputs(inputs11_3), .w(w9_3[11]), .wi(weighted_inputs9_11));
    weighted_inputs_2 w140 (.inputs(inputs12_3), .w(w9_3[12]), .wi(weighted_inputs9_12));
    weighted_inputs_2 w141 (.inputs(inputs13_3), .w(w9_3[13]), .wi(weighted_inputs9_13));
    weighted_inputs_2 w142 (.inputs(inputs14_3), .w(w9_3[14]), .wi(weighted_inputs9_14));
    weighted_inputs_2 w143 (.inputs(inputs15_3), .w(w9_3[15]), .wi(weighted_inputs9_15));
    weighted_inputs_2 w144 (.inputs(inputs0_3), .w(w10_3[0]), .wi(weighted_inputs10_0));
    weighted_inputs_2 w145 (.inputs(inputs1_3), .w(w10_3[1]), .wi(weighted_inputs10_1));
    weighted_inputs_2 w146 (.inputs(inputs2_3), .w(w10_3[2]), .wi(weighted_inputs10_2));
    weighted_inputs_2 w147 (.inputs(inputs3_3), .w(w10_3[3]), .wi(weighted_inputs10_3));
    weighted_inputs_2 w148 (.inputs(inputs4_3), .w(w10_3[4]), .wi(weighted_inputs10_4));
    weighted_inputs_2 w149 (.inputs(inputs5_3), .w(w10_3[5]), .wi(weighted_inputs10_5));
    weighted_inputs_2 w150 (.inputs(inputs6_3), .w(w10_3[6]), .wi(weighted_inputs10_6));
    weighted_inputs_2 w151 (.inputs(inputs7_3), .w(w10_3[7]), .wi(weighted_inputs10_7));
    weighted_inputs_2 w152 (.inputs(inputs8_3), .w(w10_3[8]), .wi(weighted_inputs10_8));
    weighted_inputs_2 w153 (.inputs(inputs9_3), .w(w10_3[9]), .wi(weighted_inputs10_9));
    weighted_inputs_2 w154 (.inputs(inputs10_3), .w(w10_3[10]), .wi(weighted_inputs10_10));
    weighted_inputs_2 w155 (.inputs(inputs11_3), .w(w10_3[11]), .wi(weighted_inputs10_11));
    weighted_inputs_2 w156 (.inputs(inputs12_3), .w(w10_3[12]), .wi(weighted_inputs10_12));
    weighted_inputs_2 w157 (.inputs(inputs13_3), .w(w10_3[13]), .wi(weighted_inputs10_13));
    weighted_inputs_2 w158 (.inputs(inputs14_3), .w(w10_3[14]), .wi(weighted_inputs10_14));
    weighted_inputs_2 w159 (.inputs(inputs15_3), .w(w10_3[15]), .wi(weighted_inputs10_15));
    weighted_inputs_2 w160 (.inputs(inputs0_3), .w(w11_3[0]), .wi(weighted_inputs11_0));
    weighted_inputs_2 w161 (.inputs(inputs1_3), .w(w11_3[1]), .wi(weighted_inputs11_1));
    weighted_inputs_2 w162 (.inputs(inputs2_3), .w(w11_3[2]), .wi(weighted_inputs11_2));
    weighted_inputs_2 w163 (.inputs(inputs3_3), .w(w11_3[3]), .wi(weighted_inputs11_3));
    weighted_inputs_2 w164 (.inputs(inputs4_3), .w(w11_3[4]), .wi(weighted_inputs11_4));
    weighted_inputs_2 w165 (.inputs(inputs5_3), .w(w11_3[5]), .wi(weighted_inputs11_5));
    weighted_inputs_2 w166 (.inputs(inputs6_3), .w(w11_3[6]), .wi(weighted_inputs11_6));
    weighted_inputs_2 w167 (.inputs(inputs7_3), .w(w11_3[7]), .wi(weighted_inputs11_7));
    weighted_inputs_2 w168 (.inputs(inputs8_3), .w(w11_3[8]), .wi(weighted_inputs11_8));
    weighted_inputs_2 w169 (.inputs(inputs9_3), .w(w11_3[9]), .wi(weighted_inputs11_9));
    weighted_inputs_2 w170 (.inputs(inputs10_3), .w(w11_3[10]), .wi(weighted_inputs11_10));
    weighted_inputs_2 w171 (.inputs(inputs11_3), .w(w11_3[11]), .wi(weighted_inputs11_11));
    weighted_inputs_2 w172 (.inputs(inputs12_3), .w(w11_3[12]), .wi(weighted_inputs11_12));
    weighted_inputs_2 w173 (.inputs(inputs13_3), .w(w11_3[13]), .wi(weighted_inputs11_13));
    weighted_inputs_2 w174 (.inputs(inputs14_3), .w(w11_3[14]), .wi(weighted_inputs11_14));
    weighted_inputs_2 w175 (.inputs(inputs15_3), .w(w11_3[15]), .wi(weighted_inputs11_15));
    weighted_inputs_2 w176 (.inputs(inputs0_3), .w(w12_3[0]), .wi(weighted_inputs12_0));
    weighted_inputs_2 w177 (.inputs(inputs1_3), .w(w12_3[1]), .wi(weighted_inputs12_1));
    weighted_inputs_2 w178 (.inputs(inputs2_3), .w(w12_3[2]), .wi(weighted_inputs12_2));
    weighted_inputs_2 w179 (.inputs(inputs3_3), .w(w12_3[3]), .wi(weighted_inputs12_3));
    weighted_inputs_2 w180 (.inputs(inputs4_3), .w(w12_3[4]), .wi(weighted_inputs12_4));
    weighted_inputs_2 w181 (.inputs(inputs5_3), .w(w12_3[5]), .wi(weighted_inputs12_5));
    weighted_inputs_2 w182 (.inputs(inputs6_3), .w(w12_3[6]), .wi(weighted_inputs12_6));
    weighted_inputs_2 w183 (.inputs(inputs7_3), .w(w12_3[7]), .wi(weighted_inputs12_7));
    weighted_inputs_2 w184 (.inputs(inputs8_3), .w(w12_3[8]), .wi(weighted_inputs12_8));
    weighted_inputs_2 w185 (.inputs(inputs9_3), .w(w12_3[9]), .wi(weighted_inputs12_9));
    weighted_inputs_2 w186 (.inputs(inputs10_3), .w(w12_3[10]), .wi(weighted_inputs12_10));
    weighted_inputs_2 w187 (.inputs(inputs11_3), .w(w12_3[11]), .wi(weighted_inputs12_11));
    weighted_inputs_2 w188 (.inputs(inputs12_3), .w(w12_3[12]), .wi(weighted_inputs12_12));
    weighted_inputs_2 w189 (.inputs(inputs13_3), .w(w12_3[13]), .wi(weighted_inputs12_13));
    weighted_inputs_2 w190 (.inputs(inputs14_3), .w(w12_3[14]), .wi(weighted_inputs12_14));
    weighted_inputs_2 w191 (.inputs(inputs15_3), .w(w12_3[15]), .wi(weighted_inputs12_15));
    weighted_inputs_2 w192 (.inputs(inputs0_3), .w(w13_3[0]), .wi(weighted_inputs13_0));
    weighted_inputs_2 w193 (.inputs(inputs1_3), .w(w13_3[1]), .wi(weighted_inputs13_1));
    weighted_inputs_2 w194 (.inputs(inputs2_3), .w(w13_3[2]), .wi(weighted_inputs13_2));
    weighted_inputs_2 w195 (.inputs(inputs3_3), .w(w13_3[3]), .wi(weighted_inputs13_3));
    weighted_inputs_2 w196 (.inputs(inputs4_3), .w(w13_3[4]), .wi(weighted_inputs13_4));
    weighted_inputs_2 w197 (.inputs(inputs5_3), .w(w13_3[5]), .wi(weighted_inputs13_5));
    weighted_inputs_2 w198 (.inputs(inputs6_3), .w(w13_3[6]), .wi(weighted_inputs13_6));
    weighted_inputs_2 w199 (.inputs(inputs7_3), .w(w13_3[7]), .wi(weighted_inputs13_7));
    weighted_inputs_2 w200 (.inputs(inputs8_3), .w(w13_3[8]), .wi(weighted_inputs13_8));
    weighted_inputs_2 w201 (.inputs(inputs9_3), .w(w13_3[9]), .wi(weighted_inputs13_9));
    weighted_inputs_2 w202 (.inputs(inputs10_3), .w(w13_3[10]), .wi(weighted_inputs13_10));
    weighted_inputs_2 w203 (.inputs(inputs11_3), .w(w13_3[11]), .wi(weighted_inputs13_11));
    weighted_inputs_2 w204 (.inputs(inputs12_3), .w(w13_3[12]), .wi(weighted_inputs13_12));
    weighted_inputs_2 w205 (.inputs(inputs13_3), .w(w13_3[13]), .wi(weighted_inputs13_13));
    weighted_inputs_2 w206 (.inputs(inputs14_3), .w(w13_3[14]), .wi(weighted_inputs13_14));
    weighted_inputs_2 w207 (.inputs(inputs15_3), .w(w13_3[15]), .wi(weighted_inputs13_15));
    weighted_inputs_2 w208 (.inputs(inputs0_3), .w(w14_3[0]), .wi(weighted_inputs14_0));
    weighted_inputs_2 w209 (.inputs(inputs1_3), .w(w14_3[1]), .wi(weighted_inputs14_1));
    weighted_inputs_2 w210 (.inputs(inputs2_3), .w(w14_3[2]), .wi(weighted_inputs14_2));
    weighted_inputs_2 w211 (.inputs(inputs3_3), .w(w14_3[3]), .wi(weighted_inputs14_3));
    weighted_inputs_2 w212 (.inputs(inputs4_3), .w(w14_3[4]), .wi(weighted_inputs14_4));
    weighted_inputs_2 w213 (.inputs(inputs5_3), .w(w14_3[5]), .wi(weighted_inputs14_5));
    weighted_inputs_2 w214 (.inputs(inputs6_3), .w(w14_3[6]), .wi(weighted_inputs14_6));
    weighted_inputs_2 w215 (.inputs(inputs7_3), .w(w14_3[7]), .wi(weighted_inputs14_7));
    weighted_inputs_2 w216 (.inputs(inputs8_3), .w(w14_3[8]), .wi(weighted_inputs14_8));
    weighted_inputs_2 w217 (.inputs(inputs9_3), .w(w14_3[9]), .wi(weighted_inputs14_9));
    weighted_inputs_2 w218 (.inputs(inputs10_3), .w(w14_3[10]), .wi(weighted_inputs14_10));
    weighted_inputs_2 w219 (.inputs(inputs11_3), .w(w14_3[11]), .wi(weighted_inputs14_11));
    weighted_inputs_2 w220 (.inputs(inputs12_3), .w(w14_3[12]), .wi(weighted_inputs14_12));
    weighted_inputs_2 w221 (.inputs(inputs13_3), .w(w14_3[13]), .wi(weighted_inputs14_13));
    weighted_inputs_2 w222 (.inputs(inputs14_3), .w(w14_3[14]), .wi(weighted_inputs14_14));
    weighted_inputs_2 w223 (.inputs(inputs15_3), .w(w14_3[15]), .wi(weighted_inputs14_15));
    weighted_inputs_2 w224 (.inputs(inputs0_3), .w(w15_3[0]), .wi(weighted_inputs15_0));
    weighted_inputs_2 w225 (.inputs(inputs1_3), .w(w15_3[1]), .wi(weighted_inputs15_1));
    weighted_inputs_2 w226 (.inputs(inputs2_3), .w(w15_3[2]), .wi(weighted_inputs15_2));
    weighted_inputs_2 w227 (.inputs(inputs3_3), .w(w15_3[3]), .wi(weighted_inputs15_3));
    weighted_inputs_2 w228 (.inputs(inputs4_3), .w(w15_3[4]), .wi(weighted_inputs15_4));
    weighted_inputs_2 w229 (.inputs(inputs5_3), .w(w15_3[5]), .wi(weighted_inputs15_5));
    weighted_inputs_2 w230 (.inputs(inputs6_3), .w(w15_3[6]), .wi(weighted_inputs15_6));
    weighted_inputs_2 w231 (.inputs(inputs7_3), .w(w15_3[7]), .wi(weighted_inputs15_7));
    weighted_inputs_2 w232 (.inputs(inputs8_3), .w(w15_3[8]), .wi(weighted_inputs15_8));
    weighted_inputs_2 w233 (.inputs(inputs9_3), .w(w15_3[9]), .wi(weighted_inputs15_9));
    weighted_inputs_2 w234 (.inputs(inputs10_3), .w(w15_3[10]), .wi(weighted_inputs15_10));
    weighted_inputs_2 w235 (.inputs(inputs11_3), .w(w15_3[11]), .wi(weighted_inputs15_11));
    weighted_inputs_2 w236 (.inputs(inputs12_3), .w(w15_3[12]), .wi(weighted_inputs15_12));
    weighted_inputs_2 w237 (.inputs(inputs13_3), .w(w15_3[13]), .wi(weighted_inputs15_13));
    weighted_inputs_2 w238 (.inputs(inputs14_3), .w(w15_3[14]), .wi(weighted_inputs15_14));
    weighted_inputs_2 w239 (.inputs(inputs15_3), .w(w15_3[15]), .wi(weighted_inputs15_15));
    weighted_inputs_2 w240 (.inputs(inputs0_3), .w(w16_3[0]), .wi(weighted_inputs16_0));
    weighted_inputs_2 w241 (.inputs(inputs1_3), .w(w16_3[1]), .wi(weighted_inputs16_1));
    weighted_inputs_2 w242 (.inputs(inputs2_3), .w(w16_3[2]), .wi(weighted_inputs16_2));
    weighted_inputs_2 w243 (.inputs(inputs3_3), .w(w16_3[3]), .wi(weighted_inputs16_3));
    weighted_inputs_2 w244 (.inputs(inputs4_3), .w(w16_3[4]), .wi(weighted_inputs16_4));
    weighted_inputs_2 w245 (.inputs(inputs5_3), .w(w16_3[5]), .wi(weighted_inputs16_5));
    weighted_inputs_2 w246 (.inputs(inputs6_3), .w(w16_3[6]), .wi(weighted_inputs16_6));
    weighted_inputs_2 w247 (.inputs(inputs7_3), .w(w16_3[7]), .wi(weighted_inputs16_7));
    weighted_inputs_2 w248 (.inputs(inputs8_3), .w(w16_3[8]), .wi(weighted_inputs16_8));
    weighted_inputs_2 w249 (.inputs(inputs9_3), .w(w16_3[9]), .wi(weighted_inputs16_9));
    weighted_inputs_2 w250 (.inputs(inputs10_3), .w(w16_3[10]), .wi(weighted_inputs16_10));
    weighted_inputs_2 w251 (.inputs(inputs11_3), .w(w16_3[11]), .wi(weighted_inputs16_11));
    weighted_inputs_2 w252 (.inputs(inputs12_3), .w(w16_3[12]), .wi(weighted_inputs16_12));
    weighted_inputs_2 w253 (.inputs(inputs13_3), .w(w16_3[13]), .wi(weighted_inputs16_13));
    weighted_inputs_2 w254 (.inputs(inputs14_3), .w(w16_3[14]), .wi(weighted_inputs16_14));
    weighted_inputs_2 w255 (.inputs(inputs15_3), .w(w16_3[15]), .wi(weighted_inputs16_15));
    adder_tree_3 add0(
    .clk(clk), 
        .in0(weighted_inputs1_0),
        .in1(weighted_inputs1_1),
        .in2(weighted_inputs1_2),
        .in3(weighted_inputs1_3),
        .in4(weighted_inputs1_4),
        .in5(weighted_inputs1_5),
        .in6(weighted_inputs1_6),
        .in7(weighted_inputs1_7),
        .in8(weighted_inputs1_8),
        .in9(weighted_inputs1_9),
        .in10(weighted_inputs1_10),
        .in11(weighted_inputs1_11),
        .in12(weighted_inputs1_12),
        .in13(weighted_inputs1_13),
        .in14(weighted_inputs1_14),
        .in15(weighted_inputs1_15),
        .sum(sum1[0])
    );
    adder_tree_3 add1(
    .clk(clk), 
        .in0(weighted_inputs2_0),
        .in1(weighted_inputs2_1),
        .in2(weighted_inputs2_2),
        .in3(weighted_inputs2_3),
        .in4(weighted_inputs2_4),
        .in5(weighted_inputs2_5),
        .in6(weighted_inputs2_6),
        .in7(weighted_inputs2_7),
        .in8(weighted_inputs2_8),
        .in9(weighted_inputs2_9),
        .in10(weighted_inputs2_10),
        .in11(weighted_inputs2_11),
        .in12(weighted_inputs2_12),
        .in13(weighted_inputs2_13),
        .in14(weighted_inputs2_14),
        .in15(weighted_inputs2_15),
        .sum(sum1[1])
    );
    adder_tree_3 add2(
    .clk(clk), 
        .in0(weighted_inputs3_0),
        .in1(weighted_inputs3_1),
        .in2(weighted_inputs3_2),
        .in3(weighted_inputs3_3),
        .in4(weighted_inputs3_4),
        .in5(weighted_inputs3_5),
        .in6(weighted_inputs3_6),
        .in7(weighted_inputs3_7),
        .in8(weighted_inputs3_8),
        .in9(weighted_inputs3_9),
        .in10(weighted_inputs3_10),
        .in11(weighted_inputs3_11),
        .in12(weighted_inputs3_12),
        .in13(weighted_inputs3_13),
        .in14(weighted_inputs3_14),
        .in15(weighted_inputs3_15),
        .sum(sum1[2])
    );
    adder_tree_3 add3(
    .clk(clk), 
        .in0(weighted_inputs4_0),
        .in1(weighted_inputs4_1),
        .in2(weighted_inputs4_2),
        .in3(weighted_inputs4_3),
        .in4(weighted_inputs4_4),
        .in5(weighted_inputs4_5),
        .in6(weighted_inputs4_6),
        .in7(weighted_inputs4_7),
        .in8(weighted_inputs4_8),
        .in9(weighted_inputs4_9),
        .in10(weighted_inputs4_10),
        .in11(weighted_inputs4_11),
        .in12(weighted_inputs4_12),
        .in13(weighted_inputs4_13),
        .in14(weighted_inputs4_14),
        .in15(weighted_inputs4_15),
        .sum(sum1[3])
    );
    adder_tree_3 add4(
    .clk(clk), 
        .in0(weighted_inputs5_0),
        .in1(weighted_inputs5_1),
        .in2(weighted_inputs5_2),
        .in3(weighted_inputs5_3),
        .in4(weighted_inputs5_4),
        .in5(weighted_inputs5_5),
        .in6(weighted_inputs5_6),
        .in7(weighted_inputs5_7),
        .in8(weighted_inputs5_8),
        .in9(weighted_inputs5_9),
        .in10(weighted_inputs5_10),
        .in11(weighted_inputs5_11),
        .in12(weighted_inputs5_12),
        .in13(weighted_inputs5_13),
        .in14(weighted_inputs5_14),
        .in15(weighted_inputs5_15),
        .sum(sum1[4])
    );
    adder_tree_3 add5(
    .clk(clk), 
        .in0(weighted_inputs6_0),
        .in1(weighted_inputs6_1),
        .in2(weighted_inputs6_2),
        .in3(weighted_inputs6_3),
        .in4(weighted_inputs6_4),
        .in5(weighted_inputs6_5),
        .in6(weighted_inputs6_6),
        .in7(weighted_inputs6_7),
        .in8(weighted_inputs6_8),
        .in9(weighted_inputs6_9),
        .in10(weighted_inputs6_10),
        .in11(weighted_inputs6_11),
        .in12(weighted_inputs6_12),
        .in13(weighted_inputs6_13),
        .in14(weighted_inputs6_14),
        .in15(weighted_inputs6_15),
        .sum(sum1[5])
    );
    adder_tree_3 add6(
    .clk(clk), 
        .in0(weighted_inputs7_0),
        .in1(weighted_inputs7_1),
        .in2(weighted_inputs7_2),
        .in3(weighted_inputs7_3),
        .in4(weighted_inputs7_4),
        .in5(weighted_inputs7_5),
        .in6(weighted_inputs7_6),
        .in7(weighted_inputs7_7),
        .in8(weighted_inputs7_8),
        .in9(weighted_inputs7_9),
        .in10(weighted_inputs7_10),
        .in11(weighted_inputs7_11),
        .in12(weighted_inputs7_12),
        .in13(weighted_inputs7_13),
        .in14(weighted_inputs7_14),
        .in15(weighted_inputs7_15),
        .sum(sum1[6])
    );
    adder_tree_3 add7(
    .clk(clk), 
        .in0(weighted_inputs8_0),
        .in1(weighted_inputs8_1),
        .in2(weighted_inputs8_2),
        .in3(weighted_inputs8_3),
        .in4(weighted_inputs8_4),
        .in5(weighted_inputs8_5),
        .in6(weighted_inputs8_6),
        .in7(weighted_inputs8_7),
        .in8(weighted_inputs8_8),
        .in9(weighted_inputs8_9),
        .in10(weighted_inputs8_10),
        .in11(weighted_inputs8_11),
        .in12(weighted_inputs8_12),
        .in13(weighted_inputs8_13),
        .in14(weighted_inputs8_14),
        .in15(weighted_inputs8_15),
        .sum(sum1[7])
    );
    adder_tree_3 add8(
    .clk(clk), 
        .in0(weighted_inputs9_0),
        .in1(weighted_inputs9_1),
        .in2(weighted_inputs9_2),
        .in3(weighted_inputs9_3),
        .in4(weighted_inputs9_4),
        .in5(weighted_inputs9_5),
        .in6(weighted_inputs9_6),
        .in7(weighted_inputs9_7),
        .in8(weighted_inputs9_8),
        .in9(weighted_inputs9_9),
        .in10(weighted_inputs9_10),
        .in11(weighted_inputs9_11),
        .in12(weighted_inputs9_12),
        .in13(weighted_inputs9_13),
        .in14(weighted_inputs9_14),
        .in15(weighted_inputs9_15),
        .sum(sum1[8])
    );
    adder_tree_3 add9(
    .clk(clk), 
        .in0(weighted_inputs10_0),
        .in1(weighted_inputs10_1),
        .in2(weighted_inputs10_2),
        .in3(weighted_inputs10_3),
        .in4(weighted_inputs10_4),
        .in5(weighted_inputs10_5),
        .in6(weighted_inputs10_6),
        .in7(weighted_inputs10_7),
        .in8(weighted_inputs10_8),
        .in9(weighted_inputs10_9),
        .in10(weighted_inputs10_10),
        .in11(weighted_inputs10_11),
        .in12(weighted_inputs10_12),
        .in13(weighted_inputs10_13),
        .in14(weighted_inputs10_14),
        .in15(weighted_inputs10_15),
        .sum(sum1[9])
    );
    adder_tree_3 add10(
    .clk(clk), 
        .in0(weighted_inputs11_0),
        .in1(weighted_inputs11_1),
        .in2(weighted_inputs11_2),
        .in3(weighted_inputs11_3),
        .in4(weighted_inputs11_4),
        .in5(weighted_inputs11_5),
        .in6(weighted_inputs11_6),
        .in7(weighted_inputs11_7),
        .in8(weighted_inputs11_8),
        .in9(weighted_inputs11_9),
        .in10(weighted_inputs11_10),
        .in11(weighted_inputs11_11),
        .in12(weighted_inputs11_12),
        .in13(weighted_inputs11_13),
        .in14(weighted_inputs11_14),
        .in15(weighted_inputs11_15),
        .sum(sum1[10])
    );
    adder_tree_3 add11(
    .clk(clk), 
        .in0(weighted_inputs12_0),
        .in1(weighted_inputs12_1),
        .in2(weighted_inputs12_2),
        .in3(weighted_inputs12_3),
        .in4(weighted_inputs12_4),
        .in5(weighted_inputs12_5),
        .in6(weighted_inputs12_6),
        .in7(weighted_inputs12_7),
        .in8(weighted_inputs12_8),
        .in9(weighted_inputs12_9),
        .in10(weighted_inputs12_10),
        .in11(weighted_inputs12_11),
        .in12(weighted_inputs12_12),
        .in13(weighted_inputs12_13),
        .in14(weighted_inputs12_14),
        .in15(weighted_inputs12_15),
        .sum(sum1[11])
    );
    adder_tree_3 add12(
    .clk(clk), 
        .in0(weighted_inputs13_0),
        .in1(weighted_inputs13_1),
        .in2(weighted_inputs13_2),
        .in3(weighted_inputs13_3),
        .in4(weighted_inputs13_4),
        .in5(weighted_inputs13_5),
        .in6(weighted_inputs13_6),
        .in7(weighted_inputs13_7),
        .in8(weighted_inputs13_8),
        .in9(weighted_inputs13_9),
        .in10(weighted_inputs13_10),
        .in11(weighted_inputs13_11),
        .in12(weighted_inputs13_12),
        .in13(weighted_inputs13_13),
        .in14(weighted_inputs13_14),
        .in15(weighted_inputs13_15),
        .sum(sum1[12])
    );
    adder_tree_3 add13(
    .clk(clk), 
        .in0(weighted_inputs14_0),
        .in1(weighted_inputs14_1),
        .in2(weighted_inputs14_2),
        .in3(weighted_inputs14_3),
        .in4(weighted_inputs14_4),
        .in5(weighted_inputs14_5),
        .in6(weighted_inputs14_6),
        .in7(weighted_inputs14_7),
        .in8(weighted_inputs14_8),
        .in9(weighted_inputs14_9),
        .in10(weighted_inputs14_10),
        .in11(weighted_inputs14_11),
        .in12(weighted_inputs14_12),
        .in13(weighted_inputs14_13),
        .in14(weighted_inputs14_14),
        .in15(weighted_inputs14_15),
        .sum(sum1[13])
    );
    adder_tree_3 add14(
    .clk(clk), 
        .in0(weighted_inputs15_0),
        .in1(weighted_inputs15_1),
        .in2(weighted_inputs15_2),
        .in3(weighted_inputs15_3),
        .in4(weighted_inputs15_4),
        .in5(weighted_inputs15_5),
        .in6(weighted_inputs15_6),
        .in7(weighted_inputs15_7),
        .in8(weighted_inputs15_8),
        .in9(weighted_inputs15_9),
        .in10(weighted_inputs15_10),
        .in11(weighted_inputs15_11),
        .in12(weighted_inputs15_12),
        .in13(weighted_inputs15_13),
        .in14(weighted_inputs15_14),
        .in15(weighted_inputs15_15),
        .sum(sum1[14])
    );
    adder_tree_3 add15(
    .clk(clk), 
        .in0(weighted_inputs16_0),
        .in1(weighted_inputs16_1),
        .in2(weighted_inputs16_2),
        .in3(weighted_inputs16_3),
        .in4(weighted_inputs16_4),
        .in5(weighted_inputs16_5),
        .in6(weighted_inputs16_6),
        .in7(weighted_inputs16_7),
        .in8(weighted_inputs16_8),
        .in9(weighted_inputs16_9),
        .in10(weighted_inputs16_10),
        .in11(weighted_inputs16_11),
        .in12(weighted_inputs16_12),
        .in13(weighted_inputs16_13),
        .in14(weighted_inputs16_14),
        .in15(weighted_inputs16_15),
        .sum(sum1[15])
    );
    add5bit_3 u0 (.a(sum1[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1[0]));
    add5bit_3 u1 (.a(sum1[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1[1]));
    add5bit_3 u2 (.a(sum1[2]), .b(b3_3), .cin(1'b0), .y(biased_sum1[2]));
    add5bit_3 u3 (.a(sum1[3]), .b(b4_3), .cin(1'b0), .y(biased_sum1[3]));
    add5bit_3 u4 (.a(sum1[4]), .b(b5_3), .cin(1'b0), .y(biased_sum1[4]));
    add5bit_3 u5 (.a(sum1[5]), .b(b6_3), .cin(1'b0), .y(biased_sum1[5]));
    add5bit_3 u6 (.a(sum1[6]), .b(b7_3), .cin(1'b0), .y(biased_sum1[6]));
    add5bit_3 u7 (.a(sum1[7]), .b(b8_3), .cin(1'b0), .y(biased_sum1[7]));
    add5bit_3 u8 (.a(sum1[8]), .b(b9_3), .cin(1'b0), .y(biased_sum1[8]));
    add5bit_3 u9 (.a(sum1[9]), .b(b10_3), .cin(1'b0), .y(biased_sum1[9]));
    add5bit_3 u10 (.a(sum1[10]), .b(b11_3), .cin(1'b0), .y(biased_sum1[10]));
    add5bit_3 u11 (.a(sum1[11]), .b(b12_3), .cin(1'b0), .y(biased_sum1[11]));
    add5bit_3 u12 (.a(sum1[12]), .b(b13_3), .cin(1'b0), .y(biased_sum1[12]));
    add5bit_3 u13 (.a(sum1[13]), .b(b14_3), .cin(1'b0), .y(biased_sum1[13]));
    add5bit_3 u14 (.a(sum1[14]), .b(b15_3), .cin(1'b0), .y(biased_sum1[14]));
    add5bit_3 u15 (.a(sum1[15]), .b(b16_3), .cin(1'b0), .y(biased_sum1[15]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    assign biased_sum4_0 = biased_sum1[4];
    assign biased_sum5_0 = biased_sum1[5];
    assign biased_sum6_0 = biased_sum1[6];
    assign biased_sum7_0 = biased_sum1[7];
    assign biased_sum8_0 = biased_sum1[8];
    assign biased_sum9_0 = biased_sum1[9];
    assign biased_sum10_0 = biased_sum1[10];
    assign biased_sum11_0 = biased_sum1[11];
    assign biased_sum12_0 = biased_sum1[12];
    assign biased_sum13_0 = biased_sum1[13];
    assign biased_sum14_0 = biased_sum1[14];
    assign biased_sum15_0 = biased_sum1[15];
    always @(posedge clk) begin
        $display("----- BNN LAYER 3 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_3, inputs1_3, inputs2_3, inputs3_3, inputs4_3, inputs5_3, inputs6_3, inputs7_3, inputs8_3, inputs9_3, inputs10_3, inputs11_3, inputs12_3, inputs13_3, inputs14_3, inputs15_3);
        $display("Weights: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", w1_3, w2_3, w3_3, w4_3, w5_3, w6_3, w7_3, w8_3, w9_3, w10_3, w11_3, w12_3, w13_3, w14_3, w15_3, w16_3);
        $display("sum1: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7], sum1[8], sum1[9], sum1[10], sum1[11], sum1[12], sum1[13], sum1[14], sum1[15]);
        $display("biased_sum1: %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7], biased_sum1[8], biased_sum1[9], biased_sum1[10], biased_sum1[11], biased_sum1[12], biased_sum1[13], biased_sum1[14], biased_sum1[15]);
    end
endmodule


module activation_3 (

    input [5:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[5] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_3 (
    input  [5:0] inputs0_0,
    input  [5:0] inputs1_0,
    input  [5:0] inputs2_0,
    input  [5:0] inputs3_0,
    input  [5:0] inputs4_0,
    input  [5:0] inputs5_0,
    input  [5:0] inputs6_0,
    input  [5:0] inputs7_0,
    input  [5:0] inputs8_0,
    input  [5:0] inputs9_0,
    input  [5:0] inputs10_0,
    input  [5:0] inputs11_0,
    input  [5:0] inputs12_0,
    input  [5:0] inputs13_0,
    input  [5:0] inputs14_0,
    input  [5:0] inputs15_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3,
    output wire activation4,
    output wire activation5,
    output wire activation6,
    output wire activation7,
    output wire activation8,
    output wire activation9,
    output wire activation10,
    output wire activation11,
    output wire activation12,
    output wire activation13,
    output wire activation14,
    output wire activation15
);

    activation_3 a0 (
        .inputs0_0(inputs0_0),
        .activation(activation0)
    );

    activation_3 a1 (
        .inputs0_0(inputs1_0),
        .activation(activation1)
    );

    activation_3 a2 (
        .inputs0_0(inputs2_0),
        .activation(activation2)
    );

    activation_3 a3 (
        .inputs0_0(inputs3_0),
        .activation(activation3)
    );

    activation_3 a4 (
        .inputs0_0(inputs4_0),
        .activation(activation4)
    );

    activation_3 a5 (
        .inputs0_0(inputs5_0),
        .activation(activation5)
    );

    activation_3 a6 (
        .inputs0_0(inputs6_0),
        .activation(activation6)
    );

    activation_3 a7 (
        .inputs0_0(inputs7_0),
        .activation(activation7)
    );

    activation_3 a8 (
        .inputs0_0(inputs8_0),
        .activation(activation8)
    );

    activation_3 a9 (
        .inputs0_0(inputs9_0),
        .activation(activation9)
    );

    activation_3 a10 (
        .inputs0_0(inputs10_0),
        .activation(activation10)
    );

    activation_3 a11 (
        .inputs0_0(inputs11_0),
        .activation(activation11)
    );

    activation_3 a12 (
        .inputs0_0(inputs12_0),
        .activation(activation12)
    );

    activation_3 a13 (
        .inputs0_0(inputs13_0),
        .activation(activation13)
    );

    activation_3 a14 (
        .inputs0_0(inputs14_0),
        .activation(activation14)
    );

    activation_3 a15 (
        .inputs0_0(inputs15_0),
        .activation(activation15)
    );

endmodule



module activation_and_conversion_3(
  input  wire clk, 
  input  wire [0:0] inputs0_3,
  input  wire [0:0] inputs1_3,
  input  wire [0:0] inputs2_3,
  input  wire [0:0] inputs3_3,
  input  wire [0:0] inputs4_3,
  input  wire [0:0] inputs5_3,
  input  wire [0:0] inputs6_3,
  input  wire [0:0] inputs7_3,
  input  wire [0:0] inputs8_3,
  input  wire [0:0] inputs9_3,
  input  wire [0:0] inputs10_3,
  input  wire [0:0] inputs11_3,
  input  wire [0:0] inputs12_3,
  input  wire [0:0] inputs13_3,
  input  wire [0:0] inputs14_3,
  input  wire [0:0] inputs15_3,
  input  wire [15:0] w1_3,
  input  wire [15:0] w2_3,
  input  wire [15:0] w3_3,
  input  wire [15:0] w4_3,
  input  wire [15:0] w5_3,
  input  wire [15:0] w6_3,
  input  wire [15:0] w7_3,
  input  wire [15:0] w8_3,
  input  wire [15:0] w9_3,
  input  wire [15:0] w10_3,
  input  wire [15:0] w11_3,
  input  wire [15:0] w12_3,
  input  wire [15:0] w13_3,
  input  wire [15:0] w14_3,
  input  wire [15:0] w15_3,
  input  wire [15:0] w16_3,
  input  wire [4:0] b1_3, b2_3, b3_3, b4_3, b5_3, b6_3, b7_3, b8_3, b9_3, b10_3, b11_3, b12_3, b13_3, b14_3, b15_3, b16_3,
  output wire activation0_3, 

  output wire activation1_3, 

  output wire activation2_3, 

  output wire activation3_3, 

  output wire activation4_3, 

  output wire activation5_3, 

  output wire activation6_3, 

  output wire activation7_3, 

  output wire activation8_3, 

  output wire activation9_3, 

  output wire activation10_3, 

  output wire activation11_3, 

  output wire activation12_3, 

  output wire activation13_3, 

  output wire activation14_3, 

  output wire activation15_3
);

  wire [5:0] biased_sum0_0;
  wire [5:0] biased_sum1_0;
  wire [5:0] biased_sum2_0;
  wire [5:0] biased_sum3_0;
  wire [5:0] biased_sum4_0;
  wire [5:0] biased_sum5_0;
  wire [5:0] biased_sum6_0;
  wire [5:0] biased_sum7_0;
  wire [5:0] biased_sum8_0;
  wire [5:0] biased_sum9_0;
  wire [5:0] biased_sum10_0;
  wire [5:0] biased_sum11_0;
  wire [5:0] biased_sum12_0;
  wire [5:0] biased_sum13_0;
  wire [5:0] biased_sum14_0;
  wire [5:0] biased_sum15_0;

    layer3 l1 (
    .clk(clk),
    .inputs0_3(inputs0_3),
    .inputs1_3(inputs1_3),
    .inputs2_3(inputs2_3),
    .inputs3_3(inputs3_3),
    .inputs4_3(inputs4_3),
    .inputs5_3(inputs5_3),
    .inputs6_3(inputs6_3),
    .inputs7_3(inputs7_3),
    .inputs8_3(inputs8_3),
    .inputs9_3(inputs9_3),
    .inputs10_3(inputs10_3),
    .inputs11_3(inputs11_3),
    .inputs12_3(inputs12_3),
    .inputs13_3(inputs13_3),
    .inputs14_3(inputs14_3),
    .inputs15_3(inputs15_3),
    .w1_3(w1_3),
    .w2_3(w2_3),
    .w3_3(w3_3),
    .w4_3(w4_3),
    .w5_3(w5_3),
    .w6_3(w6_3),
    .w7_3(w7_3),
    .w8_3(w8_3),
    .w9_3(w9_3),
    .w10_3(w10_3),
    .w11_3(w11_3),
    .w12_3(w12_3),
    .w13_3(w13_3),
    .w14_3(w14_3),
    .w15_3(w15_3),
    .w16_3(w16_3),
    .b1_3(b1_3),
    .b2_3(b2_3),
    .b3_3(b3_3),
    .b4_3(b4_3),
    .b5_3(b5_3),
    .b6_3(b6_3),
    .b7_3(b7_3),
    .b8_3(b8_3),
    .b9_3(b9_3),
    .b10_3(b10_3),
    .b11_3(b11_3),
    .b12_3(b12_3),
    .b13_3(b13_3),
    .b14_3(b14_3),
    .b15_3(b15_3),
    .b16_3(b16_3),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0),
    .biased_sum4_0(biased_sum4_0),
    .biased_sum5_0(biased_sum5_0),
    .biased_sum6_0(biased_sum6_0),
    .biased_sum7_0(biased_sum7_0),
    .biased_sum8_0(biased_sum8_0),
    .biased_sum9_0(biased_sum9_0),
    .biased_sum10_0(biased_sum10_0),
    .biased_sum11_0(biased_sum11_0),
    .biased_sum12_0(biased_sum12_0),
    .biased_sum13_0(biased_sum13_0),
    .biased_sum14_0(biased_sum14_0),
    .biased_sum15_0(biased_sum15_0)
  );

    activation_array_3 act1 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .inputs4_0(biased_sum4_0),
    .inputs5_0(biased_sum5_0),
    .inputs6_0(biased_sum6_0),
    .inputs7_0(biased_sum7_0),
    .inputs8_0(biased_sum8_0),
    .inputs9_0(biased_sum9_0),
    .inputs10_0(biased_sum10_0),
    .inputs11_0(biased_sum11_0),
    .inputs12_0(biased_sum12_0),
    .inputs13_0(biased_sum13_0),
    .inputs14_0(biased_sum14_0),
    .inputs15_0(biased_sum15_0),
    .activation0(activation0_3),
    .activation1(activation1_3),
    .activation2(activation2_3),
    .activation3(activation3_3),
    .activation4(activation4_3),
    .activation5(activation5_3),
    .activation6(activation6_3),
    .activation7(activation7_3),
    .activation8(activation8_3),
    .activation9(activation9_3),
    .activation10(activation10_3),
    .activation11(activation11_3),
    .activation12(activation12_3),
    .activation13(activation13_3),
    .activation14(activation14_3),
    .activation15(activation15_3)
  );

    activation_array_3 act2 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .inputs4_0(biased_sum4_0),
    .inputs5_0(biased_sum5_0),
    .inputs6_0(biased_sum6_0),
    .inputs7_0(biased_sum7_0),
    .inputs8_0(biased_sum8_0),
    .inputs9_0(biased_sum9_0),
    .inputs10_0(biased_sum10_0),
    .inputs11_0(biased_sum11_0),
    .inputs12_0(biased_sum12_0),
    .inputs13_0(biased_sum13_0),
    .inputs14_0(biased_sum14_0),
    .inputs15_0(biased_sum15_0),
    .activation0(activation0_3),
    .activation1(activation1_3),
    .activation2(activation2_3),
    .activation3(activation3_3),
    .activation4(activation4_3),
    .activation5(activation5_3),
    .activation6(activation6_3),
    .activation7(activation7_3),
    .activation8(activation8_3),
    .activation9(activation9_3),
    .activation10(activation10_3),
    .activation11(activation11_3),
    .activation12(activation12_3),
    .activation13(activation13_3),
    .activation14(activation14_3),
    .activation15(activation15_3)
  );

    always @(posedge clk) begin
    $display("----- LAYER 3   boolean activations -----");
    $display("activation : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", activation0_3, activation1_3, activation2_3, activation3_3, activation4_3, activation5_3, activation6_3, activation7_3, activation8_3, activation9_3, activation10_3, activation11_3, activation12_3, activation13_3, activation14_3, activation15_3);
  end


endmodule




module half_adder_4(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adder_4(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adder_4 HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adder_4 HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNAND_4(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule

module add1bit_4(
    input wire [0:0] a,
    input wire [0:0] b,
    input wire  cin,
    output wire [1:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;

full_adder_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));

WddlNAND_4 wn1(.A(~a[0]), .B(b[0]), .C(~c1), .S(s1), .S1(s1_1));
WddlNAND_4 wn2(.A(a[0]), .B(~b[0]), .C(~c1), .S(s2), .S1(s2_1));
WddlNAND_4 wn3(.A(a[0]), .B(b[0]), .C(c1), .S(s3), .S1(s3_1));
WddlNAND_4 wn4(.A(~a[0]), .B(~b[0]), .C(c1), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[1] = cout;

endmodule

module add2bit_4(
    input wire [1:0] a,
    input wire [1:0] b,
    input wire  cin,
    output wire [2:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;

full_adder_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));

WddlNAND_4 wn1(.A(~a[1]), .B(b[1]), .C(~c2), .S(s1), .S1(s1_1));
WddlNAND_4 wn2(.A(a[1]), .B(~b[1]), .C(~c2), .S(s2), .S1(s2_1));
WddlNAND_4 wn3(.A(a[1]), .B(b[1]), .C(c2), .S(s3), .S1(s3_1));
WddlNAND_4 wn4(.A(~a[1]), .B(~b[1]), .C(c2), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[2] = cout;

endmodule

module add3bit_4(
    input wire [2:0] a,
    input wire [2:0] b,
    input wire  cin,
    output wire [3:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;

full_adder_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_4 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNAND_4 wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNAND_4 wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNAND_4 wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNAND_4 wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout;

endmodule

module add4bit_4(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire  cin,
    output wire [4:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;

full_adder_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_4 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_4 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNAND_4 wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNAND_4 wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNAND_4 wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNAND_4 wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout;

endmodule

module add5bit_4(
    input wire [4:0] a,
    input wire [4:0] b,
    input wire  cin,
    output wire [5:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;
wire c2;
wire c3;
wire c4;
wire c5;

full_adder_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_4 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_4 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_4 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNAND_4 wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNAND_4 wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNAND_4 wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNAND_4 wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout;

endmodule



module adder_tree_4 (
    input  wire   clk, 
    input  wire [0:0] in0,
    input  wire [0:0] in1,
    input  wire [0:0] in2,
    input  wire [0:0] in3,
    input  wire [0:0] in4,
    input  wire [0:0] in5,
    input  wire [0:0] in6,
    input  wire [0:0] in7,
    input  wire [0:0] in8,
    input  wire [0:0] in9,
    input  wire [0:0] in10,
    input  wire [0:0] in11,
    input  wire [0:0] in12,
    input  wire [0:0] in13,
    input  wire [0:0] in14,
    input  wire [0:0] in15,
    output wire [4:0] sum
);

    wire [1:0] stage0_0_lo_4;
    wire [1:0] stage0_1_lo_4;
    wire [1:0] stage0_2_lo_4;
    wire [1:0] stage0_3_lo_4;
    wire [1:0] stage0_4_lo_4;
    wire [1:0] stage0_5_lo_4;
    wire [1:0] stage0_6_lo_4;
    wire [1:0] stage0_7_lo_4;
    wire [2:0] stage1_0_lo_4;
    wire [2:0] stage1_1_lo_4;
    wire [2:0] stage1_2_lo_4;
    wire [2:0] stage1_3_lo_4;
    wire [3:0] stage2_0_lo_4;
    wire [3:0] stage2_1_lo_4;
    wire [4:0] stage3_0_lo_4;
    reg  [1:0] stage0_0_4;
    reg  [1:0] stage0_1_4;
    reg  [1:0] stage0_2_4;
    reg  [1:0] stage0_3_4;
    reg  [1:0] stage0_4_4;
    reg  [1:0] stage0_5_4;
    reg  [1:0] stage0_6_4;
    reg  [1:0] stage0_7_4;
    reg  [2:0] stage1_0_4;
    reg  [2:0] stage1_1_4;
    reg  [2:0] stage1_2_4;
    reg  [2:0] stage1_3_4;
    reg  [3:0] stage2_0_4;
    reg  [3:0] stage2_1_4;
    reg  [4:0] stage3_0_4;

    add1bit_4 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_4), .cout(), .cout_bar());
    add2bit_4 u1_0 (.a(stage0_0_4), .b(stage0_1_4), .cin(1'b0), .y(stage1_0_lo_4), .cout(), .cout_bar());
    add2bit_4 u1_1 (.a(stage0_2_4), .b(stage0_3_4), .cin(1'b0), .y(stage1_1_lo_4), .cout(), .cout_bar());
    add2bit_4 u1_2 (.a(stage0_4_4), .b(stage0_5_4), .cin(1'b0), .y(stage1_2_lo_4), .cout(), .cout_bar());
    add2bit_4 u1_3 (.a(stage0_6_4), .b(stage0_7_4), .cin(1'b0), .y(stage1_3_lo_4), .cout(), .cout_bar());
    add3bit_4 u2_0 (.a(stage1_0_4), .b(stage1_1_4), .cin(1'b0), .y(stage2_0_lo_4), .cout(), .cout_bar());
    add3bit_4 u2_1 (.a(stage1_2_4), .b(stage1_3_4), .cin(1'b0), .y(stage2_1_lo_4), .cout(), .cout_bar());
    add4bit_4 u3_0 (.a(stage2_0_4), .b(stage2_1_4), .cin(1'b0), .y(stage3_0_lo_4), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_4;

    always @(posedge clk) begin
        stage0_0_4 <=  stage0_0_lo_4;
        stage0_1_4 <=  stage0_1_lo_4;
        stage0_2_4 <=  stage0_2_lo_4;
        stage0_3_4 <=  stage0_3_lo_4;
        stage0_4_4 <=  stage0_4_lo_4;
        stage0_5_4 <=  stage0_5_lo_4;
        stage0_6_4 <=  stage0_6_lo_4;
        stage0_7_4 <=  stage0_7_lo_4;
        stage1_0_4 <=  stage1_0_lo_4;
        stage1_1_4 <=  stage1_1_lo_4;
        stage1_2_4 <=  stage1_2_lo_4;
        stage1_3_4 <=  stage1_3_lo_4;
        stage2_0_4 <=  stage2_0_lo_4;
        stage2_1_4 <=  stage2_1_lo_4;
        stage3_0_4 <=  stage3_0_lo_4;
    end
endmodule


module layer4(
    input clk,
    input [0:0] inputs0_4 , inputs1_4 , inputs2_4 , inputs3_4 , inputs4_4 , inputs5_4 , inputs6_4 , inputs7_4 , inputs8_4 , inputs9_4 , inputs10_4 , inputs11_4 , inputs12_4 , inputs13_4 , inputs14_4 , inputs15_4,
    input [15:0] w1_4, w2_4, w3_4, w4_4, w5_4, w6_4, w7_4, w8_4,
    input [4:0] b1_4, b2_4, b3_4, b4_4, b5_4, b6_4, b7_4, b8_4,
    output [5:0] biased_sum0_0 , biased_sum1_0 , biased_sum2_0 , biased_sum3_0 , biased_sum4_0 , biased_sum5_0 , biased_sum6_0 , biased_sum7_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs1_4;
    wire [0:0] weighted_inputs1_5;
    wire [0:0] weighted_inputs1_6;
    wire [0:0] weighted_inputs1_7;
    wire [0:0] weighted_inputs1_8;
    wire [0:0] weighted_inputs1_9;
    wire [0:0] weighted_inputs1_10;
    wire [0:0] weighted_inputs1_11;
    wire [0:0] weighted_inputs1_12;
    wire [0:0] weighted_inputs1_13;
    wire [0:0] weighted_inputs1_14;
    wire [0:0] weighted_inputs1_15;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;
    wire [0:0] weighted_inputs2_4;
    wire [0:0] weighted_inputs2_5;
    wire [0:0] weighted_inputs2_6;
    wire [0:0] weighted_inputs2_7;
    wire [0:0] weighted_inputs2_8;
    wire [0:0] weighted_inputs2_9;
    wire [0:0] weighted_inputs2_10;
    wire [0:0] weighted_inputs2_11;
    wire [0:0] weighted_inputs2_12;
    wire [0:0] weighted_inputs2_13;
    wire [0:0] weighted_inputs2_14;
    wire [0:0] weighted_inputs2_15;
    wire [0:0] weighted_inputs3_0;
    wire [0:0] weighted_inputs3_1;
    wire [0:0] weighted_inputs3_2;
    wire [0:0] weighted_inputs3_3;
    wire [0:0] weighted_inputs3_4;
    wire [0:0] weighted_inputs3_5;
    wire [0:0] weighted_inputs3_6;
    wire [0:0] weighted_inputs3_7;
    wire [0:0] weighted_inputs3_8;
    wire [0:0] weighted_inputs3_9;
    wire [0:0] weighted_inputs3_10;
    wire [0:0] weighted_inputs3_11;
    wire [0:0] weighted_inputs3_12;
    wire [0:0] weighted_inputs3_13;
    wire [0:0] weighted_inputs3_14;
    wire [0:0] weighted_inputs3_15;
    wire [0:0] weighted_inputs4_0;
    wire [0:0] weighted_inputs4_1;
    wire [0:0] weighted_inputs4_2;
    wire [0:0] weighted_inputs4_3;
    wire [0:0] weighted_inputs4_4;
    wire [0:0] weighted_inputs4_5;
    wire [0:0] weighted_inputs4_6;
    wire [0:0] weighted_inputs4_7;
    wire [0:0] weighted_inputs4_8;
    wire [0:0] weighted_inputs4_9;
    wire [0:0] weighted_inputs4_10;
    wire [0:0] weighted_inputs4_11;
    wire [0:0] weighted_inputs4_12;
    wire [0:0] weighted_inputs4_13;
    wire [0:0] weighted_inputs4_14;
    wire [0:0] weighted_inputs4_15;
    wire [0:0] weighted_inputs5_0;
    wire [0:0] weighted_inputs5_1;
    wire [0:0] weighted_inputs5_2;
    wire [0:0] weighted_inputs5_3;
    wire [0:0] weighted_inputs5_4;
    wire [0:0] weighted_inputs5_5;
    wire [0:0] weighted_inputs5_6;
    wire [0:0] weighted_inputs5_7;
    wire [0:0] weighted_inputs5_8;
    wire [0:0] weighted_inputs5_9;
    wire [0:0] weighted_inputs5_10;
    wire [0:0] weighted_inputs5_11;
    wire [0:0] weighted_inputs5_12;
    wire [0:0] weighted_inputs5_13;
    wire [0:0] weighted_inputs5_14;
    wire [0:0] weighted_inputs5_15;
    wire [0:0] weighted_inputs6_0;
    wire [0:0] weighted_inputs6_1;
    wire [0:0] weighted_inputs6_2;
    wire [0:0] weighted_inputs6_3;
    wire [0:0] weighted_inputs6_4;
    wire [0:0] weighted_inputs6_5;
    wire [0:0] weighted_inputs6_6;
    wire [0:0] weighted_inputs6_7;
    wire [0:0] weighted_inputs6_8;
    wire [0:0] weighted_inputs6_9;
    wire [0:0] weighted_inputs6_10;
    wire [0:0] weighted_inputs6_11;
    wire [0:0] weighted_inputs6_12;
    wire [0:0] weighted_inputs6_13;
    wire [0:0] weighted_inputs6_14;
    wire [0:0] weighted_inputs6_15;
    wire [0:0] weighted_inputs7_0;
    wire [0:0] weighted_inputs7_1;
    wire [0:0] weighted_inputs7_2;
    wire [0:0] weighted_inputs7_3;
    wire [0:0] weighted_inputs7_4;
    wire [0:0] weighted_inputs7_5;
    wire [0:0] weighted_inputs7_6;
    wire [0:0] weighted_inputs7_7;
    wire [0:0] weighted_inputs7_8;
    wire [0:0] weighted_inputs7_9;
    wire [0:0] weighted_inputs7_10;
    wire [0:0] weighted_inputs7_11;
    wire [0:0] weighted_inputs7_12;
    wire [0:0] weighted_inputs7_13;
    wire [0:0] weighted_inputs7_14;
    wire [0:0] weighted_inputs7_15;
    wire [0:0] weighted_inputs8_0;
    wire [0:0] weighted_inputs8_1;
    wire [0:0] weighted_inputs8_2;
    wire [0:0] weighted_inputs8_3;
    wire [0:0] weighted_inputs8_4;
    wire [0:0] weighted_inputs8_5;
    wire [0:0] weighted_inputs8_6;
    wire [0:0] weighted_inputs8_7;
    wire [0:0] weighted_inputs8_8;
    wire [0:0] weighted_inputs8_9;
    wire [0:0] weighted_inputs8_10;
    wire [0:0] weighted_inputs8_11;
    wire [0:0] weighted_inputs8_12;
    wire [0:0] weighted_inputs8_13;
    wire [0:0] weighted_inputs8_14;
    wire [0:0] weighted_inputs8_15;

    wire [4:0] sum1 [7:0];
    wire [5:0] biased_sum1 [7:0];

    weighted_inputs_2 w0 (.inputs(inputs0_4), .w(w1_4[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_4), .w(w1_4[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_4), .w(w1_4[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_4), .w(w1_4[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs4_4), .w(w1_4[4]), .wi(weighted_inputs1_4));
    weighted_inputs_2 w5 (.inputs(inputs5_4), .w(w1_4[5]), .wi(weighted_inputs1_5));
    weighted_inputs_2 w6 (.inputs(inputs6_4), .w(w1_4[6]), .wi(weighted_inputs1_6));
    weighted_inputs_2 w7 (.inputs(inputs7_4), .w(w1_4[7]), .wi(weighted_inputs1_7));
    weighted_inputs_2 w8 (.inputs(inputs8_4), .w(w1_4[8]), .wi(weighted_inputs1_8));
    weighted_inputs_2 w9 (.inputs(inputs9_4), .w(w1_4[9]), .wi(weighted_inputs1_9));
    weighted_inputs_2 w10 (.inputs(inputs10_4), .w(w1_4[10]), .wi(weighted_inputs1_10));
    weighted_inputs_2 w11 (.inputs(inputs11_4), .w(w1_4[11]), .wi(weighted_inputs1_11));
    weighted_inputs_2 w12 (.inputs(inputs12_4), .w(w1_4[12]), .wi(weighted_inputs1_12));
    weighted_inputs_2 w13 (.inputs(inputs13_4), .w(w1_4[13]), .wi(weighted_inputs1_13));
    weighted_inputs_2 w14 (.inputs(inputs14_4), .w(w1_4[14]), .wi(weighted_inputs1_14));
    weighted_inputs_2 w15 (.inputs(inputs15_4), .w(w1_4[15]), .wi(weighted_inputs1_15));
    weighted_inputs_2 w16 (.inputs(inputs0_4), .w(w2_4[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w17 (.inputs(inputs1_4), .w(w2_4[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w18 (.inputs(inputs2_4), .w(w2_4[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w19 (.inputs(inputs3_4), .w(w2_4[3]), .wi(weighted_inputs2_3));
    weighted_inputs_2 w20 (.inputs(inputs4_4), .w(w2_4[4]), .wi(weighted_inputs2_4));
    weighted_inputs_2 w21 (.inputs(inputs5_4), .w(w2_4[5]), .wi(weighted_inputs2_5));
    weighted_inputs_2 w22 (.inputs(inputs6_4), .w(w2_4[6]), .wi(weighted_inputs2_6));
    weighted_inputs_2 w23 (.inputs(inputs7_4), .w(w2_4[7]), .wi(weighted_inputs2_7));
    weighted_inputs_2 w24 (.inputs(inputs8_4), .w(w2_4[8]), .wi(weighted_inputs2_8));
    weighted_inputs_2 w25 (.inputs(inputs9_4), .w(w2_4[9]), .wi(weighted_inputs2_9));
    weighted_inputs_2 w26 (.inputs(inputs10_4), .w(w2_4[10]), .wi(weighted_inputs2_10));
    weighted_inputs_2 w27 (.inputs(inputs11_4), .w(w2_4[11]), .wi(weighted_inputs2_11));
    weighted_inputs_2 w28 (.inputs(inputs12_4), .w(w2_4[12]), .wi(weighted_inputs2_12));
    weighted_inputs_2 w29 (.inputs(inputs13_4), .w(w2_4[13]), .wi(weighted_inputs2_13));
    weighted_inputs_2 w30 (.inputs(inputs14_4), .w(w2_4[14]), .wi(weighted_inputs2_14));
    weighted_inputs_2 w31 (.inputs(inputs15_4), .w(w2_4[15]), .wi(weighted_inputs2_15));
    weighted_inputs_2 w32 (.inputs(inputs0_4), .w(w3_4[0]), .wi(weighted_inputs3_0));
    weighted_inputs_2 w33 (.inputs(inputs1_4), .w(w3_4[1]), .wi(weighted_inputs3_1));
    weighted_inputs_2 w34 (.inputs(inputs2_4), .w(w3_4[2]), .wi(weighted_inputs3_2));
    weighted_inputs_2 w35 (.inputs(inputs3_4), .w(w3_4[3]), .wi(weighted_inputs3_3));
    weighted_inputs_2 w36 (.inputs(inputs4_4), .w(w3_4[4]), .wi(weighted_inputs3_4));
    weighted_inputs_2 w37 (.inputs(inputs5_4), .w(w3_4[5]), .wi(weighted_inputs3_5));
    weighted_inputs_2 w38 (.inputs(inputs6_4), .w(w3_4[6]), .wi(weighted_inputs3_6));
    weighted_inputs_2 w39 (.inputs(inputs7_4), .w(w3_4[7]), .wi(weighted_inputs3_7));
    weighted_inputs_2 w40 (.inputs(inputs8_4), .w(w3_4[8]), .wi(weighted_inputs3_8));
    weighted_inputs_2 w41 (.inputs(inputs9_4), .w(w3_4[9]), .wi(weighted_inputs3_9));
    weighted_inputs_2 w42 (.inputs(inputs10_4), .w(w3_4[10]), .wi(weighted_inputs3_10));
    weighted_inputs_2 w43 (.inputs(inputs11_4), .w(w3_4[11]), .wi(weighted_inputs3_11));
    weighted_inputs_2 w44 (.inputs(inputs12_4), .w(w3_4[12]), .wi(weighted_inputs3_12));
    weighted_inputs_2 w45 (.inputs(inputs13_4), .w(w3_4[13]), .wi(weighted_inputs3_13));
    weighted_inputs_2 w46 (.inputs(inputs14_4), .w(w3_4[14]), .wi(weighted_inputs3_14));
    weighted_inputs_2 w47 (.inputs(inputs15_4), .w(w3_4[15]), .wi(weighted_inputs3_15));
    weighted_inputs_2 w48 (.inputs(inputs0_4), .w(w4_4[0]), .wi(weighted_inputs4_0));
    weighted_inputs_2 w49 (.inputs(inputs1_4), .w(w4_4[1]), .wi(weighted_inputs4_1));
    weighted_inputs_2 w50 (.inputs(inputs2_4), .w(w4_4[2]), .wi(weighted_inputs4_2));
    weighted_inputs_2 w51 (.inputs(inputs3_4), .w(w4_4[3]), .wi(weighted_inputs4_3));
    weighted_inputs_2 w52 (.inputs(inputs4_4), .w(w4_4[4]), .wi(weighted_inputs4_4));
    weighted_inputs_2 w53 (.inputs(inputs5_4), .w(w4_4[5]), .wi(weighted_inputs4_5));
    weighted_inputs_2 w54 (.inputs(inputs6_4), .w(w4_4[6]), .wi(weighted_inputs4_6));
    weighted_inputs_2 w55 (.inputs(inputs7_4), .w(w4_4[7]), .wi(weighted_inputs4_7));
    weighted_inputs_2 w56 (.inputs(inputs8_4), .w(w4_4[8]), .wi(weighted_inputs4_8));
    weighted_inputs_2 w57 (.inputs(inputs9_4), .w(w4_4[9]), .wi(weighted_inputs4_9));
    weighted_inputs_2 w58 (.inputs(inputs10_4), .w(w4_4[10]), .wi(weighted_inputs4_10));
    weighted_inputs_2 w59 (.inputs(inputs11_4), .w(w4_4[11]), .wi(weighted_inputs4_11));
    weighted_inputs_2 w60 (.inputs(inputs12_4), .w(w4_4[12]), .wi(weighted_inputs4_12));
    weighted_inputs_2 w61 (.inputs(inputs13_4), .w(w4_4[13]), .wi(weighted_inputs4_13));
    weighted_inputs_2 w62 (.inputs(inputs14_4), .w(w4_4[14]), .wi(weighted_inputs4_14));
    weighted_inputs_2 w63 (.inputs(inputs15_4), .w(w4_4[15]), .wi(weighted_inputs4_15));
    weighted_inputs_2 w64 (.inputs(inputs0_4), .w(w5_4[0]), .wi(weighted_inputs5_0));
    weighted_inputs_2 w65 (.inputs(inputs1_4), .w(w5_4[1]), .wi(weighted_inputs5_1));
    weighted_inputs_2 w66 (.inputs(inputs2_4), .w(w5_4[2]), .wi(weighted_inputs5_2));
    weighted_inputs_2 w67 (.inputs(inputs3_4), .w(w5_4[3]), .wi(weighted_inputs5_3));
    weighted_inputs_2 w68 (.inputs(inputs4_4), .w(w5_4[4]), .wi(weighted_inputs5_4));
    weighted_inputs_2 w69 (.inputs(inputs5_4), .w(w5_4[5]), .wi(weighted_inputs5_5));
    weighted_inputs_2 w70 (.inputs(inputs6_4), .w(w5_4[6]), .wi(weighted_inputs5_6));
    weighted_inputs_2 w71 (.inputs(inputs7_4), .w(w5_4[7]), .wi(weighted_inputs5_7));
    weighted_inputs_2 w72 (.inputs(inputs8_4), .w(w5_4[8]), .wi(weighted_inputs5_8));
    weighted_inputs_2 w73 (.inputs(inputs9_4), .w(w5_4[9]), .wi(weighted_inputs5_9));
    weighted_inputs_2 w74 (.inputs(inputs10_4), .w(w5_4[10]), .wi(weighted_inputs5_10));
    weighted_inputs_2 w75 (.inputs(inputs11_4), .w(w5_4[11]), .wi(weighted_inputs5_11));
    weighted_inputs_2 w76 (.inputs(inputs12_4), .w(w5_4[12]), .wi(weighted_inputs5_12));
    weighted_inputs_2 w77 (.inputs(inputs13_4), .w(w5_4[13]), .wi(weighted_inputs5_13));
    weighted_inputs_2 w78 (.inputs(inputs14_4), .w(w5_4[14]), .wi(weighted_inputs5_14));
    weighted_inputs_2 w79 (.inputs(inputs15_4), .w(w5_4[15]), .wi(weighted_inputs5_15));
    weighted_inputs_2 w80 (.inputs(inputs0_4), .w(w6_4[0]), .wi(weighted_inputs6_0));
    weighted_inputs_2 w81 (.inputs(inputs1_4), .w(w6_4[1]), .wi(weighted_inputs6_1));
    weighted_inputs_2 w82 (.inputs(inputs2_4), .w(w6_4[2]), .wi(weighted_inputs6_2));
    weighted_inputs_2 w83 (.inputs(inputs3_4), .w(w6_4[3]), .wi(weighted_inputs6_3));
    weighted_inputs_2 w84 (.inputs(inputs4_4), .w(w6_4[4]), .wi(weighted_inputs6_4));
    weighted_inputs_2 w85 (.inputs(inputs5_4), .w(w6_4[5]), .wi(weighted_inputs6_5));
    weighted_inputs_2 w86 (.inputs(inputs6_4), .w(w6_4[6]), .wi(weighted_inputs6_6));
    weighted_inputs_2 w87 (.inputs(inputs7_4), .w(w6_4[7]), .wi(weighted_inputs6_7));
    weighted_inputs_2 w88 (.inputs(inputs8_4), .w(w6_4[8]), .wi(weighted_inputs6_8));
    weighted_inputs_2 w89 (.inputs(inputs9_4), .w(w6_4[9]), .wi(weighted_inputs6_9));
    weighted_inputs_2 w90 (.inputs(inputs10_4), .w(w6_4[10]), .wi(weighted_inputs6_10));
    weighted_inputs_2 w91 (.inputs(inputs11_4), .w(w6_4[11]), .wi(weighted_inputs6_11));
    weighted_inputs_2 w92 (.inputs(inputs12_4), .w(w6_4[12]), .wi(weighted_inputs6_12));
    weighted_inputs_2 w93 (.inputs(inputs13_4), .w(w6_4[13]), .wi(weighted_inputs6_13));
    weighted_inputs_2 w94 (.inputs(inputs14_4), .w(w6_4[14]), .wi(weighted_inputs6_14));
    weighted_inputs_2 w95 (.inputs(inputs15_4), .w(w6_4[15]), .wi(weighted_inputs6_15));
    weighted_inputs_2 w96 (.inputs(inputs0_4), .w(w7_4[0]), .wi(weighted_inputs7_0));
    weighted_inputs_2 w97 (.inputs(inputs1_4), .w(w7_4[1]), .wi(weighted_inputs7_1));
    weighted_inputs_2 w98 (.inputs(inputs2_4), .w(w7_4[2]), .wi(weighted_inputs7_2));
    weighted_inputs_2 w99 (.inputs(inputs3_4), .w(w7_4[3]), .wi(weighted_inputs7_3));
    weighted_inputs_2 w100 (.inputs(inputs4_4), .w(w7_4[4]), .wi(weighted_inputs7_4));
    weighted_inputs_2 w101 (.inputs(inputs5_4), .w(w7_4[5]), .wi(weighted_inputs7_5));
    weighted_inputs_2 w102 (.inputs(inputs6_4), .w(w7_4[6]), .wi(weighted_inputs7_6));
    weighted_inputs_2 w103 (.inputs(inputs7_4), .w(w7_4[7]), .wi(weighted_inputs7_7));
    weighted_inputs_2 w104 (.inputs(inputs8_4), .w(w7_4[8]), .wi(weighted_inputs7_8));
    weighted_inputs_2 w105 (.inputs(inputs9_4), .w(w7_4[9]), .wi(weighted_inputs7_9));
    weighted_inputs_2 w106 (.inputs(inputs10_4), .w(w7_4[10]), .wi(weighted_inputs7_10));
    weighted_inputs_2 w107 (.inputs(inputs11_4), .w(w7_4[11]), .wi(weighted_inputs7_11));
    weighted_inputs_2 w108 (.inputs(inputs12_4), .w(w7_4[12]), .wi(weighted_inputs7_12));
    weighted_inputs_2 w109 (.inputs(inputs13_4), .w(w7_4[13]), .wi(weighted_inputs7_13));
    weighted_inputs_2 w110 (.inputs(inputs14_4), .w(w7_4[14]), .wi(weighted_inputs7_14));
    weighted_inputs_2 w111 (.inputs(inputs15_4), .w(w7_4[15]), .wi(weighted_inputs7_15));
    weighted_inputs_2 w112 (.inputs(inputs0_4), .w(w8_4[0]), .wi(weighted_inputs8_0));
    weighted_inputs_2 w113 (.inputs(inputs1_4), .w(w8_4[1]), .wi(weighted_inputs8_1));
    weighted_inputs_2 w114 (.inputs(inputs2_4), .w(w8_4[2]), .wi(weighted_inputs8_2));
    weighted_inputs_2 w115 (.inputs(inputs3_4), .w(w8_4[3]), .wi(weighted_inputs8_3));
    weighted_inputs_2 w116 (.inputs(inputs4_4), .w(w8_4[4]), .wi(weighted_inputs8_4));
    weighted_inputs_2 w117 (.inputs(inputs5_4), .w(w8_4[5]), .wi(weighted_inputs8_5));
    weighted_inputs_2 w118 (.inputs(inputs6_4), .w(w8_4[6]), .wi(weighted_inputs8_6));
    weighted_inputs_2 w119 (.inputs(inputs7_4), .w(w8_4[7]), .wi(weighted_inputs8_7));
    weighted_inputs_2 w120 (.inputs(inputs8_4), .w(w8_4[8]), .wi(weighted_inputs8_8));
    weighted_inputs_2 w121 (.inputs(inputs9_4), .w(w8_4[9]), .wi(weighted_inputs8_9));
    weighted_inputs_2 w122 (.inputs(inputs10_4), .w(w8_4[10]), .wi(weighted_inputs8_10));
    weighted_inputs_2 w123 (.inputs(inputs11_4), .w(w8_4[11]), .wi(weighted_inputs8_11));
    weighted_inputs_2 w124 (.inputs(inputs12_4), .w(w8_4[12]), .wi(weighted_inputs8_12));
    weighted_inputs_2 w125 (.inputs(inputs13_4), .w(w8_4[13]), .wi(weighted_inputs8_13));
    weighted_inputs_2 w126 (.inputs(inputs14_4), .w(w8_4[14]), .wi(weighted_inputs8_14));
    weighted_inputs_2 w127 (.inputs(inputs15_4), .w(w8_4[15]), .wi(weighted_inputs8_15));
    adder_tree_4 add0(
    .clk(clk), 
        .in0(weighted_inputs1_0),
        .in1(weighted_inputs1_1),
        .in2(weighted_inputs1_2),
        .in3(weighted_inputs1_3),
        .in4(weighted_inputs1_4),
        .in5(weighted_inputs1_5),
        .in6(weighted_inputs1_6),
        .in7(weighted_inputs1_7),
        .in8(weighted_inputs1_8),
        .in9(weighted_inputs1_9),
        .in10(weighted_inputs1_10),
        .in11(weighted_inputs1_11),
        .in12(weighted_inputs1_12),
        .in13(weighted_inputs1_13),
        .in14(weighted_inputs1_14),
        .in15(weighted_inputs1_15),
        .sum(sum1[0])
    );
    adder_tree_4 add1(
    .clk(clk), 
        .in0(weighted_inputs2_0),
        .in1(weighted_inputs2_1),
        .in2(weighted_inputs2_2),
        .in3(weighted_inputs2_3),
        .in4(weighted_inputs2_4),
        .in5(weighted_inputs2_5),
        .in6(weighted_inputs2_6),
        .in7(weighted_inputs2_7),
        .in8(weighted_inputs2_8),
        .in9(weighted_inputs2_9),
        .in10(weighted_inputs2_10),
        .in11(weighted_inputs2_11),
        .in12(weighted_inputs2_12),
        .in13(weighted_inputs2_13),
        .in14(weighted_inputs2_14),
        .in15(weighted_inputs2_15),
        .sum(sum1[1])
    );
    adder_tree_4 add2(
    .clk(clk), 
        .in0(weighted_inputs3_0),
        .in1(weighted_inputs3_1),
        .in2(weighted_inputs3_2),
        .in3(weighted_inputs3_3),
        .in4(weighted_inputs3_4),
        .in5(weighted_inputs3_5),
        .in6(weighted_inputs3_6),
        .in7(weighted_inputs3_7),
        .in8(weighted_inputs3_8),
        .in9(weighted_inputs3_9),
        .in10(weighted_inputs3_10),
        .in11(weighted_inputs3_11),
        .in12(weighted_inputs3_12),
        .in13(weighted_inputs3_13),
        .in14(weighted_inputs3_14),
        .in15(weighted_inputs3_15),
        .sum(sum1[2])
    );
    adder_tree_4 add3(
    .clk(clk), 
        .in0(weighted_inputs4_0),
        .in1(weighted_inputs4_1),
        .in2(weighted_inputs4_2),
        .in3(weighted_inputs4_3),
        .in4(weighted_inputs4_4),
        .in5(weighted_inputs4_5),
        .in6(weighted_inputs4_6),
        .in7(weighted_inputs4_7),
        .in8(weighted_inputs4_8),
        .in9(weighted_inputs4_9),
        .in10(weighted_inputs4_10),
        .in11(weighted_inputs4_11),
        .in12(weighted_inputs4_12),
        .in13(weighted_inputs4_13),
        .in14(weighted_inputs4_14),
        .in15(weighted_inputs4_15),
        .sum(sum1[3])
    );
    adder_tree_4 add4(
    .clk(clk), 
        .in0(weighted_inputs5_0),
        .in1(weighted_inputs5_1),
        .in2(weighted_inputs5_2),
        .in3(weighted_inputs5_3),
        .in4(weighted_inputs5_4),
        .in5(weighted_inputs5_5),
        .in6(weighted_inputs5_6),
        .in7(weighted_inputs5_7),
        .in8(weighted_inputs5_8),
        .in9(weighted_inputs5_9),
        .in10(weighted_inputs5_10),
        .in11(weighted_inputs5_11),
        .in12(weighted_inputs5_12),
        .in13(weighted_inputs5_13),
        .in14(weighted_inputs5_14),
        .in15(weighted_inputs5_15),
        .sum(sum1[4])
    );
    adder_tree_4 add5(
    .clk(clk), 
        .in0(weighted_inputs6_0),
        .in1(weighted_inputs6_1),
        .in2(weighted_inputs6_2),
        .in3(weighted_inputs6_3),
        .in4(weighted_inputs6_4),
        .in5(weighted_inputs6_5),
        .in6(weighted_inputs6_6),
        .in7(weighted_inputs6_7),
        .in8(weighted_inputs6_8),
        .in9(weighted_inputs6_9),
        .in10(weighted_inputs6_10),
        .in11(weighted_inputs6_11),
        .in12(weighted_inputs6_12),
        .in13(weighted_inputs6_13),
        .in14(weighted_inputs6_14),
        .in15(weighted_inputs6_15),
        .sum(sum1[5])
    );
    adder_tree_4 add6(
    .clk(clk), 
        .in0(weighted_inputs7_0),
        .in1(weighted_inputs7_1),
        .in2(weighted_inputs7_2),
        .in3(weighted_inputs7_3),
        .in4(weighted_inputs7_4),
        .in5(weighted_inputs7_5),
        .in6(weighted_inputs7_6),
        .in7(weighted_inputs7_7),
        .in8(weighted_inputs7_8),
        .in9(weighted_inputs7_9),
        .in10(weighted_inputs7_10),
        .in11(weighted_inputs7_11),
        .in12(weighted_inputs7_12),
        .in13(weighted_inputs7_13),
        .in14(weighted_inputs7_14),
        .in15(weighted_inputs7_15),
        .sum(sum1[6])
    );
    adder_tree_4 add7(
    .clk(clk), 
        .in0(weighted_inputs8_0),
        .in1(weighted_inputs8_1),
        .in2(weighted_inputs8_2),
        .in3(weighted_inputs8_3),
        .in4(weighted_inputs8_4),
        .in5(weighted_inputs8_5),
        .in6(weighted_inputs8_6),
        .in7(weighted_inputs8_7),
        .in8(weighted_inputs8_8),
        .in9(weighted_inputs8_9),
        .in10(weighted_inputs8_10),
        .in11(weighted_inputs8_11),
        .in12(weighted_inputs8_12),
        .in13(weighted_inputs8_13),
        .in14(weighted_inputs8_14),
        .in15(weighted_inputs8_15),
        .sum(sum1[7])
    );
    add5bit_4 u0 (.a(sum1[0]), .b(b1_4), .cin(1'b0), .y(biased_sum1[0]));
    add5bit_4 u1 (.a(sum1[1]), .b(b2_4), .cin(1'b0), .y(biased_sum1[1]));
    add5bit_4 u2 (.a(sum1[2]), .b(b3_4), .cin(1'b0), .y(biased_sum1[2]));
    add5bit_4 u3 (.a(sum1[3]), .b(b4_4), .cin(1'b0), .y(biased_sum1[3]));
    add5bit_4 u4 (.a(sum1[4]), .b(b5_4), .cin(1'b0), .y(biased_sum1[4]));
    add5bit_4 u5 (.a(sum1[5]), .b(b6_4), .cin(1'b0), .y(biased_sum1[5]));
    add5bit_4 u6 (.a(sum1[6]), .b(b7_4), .cin(1'b0), .y(biased_sum1[6]));
    add5bit_4 u7 (.a(sum1[7]), .b(b8_4), .cin(1'b0), .y(biased_sum1[7]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    assign biased_sum4_0 = biased_sum1[4];
    assign biased_sum5_0 = biased_sum1[5];
    assign biased_sum6_0 = biased_sum1[6];
    assign biased_sum7_0 = biased_sum1[7];
    always @(posedge clk) begin
        $display("----- BNN LAYER 4 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_4, inputs1_4, inputs2_4, inputs3_4, inputs4_4, inputs5_4, inputs6_4, inputs7_4, inputs8_4, inputs9_4, inputs10_4, inputs11_4, inputs12_4, inputs13_4, inputs14_4, inputs15_4);
        $display("Weights: %b %b %b %b %b %b %b %b", w1_4, w2_4, w3_4, w4_4, w5_4, w6_4, w7_4, w8_4);
        $display("sum1: %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7]);
        $display("biased_sum1: %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7]);
    end
endmodule


module subtractor (
    input  wire signed [5:0] A,
    input  wire signed [5:0] B,
    output wire signed [6:0] Result
);
    assign Result = A - B;
endmodule

module comparator_1 (
    input  wire [6:0] inputs0_0,
    input  wire [6:0] inputs0_1,
    input  wire r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0,
    output wire comparator
);
    // internal r_out chain
    wire r1 , r2 , r3 , r4 , r5 , r6 , r7;
    wire masked_c0_0 , masked_c1_0 , masked_c2_0 , masked_c3_0 , masked_c4_0 , masked_c5_0 , masked_c6_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0),
               .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0),
               .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0),
               .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0),
               .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0),
               .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0),
               .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));
    lut1 l6 (.a(inputs0_0[6]), .b(inputs0_1[6]), .c_in(masked_c5_0),
               .r_flow(r6), .r_i(r6_0), .r_out(r7), .c_masked(masked_c6_0));

    wire carry = r7 ^ masked_c6_0;
    // final compare: if carry ^ inputs0_0[N-1] ^ inputs0_1[N-1] == 0 → comparator = 1
    assign comparator = (carry ^ inputs0_0[6] ^ inputs0_1[6]) ? 1'b0 : 1'b1;
endmodule


module output_layer_max (
  input  clk, 
  input  wire [0:0] inputs0_4,
  input  wire [0:0] inputs1_4,
  input  wire [0:0] inputs2_4,
  input  wire [0:0] inputs3_4,
  input  wire [0:0] inputs4_4,
  input  wire [0:0] inputs5_4,
  input  wire [0:0] inputs6_4,
  input  wire [0:0] inputs7_4,
  input  wire [0:0] inputs8_4,
  input  wire [0:0] inputs9_4,
  input  wire [0:0] inputs10_4,
  input  wire [0:0] inputs11_4,
  input  wire [0:0] inputs12_4,
  input  wire [0:0] inputs13_4,
  input  wire [0:0] inputs14_4,
  input  wire [0:0] inputs15_4,
    input  wire [15:0] w1_4,
    input  wire [15:0] w2_4,
    input  wire [15:0] w3_4,
    input  wire [15:0] w4_4,
    input  wire [15:0] w5_4,
    input  wire [15:0] w6_4,
    input  wire [15:0] w7_4,
    input  wire [15:0] w8_4,
    input  wire [4:0] b1_4,
    input  wire [4:0] b2_4,
    input  wire [4:0] b3_4,
    input  wire [4:0] b4_4,
    input  wire [4:0] b5_4,
    input  wire [4:0] b6_4,
    input  wire [4:0] b7_4,
    input  wire [4:0] b8_4,
    input  wire r0_0,
    input  wire r1_0,
    input  wire r2_0,
    input  wire r3_0,
    input  wire r4_0,
    input  wire r5_0,
    input  wire r6_0,
    input  wire r0_1,
    input  wire r1_1,
    input  wire r2_1,
    input  wire r3_1,
    input  wire r4_1,
    input  wire r5_1,
    input  wire r6_1,
    input  wire r0_2,
    input  wire r1_2,
    input  wire r2_2,
    input  wire r3_2,
    input  wire r4_2,
    input  wire r5_2,
    input  wire r6_2,
    input  wire r0_3,
    input  wire r1_3,
    input  wire r2_3,
    input  wire r3_3,
    input  wire r4_3,
    input  wire r5_3,
    input  wire r6_3,
    input  wire r0_4,
    input  wire r1_4,
    input  wire r2_4,
    input  wire r3_4,
    input  wire r4_4,
    input  wire r5_4,
    input  wire r6_4,
    input  wire r0_5,
    input  wire r1_5,
    input  wire r2_5,
    input  wire r3_5,
    input  wire r4_5,
    input  wire r5_5,
    input  wire r6_5,
    input  wire r0_6,
    input  wire r1_6,
    input  wire r2_6,
    input  wire r3_6,
    input  wire r4_6,
    input  wire r5_6,
    input  wire r6_6,
    output reg  a0,
    output reg  a1,
    output reg  a2,
    output reg  a3,
    output reg  a4,
    output reg  a5,
    output reg  a6,
    output reg  a7
);

    wire [5:0] biased_sum0_0; 
    wire [5:0] biased_sum1_0; 
    wire [5:0] biased_sum2_0; 
    wire [5:0] biased_sum3_0; 
    wire [5:0] biased_sum4_0; 
    wire [5:0] biased_sum5_0; 
    wire [5:0] biased_sum6_0; 
    wire [5:0] biased_sum7_0; 

    layer4 l1 (
        .clk(clk),
        .inputs0_4(inputs0_4),
        .inputs1_4(inputs1_4),
        .inputs2_4(inputs2_4),
        .inputs3_4(inputs3_4),
        .inputs4_4(inputs4_4),
        .inputs5_4(inputs5_4),
        .inputs6_4(inputs6_4),
        .inputs7_4(inputs7_4),
        .inputs8_4(inputs8_4),
        .inputs9_4(inputs9_4),
        .inputs10_4(inputs10_4),
        .inputs11_4(inputs11_4),
        .inputs12_4(inputs12_4),
        .inputs13_4(inputs13_4),
        .inputs14_4(inputs14_4),
        .inputs15_4(inputs15_4),
        .w1_4(w1_4),
        .w2_4(w2_4),
        .w3_4(w3_4),
        .w4_4(w4_4),
        .w5_4(w5_4),
        .w6_4(w6_4),
        .w7_4(w7_4),
        .w8_4(w8_4),
        .b1_4(b1_4),
        .b2_4(b2_4),
        .b3_4(b3_4),
        .b4_4(b4_4),
        .b5_4(b5_4),
        .b6_4(b6_4),
        .b7_4(b7_4),
        .b8_4(b8_4),
        .biased_sum0_0(biased_sum0_0),
        .biased_sum1_0(biased_sum1_0),
        .biased_sum2_0(biased_sum2_0),
        .biased_sum3_0(biased_sum3_0),
        .biased_sum4_0(biased_sum4_0),
        .biased_sum5_0(biased_sum5_0),
        .biased_sum6_0(biased_sum6_0),
        .biased_sum7_0(biased_sum7_0)
    );

    wire [6:0] temp0_0;
    subtractor s0a (.A(biased_sum0_0), .B(biased_sum1_0), .Result(temp0_0));
    wire comp0;
    comparator_1 c0 (
        .inputs0_0(temp0_0), .inputs0_1(7'b0),
        .r0_0(r0_0), .r1_0(r1_0), .r2_0(r2_0), .r3_0(r3_0), .r4_0(r4_0), .r5_0(r5_0), .r6_0(r6_0),
        .comparator(comp0)
    );
    reg [5:0] stage1_0_0, stage1_0_1;
    always @(posedge clk) begin
        if (comp0)      begin stage1_0_0 <= biased_sum0_0;    stage1_0_1 <= 7'b0;    end
        else                    begin stage1_0_0 <= biased_sum1_0;    stage1_0_1 <= 7'b0;    end
    end

    wire [6:0] temp1_0;
    subtractor s1a (.A(biased_sum2_0), .B(biased_sum3_0), .Result(temp1_0));
    wire comp1;
    comparator_1 c1 (
        .inputs0_0(temp1_0), .inputs0_1(7'b0),
        .r0_0(r0_1), .r1_0(r1_1), .r2_0(r2_1), .r3_0(r3_1), .r4_0(r4_1), .r5_0(r5_1), .r6_0(r6_1),
        .comparator(comp1)
    );
    reg [5:0] stage1_1_0, stage1_1_1;
    always @(posedge clk) begin
        if (comp1)      begin stage1_1_0 <= biased_sum2_0;    stage1_1_1 <= 7'b0;    end
        else                    begin stage1_1_0 <= biased_sum3_0;    stage1_1_1 <= 7'b0;    end
    end

    wire [6:0] temp2_0;
    subtractor s2a (.A(biased_sum4_0), .B(biased_sum5_0), .Result(temp2_0));
    wire comp2;
    comparator_1 c2 (
        .inputs0_0(temp2_0), .inputs0_1(7'b0),
        .r0_0(r0_2), .r1_0(r1_2), .r2_0(r2_2), .r3_0(r3_2), .r4_0(r4_2), .r5_0(r5_2), .r6_0(r6_2),
        .comparator(comp2)
    );
    reg [5:0] stage1_2_0, stage1_2_1;
    always @(posedge clk) begin
        if (comp2)      begin stage1_2_0 <= biased_sum4_0;    stage1_2_1 <= 7'b0;    end
        else                    begin stage1_2_0 <= biased_sum5_0;    stage1_2_1 <= 7'b0;    end
    end

    wire [6:0] temp3_0;
    subtractor s3a (.A(biased_sum6_0), .B(biased_sum7_0), .Result(temp3_0));
    wire comp3;
    comparator_1 c3 (
        .inputs0_0(temp3_0), .inputs0_1(7'b0),
        .r0_0(r0_3), .r1_0(r1_3), .r2_0(r2_3), .r3_0(r3_3), .r4_0(r4_3), .r5_0(r5_3), .r6_0(r6_3),
        .comparator(comp3)
    );
    reg [5:0] stage1_3_0, stage1_3_1;
    always @(posedge clk) begin
        if (comp3)      begin stage1_3_0 <= biased_sum6_0;    stage1_3_1 <= 7'b0;    end
        else                    begin stage1_3_0 <= biased_sum7_0;    stage1_3_1 <= 7'b0;    end
    end

    wire [6:0] temp4_0;
    subtractor s4a (.A(stage1_0_0), .B(stage1_1_0), .Result(temp4_0));
    wire comp4;
    comparator_1 c4 (
        .inputs0_0(temp4_0), .inputs0_1(7'b0),
        .r0_0(r0_4), .r1_0(r1_4), .r2_0(r2_4), .r3_0(r3_4), .r4_0(r4_4), .r5_0(r5_4), .r6_0(r6_4),
        .comparator(comp4)
    );
    reg [5:0] stage2_0_0, stage2_0_1;
    always @(posedge clk) begin
        if (comp4)      begin stage2_0_0 <= stage1_0_0;    stage2_0_1 <= stage1_0_1;    end
        else                    begin stage2_0_0 <= stage1_1_0;    stage2_0_1 <= stage1_1_1;    end
    end

    wire [6:0] temp5_0;
    subtractor s5a (.A(stage1_2_0), .B(stage1_3_0), .Result(temp5_0));
    wire comp5;
    comparator_1 c5 (
        .inputs0_0(temp5_0), .inputs0_1(7'b0),
        .r0_0(r0_5), .r1_0(r1_5), .r2_0(r2_5), .r3_0(r3_5), .r4_0(r4_5), .r5_0(r5_5), .r6_0(r6_5),
        .comparator(comp5)
    );
    reg [5:0] stage2_1_0, stage2_1_1;
    always @(posedge clk) begin
        if (comp5)      begin stage2_1_0 <= stage1_2_0;    stage2_1_1 <= stage1_2_1;    end
        else                    begin stage2_1_0 <= stage1_3_0;    stage2_1_1 <= stage1_3_1;    end
    end

    wire [6:0] temp6_0;
    subtractor s6a (.A(stage2_0_0), .B(stage2_1_0), .Result(temp6_0));
    wire comp6;
    comparator_1 c6 (
        .inputs0_0(temp6_0), .inputs0_1(7'b0),
        .r0_0(r0_6), .r1_0(r1_6), .r2_0(r2_6), .r3_0(r3_6), .r4_0(r4_6), .r5_0(r5_6), .r6_0(r6_6),
        .comparator(comp6)
    );
    reg [5:0] stage3_0_0, stage3_0_1;
    always @(posedge clk) begin
        if (comp6)      begin stage3_0_0 <= stage2_0_0;    stage3_0_1 <= stage2_0_1;    end
        else                    begin stage3_0_0 <= stage2_1_0;    stage3_0_1 <= stage2_1_1;    end
    end

    always @(posedge clk) begin
        a0 <= 0;
        a1 <= 0;
        a2 <= 0;
        a3 <= 0;
        a4 <= 0;
        a5 <= 0;
        a6 <= 0;
        a7 <= 0;

        if (comp0 == 1 && comp4 == 1 && comp6 == 1) a0     <= 1;
        else if (comp0 == 0 && comp4 == 1 && comp6 == 1) a1     <= 1;
        else if (comp1 == 1 && comp4 == 0 && comp6 == 1) a2     <= 1;
        else if (comp1 == 0 && comp4 == 0 && comp6 == 1) a3     <= 1;
        else if (comp2 == 1 && comp5 == 1 && comp6 == 0) a4     <= 1;
        else if (comp2 == 0 && comp5 == 1 && comp6 == 0) a5     <= 1;
        else if (comp3 == 1 && comp5 == 0 && comp6 == 0) a6     <= 1;
        else             a7     <= 1;

    end
endmodule
module connector(
    // Layer-1 inputs
    input  wire clk ,
    input  wire [7:0] inputs0_1,
    input  wire [7:0] inputs1_1,
    input  wire [7:0] inputs2_1,
    input  wire [7:0] inputs3_1,
    input  wire [7:0] inputs4_1,
    input  wire [7:0] inputs5_1,
    input  wire [7:0] inputs6_1,
    input  wire [7:0] inputs7_1,
    input  wire [7:0] inputs8_1,
    input  wire [7:0] inputs9_1,
    input  wire [7:0] inputs10_1,
    input  wire [7:0] inputs11_1,
    input  wire [7:0] inputs12_1,
    input  wire [7:0] inputs13_1,
    input  wire [7:0] inputs14_1,
    input  wire [7:0] inputs15_1,
    input  wire [7:0] inputs16_1,
    input  wire [7:0] inputs17_1,
    input  wire [7:0] inputs18_1,
    input  wire [7:0] inputs19_1,
    input  wire [7:0] inputs20_1,
    input  wire [7:0] inputs21_1,
    input  wire [7:0] inputs22_1,
    input  wire [7:0] inputs23_1,
    input  wire [7:0] inputs24_1,
    input  wire [7:0] inputs25_1,
    input  wire [7:0] inputs26_1,
    input  wire [7:0] inputs27_1,
    input  wire [7:0] inputs28_1,
    input  wire [7:0] inputs29_1,
    input  wire [7:0] inputs30_1,
    input  wire [7:0] inputs31_1,
    // Layer-1 weights & biases
    input  wire [31:0] w1_1,
    input  wire [31:0] w2_1,
    input  wire [31:0] w3_1,
    input  wire [31:0] w4_1,
    input  wire [31:0] w5_1,
    input  wire [31:0] w6_1,
    input  wire [31:0] w7_1,
    input  wire [31:0] w8_1,
    input  wire [31:0] w9_1,
    input  wire [31:0] w10_1,
    input  wire [31:0] w11_1,
    input  wire [31:0] w12_1,
    input  wire [31:0] w13_1,
    input  wire [31:0] w14_1,
    input  wire [31:0] w15_1,
    input  wire [31:0] w16_1,
    input  wire [12:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1, b9_1, b10_1, b11_1, b12_1, b13_1, b14_1, b15_1, b16_1,

    // Layer-2 weights & biases
    input  wire [15:0] w1_2,
    input  wire [15:0] w2_2,
    input  wire [15:0] w3_2,
    input  wire [15:0] w4_2,
    input  wire [15:0] w5_2,
    input  wire [15:0] w6_2,
    input  wire [15:0] w7_2,
    input  wire [15:0] w8_2,
    input  wire [15:0] w9_2,
    input  wire [15:0] w10_2,
    input  wire [15:0] w11_2,
    input  wire [15:0] w12_2,
    input  wire [15:0] w13_2,
    input  wire [15:0] w14_2,
    input  wire [15:0] w15_2,
    input  wire [15:0] w16_2,
    input  wire [4:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2, b9_2, b10_2, b11_2, b12_2, b13_2, b14_2, b15_2, b16_2,

    // Layer-3 weights & biases (output layer)
    input  wire [15:0] w1_3, 
    input  wire [15:0] w2_3, 
    input  wire [15:0] w3_3, 
    input  wire [15:0] w4_3, 
    input  wire [15:0] w5_3, 
    input  wire [15:0] w6_3, 
    input  wire [15:0] w7_3, 
    input  wire [15:0] w8_3, 
    input  wire [15:0] w9_3, 
    input  wire [15:0] w10_3, 
    input  wire [15:0] w11_3, 
    input  wire [15:0] w12_3, 
    input  wire [15:0] w13_3, 
    input  wire [15:0] w14_3, 
    input  wire [15:0] w15_3, 
    input  wire [15:0] w16_3, 
    input  wire [4:0] b1_3,
    input  wire [4:0] b2_3,
    input  wire [4:0] b3_3,
    input  wire [4:0] b4_3,
    input  wire [4:0] b5_3,
    input  wire [4:0] b6_3,
    input  wire [4:0] b7_3,
    input  wire [4:0] b8_3,
    input  wire [4:0] b9_3,
    input  wire [4:0] b10_3,
    input  wire [4:0] b11_3,
    input  wire [4:0] b12_3,
    input  wire [4:0] b13_3,
    input  wire [4:0] b14_3,
    input  wire [4:0] b15_3,
    input  wire [4:0] b16_3,

    // Layer-4 weights & biases (output layer)
    input  wire [15:0] w1_4,
    input  wire [15:0] w2_4,
    input  wire [15:0] w3_4,
    input  wire [15:0] w4_4,
    input  wire [15:0] w5_4,
    input  wire [15:0] w6_4,
    input  wire [15:0] w7_4,
    input  wire [15:0] w8_4,
    input  wire [4:0] b1_4,
    input  wire [4:0] b2_4,
    input  wire [4:0] b3_4,
    input  wire [4:0] b4_4,
    input  wire [4:0] b5_4,
    input  wire [4:0] b6_4,
    input  wire [4:0] b7_4,
    input  wire [4:0] b8_4,
    output wire a0,
    output wire a1,
    output wire a2,
    output wire a3,
    output wire a4,
    output wire a5,
    output wire a6,
    output wire a7
);

  //--------------------------------------------------------------------------
  // Layer-1 randomness taps
  //--------------------------------------------------------------------------
 wire activation0_1;
 wire activation1_1;
 wire activation2_1;
 wire activation3_1;
 wire activation4_1;
 wire activation5_1;
 wire activation6_1;
 wire activation7_1;
 wire activation8_1;
 wire activation9_1;
 wire activation10_1;
 wire activation11_1;
 wire activation12_1;
 wire activation13_1;
 wire activation14_1;
 wire activation15_1;
 reg activationr0_1;
 reg activationr1_1;
 reg activationr2_1;
 reg activationr3_1;
 reg activationr4_1;
 reg activationr5_1;
 reg activationr6_1;
 reg activationr7_1;
 reg activationr8_1;
 reg activationr9_1;
 reg activationr10_1;
 reg activationr11_1;
 reg activationr12_1;
 reg activationr13_1;
 reg activationr14_1;
 reg activationr15_1;
  activation_and_conversion_1 layer1_inst (
    .clk(clk),
    .inputs0_1(inputs0_1),
    .inputs1_1(inputs1_1),
    .inputs2_1(inputs2_1),
    .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1),
    .inputs5_1(inputs5_1),
    .inputs6_1(inputs6_1),
    .inputs7_1(inputs7_1),
    .inputs8_1(inputs8_1),
    .inputs9_1(inputs9_1),
    .inputs10_1(inputs10_1),
    .inputs11_1(inputs11_1),
    .inputs12_1(inputs12_1),
    .inputs13_1(inputs13_1),
    .inputs14_1(inputs14_1),
    .inputs15_1(inputs15_1),
    .inputs16_1(inputs16_1),
    .inputs17_1(inputs17_1),
    .inputs18_1(inputs18_1),
    .inputs19_1(inputs19_1),
    .inputs20_1(inputs20_1),
    .inputs21_1(inputs21_1),
    .inputs22_1(inputs22_1),
    .inputs23_1(inputs23_1),
    .inputs24_1(inputs24_1),
    .inputs25_1(inputs25_1),
    .inputs26_1(inputs26_1),
    .inputs27_1(inputs27_1),
    .inputs28_1(inputs28_1),
    .inputs29_1(inputs29_1),
    .inputs30_1(inputs30_1),
    .inputs31_1(inputs31_1),
    .w1_1(w1_1), 
    .w2_1(w2_1), 
    .w3_1(w3_1), 
    .w4_1(w4_1), 
    .w5_1(w5_1), 
    .w6_1(w6_1), 
    .w7_1(w7_1), 
    .w8_1(w8_1), 
    .w9_1(w9_1), 
    .w10_1(w10_1), 
    .w11_1(w11_1), 
    .w12_1(w12_1), 
    .w13_1(w13_1), 
    .w14_1(w14_1), 
    .w15_1(w15_1), 
    .w16_1(w16_1), 
    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1), .b5_1(b5_1), .b6_1(b6_1), .b7_1(b7_1), .b8_1(b8_1), .b9_1(b9_1), .b10_1(b10_1), .b11_1(b11_1), .b12_1(b12_1), .b13_1(b13_1), .b14_1(b14_1), .b15_1(b15_1), .b16_1(b16_1),
    .activation0_1(activation0_1), 
    .activation1_1(activation1_1), 
    .activation2_1(activation2_1), 
    .activation3_1(activation3_1), 
    .activation4_1(activation4_1), 
    .activation5_1(activation5_1), 
    .activation6_1(activation6_1), 
    .activation7_1(activation7_1), 
    .activation8_1(activation8_1), 
    .activation9_1(activation9_1), 
    .activation10_1(activation10_1), 
    .activation11_1(activation11_1), 
    .activation12_1(activation12_1), 
    .activation13_1(activation13_1), 
    .activation14_1(activation14_1), 
    .activation15_1(activation15_1)
  );

  always @(posedge clk) begin
    activationr0_1 <=activation0_1;
    activationr1_1 <=activation1_1;
    activationr2_1 <=activation2_1;
    activationr3_1 <=activation3_1;
    activationr4_1 <=activation4_1;
    activationr5_1 <=activation5_1;
    activationr6_1 <=activation6_1;
    activationr7_1 <=activation7_1;
    activationr8_1 <=activation8_1;
    activationr9_1 <=activation9_1;
    activationr10_1 <=activation10_1;
    activationr11_1 <=activation11_1;
    activationr12_1 <=activation12_1;
    activationr13_1 <=activation13_1;
    activationr14_1 <=activation14_1;
    activationr15_1 <=activation15_1;
  end

  //--------------------------------------------------------------------------
  // Layer-2 randomness taps
  //--------------------------------------------------------------------------
 wire activation0_2;
 wire activation1_2;
 wire activation2_2;
 wire activation3_2;
 wire activation4_2;
 wire activation5_2;
 wire activation6_2;
 wire activation7_2;
 wire activation8_2;
 wire activation9_2;
 wire activation10_2;
 wire activation11_2;
 wire activation12_2;
 wire activation13_2;
 wire activation14_2;
 wire activation15_2;
 reg activationr0_2;
 reg activationr1_2;
 reg activationr2_2;
 reg activationr3_2;
 reg activationr4_2;
 reg activationr5_2;
 reg activationr6_2;
 reg activationr7_2;
 reg activationr8_2;
 reg activationr9_2;
 reg activationr10_2;
 reg activationr11_2;
 reg activationr12_2;
 reg activationr13_2;
 reg activationr14_2;
 reg activationr15_2;
  activation_and_conversion_2 layer2_inst (
    .clk(clk),
    .inputs0_2(activation0_1),
    .inputs1_2(activation1_1),
    .inputs2_2(activation2_1),
    .inputs3_2(activation3_1),
    .inputs4_2(activation4_1),
    .inputs5_2(activation5_1),
    .inputs6_2(activation6_1),
    .inputs7_2(activation7_1),
    .inputs8_2(activation8_1),
    .inputs9_2(activation9_1),
    .inputs10_2(activation10_1),
    .inputs11_2(activation11_1),
    .inputs12_2(activation12_1),
    .inputs13_2(activation13_1),
    .inputs14_2(activation14_1),
    .inputs15_2(activation15_1),
    .w1_2(w1_2),
    .w2_2(w2_2),
    .w3_2(w3_2),
    .w4_2(w4_2),
    .w5_2(w5_2),
    .w6_2(w6_2),
    .w7_2(w7_2),
    .w8_2(w8_2),
    .w9_2(w9_2),
    .w10_2(w10_2),
    .w11_2(w11_2),
    .w12_2(w12_2),
    .w13_2(w13_2),
    .w14_2(w14_2),
    .w15_2(w15_2),
    .w16_2(w16_2),
    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2), .b5_2(b5_2), .b6_2(b6_2), .b7_2(b7_2), .b8_2(b8_2), .b9_2(b9_2), .b10_2(b10_2), .b11_2(b11_2), .b12_2(b12_2), .b13_2(b13_2), .b14_2(b14_2), .b15_2(b15_2), .b16_2(b16_2),
    .activation0_2(activation0_2), 
    .activation1_2(activation1_2), 
    .activation2_2(activation2_2), 
    .activation3_2(activation3_2), 
    .activation4_2(activation4_2), 
    .activation5_2(activation5_2), 
    .activation6_2(activation6_2), 
    .activation7_2(activation7_2), 
    .activation8_2(activation8_2), 
    .activation9_2(activation9_2), 
    .activation10_2(activation10_2), 
    .activation11_2(activation11_2), 
    .activation12_2(activation12_2), 
    .activation13_2(activation13_2), 
    .activation14_2(activation14_2), 
    .activation15_2(activation15_2)
  );

  always @(posedge clk) begin
    activationr0_2 <= activation0_2;
    activationr1_2 <= activation1_2;
    activationr2_2 <= activation2_2;
    activationr3_2 <= activation3_2;
    activationr4_2 <= activation4_2;
    activationr5_2 <= activation5_2;
    activationr6_2 <= activation6_2;
    activationr7_2 <= activation7_2;
    activationr8_2 <= activation8_2;
    activationr9_2 <= activation9_2;
    activationr10_2 <= activation10_2;
    activationr11_2 <= activation11_2;
    activationr12_2 <= activation12_2;
    activationr13_2 <= activation13_2;
    activationr14_2 <= activation14_2;
    activationr15_2 <= activation15_2;
  end

  //--------------------------------------------------------------------------
  // Layer-3 randomness taps
  //--------------------------------------------------------------------------
 wire activation0_3;
 wire activation1_3;
 wire activation2_3;
 wire activation3_3;
 wire activation4_3;
 wire activation5_3;
 wire activation6_3;
 wire activation7_3;
 wire activation8_3;
 wire activation9_3;
 wire activation10_3;
 wire activation11_3;
 wire activation12_3;
 wire activation13_3;
 wire activation14_3;
 wire activation15_3;
 reg activationr0_3;
 reg activationr1_3;
 reg activationr2_3;
 reg activationr3_3;
 reg activationr4_3;
 reg activationr5_3;
 reg activationr6_3;
 reg activationr7_3;
 reg activationr8_3;
 reg activationr9_3;
 reg activationr10_3;
 reg activationr11_3;
 reg activationr12_3;
 reg activationr13_3;
 reg activationr14_3;
 reg activationr15_3;
  activation_and_conversion_3 layer3_inst (
    .clk(clk),
    .inputs0_3(activation0_2),
    .inputs1_3(activation1_2),
    .inputs2_3(activation2_2),
    .inputs3_3(activation3_2),
    .inputs4_3(activation4_2),
    .inputs5_3(activation5_2),
    .inputs6_3(activation6_2),
    .inputs7_3(activation7_2),
    .inputs8_3(activation8_2),
    .inputs9_3(activation9_2),
    .inputs10_3(activation10_2),
    .inputs11_3(activation11_2),
    .inputs12_3(activation12_2),
    .inputs13_3(activation13_2),
    .inputs14_3(activation14_2),
    .inputs15_3(activation15_2),
    .w1_3(w1_3),
    .w2_3(w2_3),
    .w3_3(w3_3),
    .w4_3(w4_3),
    .w5_3(w5_3),
    .w6_3(w6_3),
    .w7_3(w7_3),
    .w8_3(w8_3),
    .w9_3(w9_3),
    .w10_3(w10_3),
    .w11_3(w11_3),
    .w12_3(w12_3),
    .w13_3(w13_3),
    .w14_3(w14_3),
    .w15_3(w15_3),
    .w16_3(w16_3),
    .b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3), .b5_3(b5_3), .b6_3(b6_3), .b7_3(b7_3), .b8_3(b8_3), .b9_3(b9_3), .b10_3(b10_3), .b11_3(b11_3), .b12_3(b12_3), .b13_3(b13_3), .b14_3(b14_3), .b15_3(b15_3), .b16_3(b16_3),
    .activation0_3(activation0_3), 
    .activation1_3(activation1_3), 
    .activation2_3(activation2_3), 
    .activation3_3(activation3_3), 
    .activation4_3(activation4_3), 
    .activation5_3(activation5_3), 
    .activation6_3(activation6_3), 
    .activation7_3(activation7_3), 
    .activation8_3(activation8_3), 
    .activation9_3(activation9_3), 
    .activation10_3(activation10_3), 
    .activation11_3(activation11_3), 
    .activation12_3(activation12_3), 
    .activation13_3(activation13_3), 
    .activation14_3(activation14_3), 
    .activation15_3(activation15_3)
  );

  always @(posedge clk) begin
    activationr0_3 <= activation0_3;
    activationr1_3 <= activation1_3;
    activationr2_3 <= activation2_3;
    activationr3_3 <= activation3_3;
    activationr4_3 <= activation4_3;
    activationr5_3 <= activation5_3;
    activationr6_3 <= activation6_3;
    activationr7_3 <= activation7_3;
    activationr8_3 <= activation8_3;
    activationr9_3 <= activation9_3;
    activationr10_3 <= activation10_3;
    activationr11_3 <= activation11_3;
    activationr12_3 <= activation12_3;
    activationr13_3 <= activation13_3;
    activationr14_3 <= activation14_3;
    activationr15_3 <= activation15_3;
  end

  //--------------------------------------------------------------------------
  // Layer-4 randomness taps
  //--------------------------------------------------------------------------
    reg r0_0;
    reg r0_0bar;
    reg r1_0;
    reg r1_0bar;
    reg r2_0;
    reg r2_0bar;
    reg r3_0;
    reg r3_0bar;
    reg r4_0;
    reg r4_0bar;
    reg r5_0;
    reg r5_0bar;
    reg r6_0;
    reg r6_0bar;
    reg r0_1;
    reg r0_1bar;
    reg r1_1;
    reg r1_1bar;
    reg r2_1;
    reg r2_1bar;
    reg r3_1;
    reg r3_1bar;
    reg r4_1;
    reg r4_1bar;
    reg r5_1;
    reg r5_1bar;
    reg r6_1;
    reg r6_1bar;
    reg r0_2;
    reg r0_2bar;
    reg r1_2;
    reg r1_2bar;
    reg r2_2;
    reg r2_2bar;
    reg r3_2;
    reg r3_2bar;
    reg r4_2;
    reg r4_2bar;
    reg r5_2;
    reg r5_2bar;
    reg r6_2;
    reg r6_2bar;
    reg r0_3;
    reg r0_3bar;
    reg r1_3;
    reg r1_3bar;
    reg r2_3;
    reg r2_3bar;
    reg r3_3;
    reg r3_3bar;
    reg r4_3;
    reg r4_3bar;
    reg r5_3;
    reg r5_3bar;
    reg r6_3;
    reg r6_3bar;
    reg r0_4;
    reg r0_4bar;
    reg r1_4;
    reg r1_4bar;
    reg r2_4;
    reg r2_4bar;
    reg r3_4;
    reg r3_4bar;
    reg r4_4;
    reg r4_4bar;
    reg r5_4;
    reg r5_4bar;
    reg r6_4;
    reg r6_4bar;
    reg r0_5;
    reg r0_5bar;
    reg r1_5;
    reg r1_5bar;
    reg r2_5;
    reg r2_5bar;
    reg r3_5;
    reg r3_5bar;
    reg r4_5;
    reg r4_5bar;
    reg r5_5;
    reg r5_5bar;
    reg r6_5;
    reg r6_5bar;
    reg r0_6;
    reg r0_6bar;
    reg r1_6;
    reg r1_6bar;
    reg r2_6;
    reg r2_6bar;
    reg r3_6;
    reg r3_6bar;
    reg r4_6;
    reg r4_6bar;
    reg r5_6;
    reg r5_6bar;
    reg r6_6;
    reg r6_6bar;
  initial begin
    r0_0 = $random;
    r0_0bar = $random;
    r1_0 = $random;
    r1_0bar = $random;
    r2_0 = $random;
    r2_0bar = $random;
    r3_0 = $random;
    r3_0bar = $random;
    r4_0 = $random;
    r4_0bar = $random;
    r5_0 = $random;
    r5_0bar = $random;
    r6_0 = $random;
    r6_0bar = $random;
    r0_1 = $random;
    r0_1bar = $random;
    r1_1 = $random;
    r1_1bar = $random;
    r2_1 = $random;
    r2_1bar = $random;
    r3_1 = $random;
    r3_1bar = $random;
    r4_1 = $random;
    r4_1bar = $random;
    r5_1 = $random;
    r5_1bar = $random;
    r6_1 = $random;
    r6_1bar = $random;
    r0_2 = $random;
    r0_2bar = $random;
    r1_2 = $random;
    r1_2bar = $random;
    r2_2 = $random;
    r2_2bar = $random;
    r3_2 = $random;
    r3_2bar = $random;
    r4_2 = $random;
    r4_2bar = $random;
    r5_2 = $random;
    r5_2bar = $random;
    r6_2 = $random;
    r6_2bar = $random;
    r0_3 = $random;
    r0_3bar = $random;
    r1_3 = $random;
    r1_3bar = $random;
    r2_3 = $random;
    r2_3bar = $random;
    r3_3 = $random;
    r3_3bar = $random;
    r4_3 = $random;
    r4_3bar = $random;
    r5_3 = $random;
    r5_3bar = $random;
    r6_3 = $random;
    r6_3bar = $random;
    r0_4 = $random;
    r0_4bar = $random;
    r1_4 = $random;
    r1_4bar = $random;
    r2_4 = $random;
    r2_4bar = $random;
    r3_4 = $random;
    r3_4bar = $random;
    r4_4 = $random;
    r4_4bar = $random;
    r5_4 = $random;
    r5_4bar = $random;
    r6_4 = $random;
    r6_4bar = $random;
    r0_5 = $random;
    r0_5bar = $random;
    r1_5 = $random;
    r1_5bar = $random;
    r2_5 = $random;
    r2_5bar = $random;
    r3_5 = $random;
    r3_5bar = $random;
    r4_5 = $random;
    r4_5bar = $random;
    r5_5 = $random;
    r5_5bar = $random;
    r6_5 = $random;
    r6_5bar = $random;
    r0_6 = $random;
    r0_6bar = $random;
    r1_6 = $random;
    r1_6bar = $random;
    r2_6 = $random;
    r2_6bar = $random;
    r3_6 = $random;
    r3_6bar = $random;
    r4_6 = $random;
    r4_6bar = $random;
    r5_6 = $random;
    r5_6bar = $random;
    r6_6 = $random;
    r6_6bar = $random;
    #1;
  end

 reg a0_reg ;
 reg a1_reg ;
 reg a2_reg ;
 reg a3_reg ;
 reg a4_reg ;
 reg a5_reg ;
 reg a6_reg ;
 reg a7_reg ;
  output_layer_max layer4 (
    .clk(clk),
    .inputs0_4(activation0_3),
    .inputs1_4(activation1_3),
    .inputs2_4(activation2_3),
    .inputs3_4(activation3_3),
    .inputs4_4(activation4_3),
    .inputs5_4(activation5_3),
    .inputs6_4(activation6_3),
    .inputs7_4(activation7_3),
    .inputs8_4(activation8_3),
    .inputs9_4(activation9_3),
    .inputs10_4(activation10_3),
    .inputs11_4(activation11_3),
    .inputs12_4(activation12_3),
    .inputs13_4(activation13_3),
    .inputs14_4(activation14_3),
    .inputs15_4(activation15_3),
    .w1_4(w1_4),
    .w2_4(w2_4),
    .w3_4(w3_4),
    .w4_4(w4_4),
    .w5_4(w5_4),
    .w6_4(w6_4),
    .w7_4(w7_4),
    .w8_4(w8_4),
    .b1_4(b1_4), .b2_4(b2_4), .b3_4(b3_4), .b4_4(b4_4), .b5_4(b5_4), .b6_4(b6_4), .b7_4(b7_4), .b8_4(b8_4),
    .r0_0(r0_0),
    .r1_0(r1_0),
    .r2_0(r2_0),
    .r3_0(r3_0),
    .r4_0(r4_0),
    .r5_0(r5_0),
    .r6_0(r6_0),
    .r0_1(r0_1),
    .r1_1(r1_1),
    .r2_1(r2_1),
    .r3_1(r3_1),
    .r4_1(r4_1),
    .r5_1(r5_1),
    .r6_1(r6_1),
    .r0_2(r0_2),
    .r1_2(r1_2),
    .r2_2(r2_2),
    .r3_2(r3_2),
    .r4_2(r4_2),
    .r5_2(r5_2),
    .r6_2(r6_2),
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r6_3(r6_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r6_4(r6_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r6_5(r6_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r6_6(r6_6),
    .a0(a0),
    .a1(a1),
    .a2(a2),
    .a3(a3),
    .a4(a4),
    .a5(a5),
    .a6(a6),
    .a7(a7)
  );

  always @(posedge clk) begin
    a0_reg <= a0;
    a1_reg <= a1;
    a2_reg <= a2;
    a3_reg <= a3;
    a4_reg <= a4;
    a5_reg <= a5;
    a6_reg <= a6;
    a7_reg <= a7;
  end

endmodule
`default_nettype wire