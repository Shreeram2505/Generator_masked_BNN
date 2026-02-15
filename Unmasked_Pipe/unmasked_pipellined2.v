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
    output wire [11:0] sum
);

    wire [8:0] stage0_0_lo_1;
    wire [8:0] stage0_1_lo_1;
    wire [8:0] stage0_2_lo_1;
    wire [8:0] stage0_3_lo_1;
    wire [8:0] stage0_4_lo_1;
    wire [8:0] stage0_5_lo_1;
    wire [8:0] stage0_6_lo_1;
    wire [8:0] stage0_7_lo_1;
    wire [9:0] stage1_0_lo_1;
    wire [9:0] stage1_1_lo_1;
    wire [9:0] stage1_2_lo_1;
    wire [9:0] stage1_3_lo_1;
    wire [10:0] stage2_0_lo_1;
    wire [10:0] stage2_1_lo_1;
    wire [11:0] stage3_0_lo_1;
    reg  [8:0] stage0_0_1;
    reg  [8:0] stage0_1_1;
    reg  [8:0] stage0_2_1;
    reg  [8:0] stage0_3_1;
    reg  [8:0] stage0_4_1;
    reg  [8:0] stage0_5_1;
    reg  [8:0] stage0_6_1;
    reg  [8:0] stage0_7_1;
    reg  [9:0] stage1_0_1;
    reg  [9:0] stage1_1_1;
    reg  [9:0] stage1_2_1;
    reg  [9:0] stage1_3_1;
    reg  [10:0] stage2_0_1;
    reg  [10:0] stage2_1_1;
    reg  [11:0] stage3_0_1;

    add8bit_1 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_0 (.a(stage0_0_1), .b(stage0_1_1), .cin(1'b0), .y(stage1_0_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_1 (.a(stage0_2_1), .b(stage0_3_1), .cin(1'b0), .y(stage1_1_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_2 (.a(stage0_4_1), .b(stage0_5_1), .cin(1'b0), .y(stage1_2_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_3 (.a(stage0_6_1), .b(stage0_7_1), .cin(1'b0), .y(stage1_3_lo_1), .cout(), .cout_bar());
    add10bit_1 u2_0 (.a(stage1_0_1), .b(stage1_1_1), .cin(1'b0), .y(stage2_0_lo_1), .cout(), .cout_bar());
    add10bit_1 u2_1 (.a(stage1_2_1), .b(stage1_3_1), .cin(1'b0), .y(stage2_1_lo_1), .cout(), .cout_bar());
    add11bit_1 u3_0 (.a(stage2_0_1), .b(stage2_1_1), .cin(1'b0), .y(stage3_0_lo_1), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_1;

    always @(posedge clk) begin
        stage0_0_1 <=  stage0_0_lo_1;
        stage0_1_1 <=  stage0_1_lo_1;
        stage0_2_1 <=  stage0_2_lo_1;
        stage0_3_1 <=  stage0_3_lo_1;
        stage0_4_1 <=  stage0_4_lo_1;
        stage0_5_1 <=  stage0_5_lo_1;
        stage0_6_1 <=  stage0_6_lo_1;
        stage0_7_1 <=  stage0_7_lo_1;
        stage1_0_1 <=  stage1_0_lo_1;
        stage1_1_1 <=  stage1_1_lo_1;
        stage1_2_1 <=  stage1_2_lo_1;
        stage1_3_1 <=  stage1_3_lo_1;
        stage2_0_1 <=  stage2_0_lo_1;
        stage2_1_1 <=  stage2_1_lo_1;
        stage3_0_1 <=  stage3_0_lo_1;
    end
endmodule


module layer1(
    input clk,
    input [7:0] inputs0_1 , inputs1_1 , inputs2_1 , inputs3_1 , inputs4_1 , inputs5_1 , inputs6_1 , inputs7_1 , inputs8_1 , inputs9_1 , inputs10_1 , inputs11_1 , inputs12_1 , inputs13_1 , inputs14_1 , inputs15_1,
    input [15:0] w1_1, w2_1, w3_1, w4_1, w5_1, w6_1, w7_1, w8_1,
    input [11:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1,
    output [12:0] biased_sum0_0, biased_sum1_0, biased_sum2_0, biased_sum3_0, biased_sum4_0, biased_sum5_0, biased_sum6_0, biased_sum7_0
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

    wire [11:0] sum1 [7:0];
    wire [12:0] biased_sum1 [7:0];

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
    weighted_inputs_1 w16 (.inputs(inputs0_1), .w(w2_1[0]), .wi(weighted_inputs2_0));
    weighted_inputs_1 w17 (.inputs(inputs1_1), .w(w2_1[1]), .wi(weighted_inputs2_1));
    weighted_inputs_1 w18 (.inputs(inputs2_1), .w(w2_1[2]), .wi(weighted_inputs2_2));
    weighted_inputs_1 w19 (.inputs(inputs3_1), .w(w2_1[3]), .wi(weighted_inputs2_3));
    weighted_inputs_1 w20 (.inputs(inputs4_1), .w(w2_1[4]), .wi(weighted_inputs2_4));
    weighted_inputs_1 w21 (.inputs(inputs5_1), .w(w2_1[5]), .wi(weighted_inputs2_5));
    weighted_inputs_1 w22 (.inputs(inputs6_1), .w(w2_1[6]), .wi(weighted_inputs2_6));
    weighted_inputs_1 w23 (.inputs(inputs7_1), .w(w2_1[7]), .wi(weighted_inputs2_7));
    weighted_inputs_1 w24 (.inputs(inputs8_1), .w(w2_1[8]), .wi(weighted_inputs2_8));
    weighted_inputs_1 w25 (.inputs(inputs9_1), .w(w2_1[9]), .wi(weighted_inputs2_9));
    weighted_inputs_1 w26 (.inputs(inputs10_1), .w(w2_1[10]), .wi(weighted_inputs2_10));
    weighted_inputs_1 w27 (.inputs(inputs11_1), .w(w2_1[11]), .wi(weighted_inputs2_11));
    weighted_inputs_1 w28 (.inputs(inputs12_1), .w(w2_1[12]), .wi(weighted_inputs2_12));
    weighted_inputs_1 w29 (.inputs(inputs13_1), .w(w2_1[13]), .wi(weighted_inputs2_13));
    weighted_inputs_1 w30 (.inputs(inputs14_1), .w(w2_1[14]), .wi(weighted_inputs2_14));
    weighted_inputs_1 w31 (.inputs(inputs15_1), .w(w2_1[15]), .wi(weighted_inputs2_15));
    weighted_inputs_1 w32 (.inputs(inputs0_1), .w(w3_1[0]), .wi(weighted_inputs3_0));
    weighted_inputs_1 w33 (.inputs(inputs1_1), .w(w3_1[1]), .wi(weighted_inputs3_1));
    weighted_inputs_1 w34 (.inputs(inputs2_1), .w(w3_1[2]), .wi(weighted_inputs3_2));
    weighted_inputs_1 w35 (.inputs(inputs3_1), .w(w3_1[3]), .wi(weighted_inputs3_3));
    weighted_inputs_1 w36 (.inputs(inputs4_1), .w(w3_1[4]), .wi(weighted_inputs3_4));
    weighted_inputs_1 w37 (.inputs(inputs5_1), .w(w3_1[5]), .wi(weighted_inputs3_5));
    weighted_inputs_1 w38 (.inputs(inputs6_1), .w(w3_1[6]), .wi(weighted_inputs3_6));
    weighted_inputs_1 w39 (.inputs(inputs7_1), .w(w3_1[7]), .wi(weighted_inputs3_7));
    weighted_inputs_1 w40 (.inputs(inputs8_1), .w(w3_1[8]), .wi(weighted_inputs3_8));
    weighted_inputs_1 w41 (.inputs(inputs9_1), .w(w3_1[9]), .wi(weighted_inputs3_9));
    weighted_inputs_1 w42 (.inputs(inputs10_1), .w(w3_1[10]), .wi(weighted_inputs3_10));
    weighted_inputs_1 w43 (.inputs(inputs11_1), .w(w3_1[11]), .wi(weighted_inputs3_11));
    weighted_inputs_1 w44 (.inputs(inputs12_1), .w(w3_1[12]), .wi(weighted_inputs3_12));
    weighted_inputs_1 w45 (.inputs(inputs13_1), .w(w3_1[13]), .wi(weighted_inputs3_13));
    weighted_inputs_1 w46 (.inputs(inputs14_1), .w(w3_1[14]), .wi(weighted_inputs3_14));
    weighted_inputs_1 w47 (.inputs(inputs15_1), .w(w3_1[15]), .wi(weighted_inputs3_15));
    weighted_inputs_1 w48 (.inputs(inputs0_1), .w(w4_1[0]), .wi(weighted_inputs4_0));
    weighted_inputs_1 w49 (.inputs(inputs1_1), .w(w4_1[1]), .wi(weighted_inputs4_1));
    weighted_inputs_1 w50 (.inputs(inputs2_1), .w(w4_1[2]), .wi(weighted_inputs4_2));
    weighted_inputs_1 w51 (.inputs(inputs3_1), .w(w4_1[3]), .wi(weighted_inputs4_3));
    weighted_inputs_1 w52 (.inputs(inputs4_1), .w(w4_1[4]), .wi(weighted_inputs4_4));
    weighted_inputs_1 w53 (.inputs(inputs5_1), .w(w4_1[5]), .wi(weighted_inputs4_5));
    weighted_inputs_1 w54 (.inputs(inputs6_1), .w(w4_1[6]), .wi(weighted_inputs4_6));
    weighted_inputs_1 w55 (.inputs(inputs7_1), .w(w4_1[7]), .wi(weighted_inputs4_7));
    weighted_inputs_1 w56 (.inputs(inputs8_1), .w(w4_1[8]), .wi(weighted_inputs4_8));
    weighted_inputs_1 w57 (.inputs(inputs9_1), .w(w4_1[9]), .wi(weighted_inputs4_9));
    weighted_inputs_1 w58 (.inputs(inputs10_1), .w(w4_1[10]), .wi(weighted_inputs4_10));
    weighted_inputs_1 w59 (.inputs(inputs11_1), .w(w4_1[11]), .wi(weighted_inputs4_11));
    weighted_inputs_1 w60 (.inputs(inputs12_1), .w(w4_1[12]), .wi(weighted_inputs4_12));
    weighted_inputs_1 w61 (.inputs(inputs13_1), .w(w4_1[13]), .wi(weighted_inputs4_13));
    weighted_inputs_1 w62 (.inputs(inputs14_1), .w(w4_1[14]), .wi(weighted_inputs4_14));
    weighted_inputs_1 w63 (.inputs(inputs15_1), .w(w4_1[15]), .wi(weighted_inputs4_15));
    weighted_inputs_1 w64 (.inputs(inputs0_1), .w(w5_1[0]), .wi(weighted_inputs5_0));
    weighted_inputs_1 w65 (.inputs(inputs1_1), .w(w5_1[1]), .wi(weighted_inputs5_1));
    weighted_inputs_1 w66 (.inputs(inputs2_1), .w(w5_1[2]), .wi(weighted_inputs5_2));
    weighted_inputs_1 w67 (.inputs(inputs3_1), .w(w5_1[3]), .wi(weighted_inputs5_3));
    weighted_inputs_1 w68 (.inputs(inputs4_1), .w(w5_1[4]), .wi(weighted_inputs5_4));
    weighted_inputs_1 w69 (.inputs(inputs5_1), .w(w5_1[5]), .wi(weighted_inputs5_5));
    weighted_inputs_1 w70 (.inputs(inputs6_1), .w(w5_1[6]), .wi(weighted_inputs5_6));
    weighted_inputs_1 w71 (.inputs(inputs7_1), .w(w5_1[7]), .wi(weighted_inputs5_7));
    weighted_inputs_1 w72 (.inputs(inputs8_1), .w(w5_1[8]), .wi(weighted_inputs5_8));
    weighted_inputs_1 w73 (.inputs(inputs9_1), .w(w5_1[9]), .wi(weighted_inputs5_9));
    weighted_inputs_1 w74 (.inputs(inputs10_1), .w(w5_1[10]), .wi(weighted_inputs5_10));
    weighted_inputs_1 w75 (.inputs(inputs11_1), .w(w5_1[11]), .wi(weighted_inputs5_11));
    weighted_inputs_1 w76 (.inputs(inputs12_1), .w(w5_1[12]), .wi(weighted_inputs5_12));
    weighted_inputs_1 w77 (.inputs(inputs13_1), .w(w5_1[13]), .wi(weighted_inputs5_13));
    weighted_inputs_1 w78 (.inputs(inputs14_1), .w(w5_1[14]), .wi(weighted_inputs5_14));
    weighted_inputs_1 w79 (.inputs(inputs15_1), .w(w5_1[15]), .wi(weighted_inputs5_15));
    weighted_inputs_1 w80 (.inputs(inputs0_1), .w(w6_1[0]), .wi(weighted_inputs6_0));
    weighted_inputs_1 w81 (.inputs(inputs1_1), .w(w6_1[1]), .wi(weighted_inputs6_1));
    weighted_inputs_1 w82 (.inputs(inputs2_1), .w(w6_1[2]), .wi(weighted_inputs6_2));
    weighted_inputs_1 w83 (.inputs(inputs3_1), .w(w6_1[3]), .wi(weighted_inputs6_3));
    weighted_inputs_1 w84 (.inputs(inputs4_1), .w(w6_1[4]), .wi(weighted_inputs6_4));
    weighted_inputs_1 w85 (.inputs(inputs5_1), .w(w6_1[5]), .wi(weighted_inputs6_5));
    weighted_inputs_1 w86 (.inputs(inputs6_1), .w(w6_1[6]), .wi(weighted_inputs6_6));
    weighted_inputs_1 w87 (.inputs(inputs7_1), .w(w6_1[7]), .wi(weighted_inputs6_7));
    weighted_inputs_1 w88 (.inputs(inputs8_1), .w(w6_1[8]), .wi(weighted_inputs6_8));
    weighted_inputs_1 w89 (.inputs(inputs9_1), .w(w6_1[9]), .wi(weighted_inputs6_9));
    weighted_inputs_1 w90 (.inputs(inputs10_1), .w(w6_1[10]), .wi(weighted_inputs6_10));
    weighted_inputs_1 w91 (.inputs(inputs11_1), .w(w6_1[11]), .wi(weighted_inputs6_11));
    weighted_inputs_1 w92 (.inputs(inputs12_1), .w(w6_1[12]), .wi(weighted_inputs6_12));
    weighted_inputs_1 w93 (.inputs(inputs13_1), .w(w6_1[13]), .wi(weighted_inputs6_13));
    weighted_inputs_1 w94 (.inputs(inputs14_1), .w(w6_1[14]), .wi(weighted_inputs6_14));
    weighted_inputs_1 w95 (.inputs(inputs15_1), .w(w6_1[15]), .wi(weighted_inputs6_15));
    weighted_inputs_1 w96 (.inputs(inputs0_1), .w(w7_1[0]), .wi(weighted_inputs7_0));
    weighted_inputs_1 w97 (.inputs(inputs1_1), .w(w7_1[1]), .wi(weighted_inputs7_1));
    weighted_inputs_1 w98 (.inputs(inputs2_1), .w(w7_1[2]), .wi(weighted_inputs7_2));
    weighted_inputs_1 w99 (.inputs(inputs3_1), .w(w7_1[3]), .wi(weighted_inputs7_3));
    weighted_inputs_1 w100 (.inputs(inputs4_1), .w(w7_1[4]), .wi(weighted_inputs7_4));
    weighted_inputs_1 w101 (.inputs(inputs5_1), .w(w7_1[5]), .wi(weighted_inputs7_5));
    weighted_inputs_1 w102 (.inputs(inputs6_1), .w(w7_1[6]), .wi(weighted_inputs7_6));
    weighted_inputs_1 w103 (.inputs(inputs7_1), .w(w7_1[7]), .wi(weighted_inputs7_7));
    weighted_inputs_1 w104 (.inputs(inputs8_1), .w(w7_1[8]), .wi(weighted_inputs7_8));
    weighted_inputs_1 w105 (.inputs(inputs9_1), .w(w7_1[9]), .wi(weighted_inputs7_9));
    weighted_inputs_1 w106 (.inputs(inputs10_1), .w(w7_1[10]), .wi(weighted_inputs7_10));
    weighted_inputs_1 w107 (.inputs(inputs11_1), .w(w7_1[11]), .wi(weighted_inputs7_11));
    weighted_inputs_1 w108 (.inputs(inputs12_1), .w(w7_1[12]), .wi(weighted_inputs7_12));
    weighted_inputs_1 w109 (.inputs(inputs13_1), .w(w7_1[13]), .wi(weighted_inputs7_13));
    weighted_inputs_1 w110 (.inputs(inputs14_1), .w(w7_1[14]), .wi(weighted_inputs7_14));
    weighted_inputs_1 w111 (.inputs(inputs15_1), .w(w7_1[15]), .wi(weighted_inputs7_15));
    weighted_inputs_1 w112 (.inputs(inputs0_1), .w(w8_1[0]), .wi(weighted_inputs8_0));
    weighted_inputs_1 w113 (.inputs(inputs1_1), .w(w8_1[1]), .wi(weighted_inputs8_1));
    weighted_inputs_1 w114 (.inputs(inputs2_1), .w(w8_1[2]), .wi(weighted_inputs8_2));
    weighted_inputs_1 w115 (.inputs(inputs3_1), .w(w8_1[3]), .wi(weighted_inputs8_3));
    weighted_inputs_1 w116 (.inputs(inputs4_1), .w(w8_1[4]), .wi(weighted_inputs8_4));
    weighted_inputs_1 w117 (.inputs(inputs5_1), .w(w8_1[5]), .wi(weighted_inputs8_5));
    weighted_inputs_1 w118 (.inputs(inputs6_1), .w(w8_1[6]), .wi(weighted_inputs8_6));
    weighted_inputs_1 w119 (.inputs(inputs7_1), .w(w8_1[7]), .wi(weighted_inputs8_7));
    weighted_inputs_1 w120 (.inputs(inputs8_1), .w(w8_1[8]), .wi(weighted_inputs8_8));
    weighted_inputs_1 w121 (.inputs(inputs9_1), .w(w8_1[9]), .wi(weighted_inputs8_9));
    weighted_inputs_1 w122 (.inputs(inputs10_1), .w(w8_1[10]), .wi(weighted_inputs8_10));
    weighted_inputs_1 w123 (.inputs(inputs11_1), .w(w8_1[11]), .wi(weighted_inputs8_11));
    weighted_inputs_1 w124 (.inputs(inputs12_1), .w(w8_1[12]), .wi(weighted_inputs8_12));
    weighted_inputs_1 w125 (.inputs(inputs13_1), .w(w8_1[13]), .wi(weighted_inputs8_13));
    weighted_inputs_1 w126 (.inputs(inputs14_1), .w(w8_1[14]), .wi(weighted_inputs8_14));
    weighted_inputs_1 w127 (.inputs(inputs15_1), .w(w8_1[15]), .wi(weighted_inputs8_15));
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
        .sum(sum1[7])
    );
    add12bit_1 u0 (.a(sum1[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1[0]));
    add12bit_1 u1 (.a(sum1[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1[1]));
    add12bit_1 u2 (.a(sum1[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1[2]));
    add12bit_1 u3 (.a(sum1[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1[3]));
    add12bit_1 u4 (.a(sum1[4]), .b(b5_1), .cin(1'b0), .y(biased_sum1[4]));
    add12bit_1 u5 (.a(sum1[5]), .b(b6_1), .cin(1'b0), .y(biased_sum1[5]));
    add12bit_1 u6 (.a(sum1[6]), .b(b7_1), .cin(1'b0), .y(biased_sum1[6]));
    add12bit_1 u7 (.a(sum1[7]), .b(b8_1), .cin(1'b0), .y(biased_sum1[7]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    assign biased_sum4_0 = biased_sum1[4];
    assign biased_sum5_0 = biased_sum1[5];
    assign biased_sum6_0 = biased_sum1[6];
    assign biased_sum7_0 = biased_sum1[7];
    always @(posedge clk) begin
        $display("----- BNN LAYER 1 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_1, inputs1_1, inputs2_1, inputs3_1, inputs4_1, inputs5_1, inputs6_1, inputs7_1, inputs8_1, inputs9_1, inputs10_1, inputs11_1, inputs12_1, inputs13_1, inputs14_1, inputs15_1);
        $display("Weights: %b %b %b %b %b %b %b %b", w1_1, w2_1, w3_1, w4_1, w5_1, w6_1, w7_1, w8_1);
        $display("sum1: %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7]);
        $display("biased_sum1: %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7]);
    end
endmodule


module activation_1 (

    input [12:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[12] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_1 (
    input  [12:0] inputs0_0,
    input  [12:0] inputs1_0,
    input  [12:0] inputs2_0,
    input  [12:0] inputs3_0,
    input  [12:0] inputs4_0,
    input  [12:0] inputs5_0,
    input  [12:0] inputs6_0,
    input  [12:0] inputs7_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3,
    output wire activation4,
    output wire activation5,
    output wire activation6,
    output wire activation7
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
  input  wire [15:0] w1_1,
  input  wire [15:0] w2_1,
  input  wire [15:0] w3_1,
  input  wire [15:0] w4_1,
  input  wire [15:0] w5_1,
  input  wire [15:0] w6_1,
  input  wire [15:0] w7_1,
  input  wire [15:0] w8_1,
  input  wire [11:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1,
  output wire activation0_1, 

  output wire activation1_1, 

  output wire activation2_1, 

  output wire activation3_1, 

  output wire activation4_1, 

  output wire activation5_1, 

  output wire activation6_1, 

  output wire activation7_1
);

  wire [12:0] biased_sum0_0;
  wire [12:0] biased_sum1_0;
  wire [12:0] biased_sum2_0;
  wire [12:0] biased_sum3_0;
  wire [12:0] biased_sum4_0;
  wire [12:0] biased_sum5_0;
  wire [12:0] biased_sum6_0;
  wire [12:0] biased_sum7_0;

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
    .w1_1(w1_1),
    .w2_1(w2_1),
    .w3_1(w3_1),
    .w4_1(w4_1),
    .w5_1(w5_1),
    .w6_1(w6_1),
    .w7_1(w7_1),
    .w8_1(w8_1),
    .b1_1(b1_1),
    .b2_1(b2_1),
    .b3_1(b3_1),
    .b4_1(b4_1),
    .b5_1(b5_1),
    .b6_1(b6_1),
    .b7_1(b7_1),
    .b8_1(b8_1),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0),
    .biased_sum4_0(biased_sum4_0),
    .biased_sum5_0(biased_sum5_0),
    .biased_sum6_0(biased_sum6_0),
    .biased_sum7_0(biased_sum7_0)
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
    .activation0(activation0_1),
    .activation1(activation1_1),
    .activation2(activation2_1),
    .activation3(activation3_1),
    .activation4(activation4_1),
    .activation5(activation5_1),
    .activation6(activation6_1),
    .activation7(activation7_1)
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
    .activation0(activation0_1),
    .activation1(activation1_1),
    .activation2(activation2_1),
    .activation3(activation3_1),
    .activation4(activation4_1),
    .activation5(activation5_1),
    .activation6(activation6_1),
    .activation7(activation7_1)
  );

    always @(posedge clk) begin
    $display("----- LAYER 1   boolean activations -----");
    $display("activation : %b %b %b %b %b %b %b %b", activation0_1, activation1_1, activation2_1, activation3_1, activation4_1, activation5_1, activation6_1, activation7_1);
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
    output wire [3:0] sum
);

    wire [1:0] stage0_0_lo_2;
    wire [1:0] stage0_1_lo_2;
    wire [1:0] stage0_2_lo_2;
    wire [1:0] stage0_3_lo_2;
    wire [2:0] stage1_0_lo_2;
    wire [2:0] stage1_1_lo_2;
    wire [3:0] stage2_0_lo_2;
    reg  [1:0] stage0_0_2;
    reg  [1:0] stage0_1_2;
    reg  [1:0] stage0_2_2;
    reg  [1:0] stage0_3_2;
    reg  [2:0] stage1_0_2;
    reg  [2:0] stage1_1_2;
    reg  [3:0] stage2_0_2;

    add1bit_2 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_2), .cout(), .cout_bar());
    add2bit_2 u1_0 (.a(stage0_0_2), .b(stage0_1_2), .cin(1'b0), .y(stage1_0_lo_2), .cout(), .cout_bar());
    add2bit_2 u1_1 (.a(stage0_2_2), .b(stage0_3_2), .cin(1'b0), .y(stage1_1_lo_2), .cout(), .cout_bar());
    add3bit_2 u2_0 (.a(stage1_0_2), .b(stage1_1_2), .cin(1'b0), .y(stage2_0_lo_2), .cout(), .cout_bar());

    assign sum =  stage2_0_lo_2;

    always @(posedge clk) begin
        stage0_0_2 <=  stage0_0_lo_2;
        stage0_1_2 <=  stage0_1_lo_2;
        stage0_2_2 <=  stage0_2_lo_2;
        stage0_3_2 <=  stage0_3_lo_2;
        stage1_0_2 <=  stage1_0_lo_2;
        stage1_1_2 <=  stage1_1_lo_2;
        stage2_0_2 <=  stage2_0_lo_2;
    end
endmodule


module layer2(
    input clk,
    input [0:0] inputs0_2 , inputs1_2 , inputs2_2 , inputs3_2 , inputs4_2 , inputs5_2 , inputs6_2 , inputs7_2,
    input [7:0] w1_2, w2_2, w3_2, w4_2, w5_2, w6_2, w7_2, w8_2,
    input [3:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2,
    output [4:0] biased_sum0_0 , biased_sum1_0 , biased_sum2_0 , biased_sum3_0 , biased_sum4_0 , biased_sum5_0 , biased_sum6_0 , biased_sum7_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs1_4;
    wire [0:0] weighted_inputs1_5;
    wire [0:0] weighted_inputs1_6;
    wire [0:0] weighted_inputs1_7;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;
    wire [0:0] weighted_inputs2_4;
    wire [0:0] weighted_inputs2_5;
    wire [0:0] weighted_inputs2_6;
    wire [0:0] weighted_inputs2_7;
    wire [0:0] weighted_inputs3_0;
    wire [0:0] weighted_inputs3_1;
    wire [0:0] weighted_inputs3_2;
    wire [0:0] weighted_inputs3_3;
    wire [0:0] weighted_inputs3_4;
    wire [0:0] weighted_inputs3_5;
    wire [0:0] weighted_inputs3_6;
    wire [0:0] weighted_inputs3_7;
    wire [0:0] weighted_inputs4_0;
    wire [0:0] weighted_inputs4_1;
    wire [0:0] weighted_inputs4_2;
    wire [0:0] weighted_inputs4_3;
    wire [0:0] weighted_inputs4_4;
    wire [0:0] weighted_inputs4_5;
    wire [0:0] weighted_inputs4_6;
    wire [0:0] weighted_inputs4_7;
    wire [0:0] weighted_inputs5_0;
    wire [0:0] weighted_inputs5_1;
    wire [0:0] weighted_inputs5_2;
    wire [0:0] weighted_inputs5_3;
    wire [0:0] weighted_inputs5_4;
    wire [0:0] weighted_inputs5_5;
    wire [0:0] weighted_inputs5_6;
    wire [0:0] weighted_inputs5_7;
    wire [0:0] weighted_inputs6_0;
    wire [0:0] weighted_inputs6_1;
    wire [0:0] weighted_inputs6_2;
    wire [0:0] weighted_inputs6_3;
    wire [0:0] weighted_inputs6_4;
    wire [0:0] weighted_inputs6_5;
    wire [0:0] weighted_inputs6_6;
    wire [0:0] weighted_inputs6_7;
    wire [0:0] weighted_inputs7_0;
    wire [0:0] weighted_inputs7_1;
    wire [0:0] weighted_inputs7_2;
    wire [0:0] weighted_inputs7_3;
    wire [0:0] weighted_inputs7_4;
    wire [0:0] weighted_inputs7_5;
    wire [0:0] weighted_inputs7_6;
    wire [0:0] weighted_inputs7_7;
    wire [0:0] weighted_inputs8_0;
    wire [0:0] weighted_inputs8_1;
    wire [0:0] weighted_inputs8_2;
    wire [0:0] weighted_inputs8_3;
    wire [0:0] weighted_inputs8_4;
    wire [0:0] weighted_inputs8_5;
    wire [0:0] weighted_inputs8_6;
    wire [0:0] weighted_inputs8_7;

    wire [3:0] sum1 [7:0];
    wire [4:0] biased_sum1 [7:0];

    weighted_inputs_2 w0 (.inputs(inputs0_2), .w(w1_2[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_2), .w(w1_2[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_2), .w(w1_2[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_2), .w(w1_2[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs4_2), .w(w1_2[4]), .wi(weighted_inputs1_4));
    weighted_inputs_2 w5 (.inputs(inputs5_2), .w(w1_2[5]), .wi(weighted_inputs1_5));
    weighted_inputs_2 w6 (.inputs(inputs6_2), .w(w1_2[6]), .wi(weighted_inputs1_6));
    weighted_inputs_2 w7 (.inputs(inputs7_2), .w(w1_2[7]), .wi(weighted_inputs1_7));
    weighted_inputs_2 w8 (.inputs(inputs0_2), .w(w2_2[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w9 (.inputs(inputs1_2), .w(w2_2[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w10 (.inputs(inputs2_2), .w(w2_2[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w11 (.inputs(inputs3_2), .w(w2_2[3]), .wi(weighted_inputs2_3));
    weighted_inputs_2 w12 (.inputs(inputs4_2), .w(w2_2[4]), .wi(weighted_inputs2_4));
    weighted_inputs_2 w13 (.inputs(inputs5_2), .w(w2_2[5]), .wi(weighted_inputs2_5));
    weighted_inputs_2 w14 (.inputs(inputs6_2), .w(w2_2[6]), .wi(weighted_inputs2_6));
    weighted_inputs_2 w15 (.inputs(inputs7_2), .w(w2_2[7]), .wi(weighted_inputs2_7));
    weighted_inputs_2 w16 (.inputs(inputs0_2), .w(w3_2[0]), .wi(weighted_inputs3_0));
    weighted_inputs_2 w17 (.inputs(inputs1_2), .w(w3_2[1]), .wi(weighted_inputs3_1));
    weighted_inputs_2 w18 (.inputs(inputs2_2), .w(w3_2[2]), .wi(weighted_inputs3_2));
    weighted_inputs_2 w19 (.inputs(inputs3_2), .w(w3_2[3]), .wi(weighted_inputs3_3));
    weighted_inputs_2 w20 (.inputs(inputs4_2), .w(w3_2[4]), .wi(weighted_inputs3_4));
    weighted_inputs_2 w21 (.inputs(inputs5_2), .w(w3_2[5]), .wi(weighted_inputs3_5));
    weighted_inputs_2 w22 (.inputs(inputs6_2), .w(w3_2[6]), .wi(weighted_inputs3_6));
    weighted_inputs_2 w23 (.inputs(inputs7_2), .w(w3_2[7]), .wi(weighted_inputs3_7));
    weighted_inputs_2 w24 (.inputs(inputs0_2), .w(w4_2[0]), .wi(weighted_inputs4_0));
    weighted_inputs_2 w25 (.inputs(inputs1_2), .w(w4_2[1]), .wi(weighted_inputs4_1));
    weighted_inputs_2 w26 (.inputs(inputs2_2), .w(w4_2[2]), .wi(weighted_inputs4_2));
    weighted_inputs_2 w27 (.inputs(inputs3_2), .w(w4_2[3]), .wi(weighted_inputs4_3));
    weighted_inputs_2 w28 (.inputs(inputs4_2), .w(w4_2[4]), .wi(weighted_inputs4_4));
    weighted_inputs_2 w29 (.inputs(inputs5_2), .w(w4_2[5]), .wi(weighted_inputs4_5));
    weighted_inputs_2 w30 (.inputs(inputs6_2), .w(w4_2[6]), .wi(weighted_inputs4_6));
    weighted_inputs_2 w31 (.inputs(inputs7_2), .w(w4_2[7]), .wi(weighted_inputs4_7));
    weighted_inputs_2 w32 (.inputs(inputs0_2), .w(w5_2[0]), .wi(weighted_inputs5_0));
    weighted_inputs_2 w33 (.inputs(inputs1_2), .w(w5_2[1]), .wi(weighted_inputs5_1));
    weighted_inputs_2 w34 (.inputs(inputs2_2), .w(w5_2[2]), .wi(weighted_inputs5_2));
    weighted_inputs_2 w35 (.inputs(inputs3_2), .w(w5_2[3]), .wi(weighted_inputs5_3));
    weighted_inputs_2 w36 (.inputs(inputs4_2), .w(w5_2[4]), .wi(weighted_inputs5_4));
    weighted_inputs_2 w37 (.inputs(inputs5_2), .w(w5_2[5]), .wi(weighted_inputs5_5));
    weighted_inputs_2 w38 (.inputs(inputs6_2), .w(w5_2[6]), .wi(weighted_inputs5_6));
    weighted_inputs_2 w39 (.inputs(inputs7_2), .w(w5_2[7]), .wi(weighted_inputs5_7));
    weighted_inputs_2 w40 (.inputs(inputs0_2), .w(w6_2[0]), .wi(weighted_inputs6_0));
    weighted_inputs_2 w41 (.inputs(inputs1_2), .w(w6_2[1]), .wi(weighted_inputs6_1));
    weighted_inputs_2 w42 (.inputs(inputs2_2), .w(w6_2[2]), .wi(weighted_inputs6_2));
    weighted_inputs_2 w43 (.inputs(inputs3_2), .w(w6_2[3]), .wi(weighted_inputs6_3));
    weighted_inputs_2 w44 (.inputs(inputs4_2), .w(w6_2[4]), .wi(weighted_inputs6_4));
    weighted_inputs_2 w45 (.inputs(inputs5_2), .w(w6_2[5]), .wi(weighted_inputs6_5));
    weighted_inputs_2 w46 (.inputs(inputs6_2), .w(w6_2[6]), .wi(weighted_inputs6_6));
    weighted_inputs_2 w47 (.inputs(inputs7_2), .w(w6_2[7]), .wi(weighted_inputs6_7));
    weighted_inputs_2 w48 (.inputs(inputs0_2), .w(w7_2[0]), .wi(weighted_inputs7_0));
    weighted_inputs_2 w49 (.inputs(inputs1_2), .w(w7_2[1]), .wi(weighted_inputs7_1));
    weighted_inputs_2 w50 (.inputs(inputs2_2), .w(w7_2[2]), .wi(weighted_inputs7_2));
    weighted_inputs_2 w51 (.inputs(inputs3_2), .w(w7_2[3]), .wi(weighted_inputs7_3));
    weighted_inputs_2 w52 (.inputs(inputs4_2), .w(w7_2[4]), .wi(weighted_inputs7_4));
    weighted_inputs_2 w53 (.inputs(inputs5_2), .w(w7_2[5]), .wi(weighted_inputs7_5));
    weighted_inputs_2 w54 (.inputs(inputs6_2), .w(w7_2[6]), .wi(weighted_inputs7_6));
    weighted_inputs_2 w55 (.inputs(inputs7_2), .w(w7_2[7]), .wi(weighted_inputs7_7));
    weighted_inputs_2 w56 (.inputs(inputs0_2), .w(w8_2[0]), .wi(weighted_inputs8_0));
    weighted_inputs_2 w57 (.inputs(inputs1_2), .w(w8_2[1]), .wi(weighted_inputs8_1));
    weighted_inputs_2 w58 (.inputs(inputs2_2), .w(w8_2[2]), .wi(weighted_inputs8_2));
    weighted_inputs_2 w59 (.inputs(inputs3_2), .w(w8_2[3]), .wi(weighted_inputs8_3));
    weighted_inputs_2 w60 (.inputs(inputs4_2), .w(w8_2[4]), .wi(weighted_inputs8_4));
    weighted_inputs_2 w61 (.inputs(inputs5_2), .w(w8_2[5]), .wi(weighted_inputs8_5));
    weighted_inputs_2 w62 (.inputs(inputs6_2), .w(w8_2[6]), .wi(weighted_inputs8_6));
    weighted_inputs_2 w63 (.inputs(inputs7_2), .w(w8_2[7]), .wi(weighted_inputs8_7));
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
        .sum(sum1[7])
    );
    add4bit_2 u0 (.a(sum1[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1[0]));
    add4bit_2 u1 (.a(sum1[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1[1]));
    add4bit_2 u2 (.a(sum1[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1[2]));
    add4bit_2 u3 (.a(sum1[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1[3]));
    add4bit_2 u4 (.a(sum1[4]), .b(b5_2), .cin(1'b0), .y(biased_sum1[4]));
    add4bit_2 u5 (.a(sum1[5]), .b(b6_2), .cin(1'b0), .y(biased_sum1[5]));
    add4bit_2 u6 (.a(sum1[6]), .b(b7_2), .cin(1'b0), .y(biased_sum1[6]));
    add4bit_2 u7 (.a(sum1[7]), .b(b8_2), .cin(1'b0), .y(biased_sum1[7]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    assign biased_sum4_0 = biased_sum1[4];
    assign biased_sum5_0 = biased_sum1[5];
    assign biased_sum6_0 = biased_sum1[6];
    assign biased_sum7_0 = biased_sum1[7];
    always @(posedge clk) begin
        $display("----- BNN LAYER 2 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b", inputs0_2, inputs1_2, inputs2_2, inputs3_2, inputs4_2, inputs5_2, inputs6_2, inputs7_2);
        $display("Weights: %b %b %b %b %b %b %b %b", w1_2, w2_2, w3_2, w4_2, w5_2, w6_2, w7_2, w8_2);
        $display("sum1: %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7]);
        $display("biased_sum1: %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7]);
    end
endmodule


module activation_2 (

    input [4:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[4] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_2 (
    input  [4:0] inputs0_0,
    input  [4:0] inputs1_0,
    input  [4:0] inputs2_0,
    input  [4:0] inputs3_0,
    input  [4:0] inputs4_0,
    input  [4:0] inputs5_0,
    input  [4:0] inputs6_0,
    input  [4:0] inputs7_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3,
    output wire activation4,
    output wire activation5,
    output wire activation6,
    output wire activation7
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
  input  wire [7:0] w1_2,
  input  wire [7:0] w2_2,
  input  wire [7:0] w3_2,
  input  wire [7:0] w4_2,
  input  wire [7:0] w5_2,
  input  wire [7:0] w6_2,
  input  wire [7:0] w7_2,
  input  wire [7:0] w8_2,
  input  wire [3:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2,
  output wire activation0_2, 

  output wire activation1_2, 

  output wire activation2_2, 

  output wire activation3_2, 

  output wire activation4_2, 

  output wire activation5_2, 

  output wire activation6_2, 

  output wire activation7_2
);

  wire [4:0] biased_sum0_0;
  wire [4:0] biased_sum1_0;
  wire [4:0] biased_sum2_0;
  wire [4:0] biased_sum3_0;
  wire [4:0] biased_sum4_0;
  wire [4:0] biased_sum5_0;
  wire [4:0] biased_sum6_0;
  wire [4:0] biased_sum7_0;

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
    .w1_2(w1_2),
    .w2_2(w2_2),
    .w3_2(w3_2),
    .w4_2(w4_2),
    .w5_2(w5_2),
    .w6_2(w6_2),
    .w7_2(w7_2),
    .w8_2(w8_2),
    .b1_2(b1_2),
    .b2_2(b2_2),
    .b3_2(b3_2),
    .b4_2(b4_2),
    .b5_2(b5_2),
    .b6_2(b6_2),
    .b7_2(b7_2),
    .b8_2(b8_2),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0),
    .biased_sum4_0(biased_sum4_0),
    .biased_sum5_0(biased_sum5_0),
    .biased_sum6_0(biased_sum6_0),
    .biased_sum7_0(biased_sum7_0)
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
    .activation0(activation0_2),
    .activation1(activation1_2),
    .activation2(activation2_2),
    .activation3(activation3_2),
    .activation4(activation4_2),
    .activation5(activation5_2),
    .activation6(activation6_2),
    .activation7(activation7_2)
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
    .activation0(activation0_2),
    .activation1(activation1_2),
    .activation2(activation2_2),
    .activation3(activation3_2),
    .activation4(activation4_2),
    .activation5(activation5_2),
    .activation6(activation6_2),
    .activation7(activation7_2)
  );

    always @(posedge clk) begin
    $display("----- LAYER 2   boolean activations -----");
    $display("activation : %b %b %b %b %b %b %b %b", activation0_2, activation1_2, activation2_2, activation3_2, activation4_2, activation5_2, activation6_2, activation7_2);
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
    output wire [3:0] sum
);

    wire [1:0] stage0_0_lo_3;
    wire [1:0] stage0_1_lo_3;
    wire [1:0] stage0_2_lo_3;
    wire [1:0] stage0_3_lo_3;
    wire [2:0] stage1_0_lo_3;
    wire [2:0] stage1_1_lo_3;
    wire [3:0] stage2_0_lo_3;
    reg  [1:0] stage0_0_3;
    reg  [1:0] stage0_1_3;
    reg  [1:0] stage0_2_3;
    reg  [1:0] stage0_3_3;
    reg  [2:0] stage1_0_3;
    reg  [2:0] stage1_1_3;
    reg  [3:0] stage2_0_3;

    add1bit_3 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_3), .cout(), .cout_bar());
    add2bit_3 u1_0 (.a(stage0_0_3), .b(stage0_1_3), .cin(1'b0), .y(stage1_0_lo_3), .cout(), .cout_bar());
    add2bit_3 u1_1 (.a(stage0_2_3), .b(stage0_3_3), .cin(1'b0), .y(stage1_1_lo_3), .cout(), .cout_bar());
    add3bit_3 u2_0 (.a(stage1_0_3), .b(stage1_1_3), .cin(1'b0), .y(stage2_0_lo_3), .cout(), .cout_bar());

    assign sum =  stage2_0_lo_3;

    always @(posedge clk) begin
        stage0_0_3 <=  stage0_0_lo_3;
        stage0_1_3 <=  stage0_1_lo_3;
        stage0_2_3 <=  stage0_2_lo_3;
        stage0_3_3 <=  stage0_3_lo_3;
        stage1_0_3 <=  stage1_0_lo_3;
        stage1_1_3 <=  stage1_1_lo_3;
        stage2_0_3 <=  stage2_0_lo_3;
    end
endmodule


module layer3(
    input clk,
    input [0:0] inputs0_3 , inputs1_3 , inputs2_3 , inputs3_3 , inputs4_3 , inputs5_3 , inputs6_3 , inputs7_3,
    input [7:0] w1_3, w2_3, w3_3, w4_3, w5_3, w6_3, w7_3, w8_3,
    input [3:0] b1_3, b2_3, b3_3, b4_3, b5_3, b6_3, b7_3, b8_3,
    output [4:0] biased_sum0_0 , biased_sum1_0 , biased_sum2_0 , biased_sum3_0 , biased_sum4_0 , biased_sum5_0 , biased_sum6_0 , biased_sum7_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs1_4;
    wire [0:0] weighted_inputs1_5;
    wire [0:0] weighted_inputs1_6;
    wire [0:0] weighted_inputs1_7;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;
    wire [0:0] weighted_inputs2_4;
    wire [0:0] weighted_inputs2_5;
    wire [0:0] weighted_inputs2_6;
    wire [0:0] weighted_inputs2_7;
    wire [0:0] weighted_inputs3_0;
    wire [0:0] weighted_inputs3_1;
    wire [0:0] weighted_inputs3_2;
    wire [0:0] weighted_inputs3_3;
    wire [0:0] weighted_inputs3_4;
    wire [0:0] weighted_inputs3_5;
    wire [0:0] weighted_inputs3_6;
    wire [0:0] weighted_inputs3_7;
    wire [0:0] weighted_inputs4_0;
    wire [0:0] weighted_inputs4_1;
    wire [0:0] weighted_inputs4_2;
    wire [0:0] weighted_inputs4_3;
    wire [0:0] weighted_inputs4_4;
    wire [0:0] weighted_inputs4_5;
    wire [0:0] weighted_inputs4_6;
    wire [0:0] weighted_inputs4_7;
    wire [0:0] weighted_inputs5_0;
    wire [0:0] weighted_inputs5_1;
    wire [0:0] weighted_inputs5_2;
    wire [0:0] weighted_inputs5_3;
    wire [0:0] weighted_inputs5_4;
    wire [0:0] weighted_inputs5_5;
    wire [0:0] weighted_inputs5_6;
    wire [0:0] weighted_inputs5_7;
    wire [0:0] weighted_inputs6_0;
    wire [0:0] weighted_inputs6_1;
    wire [0:0] weighted_inputs6_2;
    wire [0:0] weighted_inputs6_3;
    wire [0:0] weighted_inputs6_4;
    wire [0:0] weighted_inputs6_5;
    wire [0:0] weighted_inputs6_6;
    wire [0:0] weighted_inputs6_7;
    wire [0:0] weighted_inputs7_0;
    wire [0:0] weighted_inputs7_1;
    wire [0:0] weighted_inputs7_2;
    wire [0:0] weighted_inputs7_3;
    wire [0:0] weighted_inputs7_4;
    wire [0:0] weighted_inputs7_5;
    wire [0:0] weighted_inputs7_6;
    wire [0:0] weighted_inputs7_7;
    wire [0:0] weighted_inputs8_0;
    wire [0:0] weighted_inputs8_1;
    wire [0:0] weighted_inputs8_2;
    wire [0:0] weighted_inputs8_3;
    wire [0:0] weighted_inputs8_4;
    wire [0:0] weighted_inputs8_5;
    wire [0:0] weighted_inputs8_6;
    wire [0:0] weighted_inputs8_7;

    wire [3:0] sum1 [7:0];
    wire [4:0] biased_sum1 [7:0];

    weighted_inputs_2 w0 (.inputs(inputs0_3), .w(w1_3[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_3), .w(w1_3[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_3), .w(w1_3[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_3), .w(w1_3[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs4_3), .w(w1_3[4]), .wi(weighted_inputs1_4));
    weighted_inputs_2 w5 (.inputs(inputs5_3), .w(w1_3[5]), .wi(weighted_inputs1_5));
    weighted_inputs_2 w6 (.inputs(inputs6_3), .w(w1_3[6]), .wi(weighted_inputs1_6));
    weighted_inputs_2 w7 (.inputs(inputs7_3), .w(w1_3[7]), .wi(weighted_inputs1_7));
    weighted_inputs_2 w8 (.inputs(inputs0_3), .w(w2_3[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w9 (.inputs(inputs1_3), .w(w2_3[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w10 (.inputs(inputs2_3), .w(w2_3[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w11 (.inputs(inputs3_3), .w(w2_3[3]), .wi(weighted_inputs2_3));
    weighted_inputs_2 w12 (.inputs(inputs4_3), .w(w2_3[4]), .wi(weighted_inputs2_4));
    weighted_inputs_2 w13 (.inputs(inputs5_3), .w(w2_3[5]), .wi(weighted_inputs2_5));
    weighted_inputs_2 w14 (.inputs(inputs6_3), .w(w2_3[6]), .wi(weighted_inputs2_6));
    weighted_inputs_2 w15 (.inputs(inputs7_3), .w(w2_3[7]), .wi(weighted_inputs2_7));
    weighted_inputs_2 w16 (.inputs(inputs0_3), .w(w3_3[0]), .wi(weighted_inputs3_0));
    weighted_inputs_2 w17 (.inputs(inputs1_3), .w(w3_3[1]), .wi(weighted_inputs3_1));
    weighted_inputs_2 w18 (.inputs(inputs2_3), .w(w3_3[2]), .wi(weighted_inputs3_2));
    weighted_inputs_2 w19 (.inputs(inputs3_3), .w(w3_3[3]), .wi(weighted_inputs3_3));
    weighted_inputs_2 w20 (.inputs(inputs4_3), .w(w3_3[4]), .wi(weighted_inputs3_4));
    weighted_inputs_2 w21 (.inputs(inputs5_3), .w(w3_3[5]), .wi(weighted_inputs3_5));
    weighted_inputs_2 w22 (.inputs(inputs6_3), .w(w3_3[6]), .wi(weighted_inputs3_6));
    weighted_inputs_2 w23 (.inputs(inputs7_3), .w(w3_3[7]), .wi(weighted_inputs3_7));
    weighted_inputs_2 w24 (.inputs(inputs0_3), .w(w4_3[0]), .wi(weighted_inputs4_0));
    weighted_inputs_2 w25 (.inputs(inputs1_3), .w(w4_3[1]), .wi(weighted_inputs4_1));
    weighted_inputs_2 w26 (.inputs(inputs2_3), .w(w4_3[2]), .wi(weighted_inputs4_2));
    weighted_inputs_2 w27 (.inputs(inputs3_3), .w(w4_3[3]), .wi(weighted_inputs4_3));
    weighted_inputs_2 w28 (.inputs(inputs4_3), .w(w4_3[4]), .wi(weighted_inputs4_4));
    weighted_inputs_2 w29 (.inputs(inputs5_3), .w(w4_3[5]), .wi(weighted_inputs4_5));
    weighted_inputs_2 w30 (.inputs(inputs6_3), .w(w4_3[6]), .wi(weighted_inputs4_6));
    weighted_inputs_2 w31 (.inputs(inputs7_3), .w(w4_3[7]), .wi(weighted_inputs4_7));
    weighted_inputs_2 w32 (.inputs(inputs0_3), .w(w5_3[0]), .wi(weighted_inputs5_0));
    weighted_inputs_2 w33 (.inputs(inputs1_3), .w(w5_3[1]), .wi(weighted_inputs5_1));
    weighted_inputs_2 w34 (.inputs(inputs2_3), .w(w5_3[2]), .wi(weighted_inputs5_2));
    weighted_inputs_2 w35 (.inputs(inputs3_3), .w(w5_3[3]), .wi(weighted_inputs5_3));
    weighted_inputs_2 w36 (.inputs(inputs4_3), .w(w5_3[4]), .wi(weighted_inputs5_4));
    weighted_inputs_2 w37 (.inputs(inputs5_3), .w(w5_3[5]), .wi(weighted_inputs5_5));
    weighted_inputs_2 w38 (.inputs(inputs6_3), .w(w5_3[6]), .wi(weighted_inputs5_6));
    weighted_inputs_2 w39 (.inputs(inputs7_3), .w(w5_3[7]), .wi(weighted_inputs5_7));
    weighted_inputs_2 w40 (.inputs(inputs0_3), .w(w6_3[0]), .wi(weighted_inputs6_0));
    weighted_inputs_2 w41 (.inputs(inputs1_3), .w(w6_3[1]), .wi(weighted_inputs6_1));
    weighted_inputs_2 w42 (.inputs(inputs2_3), .w(w6_3[2]), .wi(weighted_inputs6_2));
    weighted_inputs_2 w43 (.inputs(inputs3_3), .w(w6_3[3]), .wi(weighted_inputs6_3));
    weighted_inputs_2 w44 (.inputs(inputs4_3), .w(w6_3[4]), .wi(weighted_inputs6_4));
    weighted_inputs_2 w45 (.inputs(inputs5_3), .w(w6_3[5]), .wi(weighted_inputs6_5));
    weighted_inputs_2 w46 (.inputs(inputs6_3), .w(w6_3[6]), .wi(weighted_inputs6_6));
    weighted_inputs_2 w47 (.inputs(inputs7_3), .w(w6_3[7]), .wi(weighted_inputs6_7));
    weighted_inputs_2 w48 (.inputs(inputs0_3), .w(w7_3[0]), .wi(weighted_inputs7_0));
    weighted_inputs_2 w49 (.inputs(inputs1_3), .w(w7_3[1]), .wi(weighted_inputs7_1));
    weighted_inputs_2 w50 (.inputs(inputs2_3), .w(w7_3[2]), .wi(weighted_inputs7_2));
    weighted_inputs_2 w51 (.inputs(inputs3_3), .w(w7_3[3]), .wi(weighted_inputs7_3));
    weighted_inputs_2 w52 (.inputs(inputs4_3), .w(w7_3[4]), .wi(weighted_inputs7_4));
    weighted_inputs_2 w53 (.inputs(inputs5_3), .w(w7_3[5]), .wi(weighted_inputs7_5));
    weighted_inputs_2 w54 (.inputs(inputs6_3), .w(w7_3[6]), .wi(weighted_inputs7_6));
    weighted_inputs_2 w55 (.inputs(inputs7_3), .w(w7_3[7]), .wi(weighted_inputs7_7));
    weighted_inputs_2 w56 (.inputs(inputs0_3), .w(w8_3[0]), .wi(weighted_inputs8_0));
    weighted_inputs_2 w57 (.inputs(inputs1_3), .w(w8_3[1]), .wi(weighted_inputs8_1));
    weighted_inputs_2 w58 (.inputs(inputs2_3), .w(w8_3[2]), .wi(weighted_inputs8_2));
    weighted_inputs_2 w59 (.inputs(inputs3_3), .w(w8_3[3]), .wi(weighted_inputs8_3));
    weighted_inputs_2 w60 (.inputs(inputs4_3), .w(w8_3[4]), .wi(weighted_inputs8_4));
    weighted_inputs_2 w61 (.inputs(inputs5_3), .w(w8_3[5]), .wi(weighted_inputs8_5));
    weighted_inputs_2 w62 (.inputs(inputs6_3), .w(w8_3[6]), .wi(weighted_inputs8_6));
    weighted_inputs_2 w63 (.inputs(inputs7_3), .w(w8_3[7]), .wi(weighted_inputs8_7));
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
        .sum(sum1[7])
    );
    add4bit_3 u0 (.a(sum1[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1[0]));
    add4bit_3 u1 (.a(sum1[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1[1]));
    add4bit_3 u2 (.a(sum1[2]), .b(b3_3), .cin(1'b0), .y(biased_sum1[2]));
    add4bit_3 u3 (.a(sum1[3]), .b(b4_3), .cin(1'b0), .y(biased_sum1[3]));
    add4bit_3 u4 (.a(sum1[4]), .b(b5_3), .cin(1'b0), .y(biased_sum1[4]));
    add4bit_3 u5 (.a(sum1[5]), .b(b6_3), .cin(1'b0), .y(biased_sum1[5]));
    add4bit_3 u6 (.a(sum1[6]), .b(b7_3), .cin(1'b0), .y(biased_sum1[6]));
    add4bit_3 u7 (.a(sum1[7]), .b(b8_3), .cin(1'b0), .y(biased_sum1[7]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    assign biased_sum4_0 = biased_sum1[4];
    assign biased_sum5_0 = biased_sum1[5];
    assign biased_sum6_0 = biased_sum1[6];
    assign biased_sum7_0 = biased_sum1[7];
    always @(posedge clk) begin
        $display("----- BNN LAYER 3 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b", inputs0_3, inputs1_3, inputs2_3, inputs3_3, inputs4_3, inputs5_3, inputs6_3, inputs7_3);
        $display("Weights: %b %b %b %b %b %b %b %b", w1_3, w2_3, w3_3, w4_3, w5_3, w6_3, w7_3, w8_3);
        $display("sum1: %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7]);
        $display("biased_sum1: %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7]);
    end
endmodule


module activation_3 (

    input [4:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[4] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_3 (
    input  [4:0] inputs0_0,
    input  [4:0] inputs1_0,
    input  [4:0] inputs2_0,
    input  [4:0] inputs3_0,
    input  [4:0] inputs4_0,
    input  [4:0] inputs5_0,
    input  [4:0] inputs6_0,
    input  [4:0] inputs7_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3,
    output wire activation4,
    output wire activation5,
    output wire activation6,
    output wire activation7
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
  input  wire [7:0] w1_3,
  input  wire [7:0] w2_3,
  input  wire [7:0] w3_3,
  input  wire [7:0] w4_3,
  input  wire [7:0] w5_3,
  input  wire [7:0] w6_3,
  input  wire [7:0] w7_3,
  input  wire [7:0] w8_3,
  input  wire [3:0] b1_3, b2_3, b3_3, b4_3, b5_3, b6_3, b7_3, b8_3,
  output wire activation0_3, 

  output wire activation1_3, 

  output wire activation2_3, 

  output wire activation3_3, 

  output wire activation4_3, 

  output wire activation5_3, 

  output wire activation6_3, 

  output wire activation7_3
);

  wire [4:0] biased_sum0_0;
  wire [4:0] biased_sum1_0;
  wire [4:0] biased_sum2_0;
  wire [4:0] biased_sum3_0;
  wire [4:0] biased_sum4_0;
  wire [4:0] biased_sum5_0;
  wire [4:0] biased_sum6_0;
  wire [4:0] biased_sum7_0;

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
    .w1_3(w1_3),
    .w2_3(w2_3),
    .w3_3(w3_3),
    .w4_3(w4_3),
    .w5_3(w5_3),
    .w6_3(w6_3),
    .w7_3(w7_3),
    .w8_3(w8_3),
    .b1_3(b1_3),
    .b2_3(b2_3),
    .b3_3(b3_3),
    .b4_3(b4_3),
    .b5_3(b5_3),
    .b6_3(b6_3),
    .b7_3(b7_3),
    .b8_3(b8_3),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0),
    .biased_sum4_0(biased_sum4_0),
    .biased_sum5_0(biased_sum5_0),
    .biased_sum6_0(biased_sum6_0),
    .biased_sum7_0(biased_sum7_0)
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
    .activation0(activation0_3),
    .activation1(activation1_3),
    .activation2(activation2_3),
    .activation3(activation3_3),
    .activation4(activation4_3),
    .activation5(activation5_3),
    .activation6(activation6_3),
    .activation7(activation7_3)
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
    .activation0(activation0_3),
    .activation1(activation1_3),
    .activation2(activation2_3),
    .activation3(activation3_3),
    .activation4(activation4_3),
    .activation5(activation5_3),
    .activation6(activation6_3),
    .activation7(activation7_3)
  );

    always @(posedge clk) begin
    $display("----- LAYER 3   boolean activations -----");
    $display("activation : %b %b %b %b %b %b %b %b", activation0_3, activation1_3, activation2_3, activation3_3, activation4_3, activation5_3, activation6_3, activation7_3);
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
    output wire [3:0] sum
);

    wire [1:0] stage0_0_lo_4;
    wire [1:0] stage0_1_lo_4;
    wire [1:0] stage0_2_lo_4;
    wire [1:0] stage0_3_lo_4;
    wire [2:0] stage1_0_lo_4;
    wire [2:0] stage1_1_lo_4;
    wire [3:0] stage2_0_lo_4;
    reg  [1:0] stage0_0_4;
    reg  [1:0] stage0_1_4;
    reg  [1:0] stage0_2_4;
    reg  [1:0] stage0_3_4;
    reg  [2:0] stage1_0_4;
    reg  [2:0] stage1_1_4;
    reg  [3:0] stage2_0_4;

    add1bit_4 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_4), .cout(), .cout_bar());
    add2bit_4 u1_0 (.a(stage0_0_4), .b(stage0_1_4), .cin(1'b0), .y(stage1_0_lo_4), .cout(), .cout_bar());
    add2bit_4 u1_1 (.a(stage0_2_4), .b(stage0_3_4), .cin(1'b0), .y(stage1_1_lo_4), .cout(), .cout_bar());
    add3bit_4 u2_0 (.a(stage1_0_4), .b(stage1_1_4), .cin(1'b0), .y(stage2_0_lo_4), .cout(), .cout_bar());

    assign sum =  stage2_0_lo_4;

    always @(posedge clk) begin
        stage0_0_4 <=  stage0_0_lo_4;
        stage0_1_4 <=  stage0_1_lo_4;
        stage0_2_4 <=  stage0_2_lo_4;
        stage0_3_4 <=  stage0_3_lo_4;
        stage1_0_4 <=  stage1_0_lo_4;
        stage1_1_4 <=  stage1_1_lo_4;
        stage2_0_4 <=  stage2_0_lo_4;
    end
endmodule


module layer4(
    input clk,
    input [0:0] inputs0_4 , inputs1_4 , inputs2_4 , inputs3_4 , inputs4_4 , inputs5_4 , inputs6_4 , inputs7_4,
    input [7:0] w1_4, w2_4, w3_4, w4_4,
    input [3:0] b1_4, b2_4, b3_4, b4_4,
    output [4:0] biased_sum0_0 , biased_sum1_0 , biased_sum2_0 , biased_sum3_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs1_4;
    wire [0:0] weighted_inputs1_5;
    wire [0:0] weighted_inputs1_6;
    wire [0:0] weighted_inputs1_7;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;
    wire [0:0] weighted_inputs2_4;
    wire [0:0] weighted_inputs2_5;
    wire [0:0] weighted_inputs2_6;
    wire [0:0] weighted_inputs2_7;
    wire [0:0] weighted_inputs3_0;
    wire [0:0] weighted_inputs3_1;
    wire [0:0] weighted_inputs3_2;
    wire [0:0] weighted_inputs3_3;
    wire [0:0] weighted_inputs3_4;
    wire [0:0] weighted_inputs3_5;
    wire [0:0] weighted_inputs3_6;
    wire [0:0] weighted_inputs3_7;
    wire [0:0] weighted_inputs4_0;
    wire [0:0] weighted_inputs4_1;
    wire [0:0] weighted_inputs4_2;
    wire [0:0] weighted_inputs4_3;
    wire [0:0] weighted_inputs4_4;
    wire [0:0] weighted_inputs4_5;
    wire [0:0] weighted_inputs4_6;
    wire [0:0] weighted_inputs4_7;

    wire [3:0] sum1 [3:0];
    wire [4:0] biased_sum1 [3:0];

    weighted_inputs_2 w0 (.inputs(inputs0_4), .w(w1_4[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_4), .w(w1_4[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_4), .w(w1_4[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_4), .w(w1_4[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs4_4), .w(w1_4[4]), .wi(weighted_inputs1_4));
    weighted_inputs_2 w5 (.inputs(inputs5_4), .w(w1_4[5]), .wi(weighted_inputs1_5));
    weighted_inputs_2 w6 (.inputs(inputs6_4), .w(w1_4[6]), .wi(weighted_inputs1_6));
    weighted_inputs_2 w7 (.inputs(inputs7_4), .w(w1_4[7]), .wi(weighted_inputs1_7));
    weighted_inputs_2 w8 (.inputs(inputs0_4), .w(w2_4[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w9 (.inputs(inputs1_4), .w(w2_4[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w10 (.inputs(inputs2_4), .w(w2_4[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w11 (.inputs(inputs3_4), .w(w2_4[3]), .wi(weighted_inputs2_3));
    weighted_inputs_2 w12 (.inputs(inputs4_4), .w(w2_4[4]), .wi(weighted_inputs2_4));
    weighted_inputs_2 w13 (.inputs(inputs5_4), .w(w2_4[5]), .wi(weighted_inputs2_5));
    weighted_inputs_2 w14 (.inputs(inputs6_4), .w(w2_4[6]), .wi(weighted_inputs2_6));
    weighted_inputs_2 w15 (.inputs(inputs7_4), .w(w2_4[7]), .wi(weighted_inputs2_7));
    weighted_inputs_2 w16 (.inputs(inputs0_4), .w(w3_4[0]), .wi(weighted_inputs3_0));
    weighted_inputs_2 w17 (.inputs(inputs1_4), .w(w3_4[1]), .wi(weighted_inputs3_1));
    weighted_inputs_2 w18 (.inputs(inputs2_4), .w(w3_4[2]), .wi(weighted_inputs3_2));
    weighted_inputs_2 w19 (.inputs(inputs3_4), .w(w3_4[3]), .wi(weighted_inputs3_3));
    weighted_inputs_2 w20 (.inputs(inputs4_4), .w(w3_4[4]), .wi(weighted_inputs3_4));
    weighted_inputs_2 w21 (.inputs(inputs5_4), .w(w3_4[5]), .wi(weighted_inputs3_5));
    weighted_inputs_2 w22 (.inputs(inputs6_4), .w(w3_4[6]), .wi(weighted_inputs3_6));
    weighted_inputs_2 w23 (.inputs(inputs7_4), .w(w3_4[7]), .wi(weighted_inputs3_7));
    weighted_inputs_2 w24 (.inputs(inputs0_4), .w(w4_4[0]), .wi(weighted_inputs4_0));
    weighted_inputs_2 w25 (.inputs(inputs1_4), .w(w4_4[1]), .wi(weighted_inputs4_1));
    weighted_inputs_2 w26 (.inputs(inputs2_4), .w(w4_4[2]), .wi(weighted_inputs4_2));
    weighted_inputs_2 w27 (.inputs(inputs3_4), .w(w4_4[3]), .wi(weighted_inputs4_3));
    weighted_inputs_2 w28 (.inputs(inputs4_4), .w(w4_4[4]), .wi(weighted_inputs4_4));
    weighted_inputs_2 w29 (.inputs(inputs5_4), .w(w4_4[5]), .wi(weighted_inputs4_5));
    weighted_inputs_2 w30 (.inputs(inputs6_4), .w(w4_4[6]), .wi(weighted_inputs4_6));
    weighted_inputs_2 w31 (.inputs(inputs7_4), .w(w4_4[7]), .wi(weighted_inputs4_7));
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
        .sum(sum1[3])
    );
    add4bit_4 u0 (.a(sum1[0]), .b(b1_4), .cin(1'b0), .y(biased_sum1[0]));
    add4bit_4 u1 (.a(sum1[1]), .b(b2_4), .cin(1'b0), .y(biased_sum1[1]));
    add4bit_4 u2 (.a(sum1[2]), .b(b3_4), .cin(1'b0), .y(biased_sum1[2]));
    add4bit_4 u3 (.a(sum1[3]), .b(b4_4), .cin(1'b0), .y(biased_sum1[3]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    always @(posedge clk) begin
        $display("----- BNN LAYER 4 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b", inputs0_4, inputs1_4, inputs2_4, inputs3_4, inputs4_4, inputs5_4, inputs6_4, inputs7_4);
        $display("Weights: %b %b %b %b", w1_4, w2_4, w3_4, w4_4);
        $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
        $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
    end
endmodule


module subtractor (
    input  wire signed [4:0] A,
    input  wire signed [4:0] B,
    output wire signed [5:0] Result
);
    assign Result = A - B;
endmodule

module comparator_1 (
    input  wire [5:0] inputs0_0,
    input  wire [5:0] inputs0_1,
    input  wire r0_0, r1_0, r2_0, r3_0, r4_0, r5_0,
    output wire comparator
);
    // internal r_out chain
    wire r1 , r2 , r3 , r4 , r5 , r6;
    wire masked_c0_0 , masked_c1_0 , masked_c2_0 , masked_c3_0 , masked_c4_0 , masked_c5_0;

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

    wire carry = r6 ^ masked_c5_0;
    // final compare: if carry ^ inputs0_0[N-1] ^ inputs0_1[N-1] == 0 → comparator = 1
    assign comparator = (carry ^ inputs0_0[5] ^ inputs0_1[5]) ? 1'b0 : 1'b1;
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
    input  wire [7:0] w1_4,
    input  wire [7:0] w2_4,
    input  wire [7:0] w3_4,
    input  wire [7:0] w4_4,
    input  wire [3:0] b1_4,
    input  wire [3:0] b2_4,
    input  wire [3:0] b3_4,
    input  wire [3:0] b4_4,
    input  wire r0_0,
    input  wire r1_0,
    input  wire r2_0,
    input  wire r3_0,
    input  wire r4_0,
    input  wire r5_0,
    input  wire r0_1,
    input  wire r1_1,
    input  wire r2_1,
    input  wire r3_1,
    input  wire r4_1,
    input  wire r5_1,
    input  wire r0_2,
    input  wire r1_2,
    input  wire r2_2,
    input  wire r3_2,
    input  wire r4_2,
    input  wire r5_2,
    output reg  a0,
    output reg  a1,
    output reg  a2,
    output reg  a3
);

    wire [4:0] biased_sum0_0; 
    wire [4:0] biased_sum1_0; 
    wire [4:0] biased_sum2_0; 
    wire [4:0] biased_sum3_0; 

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
        .w1_4(w1_4),
        .w2_4(w2_4),
        .w3_4(w3_4),
        .w4_4(w4_4),
        .b1_4(b1_4),
        .b2_4(b2_4),
        .b3_4(b3_4),
        .b4_4(b4_4),
        .biased_sum0_0(biased_sum0_0),
        .biased_sum1_0(biased_sum1_0),
        .biased_sum2_0(biased_sum2_0),
        .biased_sum3_0(biased_sum3_0)
    );

    wire [5:0] temp0_0;
    subtractor s0a (.A(biased_sum0_0), .B(biased_sum1_0), .Result(temp0_0));
    wire comp0;
    comparator_1 c0 (
        .inputs0_0(temp0_0), .inputs0_1(6'b0),
        .r0_0(r0_0), .r1_0(r1_0), .r2_0(r2_0), .r3_0(r3_0), .r4_0(r4_0), .r5_0(r5_0),
        .comparator(comp0)
    );
    reg [4:0] stage1_0_0, stage1_0_1;
    always @(posedge clk) begin
        if (comp0)      begin stage1_0_0 <= biased_sum0_0;    stage1_0_1 <= 6'b0;    end
        else                    begin stage1_0_0 <= biased_sum1_0;    stage1_0_1 <= 6'b0;    end
    end

    wire [5:0] temp1_0;
    subtractor s1a (.A(biased_sum2_0), .B(biased_sum3_0), .Result(temp1_0));
    wire comp1;
    comparator_1 c1 (
        .inputs0_0(temp1_0), .inputs0_1(6'b0),
        .r0_0(r0_1), .r1_0(r1_1), .r2_0(r2_1), .r3_0(r3_1), .r4_0(r4_1), .r5_0(r5_1),
        .comparator(comp1)
    );
    reg [4:0] stage1_1_0, stage1_1_1;
    always @(posedge clk) begin
        if (comp1)      begin stage1_1_0 <= biased_sum2_0;    stage1_1_1 <= 6'b0;    end
        else                    begin stage1_1_0 <= biased_sum3_0;    stage1_1_1 <= 6'b0;    end
    end

    wire [5:0] temp2_0;
    subtractor s2a (.A(stage1_0_0), .B(stage1_1_0), .Result(temp2_0));
    wire comp2;
    comparator_1 c2 (
        .inputs0_0(temp2_0), .inputs0_1(6'b0),
        .r0_0(r0_2), .r1_0(r1_2), .r2_0(r2_2), .r3_0(r3_2), .r4_0(r4_2), .r5_0(r5_2),
        .comparator(comp2)
    );
    reg [4:0] stage2_0_0, stage2_0_1;
    always @(posedge clk) begin
        if (comp2)      begin stage2_0_0 <= stage1_0_0;    stage2_0_1 <= stage1_0_1;    end
        else                    begin stage2_0_0 <= stage1_1_0;    stage2_0_1 <= stage1_1_1;    end
    end

    always @(posedge clk) begin
        a0 <= 0;
        a1 <= 0;
        a2 <= 0;
        a3 <= 0;

        if (comp0 == 1 && comp2 == 1) a0     <= 1;
        else if (comp0 == 0 && comp2 == 1) a1     <= 1;
        else if (comp1 == 1 && comp2 == 0) a2     <= 1;
        else             a3     <= 1;

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
    // Layer-1 weights & biases
    input  wire [15:0] w1_1,
    input  wire [15:0] w2_1,
    input  wire [15:0] w3_1,
    input  wire [15:0] w4_1,
    input  wire [15:0] w5_1,
    input  wire [15:0] w6_1,
    input  wire [15:0] w7_1,
    input  wire [15:0] w8_1,
    input  wire [11:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1,

    // Layer-2 weights & biases
    input  wire [7:0] w1_2,
    input  wire [7:0] w2_2,
    input  wire [7:0] w3_2,
    input  wire [7:0] w4_2,
    input  wire [7:0] w5_2,
    input  wire [7:0] w6_2,
    input  wire [7:0] w7_2,
    input  wire [7:0] w8_2,
    input  wire [3:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2,

    // Layer-3 weights & biases (output layer)
    input  wire [7:0] w1_3, 
    input  wire [7:0] w2_3, 
    input  wire [7:0] w3_3, 
    input  wire [7:0] w4_3, 
    input  wire [7:0] w5_3, 
    input  wire [7:0] w6_3, 
    input  wire [7:0] w7_3, 
    input  wire [7:0] w8_3, 
    input  wire [3:0] b1_3,
    input  wire [3:0] b2_3,
    input  wire [3:0] b3_3,
    input  wire [3:0] b4_3,
    input  wire [3:0] b5_3,
    input  wire [3:0] b6_3,
    input  wire [3:0] b7_3,
    input  wire [3:0] b8_3,

    // Layer-4 weights & biases (output layer)
    input  wire [7:0] w1_4,
    input  wire [7:0] w2_4,
    input  wire [7:0] w3_4,
    input  wire [7:0] w4_4,
    input  wire [3:0] b1_4,
    input  wire [3:0] b2_4,
    input  wire [3:0] b3_4,
    input  wire [3:0] b4_4,
    output wire a0,
    output wire a1,
    output wire a2,
    output wire a3
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
 reg activationr0_1;
 reg activationr1_1;
 reg activationr2_1;
 reg activationr3_1;
 reg activationr4_1;
 reg activationr5_1;
 reg activationr6_1;
 reg activationr7_1;
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
    .w1_1(w1_1), 
    .w2_1(w2_1), 
    .w3_1(w3_1), 
    .w4_1(w4_1), 
    .w5_1(w5_1), 
    .w6_1(w6_1), 
    .w7_1(w7_1), 
    .w8_1(w8_1), 
    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1), .b5_1(b5_1), .b6_1(b6_1), .b7_1(b7_1), .b8_1(b8_1),
    .activation0_1(activation0_1), 
    .activation1_1(activation1_1), 
    .activation2_1(activation2_1), 
    .activation3_1(activation3_1), 
    .activation4_1(activation4_1), 
    .activation5_1(activation5_1), 
    .activation6_1(activation6_1), 
    .activation7_1(activation7_1)
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
 reg activationr0_2;
 reg activationr1_2;
 reg activationr2_2;
 reg activationr3_2;
 reg activationr4_2;
 reg activationr5_2;
 reg activationr6_2;
 reg activationr7_2;
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
    .w1_2(w1_2),
    .w2_2(w2_2),
    .w3_2(w3_2),
    .w4_2(w4_2),
    .w5_2(w5_2),
    .w6_2(w6_2),
    .w7_2(w7_2),
    .w8_2(w8_2),
    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2), .b5_2(b5_2), .b6_2(b6_2), .b7_2(b7_2), .b8_2(b8_2),
    .activation0_2(activation0_2), 
    .activation1_2(activation1_2), 
    .activation2_2(activation2_2), 
    .activation3_2(activation3_2), 
    .activation4_2(activation4_2), 
    .activation5_2(activation5_2), 
    .activation6_2(activation6_2), 
    .activation7_2(activation7_2)
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
 reg activationr0_3;
 reg activationr1_3;
 reg activationr2_3;
 reg activationr3_3;
 reg activationr4_3;
 reg activationr5_3;
 reg activationr6_3;
 reg activationr7_3;
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
    .w1_3(w1_3),
    .w2_3(w2_3),
    .w3_3(w3_3),
    .w4_3(w4_3),
    .w5_3(w5_3),
    .w6_3(w6_3),
    .w7_3(w7_3),
    .w8_3(w8_3),
    .b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3), .b5_3(b5_3), .b6_3(b6_3), .b7_3(b7_3), .b8_3(b8_3),
    .activation0_3(activation0_3), 
    .activation1_3(activation1_3), 
    .activation2_3(activation2_3), 
    .activation3_3(activation3_3), 
    .activation4_3(activation4_3), 
    .activation5_3(activation5_3), 
    .activation6_3(activation6_3), 
    .activation7_3(activation7_3)
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
    #1;
  end

 reg a0_reg ;
 reg a1_reg ;
 reg a2_reg ;
 reg a3_reg ;
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
    .w1_4(w1_4),
    .w2_4(w2_4),
    .w3_4(w3_4),
    .w4_4(w4_4),
    .b1_4(b1_4), .b2_4(b2_4), .b3_4(b3_4), .b4_4(b4_4),
    .r0_0(r0_0),
    .r1_0(r1_0),
    .r2_0(r2_0),
    .r3_0(r3_0),
    .r4_0(r4_0),
    .r5_0(r5_0),
    .r0_1(r0_1),
    .r1_1(r1_1),
    .r2_1(r2_1),
    .r3_1(r3_1),
    .r4_1(r4_1),
    .r5_1(r5_1),
    .r0_2(r0_2),
    .r1_2(r1_2),
    .r2_2(r2_2),
    .r3_2(r3_2),
    .r4_2(r4_2),
    .r5_2(r5_2),
    .a0(a0),
    .a1(a1),
    .a2(a2),
    .a3(a3)
  );

  always @(posedge clk) begin
    a0_reg <= a0;
    a1_reg <= a1;
    a2_reg <= a2;
    a3_reg <= a3;
  end

endmodule
`default_nettype wire
