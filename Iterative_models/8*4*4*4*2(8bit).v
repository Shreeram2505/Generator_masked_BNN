
    `timescale 1ns/1ps
    `default_nettype none
    
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

module mux_1 (

    input  wire a, b, s,

    output wire y
);

assign y = (~s & a)|(s & b);

endmodule


module mux_2(
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input  [7:0] d,
    input        s0,
    input        s1,
    output [7:0] y
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
    input  [7:0] a,
    input  [7:0] b,
    input  [7:0] c,
    input        s0,
    input        s1,
    output [7:0] y
);
    assign y = (s1 == 0 && s0 == 0) ? a :
               (s1 == 0 && s0 == 1) ? b :
               (s1 == 1 && s0 == 0) ? c :
               3'b000; // Default value for (s1 == 1 && s0 == 1)
endmodule


module half_adder(
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

module add8bit(
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));

WddlNAND wn1(.A(~a[7]), .B(b[7]), .C(~c8), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[7]), .B(~b[7]), .C(~c8), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[7]), .B(b[7]), .C(c8), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[7]), .B(~b[7]), .C(c8), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[8] = cout;

endmodule

module add9bit(
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adder fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));

WddlNAND wn1(.A(~a[8]), .B(b[8]), .C(~c9), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[8]), .B(~b[8]), .C(~c9), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[8]), .B(b[8]), .C(c9), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[8]), .B(~b[8]), .C(c9), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[9] = cout;

endmodule

module add10bit(
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adder fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adder fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));

WddlNAND wn1(.A(~a[9]), .B(b[9]), .C(~c10), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[9]), .B(~b[9]), .C(~c10), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[9]), .B(b[9]), .C(c10), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[9]), .B(~b[9]), .C(c10), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[10] = cout;

endmodule

module add11bit(
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adder fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adder fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));
full_adder fa10(.S(y[10]), .C(c11), .X(a[10]), .Y(b[10]), .Z(c10));

WddlNAND wn1(.A(~a[10]), .B(b[10]), .C(~c11), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[10]), .B(~b[10]), .C(~c11), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[10]), .B(b[10]), .C(c11), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[10]), .B(~b[10]), .C(c11), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[11] = cout;

endmodule


module half_adderbar(
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

module add8bitbar(
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));

WddlNANDbar wn1(.A(~a[7]), .B(b[7]), .C(~c8), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[7]), .B(~b[7]), .C(~c8), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[7]), .B(b[7]), .C(c8), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[7]), .B(~b[7]), .C(c8), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[8] = cout_bar;

endmodule

module add9bitbar(
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adderbar fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));

WddlNANDbar wn1(.A(~a[8]), .B(b[8]), .C(~c9), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[8]), .B(~b[8]), .C(~c9), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[8]), .B(b[8]), .C(c9), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[8]), .B(~b[8]), .C(c9), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[9] = cout_bar;

endmodule

module add10bitbar(
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adderbar fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adderbar fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));

WddlNANDbar wn1(.A(~a[9]), .B(b[9]), .C(~c10), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[9]), .B(~b[9]), .C(~c10), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[9]), .B(b[9]), .C(c10), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[9]), .B(~b[9]), .C(c10), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[10] = cout_bar;

endmodule

module add11bitbar(
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adderbar fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adderbar fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));
full_adderbar fa10(.S(y[10]), .C(c11), .X(a[10]), .Y(b[10]), .Z(c10));

WddlNANDbar wn1(.A(~a[10]), .B(b[10]), .C(~c11), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[10]), .B(~b[10]), .C(~c11), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[10]), .B(b[10]), .C(c11), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[10]), .B(~b[10]), .C(c11), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[11] = cout_bar;

endmodule



module adder_tree (
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

    wire [8:0] stage0_0_lo;
    wire [8:0] stage0_1_lo;
    wire [8:0] stage0_2_lo;
    wire [8:0] stage0_3_lo;
    wire [9:0] stage1_0_lo;
    wire [9:0] stage1_1_lo;
    wire [10:0] stage2_0_lo;
    reg  [8:0] stage0_0;
    reg  [8:0] stage0_1;
    reg  [8:0] stage0_2;
    reg  [8:0] stage0_3;
    reg  [9:0] stage1_0;
    reg  [9:0] stage1_1;
    reg  [10:0] stage2_0;

    add8bit u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add8bit u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add8bit u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add8bit u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add9bit u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add9bit u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add10bit u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum =  stage2_0_lo;

    always @(posedge clk) begin
        stage0_0 <=  stage0_0_lo;
        stage0_1 <=  stage0_1_lo;
        stage0_2 <=  stage0_2_lo;
        stage0_3 <=  stage0_3_lo;
        stage1_0 <=  stage1_0_lo;
        stage1_1 <=  stage1_1_lo;
        stage2_0 <=  stage2_0_lo;
    end
endmodule


module adder_tree_bar (
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

    wire [8:0] stage0_0_lo_bar;
    wire [8:0] stage0_1_lo_bar;
    wire [8:0] stage0_2_lo_bar;
    wire [8:0] stage0_3_lo_bar;
    wire [9:0] stage1_0_lo_bar;
    wire [9:0] stage1_1_lo_bar;
    wire [10:0] stage2_0_lo_bar;
    reg  [8:0] stage0_0_bar;
    reg  [8:0] stage0_1_bar;
    reg  [8:0] stage0_2_bar;
    reg  [8:0] stage0_3_bar;
    reg  [9:0] stage1_0_bar;
    reg  [9:0] stage1_1_bar;
    reg  [10:0] stage2_0_bar;

    add8bitbar u0_0_bar (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_bar), .cout(), .cout_bar());
    add8bitbar u0_1_bar (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_bar), .cout(), .cout_bar());
    add8bitbar u0_2_bar (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_bar), .cout(), .cout_bar());
    add8bitbar u0_3_bar (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_bar), .cout(), .cout_bar());
    add9bitbar u1_0_bar (.a(stage0_0_bar), .b(stage0_1_bar), .cin(1'b0), .y(stage1_0_lo_bar), .cout(), .cout_bar());
    add9bitbar u1_1_bar (.a(stage0_2_bar), .b(stage0_3_bar), .cin(1'b0), .y(stage1_1_lo_bar), .cout(), .cout_bar());
    add10bitbar u2_0_bar (.a(stage1_0_bar), .b(stage1_1_bar), .cin(1'b0), .y(stage2_0_lo_bar), .cout(), .cout_bar());

    assign sum =  stage2_0_lo_bar;

    always @(posedge clk) begin
        stage0_0_bar <=  stage0_0_lo_bar;
        stage0_1_bar <=  stage0_1_lo_bar;
        stage0_2_bar <=  stage0_2_lo_bar;
        stage0_3_bar <=  stage0_3_lo_bar;
        stage1_0_bar <=  stage1_0_lo_bar;
        stage1_1_bar <=  stage1_1_lo_bar;
        stage2_0_bar <=  stage2_0_lo_bar;
    end
endmodule

module mux_5(
    input  [10:0] a,
    input  [10:0] b,
    input  [10:0] c,
    input  [10:0] d,
    input        s0,
    input        s1,
    output [10:0] y
);
    assign y = (!s1 && !s0) ? a :
               (!s1 &&  s0) ? b :
               ( s1 && !s0) ? c :
                              d;
endmodule

module activation (

    input [11:0] inputs0_0,
    input [11:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0, r9_0, r10_0, r11_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0, masked_c6_0, masked_c7_0, masked_c8_0, masked_c9_0, masked_c10_0, masked_c11_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0), .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0), .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0), .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0), .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0), .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0), .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));
    lut1 l6 (.a(inputs0_0[6]), .b(inputs0_1[6]), .c_in(masked_c5_0), .r_flow(r6), .r_i(r6_0), .r_out(r7), .c_masked(masked_c6_0));
    lut1 l7 (.a(inputs0_0[7]), .b(inputs0_1[7]), .c_in(masked_c6_0), .r_flow(r7), .r_i(r7_0), .r_out(r8), .c_masked(masked_c7_0));
    lut1 l8 (.a(inputs0_0[8]), .b(inputs0_1[8]), .c_in(masked_c7_0), .r_flow(r8), .r_i(r8_0), .r_out(r9), .c_masked(masked_c8_0));
    lut1 l9 (.a(inputs0_0[9]), .b(inputs0_1[9]), .c_in(masked_c8_0), .r_flow(r9), .r_i(r9_0), .r_out(r10), .c_masked(masked_c9_0));
    lut1 l10 (.a(inputs0_0[10]), .b(inputs0_1[10]), .c_in(masked_c9_0), .r_flow(r10), .r_i(r10_0), .r_out(r11), .c_masked(masked_c10_0));
    lut1 l11 (.a(inputs0_0[11]), .b(inputs0_1[11]), .c_in(masked_c10_0), .r_flow(r11), .r_i(r11_0), .r_out(r12), .c_masked(masked_c11_0));

    wire carry = r12 ^ masked_c11_0;
    wire activation = (carry ^ inputs0_0[11] ^ inputs0_1[11]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r12;
    assign mask = r12;

endmodule

module activation_array_1 (
    input  [11:0] inputs0_0, inputs0_1,
    input  [11:0] inputs1_0, inputs1_1,
    input  [11:0] inputs2_0, inputs2_1,
    input  [11:0] inputs3_0, inputs3_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0, r9_0, r10_0, r11_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1, r6_1, r7_1, r8_1, r9_1, r10_1, r11_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2, r7_2, r8_2, r9_2, r10_2, r11_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3, r6_3, r7_3, r8_3, r9_3, r10_3, r11_3,
    output wire masked_activation0,
    output wire masked_activation1,
    output wire masked_activation2,
    output wire masked_activation3,
    output wire mask0,
    output wire mask1,
    output wire mask2,
    output wire mask3
);

    activation a0 (
        .inputs0_0(inputs0_0), .inputs0_1(inputs0_1),
        .r0_0(r0_0),
        .r1_0(r1_0),
        .r2_0(r2_0),
        .r3_0(r3_0),
        .r4_0(r4_0),
        .r5_0(r5_0),
        .r6_0(r6_0),
        .r7_0(r7_0),
        .r8_0(r8_0),
        .r9_0(r9_0),
        .r10_0(r10_0),
        .r11_0(r11_0),
        .masked_activation(masked_activation0),
        .mask(mask0)
    );

    activation a1 (
        .inputs0_0(inputs1_0), .inputs0_1(inputs1_1),
        .r0_0(r0_1),
        .r1_0(r1_1),
        .r2_0(r2_1),
        .r3_0(r3_1),
        .r4_0(r4_1),
        .r5_0(r5_1),
        .r6_0(r6_1),
        .r7_0(r7_1),
        .r8_0(r8_1),
        .r9_0(r9_1),
        .r10_0(r10_1),
        .r11_0(r11_1),
        .masked_activation(masked_activation1),
        .mask(mask1)
    );

    activation a2 (
        .inputs0_0(inputs2_0), .inputs0_1(inputs2_1),
        .r0_0(r0_2),
        .r1_0(r1_2),
        .r2_0(r2_2),
        .r3_0(r3_2),
        .r4_0(r4_2),
        .r5_0(r5_2),
        .r6_0(r6_2),
        .r7_0(r7_2),
        .r8_0(r8_2),
        .r9_0(r9_2),
        .r10_0(r10_2),
        .r11_0(r11_2),
        .masked_activation(masked_activation2),
        .mask(mask2)
    );

    activation a3 (
        .inputs0_0(inputs3_0), .inputs0_1(inputs3_1),
        .r0_0(r0_3),
        .r1_0(r1_3),
        .r2_0(r2_3),
        .r3_0(r3_3),
        .r4_0(r4_3),
        .r5_0(r5_3),
        .r6_0(r6_3),
        .r7_0(r7_3),
        .r8_0(r8_3),
        .r9_0(r9_3),
        .r10_0(r10_3),
        .r11_0(r11_3),
        .masked_activation(masked_activation3),
        .mask(mask3)
    );

endmodule

module layer (
  input wire  clk,
  input wire  rst_n,
  input wire  start,
  input wire [7:0] inputs0_1, inputs1_1, inputs2_1, inputs3_1, inputs4_1, inputs5_1, inputs6_1, inputs7_1,
  input wire [7:0] act0_0_0, act0_0_1, act0_0_2, act0_0_3, act0_0_4, act0_0_5, act0_0_6, act0_0_7,
  input wire [7:0] act0_1_0, act0_1_1, act0_1_2, act0_1_3, act0_1_4, act0_1_5, act0_1_6, act0_1_7,
  input wire [7:0] act1_0_0, act1_0_1, act1_0_2, act1_0_3, act1_0_4, act1_0_5, act1_0_6, act1_0_7,
  input wire [7:0] act1_1_0, act1_1_1, act1_1_2, act1_1_3, act1_1_4, act1_1_5, act1_1_6, act1_1_7,
  input wire [7:0] act2_0_0, act2_0_1, act2_0_2, act2_0_3, act2_0_4, act2_0_5, act2_0_6, act2_0_7,
  input wire [7:0] act2_1_0, act2_1_1, act2_1_2, act2_1_3, act2_1_4, act2_1_5, act2_1_6, act2_1_7,
  input wire [7:0] act3_0_0, act3_0_1, act3_0_2, act3_0_3, act3_0_4, act3_0_5, act3_0_6, act3_0_7,
  input wire [7:0] act3_1_0, act3_1_1, act3_1_2, act3_1_3, act3_1_4, act3_1_5, act3_1_6, act3_1_7,
  input wire [7:0] w1_0_1, w1_1_1,
  input wire [7:0] w2_0_1, w2_1_1,
  input wire [7:0] w3_0_1, w3_1_1,
  input wire [7:0] w4_0_1, w4_1_1,
  input wire [10:0] b1_1, b1_2, b1_3, b1_4,
  input wire [10:0] b2_1, b2_2, b2_3, b2_4,
  input wire [10:0] b3_1, b3_2, b3_3, b3_4,
  input wire [10:0] b4_1, b4_2, b4_3, b4_4,
  input wire [1:0] s,
  output reg  done,
  output reg [11:0] biased_sum0_0_r, biased_sum0_1_r, biased_sum0_0bar_r, biased_sum0_1bar_r,
  output reg [11:0] biased_sum1_0_r, biased_sum1_1_r, biased_sum1_0bar_r, biased_sum1_1bar_r,
  output reg [11:0] biased_sum2_0_r, biased_sum2_1_r, biased_sum2_0bar_r, biased_sum2_1bar_r,
  output reg [11:0] biased_sum3_0_r, biased_sum3_1_r, biased_sum3_0bar_r, biased_sum3_1bar_r,
  output reg  masked_activation0_1_r, masked_activation0bar_1_r,
  output reg  masked_activation1_1_r, masked_activation1bar_1_r,
  output reg  masked_activation2_1_r, masked_activation2bar_1_r,
  output reg  masked_activation3_1_r, masked_activation3bar_1_r,
  output reg  mask0_1_r, mask0bar_1_r,
  output reg  mask1_1_r, mask1bar_1_r,
  output reg  mask2_1_r, mask2bar_1_r,
  output reg  mask3_1_r, mask3bar_1_r
);

  // internal wires
  wire [11:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar;
  wire masked_activation0_1, masked_activation0bar_1;
  wire mask0_1, mask0bar_1;
  wire [11:0] biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar;
  wire masked_activation1_1, masked_activation1bar_1;
  wire mask1_1, mask1bar_1;
  wire [11:0] biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar;
  wire masked_activation2_1, masked_activation2bar_1;
  wire mask2_1, mask2bar_1;
  wire [11:0] biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar;
  wire masked_activation3_1, masked_activation3bar_1;
  wire mask3_1, mask3bar_1;
  

  wire [7:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
  wire [7:0] new_weighted_inputs1_0_0, new_weighted_inputs1_0_1;
  wire [7:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
  wire [7:0] new_weighted_inputs1_1_0, new_weighted_inputs1_1_1;
  wire [7:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
  wire [7:0] new_weighted_inputs1_2_0, new_weighted_inputs1_2_1;
  wire [7:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
  wire [7:0] new_weighted_inputs1_3_0, new_weighted_inputs1_3_1;
  wire [7:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
  wire [7:0] new_weighted_inputs1_4_0, new_weighted_inputs1_4_1;
  wire [7:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
  wire [7:0] new_weighted_inputs1_5_0, new_weighted_inputs1_5_1;
  wire [7:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
  wire [7:0] new_weighted_inputs1_6_0, new_weighted_inputs1_6_1;
  wire [7:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
  wire [7:0] new_weighted_inputs1_7_0, new_weighted_inputs1_7_1;
  wire [7:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
  wire [7:0] new_weighted_inputs2_0_0, new_weighted_inputs2_0_1;
  wire [7:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
  wire [7:0] new_weighted_inputs2_1_0, new_weighted_inputs2_1_1;
  wire [7:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
  wire [7:0] new_weighted_inputs2_2_0, new_weighted_inputs2_2_1;
  wire [7:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
  wire [7:0] new_weighted_inputs2_3_0, new_weighted_inputs2_3_1;
  wire [7:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
  wire [7:0] new_weighted_inputs2_4_0, new_weighted_inputs2_4_1;
  wire [7:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
  wire [7:0] new_weighted_inputs2_5_0, new_weighted_inputs2_5_1;
  wire [7:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
  wire [7:0] new_weighted_inputs2_6_0, new_weighted_inputs2_6_1;
  wire [7:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
  wire [7:0] new_weighted_inputs2_7_0, new_weighted_inputs2_7_1;
  wire [7:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
  wire [7:0] new_weighted_inputs3_0_0, new_weighted_inputs3_0_1;
  wire [7:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
  wire [7:0] new_weighted_inputs3_1_0, new_weighted_inputs3_1_1;
  wire [7:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
  wire [7:0] new_weighted_inputs3_2_0, new_weighted_inputs3_2_1;
  wire [7:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
  wire [7:0] new_weighted_inputs3_3_0, new_weighted_inputs3_3_1;
  wire [7:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
  wire [7:0] new_weighted_inputs3_4_0, new_weighted_inputs3_4_1;
  wire [7:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
  wire [7:0] new_weighted_inputs3_5_0, new_weighted_inputs3_5_1;
  wire [7:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
  wire [7:0] new_weighted_inputs3_6_0, new_weighted_inputs3_6_1;
  wire [7:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
  wire [7:0] new_weighted_inputs3_7_0, new_weighted_inputs3_7_1;
  wire [7:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
  wire [7:0] new_weighted_inputs4_0_0, new_weighted_inputs4_0_1;
  wire [7:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
  wire [7:0] new_weighted_inputs4_1_0, new_weighted_inputs4_1_1;
  wire [7:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
  wire [7:0] new_weighted_inputs4_2_0, new_weighted_inputs4_2_1;
  wire [7:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
  wire [7:0] new_weighted_inputs4_3_0, new_weighted_inputs4_3_1;
  wire [7:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
  wire [7:0] new_weighted_inputs4_4_0, new_weighted_inputs4_4_1;
  wire [7:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
  wire [7:0] new_weighted_inputs4_5_0, new_weighted_inputs4_5_1;
  wire [7:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
  wire [7:0] new_weighted_inputs4_6_0, new_weighted_inputs4_6_1;
  wire [7:0] weighted_inputs4_7_0, weighted_inputs4_7_1;
  wire [7:0] new_weighted_inputs4_7_0, new_weighted_inputs4_7_1;
  

  wire [10:0] sum1 [3:0], sum2 [3:0], sum1bar [3:0], sum2bar [3 :0];
  wire [11:0] biased_sum1 [3:0], biased_sum2 [3:0], biased_sum1bar [3:0], biased_sum2bar [3:0];
  

  wire [7:0] act0_0_0_1;
  wire [7:0] act0_0_1_1;
  wire [7:0] act0_0_0_2;
  wire [7:0] act0_0_1_2;
  wire [7:0] act0_0_0_3;
  wire [7:0] act0_0_1_3;
  wire [7:0] act0_1_0_1;
  wire [7:0] act0_1_1_1;
  wire [7:0] act0_1_0_2;
  wire [7:0] act0_1_1_2;
  wire [7:0] act0_1_0_3;
  wire [7:0] act0_1_1_3;
  wire [7:0] act0_2_0_1;
  wire [7:0] act0_2_1_1;
  wire [7:0] act0_2_0_2;
  wire [7:0] act0_2_1_2;
  wire [7:0] act0_2_0_3;
  wire [7:0] act0_2_1_3;
  wire [7:0] act0_3_0_1;
  wire [7:0] act0_3_1_1;
  wire [7:0] act0_3_0_2;
  wire [7:0] act0_3_1_2;
  wire [7:0] act0_3_0_3;
  wire [7:0] act0_3_1_3;
  wire [7:0] act0_4_0_1;
  wire [7:0] act0_4_1_1;
  wire [7:0] act0_4_0_2;
  wire [7:0] act0_4_1_2;
  wire [7:0] act0_4_0_3;
  wire [7:0] act0_4_1_3;
  wire [7:0] act0_5_0_1;
  wire [7:0] act0_5_1_1;
  wire [7:0] act0_5_0_2;
  wire [7:0] act0_5_1_2;
  wire [7:0] act0_5_0_3;
  wire [7:0] act0_5_1_3;
  wire [7:0] act0_6_0_1;
  wire [7:0] act0_6_1_1;
  wire [7:0] act0_6_0_2;
  wire [7:0] act0_6_1_2;
  wire [7:0] act0_6_0_3;
  wire [7:0] act0_6_1_3;
  wire [7:0] act0_7_0_1;
  wire [7:0] act0_7_1_1;
  wire [7:0] act0_7_0_2;
  wire [7:0] act0_7_1_2;
  wire [7:0] act0_7_0_3;
  wire [7:0] act0_7_1_3;
  wire [7:0] act1_0_0_1;
  wire [7:0] act1_0_1_1;
  wire [7:0] act1_0_0_2;
  wire [7:0] act1_0_1_2;
  wire [7:0] act1_0_0_3;
  wire [7:0] act1_0_1_3;
  wire [7:0] act1_1_0_1;
  wire [7:0] act1_1_1_1;
  wire [7:0] act1_1_0_2;
  wire [7:0] act1_1_1_2;
  wire [7:0] act1_1_0_3;
  wire [7:0] act1_1_1_3;
  wire [7:0] act1_2_0_1;
  wire [7:0] act1_2_1_1;
  wire [7:0] act1_2_0_2;
  wire [7:0] act1_2_1_2;
  wire [7:0] act1_2_0_3;
  wire [7:0] act1_2_1_3;
  wire [7:0] act1_3_0_1;
  wire [7:0] act1_3_1_1;
  wire [7:0] act1_3_0_2;
  wire [7:0] act1_3_1_2;
  wire [7:0] act1_3_0_3;
  wire [7:0] act1_3_1_3;
  wire [7:0] act1_4_0_1;
  wire [7:0] act1_4_1_1;
  wire [7:0] act1_4_0_2;
  wire [7:0] act1_4_1_2;
  wire [7:0] act1_4_0_3;
  wire [7:0] act1_4_1_3;
  wire [7:0] act1_5_0_1;
  wire [7:0] act1_5_1_1;
  wire [7:0] act1_5_0_2;
  wire [7:0] act1_5_1_2;
  wire [7:0] act1_5_0_3;
  wire [7:0] act1_5_1_3;
  wire [7:0] act1_6_0_1;
  wire [7:0] act1_6_1_1;
  wire [7:0] act1_6_0_2;
  wire [7:0] act1_6_1_2;
  wire [7:0] act1_6_0_3;
  wire [7:0] act1_6_1_3;
  wire [7:0] act1_7_0_1;
  wire [7:0] act1_7_1_1;
  wire [7:0] act1_7_0_2;
  wire [7:0] act1_7_1_2;
  wire [7:0] act1_7_0_3;
  wire [7:0] act1_7_1_3;
  wire [7:0] act2_0_0_1;
  wire [7:0] act2_0_1_1;
  wire [7:0] act2_0_0_2;
  wire [7:0] act2_0_1_2;
  wire [7:0] act2_0_0_3;
  wire [7:0] act2_0_1_3;
  wire [7:0] act2_1_0_1;
  wire [7:0] act2_1_1_1;
  wire [7:0] act2_1_0_2;
  wire [7:0] act2_1_1_2;
  wire [7:0] act2_1_0_3;
  wire [7:0] act2_1_1_3;
  wire [7:0] act2_2_0_1;
  wire [7:0] act2_2_1_1;
  wire [7:0] act2_2_0_2;
  wire [7:0] act2_2_1_2;
  wire [7:0] act2_2_0_3;
  wire [7:0] act2_2_1_3;
  wire [7:0] act2_3_0_1;
  wire [7:0] act2_3_1_1;
  wire [7:0] act2_3_0_2;
  wire [7:0] act2_3_1_2;
  wire [7:0] act2_3_0_3;
  wire [7:0] act2_3_1_3;
  wire [7:0] act2_4_0_1;
  wire [7:0] act2_4_1_1;
  wire [7:0] act2_4_0_2;
  wire [7:0] act2_4_1_2;
  wire [7:0] act2_4_0_3;
  wire [7:0] act2_4_1_3;
  wire [7:0] act2_5_0_1;
  wire [7:0] act2_5_1_1;
  wire [7:0] act2_5_0_2;
  wire [7:0] act2_5_1_2;
  wire [7:0] act2_5_0_3;
  wire [7:0] act2_5_1_3;
  wire [7:0] act2_6_0_1;
  wire [7:0] act2_6_1_1;
  wire [7:0] act2_6_0_2;
  wire [7:0] act2_6_1_2;
  wire [7:0] act2_6_0_3;
  wire [7:0] act2_6_1_3;
  wire [7:0] act2_7_0_1;
  wire [7:0] act2_7_1_1;
  wire [7:0] act2_7_0_2;
  wire [7:0] act2_7_1_2;
  wire [7:0] act2_7_0_3;
  wire [7:0] act2_7_1_3;
  wire [7:0] act3_0_0_1;
  wire [7:0] act3_0_1_1;
  wire [7:0] act3_0_0_2;
  wire [7:0] act3_0_1_2;
  wire [7:0] act3_0_0_3;
  wire [7:0] act3_0_1_3;
  wire [7:0] act3_1_0_1;
  wire [7:0] act3_1_1_1;
  wire [7:0] act3_1_0_2;
  wire [7:0] act3_1_1_2;
  wire [7:0] act3_1_0_3;
  wire [7:0] act3_1_1_3;
  wire [7:0] act3_2_0_1;
  wire [7:0] act3_2_1_1;
  wire [7:0] act3_2_0_2;
  wire [7:0] act3_2_1_2;
  wire [7:0] act3_2_0_3;
  wire [7:0] act3_2_1_3;
  wire [7:0] act3_3_0_1;
  wire [7:0] act3_3_1_1;
  wire [7:0] act3_3_0_2;
  wire [7:0] act3_3_1_2;
  wire [7:0] act3_3_0_3;
  wire [7:0] act3_3_1_3;
  wire [7:0] act3_4_0_1;
  wire [7:0] act3_4_1_1;
  wire [7:0] act3_4_0_2;
  wire [7:0] act3_4_1_2;
  wire [7:0] act3_4_0_3;
  wire [7:0] act3_4_1_3;
  wire [7:0] act3_5_0_1;
  wire [7:0] act3_5_1_1;
  wire [7:0] act3_5_0_2;
  wire [7:0] act3_5_1_2;
  wire [7:0] act3_5_0_3;
  wire [7:0] act3_5_1_3;
  wire [7:0] act3_6_0_1;
  wire [7:0] act3_6_1_1;
  wire [7:0] act3_6_0_2;
  wire [7:0] act3_6_1_2;
  wire [7:0] act3_6_0_3;
  wire [7:0] act3_6_1_3;
  wire [7:0] act3_7_0_1;
  wire [7:0] act3_7_1_1;
  wire [7:0] act3_7_0_2;
  wire [7:0] act3_7_1_2;
  wire [7:0] act3_7_0_3;
  wire [7:0] act3_7_1_3;
  

  assign act0_0_0_1= act0_0_0;
  assign act0_0_1_1= act0_1_0;
  assign act0_0_0_2= act0_0_0;
  assign act0_0_1_2= act0_1_0;
  assign act0_0_0_3= act0_0_0;
  assign act0_0_1_3= act0_1_0;
  assign act0_1_0_1= act0_0_1;
  assign act0_1_1_1= act0_1_1;
  assign act0_1_0_2= act0_0_1;
  assign act0_1_1_2= act0_1_1;
  assign act0_1_0_3= act0_0_1;
  assign act0_1_1_3= act0_1_1;
  assign act0_2_0_1= act0_0_2;
  assign act0_2_1_1= act0_1_2;
  assign act0_2_0_2= act0_0_2;
  assign act0_2_1_2= act0_1_2;
  assign act0_2_0_3= act0_0_2;
  assign act0_2_1_3= act0_1_2;
  assign act0_3_0_1= act0_0_3;
  assign act0_3_1_1= act0_1_3;
  assign act0_3_0_2= act0_0_3;
  assign act0_3_1_2= act0_1_3;
  assign act0_3_0_3= act0_0_3;
  assign act0_3_1_3= act0_1_3;
  assign act0_4_0_1= act0_0_4;
  assign act0_4_1_1= act0_1_4;
  assign act0_4_0_2= act0_0_4;
  assign act0_4_1_2= act0_1_4;
  assign act0_4_0_3= act0_0_4;
  assign act0_4_1_3= act0_1_4;
  assign act0_5_0_1= act0_0_5;
  assign act0_5_1_1= act0_1_5;
  assign act0_5_0_2= act0_0_5;
  assign act0_5_1_2= act0_1_5;
  assign act0_5_0_3= act0_0_5;
  assign act0_5_1_3= act0_1_5;
  assign act0_6_0_1= act0_0_6;
  assign act0_6_1_1= act0_1_6;
  assign act0_6_0_2= act0_0_6;
  assign act0_6_1_2= act0_1_6;
  assign act0_6_0_3= act0_0_6;
  assign act0_6_1_3= act0_1_6;
  assign act0_7_0_1= act0_0_7;
  assign act0_7_1_1= act0_1_7;
  assign act0_7_0_2= act0_0_7;
  assign act0_7_1_2= act0_1_7;
  assign act0_7_0_3= act0_0_7;
  assign act0_7_1_3= act0_1_7;
  assign act1_0_0_1= act1_0_0;
  assign act1_0_1_1= act1_1_0;
  assign act1_0_0_2= act1_0_0;
  assign act1_0_1_2= act1_1_0;
  assign act1_0_0_3= act1_0_0;
  assign act1_0_1_3= act1_1_0;
  assign act1_1_0_1= act1_0_1;
  assign act1_1_1_1= act1_1_1;
  assign act1_1_0_2= act1_0_1;
  assign act1_1_1_2= act1_1_1;
  assign act1_1_0_3= act1_0_1;
  assign act1_1_1_3= act1_1_1;
  assign act1_2_0_1= act1_0_2;
  assign act1_2_1_1= act1_1_2;
  assign act1_2_0_2= act1_0_2;
  assign act1_2_1_2= act1_1_2;
  assign act1_2_0_3= act1_0_2;
  assign act1_2_1_3= act1_1_2;
  assign act1_3_0_1= act1_0_3;
  assign act1_3_1_1= act1_1_3;
  assign act1_3_0_2= act1_0_3;
  assign act1_3_1_2= act1_1_3;
  assign act1_3_0_3= act1_0_3;
  assign act1_3_1_3= act1_1_3;
  assign act1_4_0_1= act1_0_4;
  assign act1_4_1_1= act1_1_4;
  assign act1_4_0_2= act1_0_4;
  assign act1_4_1_2= act1_1_4;
  assign act1_4_0_3= act1_0_4;
  assign act1_4_1_3= act1_1_4;
  assign act1_5_0_1= act1_0_5;
  assign act1_5_1_1= act1_1_5;
  assign act1_5_0_2= act1_0_5;
  assign act1_5_1_2= act1_1_5;
  assign act1_5_0_3= act1_0_5;
  assign act1_5_1_3= act1_1_5;
  assign act1_6_0_1= act1_0_6;
  assign act1_6_1_1= act1_1_6;
  assign act1_6_0_2= act1_0_6;
  assign act1_6_1_2= act1_1_6;
  assign act1_6_0_3= act1_0_6;
  assign act1_6_1_3= act1_1_6;
  assign act1_7_0_1= act1_0_7;
  assign act1_7_1_1= act1_1_7;
  assign act1_7_0_2= act1_0_7;
  assign act1_7_1_2= act1_1_7;
  assign act1_7_0_3= act1_0_7;
  assign act1_7_1_3= act1_1_7;
  assign act2_0_0_1= act2_0_0;
  assign act2_0_1_1= act2_1_0;
  assign act2_0_0_2= act2_0_0;
  assign act2_0_1_2= act2_1_0;
  assign act2_0_0_3= act2_0_0;
  assign act2_0_1_3= act2_1_0;
  assign act2_1_0_1= act2_0_1;
  assign act2_1_1_1= act2_1_1;
  assign act2_1_0_2= act2_0_1;
  assign act2_1_1_2= act2_1_1;
  assign act2_1_0_3= act2_0_1;
  assign act2_1_1_3= act2_1_1;
  assign act2_2_0_1= act2_0_2;
  assign act2_2_1_1= act2_1_2;
  assign act2_2_0_2= act2_0_2;
  assign act2_2_1_2= act2_1_2;
  assign act2_2_0_3= act2_0_2;
  assign act2_2_1_3= act2_1_2;
  assign act2_3_0_1= act2_0_3;
  assign act2_3_1_1= act2_1_3;
  assign act2_3_0_2= act2_0_3;
  assign act2_3_1_2= act2_1_3;
  assign act2_3_0_3= act2_0_3;
  assign act2_3_1_3= act2_1_3;
  assign act2_4_0_1= act2_0_4;
  assign act2_4_1_1= act2_1_4;
  assign act2_4_0_2= act2_0_4;
  assign act2_4_1_2= act2_1_4;
  assign act2_4_0_3= act2_0_4;
  assign act2_4_1_3= act2_1_4;
  assign act2_5_0_1= act2_0_5;
  assign act2_5_1_1= act2_1_5;
  assign act2_5_0_2= act2_0_5;
  assign act2_5_1_2= act2_1_5;
  assign act2_5_0_3= act2_0_5;
  assign act2_5_1_3= act2_1_5;
  assign act2_6_0_1= act2_0_6;
  assign act2_6_1_1= act2_1_6;
  assign act2_6_0_2= act2_0_6;
  assign act2_6_1_2= act2_1_6;
  assign act2_6_0_3= act2_0_6;
  assign act2_6_1_3= act2_1_6;
  assign act2_7_0_1= act2_0_7;
  assign act2_7_1_1= act2_1_7;
  assign act2_7_0_2= act2_0_7;
  assign act2_7_1_2= act2_1_7;
  assign act2_7_0_3= act2_0_7;
  assign act2_7_1_3= act2_1_7;
  assign act3_0_0_1= act3_0_0;
  assign act3_0_1_1= act3_1_0;
  assign act3_0_0_2= act3_0_0;
  assign act3_0_1_2= act3_1_0;
  assign act3_0_0_3= act3_0_0;
  assign act3_0_1_3= act3_1_0;
  assign act3_1_0_1= act3_0_1;
  assign act3_1_1_1= act3_1_1;
  assign act3_1_0_2= act3_0_1;
  assign act3_1_1_2= act3_1_1;
  assign act3_1_0_3= act3_0_1;
  assign act3_1_1_3= act3_1_1;
  assign act3_2_0_1= act3_0_2;
  assign act3_2_1_1= act3_1_2;
  assign act3_2_0_2= act3_0_2;
  assign act3_2_1_2= act3_1_2;
  assign act3_2_0_3= act3_0_2;
  assign act3_2_1_3= act3_1_2;
  assign act3_3_0_1= act3_0_3;
  assign act3_3_1_1= act3_1_3;
  assign act3_3_0_2= act3_0_3;
  assign act3_3_1_2= act3_1_3;
  assign act3_3_0_3= act3_0_3;
  assign act3_3_1_3= act3_1_3;
  assign act3_4_0_1= act3_0_4;
  assign act3_4_1_1= act3_1_4;
  assign act3_4_0_2= act3_0_4;
  assign act3_4_1_2= act3_1_4;
  assign act3_4_0_3= act3_0_4;
  assign act3_4_1_3= act3_1_4;
  assign act3_5_0_1= act3_0_5;
  assign act3_5_1_1= act3_1_5;
  assign act3_5_0_2= act3_0_5;
  assign act3_5_1_2= act3_1_5;
  assign act3_5_0_3= act3_0_5;
  assign act3_5_1_3= act3_1_5;
  assign act3_6_0_1= act3_0_6;
  assign act3_6_1_1= act3_1_6;
  assign act3_6_0_2= act3_0_6;
  assign act3_6_1_2= act3_1_6;
  assign act3_6_0_3= act3_0_6;
  assign act3_6_1_3= act3_1_6;
  assign act3_7_0_1= act3_0_7;
  assign act3_7_1_1= act3_1_7;
  assign act3_7_0_2= act3_0_7;
  assign act3_7_1_2= act3_1_7;
  assign act3_7_0_3= act3_0_7;
  assign act3_7_1_3= act3_1_7;
 
  // weighted_inputs modules
  weighted_inputs_1 w1_0    (.inputs(inputs0_1), .w(w1_0_1[0]), .wi(weighted_inputs1_0_0));
  weighted_inputs_1 w1_0_bar(.inputs(inputs0_1), .w(w1_1_1[0]), .wi(weighted_inputs1_0_1));
  weighted_inputs_1 w1_1    (.inputs(inputs1_1), .w(w1_0_1[1]), .wi(weighted_inputs1_1_0));
  weighted_inputs_1 w1_1_bar(.inputs(inputs1_1), .w(w1_1_1[1]), .wi(weighted_inputs1_1_1));
  weighted_inputs_1 w1_2    (.inputs(inputs2_1), .w(w1_0_1[2]), .wi(weighted_inputs1_2_0));
  weighted_inputs_1 w1_2_bar(.inputs(inputs2_1), .w(w1_1_1[2]), .wi(weighted_inputs1_2_1));
  weighted_inputs_1 w1_3    (.inputs(inputs3_1), .w(w1_0_1[3]), .wi(weighted_inputs1_3_0));
  weighted_inputs_1 w1_3_bar(.inputs(inputs3_1), .w(w1_1_1[3]), .wi(weighted_inputs1_3_1));
  weighted_inputs_1 w1_4    (.inputs(inputs4_1), .w(w1_0_1[4]), .wi(weighted_inputs1_4_0));
  weighted_inputs_1 w1_4_bar(.inputs(inputs4_1), .w(w1_1_1[4]), .wi(weighted_inputs1_4_1));
  weighted_inputs_1 w1_5    (.inputs(inputs5_1), .w(w1_0_1[5]), .wi(weighted_inputs1_5_0));
  weighted_inputs_1 w1_5_bar(.inputs(inputs5_1), .w(w1_1_1[5]), .wi(weighted_inputs1_5_1));
  weighted_inputs_1 w1_6    (.inputs(inputs6_1), .w(w1_0_1[6]), .wi(weighted_inputs1_6_0));
  weighted_inputs_1 w1_6_bar(.inputs(inputs6_1), .w(w1_1_1[6]), .wi(weighted_inputs1_6_1));
  weighted_inputs_1 w1_7    (.inputs(inputs7_1), .w(w1_0_1[7]), .wi(weighted_inputs1_7_0));
  weighted_inputs_1 w1_7_bar(.inputs(inputs7_1), .w(w1_1_1[7]), .wi(weighted_inputs1_7_1));
  weighted_inputs_1 w2_0    (.inputs(inputs0_1), .w(w2_0_1[0]), .wi(weighted_inputs2_0_0));
  weighted_inputs_1 w2_0_bar(.inputs(inputs0_1), .w(w2_1_1[0]), .wi(weighted_inputs2_0_1));
  weighted_inputs_1 w2_1    (.inputs(inputs1_1), .w(w2_0_1[1]), .wi(weighted_inputs2_1_0));
  weighted_inputs_1 w2_1_bar(.inputs(inputs1_1), .w(w2_1_1[1]), .wi(weighted_inputs2_1_1));
  weighted_inputs_1 w2_2    (.inputs(inputs2_1), .w(w2_0_1[2]), .wi(weighted_inputs2_2_0));
  weighted_inputs_1 w2_2_bar(.inputs(inputs2_1), .w(w2_1_1[2]), .wi(weighted_inputs2_2_1));
  weighted_inputs_1 w2_3    (.inputs(inputs3_1), .w(w2_0_1[3]), .wi(weighted_inputs2_3_0));
  weighted_inputs_1 w2_3_bar(.inputs(inputs3_1), .w(w2_1_1[3]), .wi(weighted_inputs2_3_1));
  weighted_inputs_1 w2_4    (.inputs(inputs4_1), .w(w2_0_1[4]), .wi(weighted_inputs2_4_0));
  weighted_inputs_1 w2_4_bar(.inputs(inputs4_1), .w(w2_1_1[4]), .wi(weighted_inputs2_4_1));
  weighted_inputs_1 w2_5    (.inputs(inputs5_1), .w(w2_0_1[5]), .wi(weighted_inputs2_5_0));
  weighted_inputs_1 w2_5_bar(.inputs(inputs5_1), .w(w2_1_1[5]), .wi(weighted_inputs2_5_1));
  weighted_inputs_1 w2_6    (.inputs(inputs6_1), .w(w2_0_1[6]), .wi(weighted_inputs2_6_0));
  weighted_inputs_1 w2_6_bar(.inputs(inputs6_1), .w(w2_1_1[6]), .wi(weighted_inputs2_6_1));
  weighted_inputs_1 w2_7    (.inputs(inputs7_1), .w(w2_0_1[7]), .wi(weighted_inputs2_7_0));
  weighted_inputs_1 w2_7_bar(.inputs(inputs7_1), .w(w2_1_1[7]), .wi(weighted_inputs2_7_1));
  weighted_inputs_1 w3_0    (.inputs(inputs0_1), .w(w3_0_1[0]), .wi(weighted_inputs3_0_0));
  weighted_inputs_1 w3_0_bar(.inputs(inputs0_1), .w(w3_1_1[0]), .wi(weighted_inputs3_0_1));
  weighted_inputs_1 w3_1    (.inputs(inputs1_1), .w(w3_0_1[1]), .wi(weighted_inputs3_1_0));
  weighted_inputs_1 w3_1_bar(.inputs(inputs1_1), .w(w3_1_1[1]), .wi(weighted_inputs3_1_1));
  weighted_inputs_1 w3_2    (.inputs(inputs2_1), .w(w3_0_1[2]), .wi(weighted_inputs3_2_0));
  weighted_inputs_1 w3_2_bar(.inputs(inputs2_1), .w(w3_1_1[2]), .wi(weighted_inputs3_2_1));
  weighted_inputs_1 w3_3    (.inputs(inputs3_1), .w(w3_0_1[3]), .wi(weighted_inputs3_3_0));
  weighted_inputs_1 w3_3_bar(.inputs(inputs3_1), .w(w3_1_1[3]), .wi(weighted_inputs3_3_1));
  weighted_inputs_1 w3_4    (.inputs(inputs4_1), .w(w3_0_1[4]), .wi(weighted_inputs3_4_0));
  weighted_inputs_1 w3_4_bar(.inputs(inputs4_1), .w(w3_1_1[4]), .wi(weighted_inputs3_4_1));
  weighted_inputs_1 w3_5    (.inputs(inputs5_1), .w(w3_0_1[5]), .wi(weighted_inputs3_5_0));
  weighted_inputs_1 w3_5_bar(.inputs(inputs5_1), .w(w3_1_1[5]), .wi(weighted_inputs3_5_1));
  weighted_inputs_1 w3_6    (.inputs(inputs6_1), .w(w3_0_1[6]), .wi(weighted_inputs3_6_0));
  weighted_inputs_1 w3_6_bar(.inputs(inputs6_1), .w(w3_1_1[6]), .wi(weighted_inputs3_6_1));
  weighted_inputs_1 w3_7    (.inputs(inputs7_1), .w(w3_0_1[7]), .wi(weighted_inputs3_7_0));
  weighted_inputs_1 w3_7_bar(.inputs(inputs7_1), .w(w3_1_1[7]), .wi(weighted_inputs3_7_1));
  weighted_inputs_1 w4_0    (.inputs(inputs0_1), .w(w4_0_1[0]), .wi(weighted_inputs4_0_0));
  weighted_inputs_1 w4_0_bar(.inputs(inputs0_1), .w(w4_1_1[0]), .wi(weighted_inputs4_0_1));
  weighted_inputs_1 w4_1    (.inputs(inputs1_1), .w(w4_0_1[1]), .wi(weighted_inputs4_1_0));
  weighted_inputs_1 w4_1_bar(.inputs(inputs1_1), .w(w4_1_1[1]), .wi(weighted_inputs4_1_1));
  weighted_inputs_1 w4_2    (.inputs(inputs2_1), .w(w4_0_1[2]), .wi(weighted_inputs4_2_0));
  weighted_inputs_1 w4_2_bar(.inputs(inputs2_1), .w(w4_1_1[2]), .wi(weighted_inputs4_2_1));
  weighted_inputs_1 w4_3    (.inputs(inputs3_1), .w(w4_0_1[3]), .wi(weighted_inputs4_3_0));
  weighted_inputs_1 w4_3_bar(.inputs(inputs3_1), .w(w4_1_1[3]), .wi(weighted_inputs4_3_1));
  weighted_inputs_1 w4_4    (.inputs(inputs4_1), .w(w4_0_1[4]), .wi(weighted_inputs4_4_0));
  weighted_inputs_1 w4_4_bar(.inputs(inputs4_1), .w(w4_1_1[4]), .wi(weighted_inputs4_4_1));
  weighted_inputs_1 w4_5    (.inputs(inputs5_1), .w(w4_0_1[5]), .wi(weighted_inputs4_5_0));
  weighted_inputs_1 w4_5_bar(.inputs(inputs5_1), .w(w4_1_1[5]), .wi(weighted_inputs4_5_1));
  weighted_inputs_1 w4_6    (.inputs(inputs6_1), .w(w4_0_1[6]), .wi(weighted_inputs4_6_0));
  weighted_inputs_1 w4_6_bar(.inputs(inputs6_1), .w(w4_1_1[6]), .wi(weighted_inputs4_6_1));
  weighted_inputs_1 w4_7    (.inputs(inputs7_1), .w(w4_0_1[7]), .wi(weighted_inputs4_7_0));
  weighted_inputs_1 w4_7_bar(.inputs(inputs7_1), .w(w4_1_1[7]), .wi(weighted_inputs4_7_1));
 
  // adder trees for sum1 and sum1bar
  mux_2 m1 (.a(weighted_inputs1_0_0), .b(act0_0_0_1), .c(act0_0_0_2), .d(act0_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_0_0));
  mux_2 m2 (.a(weighted_inputs1_1_0), .b(act0_1_0_1), .c(act0_1_0_2), .d(act0_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_1_0));
  mux_2 m3 (.a(weighted_inputs1_2_0), .b(act0_2_0_1), .c(act0_2_0_2), .d(act0_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_2_0));
  mux_2 m4 (.a(weighted_inputs1_3_0), .b(act0_3_0_1), .c(act0_3_0_2), .d(act0_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_3_0));
  mux_2 m5 (.a(weighted_inputs1_4_0), .b(act0_4_0_1), .c(act0_4_0_2), .d(act0_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_4_0));
  mux_2 m6 (.a(weighted_inputs1_5_0), .b(act0_5_0_1), .c(act0_5_0_2), .d(act0_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_5_0));
  mux_2 m7 (.a(weighted_inputs1_6_0), .b(act0_6_0_1), .c(act0_6_0_2), .d(act0_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_6_0));
  mux_2 m8 (.a(weighted_inputs1_7_0), .b(act0_7_0_1), .c(act0_7_0_2), .d(act0_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_7_0));
  adder_tree add0 (
    .clk(clk),
    .in0(new_weighted_inputs1_0_0),
    .in1(new_weighted_inputs1_1_0),
    .in2(new_weighted_inputs1_2_0),
    .in3(new_weighted_inputs1_3_0),
    .in4(new_weighted_inputs1_4_0),
    .in5(new_weighted_inputs1_5_0),
    .in6(new_weighted_inputs1_6_0),
    .in7(new_weighted_inputs1_7_0),
    .sum(sum1[0])
  );
  adder_tree_bar addb0 (
    .clk(clk),
    .in0(new_weighted_inputs1_0_0),
    .in1(new_weighted_inputs1_1_0),
    .in2(new_weighted_inputs1_2_0),
    .in3(new_weighted_inputs1_3_0),
    .in4(new_weighted_inputs1_4_0),
    .in5(new_weighted_inputs1_5_0),
    .in6(new_weighted_inputs1_6_0),
    .in7(new_weighted_inputs1_7_0),
    .sum(sum1bar[0])
  );

  mux_2 m9 (.a(weighted_inputs2_0_0), .b(act1_0_0_1), .c(act1_0_0_2), .d(act1_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_0_0));
  mux_2 m10 (.a(weighted_inputs2_1_0), .b(act1_1_0_1), .c(act1_1_0_2), .d(act1_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_1_0));
  mux_2 m11 (.a(weighted_inputs2_2_0), .b(act1_2_0_1), .c(act1_2_0_2), .d(act1_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_2_0));
  mux_2 m12 (.a(weighted_inputs2_3_0), .b(act1_3_0_1), .c(act1_3_0_2), .d(act1_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_3_0));
  mux_2 m13 (.a(weighted_inputs2_4_0), .b(act1_4_0_1), .c(act1_4_0_2), .d(act1_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_4_0));
  mux_2 m14 (.a(weighted_inputs2_5_0), .b(act1_5_0_1), .c(act1_5_0_2), .d(act1_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_5_0));
  mux_2 m15 (.a(weighted_inputs2_6_0), .b(act1_6_0_1), .c(act1_6_0_2), .d(act1_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_6_0));
  mux_2 m16 (.a(weighted_inputs2_7_0), .b(act1_7_0_1), .c(act1_7_0_2), .d(act1_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_7_0));
  adder_tree add1 (
    .clk(clk),
    .in0(new_weighted_inputs2_0_0),
    .in1(new_weighted_inputs2_1_0),
    .in2(new_weighted_inputs2_2_0),
    .in3(new_weighted_inputs2_3_0),
    .in4(new_weighted_inputs2_4_0),
    .in5(new_weighted_inputs2_5_0),
    .in6(new_weighted_inputs2_6_0),
    .in7(new_weighted_inputs2_7_0),
    .sum(sum1[1])
  );
  adder_tree_bar addb1 (
    .clk(clk),
    .in0(new_weighted_inputs2_0_0),
    .in1(new_weighted_inputs2_1_0),
    .in2(new_weighted_inputs2_2_0),
    .in3(new_weighted_inputs2_3_0),
    .in4(new_weighted_inputs2_4_0),
    .in5(new_weighted_inputs2_5_0),
    .in6(new_weighted_inputs2_6_0),
    .in7(new_weighted_inputs2_7_0),
    .sum(sum1bar[1])
  );

  mux_2 m17 (.a(weighted_inputs3_0_0), .b(act2_0_0_1), .c(act2_0_0_2), .d(act2_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_0_0));
  mux_2 m18 (.a(weighted_inputs3_1_0), .b(act2_1_0_1), .c(act2_1_0_2), .d(act2_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_1_0));
  mux_2 m19 (.a(weighted_inputs3_2_0), .b(act2_2_0_1), .c(act2_2_0_2), .d(act2_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_2_0));
  mux_2 m20 (.a(weighted_inputs3_3_0), .b(act2_3_0_1), .c(act2_3_0_2), .d(act2_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_3_0));
  mux_2 m21 (.a(weighted_inputs3_4_0), .b(act2_4_0_1), .c(act2_4_0_2), .d(act2_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_4_0));
  mux_2 m22 (.a(weighted_inputs3_5_0), .b(act2_5_0_1), .c(act2_5_0_2), .d(act2_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_5_0));
  mux_2 m23 (.a(weighted_inputs3_6_0), .b(act2_6_0_1), .c(act2_6_0_2), .d(act2_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_6_0));
  mux_2 m24 (.a(weighted_inputs3_7_0), .b(act2_7_0_1), .c(act2_7_0_2), .d(act2_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_7_0));
  adder_tree add2 (
    .clk(clk),
    .in0(new_weighted_inputs3_0_0),
    .in1(new_weighted_inputs3_1_0),
    .in2(new_weighted_inputs3_2_0),
    .in3(new_weighted_inputs3_3_0),
    .in4(new_weighted_inputs3_4_0),
    .in5(new_weighted_inputs3_5_0),
    .in6(new_weighted_inputs3_6_0),
    .in7(new_weighted_inputs3_7_0),
    .sum(sum1[2])
  );
  adder_tree_bar addb2 (
    .clk(clk),
    .in0(new_weighted_inputs3_0_0),
    .in1(new_weighted_inputs3_1_0),
    .in2(new_weighted_inputs3_2_0),
    .in3(new_weighted_inputs3_3_0),
    .in4(new_weighted_inputs3_4_0),
    .in5(new_weighted_inputs3_5_0),
    .in6(new_weighted_inputs3_6_0),
    .in7(new_weighted_inputs3_7_0),
    .sum(sum1bar[2])
  );

  mux_2 m25 (.a(weighted_inputs4_0_0), .b(act3_0_0_1), .c(act3_0_0_2), .d(act3_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_0_0));
  mux_2 m26 (.a(weighted_inputs4_1_0), .b(act3_1_0_1), .c(act3_1_0_2), .d(act3_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_1_0));
  mux_2 m27 (.a(weighted_inputs4_2_0), .b(act3_2_0_1), .c(act3_2_0_2), .d(act3_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_2_0));
  mux_2 m28 (.a(weighted_inputs4_3_0), .b(act3_3_0_1), .c(act3_3_0_2), .d(act3_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_3_0));
  mux_2 m29 (.a(weighted_inputs4_4_0), .b(act3_4_0_1), .c(act3_4_0_2), .d(act3_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_4_0));
  mux_2 m30 (.a(weighted_inputs4_5_0), .b(act3_5_0_1), .c(act3_5_0_2), .d(act3_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_5_0));
  mux_2 m31 (.a(weighted_inputs4_6_0), .b(act3_6_0_1), .c(act3_6_0_2), .d(act3_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_6_0));
  mux_2 m32 (.a(weighted_inputs4_7_0), .b(act3_7_0_1), .c(act3_7_0_2), .d(act3_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_7_0));
  adder_tree add3 (
    .clk(clk),
    .in0(new_weighted_inputs4_0_0),
    .in1(new_weighted_inputs4_1_0),
    .in2(new_weighted_inputs4_2_0),
    .in3(new_weighted_inputs4_3_0),
    .in4(new_weighted_inputs4_4_0),
    .in5(new_weighted_inputs4_5_0),
    .in6(new_weighted_inputs4_6_0),
    .in7(new_weighted_inputs4_7_0),
    .sum(sum1[3])
  );
  adder_tree_bar addb3 (
    .clk(clk),
    .in0(new_weighted_inputs4_0_0),
    .in1(new_weighted_inputs4_1_0),
    .in2(new_weighted_inputs4_2_0),
    .in3(new_weighted_inputs4_3_0),
    .in4(new_weighted_inputs4_4_0),
    .in5(new_weighted_inputs4_5_0),
    .in6(new_weighted_inputs4_6_0),
    .in7(new_weighted_inputs4_7_0),
    .sum(sum1bar[3])
  );

  // adder trees for sum2 and sum2bar
  mux_2 m33 (.a(weighted_inputs1_0_1), .b(act0_0_1_1), .c(act0_0_1_2), .d(act0_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_0_1));
  mux_2 m34 (.a(weighted_inputs1_1_1), .b(act0_1_1_1), .c(act0_1_1_2), .d(act0_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_1_1));
  mux_2 m35 (.a(weighted_inputs1_2_1), .b(act0_2_1_1), .c(act0_2_1_2), .d(act0_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_2_1));
  mux_2 m36 (.a(weighted_inputs1_3_1), .b(act0_3_1_1), .c(act0_3_1_2), .d(act0_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_3_1));
  mux_2 m37 (.a(weighted_inputs1_4_1), .b(act0_4_1_1), .c(act0_4_1_2), .d(act0_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_4_1));
  mux_2 m38 (.a(weighted_inputs1_5_1), .b(act0_5_1_1), .c(act0_5_1_2), .d(act0_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_5_1));
  mux_2 m39 (.a(weighted_inputs1_6_1), .b(act0_6_1_1), .c(act0_6_1_2), .d(act0_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_6_1));
  mux_2 m40 (.a(weighted_inputs1_7_1), .b(act0_7_1_1), .c(act0_7_1_2), .d(act0_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_7_1));
  adder_tree add4 (
    .clk(clk),
    .in0(new_weighted_inputs1_0_1),
    .in1(new_weighted_inputs1_1_1),
    .in2(new_weighted_inputs1_2_1),
    .in3(new_weighted_inputs1_3_1),
    .in4(new_weighted_inputs1_4_1),
    .in5(new_weighted_inputs1_5_1),
    .in6(new_weighted_inputs1_6_1),
    .in7(new_weighted_inputs1_7_1),
    .sum(sum2[0])
  );
  adder_tree_bar addb4 (
    .clk(clk),
    .in0(new_weighted_inputs1_0_1),
    .in1(new_weighted_inputs1_1_1),
    .in2(new_weighted_inputs1_2_1),
    .in3(new_weighted_inputs1_3_1),
    .in4(new_weighted_inputs1_4_1),
    .in5(new_weighted_inputs1_5_1),
    .in6(new_weighted_inputs1_6_1),
    .in7(new_weighted_inputs1_7_1),
    .sum(sum2bar[0])
  );

  mux_2 m41 (.a(weighted_inputs2_0_1), .b(act1_0_1_1), .c(act1_0_1_2), .d(act1_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_0_1));
  mux_2 m42 (.a(weighted_inputs2_1_1), .b(act1_1_1_1), .c(act1_1_1_2), .d(act1_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_1_1));
  mux_2 m43 (.a(weighted_inputs2_2_1), .b(act1_2_1_1), .c(act1_2_1_2), .d(act1_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_2_1));
  mux_2 m44 (.a(weighted_inputs2_3_1), .b(act1_3_1_1), .c(act1_3_1_2), .d(act1_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_3_1));
  mux_2 m45 (.a(weighted_inputs2_4_1), .b(act1_4_1_1), .c(act1_4_1_2), .d(act1_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_4_1));
  mux_2 m46 (.a(weighted_inputs2_5_1), .b(act1_5_1_1), .c(act1_5_1_2), .d(act1_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_5_1));
  mux_2 m47 (.a(weighted_inputs2_6_1), .b(act1_6_1_1), .c(act1_6_1_2), .d(act1_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_6_1));
  mux_2 m48 (.a(weighted_inputs2_7_1), .b(act1_7_1_1), .c(act1_7_1_2), .d(act1_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_7_1));
  adder_tree add5 (
    .clk(clk),
    .in0(new_weighted_inputs2_0_1),
    .in1(new_weighted_inputs2_1_1),
    .in2(new_weighted_inputs2_2_1),
    .in3(new_weighted_inputs2_3_1),
    .in4(new_weighted_inputs2_4_1),
    .in5(new_weighted_inputs2_5_1),
    .in6(new_weighted_inputs2_6_1),
    .in7(new_weighted_inputs2_7_1),
    .sum(sum2[1])
  );
  adder_tree_bar addb5 (
    .clk(clk),
    .in0(new_weighted_inputs2_0_1),
    .in1(new_weighted_inputs2_1_1),
    .in2(new_weighted_inputs2_2_1),
    .in3(new_weighted_inputs2_3_1),
    .in4(new_weighted_inputs2_4_1),
    .in5(new_weighted_inputs2_5_1),
    .in6(new_weighted_inputs2_6_1),
    .in7(new_weighted_inputs2_7_1),
    .sum(sum2bar[1])
  );

  mux_2 m49 (.a(weighted_inputs3_0_1), .b(act2_0_1_1), .c(act2_0_1_2), .d(act2_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_0_1));
  mux_2 m50 (.a(weighted_inputs3_1_1), .b(act2_1_1_1), .c(act2_1_1_2), .d(act2_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_1_1));
  mux_2 m51 (.a(weighted_inputs3_2_1), .b(act2_2_1_1), .c(act2_2_1_2), .d(act2_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_2_1));
  mux_2 m52 (.a(weighted_inputs3_3_1), .b(act2_3_1_1), .c(act2_3_1_2), .d(act2_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_3_1));
  mux_2 m53 (.a(weighted_inputs3_4_1), .b(act2_4_1_1), .c(act2_4_1_2), .d(act2_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_4_1));
  mux_2 m54 (.a(weighted_inputs3_5_1), .b(act2_5_1_1), .c(act2_5_1_2), .d(act2_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_5_1));
  mux_2 m55 (.a(weighted_inputs3_6_1), .b(act2_6_1_1), .c(act2_6_1_2), .d(act2_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_6_1));
  mux_2 m56 (.a(weighted_inputs3_7_1), .b(act2_7_1_1), .c(act2_7_1_2), .d(act2_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_7_1));
  adder_tree add6 (
    .clk(clk),
    .in0(new_weighted_inputs3_0_1),
    .in1(new_weighted_inputs3_1_1),
    .in2(new_weighted_inputs3_2_1),
    .in3(new_weighted_inputs3_3_1),
    .in4(new_weighted_inputs3_4_1),
    .in5(new_weighted_inputs3_5_1),
    .in6(new_weighted_inputs3_6_1),
    .in7(new_weighted_inputs3_7_1),
    .sum(sum2[2])
  );
  adder_tree_bar addb6 (
    .clk(clk),
    .in0(new_weighted_inputs3_0_1),
    .in1(new_weighted_inputs3_1_1),
    .in2(new_weighted_inputs3_2_1),
    .in3(new_weighted_inputs3_3_1),
    .in4(new_weighted_inputs3_4_1),
    .in5(new_weighted_inputs3_5_1),
    .in6(new_weighted_inputs3_6_1),
    .in7(new_weighted_inputs3_7_1),
    .sum(sum2bar[2])
  );

  mux_2 m57 (.a(weighted_inputs4_0_1), .b(act3_0_1_1), .c(act3_0_1_2), .d(act3_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_0_1));
  mux_2 m58 (.a(weighted_inputs4_1_1), .b(act3_1_1_1), .c(act3_1_1_2), .d(act3_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_1_1));
  mux_2 m59 (.a(weighted_inputs4_2_1), .b(act3_2_1_1), .c(act3_2_1_2), .d(act3_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_2_1));
  mux_2 m60 (.a(weighted_inputs4_3_1), .b(act3_3_1_1), .c(act3_3_1_2), .d(act3_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_3_1));
  mux_2 m61 (.a(weighted_inputs4_4_1), .b(act3_4_1_1), .c(act3_4_1_2), .d(act3_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_4_1));
  mux_2 m62 (.a(weighted_inputs4_5_1), .b(act3_5_1_1), .c(act3_5_1_2), .d(act3_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_5_1));
  mux_2 m63 (.a(weighted_inputs4_6_1), .b(act3_6_1_1), .c(act3_6_1_2), .d(act3_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_6_1));
  mux_2 m64 (.a(weighted_inputs4_7_1), .b(act3_7_1_1), .c(act3_7_1_2), .d(act3_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_7_1));
  adder_tree add7 (
    .clk(clk),
    .in0(new_weighted_inputs4_0_1),
    .in1(new_weighted_inputs4_1_1),
    .in2(new_weighted_inputs4_2_1),
    .in3(new_weighted_inputs4_3_1),
    .in4(new_weighted_inputs4_4_1),
    .in5(new_weighted_inputs4_5_1),
    .in6(new_weighted_inputs4_6_1),
    .in7(new_weighted_inputs4_7_1),
    .sum(sum2[3])
  );
  adder_tree_bar addb7 (
    .clk(clk),
    .in0(new_weighted_inputs4_0_1),
    .in1(new_weighted_inputs4_1_1),
    .in2(new_weighted_inputs4_2_1),
    .in3(new_weighted_inputs4_3_1),
    .in4(new_weighted_inputs4_4_1),
    .in5(new_weighted_inputs4_5_1),
    .in6(new_weighted_inputs4_6_1),
    .in7(new_weighted_inputs4_7_1),
    .sum(sum2bar[3])
  );

  wire [10:0] b1;
  wire [10:0] b2;
  wire [10:0] b3;
  wire [10:0] b4;

  mux_5 mux0  (.a(b1_1), .b(b1_2), .c(b1_3), .d(b1_4), .s0(s[0]), .s1(s[1]), .y(b1));
  mux_5 mux1  (.a(b2_1), .b(b2_2), .c(b2_3), .d(b2_4), .s0(s[0]), .s1(s[1]), .y(b2));
  mux_5 mux2  (.a(b3_1), .b(b3_2), .c(b3_3), .d(b3_4), .s0(s[0]), .s1(s[1]), .y(b3));
  mux_5 mux3  (.a(b4_1), .b(b4_2), .c(b4_3), .d(b4_4), .s0(s[0]), .s1(s[1]), .y(b4));

  // bias addition
  add11bit     u0  (.a(sum1[0]),     .b(b1), .cin(1'b0), .y(biased_sum1[0]));
  add11bitbar ub0 (.a(sum1bar[0]), .b(b1), .cin(1'b0), .y(biased_sum1bar[0]));
  add11bit     u4  (.a(sum2[0]),     .b(b1), .cin(1'b0), .y(biased_sum2[0]));
  add11bitbar ub4 (.a(sum2bar[0]), .b(b1), .cin(1'b0), .y(biased_sum2bar[0]));
  add11bit     u1  (.a(sum1[1]),     .b(b2), .cin(1'b0), .y(biased_sum1[1]));
  add11bitbar ub1 (.a(sum1bar[1]), .b(b2), .cin(1'b0), .y(biased_sum1bar[1]));
  add11bit     u5  (.a(sum2[1]),     .b(b2), .cin(1'b0), .y(biased_sum2[1]));
  add11bitbar ub5 (.a(sum2bar[1]), .b(b2), .cin(1'b0), .y(biased_sum2bar[1]));
  add11bit     u2  (.a(sum1[2]),     .b(b3), .cin(1'b0), .y(biased_sum1[2]));
  add11bitbar ub2 (.a(sum1bar[2]), .b(b3), .cin(1'b0), .y(biased_sum1bar[2]));
  add11bit     u6  (.a(sum2[2]),     .b(b3), .cin(1'b0), .y(biased_sum2[2]));
  add11bitbar ub6 (.a(sum2bar[2]), .b(b3), .cin(1'b0), .y(biased_sum2bar[2]));
  add11bit     u3  (.a(sum1[3]),     .b(b4), .cin(1'b0), .y(biased_sum1[3]));
  add11bitbar ub3 (.a(sum1bar[3]), .b(b4), .cin(1'b0), .y(biased_sum1bar[3]));
  add11bit     u7  (.a(sum2[3]),     .b(b4), .cin(1'b0), .y(biased_sum2[3]));
  add11bitbar ub7 (.a(sum2bar[3]), .b(b4), .cin(1'b0), .y(biased_sum2bar[3]));

    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum0_1 = biased_sum2[0];
    assign biased_sum0_0bar = biased_sum1bar[0];
    assign biased_sum0_1bar = biased_sum2bar[0];

    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum1_1 = biased_sum2[1];
    assign biased_sum1_0bar = biased_sum1bar[1];
    assign biased_sum1_1bar = biased_sum2bar[1];

    assign biased_sum2_0 = biased_sum1[2];
    assign biased_sum2_1 = biased_sum2[2];
    assign biased_sum2_0bar = biased_sum1bar[2];
    assign biased_sum2_1bar = biased_sum2bar[2];

    assign biased_sum3_0 = biased_sum1[3];
    assign biased_sum3_1 = biased_sum2[3];
    assign biased_sum3_0bar = biased_sum1bar[3];
    assign biased_sum3_1bar = biased_sum2bar[3];


  always @(posedge clk) begin
    $display("----- BNN LAYER  OUTPUTS -----");
    $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
    $display("sum2: %b %b %b %b", sum2[0], sum2[1], sum2[2], sum2[3]);
    $display("sum1bar: %b %b %b %b", sum1bar[0], sum1bar[1], sum1bar[2], sum1bar[3]);
    $display("sum2bar: %b %b %b %b", sum2bar[0], sum2bar[1], sum2bar[2], sum2bar[3]);
    $display("bias values: %b %b %b %b", b1, b2, b3, b4);
    $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
    $display("biased_sum2: %b %b %b %b", biased_sum2[0], biased_sum2[1], biased_sum2[2], biased_sum2[3]);
    $display("biased_sum1bar: %b %b %b %b", biased_sum1bar[0], biased_sum1bar[1], biased_sum1bar[2], biased_sum1bar[3]);
    $display("biased_sum2bar: %b %b %b %b", biased_sum2bar[0], biased_sum2bar[1], biased_sum2bar[2], biased_sum2bar[3]);
  end

  reg r0_0;
  reg r1_0;
  reg r2_0;
  reg r3_0;
  reg r4_0;
  reg r5_0;
  reg r6_0;
  reg r7_0;
  reg r8_0;
  reg r9_0;
  reg r10_0;
  reg r11_0;
  reg r0_1;
  reg r1_1;
  reg r2_1;
  reg r3_1;
  reg r4_1;
  reg r5_1;
  reg r6_1;
  reg r7_1;
  reg r8_1;
  reg r9_1;
  reg r10_1;
  reg r11_1;
  reg r0_2;
  reg r1_2;
  reg r2_2;
  reg r3_2;
  reg r4_2;
  reg r5_2;
  reg r6_2;
  reg r7_2;
  reg r8_2;
  reg r9_2;
  reg r10_2;
  reg r11_2;
  reg r0_3;
  reg r1_3;
  reg r2_3;
  reg r3_3;
  reg r4_3;
  reg r5_3;
  reg r6_3;
  reg r7_3;
  reg r8_3;
  reg r9_3;
  reg r10_3;
  reg r11_3;

  initial begin
    r0_0 = $random;
    r1_0 = $random;
    r2_0 = $random;
    r3_0 = $random;
    r4_0 = $random;
    r5_0 = $random;
    r6_0 = $random;
    r7_0 = $random;
    r8_0 = $random;
    r9_0 = $random;
    r10_0 = $random;
    r11_0 = $random;
    r0_1 = $random;
    r1_1 = $random;
    r2_1 = $random;
    r3_1 = $random;
    r4_1 = $random;
    r5_1 = $random;
    r6_1 = $random;
    r7_1 = $random;
    r8_1 = $random;
    r9_1 = $random;
    r10_1 = $random;
    r11_1 = $random;
    r0_2 = $random;
    r1_2 = $random;
    r2_2 = $random;
    r3_2 = $random;
    r4_2 = $random;
    r5_2 = $random;
    r6_2 = $random;
    r7_2 = $random;
    r8_2 = $random;
    r9_2 = $random;
    r10_2 = $random;
    r11_2 = $random;
    r0_3 = $random;
    r1_3 = $random;
    r2_3 = $random;
    r3_3 = $random;
    r4_3 = $random;
    r5_3 = $random;
    r6_3 = $random;
    r7_3 = $random;
    r8_3 = $random;
    r9_3 = $random;
    r10_3 = $random;
    r11_3 = $random;
    #1;
  end

  activation_array_1 act1 (
    .inputs0_0(biased_sum0_0),
    .inputs0_1(biased_sum0_1),
    .inputs1_0(biased_sum1_0),
    .inputs1_1(biased_sum1_1),
    .inputs2_0(biased_sum2_0),
    .inputs2_1(biased_sum2_1),
    .inputs3_0(biased_sum3_0),
    .inputs3_1(biased_sum3_1),
    .r0_0(r0_0),
    .r1_0(r1_0),
    .r2_0(r2_0),
    .r3_0(r3_0),
    .r4_0(r4_0),
    .r5_0(r5_0),
    .r6_0(r6_0),
    .r7_0(r7_0),
    .r8_0(r8_0),
    .r9_0(r9_0),
    .r10_0(r10_0),
    .r11_0(r11_0),
    .r0_1(r0_1),
    .r1_1(r1_1),
    .r2_1(r2_1),
    .r3_1(r3_1),
    .r4_1(r4_1),
    .r5_1(r5_1),
    .r6_1(r6_1),
    .r7_1(r7_1),
    .r8_1(r8_1),
    .r9_1(r9_1),
    .r10_1(r10_1),
    .r11_1(r11_1),
    .r0_2(r0_2),
    .r1_2(r1_2),
    .r2_2(r2_2),
    .r3_2(r3_2),
    .r4_2(r4_2),
    .r5_2(r5_2),
    .r6_2(r6_2),
    .r7_2(r7_2),
    .r8_2(r8_2),
    .r9_2(r9_2),
    .r10_2(r10_2),
    .r11_2(r11_2),
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r6_3(r6_3),
    .r7_3(r7_3),
    .r8_3(r8_3),
    .r9_3(r9_3),
    .r10_3(r10_3),
    .r11_3(r11_3),
    .masked_activation0(masked_activation0_1),
    .masked_activation1(masked_activation1_1),
    .masked_activation2(masked_activation2_1),
    .masked_activation3(masked_activation3_1),
    .mask0(mask0_1),
    .mask1(mask1_1),
    .mask2(mask2_1),
    .mask3(mask3_1)
  );

  activation_array_1 act2 (
    .inputs0_0(biased_sum0_0bar),
    .inputs0_1(biased_sum0_1bar),
    .inputs1_0(biased_sum1_0bar),
    .inputs1_1(biased_sum1_1bar),
    .inputs2_0(biased_sum2_0bar),
    .inputs2_1(biased_sum2_1bar),
    .inputs3_0(biased_sum3_0bar),
    .inputs3_1(biased_sum3_1bar),
    .r0_0(r0_0),
    .r1_0(r1_0),
    .r2_0(r2_0),
    .r3_0(r3_0),
    .r4_0(r4_0),
    .r5_0(r5_0),
    .r6_0(r6_0),
    .r7_0(r7_0),
    .r8_0(r8_0),
    .r9_0(r9_0),
    .r10_0(r10_0),
    .r11_0(r11_0),
    .r0_1(r0_1),
    .r1_1(r1_1),
    .r2_1(r2_1),
    .r3_1(r3_1),
    .r4_1(r4_1),
    .r5_1(r5_1),
    .r6_1(r6_1),
    .r7_1(r7_1),
    .r8_1(r8_1),
    .r9_1(r9_1),
    .r10_1(r10_1),
    .r11_1(r11_1),
    .r0_2(r0_2),
    .r1_2(r1_2),
    .r2_2(r2_2),
    .r3_2(r3_2),
    .r4_2(r4_2),
    .r5_2(r5_2),
    .r6_2(r6_2),
    .r7_2(r7_2),
    .r8_2(r8_2),
    .r9_2(r9_2),
    .r10_2(r10_2),
    .r11_2(r11_2),
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r6_3(r6_3),
    .r7_3(r7_3),
    .r8_3(r8_3),
    .r9_3(r9_3),
    .r10_3(r10_3),
    .r11_3(r11_3),
    .masked_activation0(masked_activation0bar_1),
    .masked_activation1(masked_activation1bar_1),
    .masked_activation2(masked_activation2bar_1),
    .masked_activation3(masked_activation3bar_1),
    .mask0(mask0bar_1),
    .mask1(mask1bar_1),
    .mask2(mask2bar_1),
    .mask3(mask3bar_1)
  );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done <= 1'b0;
      biased_sum0_0_r    <= 12'd0;  biased_sum0_1_r    <= 12'd0;
      biased_sum0_0bar_r <= 12'd0;  biased_sum0_1bar_r <= 12'd0;
      masked_activation0_1_r <= 1'b0; masked_activation0bar_1_r <= 1'b0;
      mask0_1_r             <= 1'b0;             mask0bar_1_r             <= 1'b0;
      biased_sum1_0_r    <= 12'd0;  biased_sum1_1_r    <= 12'd0;
      biased_sum1_0bar_r <= 12'd0;  biased_sum1_1bar_r <= 12'd0;
      masked_activation1_1_r <= 1'b0; masked_activation1bar_1_r <= 1'b0;
      mask1_1_r             <= 1'b0;             mask1bar_1_r             <= 1'b0;
      biased_sum2_0_r    <= 12'd0;  biased_sum2_1_r    <= 12'd0;
      biased_sum2_0bar_r <= 12'd0;  biased_sum2_1bar_r <= 12'd0;
      masked_activation2_1_r <= 1'b0; masked_activation2bar_1_r <= 1'b0;
      mask2_1_r             <= 1'b0;             mask2bar_1_r             <= 1'b0;
      biased_sum3_0_r    <= 12'd0;  biased_sum3_1_r    <= 12'd0;
      biased_sum3_0bar_r <= 12'd0;  biased_sum3_1bar_r <= 12'd0;
      masked_activation3_1_r <= 1'b0; masked_activation3bar_1_r <= 1'b0;
      mask3_1_r             <= 1'b0;             mask3bar_1_r             <= 1'b0;
    end else if (start) begin
      done <= 1'b1;
      biased_sum0_0_r    <= biased_sum0_0;  biased_sum0_1_r    <= biased_sum0_1;
      biased_sum0_0bar_r <= biased_sum0_0bar;  biased_sum0_1bar_r <= biased_sum0_1bar;
      masked_activation0_1_r <= masked_activation0_1; masked_activation0bar_1_r <= masked_activation0bar_1;
      mask0_1_r             <= mask0_1;             mask0bar_1_r             <= mask0bar_1;
      biased_sum1_0_r    <= biased_sum1_0;  biased_sum1_1_r    <= biased_sum1_1;
      biased_sum1_0bar_r <= biased_sum1_0bar;  biased_sum1_1bar_r <= biased_sum1_1bar;
      masked_activation1_1_r <= masked_activation1_1; masked_activation1bar_1_r <= masked_activation1bar_1;
      mask1_1_r             <= mask1_1;             mask1bar_1_r             <= mask1bar_1;
      biased_sum2_0_r    <= biased_sum2_0;  biased_sum2_1_r    <= biased_sum2_1;
      biased_sum2_0bar_r <= biased_sum2_0bar;  biased_sum2_1bar_r <= biased_sum2_1bar;
      masked_activation2_1_r <= masked_activation2_1; masked_activation2bar_1_r <= masked_activation2bar_1;
      mask2_1_r             <= mask2_1;             mask2bar_1_r             <= mask2bar_1;
      biased_sum3_0_r    <= biased_sum3_0;  biased_sum3_1_r    <= biased_sum3_1;
      biased_sum3_0bar_r <= biased_sum3_0bar;  biased_sum3_1bar_r <= biased_sum3_1bar;
      masked_activation3_1_r <= masked_activation3_1; masked_activation3bar_1_r <= masked_activation3bar_1;
      mask3_1_r             <= mask3_1;             mask3bar_1_r             <= mask3bar_1;
    end else begin
      done <= 1'b0;
    end
  end

endmodule

`timescale 1ns/1ps

module mux (

    input  wire a, b, s,

    output wire y
);

assign y = (~s & a)|(s & b);
endmodule


module boolean_arithmetic_coversion_1 (

    input  wire x0,

    input  wire x1,

    input  wire [6:0] r_mask,

    output wire [7:0] arith_share0,

    output wire [7:0] arith_share1
);

    wire [7:0] y0;

    wire [7:0] y1;


    assign y0 = { r_mask, x0 };

    assign y1 = { r_mask, x1 };


    // stage1 for LSB

    assign arith_share0[0] = y0[0];


    mux m1(.a(y0[1]), .b(y1[0] ^ y0[1]), .s(arith_share0[0]), .y(arith_share0[1]));

    mux m2(.a(y0[1] ^ y0[2]), .b(y0[2] ^ y1[1]), .s(arith_share0[1]), .y(arith_share0[2]));

    mux m3(.a(y0[2] ^ y0[3]), .b(y0[3] ^ y1[2]), .s(arith_share0[2]), .y(arith_share0[3]));

    mux m4(.a(y0[3] ^ y0[4]), .b(y0[4] ^ y1[3]), .s(arith_share0[3]), .y(arith_share0[4]));

    mux m5(.a(y0[4] ^ y0[5]), .b(y0[5] ^ y1[4]), .s(arith_share0[4]), .y(arith_share0[5]));

    mux m6(.a(y0[5] ^ y0[6]), .b(y0[6] ^ y1[5]), .s(arith_share0[5]), .y(arith_share0[6]));

    mux m7(.a(y0[6] ^ y0[7]), .b(y0[7] ^ y1[6]), .s(arith_share0[6]), .y(arith_share0[7]));


    assign arith_share1 = y1;

endmodule

module share_boolean_arithmetic (
    // Handshake
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    output reg         done,

    // Masked-activation & mask inputs
    input  wire        masked_activation0_1,
    input  wire        masked_activation1_1,
    input  wire        masked_activation2_1,
    input  wire        masked_activation3_1,
    input  wire        mask0_1,
    input  wire        mask1_1,
    input  wire        mask2_1,
    input  wire        mask3_1,

    // Weight vectors for the three sub-rounds
    input  wire [7:0]  w1_0_2, w1_1_2, w2_0_2, w2_1_2, w3_0_2, w3_1_2, w4_0_2, w4_1_2,
    input  wire [7:0]  w1_0_3, w1_1_3, w2_0_3, w2_1_3, w3_0_3, w3_1_3, w4_0_3, w4_1_3,
    input  wire [7:0]  w1_0_4, w1_1_4, w2_0_4, w2_1_4, w3_0_4, w3_1_4, w4_0_4, w4_1_4,

    // Selection bits
    input  wire [1:0]  s,

    // Registered arithmetic-shares outputs (_r suffix)
    output reg  [7:0]act0_0_0_r,
    output reg  [7:0]act0_0_1_r,
    output reg  [7:0]act0_0_2_r,
    output reg  [7:0]act0_0_3_r,
    output reg  [7:0]act0_0_4_r,
    output reg  [7:0]act0_0_5_r,
    output reg  [7:0]act0_0_6_r,
    output reg  [7:0]act0_0_7_r,
    output reg  [7:0]act0_1_0_r,
    output reg  [7:0]act0_1_1_r,
    output reg  [7:0]act0_1_2_r,
    output reg  [7:0]act0_1_3_r,
    output reg  [7:0]act0_1_4_r,
    output reg  [7:0]act0_1_5_r,
    output reg  [7:0]act0_1_6_r,
    output reg  [7:0]act0_1_7_r,
    output reg  [7:0]act1_0_0_r,
    output reg  [7:0]act1_0_1_r,
    output reg  [7:0]act1_0_2_r,
    output reg  [7:0]act1_0_3_r,
    output reg  [7:0]act1_0_4_r,
    output reg  [7:0]act1_0_5_r,
    output reg  [7:0]act1_0_6_r,
    output reg  [7:0]act1_0_7_r,
    output reg  [7:0]act1_1_0_r,
    output reg  [7:0]act1_1_1_r,
    output reg  [7:0]act1_1_2_r,
    output reg  [7:0]act1_1_3_r,
    output reg  [7:0]act1_1_4_r,
    output reg  [7:0]act1_1_5_r,
    output reg  [7:0]act1_1_6_r,
    output reg  [7:0]act1_1_7_r,
    output reg  [7:0]act2_0_0_r,
    output reg  [7:0]act2_0_1_r,
    output reg  [7:0]act2_0_2_r,
    output reg  [7:0]act2_0_3_r,
    output reg  [7:0]act2_0_4_r,
    output reg  [7:0]act2_0_5_r,
    output reg  [7:0]act2_0_6_r,
    output reg  [7:0]act2_0_7_r,
    output reg  [7:0]act2_1_0_r,
    output reg  [7:0]act2_1_1_r,
    output reg  [7:0]act2_1_2_r,
    output reg  [7:0]act2_1_3_r,
    output reg  [7:0]act2_1_4_r,
    output reg  [7:0]act2_1_5_r,
    output reg  [7:0]act2_1_6_r,
    output reg  [7:0]act2_1_7_r,
    output reg  [7:0]act3_0_0_r,
    output reg  [7:0]act3_0_1_r,
    output reg  [7:0]act3_0_2_r,
    output reg  [7:0]act3_0_3_r,
    output reg  [7:0]act3_0_4_r,
    output reg  [7:0]act3_0_5_r,
    output reg  [7:0]act3_0_6_r,
    output reg  [7:0]act3_0_7_r,
    output reg  [7:0]act3_1_0_r,
    output reg  [7:0]act3_1_1_r,
    output reg  [7:0]act3_1_2_r,
    output reg  [7:0]act3_1_3_r,
    output reg  [7:0]act3_1_4_r,
    output reg  [7:0]act3_1_5_r,
    output reg  [7:0]act3_1_6_r,
    output reg  [7:0]act3_1_7_r
);

  //--------------------------------------------------------------------------
  // 1) COMBINATIONAL WIRES
  //--------------------------------------------------------------------------
  reg [6:0] ar0, ar1, ar2, ar3;

  initial begin
    ar0    = $random;
    ar1    = $random;
    ar2    = $random;
    ar3    = $random;
    #1;
  end

  // Arithmetic shares driven by each converter (32 converters × 2 shares)
  wire [7:0] act0_0_0_1;
  wire [7:0] act0_0_1_1;
  wire [7:0] act0_0_0_2;
  wire [7:0] act0_0_1_2;
  wire [7:0] act0_0_0_3;
  wire [7:0] act0_0_1_3;
  wire [7:0] act0_1_0_1;
  wire [7:0] act0_1_1_1;
  wire [7:0] act0_1_0_2;
  wire [7:0] act0_1_1_2;
  wire [7:0] act0_1_0_3;
  wire [7:0] act0_1_1_3;
  wire [7:0] act0_2_0_1;
  wire [7:0] act0_2_1_1;
  wire [7:0] act0_2_0_2;
  wire [7:0] act0_2_1_2;
  wire [7:0] act0_2_0_3;
  wire [7:0] act0_2_1_3;
  wire [7:0] act0_3_0_1;
  wire [7:0] act0_3_1_1;
  wire [7:0] act0_3_0_2;
  wire [7:0] act0_3_1_2;
  wire [7:0] act0_3_0_3;
  wire [7:0] act0_3_1_3;
  wire [7:0] act0_4_0_1;
  wire [7:0] act0_4_1_1;
  wire [7:0] act0_4_0_2;
  wire [7:0] act0_4_1_2;
  wire [7:0] act0_4_0_3;
  wire [7:0] act0_4_1_3;
  wire [7:0] act0_5_0_1;
  wire [7:0] act0_5_1_1;
  wire [7:0] act0_5_0_2;
  wire [7:0] act0_5_1_2;
  wire [7:0] act0_5_0_3;
  wire [7:0] act0_5_1_3;
  wire [7:0] act0_6_0_1;
  wire [7:0] act0_6_1_1;
  wire [7:0] act0_6_0_2;
  wire [7:0] act0_6_1_2;
  wire [7:0] act0_6_0_3;
  wire [7:0] act0_6_1_3;
  wire [7:0] act0_7_0_1;
  wire [7:0] act0_7_1_1;
  wire [7:0] act0_7_0_2;
  wire [7:0] act0_7_1_2;
  wire [7:0] act0_7_0_3;
  wire [7:0] act0_7_1_3;
  wire [7:0] act1_0_0_1;
  wire [7:0] act1_0_1_1;
  wire [7:0] act1_0_0_2;
  wire [7:0] act1_0_1_2;
  wire [7:0] act1_0_0_3;
  wire [7:0] act1_0_1_3;
  wire [7:0] act1_1_0_1;
  wire [7:0] act1_1_1_1;
  wire [7:0] act1_1_0_2;
  wire [7:0] act1_1_1_2;
  wire [7:0] act1_1_0_3;
  wire [7:0] act1_1_1_3;
  wire [7:0] act1_2_0_1;
  wire [7:0] act1_2_1_1;
  wire [7:0] act1_2_0_2;
  wire [7:0] act1_2_1_2;
  wire [7:0] act1_2_0_3;
  wire [7:0] act1_2_1_3;
  wire [7:0] act1_3_0_1;
  wire [7:0] act1_3_1_1;
  wire [7:0] act1_3_0_2;
  wire [7:0] act1_3_1_2;
  wire [7:0] act1_3_0_3;
  wire [7:0] act1_3_1_3;
  wire [7:0] act1_4_0_1;
  wire [7:0] act1_4_1_1;
  wire [7:0] act1_4_0_2;
  wire [7:0] act1_4_1_2;
  wire [7:0] act1_4_0_3;
  wire [7:0] act1_4_1_3;
  wire [7:0] act1_5_0_1;
  wire [7:0] act1_5_1_1;
  wire [7:0] act1_5_0_2;
  wire [7:0] act1_5_1_2;
  wire [7:0] act1_5_0_3;
  wire [7:0] act1_5_1_3;
  wire [7:0] act1_6_0_1;
  wire [7:0] act1_6_1_1;
  wire [7:0] act1_6_0_2;
  wire [7:0] act1_6_1_2;
  wire [7:0] act1_6_0_3;
  wire [7:0] act1_6_1_3;
  wire [7:0] act1_7_0_1;
  wire [7:0] act1_7_1_1;
  wire [7:0] act1_7_0_2;
  wire [7:0] act1_7_1_2;
  wire [7:0] act1_7_0_3;
  wire [7:0] act1_7_1_3;
  wire [7:0] act2_0_0_1;
  wire [7:0] act2_0_1_1;
  wire [7:0] act2_0_0_2;
  wire [7:0] act2_0_1_2;
  wire [7:0] act2_0_0_3;
  wire [7:0] act2_0_1_3;
  wire [7:0] act2_1_0_1;
  wire [7:0] act2_1_1_1;
  wire [7:0] act2_1_0_2;
  wire [7:0] act2_1_1_2;
  wire [7:0] act2_1_0_3;
  wire [7:0] act2_1_1_3;
  wire [7:0] act2_2_0_1;
  wire [7:0] act2_2_1_1;
  wire [7:0] act2_2_0_2;
  wire [7:0] act2_2_1_2;
  wire [7:0] act2_2_0_3;
  wire [7:0] act2_2_1_3;
  wire [7:0] act2_3_0_1;
  wire [7:0] act2_3_1_1;
  wire [7:0] act2_3_0_2;
  wire [7:0] act2_3_1_2;
  wire [7:0] act2_3_0_3;
  wire [7:0] act2_3_1_3;
  wire [7:0] act2_4_0_1;
  wire [7:0] act2_4_1_1;
  wire [7:0] act2_4_0_2;
  wire [7:0] act2_4_1_2;
  wire [7:0] act2_4_0_3;
  wire [7:0] act2_4_1_3;
  wire [7:0] act2_5_0_1;
  wire [7:0] act2_5_1_1;
  wire [7:0] act2_5_0_2;
  wire [7:0] act2_5_1_2;
  wire [7:0] act2_5_0_3;
  wire [7:0] act2_5_1_3;
  wire [7:0] act2_6_0_1;
  wire [7:0] act2_6_1_1;
  wire [7:0] act2_6_0_2;
  wire [7:0] act2_6_1_2;
  wire [7:0] act2_6_0_3;
  wire [7:0] act2_6_1_3;
  wire [7:0] act2_7_0_1;
  wire [7:0] act2_7_1_1;
  wire [7:0] act2_7_0_2;
  wire [7:0] act2_7_1_2;
  wire [7:0] act2_7_0_3;
  wire [7:0] act2_7_1_3;
  wire [7:0] act3_0_0_1;
  wire [7:0] act3_0_1_1;
  wire [7:0] act3_0_0_2;
  wire [7:0] act3_0_1_2;
  wire [7:0] act3_0_0_3;
  wire [7:0] act3_0_1_3;
  wire [7:0] act3_1_0_1;
  wire [7:0] act3_1_1_1;
  wire [7:0] act3_1_0_2;
  wire [7:0] act3_1_1_2;
  wire [7:0] act3_1_0_3;
  wire [7:0] act3_1_1_3;
  wire [7:0] act3_2_0_1;
  wire [7:0] act3_2_1_1;
  wire [7:0] act3_2_0_2;
  wire [7:0] act3_2_1_2;
  wire [7:0] act3_2_0_3;
  wire [7:0] act3_2_1_3;
  wire [7:0] act3_3_0_1;
  wire [7:0] act3_3_1_1;
  wire [7:0] act3_3_0_2;
  wire [7:0] act3_3_1_2;
  wire [7:0] act3_3_0_3;
  wire [7:0] act3_3_1_3;
  wire [7:0] act3_4_0_1;
  wire [7:0] act3_4_1_1;
  wire [7:0] act3_4_0_2;
  wire [7:0] act3_4_1_2;
  wire [7:0] act3_4_0_3;
  wire [7:0] act3_4_1_3;
  wire [7:0] act3_5_0_1;
  wire [7:0] act3_5_1_1;
  wire [7:0] act3_5_0_2;
  wire [7:0] act3_5_1_2;
  wire [7:0] act3_5_0_3;
  wire [7:0] act3_5_1_3;
  wire [7:0] act3_6_0_1;
  wire [7:0] act3_6_1_1;
  wire [7:0] act3_6_0_2;
  wire [7:0] act3_6_1_2;
  wire [7:0] act3_6_0_3;
  wire [7:0] act3_6_1_3;
  wire [7:0] act3_7_0_1;
  wire [7:0] act3_7_1_1;
  wire [7:0] act3_7_0_2;
  wire [7:0] act3_7_1_2;
  wire [7:0] act3_7_0_3;
  wire [7:0] act3_7_1_3;

  // Layer 1, act0
  wire [7:0] act0_0_0;
  wire [7:0] act0_1_0;
  wire [7:0] act0_0_1;
  wire [7:0] act0_1_1;
  wire [7:0] act0_0_2;
  wire [7:0] act0_1_2;
  wire [7:0] act0_0_3;
  wire [7:0] act0_1_3;
  wire [7:0] act0_0_4;
  wire [7:0] act0_1_4;
  wire [7:0] act0_0_5;
  wire [7:0] act0_1_5;
  wire [7:0] act0_0_6;
  wire [7:0] act0_1_6;
  wire [7:0] act0_0_7;
  wire [7:0] act0_1_7;

  // Layer 1, act1
  wire [7:0] act1_0_0;
  wire [7:0] act1_1_0;
  wire [7:0] act1_0_1;
  wire [7:0] act1_1_1;
  wire [7:0] act1_0_2;
  wire [7:0] act1_1_2;
  wire [7:0] act1_0_3;
  wire [7:0] act1_1_3;
  wire [7:0] act1_0_4;
  wire [7:0] act1_1_4;
  wire [7:0] act1_0_5;
  wire [7:0] act1_1_5;
  wire [7:0] act1_0_6;
  wire [7:0] act1_1_6;
  wire [7:0] act1_0_7;
  wire [7:0] act1_1_7;

  // Layer 1, act2
  wire [7:0] act2_0_0;
  wire [7:0] act2_1_0;
  wire [7:0] act2_0_1;
  wire [7:0] act2_1_1;
  wire [7:0] act2_0_2;
  wire [7:0] act2_1_2;
  wire [7:0] act2_0_3;
  wire [7:0] act2_1_3;
  wire [7:0] act2_0_4;
  wire [7:0] act2_1_4;
  wire [7:0] act2_0_5;
  wire [7:0] act2_1_5;
  wire [7:0] act2_0_6;
  wire [7:0] act2_1_6;
  wire [7:0] act2_0_7;
  wire [7:0] act2_1_7;

  // Layer 1, act3
  wire [7:0] act3_0_0;
  wire [7:0] act3_1_0;
  wire [7:0] act3_0_1;
  wire [7:0] act3_1_1;
  wire [7:0] act3_0_2;
  wire [7:0] act3_1_2;
  wire [7:0] act3_0_3;
  wire [7:0] act3_1_3;
  wire [7:0] act3_0_4;
  wire [7:0] act3_1_4;
  wire [7:0] act3_0_5;
  wire [7:0] act3_1_5;
  wire [7:0] act3_0_6;
  wire [7:0] act3_1_6;
  wire [7:0] act3_0_7;
  wire [7:0] act3_1_7;

  wire [7:0] w1_0;
  wire [7:0] w1_1;
  wire [7:0] w2_0;
  wire [7:0] w2_1;
  wire [7:0] w3_0;
  wire [7:0] w3_1;
  wire [7:0] w4_0;
  wire [7:0] w4_1;

  // Muxes for w1_0
  mux_3 m00_0 (.a(w1_0_2[0]), .b(w1_0_3[0]), .c(w1_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w1_0[0]));
  mux_3 m00_1 (.a(w1_0_2[1]), .b(w1_0_3[1]), .c(w1_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w1_0[1]));
  mux_3 m00_2 (.a(w1_0_2[2]), .b(w1_0_3[2]), .c(w1_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w1_0[2]));
  mux_3 m00_3 (.a(w1_0_2[3]), .b(w1_0_3[3]), .c(w1_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w1_0[3]));
  mux_3 m00_4 (.a(w1_0_2[4]), .b(w1_0_3[4]), .c(w1_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w1_0[4]));
  mux_3 m00_5 (.a(w1_0_2[5]), .b(w1_0_3[5]), .c(w1_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w1_0[5]));
  mux_3 m00_6 (.a(w1_0_2[6]), .b(w1_0_3[6]), .c(w1_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w1_0[6]));
  mux_3 m00_7 (.a(w1_0_2[7]), .b(w1_0_3[7]), .c(w1_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w1_0[7]));

  // Muxes for w2_0
  mux_3 m10_0 (.a(w2_0_2[0]), .b(w2_0_3[0]), .c(w2_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w2_0[0]));
  mux_3 m10_1 (.a(w2_0_2[1]), .b(w2_0_3[1]), .c(w2_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w2_0[1]));
  mux_3 m10_2 (.a(w2_0_2[2]), .b(w2_0_3[2]), .c(w2_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w2_0[2]));
  mux_3 m10_3 (.a(w2_0_2[3]), .b(w2_0_3[3]), .c(w2_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w2_0[3]));
  mux_3 m10_4 (.a(w2_0_2[4]), .b(w2_0_3[4]), .c(w2_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w2_0[4]));
  mux_3 m10_5 (.a(w2_0_2[5]), .b(w2_0_3[5]), .c(w2_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w2_0[5]));
  mux_3 m10_6 (.a(w2_0_2[6]), .b(w2_0_3[6]), .c(w2_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w2_0[6]));
  mux_3 m10_7 (.a(w2_0_2[7]), .b(w2_0_3[7]), .c(w2_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w2_0[7]));

  // Muxes for w3_0
  mux_3 m20_0 (.a(w3_0_2[0]), .b(w3_0_3[0]), .c(w3_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w3_0[0]));
  mux_3 m20_1 (.a(w3_0_2[1]), .b(w3_0_3[1]), .c(w3_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w3_0[1]));
  mux_3 m20_2 (.a(w3_0_2[2]), .b(w3_0_3[2]), .c(w3_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w3_0[2]));
  mux_3 m20_3 (.a(w3_0_2[3]), .b(w3_0_3[3]), .c(w3_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w3_0[3]));
  mux_3 m20_4 (.a(w3_0_2[4]), .b(w3_0_3[4]), .c(w3_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w3_0[4]));
  mux_3 m20_5 (.a(w3_0_2[5]), .b(w3_0_3[5]), .c(w3_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w3_0[5]));
  mux_3 m20_6 (.a(w3_0_2[6]), .b(w3_0_3[6]), .c(w3_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w3_0[6]));
  mux_3 m20_7 (.a(w3_0_2[7]), .b(w3_0_3[7]), .c(w3_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w3_0[7]));

  // Muxes for w4_0
  mux_3 m30_0 (.a(w4_0_2[0]), .b(w4_0_3[0]), .c(w4_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w4_0[0]));
  mux_3 m30_1 (.a(w4_0_2[1]), .b(w4_0_3[1]), .c(w4_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w4_0[1]));
  mux_3 m30_2 (.a(w4_0_2[2]), .b(w4_0_3[2]), .c(w4_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w4_0[2]));
  mux_3 m30_3 (.a(w4_0_2[3]), .b(w4_0_3[3]), .c(w4_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w4_0[3]));
  mux_3 m30_4 (.a(w4_0_2[4]), .b(w4_0_3[4]), .c(w4_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w4_0[4]));
  mux_3 m30_5 (.a(w4_0_2[5]), .b(w4_0_3[5]), .c(w4_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w4_0[5]));
  mux_3 m30_6 (.a(w4_0_2[6]), .b(w4_0_3[6]), .c(w4_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w4_0[6]));
  mux_3 m30_7 (.a(w4_0_2[7]), .b(w4_0_3[7]), .c(w4_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w4_0[7]));

  // Layer with weight vector _2
  wire [7:0] new_masked_activation0_0 = {
      (~^( masked_activation0_1 ^ w1_0[7] )),
      (~^( masked_activation0_1 ^ w1_0[6] )),
      (~^( masked_activation0_1 ^ w1_0[5] )),
      (~^( masked_activation0_1 ^ w1_0[4] )),
      (~^( masked_activation0_1 ^ w1_0[3] )),
      (~^( masked_activation0_1 ^ w1_0[2] )),
      (~^( masked_activation0_1 ^ w1_0[1] )),
      (~^( masked_activation0_1 ^ w1_0[0] ))
  };
  wire [7:0] new_mask0_0 = {
      ~( mask0_1 ^ w1_1[7] ),
      ~( mask0_1 ^ w1_1[6] ),
      ~( mask0_1 ^ w1_1[5] ),
      ~( mask0_1 ^ w1_1[4] ),
      ~( mask0_1 ^ w1_1[3] ),
      ~( mask0_1 ^ w1_1[2] ),
      ~( mask0_1 ^ w1_1[1] ),
      ~( mask0_1 ^ w1_1[0] )
  };

  wire [7:0] new_masked_activation1_0 = {
      (~^( masked_activation1_1 ^ w2_0[7] )),
      (~^( masked_activation1_1 ^ w2_0[6] )),
      (~^( masked_activation1_1 ^ w2_0[5] )),
      (~^( masked_activation1_1 ^ w2_0[4] )),
      (~^( masked_activation1_1 ^ w2_0[3] )),
      (~^( masked_activation1_1 ^ w2_0[2] )),
      (~^( masked_activation1_1 ^ w2_0[1] )),
      (~^( masked_activation1_1 ^ w2_0[0] ))
  };
  wire [7:0] new_mask1_0 = {
      ~( mask1_1 ^ w2_1[7] ),
      ~( mask1_1 ^ w2_1[6] ),
      ~( mask1_1 ^ w2_1[5] ),
      ~( mask1_1 ^ w2_1[4] ),
      ~( mask1_1 ^ w2_1[3] ),
      ~( mask1_1 ^ w2_1[2] ),
      ~( mask1_1 ^ w2_1[1] ),
      ~( mask1_1 ^ w2_1[0] )
  };

  wire [7:0] new_masked_activation2_0 = {
      (~^( masked_activation2_1 ^ w3_0[7] )),
      (~^( masked_activation2_1 ^ w3_0[6] )),
      (~^( masked_activation2_1 ^ w3_0[5] )),
      (~^( masked_activation2_1 ^ w3_0[4] )),
      (~^( masked_activation2_1 ^ w3_0[3] )),
      (~^( masked_activation2_1 ^ w3_0[2] )),
      (~^( masked_activation2_1 ^ w3_0[1] )),
      (~^( masked_activation2_1 ^ w3_0[0] ))
  };
  wire [7:0] new_mask2_0 = {
      ~( mask2_1 ^ w3_1[7] ),
      ~( mask2_1 ^ w3_1[6] ),
      ~( mask2_1 ^ w3_1[5] ),
      ~( mask2_1 ^ w3_1[4] ),
      ~( mask2_1 ^ w3_1[3] ),
      ~( mask2_1 ^ w3_1[2] ),
      ~( mask2_1 ^ w3_1[1] ),
      ~( mask2_1 ^ w3_1[0] )
  };

  wire [7:0] new_masked_activation3_0 = {
      (~^( masked_activation3_1 ^ w4_0[7] )),
      (~^( masked_activation3_1 ^ w4_0[6] )),
      (~^( masked_activation3_1 ^ w4_0[5] )),
      (~^( masked_activation3_1 ^ w4_0[4] )),
      (~^( masked_activation3_1 ^ w4_0[3] )),
      (~^( masked_activation3_1 ^ w4_0[2] )),
      (~^( masked_activation3_1 ^ w4_0[1] )),
      (~^( masked_activation3_1 ^ w4_0[0] ))
  };
  wire [7:0] new_mask3_0 = {
      ~( mask3_1 ^ w4_1[7] ),
      ~( mask3_1 ^ w4_1[6] ),
      ~( mask3_1 ^ w4_1[5] ),
      ~( mask3_1 ^ w4_1[4] ),
      ~( mask3_1 ^ w4_1[3] ),
      ~( mask3_1 ^ w4_1[2] ),
      ~( mask3_1 ^ w4_1[1] ),
      ~( mask3_1 ^ w4_1[0] )
  };

  // Muxes for w1_1
  mux_3 m01_0 (.a(w1_1_2[0]), .b(w1_1_3[0]), .c(w1_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w1_1[0]));
  mux_3 m01_1 (.a(w1_1_2[1]), .b(w1_1_3[1]), .c(w1_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w1_1[1]));
  mux_3 m01_2 (.a(w1_1_2[2]), .b(w1_1_3[2]), .c(w1_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w1_1[2]));
  mux_3 m01_3 (.a(w1_1_2[3]), .b(w1_1_3[3]), .c(w1_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w1_1[3]));
  mux_3 m01_4 (.a(w1_1_2[4]), .b(w1_1_3[4]), .c(w1_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w1_1[4]));
  mux_3 m01_5 (.a(w1_1_2[5]), .b(w1_1_3[5]), .c(w1_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w1_1[5]));
  mux_3 m01_6 (.a(w1_1_2[6]), .b(w1_1_3[6]), .c(w1_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w1_1[6]));
  mux_3 m01_7 (.a(w1_1_2[7]), .b(w1_1_3[7]), .c(w1_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w1_1[7]));

  // Muxes for w2_1
  mux_3 m11_0 (.a(w2_1_2[0]), .b(w2_1_3[0]), .c(w2_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w2_1[0]));
  mux_3 m11_1 (.a(w2_1_2[1]), .b(w2_1_3[1]), .c(w2_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w2_1[1]));
  mux_3 m11_2 (.a(w2_1_2[2]), .b(w2_1_3[2]), .c(w2_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w2_1[2]));
  mux_3 m11_3 (.a(w2_1_2[3]), .b(w2_1_3[3]), .c(w2_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w2_1[3]));
  mux_3 m11_4 (.a(w2_1_2[4]), .b(w2_1_3[4]), .c(w2_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w2_1[4]));
  mux_3 m11_5 (.a(w2_1_2[5]), .b(w2_1_3[5]), .c(w2_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w2_1[5]));
  mux_3 m11_6 (.a(w2_1_2[6]), .b(w2_1_3[6]), .c(w2_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w2_1[6]));
  mux_3 m11_7 (.a(w2_1_2[7]), .b(w2_1_3[7]), .c(w2_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w2_1[7]));

  // Muxes for w3_1
  mux_3 m21_0 (.a(w3_1_2[0]), .b(w3_1_3[0]), .c(w3_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w3_1[0]));
  mux_3 m21_1 (.a(w3_1_2[1]), .b(w3_1_3[1]), .c(w3_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w3_1[1]));
  mux_3 m21_2 (.a(w3_1_2[2]), .b(w3_1_3[2]), .c(w3_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w3_1[2]));
  mux_3 m21_3 (.a(w3_1_2[3]), .b(w3_1_3[3]), .c(w3_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w3_1[3]));
  mux_3 m21_4 (.a(w3_1_2[4]), .b(w3_1_3[4]), .c(w3_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w3_1[4]));
  mux_3 m21_5 (.a(w3_1_2[5]), .b(w3_1_3[5]), .c(w3_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w3_1[5]));
  mux_3 m21_6 (.a(w3_1_2[6]), .b(w3_1_3[6]), .c(w3_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w3_1[6]));
  mux_3 m21_7 (.a(w3_1_2[7]), .b(w3_1_3[7]), .c(w3_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w3_1[7]));

  // Muxes for w4_1
  mux_3 m31_0 (.a(w4_1_2[0]), .b(w4_1_3[0]), .c(w4_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w4_1[0]));
  mux_3 m31_1 (.a(w4_1_2[1]), .b(w4_1_3[1]), .c(w4_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w4_1[1]));
  mux_3 m31_2 (.a(w4_1_2[2]), .b(w4_1_3[2]), .c(w4_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w4_1[2]));
  mux_3 m31_3 (.a(w4_1_2[3]), .b(w4_1_3[3]), .c(w4_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w4_1[3]));
  mux_3 m31_4 (.a(w4_1_2[4]), .b(w4_1_3[4]), .c(w4_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w4_1[4]));
  mux_3 m31_5 (.a(w4_1_2[5]), .b(w4_1_3[5]), .c(w4_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w4_1[5]));
  mux_3 m31_6 (.a(w4_1_2[6]), .b(w4_1_3[6]), .c(w4_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w4_1[6]));
  mux_3 m31_7 (.a(w4_1_2[7]), .b(w4_1_3[7]), .c(w4_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w4_1[7]));

  // node 1
  mux_4 mux0_0_0 (.a(act0_0_0_1), .b(act0_0_0_2), .c(act0_0_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_0));
  mux_4 mux0_0_1 (.a(act0_1_0_1), .b(act0_1_0_2), .c(act0_1_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_1));
  mux_4 mux0_0_2 (.a(act0_2_0_1), .b(act0_2_0_2), .c(act0_2_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_2));
  mux_4 mux0_0_3 (.a(act0_3_0_1), .b(act0_3_0_2), .c(act0_3_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_3));
  mux_4 mux0_0_4 (.a(act0_4_0_1), .b(act0_4_0_2), .c(act0_4_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_4));
  mux_4 mux0_0_5 (.a(act0_5_0_1), .b(act0_5_0_2), .c(act0_5_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_5));
  mux_4 mux0_0_6 (.a(act0_6_0_1), .b(act0_6_0_2), .c(act0_6_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_6));
  mux_4 mux0_0_7 (.a(act0_7_0_1), .b(act0_7_0_2), .c(act0_7_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_7));
  mux_4 mux0_1_0 (.a(act0_0_1_1), .b(act0_0_1_2), .c(act0_0_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_0));
  mux_4 mux0_1_1 (.a(act0_1_1_1), .b(act0_1_1_2), .c(act0_1_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_1));
  mux_4 mux0_1_2 (.a(act0_2_1_1), .b(act0_2_1_2), .c(act0_2_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_2));
  mux_4 mux0_1_3 (.a(act0_3_1_1), .b(act0_3_1_2), .c(act0_3_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_3));
  mux_4 mux0_1_4 (.a(act0_4_1_1), .b(act0_4_1_2), .c(act0_4_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_4));
  mux_4 mux0_1_5 (.a(act0_5_1_1), .b(act0_5_1_2), .c(act0_5_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_5));
  mux_4 mux0_1_6 (.a(act0_6_1_1), .b(act0_6_1_2), .c(act0_6_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_6));
  mux_4 mux0_1_7 (.a(act0_7_1_1), .b(act0_7_1_2), .c(act0_7_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_7));

  // node 2
  mux_4 mux1_0_0 (.a(act1_0_0_1), .b(act1_0_0_2), .c(act1_0_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_0));
  mux_4 mux1_0_1 (.a(act1_1_0_1), .b(act1_1_0_2), .c(act1_1_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_1));
  mux_4 mux1_0_2 (.a(act1_2_0_1), .b(act1_2_0_2), .c(act1_2_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_2));
  mux_4 mux1_0_3 (.a(act1_3_0_1), .b(act1_3_0_2), .c(act1_3_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_3));
  mux_4 mux1_0_4 (.a(act1_4_0_1), .b(act1_4_0_2), .c(act1_4_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_4));
  mux_4 mux1_0_5 (.a(act1_5_0_1), .b(act1_5_0_2), .c(act1_5_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_5));
  mux_4 mux1_0_6 (.a(act1_6_0_1), .b(act1_6_0_2), .c(act1_6_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_6));
  mux_4 mux1_0_7 (.a(act1_7_0_1), .b(act1_7_0_2), .c(act1_7_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_7));
  mux_4 mux1_1_0 (.a(act1_0_1_1), .b(act1_0_1_2), .c(act1_0_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_0));
  mux_4 mux1_1_1 (.a(act1_1_1_1), .b(act1_1_1_2), .c(act1_1_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_1));
  mux_4 mux1_1_2 (.a(act1_2_1_1), .b(act1_2_1_2), .c(act1_2_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_2));
  mux_4 mux1_1_3 (.a(act1_3_1_1), .b(act1_3_1_2), .c(act1_3_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_3));
  mux_4 mux1_1_4 (.a(act1_4_1_1), .b(act1_4_1_2), .c(act1_4_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_4));
  mux_4 mux1_1_5 (.a(act1_5_1_1), .b(act1_5_1_2), .c(act1_5_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_5));
  mux_4 mux1_1_6 (.a(act1_6_1_1), .b(act1_6_1_2), .c(act1_6_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_6));
  mux_4 mux1_1_7 (.a(act1_7_1_1), .b(act1_7_1_2), .c(act1_7_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_7));

  // node 3
  mux_4 mux2_0_0 (.a(act2_0_0_1), .b(act2_0_0_2), .c(act2_0_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_0));
  mux_4 mux2_0_1 (.a(act2_1_0_1), .b(act2_1_0_2), .c(act2_1_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_1));
  mux_4 mux2_0_2 (.a(act2_2_0_1), .b(act2_2_0_2), .c(act2_2_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_2));
  mux_4 mux2_0_3 (.a(act2_3_0_1), .b(act2_3_0_2), .c(act2_3_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_3));
  mux_4 mux2_0_4 (.a(act2_4_0_1), .b(act2_4_0_2), .c(act2_4_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_4));
  mux_4 mux2_0_5 (.a(act2_5_0_1), .b(act2_5_0_2), .c(act2_5_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_5));
  mux_4 mux2_0_6 (.a(act2_6_0_1), .b(act2_6_0_2), .c(act2_6_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_6));
  mux_4 mux2_0_7 (.a(act2_7_0_1), .b(act2_7_0_2), .c(act2_7_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_7));
  mux_4 mux2_1_0 (.a(act2_0_1_1), .b(act2_0_1_2), .c(act2_0_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_0));
  mux_4 mux2_1_1 (.a(act2_1_1_1), .b(act2_1_1_2), .c(act2_1_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_1));
  mux_4 mux2_1_2 (.a(act2_2_1_1), .b(act2_2_1_2), .c(act2_2_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_2));
  mux_4 mux2_1_3 (.a(act2_3_1_1), .b(act2_3_1_2), .c(act2_3_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_3));
  mux_4 mux2_1_4 (.a(act2_4_1_1), .b(act2_4_1_2), .c(act2_4_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_4));
  mux_4 mux2_1_5 (.a(act2_5_1_1), .b(act2_5_1_2), .c(act2_5_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_5));
  mux_4 mux2_1_6 (.a(act2_6_1_1), .b(act2_6_1_2), .c(act2_6_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_6));
  mux_4 mux2_1_7 (.a(act2_7_1_1), .b(act2_7_1_2), .c(act2_7_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_7));

  // node 4
  mux_4 mux3_0_0 (.a(act3_0_0_1), .b(act3_0_0_2), .c(act3_0_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_0));
  mux_4 mux3_0_1 (.a(act3_1_0_1), .b(act3_1_0_2), .c(act3_1_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_1));
  mux_4 mux3_0_2 (.a(act3_2_0_1), .b(act3_2_0_2), .c(act3_2_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_2));
  mux_4 mux3_0_3 (.a(act3_3_0_1), .b(act3_3_0_2), .c(act3_3_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_3));
  mux_4 mux3_0_4 (.a(act3_4_0_1), .b(act3_4_0_2), .c(act3_4_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_4));
  mux_4 mux3_0_5 (.a(act3_5_0_1), .b(act3_5_0_2), .c(act3_5_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_5));
  mux_4 mux3_0_6 (.a(act3_6_0_1), .b(act3_6_0_2), .c(act3_6_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_6));
  mux_4 mux3_0_7 (.a(act3_7_0_1), .b(act3_7_0_2), .c(act3_7_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_7));
  mux_4 mux3_1_0 (.a(act3_0_1_1), .b(act3_0_1_2), .c(act3_0_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_0));
  mux_4 mux3_1_1 (.a(act3_1_1_1), .b(act3_1_1_2), .c(act3_1_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_1));
  mux_4 mux3_1_2 (.a(act3_2_1_1), .b(act3_2_1_2), .c(act3_2_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_2));
  mux_4 mux3_1_3 (.a(act3_3_1_1), .b(act3_3_1_2), .c(act3_3_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_3));
  mux_4 mux3_1_4 (.a(act3_4_1_1), .b(act3_4_1_2), .c(act3_4_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_4));
  mux_4 mux3_1_5 (.a(act3_5_1_1), .b(act3_5_1_2), .c(act3_5_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_5));
  mux_4 mux3_1_6 (.a(act3_6_1_1), .b(act3_6_1_2), .c(act3_6_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_6));
  mux_4 mux3_1_7 (.a(act3_7_1_1), .b(act3_7_1_2), .c(act3_7_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_7));

  // Boolean→Arithmetic converters
  boolean_arithmetic_coversion_1 conv00 (.x0(new_masked_activation0_0[0]), .x1(new_mask0_0[0]), .r_mask(ar0), .arith_share0(act0_0_0), .arith_share1(act0_1_0));
  boolean_arithmetic_coversion_1 conv01 (.x0(new_masked_activation0_0[1]), .x1(new_mask0_0[1]), .r_mask(ar0), .arith_share0(act0_0_1), .arith_share1(act0_1_1));
  boolean_arithmetic_coversion_1 conv02 (.x0(new_masked_activation0_0[2]), .x1(new_mask0_0[2]), .r_mask(ar0), .arith_share0(act0_0_2), .arith_share1(act0_1_2));
  boolean_arithmetic_coversion_1 conv03 (.x0(new_masked_activation0_0[3]), .x1(new_mask0_0[3]), .r_mask(ar0), .arith_share0(act0_0_3), .arith_share1(act0_1_3));
  boolean_arithmetic_coversion_1 conv04 (.x0(new_masked_activation0_0[4]), .x1(new_mask0_0[4]), .r_mask(ar0), .arith_share0(act0_0_4), .arith_share1(act0_1_4));
  boolean_arithmetic_coversion_1 conv05 (.x0(new_masked_activation0_0[5]), .x1(new_mask0_0[5]), .r_mask(ar0), .arith_share0(act0_0_5), .arith_share1(act0_1_5));
  boolean_arithmetic_coversion_1 conv06 (.x0(new_masked_activation0_0[6]), .x1(new_mask0_0[6]), .r_mask(ar0), .arith_share0(act0_0_6), .arith_share1(act0_1_6));
  boolean_arithmetic_coversion_1 conv07 (.x0(new_masked_activation0_0[7]), .x1(new_mask0_0[7]), .r_mask(ar0), .arith_share0(act0_0_7), .arith_share1(act0_1_7));

  boolean_arithmetic_coversion_1 conv08 (.x0(new_masked_activation1_0[0]), .x1(new_mask1_0[0]), .r_mask(ar1), .arith_share0(act1_0_0), .arith_share1(act1_1_0));
  boolean_arithmetic_coversion_1 conv09 (.x0(new_masked_activation1_0[1]), .x1(new_mask1_0[1]), .r_mask(ar1), .arith_share0(act1_0_1), .arith_share1(act1_1_1));
  boolean_arithmetic_coversion_1 conv10 (.x0(new_masked_activation1_0[2]), .x1(new_mask1_0[2]), .r_mask(ar1), .arith_share0(act1_0_2), .arith_share1(act1_1_2));
  boolean_arithmetic_coversion_1 conv11 (.x0(new_masked_activation1_0[3]), .x1(new_mask1_0[3]), .r_mask(ar1), .arith_share0(act1_0_3), .arith_share1(act1_1_3));
  boolean_arithmetic_coversion_1 conv12 (.x0(new_masked_activation1_0[4]), .x1(new_mask1_0[4]), .r_mask(ar1), .arith_share0(act1_0_4), .arith_share1(act1_1_4));
  boolean_arithmetic_coversion_1 conv13 (.x0(new_masked_activation1_0[5]), .x1(new_mask1_0[5]), .r_mask(ar1), .arith_share0(act1_0_5), .arith_share1(act1_1_5));
  boolean_arithmetic_coversion_1 conv14 (.x0(new_masked_activation1_0[6]), .x1(new_mask1_0[6]), .r_mask(ar1), .arith_share0(act1_0_6), .arith_share1(act1_1_6));
  boolean_arithmetic_coversion_1 conv15 (.x0(new_masked_activation1_0[7]), .x1(new_mask1_0[7]), .r_mask(ar1), .arith_share0(act1_0_7), .arith_share1(act1_1_7));

  boolean_arithmetic_coversion_1 conv16 (.x0(new_masked_activation2_0[0]), .x1(new_mask2_0[0]), .r_mask(ar2), .arith_share0(act2_0_0), .arith_share1(act2_1_0));
  boolean_arithmetic_coversion_1 conv17 (.x0(new_masked_activation2_0[1]), .x1(new_mask2_0[1]), .r_mask(ar2), .arith_share0(act2_0_1), .arith_share1(act2_1_1));
  boolean_arithmetic_coversion_1 conv18 (.x0(new_masked_activation2_0[2]), .x1(new_mask2_0[2]), .r_mask(ar2), .arith_share0(act2_0_2), .arith_share1(act2_1_2));
  boolean_arithmetic_coversion_1 conv19 (.x0(new_masked_activation2_0[3]), .x1(new_mask2_0[3]), .r_mask(ar2), .arith_share0(act2_0_3), .arith_share1(act2_1_3));
  boolean_arithmetic_coversion_1 conv20 (.x0(new_masked_activation2_0[4]), .x1(new_mask2_0[4]), .r_mask(ar2), .arith_share0(act2_0_4), .arith_share1(act2_1_4));
  boolean_arithmetic_coversion_1 conv21 (.x0(new_masked_activation2_0[5]), .x1(new_mask2_0[5]), .r_mask(ar2), .arith_share0(act2_0_5), .arith_share1(act2_1_5));
  boolean_arithmetic_coversion_1 conv22 (.x0(new_masked_activation2_0[6]), .x1(new_mask2_0[6]), .r_mask(ar2), .arith_share0(act2_0_6), .arith_share1(act2_1_6));
  boolean_arithmetic_coversion_1 conv23 (.x0(new_masked_activation2_0[7]), .x1(new_mask2_0[7]), .r_mask(ar2), .arith_share0(act2_0_7), .arith_share1(act2_1_7));

  boolean_arithmetic_coversion_1 conv24 (.x0(new_masked_activation3_0[0]), .x1(new_mask3_0[0]), .r_mask(ar3), .arith_share0(act3_0_0), .arith_share1(act3_1_0));
  boolean_arithmetic_coversion_1 conv25 (.x0(new_masked_activation3_0[1]), .x1(new_mask3_0[1]), .r_mask(ar3), .arith_share0(act3_0_1), .arith_share1(act3_1_1));
  boolean_arithmetic_coversion_1 conv26 (.x0(new_masked_activation3_0[2]), .x1(new_mask3_0[2]), .r_mask(ar3), .arith_share0(act3_0_2), .arith_share1(act3_1_2));
  boolean_arithmetic_coversion_1 conv27 (.x0(new_masked_activation3_0[3]), .x1(new_mask3_0[3]), .r_mask(ar3), .arith_share0(act3_0_3), .arith_share1(act3_1_3));
  boolean_arithmetic_coversion_1 conv28 (.x0(new_masked_activation3_0[4]), .x1(new_mask3_0[4]), .r_mask(ar3), .arith_share0(act3_0_4), .arith_share1(act3_1_4));
  boolean_arithmetic_coversion_1 conv29 (.x0(new_masked_activation3_0[5]), .x1(new_mask3_0[5]), .r_mask(ar3), .arith_share0(act3_0_5), .arith_share1(act3_1_5));
  boolean_arithmetic_coversion_1 conv30 (.x0(new_masked_activation3_0[6]), .x1(new_mask3_0[6]), .r_mask(ar3), .arith_share0(act3_0_6), .arith_share1(act3_1_6));
  boolean_arithmetic_coversion_1 conv31 (.x0(new_masked_activation3_0[7]), .x1(new_mask3_0[7]), .r_mask(ar3), .arith_share0(act3_0_7), .arith_share1(act3_1_7));

  // snapshot into registers
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done <= 1'b0;
        act0_0_0_r <= 8'd0 ;
        act0_0_1_r <= 8'd0 ;
        act0_0_2_r <= 8'd0 ;
        act0_0_3_r <= 8'd0 ;
        act0_0_4_r <= 8'd0 ;
        act0_0_5_r <= 8'd0 ;
        act0_0_6_r <= 8'd0 ;
        act0_0_7_r <= 8'd0 ;
        act0_1_0_r <= 8'd0 ;
        act0_1_1_r <= 8'd0 ;
        act0_1_2_r <= 8'd0 ;
        act0_1_3_r <= 8'd0 ;
        act0_1_4_r <= 8'd0 ;
        act0_1_5_r <= 8'd0 ;
        act0_1_6_r <= 8'd0 ;
        act0_1_7_r <= 8'd0 ;
        act1_0_0_r <= 8'd0 ;
        act1_0_1_r <= 8'd0 ;
        act1_0_2_r <= 8'd0 ;
        act1_0_3_r <= 8'd0 ;
        act1_0_4_r <= 8'd0 ;
        act1_0_5_r <= 8'd0 ;
        act1_0_6_r <= 8'd0 ;
        act1_0_7_r <= 8'd0 ;
        act1_1_0_r <= 8'd0 ;
        act1_1_1_r <= 8'd0 ;
        act1_1_2_r <= 8'd0 ;
        act1_1_3_r <= 8'd0 ;
        act1_1_4_r <= 8'd0 ;
        act1_1_5_r <= 8'd0 ;
        act1_1_6_r <= 8'd0 ;
        act1_1_7_r <= 8'd0 ;
        act2_0_0_r <= 8'd0 ;
        act2_0_1_r <= 8'd0 ;
        act2_0_2_r <= 8'd0 ;
        act2_0_3_r <= 8'd0 ;
        act2_0_4_r <= 8'd0 ;
        act2_0_5_r <= 8'd0 ;
        act2_0_6_r <= 8'd0 ;
        act2_0_7_r <= 8'd0 ;
        act2_1_0_r <= 8'd0 ;
        act2_1_1_r <= 8'd0 ;
        act2_1_2_r <= 8'd0 ;
        act2_1_3_r <= 8'd0 ;
        act2_1_4_r <= 8'd0 ;
        act2_1_5_r <= 8'd0 ;
        act2_1_6_r <= 8'd0 ;
        act2_1_7_r <= 8'd0 ;
        act3_0_0_r <= 8'd0 ;
        act3_0_1_r <= 8'd0 ;
        act3_0_2_r <= 8'd0 ;
        act3_0_3_r <= 8'd0 ;
        act3_0_4_r <= 8'd0 ;
        act3_0_5_r <= 8'd0 ;
        act3_0_6_r <= 8'd0 ;
        act3_0_7_r <= 8'd0 ;
        act3_1_0_r <= 8'd0 ;
        act3_1_1_r <= 8'd0 ;
        act3_1_2_r <= 8'd0 ;
        act3_1_3_r <= 8'd0 ;
        act3_1_4_r <= 8'd0 ;
        act3_1_5_r <= 8'd0 ;
        act3_1_6_r <= 8'd0 ;
        act3_1_7_r <= 8'd0 ;
    end else begin
      if (start) begin
        act0_0_0_r <= act0_0_0 ;
        act0_0_1_r <= act0_0_1 ;
        act0_0_2_r <= act0_0_2 ;
        act0_0_3_r <= act0_0_3 ;
        act0_0_4_r <= act0_0_4 ;
        act0_0_5_r <= act0_0_5 ;
        act0_0_6_r <= act0_0_6 ;
        act0_0_7_r <= act0_0_7 ;
        act0_1_0_r <= act0_1_0 ;
        act0_1_1_r <= act0_1_1 ;
        act0_1_2_r <= act0_1_2 ;
        act0_1_3_r <= act0_1_3 ;
        act0_1_4_r <= act0_1_4 ;
        act0_1_5_r <= act0_1_5 ;
        act0_1_6_r <= act0_1_6 ;
        act0_1_7_r <= act0_1_7 ;
        act1_0_0_r <= act1_0_0 ;
        act1_0_1_r <= act1_0_1 ;
        act1_0_2_r <= act1_0_2 ;
        act1_0_3_r <= act1_0_3 ;
        act1_0_4_r <= act1_0_4 ;
        act1_0_5_r <= act1_0_5 ;
        act1_0_6_r <= act1_0_6 ;
        act1_0_7_r <= act1_0_7 ;
        act1_1_0_r <= act1_1_0 ;
        act1_1_1_r <= act1_1_1 ;
        act1_1_2_r <= act1_1_2 ;
        act1_1_3_r <= act1_1_3 ;
        act1_1_4_r <= act1_1_4 ;
        act1_1_5_r <= act1_1_5 ;
        act1_1_6_r <= act1_1_6 ;
        act1_1_7_r <= act1_1_7 ;
        act2_0_0_r <= act2_0_0 ;
        act2_0_1_r <= act2_0_1 ;
        act2_0_2_r <= act2_0_2 ;
        act2_0_3_r <= act2_0_3 ;
        act2_0_4_r <= act2_0_4 ;
        act2_0_5_r <= act2_0_5 ;
        act2_0_6_r <= act2_0_6 ;
        act2_0_7_r <= act2_0_7 ;
        act2_1_0_r <= act2_1_0 ;
        act2_1_1_r <= act2_1_1 ;
        act2_1_2_r <= act2_1_2 ;
        act2_1_3_r <= act2_1_3 ;
        act2_1_4_r <= act2_1_4 ;
        act2_1_5_r <= act2_1_5 ;
        act2_1_6_r <= act2_1_6 ;
        act2_1_7_r <= act2_1_7 ;
        act3_0_0_r <= act3_0_0 ;
        act3_0_1_r <= act3_0_1 ;
        act3_0_2_r <= act3_0_2 ;
        act3_0_3_r <= act3_0_3 ;
        act3_0_4_r <= act3_0_4 ;
        act3_0_5_r <= act3_0_5 ;
        act3_0_6_r <= act3_0_6 ;
        act3_0_7_r <= act3_0_7 ;
        act3_1_0_r <= act3_1_0 ;
        act3_1_1_r <= act3_1_1 ;
        act3_1_2_r <= act3_1_2 ;
        act3_1_3_r <= act3_1_3 ;
        act3_1_4_r <= act3_1_4 ;
        act3_1_5_r <= act3_1_5 ;
        act3_1_6_r <= act3_1_6 ;
        act3_1_7_r <= act3_1_7 ;
        done <= 1'b1;
      end else begin
        done <= 1'b0;
      end
    end
  end
endmodule
module subtractor (
    input  wire signed [11:0] A,
    input  wire signed [11:0] B,
    output wire signed [12:0] Result
);
    assign Result = A - B;
endmodule

module comparator_1 (
    input  wire [12:0] inputs0_0,
    input  wire [12:0] inputs0_1,
    input  wire r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0, r9_0, r10_0, r11_0, r12_0,
    output wire comparator
);
    // internal r_out chain
    wire r1 , r2 , r3 , r4 , r5 , r6 , r7 , r8 , r9 , r10 , r11 , r12 , r13;
    wire masked_c0_0 , masked_c1_0 , masked_c2_0 , masked_c3_0 , masked_c4_0 , masked_c5_0 , masked_c6_0 , masked_c7_0 , masked_c8_0 , masked_c9_0 , masked_c10_0 , masked_c11_0 , masked_c12_0;

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
    lut1 l7 (.a(inputs0_0[7]), .b(inputs0_1[7]), .c_in(masked_c6_0),
               .r_flow(r7), .r_i(r7_0), .r_out(r8), .c_masked(masked_c7_0));
    lut1 l8 (.a(inputs0_0[8]), .b(inputs0_1[8]), .c_in(masked_c7_0),
               .r_flow(r8), .r_i(r8_0), .r_out(r9), .c_masked(masked_c8_0));
    lut1 l9 (.a(inputs0_0[9]), .b(inputs0_1[9]), .c_in(masked_c8_0),
               .r_flow(r9), .r_i(r9_0), .r_out(r10), .c_masked(masked_c9_0));
    lut1 l10 (.a(inputs0_0[10]), .b(inputs0_1[10]), .c_in(masked_c9_0),
               .r_flow(r10), .r_i(r10_0), .r_out(r11), .c_masked(masked_c10_0));
    lut1 l11 (.a(inputs0_0[11]), .b(inputs0_1[11]), .c_in(masked_c10_0),
               .r_flow(r11), .r_i(r11_0), .r_out(r12), .c_masked(masked_c11_0));
    lut1 l12 (.a(inputs0_0[12]), .b(inputs0_1[12]), .c_in(masked_c11_0),
               .r_flow(r12), .r_i(r12_0), .r_out(r13), .c_masked(masked_c12_0));

    wire carry = r13 ^ masked_c12_0;
    // final compare: if carry ^ inputs0_0[N-1] ^ inputs0_1[N-1] == 0 → comparator = 1
    assign comparator = (carry ^ inputs0_0[12] ^ inputs0_1[12]) ? 1'b0 : 1'b1;
endmodule


module output_layer (
  input  wire [11:0] biased_sum0_0,
  input  wire [11:0] biased_sum0_1,
  input  wire [11:0] biased_sum0_0bar,
  input  wire [11:0] biased_sum0_1bar,
  input  wire [11:0] biased_sum1_0,
  input  wire [11:0] biased_sum1_1,
  input  wire [11:0] biased_sum1_0bar,
  input  wire [11:0] biased_sum1_1bar,
    output reg  a0, a0_bar,
    output reg  a1, a1_bar
);

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
    reg r7_0;
    reg r7_0bar;
    reg r8_0;
    reg r8_0bar;
    reg r9_0;
    reg r9_0bar;
    reg r10_0;
    reg r10_0bar;
    reg r11_0;
    reg r11_0bar;
    reg r12_0;
    reg r12_0bar;

  initial begin
     r0_0= $random;
     r0_0bar = $random;
     r1_0= $random;
     r1_0bar = $random;
     r2_0= $random;
     r2_0bar = $random;
     r3_0= $random;
     r3_0bar = $random;
     r4_0= $random;
     r4_0bar = $random;
     r5_0= $random;
     r5_0bar = $random;
     r6_0= $random;
     r6_0bar = $random;
     r7_0= $random;
     r7_0bar = $random;
     r8_0= $random;
     r8_0bar = $random;
     r9_0= $random;
     r9_0bar = $random;
     r10_0= $random;
     r10_0bar = $random;
     r11_0= $random;
     r11_0bar = $random;
     r12_0= $random;
     r12_0bar = $random;
    #1;
  end

    wire [12:0] temp0_0, temp0_1, temp0_0bar, temp0_1bar;
    subtractor s0a (.A(biased_sum0_0), .B(biased_sum1_0), .Result(temp0_0));
    subtractor s0b (.A(biased_sum0_1), .B(biased_sum1_1), .Result(temp0_1));
    subtractor s0abar (.A(biased_sum0_0bar), .B(biased_sum1_0bar), .Result(temp0_0bar));
    subtractor s0bbar (.A(biased_sum0_1bar), .B(biased_sum1_1bar), .Result(temp0_1bar));
    wire comp0, comp0_bar;
    comparator_1 c0 (
        .inputs0_0(temp0_0), .inputs0_1(temp0_1),
        .r0_0(r0_0), .r1_0(r1_0), .r2_0(r2_0), .r3_0(r3_0), .r4_0(r4_0), .r5_0(r5_0), .r6_0(r6_0), .r7_0(r7_0), .r8_0(r8_0), .r9_0(r9_0), .r10_0(r10_0), .r11_0(r11_0), .r12_0(r12_0),
        .comparator(comp0)
    );
    comparator_1 c0_bar (
        .inputs0_0(temp0_0bar), .inputs0_1(temp0_1bar),
        .r0_0(r0_0bar), .r1_0(r1_0bar), .r2_0(r2_0bar), .r3_0(r3_0bar), .r4_0(r4_0bar), .r5_0(r5_0bar), .r6_0(r6_0bar), .r7_0(r7_0bar), .r8_0(r8_0bar), .r9_0(r9_0bar), .r10_0(r10_0bar), .r11_0(r11_0bar), .r12_0(r12_0bar),
        .comparator(comp0_bar)
    );
    reg [11:0] stage1_0_0, stage1_0_1, stage1_0_0bar, stage1_0_1bar;
    always @(*) begin
        if (comp0)      begin stage1_0_0 = biased_sum0_0;    stage1_0_1 = biased_sum0_1;    end
        else                    begin stage1_0_0 = biased_sum1_0;    stage1_0_1 = biased_sum1_1;    end
        if (comp0_bar)  begin stage1_0_0bar = biased_sum0_0bar; stage1_0_1bar = biased_sum0_1bar; end
        else                    begin stage1_0_0bar = biased_sum1_0bar; stage1_0_1bar = biased_sum1_1bar; end
    end

    always @(*) begin
        a0 = 0; a0_bar = 0;
        a1 = 0; a1_bar = 0;

        if (comp0 == 1) a0     = 1;
        else             a1     = 1;

        if (comp0_bar == 1) a0_bar     = 1;
        else             a1_bar     = 1;
    end
endmodule
module iterative_controller (
    input wire  clk,
    input wire  rst_n,
    input wire  start,
    output reg   done,
    input wire [7:0] inputs0_1,
    input wire [7:0] inputs1_1,
    input wire [7:0] inputs2_1,
    input wire [7:0] inputs3_1,
    input wire [7:0] inputs4_1,
    input wire [7:0] inputs5_1,
    input wire [7:0] inputs6_1,
    input wire [7:0] inputs7_1,
    input wire [7:0] w1_0_1, w1_1_1,
    input wire [7:0] w1_0_2, w1_1_2,
    input wire [7:0] w1_0_3, w1_1_3,
    input wire [7:0] w1_0_4, w1_1_4,
    input wire [7:0] w2_0_1, w2_1_1,
    input wire [7:0] w2_0_2, w2_1_2,
    input wire [7:0] w2_0_3, w2_1_3,
    input wire [7:0] w2_0_4, w2_1_4,
    input wire [7:0] w3_0_1, w3_1_1,
    input wire [7:0] w3_0_2, w3_1_2,
    input wire [7:0] w3_0_3, w3_1_3,
    input wire [7:0] w3_0_4, w3_1_4,
    input wire [7:0] w4_0_1, w4_1_1,
    input wire [7:0] w4_0_2, w4_1_2,
    input wire [7:0] w4_0_3, w4_1_3,
    input wire [7:0] w4_0_4, w4_1_4,
    input wire [10:0] b1_1,
    input wire [10:0] b1_2,
    input wire [10:0] b1_3,
    input wire [10:0] b1_4,
    input wire [10:0] b2_1,
    input wire [10:0] b2_2,
    input wire [10:0] b2_3,
    input wire [10:0] b2_4,
    input wire [10:0] b3_1,
    input wire [10:0] b3_2,
    input wire [10:0] b3_3,
    input wire [10:0] b3_4,
    input wire [10:0] b4_1,
    input wire [10:0] b4_2,
    input wire [10:0] b4_3,
    input wire [10:0] b4_4,
    output wire  [7:0]act0_0_0_r,
    output wire  [7:0]act0_0_1_r,
    output wire  [7:0]act0_0_2_r,
    output wire  [7:0]act0_0_3_r,
    output wire  [7:0]act0_0_4_r,
    output wire  [7:0]act0_0_5_r,
    output wire  [7:0]act0_0_6_r,
    output wire  [7:0]act0_0_7_r,
    output wire  [7:0]act0_1_0_r,
    output wire  [7:0]act0_1_1_r,
    output wire  [7:0]act0_1_2_r,
    output wire  [7:0]act0_1_3_r,
    output wire  [7:0]act0_1_4_r,
    output wire  [7:0]act0_1_5_r,
    output wire  [7:0]act0_1_6_r,
    output wire  [7:0]act0_1_7_r,
    output wire  [7:0]act1_0_0_r,
    output wire  [7:0]act1_0_1_r,
    output wire  [7:0]act1_0_2_r,
    output wire  [7:0]act1_0_3_r,
    output wire  [7:0]act1_0_4_r,
    output wire  [7:0]act1_0_5_r,
    output wire  [7:0]act1_0_6_r,
    output wire  [7:0]act1_0_7_r,
    output wire  [7:0]act1_1_0_r,
    output wire  [7:0]act1_1_1_r,
    output wire  [7:0]act1_1_2_r,
    output wire  [7:0]act1_1_3_r,
    output wire  [7:0]act1_1_4_r,
    output wire  [7:0]act1_1_5_r,
    output wire  [7:0]act1_1_6_r,
    output wire  [7:0]act1_1_7_r,
    output wire  [7:0]act2_0_0_r,
    output wire  [7:0]act2_0_1_r,
    output wire  [7:0]act2_0_2_r,
    output wire  [7:0]act2_0_3_r,
    output wire  [7:0]act2_0_4_r,
    output wire  [7:0]act2_0_5_r,
    output wire  [7:0]act2_0_6_r,
    output wire  [7:0]act2_0_7_r,
    output wire  [7:0]act2_1_0_r,
    output wire  [7:0]act2_1_1_r,
    output wire  [7:0]act2_1_2_r,
    output wire  [7:0]act2_1_3_r,
    output wire  [7:0]act2_1_4_r,
    output wire  [7:0]act2_1_5_r,
    output wire  [7:0]act2_1_6_r,
    output wire  [7:0]act2_1_7_r,
    output wire  [7:0]act3_0_0_r,
    output wire  [7:0]act3_0_1_r,
    output wire  [7:0]act3_0_2_r,
    output wire  [7:0]act3_0_3_r,
    output wire  [7:0]act3_0_4_r,
    output wire  [7:0]act3_0_5_r,
    output wire  [7:0]act3_0_6_r,
    output wire  [7:0]act3_0_7_r,
    output wire  [7:0]act3_1_0_r,
    output wire  [7:0]act3_1_1_r,
    output wire  [7:0]act3_1_2_r,
    output wire  [7:0]act3_1_3_r,
    output wire  [7:0]act3_1_4_r,
    output wire  [7:0]act3_1_5_r,
    output wire  [7:0]act3_1_6_r,
    output wire  [7:0]act3_1_7_r
);

  reg  [1:0]  s_count;
  reg [7:0] act0_0_0_layer;
  reg [7:0] act0_1_0_layer;
  reg [7:0] act0_0_1_layer;
  reg [7:0] act0_1_1_layer;
  reg [7:0] act0_0_2_layer;
  reg [7:0] act0_1_2_layer;
  reg [7:0] act0_0_3_layer;
  reg [7:0] act0_1_3_layer;
  reg [7:0] act0_0_4_layer;
  reg [7:0] act0_1_4_layer;
  reg [7:0] act0_0_5_layer;
  reg [7:0] act0_1_5_layer;
  reg [7:0] act0_0_6_layer;
  reg [7:0] act0_1_6_layer;
  reg [7:0] act0_0_7_layer;
  reg [7:0] act0_1_7_layer;
  reg [7:0] act1_0_0_layer;
  reg [7:0] act1_1_0_layer;
  reg [7:0] act1_0_1_layer;
  reg [7:0] act1_1_1_layer;
  reg [7:0] act1_0_2_layer;
  reg [7:0] act1_1_2_layer;
  reg [7:0] act1_0_3_layer;
  reg [7:0] act1_1_3_layer;
  reg [7:0] act1_0_4_layer;
  reg [7:0] act1_1_4_layer;
  reg [7:0] act1_0_5_layer;
  reg [7:0] act1_1_5_layer;
  reg [7:0] act1_0_6_layer;
  reg [7:0] act1_1_6_layer;
  reg [7:0] act1_0_7_layer;
  reg [7:0] act1_1_7_layer;
  reg [7:0] act2_0_0_layer;
  reg [7:0] act2_1_0_layer;
  reg [7:0] act2_0_1_layer;
  reg [7:0] act2_1_1_layer;
  reg [7:0] act2_0_2_layer;
  reg [7:0] act2_1_2_layer;
  reg [7:0] act2_0_3_layer;
  reg [7:0] act2_1_3_layer;
  reg [7:0] act2_0_4_layer;
  reg [7:0] act2_1_4_layer;
  reg [7:0] act2_0_5_layer;
  reg [7:0] act2_1_5_layer;
  reg [7:0] act2_0_6_layer;
  reg [7:0] act2_1_6_layer;
  reg [7:0] act2_0_7_layer;
  reg [7:0] act2_1_7_layer;
  reg [7:0] act3_0_0_layer;
  reg [7:0] act3_1_0_layer;
  reg [7:0] act3_0_1_layer;
  reg [7:0] act3_1_1_layer;
  reg [7:0] act3_0_2_layer;
  reg [7:0] act3_1_2_layer;
  reg [7:0] act3_0_3_layer;
  reg [7:0] act3_1_3_layer;
  reg [7:0] act3_0_4_layer;
  reg [7:0] act3_1_4_layer;
  reg [7:0] act3_0_5_layer;
  reg [7:0] act3_1_5_layer;
  reg [7:0] act3_0_6_layer;
  reg [7:0] act3_1_6_layer;
  reg [7:0] act3_0_7_layer;
  reg [7:0] act3_1_7_layer;

  // internal wires
  wire [11:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar;
  wire masked_activation0_1, masked_activation0bar_1;
  wire mask0_1, mask0bar_1;
  wire  a0, a0_bar;
  wire [11:0] biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar;
  wire masked_activation1_1, masked_activation1bar_1;
  wire mask1_1, mask1bar_1;
  wire  a1, a1_bar;
  wire [11:0] biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar;
  wire masked_activation2_1, masked_activation2bar_1;
  wire mask2_1, mask2bar_1;
  wire  a2, a2_bar;
  wire [11:0] biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar;
  wire masked_activation3_1, masked_activation3bar_1;
  wire mask3_1, mask3bar_1;
  wire  a3, a3_bar;
  


  // state encoding
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
  end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
      // reset all feedback regs to zero
            act0_0_0_layer <= 8'd0;        act0_0_1_layer <= 8'd0;
            act0_0_2_layer <= 8'd0;        act0_0_3_layer <= 8'd0;
            act0_0_4_layer <= 8'd0;        act0_0_5_layer <= 8'd0;
            act0_0_6_layer <= 8'd0;        act0_0_7_layer <= 8'd0;

            act0_1_0_layer <= 8'd0;        act0_1_1_layer <= 8'd0;
            act0_1_2_layer <= 8'd0;        act0_1_3_layer <= 8'd0;
            act0_1_4_layer <= 8'd0;        act0_1_5_layer <= 8'd0;
            act0_1_6_layer <= 8'd0;        act0_1_7_layer <= 8'd0;

            act1_0_0_layer <= 8'd0;        act1_0_1_layer <= 8'd0;
            act1_0_2_layer <= 8'd0;        act1_0_3_layer <= 8'd0;
            act1_0_4_layer <= 8'd0;        act1_0_5_layer <= 8'd0;
            act1_0_6_layer <= 8'd0;        act1_0_7_layer <= 8'd0;

            act1_1_0_layer <= 8'd0;        act1_1_1_layer <= 8'd0;
            act1_1_2_layer <= 8'd0;        act1_1_3_layer <= 8'd0;
            act1_1_4_layer <= 8'd0;        act1_1_5_layer <= 8'd0;
            act1_1_6_layer <= 8'd0;        act1_1_7_layer <= 8'd0;

            act2_0_0_layer <= 8'd0;        act2_0_1_layer <= 8'd0;
            act2_0_2_layer <= 8'd0;        act2_0_3_layer <= 8'd0;
            act2_0_4_layer <= 8'd0;        act2_0_5_layer <= 8'd0;
            act2_0_6_layer <= 8'd0;        act2_0_7_layer <= 8'd0;

            act2_1_0_layer <= 8'd0;        act2_1_1_layer <= 8'd0;
            act2_1_2_layer <= 8'd0;        act2_1_3_layer <= 8'd0;
            act2_1_4_layer <= 8'd0;        act2_1_5_layer <= 8'd0;
            act2_1_6_layer <= 8'd0;        act2_1_7_layer <= 8'd0;

            act3_0_0_layer <= 8'd0;        act3_0_1_layer <= 8'd0;
            act3_0_2_layer <= 8'd0;        act3_0_3_layer <= 8'd0;
            act3_0_4_layer <= 8'd0;        act3_0_5_layer <= 8'd0;
            act3_0_6_layer <= 8'd0;        act3_0_7_layer <= 8'd0;

            act3_1_0_layer <= 8'd0;        act3_1_1_layer <= 8'd0;
            act3_1_2_layer <= 8'd0;        act3_1_3_layer <= 8'd0;
            act3_1_4_layer <= 8'd0;        act3_1_5_layer <= 8'd0;
            act3_1_6_layer <= 8'd0;        act3_1_7_layer <= 8'd0;
  end else if (state == WAIT_SHARE && done_share) begin
      // capture the outputs of m2 into the next iteration's m1 inputs
            act0_0_0_layer <= act0_0_0_r;        act0_0_1_layer <= act0_0_1_r;
            act0_0_2_layer <= act0_0_2_r;        act0_0_3_layer <= act0_0_3_r;
            act0_0_4_layer <= act0_0_4_r;        act0_0_5_layer <= act0_0_5_r;
            act0_0_6_layer <= act0_0_6_r;        act0_0_7_layer <= act0_0_7_r;

            act0_1_0_layer <= act0_1_0_r;        act0_1_1_layer <= act0_1_1_r;
            act0_1_2_layer <= act0_1_2_r;        act0_1_3_layer <= act0_1_3_r;
            act0_1_4_layer <= act0_1_4_r;        act0_1_5_layer <= act0_1_5_r;
            act0_1_6_layer <= act0_1_6_r;        act0_1_7_layer <= act0_1_7_r;

            act1_0_0_layer <= act1_0_0_r;        act1_0_1_layer <= act1_0_1_r;
            act1_0_2_layer <= act1_0_2_r;        act1_0_3_layer <= act1_0_3_r;
            act1_0_4_layer <= act1_0_4_r;        act1_0_5_layer <= act1_0_5_r;
            act1_0_6_layer <= act1_0_6_r;        act1_0_7_layer <= act1_0_7_r;

            act1_1_0_layer <= act1_1_0_r;        act1_1_1_layer <= act1_1_1_r;
            act1_1_2_layer <= act1_1_2_r;        act1_1_3_layer <= act1_1_3_r;
            act1_1_4_layer <= act1_1_4_r;        act1_1_5_layer <= act1_1_5_r;
            act1_1_6_layer <= act1_1_6_r;        act1_1_7_layer <= act1_1_7_r;

            act2_0_0_layer <= act2_0_0_r;        act2_0_1_layer <= act2_0_1_r;
            act2_0_2_layer <= act2_0_2_r;        act2_0_3_layer <= act2_0_3_r;
            act2_0_4_layer <= act2_0_4_r;        act2_0_5_layer <= act2_0_5_r;
            act2_0_6_layer <= act2_0_6_r;        act2_0_7_layer <= act2_0_7_r;

            act2_1_0_layer <= act2_1_0_r;        act2_1_1_layer <= act2_1_1_r;
            act2_1_2_layer <= act2_1_2_r;        act2_1_3_layer <= act2_1_3_r;
            act2_1_4_layer <= act2_1_4_r;        act2_1_5_layer <= act2_1_5_r;
            act2_1_6_layer <= act2_1_6_r;        act2_1_7_layer <= act2_1_7_r;

            act3_0_0_layer <= act3_0_0_r;        act3_0_1_layer <= act3_0_1_r;
            act3_0_2_layer <= act3_0_2_r;        act3_0_3_layer <= act3_0_3_r;
            act3_0_4_layer <= act3_0_4_r;        act3_0_5_layer <= act3_0_5_r;
            act3_0_6_layer <= act3_0_6_r;        act3_0_7_layer <= act3_0_7_r;

            act3_1_0_layer <= act3_1_0_r;        act3_1_1_layer <= act3_1_1_r;
            act3_1_2_layer <= act3_1_2_r;        act3_1_3_layer <= act3_1_3_r;
            act3_1_4_layer <= act3_1_4_r;        act3_1_5_layer <= act3_1_5_r;
            act3_1_6_layer <= act3_1_6_r;        act3_1_7_layer <= act3_1_7_r;
  end
   else begin 
            act0_0_0_layer <= act0_0_0_layer;        act0_0_1_layer <= act0_0_1_layer;
            act0_0_2_layer <= act0_0_2_layer;        act0_0_3_layer <= act0_0_3_layer;
            act0_0_4_layer <= act0_0_4_layer;        act0_0_5_layer <= act0_0_5_layer;
            act0_0_6_layer <= act0_0_6_layer;        act0_0_7_layer <= act0_0_7_layer;

            act0_1_0_layer <= act0_1_0_layer;        act0_1_1_layer <= act0_1_1_layer;
            act0_1_2_layer <= act0_1_2_layer;        act0_1_3_layer <= act0_1_3_layer;
            act0_1_4_layer <= act0_1_4_layer;        act0_1_5_layer <= act0_1_5_layer;
            act0_1_6_layer <= act0_1_6_layer;        act0_1_7_layer <= act0_1_7_layer;

            act1_0_0_layer <= act1_0_0_layer;        act1_0_1_layer <= act1_0_1_layer;
            act1_0_2_layer <= act1_0_2_layer;        act1_0_3_layer <= act1_0_3_layer;
            act1_0_4_layer <= act1_0_4_layer;        act1_0_5_layer <= act1_0_5_layer;
            act1_0_6_layer <= act1_0_6_layer;        act1_0_7_layer <= act1_0_7_layer;

            act1_1_0_layer <= act1_1_0_layer;        act1_1_1_layer <= act1_1_1_layer;
            act1_1_2_layer <= act1_1_2_layer;        act1_1_3_layer <= act1_1_3_layer;
            act1_1_4_layer <= act1_1_4_layer;        act1_1_5_layer <= act1_1_5_layer;
            act1_1_6_layer <= act1_1_6_layer;        act1_1_7_layer <= act1_1_7_layer;

            act2_0_0_layer <= act2_0_0_layer;        act2_0_1_layer <= act2_0_1_layer;
            act2_0_2_layer <= act2_0_2_layer;        act2_0_3_layer <= act2_0_3_layer;
            act2_0_4_layer <= act2_0_4_layer;        act2_0_5_layer <= act2_0_5_layer;
            act2_0_6_layer <= act2_0_6_layer;        act2_0_7_layer <= act2_0_7_layer;

            act2_1_0_layer <= act2_1_0_layer;        act2_1_1_layer <= act2_1_1_layer;
            act2_1_2_layer <= act2_1_2_layer;        act2_1_3_layer <= act2_1_3_layer;
            act2_1_4_layer <= act2_1_4_layer;        act2_1_5_layer <= act2_1_5_layer;
            act2_1_6_layer <= act2_1_6_layer;        act2_1_7_layer <= act2_1_7_layer;

            act3_0_0_layer <= act3_0_0_layer;        act3_0_1_layer <= act3_0_1_layer;
            act3_0_2_layer <= act3_0_2_layer;        act3_0_3_layer <= act3_0_3_layer;
            act3_0_4_layer <= act3_0_4_layer;        act3_0_5_layer <= act3_0_5_layer;
            act3_0_6_layer <= act3_0_6_layer;        act3_0_7_layer <= act3_0_7_layer;

            act3_1_0_layer <= act3_1_0_layer;        act3_1_1_layer <= act3_1_1_layer;
            act3_1_2_layer <= act3_1_2_layer;        act3_1_3_layer <= act3_1_3_layer;
            act3_1_4_layer <= act3_1_4_layer;        act3_1_5_layer <= act3_1_5_layer;
            act3_1_6_layer <= act3_1_6_layer;        act3_1_7_layer <= act3_1_7_layer;
  end
end

  //— Instantiate Layer (m1) 
  layer m1 (
    .clk                    (clk),
    .rst_n                  (rst_n),
    .start                  (start_layer),
    .done                   (done_layer),

    .inputs0_1              (inputs0_1),
    .inputs1_1              (inputs1_1),
    .inputs2_1              (inputs2_1),
    .inputs3_1              (inputs3_1),
    .inputs4_1              (inputs4_1),
    .inputs5_1              (inputs5_1),
    .inputs6_1              (inputs6_1),
    .inputs7_1              (inputs7_1),

// Updated port connections – every signal previously ending in _r is now suffixed _layer
    .act0_0_0               (act0_0_0_layer),
    .act0_0_1               (act0_0_1_layer),
    .act0_0_2               (act0_0_2_layer),
    .act0_0_3               (act0_0_3_layer),
    .act0_0_4               (act0_0_4_layer),
    .act0_0_5               (act0_0_5_layer),
    .act0_0_6               (act0_0_6_layer),
    .act0_0_7               (act0_0_7_layer),
    .act0_1_0               (act0_1_0_layer),
    .act0_1_1               (act0_1_1_layer),
    .act0_1_2               (act0_1_2_layer),
    .act0_1_3               (act0_1_3_layer),
    .act0_1_4               (act0_1_4_layer),
    .act0_1_5               (act0_1_5_layer),
    .act0_1_6               (act0_1_6_layer),
    .act0_1_7               (act0_1_7_layer),
    .act1_0_0               (act1_0_0_layer),
    .act1_0_1               (act1_0_1_layer),
    .act1_0_2               (act1_0_2_layer),
    .act1_0_3               (act1_0_3_layer),
    .act1_0_4               (act1_0_4_layer),
    .act1_0_5               (act1_0_5_layer),
    .act1_0_6               (act1_0_6_layer),
    .act1_0_7               (act1_0_7_layer),
    .act1_1_0               (act1_1_0_layer),
    .act1_1_1               (act1_1_1_layer),
    .act1_1_2               (act1_1_2_layer),
    .act1_1_3               (act1_1_3_layer),
    .act1_1_4               (act1_1_4_layer),
    .act1_1_5               (act1_1_5_layer),
    .act1_1_6               (act1_1_6_layer),
    .act1_1_7               (act1_1_7_layer),
    .act2_0_0               (act2_0_0_layer),
    .act2_0_1               (act2_0_1_layer),
    .act2_0_2               (act2_0_2_layer),
    .act2_0_3               (act2_0_3_layer),
    .act2_0_4               (act2_0_4_layer),
    .act2_0_5               (act2_0_5_layer),
    .act2_0_6               (act2_0_6_layer),
    .act2_0_7               (act2_0_7_layer),
    .act2_1_0               (act2_1_0_layer),
    .act2_1_1               (act2_1_1_layer),
    .act2_1_2               (act2_1_2_layer),
    .act2_1_3               (act2_1_3_layer),
    .act2_1_4               (act2_1_4_layer),
    .act2_1_5               (act2_1_5_layer),
    .act2_1_6               (act2_1_6_layer),
    .act2_1_7               (act2_1_7_layer),
    .act3_0_0               (act3_0_0_layer),
    .act3_0_1               (act3_0_1_layer),
    .act3_0_2               (act3_0_2_layer),
    .act3_0_3               (act3_0_3_layer),
    .act3_0_4               (act3_0_4_layer),
    .act3_0_5               (act3_0_5_layer),
    .act3_0_6               (act3_0_6_layer),
    .act3_0_7               (act3_0_7_layer),
    .act3_1_0               (act3_1_0_layer),
    .act3_1_1               (act3_1_1_layer),
    .act3_1_2               (act3_1_2_layer),
    .act3_1_3               (act3_1_3_layer),
    .act3_1_4               (act3_1_4_layer),
    .act3_1_5               (act3_1_5_layer),
    .act3_1_6               (act3_1_6_layer),
    .act3_1_7               (act3_1_7_layer),

    .w1_0_1                 (w1_0_1),
    .w1_1_1                 (w1_1_1),
    .w2_0_1                 (w2_0_1),
    .w2_1_1                 (w2_1_1),
    .w3_0_1                 (w3_0_1),
    .w3_1_1                 (w3_1_1),
    .w4_0_1                 (w4_0_1),
    .w4_1_1                 (w4_1_1),

    .b1_1                   (b1_1),
    .b2_1                   (b2_1),
    .b3_1                   (b3_1),
    .b4_1                   (b4_1),
    .b1_2                   (b1_2),
    .b2_2                   (b2_2),
    .b3_2                   (b3_2),
    .b4_2                   (b4_2),
    .b1_3                   (b1_3),
    .b2_3                   (b2_3),
    .b3_3                   (b3_3),
    .b4_3                   (b4_3),
    .b1_4                   (b1_4),
    .b2_4                   (b2_4),
    .b3_4                   (b3_4),
    .b4_4                   (b4_4),

    .s                      (s_count),

    .biased_sum0_0_r        (biased_sum0_0),
    .biased_sum0_0bar_r     (biased_sum0_0bar),
    .biased_sum0_1_r        (biased_sum0_1),
    .biased_sum0_1bar_r     (biased_sum0_1bar),
    .biased_sum1_0_r        (biased_sum1_0),
    .biased_sum1_0bar_r     (biased_sum1_0bar),
    .biased_sum1_1_r        (biased_sum1_1),
    .biased_sum1_1bar_r     (biased_sum1_1bar),
    .biased_sum2_0_r        (biased_sum2_0),
    .biased_sum2_0bar_r     (biased_sum2_0bar),
    .biased_sum2_1_r        (biased_sum2_1),
    .biased_sum2_1bar_r     (biased_sum2_1bar),
    .biased_sum3_0_r        (biased_sum3_0),
    .biased_sum3_0bar_r     (biased_sum3_0bar),
    .biased_sum3_1_r        (biased_sum3_1),
    .biased_sum3_1bar_r     (biased_sum3_1bar),

    .masked_activation0_1_r (masked_activation0_1),
    .masked_activation1_1_r (masked_activation1_1),
    .masked_activation2_1_r (masked_activation2_1),
    .masked_activation3_1_r (masked_activation3_1),
    .masked_activation0bar_1_r (masked_activation0bar_1),
    .masked_activation1bar_1_r (masked_activation1bar_1),
    .masked_activation2bar_1_r (masked_activation2bar_1),
    .masked_activation3bar_1_r (masked_activation3bar_1),

    .mask0_1_r              (mask0_1),
    .mask1_1_r              (mask1_1),
    .mask2_1_r              (mask2_1),
    .mask3_1_r              (mask3_1),
    .mask0bar_1_r           (mask0bar_1),
    .mask1bar_1_r           (mask1bar_1),
    .mask2bar_1_r           (mask2bar_1),
    .mask3bar_1_r           (mask3bar_1)
  );

  //— Instantiate Share (m2) —
  share_boolean_arithmetic m2 (
    .clk                    (clk),
    .rst_n                  (rst_n),
    .start                  (start_share),
    .done                   (done_share),

    .masked_activation0_1   (masked_activation0_1),
    .masked_activation1_1   (masked_activation1_1),
    .masked_activation2_1   (masked_activation2_1),
    .masked_activation3_1   (masked_activation3_1),
    .mask0_1                (mask0_1),
    .mask1_1                (mask1_1),
    .mask2_1                (mask2_1),
    .mask3_1                (mask3_1),

    .w1_0_2                 (w1_0_2),
    .w1_1_2                 (w1_1_2),
    .w2_0_2                 (w2_0_2),
    .w2_1_2                 (w2_1_2),
    .w3_0_2                 (w3_0_2),
    .w3_1_2                 (w3_1_2),
    .w4_0_2                 (w4_0_2),
    .w4_1_2                 (w4_1_2),
    .w1_0_3                 (w1_0_3),
    .w1_1_3                 (w1_1_3),
    .w2_0_3                 (w2_0_3),
    .w2_1_3                 (w2_1_3),
    .w3_0_3                 (w3_0_3),
    .w3_1_3                 (w3_1_3),
    .w4_0_3                 (w4_0_3),
    .w4_1_3                 (w4_1_3),
    .w1_0_4                 (w1_0_4),
    .w1_1_4                 (w1_1_4),
    .w2_0_4                 (w2_0_4),
    .w2_1_4                 (w2_1_4),
    .w3_0_4                 (w3_0_4),
    .w3_1_4                 (w3_1_4),
    .w4_0_4                 (w4_0_4),
    .w4_1_4                 (w4_1_4),

    .s                      (s_count),

    .act0_0_0_r             (act0_0_0_r),
    .act0_0_1_r             (act0_0_1_r),
    .act0_0_2_r             (act0_0_2_r),
    .act0_0_3_r             (act0_0_3_r),
    .act0_0_4_r             (act0_0_4_r),
    .act0_0_5_r             (act0_0_5_r),
    .act0_0_6_r             (act0_0_6_r),
    .act0_0_7_r             (act0_0_7_r),
    .act0_1_0_r             (act0_1_0_r),
    .act0_1_1_r             (act0_1_1_r),
    .act0_1_2_r             (act0_1_2_r),
    .act0_1_3_r             (act0_1_3_r),
    .act0_1_4_r             (act0_1_4_r),
    .act0_1_5_r             (act0_1_5_r),
    .act0_1_6_r             (act0_1_6_r),
    .act0_1_7_r             (act0_1_7_r),
    .act1_0_0_r             (act1_0_0_r),
    .act1_0_1_r             (act1_0_1_r),
    .act1_0_2_r             (act1_0_2_r),
    .act1_0_3_r             (act1_0_3_r),
    .act1_0_4_r             (act1_0_4_r),
    .act1_0_5_r             (act1_0_5_r),
    .act1_0_6_r             (act1_0_6_r),
    .act1_0_7_r             (act1_0_7_r),
    .act1_1_0_r             (act1_1_0_r),
    .act1_1_1_r             (act1_1_1_r),
    .act1_1_2_r             (act1_1_2_r),
    .act1_1_3_r             (act1_1_3_r),
    .act1_1_4_r             (act1_1_4_r),
    .act1_1_5_r             (act1_1_5_r),
    .act1_1_6_r             (act1_1_6_r),
    .act1_1_7_r             (act1_1_7_r),
    .act2_0_0_r             (act2_0_0_r),
    .act2_0_1_r             (act2_0_1_r),
    .act2_0_2_r             (act2_0_2_r),
    .act2_0_3_r             (act2_0_3_r),
    .act2_0_4_r             (act2_0_4_r),
    .act2_0_5_r             (act2_0_5_r),
    .act2_0_6_r             (act2_0_6_r),
    .act2_0_7_r             (act2_0_7_r),
    .act2_1_0_r             (act2_1_0_r),
    .act2_1_1_r             (act2_1_1_r),
    .act2_1_2_r             (act2_1_2_r),
    .act2_1_3_r             (act2_1_3_r),
    .act2_1_4_r             (act2_1_4_r),
    .act2_1_5_r             (act2_1_5_r),
    .act2_1_6_r             (act2_1_6_r),
    .act2_1_7_r             (act2_1_7_r),
    .act3_0_0_r             (act3_0_0_r),
    .act3_0_1_r             (act3_0_1_r),
    .act3_0_2_r             (act3_0_2_r),
    .act3_0_3_r             (act3_0_3_r),
    .act3_0_4_r             (act3_0_4_r),
    .act3_0_5_r             (act3_0_5_r),
    .act3_0_6_r             (act3_0_6_r),
    .act3_0_7_r             (act3_0_7_r),
    .act3_1_0_r             (act3_1_0_r),
    .act3_1_1_r             (act3_1_1_r),
    .act3_1_2_r             (act3_1_2_r),
    .act3_1_3_r             (act3_1_3_r),
    .act3_1_4_r             (act3_1_4_r),
    .act3_1_5_r             (act3_1_5_r),
    .act3_1_6_r             (act3_1_6_r),
    .act3_1_7_r             (act3_1_7_r)
  );

  output_layer dut (
    .biased_sum0_0    (biased_sum0_0),
    .biased_sum0_1    (biased_sum0_1),
    .biased_sum1_0    (biased_sum1_0),
    .biased_sum1_1    (biased_sum1_1),
    .biased_sum0_0bar (biased_sum0_0bar),
    .biased_sum0_1bar (biased_sum0_1bar),
    .biased_sum1_0bar (biased_sum1_0bar),
    .biased_sum1_1bar (biased_sum1_1bar),
    .a0               (a0),
    .a1               (a1),
    .a0_bar           (a0_bar),
    .a1_bar           (a1_bar)
  );

endmodule
