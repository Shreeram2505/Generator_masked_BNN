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
    output wire [10:0] sum
);

    wire [8:0] stage0_0_lo_1;
    wire [8:0] stage0_1_lo_1;
    wire [8:0] stage0_2_lo_1;
    wire [8:0] stage0_3_lo_1;
    wire [9:0] stage1_0_lo_1;
    wire [9:0] stage1_1_lo_1;
    wire [10:0] stage2_0_lo_1;
    reg  [8:0] stage0_0_1;
    reg  [8:0] stage0_1_1;
    reg  [8:0] stage0_2_1;
    reg  [8:0] stage0_3_1;
    reg  [9:0] stage1_0_1;
    reg  [9:0] stage1_1_1;
    reg  [10:0] stage2_0_1;

    add8bit_1 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_1), .cout(), .cout_bar());
    add8bit_1 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_0 (.a(stage0_0_1), .b(stage0_1_1), .cin(1'b0), .y(stage1_0_lo_1), .cout(), .cout_bar());
    add9bit_1 u1_1 (.a(stage0_2_1), .b(stage0_3_1), .cin(1'b0), .y(stage1_1_lo_1), .cout(), .cout_bar());
    add10bit_1 u2_0 (.a(stage1_0_1), .b(stage1_1_1), .cin(1'b0), .y(stage2_0_lo_1), .cout(), .cout_bar());

    assign sum =  stage2_0_lo_1;

    always @(posedge clk) begin
        stage0_0_1 <=  stage0_0_lo_1;
        stage0_1_1 <=  stage0_1_lo_1;
        stage0_2_1 <=  stage0_2_lo_1;
        stage0_3_1 <=  stage0_3_lo_1;
        stage1_0_1 <=  stage1_0_lo_1;
        stage1_1_1 <=  stage1_1_lo_1;
        stage2_0_1 <=  stage2_0_lo_1;
    end
endmodule


module layer1(
    input clk,
    input [7:0] inputs0_1 , inputs1_1 , inputs2_1 , inputs3_1 , inputs4_1 , inputs5_1 , inputs6_1 , inputs7_1,
    input [7:0] w1_1, w2_1, w3_1, w4_1,
    input [10:0] b1_1, b2_1, b3_1, b4_1,
    output [11:0] biased_sum0_0, biased_sum1_0, biased_sum2_0, biased_sum3_0
);
    wire [7:0] weighted_inputs1_0;
    wire [7:0] weighted_inputs1_1;
    wire [7:0] weighted_inputs1_2;
    wire [7:0] weighted_inputs1_3;
    wire [7:0] weighted_inputs1_4;
    wire [7:0] weighted_inputs1_5;
    wire [7:0] weighted_inputs1_6;
    wire [7:0] weighted_inputs1_7;
    wire [7:0] weighted_inputs2_0;
    wire [7:0] weighted_inputs2_1;
    wire [7:0] weighted_inputs2_2;
    wire [7:0] weighted_inputs2_3;
    wire [7:0] weighted_inputs2_4;
    wire [7:0] weighted_inputs2_5;
    wire [7:0] weighted_inputs2_6;
    wire [7:0] weighted_inputs2_7;
    wire [7:0] weighted_inputs3_0;
    wire [7:0] weighted_inputs3_1;
    wire [7:0] weighted_inputs3_2;
    wire [7:0] weighted_inputs3_3;
    wire [7:0] weighted_inputs3_4;
    wire [7:0] weighted_inputs3_5;
    wire [7:0] weighted_inputs3_6;
    wire [7:0] weighted_inputs3_7;
    wire [7:0] weighted_inputs4_0;
    wire [7:0] weighted_inputs4_1;
    wire [7:0] weighted_inputs4_2;
    wire [7:0] weighted_inputs4_3;
    wire [7:0] weighted_inputs4_4;
    wire [7:0] weighted_inputs4_5;
    wire [7:0] weighted_inputs4_6;
    wire [7:0] weighted_inputs4_7;

    wire [10:0] sum1 [3:0];
    wire [11:0] biased_sum1 [3:0];

    weighted_inputs_1 w0 (.inputs(inputs0_1), .w(w1_1[0]), .wi(weighted_inputs1_0));
    weighted_inputs_1 w1 (.inputs(inputs1_1), .w(w1_1[1]), .wi(weighted_inputs1_1));
    weighted_inputs_1 w2 (.inputs(inputs2_1), .w(w1_1[2]), .wi(weighted_inputs1_2));
    weighted_inputs_1 w3 (.inputs(inputs3_1), .w(w1_1[3]), .wi(weighted_inputs1_3));
    weighted_inputs_1 w4 (.inputs(inputs4_1), .w(w1_1[4]), .wi(weighted_inputs1_4));
    weighted_inputs_1 w5 (.inputs(inputs5_1), .w(w1_1[5]), .wi(weighted_inputs1_5));
    weighted_inputs_1 w6 (.inputs(inputs6_1), .w(w1_1[6]), .wi(weighted_inputs1_6));
    weighted_inputs_1 w7 (.inputs(inputs7_1), .w(w1_1[7]), .wi(weighted_inputs1_7));
    weighted_inputs_1 w8 (.inputs(inputs0_1), .w(w2_1[0]), .wi(weighted_inputs2_0));
    weighted_inputs_1 w9 (.inputs(inputs1_1), .w(w2_1[1]), .wi(weighted_inputs2_1));
    weighted_inputs_1 w10 (.inputs(inputs2_1), .w(w2_1[2]), .wi(weighted_inputs2_2));
    weighted_inputs_1 w11 (.inputs(inputs3_1), .w(w2_1[3]), .wi(weighted_inputs2_3));
    weighted_inputs_1 w12 (.inputs(inputs4_1), .w(w2_1[4]), .wi(weighted_inputs2_4));
    weighted_inputs_1 w13 (.inputs(inputs5_1), .w(w2_1[5]), .wi(weighted_inputs2_5));
    weighted_inputs_1 w14 (.inputs(inputs6_1), .w(w2_1[6]), .wi(weighted_inputs2_6));
    weighted_inputs_1 w15 (.inputs(inputs7_1), .w(w2_1[7]), .wi(weighted_inputs2_7));
    weighted_inputs_1 w16 (.inputs(inputs0_1), .w(w3_1[0]), .wi(weighted_inputs3_0));
    weighted_inputs_1 w17 (.inputs(inputs1_1), .w(w3_1[1]), .wi(weighted_inputs3_1));
    weighted_inputs_1 w18 (.inputs(inputs2_1), .w(w3_1[2]), .wi(weighted_inputs3_2));
    weighted_inputs_1 w19 (.inputs(inputs3_1), .w(w3_1[3]), .wi(weighted_inputs3_3));
    weighted_inputs_1 w20 (.inputs(inputs4_1), .w(w3_1[4]), .wi(weighted_inputs3_4));
    weighted_inputs_1 w21 (.inputs(inputs5_1), .w(w3_1[5]), .wi(weighted_inputs3_5));
    weighted_inputs_1 w22 (.inputs(inputs6_1), .w(w3_1[6]), .wi(weighted_inputs3_6));
    weighted_inputs_1 w23 (.inputs(inputs7_1), .w(w3_1[7]), .wi(weighted_inputs3_7));
    weighted_inputs_1 w24 (.inputs(inputs0_1), .w(w4_1[0]), .wi(weighted_inputs4_0));
    weighted_inputs_1 w25 (.inputs(inputs1_1), .w(w4_1[1]), .wi(weighted_inputs4_1));
    weighted_inputs_1 w26 (.inputs(inputs2_1), .w(w4_1[2]), .wi(weighted_inputs4_2));
    weighted_inputs_1 w27 (.inputs(inputs3_1), .w(w4_1[3]), .wi(weighted_inputs4_3));
    weighted_inputs_1 w28 (.inputs(inputs4_1), .w(w4_1[4]), .wi(weighted_inputs4_4));
    weighted_inputs_1 w29 (.inputs(inputs5_1), .w(w4_1[5]), .wi(weighted_inputs4_5));
    weighted_inputs_1 w30 (.inputs(inputs6_1), .w(w4_1[6]), .wi(weighted_inputs4_6));
    weighted_inputs_1 w31 (.inputs(inputs7_1), .w(w4_1[7]), .wi(weighted_inputs4_7));
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
        .sum(sum1[3])
    );
    add11bit_1 u0 (.a(sum1[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1[0]));
    add11bit_1 u1 (.a(sum1[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1[1]));
    add11bit_1 u2 (.a(sum1[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1[2]));
    add11bit_1 u3 (.a(sum1[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1[3]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    always @(posedge clk) begin
        $display("----- BNN LAYER 1 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b", inputs0_1, inputs1_1, inputs2_1, inputs3_1, inputs4_1, inputs5_1, inputs6_1, inputs7_1);
        $display("Weights: %b %b %b %b", w1_1, w2_1, w3_1, w4_1);
        $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
        $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
    end
endmodule


module activation_1 (

    input [11:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[11] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_1 (
    input  [11:0] inputs0_0,
    input  [11:0] inputs1_0,
    input  [11:0] inputs2_0,
    input  [11:0] inputs3_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3
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
  input  wire [7:0] w1_1,
  input  wire [7:0] w2_1,
  input  wire [7:0] w3_1,
  input  wire [7:0] w4_1,
  input  wire [10:0] b1_1, b2_1, b3_1, b4_1,
  output wire activation0_1, 

  output wire activation1_1, 

  output wire activation2_1, 

  output wire activation3_1
);

  wire [11:0] biased_sum0_0;
  wire [11:0] biased_sum1_0;
  wire [11:0] biased_sum2_0;
  wire [11:0] biased_sum3_0;

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
    .w1_1(w1_1),
    .w2_1(w2_1),
    .w3_1(w3_1),
    .w4_1(w4_1),
    .b1_1(b1_1),
    .b2_1(b2_1),
    .b3_1(b3_1),
    .b4_1(b4_1),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0)
  );

    activation_array_1 act1 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .activation0(activation0_1),
    .activation1(activation1_1),
    .activation2(activation2_1),
    .activation3(activation3_1)
  );

    activation_array_1 act2 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .activation0(activation0_1),
    .activation1(activation1_1),
    .activation2(activation2_1),
    .activation3(activation3_1)
  );

    always @(posedge clk) begin
    $display("----- LAYER 1   boolean activations -----");
    $display("activation : %b %b %b %b", activation0_1, activation1_1, activation2_1, activation3_1);
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



module adder_tree_2 (
    input  wire   clk, 
    input  wire [0:0] in0,
    input  wire [0:0] in1,
    input  wire [0:0] in2,
    input  wire [0:0] in3,
    output wire [2:0] sum
);

    wire [1:0] stage0_0_lo_2;
    wire [1:0] stage0_1_lo_2;
    wire [2:0] stage1_0_lo_2;
    reg  [1:0] stage0_0_2;
    reg  [1:0] stage0_1_2;
    reg  [2:0] stage1_0_2;

    add1bit_2 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_2), .cout(), .cout_bar());
    add1bit_2 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_2), .cout(), .cout_bar());
    add2bit_2 u1_0 (.a(stage0_0_2), .b(stage0_1_2), .cin(1'b0), .y(stage1_0_lo_2), .cout(), .cout_bar());

    assign sum =  stage1_0_lo_2;

    always @(posedge clk) begin
        stage0_0_2 <=  stage0_0_lo_2;
        stage0_1_2 <=  stage0_1_lo_2;
        stage1_0_2 <=  stage1_0_lo_2;
    end
endmodule


module layer2(
    input clk,
    input [0:0] inputs0_2 , inputs1_2 , inputs2_2 , inputs3_2,
    input [3:0] w1_2, w2_2, w3_2, w4_2,
    input [2:0] b1_2, b2_2, b3_2, b4_2,
    output [3:0] biased_sum0_0 , biased_sum1_0 , biased_sum2_0 , biased_sum3_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;
    wire [0:0] weighted_inputs3_0;
    wire [0:0] weighted_inputs3_1;
    wire [0:0] weighted_inputs3_2;
    wire [0:0] weighted_inputs3_3;
    wire [0:0] weighted_inputs4_0;
    wire [0:0] weighted_inputs4_1;
    wire [0:0] weighted_inputs4_2;
    wire [0:0] weighted_inputs4_3;

    wire [2:0] sum1 [3:0];
    wire [3:0] biased_sum1 [3:0];

    weighted_inputs_2 w0 (.inputs(inputs0_2), .w(w1_2[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_2), .w(w1_2[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_2), .w(w1_2[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_2), .w(w1_2[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs0_2), .w(w2_2[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w5 (.inputs(inputs1_2), .w(w2_2[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w6 (.inputs(inputs2_2), .w(w2_2[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w7 (.inputs(inputs3_2), .w(w2_2[3]), .wi(weighted_inputs2_3));
    weighted_inputs_2 w8 (.inputs(inputs0_2), .w(w3_2[0]), .wi(weighted_inputs3_0));
    weighted_inputs_2 w9 (.inputs(inputs1_2), .w(w3_2[1]), .wi(weighted_inputs3_1));
    weighted_inputs_2 w10 (.inputs(inputs2_2), .w(w3_2[2]), .wi(weighted_inputs3_2));
    weighted_inputs_2 w11 (.inputs(inputs3_2), .w(w3_2[3]), .wi(weighted_inputs3_3));
    weighted_inputs_2 w12 (.inputs(inputs0_2), .w(w4_2[0]), .wi(weighted_inputs4_0));
    weighted_inputs_2 w13 (.inputs(inputs1_2), .w(w4_2[1]), .wi(weighted_inputs4_1));
    weighted_inputs_2 w14 (.inputs(inputs2_2), .w(w4_2[2]), .wi(weighted_inputs4_2));
    weighted_inputs_2 w15 (.inputs(inputs3_2), .w(w4_2[3]), .wi(weighted_inputs4_3));
    adder_tree_2 add0(
    .clk(clk), 
        .in0(weighted_inputs1_0),
        .in1(weighted_inputs1_1),
        .in2(weighted_inputs1_2),
        .in3(weighted_inputs1_3),
        .sum(sum1[0])
    );
    adder_tree_2 add1(
    .clk(clk), 
        .in0(weighted_inputs2_0),
        .in1(weighted_inputs2_1),
        .in2(weighted_inputs2_2),
        .in3(weighted_inputs2_3),
        .sum(sum1[1])
    );
    adder_tree_2 add2(
    .clk(clk), 
        .in0(weighted_inputs3_0),
        .in1(weighted_inputs3_1),
        .in2(weighted_inputs3_2),
        .in3(weighted_inputs3_3),
        .sum(sum1[2])
    );
    adder_tree_2 add3(
    .clk(clk), 
        .in0(weighted_inputs4_0),
        .in1(weighted_inputs4_1),
        .in2(weighted_inputs4_2),
        .in3(weighted_inputs4_3),
        .sum(sum1[3])
    );
    add3bit_2 u0 (.a(sum1[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1[0]));
    add3bit_2 u1 (.a(sum1[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1[1]));
    add3bit_2 u2 (.a(sum1[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1[2]));
    add3bit_2 u3 (.a(sum1[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1[3]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    always @(posedge clk) begin
        $display("----- BNN LAYER 2 OUTPUTS -----");
        $display("Inputs : %b %b %b %b", inputs0_2, inputs1_2, inputs2_2, inputs3_2);
        $display("Weights: %b %b %b %b", w1_2, w2_2, w3_2, w4_2);
        $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
        $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
    end
endmodule


module activation_2 (

    input [3:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[3] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_2 (
    input  [3:0] inputs0_0,
    input  [3:0] inputs1_0,
    input  [3:0] inputs2_0,
    input  [3:0] inputs3_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3
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

endmodule



module activation_and_conversion_2(
  input  wire clk, 
  input  wire [0:0] inputs0_2,
  input  wire [0:0] inputs1_2,
  input  wire [0:0] inputs2_2,
  input  wire [0:0] inputs3_2,
  input  wire [3:0] w1_2,
  input  wire [3:0] w2_2,
  input  wire [3:0] w3_2,
  input  wire [3:0] w4_2,
  input  wire [2:0] b1_2, b2_2, b3_2, b4_2,
  output wire activation0_2, 

  output wire activation1_2, 

  output wire activation2_2, 

  output wire activation3_2
);

  wire [3:0] biased_sum0_0;
  wire [3:0] biased_sum1_0;
  wire [3:0] biased_sum2_0;
  wire [3:0] biased_sum3_0;

    layer2 l1 (
    .clk(clk),
    .inputs0_2(inputs0_2),
    .inputs1_2(inputs1_2),
    .inputs2_2(inputs2_2),
    .inputs3_2(inputs3_2),
    .w1_2(w1_2),
    .w2_2(w2_2),
    .w3_2(w3_2),
    .w4_2(w4_2),
    .b1_2(b1_2),
    .b2_2(b2_2),
    .b3_2(b3_2),
    .b4_2(b4_2),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0)
  );

    activation_array_2 act1 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .activation0(activation0_2),
    .activation1(activation1_2),
    .activation2(activation2_2),
    .activation3(activation3_2)
  );

    activation_array_2 act2 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .activation0(activation0_2),
    .activation1(activation1_2),
    .activation2(activation2_2),
    .activation3(activation3_2)
  );

    always @(posedge clk) begin
    $display("----- LAYER 2   boolean activations -----");
    $display("activation : %b %b %b %b", activation0_2, activation1_2, activation2_2, activation3_2);
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



module adder_tree_3 (
    input  wire   clk, 
    input  wire [0:0] in0,
    input  wire [0:0] in1,
    input  wire [0:0] in2,
    input  wire [0:0] in3,
    output wire [2:0] sum
);

    wire [1:0] stage0_0_lo_3;
    wire [1:0] stage0_1_lo_3;
    wire [2:0] stage1_0_lo_3;
    reg  [1:0] stage0_0_3;
    reg  [1:0] stage0_1_3;
    reg  [2:0] stage1_0_3;

    add1bit_3 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_3), .cout(), .cout_bar());
    add1bit_3 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_3), .cout(), .cout_bar());
    add2bit_3 u1_0 (.a(stage0_0_3), .b(stage0_1_3), .cin(1'b0), .y(stage1_0_lo_3), .cout(), .cout_bar());

    assign sum =  stage1_0_lo_3;

    always @(posedge clk) begin
        stage0_0_3 <=  stage0_0_lo_3;
        stage0_1_3 <=  stage0_1_lo_3;
        stage1_0_3 <=  stage1_0_lo_3;
    end
endmodule


module layer3(
    input clk,
    input [0:0] inputs0_3 , inputs1_3 , inputs2_3 , inputs3_3,
    input [3:0] w1_3, w2_3, w3_3, w4_3,
    input [2:0] b1_3, b2_3, b3_3, b4_3,
    output [3:0] biased_sum0_0 , biased_sum1_0 , biased_sum2_0 , biased_sum3_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;
    wire [0:0] weighted_inputs3_0;
    wire [0:0] weighted_inputs3_1;
    wire [0:0] weighted_inputs3_2;
    wire [0:0] weighted_inputs3_3;
    wire [0:0] weighted_inputs4_0;
    wire [0:0] weighted_inputs4_1;
    wire [0:0] weighted_inputs4_2;
    wire [0:0] weighted_inputs4_3;

    wire [2:0] sum1 [3:0];
    wire [3:0] biased_sum1 [3:0];

    weighted_inputs_2 w0 (.inputs(inputs0_3), .w(w1_3[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_3), .w(w1_3[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_3), .w(w1_3[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_3), .w(w1_3[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs0_3), .w(w2_3[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w5 (.inputs(inputs1_3), .w(w2_3[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w6 (.inputs(inputs2_3), .w(w2_3[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w7 (.inputs(inputs3_3), .w(w2_3[3]), .wi(weighted_inputs2_3));
    weighted_inputs_2 w8 (.inputs(inputs0_3), .w(w3_3[0]), .wi(weighted_inputs3_0));
    weighted_inputs_2 w9 (.inputs(inputs1_3), .w(w3_3[1]), .wi(weighted_inputs3_1));
    weighted_inputs_2 w10 (.inputs(inputs2_3), .w(w3_3[2]), .wi(weighted_inputs3_2));
    weighted_inputs_2 w11 (.inputs(inputs3_3), .w(w3_3[3]), .wi(weighted_inputs3_3));
    weighted_inputs_2 w12 (.inputs(inputs0_3), .w(w4_3[0]), .wi(weighted_inputs4_0));
    weighted_inputs_2 w13 (.inputs(inputs1_3), .w(w4_3[1]), .wi(weighted_inputs4_1));
    weighted_inputs_2 w14 (.inputs(inputs2_3), .w(w4_3[2]), .wi(weighted_inputs4_2));
    weighted_inputs_2 w15 (.inputs(inputs3_3), .w(w4_3[3]), .wi(weighted_inputs4_3));
    adder_tree_3 add0(
    .clk(clk), 
        .in0(weighted_inputs1_0),
        .in1(weighted_inputs1_1),
        .in2(weighted_inputs1_2),
        .in3(weighted_inputs1_3),
        .sum(sum1[0])
    );
    adder_tree_3 add1(
    .clk(clk), 
        .in0(weighted_inputs2_0),
        .in1(weighted_inputs2_1),
        .in2(weighted_inputs2_2),
        .in3(weighted_inputs2_3),
        .sum(sum1[1])
    );
    adder_tree_3 add2(
    .clk(clk), 
        .in0(weighted_inputs3_0),
        .in1(weighted_inputs3_1),
        .in2(weighted_inputs3_2),
        .in3(weighted_inputs3_3),
        .sum(sum1[2])
    );
    adder_tree_3 add3(
    .clk(clk), 
        .in0(weighted_inputs4_0),
        .in1(weighted_inputs4_1),
        .in2(weighted_inputs4_2),
        .in3(weighted_inputs4_3),
        .sum(sum1[3])
    );
    add3bit_3 u0 (.a(sum1[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1[0]));
    add3bit_3 u1 (.a(sum1[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1[1]));
    add3bit_3 u2 (.a(sum1[2]), .b(b3_3), .cin(1'b0), .y(biased_sum1[2]));
    add3bit_3 u3 (.a(sum1[3]), .b(b4_3), .cin(1'b0), .y(biased_sum1[3]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum3_0 = biased_sum1[3];
    always @(posedge clk) begin
        $display("----- BNN LAYER 3 OUTPUTS -----");
        $display("Inputs : %b %b %b %b", inputs0_3, inputs1_3, inputs2_3, inputs3_3);
        $display("Weights: %b %b %b %b", w1_3, w2_3, w3_3, w4_3);
        $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
        $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
    end
endmodule


module activation_3 (

    input [3:0] inputs0_0,


    output activation
);

    wire activation = ( 1'b0 ^ inputs0_0[3] ) ? 1'b0 : 1'b1;

endmodule

module activation_array_3 (
    input  [3:0] inputs0_0,
    input  [3:0] inputs1_0,
    input  [3:0] inputs2_0,
    input  [3:0] inputs3_0,
    output wire activation0,
    output wire activation1,
    output wire activation2,
    output wire activation3
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

endmodule



module activation_and_conversion_3(
  input  wire clk, 
  input  wire [0:0] inputs0_3,
  input  wire [0:0] inputs1_3,
  input  wire [0:0] inputs2_3,
  input  wire [0:0] inputs3_3,
  input  wire [3:0] w1_3,
  input  wire [3:0] w2_3,
  input  wire [3:0] w3_3,
  input  wire [3:0] w4_3,
  input  wire [2:0] b1_3, b2_3, b3_3, b4_3,
  output wire activation0_3, 

  output wire activation1_3, 

  output wire activation2_3, 

  output wire activation3_3
);

  wire [3:0] biased_sum0_0;
  wire [3:0] biased_sum1_0;
  wire [3:0] biased_sum2_0;
  wire [3:0] biased_sum3_0;

    layer3 l1 (
    .clk(clk),
    .inputs0_3(inputs0_3),
    .inputs1_3(inputs1_3),
    .inputs2_3(inputs2_3),
    .inputs3_3(inputs3_3),
    .w1_3(w1_3),
    .w2_3(w2_3),
    .w3_3(w3_3),
    .w4_3(w4_3),
    .b1_3(b1_3),
    .b2_3(b2_3),
    .b3_3(b3_3),
    .b4_3(b4_3),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum3_0(biased_sum3_0)
  );

    activation_array_3 act1 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .activation0(activation0_3),
    .activation1(activation1_3),
    .activation2(activation2_3),
    .activation3(activation3_3)
  );

    activation_array_3 act2 (
    .inputs0_0(biased_sum0_0),
    .inputs1_0(biased_sum1_0),
    .inputs2_0(biased_sum2_0),
    .inputs3_0(biased_sum3_0),
    .activation0(activation0_3),
    .activation1(activation1_3),
    .activation2(activation2_3),
    .activation3(activation3_3)
  );

    always @(posedge clk) begin
    $display("----- LAYER 3   boolean activations -----");
    $display("activation : %b %b %b %b", activation0_3, activation1_3, activation2_3, activation3_3);
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



module adder_tree_4 (
    input  wire   clk, 
    input  wire [0:0] in0,
    input  wire [0:0] in1,
    input  wire [0:0] in2,
    input  wire [0:0] in3,
    output wire [2:0] sum
);

    wire [1:0] stage0_0_lo_4;
    wire [1:0] stage0_1_lo_4;
    wire [2:0] stage1_0_lo_4;
    reg  [1:0] stage0_0_4;
    reg  [1:0] stage0_1_4;
    reg  [2:0] stage1_0_4;

    add1bit_4 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_4), .cout(), .cout_bar());
    add1bit_4 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_4), .cout(), .cout_bar());
    add2bit_4 u1_0 (.a(stage0_0_4), .b(stage0_1_4), .cin(1'b0), .y(stage1_0_lo_4), .cout(), .cout_bar());

    assign sum =  stage1_0_lo_4;

    always @(posedge clk) begin
        stage0_0_4 <=  stage0_0_lo_4;
        stage0_1_4 <=  stage0_1_lo_4;
        stage1_0_4 <=  stage1_0_lo_4;
    end
endmodule


module layer4(
    input clk,
    input [0:0] inputs0_4 , inputs1_4 , inputs2_4 , inputs3_4,
    input [3:0] w1_4, w2_4,
    input [2:0] b1_4, b2_4,
    output [3:0] biased_sum0_0 , biased_sum1_0 
);
    wire [0:0] weighted_inputs1_0;
    wire [0:0] weighted_inputs1_1;
    wire [0:0] weighted_inputs1_2;
    wire [0:0] weighted_inputs1_3;
    wire [0:0] weighted_inputs2_0;
    wire [0:0] weighted_inputs2_1;
    wire [0:0] weighted_inputs2_2;
    wire [0:0] weighted_inputs2_3;

    wire [2:0] sum1 [1:0];
    wire [3:0] biased_sum1 [1:0];

    weighted_inputs_2 w0 (.inputs(inputs0_4), .w(w1_4[0]), .wi(weighted_inputs1_0));
    weighted_inputs_2 w1 (.inputs(inputs1_4), .w(w1_4[1]), .wi(weighted_inputs1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_4), .w(w1_4[2]), .wi(weighted_inputs1_2));
    weighted_inputs_2 w3 (.inputs(inputs3_4), .w(w1_4[3]), .wi(weighted_inputs1_3));
    weighted_inputs_2 w4 (.inputs(inputs0_4), .w(w2_4[0]), .wi(weighted_inputs2_0));
    weighted_inputs_2 w5 (.inputs(inputs1_4), .w(w2_4[1]), .wi(weighted_inputs2_1));
    weighted_inputs_2 w6 (.inputs(inputs2_4), .w(w2_4[2]), .wi(weighted_inputs2_2));
    weighted_inputs_2 w7 (.inputs(inputs3_4), .w(w2_4[3]), .wi(weighted_inputs2_3));
    adder_tree_4 add0(
    .clk(clk), 
        .in0(weighted_inputs1_0),
        .in1(weighted_inputs1_1),
        .in2(weighted_inputs1_2),
        .in3(weighted_inputs1_3),
        .sum(sum1[0])
    );
    adder_tree_4 add1(
    .clk(clk), 
        .in0(weighted_inputs2_0),
        .in1(weighted_inputs2_1),
        .in2(weighted_inputs2_2),
        .in3(weighted_inputs2_3),
        .sum(sum1[1])
    );
    add3bit_4 u0 (.a(sum1[0]), .b(b1_4), .cin(1'b0), .y(biased_sum1[0]));
    add3bit_4 u1 (.a(sum1[1]), .b(b2_4), .cin(1'b0), .y(biased_sum1[1]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum1_0 = biased_sum1[1];
    always @(posedge clk) begin
        $display("----- BNN LAYER 4 OUTPUTS -----");
        $display("Inputs : %b %b %b %b", inputs0_4, inputs1_4, inputs2_4, inputs3_4);
        $display("Weights: %b %b", w1_4, w2_4);
        $display("sum1: %b %b", sum1[0], sum1[1]);
        $display("biased_sum1: %b %b", biased_sum1[0], biased_sum1[1]);
    end
endmodule


module subtractor (
    input  wire signed [3:0] A,
    input  wire signed [3:0] B,
    output wire signed [4:0] Result
);
    assign Result = A - B;
endmodule

module comparator_1 (
    input  wire [4:0] inputs0_0,
    input  wire [4:0] inputs0_1,
    input  wire r0_0, r1_0, r2_0, r3_0, r4_0,
    output wire comparator
);
    // internal r_out chain
    wire r1 , r2 , r3 , r4 , r5;
    wire masked_c0_0 , masked_c1_0 , masked_c2_0 , masked_c3_0 , masked_c4_0;

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

    wire carry = r5 ^ masked_c4_0;
    // final compare: if carry ^ inputs0_0[N-1] ^ inputs0_1[N-1] == 0 → comparator = 1
    assign comparator = (carry ^ inputs0_0[4] ^ inputs0_1[4]) ? 1'b0 : 1'b1;
endmodule


module output_layer_max (
  input  clk, 
  input  wire [0:0] inputs0_4,
  input  wire [0:0] inputs1_4,
  input  wire [0:0] inputs2_4,
  input  wire [0:0] inputs3_4,
    input  wire [3:0] w1_4,
    input  wire [3:0] w2_4,
    input  wire [2:0] b1_4,
    input  wire [2:0] b2_4,
    input  wire r0_0,
    input  wire r1_0,
    input  wire r2_0,
    input  wire r3_0,
    input  wire r4_0,
    output reg  a0,
    output reg  a1
);

    wire [3:0] biased_sum0_0; 
    wire [3:0] biased_sum1_0; 

    layer4 l1 (
        .clk(clk),
        .inputs0_4(inputs0_4),
        .inputs1_4(inputs1_4),
        .inputs2_4(inputs2_4),
        .inputs3_4(inputs3_4),
        .w1_4(w1_4),
        .w2_4(w2_4),
        .b1_4(b1_4),
        .b2_4(b2_4),
        .biased_sum0_0(biased_sum0_0),
        .biased_sum1_0(biased_sum1_0)
    );

    wire [4:0] temp0_0;
    subtractor s0a (.A(biased_sum0_0), .B(biased_sum1_0), .Result(temp0_0));
    wire comp0;
    comparator_1 c0 (
        .inputs0_0(temp0_0), .inputs0_1(5'b0),
        .r0_0(r0_0), .r1_0(r1_0), .r2_0(r2_0), .r3_0(r3_0), .r4_0(r4_0),
        .comparator(comp0)
    );
    reg [3:0] stage1_0_0, stage1_0_1;
    always @(posedge clk) begin
        if (comp0)      begin stage1_0_0 <= biased_sum0_0;    stage1_0_1 <= 5'b0;    end
        else                    begin stage1_0_0 <= biased_sum1_0;    stage1_0_1 <= 5'b0;    end
    end

    always @(posedge clk) begin
        a0 <= 0;
        a1 <= 0;

        if (comp0 == 1) a0     <= 1;
        else             a1     <= 1;

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
    // Layer-1 weights & biases
    input  wire [7:0] w1_1,
    input  wire [7:0] w2_1,
    input  wire [7:0] w3_1,
    input  wire [7:0] w4_1,
    input  wire [10:0] b1_1, b2_1, b3_1, b4_1,

    // Layer-2 weights & biases
    input  wire [3:0] w1_2,
    input  wire [3:0] w2_2,
    input  wire [3:0] w3_2,
    input  wire [3:0] w4_2,
    input  wire [2:0] b1_2, b2_2, b3_2, b4_2,

    // Layer-3 weights & biases (output layer)
    input  wire [3:0] w1_3, 
    input  wire [3:0] w2_3, 
    input  wire [3:0] w3_3, 
    input  wire [3:0] w4_3, 
    input  wire [2:0] b1_3,
    input  wire [2:0] b2_3,
    input  wire [2:0] b3_3,
    input  wire [2:0] b4_3,

    // Layer-4 weights & biases (output layer)
    input  wire [3:0] w1_4,
    input  wire [3:0] w2_4,
    input  wire [2:0] b1_4,
    input  wire [2:0] b2_4,
    output wire a0,
    output wire a1
);

  //--------------------------------------------------------------------------
  // Layer-1 randomness taps
  //--------------------------------------------------------------------------
 wire activation0_1;
 wire activation1_1;
 wire activation2_1;
 wire activation3_1;
 reg activationr0_1;
 reg activationr1_1;
 reg activationr2_1;
 reg activationr3_1;
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
    .w1_1(w1_1), 
    .w2_1(w2_1), 
    .w3_1(w3_1), 
    .w4_1(w4_1), 
    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1),
    .activation0_1(activation0_1), 
    .activation1_1(activation1_1), 
    .activation2_1(activation2_1), 
    .activation3_1(activation3_1)
  );

  always @(posedge clk) begin
    activationr0_1 <=activation0_1;
    activationr1_1 <=activation1_1;
    activationr2_1 <=activation2_1;
    activationr3_1 <=activation3_1;
  end

  //--------------------------------------------------------------------------
  // Layer-2 randomness taps
  //--------------------------------------------------------------------------
 wire activation0_2;
 wire activation1_2;
 wire activation2_2;
 wire activation3_2;
 reg activationr0_2;
 reg activationr1_2;
 reg activationr2_2;
 reg activationr3_2;
  activation_and_conversion_2 layer2_inst (
    .clk(clk),
    .inputs0_2(activation0_1),
    .inputs1_2(activation1_1),
    .inputs2_2(activation2_1),
    .inputs3_2(activation3_1),
    .w1_2(w1_2),
    .w2_2(w2_2),
    .w3_2(w3_2),
    .w4_2(w4_2),
    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2),
    .activation0_2(activation0_2), 
    .activation1_2(activation1_2), 
    .activation2_2(activation2_2), 
    .activation3_2(activation3_2)
  );

  always @(posedge clk) begin
    activationr0_2 <= activation0_2;
    activationr1_2 <= activation1_2;
    activationr2_2 <= activation2_2;
    activationr3_2 <= activation3_2;
  end

  //--------------------------------------------------------------------------
  // Layer-3 randomness taps
  //--------------------------------------------------------------------------
 wire activation0_3;
 wire activation1_3;
 wire activation2_3;
 wire activation3_3;
 reg activationr0_3;
 reg activationr1_3;
 reg activationr2_3;
 reg activationr3_3;
  activation_and_conversion_3 layer3_inst (
    .clk(clk),
    .inputs0_3(activation0_2),
    .inputs1_3(activation1_2),
    .inputs2_3(activation2_2),
    .inputs3_3(activation3_2),
    .w1_3(w1_3),
    .w2_3(w2_3),
    .w3_3(w3_3),
    .w4_3(w4_3),
    .b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3),
    .activation0_3(activation0_3), 
    .activation1_3(activation1_3), 
    .activation2_3(activation2_3), 
    .activation3_3(activation3_3)
  );

  always @(posedge clk) begin
    activationr0_3 <= activation0_3;
    activationr1_3 <= activation1_3;
    activationr2_3 <= activation2_3;
    activationr3_3 <= activation3_3;
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
    #1;
  end

 reg a0_reg ;
 reg a1_reg ;
  output_layer_max layer4 (
    .clk(clk),
    .inputs0_4(activation0_3),
    .inputs1_4(activation1_3),
    .inputs2_4(activation2_3),
    .inputs3_4(activation3_3),
    .w1_4(w1_4),
    .w2_4(w2_4),
    .b1_4(b1_4), .b2_4(b2_4),
    .r0_0(r0_0),
    .r1_0(r1_0),
    .r2_0(r2_0),
    .r3_0(r3_0),
    .r4_0(r4_0),
    .a0(a0),
    .a1(a1)
  );

  always @(posedge clk) begin
    a0_reg <= a0;
    a1_reg <= a1;
  end

endmodule
`default_nettype wire
