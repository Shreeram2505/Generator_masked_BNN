
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

module add3bit(
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNAND wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout;

endmodule

module add4bit(
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNAND wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout;

endmodule

module add5bit(
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNAND wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout;

endmodule

module add6bit(
    input wire [5:0] a,
    input wire [5:0] b,
    input wire  cin,
    output wire [6:0] y,
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNAND wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout;

endmodule

module add7bit(
    input wire [6:0] a,
    input wire [6:0] b,
    input wire  cin,
    output wire [7:0] y,
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

full_adder fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));

WddlNAND wn1(.A(~a[6]), .B(b[6]), .C(~c7), .S(s1), .S1(s1_1));
WddlNAND wn2(.A(a[6]), .B(~b[6]), .C(~c7), .S(s2), .S1(s2_1));
WddlNAND wn3(.A(a[6]), .B(b[6]), .C(c7), .S(s3), .S1(s3_1));
WddlNAND wn4(.A(~a[6]), .B(~b[6]), .C(c7), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[7] = cout;

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

module add3bitbar(
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNANDbar wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout_bar;

endmodule

module add4bitbar(
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNANDbar wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout_bar;

endmodule

module add5bitbar(
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNANDbar wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout_bar;

endmodule

module add6bitbar(
    input wire [5:0] a,
    input wire [5:0] b,
    input wire  cin,
    output wire [6:0] y,
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNANDbar wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout_bar;

endmodule

module add7bitbar(
    input wire [6:0] a,
    input wire [6:0] b,
    input wire  cin,
    output wire [7:0] y,
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

full_adderbar fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));

WddlNANDbar wn1(.A(~a[6]), .B(b[6]), .C(~c7), .S(s1), .S1(s1_1));
WddlNANDbar wn2(.A(a[6]), .B(~b[6]), .C(~c7), .S(s2), .S1(s2_1));
WddlNANDbar wn3(.A(a[6]), .B(b[6]), .C(c7), .S(s3), .S1(s3_1));
WddlNANDbar wn4(.A(~a[6]), .B(~b[6]), .C(c7), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[7] = cout_bar;

endmodule



module adder_tree (
    input  wire   clk, 
    input  wire [2:0] in0,
    input  wire [2:0] in1,
    input  wire [2:0] in2,
    input  wire [2:0] in3,
    input  wire [2:0] in4,
    input  wire [2:0] in5,
    input  wire [2:0] in6,
    input  wire [2:0] in7,
    input  wire [2:0] in8,
    input  wire [2:0] in9,
    input  wire [2:0] in10,
    input  wire [2:0] in11,
    input  wire [2:0] in12,
    input  wire [2:0] in13,
    input  wire [2:0] in14,
    input  wire [2:0] in15,
    output wire [6:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [3:0] stage0_4_lo;
    wire [3:0] stage0_5_lo;
    wire [3:0] stage0_6_lo;
    wire [3:0] stage0_7_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [4:0] stage1_2_lo;
    wire [4:0] stage1_3_lo;
    wire [5:0] stage2_0_lo;
    wire [5:0] stage2_1_lo;
    wire [6:0] stage3_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [3:0] stage0_4;
    reg  [3:0] stage0_5;
    reg  [3:0] stage0_6;
    reg  [3:0] stage0_7;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [4:0] stage1_2;
    reg  [4:0] stage1_3;
    reg  [5:0] stage2_0;
    reg  [5:0] stage2_1;
    reg  [6:0] stage3_0;

    add3bit u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bit u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bit u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bit u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add3bit u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo), .cout(), .cout_bar());
    add3bit u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo), .cout(), .cout_bar());
    add3bit u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo), .cout(), .cout_bar());
    add3bit u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo), .cout(), .cout_bar());
    add4bit u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bit u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add4bit u1_2 (.a(stage0_4), .b(stage0_5), .cin(1'b0), .y(stage1_2_lo), .cout(), .cout_bar());
    add4bit u1_3 (.a(stage0_6), .b(stage0_7), .cin(1'b0), .y(stage1_3_lo), .cout(), .cout_bar());
    add5bit u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());
    add5bit u2_1 (.a(stage1_2), .b(stage1_3), .cin(1'b0), .y(stage2_1_lo), .cout(), .cout_bar());
    add6bit u3_0 (.a(stage2_0), .b(stage2_1), .cin(1'b0), .y(stage3_0_lo), .cout(), .cout_bar());

    assign sum =  stage3_0_lo;

    always @(posedge clk) begin
        stage0_0 <=  stage0_0_lo;
        stage0_1 <=  stage0_1_lo;
        stage0_2 <=  stage0_2_lo;
        stage0_3 <=  stage0_3_lo;
        stage0_4 <=  stage0_4_lo;
        stage0_5 <=  stage0_5_lo;
        stage0_6 <=  stage0_6_lo;
        stage0_7 <=  stage0_7_lo;
        stage1_0 <=  stage1_0_lo;
        stage1_1 <=  stage1_1_lo;
        stage1_2 <=  stage1_2_lo;
        stage1_3 <=  stage1_3_lo;
        stage2_0 <=  stage2_0_lo;
        stage2_1 <=  stage2_1_lo;
        stage3_0 <=  stage3_0_lo;
    end
endmodule


module adder_tree_bar (
    input  wire   clk, 
    input  wire [2:0] in0,
    input  wire [2:0] in1,
    input  wire [2:0] in2,
    input  wire [2:0] in3,
    input  wire [2:0] in4,
    input  wire [2:0] in5,
    input  wire [2:0] in6,
    input  wire [2:0] in7,
    input  wire [2:0] in8,
    input  wire [2:0] in9,
    input  wire [2:0] in10,
    input  wire [2:0] in11,
    input  wire [2:0] in12,
    input  wire [2:0] in13,
    input  wire [2:0] in14,
    input  wire [2:0] in15,
    output wire [6:0] sum
);

    wire [3:0] stage0_0_lo_bar;
    wire [3:0] stage0_1_lo_bar;
    wire [3:0] stage0_2_lo_bar;
    wire [3:0] stage0_3_lo_bar;
    wire [3:0] stage0_4_lo_bar;
    wire [3:0] stage0_5_lo_bar;
    wire [3:0] stage0_6_lo_bar;
    wire [3:0] stage0_7_lo_bar;
    wire [4:0] stage1_0_lo_bar;
    wire [4:0] stage1_1_lo_bar;
    wire [4:0] stage1_2_lo_bar;
    wire [4:0] stage1_3_lo_bar;
    wire [5:0] stage2_0_lo_bar;
    wire [5:0] stage2_1_lo_bar;
    wire [6:0] stage3_0_lo_bar;
    reg  [3:0] stage0_0_bar;
    reg  [3:0] stage0_1_bar;
    reg  [3:0] stage0_2_bar;
    reg  [3:0] stage0_3_bar;
    reg  [3:0] stage0_4_bar;
    reg  [3:0] stage0_5_bar;
    reg  [3:0] stage0_6_bar;
    reg  [3:0] stage0_7_bar;
    reg  [4:0] stage1_0_bar;
    reg  [4:0] stage1_1_bar;
    reg  [4:0] stage1_2_bar;
    reg  [4:0] stage1_3_bar;
    reg  [5:0] stage2_0_bar;
    reg  [5:0] stage2_1_bar;
    reg  [6:0] stage3_0_bar;

    add3bitbar u0_0_bar (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_bar), .cout(), .cout_bar());
    add3bitbar u0_1_bar (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_bar), .cout(), .cout_bar());
    add3bitbar u0_2_bar (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_bar), .cout(), .cout_bar());
    add3bitbar u0_3_bar (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_bar), .cout(), .cout_bar());
    add3bitbar u0_4_bar (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_bar), .cout(), .cout_bar());
    add3bitbar u0_5_bar (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_bar), .cout(), .cout_bar());
    add3bitbar u0_6_bar (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_bar), .cout(), .cout_bar());
    add3bitbar u0_7_bar (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_bar), .cout(), .cout_bar());
    add4bitbar u1_0_bar (.a(stage0_0_bar), .b(stage0_1_bar), .cin(1'b0), .y(stage1_0_lo_bar), .cout(), .cout_bar());
    add4bitbar u1_1_bar (.a(stage0_2_bar), .b(stage0_3_bar), .cin(1'b0), .y(stage1_1_lo_bar), .cout(), .cout_bar());
    add4bitbar u1_2_bar (.a(stage0_4_bar), .b(stage0_5_bar), .cin(1'b0), .y(stage1_2_lo_bar), .cout(), .cout_bar());
    add4bitbar u1_3_bar (.a(stage0_6_bar), .b(stage0_7_bar), .cin(1'b0), .y(stage1_3_lo_bar), .cout(), .cout_bar());
    add5bitbar u2_0_bar (.a(stage1_0_bar), .b(stage1_1_bar), .cin(1'b0), .y(stage2_0_lo_bar), .cout(), .cout_bar());
    add5bitbar u2_1_bar (.a(stage1_2_bar), .b(stage1_3_bar), .cin(1'b0), .y(stage2_1_lo_bar), .cout(), .cout_bar());
    add6bitbar u3_0_bar (.a(stage2_0_bar), .b(stage2_1_bar), .cin(1'b0), .y(stage3_0_lo_bar), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_bar;

    always @(posedge clk) begin
        stage0_0_bar <=  stage0_0_lo_bar;
        stage0_1_bar <=  stage0_1_lo_bar;
        stage0_2_bar <=  stage0_2_lo_bar;
        stage0_3_bar <=  stage0_3_lo_bar;
        stage0_4_bar <=  stage0_4_lo_bar;
        stage0_5_bar <=  stage0_5_lo_bar;
        stage0_6_bar <=  stage0_6_lo_bar;
        stage0_7_bar <=  stage0_7_lo_bar;
        stage1_0_bar <=  stage1_0_lo_bar;
        stage1_1_bar <=  stage1_1_lo_bar;
        stage1_2_bar <=  stage1_2_lo_bar;
        stage1_3_bar <=  stage1_3_lo_bar;
        stage2_0_bar <=  stage2_0_lo_bar;
        stage2_1_bar <=  stage2_1_lo_bar;
        stage3_0_bar <=  stage3_0_lo_bar;
    end
endmodule

module mux_5(
    input  [6:0] a,
    input  [6:0] b,
    input  [6:0] c,
    input  [6:0] d,
    input        s0,
    input        s1,
    output [6:0] y
);
    assign y = (!s1 && !s0) ? a :
               (!s1 &&  s0) ? b :
               ( s1 && !s0) ? c :
                              d;
endmodule

module activation (

    input [7:0] inputs0_0,
    input [7:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6, r7, r8;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0, masked_c6_0, masked_c7_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0), .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0), .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0), .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0), .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0), .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0), .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));
    lut1 l6 (.a(inputs0_0[6]), .b(inputs0_1[6]), .c_in(masked_c5_0), .r_flow(r6), .r_i(r6_0), .r_out(r7), .c_masked(masked_c6_0));
    lut1 l7 (.a(inputs0_0[7]), .b(inputs0_1[7]), .c_in(masked_c6_0), .r_flow(r7), .r_i(r7_0), .r_out(r8), .c_masked(masked_c7_0));

    wire carry = r8 ^ masked_c7_0;
    wire activation = (carry ^ inputs0_0[7] ^ inputs0_1[7]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r8;
    assign mask = r8;

endmodule

module activation_array_1 (
    input  [7:0] inputs0_0, inputs0_1,
    input  [7:0] inputs1_0, inputs1_1,
    input  [7:0] inputs2_0, inputs2_1,
    input  [7:0] inputs3_0, inputs3_1,
    input  [7:0] inputs4_0, inputs4_1,
    input  [7:0] inputs5_0, inputs5_1,
    input  [7:0] inputs6_0, inputs6_1,
    input  [7:0] inputs7_0, inputs7_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1, r6_1, r7_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2, r7_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3, r6_3, r7_3,
    input  r0_4, r1_4, r2_4, r3_4, r4_4, r5_4, r6_4, r7_4,
    input  r0_5, r1_5, r2_5, r3_5, r4_5, r5_5, r6_5, r7_5,
    input  r0_6, r1_6, r2_6, r3_6, r4_6, r5_6, r6_6, r7_6,
    input  r0_7, r1_7, r2_7, r3_7, r4_7, r5_7, r6_7, r7_7,
    output wire masked_activation0,
    output wire masked_activation1,
    output wire masked_activation2,
    output wire masked_activation3,
    output wire masked_activation4,
    output wire masked_activation5,
    output wire masked_activation6,
    output wire masked_activation7,
    output wire mask0,
    output wire mask1,
    output wire mask2,
    output wire mask3,
    output wire mask4,
    output wire mask5,
    output wire mask6,
    output wire mask7
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
        .masked_activation(masked_activation3),
        .mask(mask3)
    );

    activation a4 (
        .inputs0_0(inputs4_0), .inputs0_1(inputs4_1),
        .r0_0(r0_4),
        .r1_0(r1_4),
        .r2_0(r2_4),
        .r3_0(r3_4),
        .r4_0(r4_4),
        .r5_0(r5_4),
        .r6_0(r6_4),
        .r7_0(r7_4),
        .masked_activation(masked_activation4),
        .mask(mask4)
    );

    activation a5 (
        .inputs0_0(inputs5_0), .inputs0_1(inputs5_1),
        .r0_0(r0_5),
        .r1_0(r1_5),
        .r2_0(r2_5),
        .r3_0(r3_5),
        .r4_0(r4_5),
        .r5_0(r5_5),
        .r6_0(r6_5),
        .r7_0(r7_5),
        .masked_activation(masked_activation5),
        .mask(mask5)
    );

    activation a6 (
        .inputs0_0(inputs6_0), .inputs0_1(inputs6_1),
        .r0_0(r0_6),
        .r1_0(r1_6),
        .r2_0(r2_6),
        .r3_0(r3_6),
        .r4_0(r4_6),
        .r5_0(r5_6),
        .r6_0(r6_6),
        .r7_0(r7_6),
        .masked_activation(masked_activation6),
        .mask(mask6)
    );

    activation a7 (
        .inputs0_0(inputs7_0), .inputs0_1(inputs7_1),
        .r0_0(r0_7),
        .r1_0(r1_7),
        .r2_0(r2_7),
        .r3_0(r3_7),
        .r4_0(r4_7),
        .r5_0(r5_7),
        .r6_0(r6_7),
        .r7_0(r7_7),
        .masked_activation(masked_activation7),
        .mask(mask7)
    );

endmodule

module layer (
  input wire  clk,
  input wire  rst_n,
  input wire  start,
  input wire [2:0] inputs0_1, inputs1_1, inputs2_1, inputs3_1, inputs4_1, inputs5_1, inputs6_1, inputs7_1, inputs8_1, inputs9_1, inputs10_1, inputs11_1, inputs12_1, inputs13_1, inputs14_1, inputs15_1,
  input wire [2:0] act0_0_0, act0_0_1, act0_0_2, act0_0_3, act0_0_4, act0_0_5, act0_0_6, act0_0_7, act0_0_8, act0_0_9, act0_0_10, act0_0_11, act0_0_12, act0_0_13, act0_0_14, act0_0_15,
  input wire [2:0] act0_1_0, act0_1_1, act0_1_2, act0_1_3, act0_1_4, act0_1_5, act0_1_6, act0_1_7, act0_1_8, act0_1_9, act0_1_10, act0_1_11, act0_1_12, act0_1_13, act0_1_14, act0_1_15,
  input wire [2:0] act1_0_0, act1_0_1, act1_0_2, act1_0_3, act1_0_4, act1_0_5, act1_0_6, act1_0_7, act1_0_8, act1_0_9, act1_0_10, act1_0_11, act1_0_12, act1_0_13, act1_0_14, act1_0_15,
  input wire [2:0] act1_1_0, act1_1_1, act1_1_2, act1_1_3, act1_1_4, act1_1_5, act1_1_6, act1_1_7, act1_1_8, act1_1_9, act1_1_10, act1_1_11, act1_1_12, act1_1_13, act1_1_14, act1_1_15,
  input wire [2:0] act2_0_0, act2_0_1, act2_0_2, act2_0_3, act2_0_4, act2_0_5, act2_0_6, act2_0_7, act2_0_8, act2_0_9, act2_0_10, act2_0_11, act2_0_12, act2_0_13, act2_0_14, act2_0_15,
  input wire [2:0] act2_1_0, act2_1_1, act2_1_2, act2_1_3, act2_1_4, act2_1_5, act2_1_6, act2_1_7, act2_1_8, act2_1_9, act2_1_10, act2_1_11, act2_1_12, act2_1_13, act2_1_14, act2_1_15,
  input wire [2:0] act3_0_0, act3_0_1, act3_0_2, act3_0_3, act3_0_4, act3_0_5, act3_0_6, act3_0_7, act3_0_8, act3_0_9, act3_0_10, act3_0_11, act3_0_12, act3_0_13, act3_0_14, act3_0_15,
  input wire [2:0] act3_1_0, act3_1_1, act3_1_2, act3_1_3, act3_1_4, act3_1_5, act3_1_6, act3_1_7, act3_1_8, act3_1_9, act3_1_10, act3_1_11, act3_1_12, act3_1_13, act3_1_14, act3_1_15,
  input wire [2:0] act4_0_0, act4_0_1, act4_0_2, act4_0_3, act4_0_4, act4_0_5, act4_0_6, act4_0_7, act4_0_8, act4_0_9, act4_0_10, act4_0_11, act4_0_12, act4_0_13, act4_0_14, act4_0_15,
  input wire [2:0] act4_1_0, act4_1_1, act4_1_2, act4_1_3, act4_1_4, act4_1_5, act4_1_6, act4_1_7, act4_1_8, act4_1_9, act4_1_10, act4_1_11, act4_1_12, act4_1_13, act4_1_14, act4_1_15,
  input wire [2:0] act5_0_0, act5_0_1, act5_0_2, act5_0_3, act5_0_4, act5_0_5, act5_0_6, act5_0_7, act5_0_8, act5_0_9, act5_0_10, act5_0_11, act5_0_12, act5_0_13, act5_0_14, act5_0_15,
  input wire [2:0] act5_1_0, act5_1_1, act5_1_2, act5_1_3, act5_1_4, act5_1_5, act5_1_6, act5_1_7, act5_1_8, act5_1_9, act5_1_10, act5_1_11, act5_1_12, act5_1_13, act5_1_14, act5_1_15,
  input wire [2:0] act6_0_0, act6_0_1, act6_0_2, act6_0_3, act6_0_4, act6_0_5, act6_0_6, act6_0_7, act6_0_8, act6_0_9, act6_0_10, act6_0_11, act6_0_12, act6_0_13, act6_0_14, act6_0_15,
  input wire [2:0] act6_1_0, act6_1_1, act6_1_2, act6_1_3, act6_1_4, act6_1_5, act6_1_6, act6_1_7, act6_1_8, act6_1_9, act6_1_10, act6_1_11, act6_1_12, act6_1_13, act6_1_14, act6_1_15,
  input wire [2:0] act7_0_0, act7_0_1, act7_0_2, act7_0_3, act7_0_4, act7_0_5, act7_0_6, act7_0_7, act7_0_8, act7_0_9, act7_0_10, act7_0_11, act7_0_12, act7_0_13, act7_0_14, act7_0_15,
  input wire [2:0] act7_1_0, act7_1_1, act7_1_2, act7_1_3, act7_1_4, act7_1_5, act7_1_6, act7_1_7, act7_1_8, act7_1_9, act7_1_10, act7_1_11, act7_1_12, act7_1_13, act7_1_14, act7_1_15,
  input wire [15:0] w1_0_1, w1_1_1,
  input wire [15:0] w2_0_1, w2_1_1,
  input wire [15:0] w3_0_1, w3_1_1,
  input wire [15:0] w4_0_1, w4_1_1,
  input wire [15:0] w5_0_1, w5_1_1,
  input wire [15:0] w6_0_1, w6_1_1,
  input wire [15:0] w7_0_1, w7_1_1,
  input wire [15:0] w8_0_1, w8_1_1,
  input wire [6:0] b1_1, b1_2, b1_3, b1_4,
  input wire [6:0] b2_1, b2_2, b2_3, b2_4,
  input wire [6:0] b3_1, b3_2, b3_3, b3_4,
  input wire [6:0] b4_1, b4_2, b4_3, b4_4,
  input wire [6:0] b5_1, b5_2, b5_3, b5_4,
  input wire [6:0] b6_1, b6_2, b6_3, b6_4,
  input wire [6:0] b7_1, b7_2, b7_3, b7_4,
  input wire [6:0] b8_1, b8_2, b8_3, b8_4,
  input wire [1:0] s,
  output reg  done,
  output reg [7:0] biased_sum0_0_r, biased_sum0_1_r, biased_sum0_0bar_r, biased_sum0_1bar_r,
  output reg [7:0] biased_sum1_0_r, biased_sum1_1_r, biased_sum1_0bar_r, biased_sum1_1bar_r,
  output reg [7:0] biased_sum2_0_r, biased_sum2_1_r, biased_sum2_0bar_r, biased_sum2_1bar_r,
  output reg [7:0] biased_sum3_0_r, biased_sum3_1_r, biased_sum3_0bar_r, biased_sum3_1bar_r,
  output reg [7:0] biased_sum4_0_r, biased_sum4_1_r, biased_sum4_0bar_r, biased_sum4_1bar_r,
  output reg [7:0] biased_sum5_0_r, biased_sum5_1_r, biased_sum5_0bar_r, biased_sum5_1bar_r,
  output reg [7:0] biased_sum6_0_r, biased_sum6_1_r, biased_sum6_0bar_r, biased_sum6_1bar_r,
  output reg [7:0] biased_sum7_0_r, biased_sum7_1_r, biased_sum7_0bar_r, biased_sum7_1bar_r,
  output reg  masked_activation0_1_r, masked_activation0bar_1_r,
  output reg  masked_activation1_1_r, masked_activation1bar_1_r,
  output reg  masked_activation2_1_r, masked_activation2bar_1_r,
  output reg  masked_activation3_1_r, masked_activation3bar_1_r,
  output reg  masked_activation4_1_r, masked_activation4bar_1_r,
  output reg  masked_activation5_1_r, masked_activation5bar_1_r,
  output reg  masked_activation6_1_r, masked_activation6bar_1_r,
  output reg  masked_activation7_1_r, masked_activation7bar_1_r,
  output reg  mask0_1_r, mask0bar_1_r,
  output reg  mask1_1_r, mask1bar_1_r,
  output reg  mask2_1_r, mask2bar_1_r,
  output reg  mask3_1_r, mask3bar_1_r,
  output reg  mask4_1_r, mask4bar_1_r,
  output reg  mask5_1_r, mask5bar_1_r,
  output reg  mask6_1_r, mask6bar_1_r,
  output reg  mask7_1_r, mask7bar_1_r
);

  // internal wires
  wire [7:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar;
  wire masked_activation0_1, masked_activation0bar_1;
  wire mask0_1, mask0bar_1;
  wire [7:0] biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar;
  wire masked_activation1_1, masked_activation1bar_1;
  wire mask1_1, mask1bar_1;
  wire [7:0] biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar;
  wire masked_activation2_1, masked_activation2bar_1;
  wire mask2_1, mask2bar_1;
  wire [7:0] biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar;
  wire masked_activation3_1, masked_activation3bar_1;
  wire mask3_1, mask3bar_1;
  wire [7:0] biased_sum4_0, biased_sum4_1, biased_sum4_0bar, biased_sum4_1bar;
  wire masked_activation4_1, masked_activation4bar_1;
  wire mask4_1, mask4bar_1;
  wire [7:0] biased_sum5_0, biased_sum5_1, biased_sum5_0bar, biased_sum5_1bar;
  wire masked_activation5_1, masked_activation5bar_1;
  wire mask5_1, mask5bar_1;
  wire [7:0] biased_sum6_0, biased_sum6_1, biased_sum6_0bar, biased_sum6_1bar;
  wire masked_activation6_1, masked_activation6bar_1;
  wire mask6_1, mask6bar_1;
  wire [7:0] biased_sum7_0, biased_sum7_1, biased_sum7_0bar, biased_sum7_1bar;
  wire masked_activation7_1, masked_activation7bar_1;
  wire mask7_1, mask7bar_1;
  

  wire [2:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
  wire [2:0] new_weighted_inputs1_0_0, new_weighted_inputs1_0_1;
  wire [2:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
  wire [2:0] new_weighted_inputs1_1_0, new_weighted_inputs1_1_1;
  wire [2:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
  wire [2:0] new_weighted_inputs1_2_0, new_weighted_inputs1_2_1;
  wire [2:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
  wire [2:0] new_weighted_inputs1_3_0, new_weighted_inputs1_3_1;
  wire [2:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
  wire [2:0] new_weighted_inputs1_4_0, new_weighted_inputs1_4_1;
  wire [2:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
  wire [2:0] new_weighted_inputs1_5_0, new_weighted_inputs1_5_1;
  wire [2:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
  wire [2:0] new_weighted_inputs1_6_0, new_weighted_inputs1_6_1;
  wire [2:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
  wire [2:0] new_weighted_inputs1_7_0, new_weighted_inputs1_7_1;
  wire [2:0] weighted_inputs1_8_0, weighted_inputs1_8_1;
  wire [2:0] new_weighted_inputs1_8_0, new_weighted_inputs1_8_1;
  wire [2:0] weighted_inputs1_9_0, weighted_inputs1_9_1;
  wire [2:0] new_weighted_inputs1_9_0, new_weighted_inputs1_9_1;
  wire [2:0] weighted_inputs1_10_0, weighted_inputs1_10_1;
  wire [2:0] new_weighted_inputs1_10_0, new_weighted_inputs1_10_1;
  wire [2:0] weighted_inputs1_11_0, weighted_inputs1_11_1;
  wire [2:0] new_weighted_inputs1_11_0, new_weighted_inputs1_11_1;
  wire [2:0] weighted_inputs1_12_0, weighted_inputs1_12_1;
  wire [2:0] new_weighted_inputs1_12_0, new_weighted_inputs1_12_1;
  wire [2:0] weighted_inputs1_13_0, weighted_inputs1_13_1;
  wire [2:0] new_weighted_inputs1_13_0, new_weighted_inputs1_13_1;
  wire [2:0] weighted_inputs1_14_0, weighted_inputs1_14_1;
  wire [2:0] new_weighted_inputs1_14_0, new_weighted_inputs1_14_1;
  wire [2:0] weighted_inputs1_15_0, weighted_inputs1_15_1;
  wire [2:0] new_weighted_inputs1_15_0, new_weighted_inputs1_15_1;
  wire [2:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
  wire [2:0] new_weighted_inputs2_0_0, new_weighted_inputs2_0_1;
  wire [2:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
  wire [2:0] new_weighted_inputs2_1_0, new_weighted_inputs2_1_1;
  wire [2:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
  wire [2:0] new_weighted_inputs2_2_0, new_weighted_inputs2_2_1;
  wire [2:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
  wire [2:0] new_weighted_inputs2_3_0, new_weighted_inputs2_3_1;
  wire [2:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
  wire [2:0] new_weighted_inputs2_4_0, new_weighted_inputs2_4_1;
  wire [2:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
  wire [2:0] new_weighted_inputs2_5_0, new_weighted_inputs2_5_1;
  wire [2:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
  wire [2:0] new_weighted_inputs2_6_0, new_weighted_inputs2_6_1;
  wire [2:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
  wire [2:0] new_weighted_inputs2_7_0, new_weighted_inputs2_7_1;
  wire [2:0] weighted_inputs2_8_0, weighted_inputs2_8_1;
  wire [2:0] new_weighted_inputs2_8_0, new_weighted_inputs2_8_1;
  wire [2:0] weighted_inputs2_9_0, weighted_inputs2_9_1;
  wire [2:0] new_weighted_inputs2_9_0, new_weighted_inputs2_9_1;
  wire [2:0] weighted_inputs2_10_0, weighted_inputs2_10_1;
  wire [2:0] new_weighted_inputs2_10_0, new_weighted_inputs2_10_1;
  wire [2:0] weighted_inputs2_11_0, weighted_inputs2_11_1;
  wire [2:0] new_weighted_inputs2_11_0, new_weighted_inputs2_11_1;
  wire [2:0] weighted_inputs2_12_0, weighted_inputs2_12_1;
  wire [2:0] new_weighted_inputs2_12_0, new_weighted_inputs2_12_1;
  wire [2:0] weighted_inputs2_13_0, weighted_inputs2_13_1;
  wire [2:0] new_weighted_inputs2_13_0, new_weighted_inputs2_13_1;
  wire [2:0] weighted_inputs2_14_0, weighted_inputs2_14_1;
  wire [2:0] new_weighted_inputs2_14_0, new_weighted_inputs2_14_1;
  wire [2:0] weighted_inputs2_15_0, weighted_inputs2_15_1;
  wire [2:0] new_weighted_inputs2_15_0, new_weighted_inputs2_15_1;
  wire [2:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
  wire [2:0] new_weighted_inputs3_0_0, new_weighted_inputs3_0_1;
  wire [2:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
  wire [2:0] new_weighted_inputs3_1_0, new_weighted_inputs3_1_1;
  wire [2:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
  wire [2:0] new_weighted_inputs3_2_0, new_weighted_inputs3_2_1;
  wire [2:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
  wire [2:0] new_weighted_inputs3_3_0, new_weighted_inputs3_3_1;
  wire [2:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
  wire [2:0] new_weighted_inputs3_4_0, new_weighted_inputs3_4_1;
  wire [2:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
  wire [2:0] new_weighted_inputs3_5_0, new_weighted_inputs3_5_1;
  wire [2:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
  wire [2:0] new_weighted_inputs3_6_0, new_weighted_inputs3_6_1;
  wire [2:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
  wire [2:0] new_weighted_inputs3_7_0, new_weighted_inputs3_7_1;
  wire [2:0] weighted_inputs3_8_0, weighted_inputs3_8_1;
  wire [2:0] new_weighted_inputs3_8_0, new_weighted_inputs3_8_1;
  wire [2:0] weighted_inputs3_9_0, weighted_inputs3_9_1;
  wire [2:0] new_weighted_inputs3_9_0, new_weighted_inputs3_9_1;
  wire [2:0] weighted_inputs3_10_0, weighted_inputs3_10_1;
  wire [2:0] new_weighted_inputs3_10_0, new_weighted_inputs3_10_1;
  wire [2:0] weighted_inputs3_11_0, weighted_inputs3_11_1;
  wire [2:0] new_weighted_inputs3_11_0, new_weighted_inputs3_11_1;
  wire [2:0] weighted_inputs3_12_0, weighted_inputs3_12_1;
  wire [2:0] new_weighted_inputs3_12_0, new_weighted_inputs3_12_1;
  wire [2:0] weighted_inputs3_13_0, weighted_inputs3_13_1;
  wire [2:0] new_weighted_inputs3_13_0, new_weighted_inputs3_13_1;
  wire [2:0] weighted_inputs3_14_0, weighted_inputs3_14_1;
  wire [2:0] new_weighted_inputs3_14_0, new_weighted_inputs3_14_1;
  wire [2:0] weighted_inputs3_15_0, weighted_inputs3_15_1;
  wire [2:0] new_weighted_inputs3_15_0, new_weighted_inputs3_15_1;
  wire [2:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
  wire [2:0] new_weighted_inputs4_0_0, new_weighted_inputs4_0_1;
  wire [2:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
  wire [2:0] new_weighted_inputs4_1_0, new_weighted_inputs4_1_1;
  wire [2:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
  wire [2:0] new_weighted_inputs4_2_0, new_weighted_inputs4_2_1;
  wire [2:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
  wire [2:0] new_weighted_inputs4_3_0, new_weighted_inputs4_3_1;
  wire [2:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
  wire [2:0] new_weighted_inputs4_4_0, new_weighted_inputs4_4_1;
  wire [2:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
  wire [2:0] new_weighted_inputs4_5_0, new_weighted_inputs4_5_1;
  wire [2:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
  wire [2:0] new_weighted_inputs4_6_0, new_weighted_inputs4_6_1;
  wire [2:0] weighted_inputs4_7_0, weighted_inputs4_7_1;
  wire [2:0] new_weighted_inputs4_7_0, new_weighted_inputs4_7_1;
  wire [2:0] weighted_inputs4_8_0, weighted_inputs4_8_1;
  wire [2:0] new_weighted_inputs4_8_0, new_weighted_inputs4_8_1;
  wire [2:0] weighted_inputs4_9_0, weighted_inputs4_9_1;
  wire [2:0] new_weighted_inputs4_9_0, new_weighted_inputs4_9_1;
  wire [2:0] weighted_inputs4_10_0, weighted_inputs4_10_1;
  wire [2:0] new_weighted_inputs4_10_0, new_weighted_inputs4_10_1;
  wire [2:0] weighted_inputs4_11_0, weighted_inputs4_11_1;
  wire [2:0] new_weighted_inputs4_11_0, new_weighted_inputs4_11_1;
  wire [2:0] weighted_inputs4_12_0, weighted_inputs4_12_1;
  wire [2:0] new_weighted_inputs4_12_0, new_weighted_inputs4_12_1;
  wire [2:0] weighted_inputs4_13_0, weighted_inputs4_13_1;
  wire [2:0] new_weighted_inputs4_13_0, new_weighted_inputs4_13_1;
  wire [2:0] weighted_inputs4_14_0, weighted_inputs4_14_1;
  wire [2:0] new_weighted_inputs4_14_0, new_weighted_inputs4_14_1;
  wire [2:0] weighted_inputs4_15_0, weighted_inputs4_15_1;
  wire [2:0] new_weighted_inputs4_15_0, new_weighted_inputs4_15_1;
  wire [2:0] weighted_inputs5_0_0, weighted_inputs5_0_1;
  wire [2:0] new_weighted_inputs5_0_0, new_weighted_inputs5_0_1;
  wire [2:0] weighted_inputs5_1_0, weighted_inputs5_1_1;
  wire [2:0] new_weighted_inputs5_1_0, new_weighted_inputs5_1_1;
  wire [2:0] weighted_inputs5_2_0, weighted_inputs5_2_1;
  wire [2:0] new_weighted_inputs5_2_0, new_weighted_inputs5_2_1;
  wire [2:0] weighted_inputs5_3_0, weighted_inputs5_3_1;
  wire [2:0] new_weighted_inputs5_3_0, new_weighted_inputs5_3_1;
  wire [2:0] weighted_inputs5_4_0, weighted_inputs5_4_1;
  wire [2:0] new_weighted_inputs5_4_0, new_weighted_inputs5_4_1;
  wire [2:0] weighted_inputs5_5_0, weighted_inputs5_5_1;
  wire [2:0] new_weighted_inputs5_5_0, new_weighted_inputs5_5_1;
  wire [2:0] weighted_inputs5_6_0, weighted_inputs5_6_1;
  wire [2:0] new_weighted_inputs5_6_0, new_weighted_inputs5_6_1;
  wire [2:0] weighted_inputs5_7_0, weighted_inputs5_7_1;
  wire [2:0] new_weighted_inputs5_7_0, new_weighted_inputs5_7_1;
  wire [2:0] weighted_inputs5_8_0, weighted_inputs5_8_1;
  wire [2:0] new_weighted_inputs5_8_0, new_weighted_inputs5_8_1;
  wire [2:0] weighted_inputs5_9_0, weighted_inputs5_9_1;
  wire [2:0] new_weighted_inputs5_9_0, new_weighted_inputs5_9_1;
  wire [2:0] weighted_inputs5_10_0, weighted_inputs5_10_1;
  wire [2:0] new_weighted_inputs5_10_0, new_weighted_inputs5_10_1;
  wire [2:0] weighted_inputs5_11_0, weighted_inputs5_11_1;
  wire [2:0] new_weighted_inputs5_11_0, new_weighted_inputs5_11_1;
  wire [2:0] weighted_inputs5_12_0, weighted_inputs5_12_1;
  wire [2:0] new_weighted_inputs5_12_0, new_weighted_inputs5_12_1;
  wire [2:0] weighted_inputs5_13_0, weighted_inputs5_13_1;
  wire [2:0] new_weighted_inputs5_13_0, new_weighted_inputs5_13_1;
  wire [2:0] weighted_inputs5_14_0, weighted_inputs5_14_1;
  wire [2:0] new_weighted_inputs5_14_0, new_weighted_inputs5_14_1;
  wire [2:0] weighted_inputs5_15_0, weighted_inputs5_15_1;
  wire [2:0] new_weighted_inputs5_15_0, new_weighted_inputs5_15_1;
  wire [2:0] weighted_inputs6_0_0, weighted_inputs6_0_1;
  wire [2:0] new_weighted_inputs6_0_0, new_weighted_inputs6_0_1;
  wire [2:0] weighted_inputs6_1_0, weighted_inputs6_1_1;
  wire [2:0] new_weighted_inputs6_1_0, new_weighted_inputs6_1_1;
  wire [2:0] weighted_inputs6_2_0, weighted_inputs6_2_1;
  wire [2:0] new_weighted_inputs6_2_0, new_weighted_inputs6_2_1;
  wire [2:0] weighted_inputs6_3_0, weighted_inputs6_3_1;
  wire [2:0] new_weighted_inputs6_3_0, new_weighted_inputs6_3_1;
  wire [2:0] weighted_inputs6_4_0, weighted_inputs6_4_1;
  wire [2:0] new_weighted_inputs6_4_0, new_weighted_inputs6_4_1;
  wire [2:0] weighted_inputs6_5_0, weighted_inputs6_5_1;
  wire [2:0] new_weighted_inputs6_5_0, new_weighted_inputs6_5_1;
  wire [2:0] weighted_inputs6_6_0, weighted_inputs6_6_1;
  wire [2:0] new_weighted_inputs6_6_0, new_weighted_inputs6_6_1;
  wire [2:0] weighted_inputs6_7_0, weighted_inputs6_7_1;
  wire [2:0] new_weighted_inputs6_7_0, new_weighted_inputs6_7_1;
  wire [2:0] weighted_inputs6_8_0, weighted_inputs6_8_1;
  wire [2:0] new_weighted_inputs6_8_0, new_weighted_inputs6_8_1;
  wire [2:0] weighted_inputs6_9_0, weighted_inputs6_9_1;
  wire [2:0] new_weighted_inputs6_9_0, new_weighted_inputs6_9_1;
  wire [2:0] weighted_inputs6_10_0, weighted_inputs6_10_1;
  wire [2:0] new_weighted_inputs6_10_0, new_weighted_inputs6_10_1;
  wire [2:0] weighted_inputs6_11_0, weighted_inputs6_11_1;
  wire [2:0] new_weighted_inputs6_11_0, new_weighted_inputs6_11_1;
  wire [2:0] weighted_inputs6_12_0, weighted_inputs6_12_1;
  wire [2:0] new_weighted_inputs6_12_0, new_weighted_inputs6_12_1;
  wire [2:0] weighted_inputs6_13_0, weighted_inputs6_13_1;
  wire [2:0] new_weighted_inputs6_13_0, new_weighted_inputs6_13_1;
  wire [2:0] weighted_inputs6_14_0, weighted_inputs6_14_1;
  wire [2:0] new_weighted_inputs6_14_0, new_weighted_inputs6_14_1;
  wire [2:0] weighted_inputs6_15_0, weighted_inputs6_15_1;
  wire [2:0] new_weighted_inputs6_15_0, new_weighted_inputs6_15_1;
  wire [2:0] weighted_inputs7_0_0, weighted_inputs7_0_1;
  wire [2:0] new_weighted_inputs7_0_0, new_weighted_inputs7_0_1;
  wire [2:0] weighted_inputs7_1_0, weighted_inputs7_1_1;
  wire [2:0] new_weighted_inputs7_1_0, new_weighted_inputs7_1_1;
  wire [2:0] weighted_inputs7_2_0, weighted_inputs7_2_1;
  wire [2:0] new_weighted_inputs7_2_0, new_weighted_inputs7_2_1;
  wire [2:0] weighted_inputs7_3_0, weighted_inputs7_3_1;
  wire [2:0] new_weighted_inputs7_3_0, new_weighted_inputs7_3_1;
  wire [2:0] weighted_inputs7_4_0, weighted_inputs7_4_1;
  wire [2:0] new_weighted_inputs7_4_0, new_weighted_inputs7_4_1;
  wire [2:0] weighted_inputs7_5_0, weighted_inputs7_5_1;
  wire [2:0] new_weighted_inputs7_5_0, new_weighted_inputs7_5_1;
  wire [2:0] weighted_inputs7_6_0, weighted_inputs7_6_1;
  wire [2:0] new_weighted_inputs7_6_0, new_weighted_inputs7_6_1;
  wire [2:0] weighted_inputs7_7_0, weighted_inputs7_7_1;
  wire [2:0] new_weighted_inputs7_7_0, new_weighted_inputs7_7_1;
  wire [2:0] weighted_inputs7_8_0, weighted_inputs7_8_1;
  wire [2:0] new_weighted_inputs7_8_0, new_weighted_inputs7_8_1;
  wire [2:0] weighted_inputs7_9_0, weighted_inputs7_9_1;
  wire [2:0] new_weighted_inputs7_9_0, new_weighted_inputs7_9_1;
  wire [2:0] weighted_inputs7_10_0, weighted_inputs7_10_1;
  wire [2:0] new_weighted_inputs7_10_0, new_weighted_inputs7_10_1;
  wire [2:0] weighted_inputs7_11_0, weighted_inputs7_11_1;
  wire [2:0] new_weighted_inputs7_11_0, new_weighted_inputs7_11_1;
  wire [2:0] weighted_inputs7_12_0, weighted_inputs7_12_1;
  wire [2:0] new_weighted_inputs7_12_0, new_weighted_inputs7_12_1;
  wire [2:0] weighted_inputs7_13_0, weighted_inputs7_13_1;
  wire [2:0] new_weighted_inputs7_13_0, new_weighted_inputs7_13_1;
  wire [2:0] weighted_inputs7_14_0, weighted_inputs7_14_1;
  wire [2:0] new_weighted_inputs7_14_0, new_weighted_inputs7_14_1;
  wire [2:0] weighted_inputs7_15_0, weighted_inputs7_15_1;
  wire [2:0] new_weighted_inputs7_15_0, new_weighted_inputs7_15_1;
  wire [2:0] weighted_inputs8_0_0, weighted_inputs8_0_1;
  wire [2:0] new_weighted_inputs8_0_0, new_weighted_inputs8_0_1;
  wire [2:0] weighted_inputs8_1_0, weighted_inputs8_1_1;
  wire [2:0] new_weighted_inputs8_1_0, new_weighted_inputs8_1_1;
  wire [2:0] weighted_inputs8_2_0, weighted_inputs8_2_1;
  wire [2:0] new_weighted_inputs8_2_0, new_weighted_inputs8_2_1;
  wire [2:0] weighted_inputs8_3_0, weighted_inputs8_3_1;
  wire [2:0] new_weighted_inputs8_3_0, new_weighted_inputs8_3_1;
  wire [2:0] weighted_inputs8_4_0, weighted_inputs8_4_1;
  wire [2:0] new_weighted_inputs8_4_0, new_weighted_inputs8_4_1;
  wire [2:0] weighted_inputs8_5_0, weighted_inputs8_5_1;
  wire [2:0] new_weighted_inputs8_5_0, new_weighted_inputs8_5_1;
  wire [2:0] weighted_inputs8_6_0, weighted_inputs8_6_1;
  wire [2:0] new_weighted_inputs8_6_0, new_weighted_inputs8_6_1;
  wire [2:0] weighted_inputs8_7_0, weighted_inputs8_7_1;
  wire [2:0] new_weighted_inputs8_7_0, new_weighted_inputs8_7_1;
  wire [2:0] weighted_inputs8_8_0, weighted_inputs8_8_1;
  wire [2:0] new_weighted_inputs8_8_0, new_weighted_inputs8_8_1;
  wire [2:0] weighted_inputs8_9_0, weighted_inputs8_9_1;
  wire [2:0] new_weighted_inputs8_9_0, new_weighted_inputs8_9_1;
  wire [2:0] weighted_inputs8_10_0, weighted_inputs8_10_1;
  wire [2:0] new_weighted_inputs8_10_0, new_weighted_inputs8_10_1;
  wire [2:0] weighted_inputs8_11_0, weighted_inputs8_11_1;
  wire [2:0] new_weighted_inputs8_11_0, new_weighted_inputs8_11_1;
  wire [2:0] weighted_inputs8_12_0, weighted_inputs8_12_1;
  wire [2:0] new_weighted_inputs8_12_0, new_weighted_inputs8_12_1;
  wire [2:0] weighted_inputs8_13_0, weighted_inputs8_13_1;
  wire [2:0] new_weighted_inputs8_13_0, new_weighted_inputs8_13_1;
  wire [2:0] weighted_inputs8_14_0, weighted_inputs8_14_1;
  wire [2:0] new_weighted_inputs8_14_0, new_weighted_inputs8_14_1;
  wire [2:0] weighted_inputs8_15_0, weighted_inputs8_15_1;
  wire [2:0] new_weighted_inputs8_15_0, new_weighted_inputs8_15_1;
  

  wire [6:0] sum1 [7:0], sum2 [7:0], sum1bar [7:0], sum2bar [7 :0];
  wire [7:0] biased_sum1 [7:0], biased_sum2 [7:0], biased_sum1bar [7:0], biased_sum2bar [7:0];
  

  wire [2:0] act0_0_0_1;
  wire [2:0] act0_0_1_1;
  wire [2:0] act0_0_0_2;
  wire [2:0] act0_0_1_2;
  wire [2:0] act0_0_0_3;
  wire [2:0] act0_0_1_3;
  wire [2:0] act0_1_0_1;
  wire [2:0] act0_1_1_1;
  wire [2:0] act0_1_0_2;
  wire [2:0] act0_1_1_2;
  wire [2:0] act0_1_0_3;
  wire [2:0] act0_1_1_3;
  wire [2:0] act0_2_0_1;
  wire [2:0] act0_2_1_1;
  wire [2:0] act0_2_0_2;
  wire [2:0] act0_2_1_2;
  wire [2:0] act0_2_0_3;
  wire [2:0] act0_2_1_3;
  wire [2:0] act0_3_0_1;
  wire [2:0] act0_3_1_1;
  wire [2:0] act0_3_0_2;
  wire [2:0] act0_3_1_2;
  wire [2:0] act0_3_0_3;
  wire [2:0] act0_3_1_3;
  wire [2:0] act0_4_0_1;
  wire [2:0] act0_4_1_1;
  wire [2:0] act0_4_0_2;
  wire [2:0] act0_4_1_2;
  wire [2:0] act0_4_0_3;
  wire [2:0] act0_4_1_3;
  wire [2:0] act0_5_0_1;
  wire [2:0] act0_5_1_1;
  wire [2:0] act0_5_0_2;
  wire [2:0] act0_5_1_2;
  wire [2:0] act0_5_0_3;
  wire [2:0] act0_5_1_3;
  wire [2:0] act0_6_0_1;
  wire [2:0] act0_6_1_1;
  wire [2:0] act0_6_0_2;
  wire [2:0] act0_6_1_2;
  wire [2:0] act0_6_0_3;
  wire [2:0] act0_6_1_3;
  wire [2:0] act0_7_0_1;
  wire [2:0] act0_7_1_1;
  wire [2:0] act0_7_0_2;
  wire [2:0] act0_7_1_2;
  wire [2:0] act0_7_0_3;
  wire [2:0] act0_7_1_3;
  wire [2:0] act0_8_0_1;
  wire [2:0] act0_8_1_1;
  wire [2:0] act0_8_0_2;
  wire [2:0] act0_8_1_2;
  wire [2:0] act0_8_0_3;
  wire [2:0] act0_8_1_3;
  wire [2:0] act0_9_0_1;
  wire [2:0] act0_9_1_1;
  wire [2:0] act0_9_0_2;
  wire [2:0] act0_9_1_2;
  wire [2:0] act0_9_0_3;
  wire [2:0] act0_9_1_3;
  wire [2:0] act0_10_0_1;
  wire [2:0] act0_10_1_1;
  wire [2:0] act0_10_0_2;
  wire [2:0] act0_10_1_2;
  wire [2:0] act0_10_0_3;
  wire [2:0] act0_10_1_3;
  wire [2:0] act0_11_0_1;
  wire [2:0] act0_11_1_1;
  wire [2:0] act0_11_0_2;
  wire [2:0] act0_11_1_2;
  wire [2:0] act0_11_0_3;
  wire [2:0] act0_11_1_3;
  wire [2:0] act0_12_0_1;
  wire [2:0] act0_12_1_1;
  wire [2:0] act0_12_0_2;
  wire [2:0] act0_12_1_2;
  wire [2:0] act0_12_0_3;
  wire [2:0] act0_12_1_3;
  wire [2:0] act0_13_0_1;
  wire [2:0] act0_13_1_1;
  wire [2:0] act0_13_0_2;
  wire [2:0] act0_13_1_2;
  wire [2:0] act0_13_0_3;
  wire [2:0] act0_13_1_3;
  wire [2:0] act0_14_0_1;
  wire [2:0] act0_14_1_1;
  wire [2:0] act0_14_0_2;
  wire [2:0] act0_14_1_2;
  wire [2:0] act0_14_0_3;
  wire [2:0] act0_14_1_3;
  wire [2:0] act0_15_0_1;
  wire [2:0] act0_15_1_1;
  wire [2:0] act0_15_0_2;
  wire [2:0] act0_15_1_2;
  wire [2:0] act0_15_0_3;
  wire [2:0] act0_15_1_3;
  wire [2:0] act1_0_0_1;
  wire [2:0] act1_0_1_1;
  wire [2:0] act1_0_0_2;
  wire [2:0] act1_0_1_2;
  wire [2:0] act1_0_0_3;
  wire [2:0] act1_0_1_3;
  wire [2:0] act1_1_0_1;
  wire [2:0] act1_1_1_1;
  wire [2:0] act1_1_0_2;
  wire [2:0] act1_1_1_2;
  wire [2:0] act1_1_0_3;
  wire [2:0] act1_1_1_3;
  wire [2:0] act1_2_0_1;
  wire [2:0] act1_2_1_1;
  wire [2:0] act1_2_0_2;
  wire [2:0] act1_2_1_2;
  wire [2:0] act1_2_0_3;
  wire [2:0] act1_2_1_3;
  wire [2:0] act1_3_0_1;
  wire [2:0] act1_3_1_1;
  wire [2:0] act1_3_0_2;
  wire [2:0] act1_3_1_2;
  wire [2:0] act1_3_0_3;
  wire [2:0] act1_3_1_3;
  wire [2:0] act1_4_0_1;
  wire [2:0] act1_4_1_1;
  wire [2:0] act1_4_0_2;
  wire [2:0] act1_4_1_2;
  wire [2:0] act1_4_0_3;
  wire [2:0] act1_4_1_3;
  wire [2:0] act1_5_0_1;
  wire [2:0] act1_5_1_1;
  wire [2:0] act1_5_0_2;
  wire [2:0] act1_5_1_2;
  wire [2:0] act1_5_0_3;
  wire [2:0] act1_5_1_3;
  wire [2:0] act1_6_0_1;
  wire [2:0] act1_6_1_1;
  wire [2:0] act1_6_0_2;
  wire [2:0] act1_6_1_2;
  wire [2:0] act1_6_0_3;
  wire [2:0] act1_6_1_3;
  wire [2:0] act1_7_0_1;
  wire [2:0] act1_7_1_1;
  wire [2:0] act1_7_0_2;
  wire [2:0] act1_7_1_2;
  wire [2:0] act1_7_0_3;
  wire [2:0] act1_7_1_3;
  wire [2:0] act1_8_0_1;
  wire [2:0] act1_8_1_1;
  wire [2:0] act1_8_0_2;
  wire [2:0] act1_8_1_2;
  wire [2:0] act1_8_0_3;
  wire [2:0] act1_8_1_3;
  wire [2:0] act1_9_0_1;
  wire [2:0] act1_9_1_1;
  wire [2:0] act1_9_0_2;
  wire [2:0] act1_9_1_2;
  wire [2:0] act1_9_0_3;
  wire [2:0] act1_9_1_3;
  wire [2:0] act1_10_0_1;
  wire [2:0] act1_10_1_1;
  wire [2:0] act1_10_0_2;
  wire [2:0] act1_10_1_2;
  wire [2:0] act1_10_0_3;
  wire [2:0] act1_10_1_3;
  wire [2:0] act1_11_0_1;
  wire [2:0] act1_11_1_1;
  wire [2:0] act1_11_0_2;
  wire [2:0] act1_11_1_2;
  wire [2:0] act1_11_0_3;
  wire [2:0] act1_11_1_3;
  wire [2:0] act1_12_0_1;
  wire [2:0] act1_12_1_1;
  wire [2:0] act1_12_0_2;
  wire [2:0] act1_12_1_2;
  wire [2:0] act1_12_0_3;
  wire [2:0] act1_12_1_3;
  wire [2:0] act1_13_0_1;
  wire [2:0] act1_13_1_1;
  wire [2:0] act1_13_0_2;
  wire [2:0] act1_13_1_2;
  wire [2:0] act1_13_0_3;
  wire [2:0] act1_13_1_3;
  wire [2:0] act1_14_0_1;
  wire [2:0] act1_14_1_1;
  wire [2:0] act1_14_0_2;
  wire [2:0] act1_14_1_2;
  wire [2:0] act1_14_0_3;
  wire [2:0] act1_14_1_3;
  wire [2:0] act1_15_0_1;
  wire [2:0] act1_15_1_1;
  wire [2:0] act1_15_0_2;
  wire [2:0] act1_15_1_2;
  wire [2:0] act1_15_0_3;
  wire [2:0] act1_15_1_3;
  wire [2:0] act2_0_0_1;
  wire [2:0] act2_0_1_1;
  wire [2:0] act2_0_0_2;
  wire [2:0] act2_0_1_2;
  wire [2:0] act2_0_0_3;
  wire [2:0] act2_0_1_3;
  wire [2:0] act2_1_0_1;
  wire [2:0] act2_1_1_1;
  wire [2:0] act2_1_0_2;
  wire [2:0] act2_1_1_2;
  wire [2:0] act2_1_0_3;
  wire [2:0] act2_1_1_3;
  wire [2:0] act2_2_0_1;
  wire [2:0] act2_2_1_1;
  wire [2:0] act2_2_0_2;
  wire [2:0] act2_2_1_2;
  wire [2:0] act2_2_0_3;
  wire [2:0] act2_2_1_3;
  wire [2:0] act2_3_0_1;
  wire [2:0] act2_3_1_1;
  wire [2:0] act2_3_0_2;
  wire [2:0] act2_3_1_2;
  wire [2:0] act2_3_0_3;
  wire [2:0] act2_3_1_3;
  wire [2:0] act2_4_0_1;
  wire [2:0] act2_4_1_1;
  wire [2:0] act2_4_0_2;
  wire [2:0] act2_4_1_2;
  wire [2:0] act2_4_0_3;
  wire [2:0] act2_4_1_3;
  wire [2:0] act2_5_0_1;
  wire [2:0] act2_5_1_1;
  wire [2:0] act2_5_0_2;
  wire [2:0] act2_5_1_2;
  wire [2:0] act2_5_0_3;
  wire [2:0] act2_5_1_3;
  wire [2:0] act2_6_0_1;
  wire [2:0] act2_6_1_1;
  wire [2:0] act2_6_0_2;
  wire [2:0] act2_6_1_2;
  wire [2:0] act2_6_0_3;
  wire [2:0] act2_6_1_3;
  wire [2:0] act2_7_0_1;
  wire [2:0] act2_7_1_1;
  wire [2:0] act2_7_0_2;
  wire [2:0] act2_7_1_2;
  wire [2:0] act2_7_0_3;
  wire [2:0] act2_7_1_3;
  wire [2:0] act2_8_0_1;
  wire [2:0] act2_8_1_1;
  wire [2:0] act2_8_0_2;
  wire [2:0] act2_8_1_2;
  wire [2:0] act2_8_0_3;
  wire [2:0] act2_8_1_3;
  wire [2:0] act2_9_0_1;
  wire [2:0] act2_9_1_1;
  wire [2:0] act2_9_0_2;
  wire [2:0] act2_9_1_2;
  wire [2:0] act2_9_0_3;
  wire [2:0] act2_9_1_3;
  wire [2:0] act2_10_0_1;
  wire [2:0] act2_10_1_1;
  wire [2:0] act2_10_0_2;
  wire [2:0] act2_10_1_2;
  wire [2:0] act2_10_0_3;
  wire [2:0] act2_10_1_3;
  wire [2:0] act2_11_0_1;
  wire [2:0] act2_11_1_1;
  wire [2:0] act2_11_0_2;
  wire [2:0] act2_11_1_2;
  wire [2:0] act2_11_0_3;
  wire [2:0] act2_11_1_3;
  wire [2:0] act2_12_0_1;
  wire [2:0] act2_12_1_1;
  wire [2:0] act2_12_0_2;
  wire [2:0] act2_12_1_2;
  wire [2:0] act2_12_0_3;
  wire [2:0] act2_12_1_3;
  wire [2:0] act2_13_0_1;
  wire [2:0] act2_13_1_1;
  wire [2:0] act2_13_0_2;
  wire [2:0] act2_13_1_2;
  wire [2:0] act2_13_0_3;
  wire [2:0] act2_13_1_3;
  wire [2:0] act2_14_0_1;
  wire [2:0] act2_14_1_1;
  wire [2:0] act2_14_0_2;
  wire [2:0] act2_14_1_2;
  wire [2:0] act2_14_0_3;
  wire [2:0] act2_14_1_3;
  wire [2:0] act2_15_0_1;
  wire [2:0] act2_15_1_1;
  wire [2:0] act2_15_0_2;
  wire [2:0] act2_15_1_2;
  wire [2:0] act2_15_0_3;
  wire [2:0] act2_15_1_3;
  wire [2:0] act3_0_0_1;
  wire [2:0] act3_0_1_1;
  wire [2:0] act3_0_0_2;
  wire [2:0] act3_0_1_2;
  wire [2:0] act3_0_0_3;
  wire [2:0] act3_0_1_3;
  wire [2:0] act3_1_0_1;
  wire [2:0] act3_1_1_1;
  wire [2:0] act3_1_0_2;
  wire [2:0] act3_1_1_2;
  wire [2:0] act3_1_0_3;
  wire [2:0] act3_1_1_3;
  wire [2:0] act3_2_0_1;
  wire [2:0] act3_2_1_1;
  wire [2:0] act3_2_0_2;
  wire [2:0] act3_2_1_2;
  wire [2:0] act3_2_0_3;
  wire [2:0] act3_2_1_3;
  wire [2:0] act3_3_0_1;
  wire [2:0] act3_3_1_1;
  wire [2:0] act3_3_0_2;
  wire [2:0] act3_3_1_2;
  wire [2:0] act3_3_0_3;
  wire [2:0] act3_3_1_3;
  wire [2:0] act3_4_0_1;
  wire [2:0] act3_4_1_1;
  wire [2:0] act3_4_0_2;
  wire [2:0] act3_4_1_2;
  wire [2:0] act3_4_0_3;
  wire [2:0] act3_4_1_3;
  wire [2:0] act3_5_0_1;
  wire [2:0] act3_5_1_1;
  wire [2:0] act3_5_0_2;
  wire [2:0] act3_5_1_2;
  wire [2:0] act3_5_0_3;
  wire [2:0] act3_5_1_3;
  wire [2:0] act3_6_0_1;
  wire [2:0] act3_6_1_1;
  wire [2:0] act3_6_0_2;
  wire [2:0] act3_6_1_2;
  wire [2:0] act3_6_0_3;
  wire [2:0] act3_6_1_3;
  wire [2:0] act3_7_0_1;
  wire [2:0] act3_7_1_1;
  wire [2:0] act3_7_0_2;
  wire [2:0] act3_7_1_2;
  wire [2:0] act3_7_0_3;
  wire [2:0] act3_7_1_3;
  wire [2:0] act3_8_0_1;
  wire [2:0] act3_8_1_1;
  wire [2:0] act3_8_0_2;
  wire [2:0] act3_8_1_2;
  wire [2:0] act3_8_0_3;
  wire [2:0] act3_8_1_3;
  wire [2:0] act3_9_0_1;
  wire [2:0] act3_9_1_1;
  wire [2:0] act3_9_0_2;
  wire [2:0] act3_9_1_2;
  wire [2:0] act3_9_0_3;
  wire [2:0] act3_9_1_3;
  wire [2:0] act3_10_0_1;
  wire [2:0] act3_10_1_1;
  wire [2:0] act3_10_0_2;
  wire [2:0] act3_10_1_2;
  wire [2:0] act3_10_0_3;
  wire [2:0] act3_10_1_3;
  wire [2:0] act3_11_0_1;
  wire [2:0] act3_11_1_1;
  wire [2:0] act3_11_0_2;
  wire [2:0] act3_11_1_2;
  wire [2:0] act3_11_0_3;
  wire [2:0] act3_11_1_3;
  wire [2:0] act3_12_0_1;
  wire [2:0] act3_12_1_1;
  wire [2:0] act3_12_0_2;
  wire [2:0] act3_12_1_2;
  wire [2:0] act3_12_0_3;
  wire [2:0] act3_12_1_3;
  wire [2:0] act3_13_0_1;
  wire [2:0] act3_13_1_1;
  wire [2:0] act3_13_0_2;
  wire [2:0] act3_13_1_2;
  wire [2:0] act3_13_0_3;
  wire [2:0] act3_13_1_3;
  wire [2:0] act3_14_0_1;
  wire [2:0] act3_14_1_1;
  wire [2:0] act3_14_0_2;
  wire [2:0] act3_14_1_2;
  wire [2:0] act3_14_0_3;
  wire [2:0] act3_14_1_3;
  wire [2:0] act3_15_0_1;
  wire [2:0] act3_15_1_1;
  wire [2:0] act3_15_0_2;
  wire [2:0] act3_15_1_2;
  wire [2:0] act3_15_0_3;
  wire [2:0] act3_15_1_3;
  wire [2:0] act4_0_0_1;
  wire [2:0] act4_0_1_1;
  wire [2:0] act4_0_0_2;
  wire [2:0] act4_0_1_2;
  wire [2:0] act4_0_0_3;
  wire [2:0] act4_0_1_3;
  wire [2:0] act4_1_0_1;
  wire [2:0] act4_1_1_1;
  wire [2:0] act4_1_0_2;
  wire [2:0] act4_1_1_2;
  wire [2:0] act4_1_0_3;
  wire [2:0] act4_1_1_3;
  wire [2:0] act4_2_0_1;
  wire [2:0] act4_2_1_1;
  wire [2:0] act4_2_0_2;
  wire [2:0] act4_2_1_2;
  wire [2:0] act4_2_0_3;
  wire [2:0] act4_2_1_3;
  wire [2:0] act4_3_0_1;
  wire [2:0] act4_3_1_1;
  wire [2:0] act4_3_0_2;
  wire [2:0] act4_3_1_2;
  wire [2:0] act4_3_0_3;
  wire [2:0] act4_3_1_3;
  wire [2:0] act4_4_0_1;
  wire [2:0] act4_4_1_1;
  wire [2:0] act4_4_0_2;
  wire [2:0] act4_4_1_2;
  wire [2:0] act4_4_0_3;
  wire [2:0] act4_4_1_3;
  wire [2:0] act4_5_0_1;
  wire [2:0] act4_5_1_1;
  wire [2:0] act4_5_0_2;
  wire [2:0] act4_5_1_2;
  wire [2:0] act4_5_0_3;
  wire [2:0] act4_5_1_3;
  wire [2:0] act4_6_0_1;
  wire [2:0] act4_6_1_1;
  wire [2:0] act4_6_0_2;
  wire [2:0] act4_6_1_2;
  wire [2:0] act4_6_0_3;
  wire [2:0] act4_6_1_3;
  wire [2:0] act4_7_0_1;
  wire [2:0] act4_7_1_1;
  wire [2:0] act4_7_0_2;
  wire [2:0] act4_7_1_2;
  wire [2:0] act4_7_0_3;
  wire [2:0] act4_7_1_3;
  wire [2:0] act4_8_0_1;
  wire [2:0] act4_8_1_1;
  wire [2:0] act4_8_0_2;
  wire [2:0] act4_8_1_2;
  wire [2:0] act4_8_0_3;
  wire [2:0] act4_8_1_3;
  wire [2:0] act4_9_0_1;
  wire [2:0] act4_9_1_1;
  wire [2:0] act4_9_0_2;
  wire [2:0] act4_9_1_2;
  wire [2:0] act4_9_0_3;
  wire [2:0] act4_9_1_3;
  wire [2:0] act4_10_0_1;
  wire [2:0] act4_10_1_1;
  wire [2:0] act4_10_0_2;
  wire [2:0] act4_10_1_2;
  wire [2:0] act4_10_0_3;
  wire [2:0] act4_10_1_3;
  wire [2:0] act4_11_0_1;
  wire [2:0] act4_11_1_1;
  wire [2:0] act4_11_0_2;
  wire [2:0] act4_11_1_2;
  wire [2:0] act4_11_0_3;
  wire [2:0] act4_11_1_3;
  wire [2:0] act4_12_0_1;
  wire [2:0] act4_12_1_1;
  wire [2:0] act4_12_0_2;
  wire [2:0] act4_12_1_2;
  wire [2:0] act4_12_0_3;
  wire [2:0] act4_12_1_3;
  wire [2:0] act4_13_0_1;
  wire [2:0] act4_13_1_1;
  wire [2:0] act4_13_0_2;
  wire [2:0] act4_13_1_2;
  wire [2:0] act4_13_0_3;
  wire [2:0] act4_13_1_3;
  wire [2:0] act4_14_0_1;
  wire [2:0] act4_14_1_1;
  wire [2:0] act4_14_0_2;
  wire [2:0] act4_14_1_2;
  wire [2:0] act4_14_0_3;
  wire [2:0] act4_14_1_3;
  wire [2:0] act4_15_0_1;
  wire [2:0] act4_15_1_1;
  wire [2:0] act4_15_0_2;
  wire [2:0] act4_15_1_2;
  wire [2:0] act4_15_0_3;
  wire [2:0] act4_15_1_3;
  wire [2:0] act5_0_0_1;
  wire [2:0] act5_0_1_1;
  wire [2:0] act5_0_0_2;
  wire [2:0] act5_0_1_2;
  wire [2:0] act5_0_0_3;
  wire [2:0] act5_0_1_3;
  wire [2:0] act5_1_0_1;
  wire [2:0] act5_1_1_1;
  wire [2:0] act5_1_0_2;
  wire [2:0] act5_1_1_2;
  wire [2:0] act5_1_0_3;
  wire [2:0] act5_1_1_3;
  wire [2:0] act5_2_0_1;
  wire [2:0] act5_2_1_1;
  wire [2:0] act5_2_0_2;
  wire [2:0] act5_2_1_2;
  wire [2:0] act5_2_0_3;
  wire [2:0] act5_2_1_3;
  wire [2:0] act5_3_0_1;
  wire [2:0] act5_3_1_1;
  wire [2:0] act5_3_0_2;
  wire [2:0] act5_3_1_2;
  wire [2:0] act5_3_0_3;
  wire [2:0] act5_3_1_3;
  wire [2:0] act5_4_0_1;
  wire [2:0] act5_4_1_1;
  wire [2:0] act5_4_0_2;
  wire [2:0] act5_4_1_2;
  wire [2:0] act5_4_0_3;
  wire [2:0] act5_4_1_3;
  wire [2:0] act5_5_0_1;
  wire [2:0] act5_5_1_1;
  wire [2:0] act5_5_0_2;
  wire [2:0] act5_5_1_2;
  wire [2:0] act5_5_0_3;
  wire [2:0] act5_5_1_3;
  wire [2:0] act5_6_0_1;
  wire [2:0] act5_6_1_1;
  wire [2:0] act5_6_0_2;
  wire [2:0] act5_6_1_2;
  wire [2:0] act5_6_0_3;
  wire [2:0] act5_6_1_3;
  wire [2:0] act5_7_0_1;
  wire [2:0] act5_7_1_1;
  wire [2:0] act5_7_0_2;
  wire [2:0] act5_7_1_2;
  wire [2:0] act5_7_0_3;
  wire [2:0] act5_7_1_3;
  wire [2:0] act5_8_0_1;
  wire [2:0] act5_8_1_1;
  wire [2:0] act5_8_0_2;
  wire [2:0] act5_8_1_2;
  wire [2:0] act5_8_0_3;
  wire [2:0] act5_8_1_3;
  wire [2:0] act5_9_0_1;
  wire [2:0] act5_9_1_1;
  wire [2:0] act5_9_0_2;
  wire [2:0] act5_9_1_2;
  wire [2:0] act5_9_0_3;
  wire [2:0] act5_9_1_3;
  wire [2:0] act5_10_0_1;
  wire [2:0] act5_10_1_1;
  wire [2:0] act5_10_0_2;
  wire [2:0] act5_10_1_2;
  wire [2:0] act5_10_0_3;
  wire [2:0] act5_10_1_3;
  wire [2:0] act5_11_0_1;
  wire [2:0] act5_11_1_1;
  wire [2:0] act5_11_0_2;
  wire [2:0] act5_11_1_2;
  wire [2:0] act5_11_0_3;
  wire [2:0] act5_11_1_3;
  wire [2:0] act5_12_0_1;
  wire [2:0] act5_12_1_1;
  wire [2:0] act5_12_0_2;
  wire [2:0] act5_12_1_2;
  wire [2:0] act5_12_0_3;
  wire [2:0] act5_12_1_3;
  wire [2:0] act5_13_0_1;
  wire [2:0] act5_13_1_1;
  wire [2:0] act5_13_0_2;
  wire [2:0] act5_13_1_2;
  wire [2:0] act5_13_0_3;
  wire [2:0] act5_13_1_3;
  wire [2:0] act5_14_0_1;
  wire [2:0] act5_14_1_1;
  wire [2:0] act5_14_0_2;
  wire [2:0] act5_14_1_2;
  wire [2:0] act5_14_0_3;
  wire [2:0] act5_14_1_3;
  wire [2:0] act5_15_0_1;
  wire [2:0] act5_15_1_1;
  wire [2:0] act5_15_0_2;
  wire [2:0] act5_15_1_2;
  wire [2:0] act5_15_0_3;
  wire [2:0] act5_15_1_3;
  wire [2:0] act6_0_0_1;
  wire [2:0] act6_0_1_1;
  wire [2:0] act6_0_0_2;
  wire [2:0] act6_0_1_2;
  wire [2:0] act6_0_0_3;
  wire [2:0] act6_0_1_3;
  wire [2:0] act6_1_0_1;
  wire [2:0] act6_1_1_1;
  wire [2:0] act6_1_0_2;
  wire [2:0] act6_1_1_2;
  wire [2:0] act6_1_0_3;
  wire [2:0] act6_1_1_3;
  wire [2:0] act6_2_0_1;
  wire [2:0] act6_2_1_1;
  wire [2:0] act6_2_0_2;
  wire [2:0] act6_2_1_2;
  wire [2:0] act6_2_0_3;
  wire [2:0] act6_2_1_3;
  wire [2:0] act6_3_0_1;
  wire [2:0] act6_3_1_1;
  wire [2:0] act6_3_0_2;
  wire [2:0] act6_3_1_2;
  wire [2:0] act6_3_0_3;
  wire [2:0] act6_3_1_3;
  wire [2:0] act6_4_0_1;
  wire [2:0] act6_4_1_1;
  wire [2:0] act6_4_0_2;
  wire [2:0] act6_4_1_2;
  wire [2:0] act6_4_0_3;
  wire [2:0] act6_4_1_3;
  wire [2:0] act6_5_0_1;
  wire [2:0] act6_5_1_1;
  wire [2:0] act6_5_0_2;
  wire [2:0] act6_5_1_2;
  wire [2:0] act6_5_0_3;
  wire [2:0] act6_5_1_3;
  wire [2:0] act6_6_0_1;
  wire [2:0] act6_6_1_1;
  wire [2:0] act6_6_0_2;
  wire [2:0] act6_6_1_2;
  wire [2:0] act6_6_0_3;
  wire [2:0] act6_6_1_3;
  wire [2:0] act6_7_0_1;
  wire [2:0] act6_7_1_1;
  wire [2:0] act6_7_0_2;
  wire [2:0] act6_7_1_2;
  wire [2:0] act6_7_0_3;
  wire [2:0] act6_7_1_3;
  wire [2:0] act6_8_0_1;
  wire [2:0] act6_8_1_1;
  wire [2:0] act6_8_0_2;
  wire [2:0] act6_8_1_2;
  wire [2:0] act6_8_0_3;
  wire [2:0] act6_8_1_3;
  wire [2:0] act6_9_0_1;
  wire [2:0] act6_9_1_1;
  wire [2:0] act6_9_0_2;
  wire [2:0] act6_9_1_2;
  wire [2:0] act6_9_0_3;
  wire [2:0] act6_9_1_3;
  wire [2:0] act6_10_0_1;
  wire [2:0] act6_10_1_1;
  wire [2:0] act6_10_0_2;
  wire [2:0] act6_10_1_2;
  wire [2:0] act6_10_0_3;
  wire [2:0] act6_10_1_3;
  wire [2:0] act6_11_0_1;
  wire [2:0] act6_11_1_1;
  wire [2:0] act6_11_0_2;
  wire [2:0] act6_11_1_2;
  wire [2:0] act6_11_0_3;
  wire [2:0] act6_11_1_3;
  wire [2:0] act6_12_0_1;
  wire [2:0] act6_12_1_1;
  wire [2:0] act6_12_0_2;
  wire [2:0] act6_12_1_2;
  wire [2:0] act6_12_0_3;
  wire [2:0] act6_12_1_3;
  wire [2:0] act6_13_0_1;
  wire [2:0] act6_13_1_1;
  wire [2:0] act6_13_0_2;
  wire [2:0] act6_13_1_2;
  wire [2:0] act6_13_0_3;
  wire [2:0] act6_13_1_3;
  wire [2:0] act6_14_0_1;
  wire [2:0] act6_14_1_1;
  wire [2:0] act6_14_0_2;
  wire [2:0] act6_14_1_2;
  wire [2:0] act6_14_0_3;
  wire [2:0] act6_14_1_3;
  wire [2:0] act6_15_0_1;
  wire [2:0] act6_15_1_1;
  wire [2:0] act6_15_0_2;
  wire [2:0] act6_15_1_2;
  wire [2:0] act6_15_0_3;
  wire [2:0] act6_15_1_3;
  wire [2:0] act7_0_0_1;
  wire [2:0] act7_0_1_1;
  wire [2:0] act7_0_0_2;
  wire [2:0] act7_0_1_2;
  wire [2:0] act7_0_0_3;
  wire [2:0] act7_0_1_3;
  wire [2:0] act7_1_0_1;
  wire [2:0] act7_1_1_1;
  wire [2:0] act7_1_0_2;
  wire [2:0] act7_1_1_2;
  wire [2:0] act7_1_0_3;
  wire [2:0] act7_1_1_3;
  wire [2:0] act7_2_0_1;
  wire [2:0] act7_2_1_1;
  wire [2:0] act7_2_0_2;
  wire [2:0] act7_2_1_2;
  wire [2:0] act7_2_0_3;
  wire [2:0] act7_2_1_3;
  wire [2:0] act7_3_0_1;
  wire [2:0] act7_3_1_1;
  wire [2:0] act7_3_0_2;
  wire [2:0] act7_3_1_2;
  wire [2:0] act7_3_0_3;
  wire [2:0] act7_3_1_3;
  wire [2:0] act7_4_0_1;
  wire [2:0] act7_4_1_1;
  wire [2:0] act7_4_0_2;
  wire [2:0] act7_4_1_2;
  wire [2:0] act7_4_0_3;
  wire [2:0] act7_4_1_3;
  wire [2:0] act7_5_0_1;
  wire [2:0] act7_5_1_1;
  wire [2:0] act7_5_0_2;
  wire [2:0] act7_5_1_2;
  wire [2:0] act7_5_0_3;
  wire [2:0] act7_5_1_3;
  wire [2:0] act7_6_0_1;
  wire [2:0] act7_6_1_1;
  wire [2:0] act7_6_0_2;
  wire [2:0] act7_6_1_2;
  wire [2:0] act7_6_0_3;
  wire [2:0] act7_6_1_3;
  wire [2:0] act7_7_0_1;
  wire [2:0] act7_7_1_1;
  wire [2:0] act7_7_0_2;
  wire [2:0] act7_7_1_2;
  wire [2:0] act7_7_0_3;
  wire [2:0] act7_7_1_3;
  wire [2:0] act7_8_0_1;
  wire [2:0] act7_8_1_1;
  wire [2:0] act7_8_0_2;
  wire [2:0] act7_8_1_2;
  wire [2:0] act7_8_0_3;
  wire [2:0] act7_8_1_3;
  wire [2:0] act7_9_0_1;
  wire [2:0] act7_9_1_1;
  wire [2:0] act7_9_0_2;
  wire [2:0] act7_9_1_2;
  wire [2:0] act7_9_0_3;
  wire [2:0] act7_9_1_3;
  wire [2:0] act7_10_0_1;
  wire [2:0] act7_10_1_1;
  wire [2:0] act7_10_0_2;
  wire [2:0] act7_10_1_2;
  wire [2:0] act7_10_0_3;
  wire [2:0] act7_10_1_3;
  wire [2:0] act7_11_0_1;
  wire [2:0] act7_11_1_1;
  wire [2:0] act7_11_0_2;
  wire [2:0] act7_11_1_2;
  wire [2:0] act7_11_0_3;
  wire [2:0] act7_11_1_3;
  wire [2:0] act7_12_0_1;
  wire [2:0] act7_12_1_1;
  wire [2:0] act7_12_0_2;
  wire [2:0] act7_12_1_2;
  wire [2:0] act7_12_0_3;
  wire [2:0] act7_12_1_3;
  wire [2:0] act7_13_0_1;
  wire [2:0] act7_13_1_1;
  wire [2:0] act7_13_0_2;
  wire [2:0] act7_13_1_2;
  wire [2:0] act7_13_0_3;
  wire [2:0] act7_13_1_3;
  wire [2:0] act7_14_0_1;
  wire [2:0] act7_14_1_1;
  wire [2:0] act7_14_0_2;
  wire [2:0] act7_14_1_2;
  wire [2:0] act7_14_0_3;
  wire [2:0] act7_14_1_3;
  wire [2:0] act7_15_0_1;
  wire [2:0] act7_15_1_1;
  wire [2:0] act7_15_0_2;
  wire [2:0] act7_15_1_2;
  wire [2:0] act7_15_0_3;
  wire [2:0] act7_15_1_3;
  

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
  assign act0_8_0_1= act0_0_8;
  assign act0_8_1_1= act0_1_8;
  assign act0_8_0_2= act0_0_8;
  assign act0_8_1_2= act0_1_8;
  assign act0_8_0_3= act0_0_8;
  assign act0_8_1_3= act0_1_8;
  assign act0_9_0_1= act0_0_9;
  assign act0_9_1_1= act0_1_9;
  assign act0_9_0_2= act0_0_9;
  assign act0_9_1_2= act0_1_9;
  assign act0_9_0_3= act0_0_9;
  assign act0_9_1_3= act0_1_9;
  assign act0_10_0_1= act0_0_10;
  assign act0_10_1_1= act0_1_10;
  assign act0_10_0_2= act0_0_10;
  assign act0_10_1_2= act0_1_10;
  assign act0_10_0_3= act0_0_10;
  assign act0_10_1_3= act0_1_10;
  assign act0_11_0_1= act0_0_11;
  assign act0_11_1_1= act0_1_11;
  assign act0_11_0_2= act0_0_11;
  assign act0_11_1_2= act0_1_11;
  assign act0_11_0_3= act0_0_11;
  assign act0_11_1_3= act0_1_11;
  assign act0_12_0_1= act0_0_12;
  assign act0_12_1_1= act0_1_12;
  assign act0_12_0_2= act0_0_12;
  assign act0_12_1_2= act0_1_12;
  assign act0_12_0_3= act0_0_12;
  assign act0_12_1_3= act0_1_12;
  assign act0_13_0_1= act0_0_13;
  assign act0_13_1_1= act0_1_13;
  assign act0_13_0_2= act0_0_13;
  assign act0_13_1_2= act0_1_13;
  assign act0_13_0_3= act0_0_13;
  assign act0_13_1_3= act0_1_13;
  assign act0_14_0_1= act0_0_14;
  assign act0_14_1_1= act0_1_14;
  assign act0_14_0_2= act0_0_14;
  assign act0_14_1_2= act0_1_14;
  assign act0_14_0_3= act0_0_14;
  assign act0_14_1_3= act0_1_14;
  assign act0_15_0_1= act0_0_15;
  assign act0_15_1_1= act0_1_15;
  assign act0_15_0_2= act0_0_15;
  assign act0_15_1_2= act0_1_15;
  assign act0_15_0_3= act0_0_15;
  assign act0_15_1_3= act0_1_15;
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
  assign act1_8_0_1= act1_0_8;
  assign act1_8_1_1= act1_1_8;
  assign act1_8_0_2= act1_0_8;
  assign act1_8_1_2= act1_1_8;
  assign act1_8_0_3= act1_0_8;
  assign act1_8_1_3= act1_1_8;
  assign act1_9_0_1= act1_0_9;
  assign act1_9_1_1= act1_1_9;
  assign act1_9_0_2= act1_0_9;
  assign act1_9_1_2= act1_1_9;
  assign act1_9_0_3= act1_0_9;
  assign act1_9_1_3= act1_1_9;
  assign act1_10_0_1= act1_0_10;
  assign act1_10_1_1= act1_1_10;
  assign act1_10_0_2= act1_0_10;
  assign act1_10_1_2= act1_1_10;
  assign act1_10_0_3= act1_0_10;
  assign act1_10_1_3= act1_1_10;
  assign act1_11_0_1= act1_0_11;
  assign act1_11_1_1= act1_1_11;
  assign act1_11_0_2= act1_0_11;
  assign act1_11_1_2= act1_1_11;
  assign act1_11_0_3= act1_0_11;
  assign act1_11_1_3= act1_1_11;
  assign act1_12_0_1= act1_0_12;
  assign act1_12_1_1= act1_1_12;
  assign act1_12_0_2= act1_0_12;
  assign act1_12_1_2= act1_1_12;
  assign act1_12_0_3= act1_0_12;
  assign act1_12_1_3= act1_1_12;
  assign act1_13_0_1= act1_0_13;
  assign act1_13_1_1= act1_1_13;
  assign act1_13_0_2= act1_0_13;
  assign act1_13_1_2= act1_1_13;
  assign act1_13_0_3= act1_0_13;
  assign act1_13_1_3= act1_1_13;
  assign act1_14_0_1= act1_0_14;
  assign act1_14_1_1= act1_1_14;
  assign act1_14_0_2= act1_0_14;
  assign act1_14_1_2= act1_1_14;
  assign act1_14_0_3= act1_0_14;
  assign act1_14_1_3= act1_1_14;
  assign act1_15_0_1= act1_0_15;
  assign act1_15_1_1= act1_1_15;
  assign act1_15_0_2= act1_0_15;
  assign act1_15_1_2= act1_1_15;
  assign act1_15_0_3= act1_0_15;
  assign act1_15_1_3= act1_1_15;
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
  assign act2_8_0_1= act2_0_8;
  assign act2_8_1_1= act2_1_8;
  assign act2_8_0_2= act2_0_8;
  assign act2_8_1_2= act2_1_8;
  assign act2_8_0_3= act2_0_8;
  assign act2_8_1_3= act2_1_8;
  assign act2_9_0_1= act2_0_9;
  assign act2_9_1_1= act2_1_9;
  assign act2_9_0_2= act2_0_9;
  assign act2_9_1_2= act2_1_9;
  assign act2_9_0_3= act2_0_9;
  assign act2_9_1_3= act2_1_9;
  assign act2_10_0_1= act2_0_10;
  assign act2_10_1_1= act2_1_10;
  assign act2_10_0_2= act2_0_10;
  assign act2_10_1_2= act2_1_10;
  assign act2_10_0_3= act2_0_10;
  assign act2_10_1_3= act2_1_10;
  assign act2_11_0_1= act2_0_11;
  assign act2_11_1_1= act2_1_11;
  assign act2_11_0_2= act2_0_11;
  assign act2_11_1_2= act2_1_11;
  assign act2_11_0_3= act2_0_11;
  assign act2_11_1_3= act2_1_11;
  assign act2_12_0_1= act2_0_12;
  assign act2_12_1_1= act2_1_12;
  assign act2_12_0_2= act2_0_12;
  assign act2_12_1_2= act2_1_12;
  assign act2_12_0_3= act2_0_12;
  assign act2_12_1_3= act2_1_12;
  assign act2_13_0_1= act2_0_13;
  assign act2_13_1_1= act2_1_13;
  assign act2_13_0_2= act2_0_13;
  assign act2_13_1_2= act2_1_13;
  assign act2_13_0_3= act2_0_13;
  assign act2_13_1_3= act2_1_13;
  assign act2_14_0_1= act2_0_14;
  assign act2_14_1_1= act2_1_14;
  assign act2_14_0_2= act2_0_14;
  assign act2_14_1_2= act2_1_14;
  assign act2_14_0_3= act2_0_14;
  assign act2_14_1_3= act2_1_14;
  assign act2_15_0_1= act2_0_15;
  assign act2_15_1_1= act2_1_15;
  assign act2_15_0_2= act2_0_15;
  assign act2_15_1_2= act2_1_15;
  assign act2_15_0_3= act2_0_15;
  assign act2_15_1_3= act2_1_15;
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
  assign act3_8_0_1= act3_0_8;
  assign act3_8_1_1= act3_1_8;
  assign act3_8_0_2= act3_0_8;
  assign act3_8_1_2= act3_1_8;
  assign act3_8_0_3= act3_0_8;
  assign act3_8_1_3= act3_1_8;
  assign act3_9_0_1= act3_0_9;
  assign act3_9_1_1= act3_1_9;
  assign act3_9_0_2= act3_0_9;
  assign act3_9_1_2= act3_1_9;
  assign act3_9_0_3= act3_0_9;
  assign act3_9_1_3= act3_1_9;
  assign act3_10_0_1= act3_0_10;
  assign act3_10_1_1= act3_1_10;
  assign act3_10_0_2= act3_0_10;
  assign act3_10_1_2= act3_1_10;
  assign act3_10_0_3= act3_0_10;
  assign act3_10_1_3= act3_1_10;
  assign act3_11_0_1= act3_0_11;
  assign act3_11_1_1= act3_1_11;
  assign act3_11_0_2= act3_0_11;
  assign act3_11_1_2= act3_1_11;
  assign act3_11_0_3= act3_0_11;
  assign act3_11_1_3= act3_1_11;
  assign act3_12_0_1= act3_0_12;
  assign act3_12_1_1= act3_1_12;
  assign act3_12_0_2= act3_0_12;
  assign act3_12_1_2= act3_1_12;
  assign act3_12_0_3= act3_0_12;
  assign act3_12_1_3= act3_1_12;
  assign act3_13_0_1= act3_0_13;
  assign act3_13_1_1= act3_1_13;
  assign act3_13_0_2= act3_0_13;
  assign act3_13_1_2= act3_1_13;
  assign act3_13_0_3= act3_0_13;
  assign act3_13_1_3= act3_1_13;
  assign act3_14_0_1= act3_0_14;
  assign act3_14_1_1= act3_1_14;
  assign act3_14_0_2= act3_0_14;
  assign act3_14_1_2= act3_1_14;
  assign act3_14_0_3= act3_0_14;
  assign act3_14_1_3= act3_1_14;
  assign act3_15_0_1= act3_0_15;
  assign act3_15_1_1= act3_1_15;
  assign act3_15_0_2= act3_0_15;
  assign act3_15_1_2= act3_1_15;
  assign act3_15_0_3= act3_0_15;
  assign act3_15_1_3= act3_1_15;
  assign act4_0_0_1= act4_0_0;
  assign act4_0_1_1= act4_1_0;
  assign act4_0_0_2= act4_0_0;
  assign act4_0_1_2= act4_1_0;
  assign act4_0_0_3= act4_0_0;
  assign act4_0_1_3= act4_1_0;
  assign act4_1_0_1= act4_0_1;
  assign act4_1_1_1= act4_1_1;
  assign act4_1_0_2= act4_0_1;
  assign act4_1_1_2= act4_1_1;
  assign act4_1_0_3= act4_0_1;
  assign act4_1_1_3= act4_1_1;
  assign act4_2_0_1= act4_0_2;
  assign act4_2_1_1= act4_1_2;
  assign act4_2_0_2= act4_0_2;
  assign act4_2_1_2= act4_1_2;
  assign act4_2_0_3= act4_0_2;
  assign act4_2_1_3= act4_1_2;
  assign act4_3_0_1= act4_0_3;
  assign act4_3_1_1= act4_1_3;
  assign act4_3_0_2= act4_0_3;
  assign act4_3_1_2= act4_1_3;
  assign act4_3_0_3= act4_0_3;
  assign act4_3_1_3= act4_1_3;
  assign act4_4_0_1= act4_0_4;
  assign act4_4_1_1= act4_1_4;
  assign act4_4_0_2= act4_0_4;
  assign act4_4_1_2= act4_1_4;
  assign act4_4_0_3= act4_0_4;
  assign act4_4_1_3= act4_1_4;
  assign act4_5_0_1= act4_0_5;
  assign act4_5_1_1= act4_1_5;
  assign act4_5_0_2= act4_0_5;
  assign act4_5_1_2= act4_1_5;
  assign act4_5_0_3= act4_0_5;
  assign act4_5_1_3= act4_1_5;
  assign act4_6_0_1= act4_0_6;
  assign act4_6_1_1= act4_1_6;
  assign act4_6_0_2= act4_0_6;
  assign act4_6_1_2= act4_1_6;
  assign act4_6_0_3= act4_0_6;
  assign act4_6_1_3= act4_1_6;
  assign act4_7_0_1= act4_0_7;
  assign act4_7_1_1= act4_1_7;
  assign act4_7_0_2= act4_0_7;
  assign act4_7_1_2= act4_1_7;
  assign act4_7_0_3= act4_0_7;
  assign act4_7_1_3= act4_1_7;
  assign act4_8_0_1= act4_0_8;
  assign act4_8_1_1= act4_1_8;
  assign act4_8_0_2= act4_0_8;
  assign act4_8_1_2= act4_1_8;
  assign act4_8_0_3= act4_0_8;
  assign act4_8_1_3= act4_1_8;
  assign act4_9_0_1= act4_0_9;
  assign act4_9_1_1= act4_1_9;
  assign act4_9_0_2= act4_0_9;
  assign act4_9_1_2= act4_1_9;
  assign act4_9_0_3= act4_0_9;
  assign act4_9_1_3= act4_1_9;
  assign act4_10_0_1= act4_0_10;
  assign act4_10_1_1= act4_1_10;
  assign act4_10_0_2= act4_0_10;
  assign act4_10_1_2= act4_1_10;
  assign act4_10_0_3= act4_0_10;
  assign act4_10_1_3= act4_1_10;
  assign act4_11_0_1= act4_0_11;
  assign act4_11_1_1= act4_1_11;
  assign act4_11_0_2= act4_0_11;
  assign act4_11_1_2= act4_1_11;
  assign act4_11_0_3= act4_0_11;
  assign act4_11_1_3= act4_1_11;
  assign act4_12_0_1= act4_0_12;
  assign act4_12_1_1= act4_1_12;
  assign act4_12_0_2= act4_0_12;
  assign act4_12_1_2= act4_1_12;
  assign act4_12_0_3= act4_0_12;
  assign act4_12_1_3= act4_1_12;
  assign act4_13_0_1= act4_0_13;
  assign act4_13_1_1= act4_1_13;
  assign act4_13_0_2= act4_0_13;
  assign act4_13_1_2= act4_1_13;
  assign act4_13_0_3= act4_0_13;
  assign act4_13_1_3= act4_1_13;
  assign act4_14_0_1= act4_0_14;
  assign act4_14_1_1= act4_1_14;
  assign act4_14_0_2= act4_0_14;
  assign act4_14_1_2= act4_1_14;
  assign act4_14_0_3= act4_0_14;
  assign act4_14_1_3= act4_1_14;
  assign act4_15_0_1= act4_0_15;
  assign act4_15_1_1= act4_1_15;
  assign act4_15_0_2= act4_0_15;
  assign act4_15_1_2= act4_1_15;
  assign act4_15_0_3= act4_0_15;
  assign act4_15_1_3= act4_1_15;
  assign act5_0_0_1= act5_0_0;
  assign act5_0_1_1= act5_1_0;
  assign act5_0_0_2= act5_0_0;
  assign act5_0_1_2= act5_1_0;
  assign act5_0_0_3= act5_0_0;
  assign act5_0_1_3= act5_1_0;
  assign act5_1_0_1= act5_0_1;
  assign act5_1_1_1= act5_1_1;
  assign act5_1_0_2= act5_0_1;
  assign act5_1_1_2= act5_1_1;
  assign act5_1_0_3= act5_0_1;
  assign act5_1_1_3= act5_1_1;
  assign act5_2_0_1= act5_0_2;
  assign act5_2_1_1= act5_1_2;
  assign act5_2_0_2= act5_0_2;
  assign act5_2_1_2= act5_1_2;
  assign act5_2_0_3= act5_0_2;
  assign act5_2_1_3= act5_1_2;
  assign act5_3_0_1= act5_0_3;
  assign act5_3_1_1= act5_1_3;
  assign act5_3_0_2= act5_0_3;
  assign act5_3_1_2= act5_1_3;
  assign act5_3_0_3= act5_0_3;
  assign act5_3_1_3= act5_1_3;
  assign act5_4_0_1= act5_0_4;
  assign act5_4_1_1= act5_1_4;
  assign act5_4_0_2= act5_0_4;
  assign act5_4_1_2= act5_1_4;
  assign act5_4_0_3= act5_0_4;
  assign act5_4_1_3= act5_1_4;
  assign act5_5_0_1= act5_0_5;
  assign act5_5_1_1= act5_1_5;
  assign act5_5_0_2= act5_0_5;
  assign act5_5_1_2= act5_1_5;
  assign act5_5_0_3= act5_0_5;
  assign act5_5_1_3= act5_1_5;
  assign act5_6_0_1= act5_0_6;
  assign act5_6_1_1= act5_1_6;
  assign act5_6_0_2= act5_0_6;
  assign act5_6_1_2= act5_1_6;
  assign act5_6_0_3= act5_0_6;
  assign act5_6_1_3= act5_1_6;
  assign act5_7_0_1= act5_0_7;
  assign act5_7_1_1= act5_1_7;
  assign act5_7_0_2= act5_0_7;
  assign act5_7_1_2= act5_1_7;
  assign act5_7_0_3= act5_0_7;
  assign act5_7_1_3= act5_1_7;
  assign act5_8_0_1= act5_0_8;
  assign act5_8_1_1= act5_1_8;
  assign act5_8_0_2= act5_0_8;
  assign act5_8_1_2= act5_1_8;
  assign act5_8_0_3= act5_0_8;
  assign act5_8_1_3= act5_1_8;
  assign act5_9_0_1= act5_0_9;
  assign act5_9_1_1= act5_1_9;
  assign act5_9_0_2= act5_0_9;
  assign act5_9_1_2= act5_1_9;
  assign act5_9_0_3= act5_0_9;
  assign act5_9_1_3= act5_1_9;
  assign act5_10_0_1= act5_0_10;
  assign act5_10_1_1= act5_1_10;
  assign act5_10_0_2= act5_0_10;
  assign act5_10_1_2= act5_1_10;
  assign act5_10_0_3= act5_0_10;
  assign act5_10_1_3= act5_1_10;
  assign act5_11_0_1= act5_0_11;
  assign act5_11_1_1= act5_1_11;
  assign act5_11_0_2= act5_0_11;
  assign act5_11_1_2= act5_1_11;
  assign act5_11_0_3= act5_0_11;
  assign act5_11_1_3= act5_1_11;
  assign act5_12_0_1= act5_0_12;
  assign act5_12_1_1= act5_1_12;
  assign act5_12_0_2= act5_0_12;
  assign act5_12_1_2= act5_1_12;
  assign act5_12_0_3= act5_0_12;
  assign act5_12_1_3= act5_1_12;
  assign act5_13_0_1= act5_0_13;
  assign act5_13_1_1= act5_1_13;
  assign act5_13_0_2= act5_0_13;
  assign act5_13_1_2= act5_1_13;
  assign act5_13_0_3= act5_0_13;
  assign act5_13_1_3= act5_1_13;
  assign act5_14_0_1= act5_0_14;
  assign act5_14_1_1= act5_1_14;
  assign act5_14_0_2= act5_0_14;
  assign act5_14_1_2= act5_1_14;
  assign act5_14_0_3= act5_0_14;
  assign act5_14_1_3= act5_1_14;
  assign act5_15_0_1= act5_0_15;
  assign act5_15_1_1= act5_1_15;
  assign act5_15_0_2= act5_0_15;
  assign act5_15_1_2= act5_1_15;
  assign act5_15_0_3= act5_0_15;
  assign act5_15_1_3= act5_1_15;
  assign act6_0_0_1= act6_0_0;
  assign act6_0_1_1= act6_1_0;
  assign act6_0_0_2= act6_0_0;
  assign act6_0_1_2= act6_1_0;
  assign act6_0_0_3= act6_0_0;
  assign act6_0_1_3= act6_1_0;
  assign act6_1_0_1= act6_0_1;
  assign act6_1_1_1= act6_1_1;
  assign act6_1_0_2= act6_0_1;
  assign act6_1_1_2= act6_1_1;
  assign act6_1_0_3= act6_0_1;
  assign act6_1_1_3= act6_1_1;
  assign act6_2_0_1= act6_0_2;
  assign act6_2_1_1= act6_1_2;
  assign act6_2_0_2= act6_0_2;
  assign act6_2_1_2= act6_1_2;
  assign act6_2_0_3= act6_0_2;
  assign act6_2_1_3= act6_1_2;
  assign act6_3_0_1= act6_0_3;
  assign act6_3_1_1= act6_1_3;
  assign act6_3_0_2= act6_0_3;
  assign act6_3_1_2= act6_1_3;
  assign act6_3_0_3= act6_0_3;
  assign act6_3_1_3= act6_1_3;
  assign act6_4_0_1= act6_0_4;
  assign act6_4_1_1= act6_1_4;
  assign act6_4_0_2= act6_0_4;
  assign act6_4_1_2= act6_1_4;
  assign act6_4_0_3= act6_0_4;
  assign act6_4_1_3= act6_1_4;
  assign act6_5_0_1= act6_0_5;
  assign act6_5_1_1= act6_1_5;
  assign act6_5_0_2= act6_0_5;
  assign act6_5_1_2= act6_1_5;
  assign act6_5_0_3= act6_0_5;
  assign act6_5_1_3= act6_1_5;
  assign act6_6_0_1= act6_0_6;
  assign act6_6_1_1= act6_1_6;
  assign act6_6_0_2= act6_0_6;
  assign act6_6_1_2= act6_1_6;
  assign act6_6_0_3= act6_0_6;
  assign act6_6_1_3= act6_1_6;
  assign act6_7_0_1= act6_0_7;
  assign act6_7_1_1= act6_1_7;
  assign act6_7_0_2= act6_0_7;
  assign act6_7_1_2= act6_1_7;
  assign act6_7_0_3= act6_0_7;
  assign act6_7_1_3= act6_1_7;
  assign act6_8_0_1= act6_0_8;
  assign act6_8_1_1= act6_1_8;
  assign act6_8_0_2= act6_0_8;
  assign act6_8_1_2= act6_1_8;
  assign act6_8_0_3= act6_0_8;
  assign act6_8_1_3= act6_1_8;
  assign act6_9_0_1= act6_0_9;
  assign act6_9_1_1= act6_1_9;
  assign act6_9_0_2= act6_0_9;
  assign act6_9_1_2= act6_1_9;
  assign act6_9_0_3= act6_0_9;
  assign act6_9_1_3= act6_1_9;
  assign act6_10_0_1= act6_0_10;
  assign act6_10_1_1= act6_1_10;
  assign act6_10_0_2= act6_0_10;
  assign act6_10_1_2= act6_1_10;
  assign act6_10_0_3= act6_0_10;
  assign act6_10_1_3= act6_1_10;
  assign act6_11_0_1= act6_0_11;
  assign act6_11_1_1= act6_1_11;
  assign act6_11_0_2= act6_0_11;
  assign act6_11_1_2= act6_1_11;
  assign act6_11_0_3= act6_0_11;
  assign act6_11_1_3= act6_1_11;
  assign act6_12_0_1= act6_0_12;
  assign act6_12_1_1= act6_1_12;
  assign act6_12_0_2= act6_0_12;
  assign act6_12_1_2= act6_1_12;
  assign act6_12_0_3= act6_0_12;
  assign act6_12_1_3= act6_1_12;
  assign act6_13_0_1= act6_0_13;
  assign act6_13_1_1= act6_1_13;
  assign act6_13_0_2= act6_0_13;
  assign act6_13_1_2= act6_1_13;
  assign act6_13_0_3= act6_0_13;
  assign act6_13_1_3= act6_1_13;
  assign act6_14_0_1= act6_0_14;
  assign act6_14_1_1= act6_1_14;
  assign act6_14_0_2= act6_0_14;
  assign act6_14_1_2= act6_1_14;
  assign act6_14_0_3= act6_0_14;
  assign act6_14_1_3= act6_1_14;
  assign act6_15_0_1= act6_0_15;
  assign act6_15_1_1= act6_1_15;
  assign act6_15_0_2= act6_0_15;
  assign act6_15_1_2= act6_1_15;
  assign act6_15_0_3= act6_0_15;
  assign act6_15_1_3= act6_1_15;
  assign act7_0_0_1= act7_0_0;
  assign act7_0_1_1= act7_1_0;
  assign act7_0_0_2= act7_0_0;
  assign act7_0_1_2= act7_1_0;
  assign act7_0_0_3= act7_0_0;
  assign act7_0_1_3= act7_1_0;
  assign act7_1_0_1= act7_0_1;
  assign act7_1_1_1= act7_1_1;
  assign act7_1_0_2= act7_0_1;
  assign act7_1_1_2= act7_1_1;
  assign act7_1_0_3= act7_0_1;
  assign act7_1_1_3= act7_1_1;
  assign act7_2_0_1= act7_0_2;
  assign act7_2_1_1= act7_1_2;
  assign act7_2_0_2= act7_0_2;
  assign act7_2_1_2= act7_1_2;
  assign act7_2_0_3= act7_0_2;
  assign act7_2_1_3= act7_1_2;
  assign act7_3_0_1= act7_0_3;
  assign act7_3_1_1= act7_1_3;
  assign act7_3_0_2= act7_0_3;
  assign act7_3_1_2= act7_1_3;
  assign act7_3_0_3= act7_0_3;
  assign act7_3_1_3= act7_1_3;
  assign act7_4_0_1= act7_0_4;
  assign act7_4_1_1= act7_1_4;
  assign act7_4_0_2= act7_0_4;
  assign act7_4_1_2= act7_1_4;
  assign act7_4_0_3= act7_0_4;
  assign act7_4_1_3= act7_1_4;
  assign act7_5_0_1= act7_0_5;
  assign act7_5_1_1= act7_1_5;
  assign act7_5_0_2= act7_0_5;
  assign act7_5_1_2= act7_1_5;
  assign act7_5_0_3= act7_0_5;
  assign act7_5_1_3= act7_1_5;
  assign act7_6_0_1= act7_0_6;
  assign act7_6_1_1= act7_1_6;
  assign act7_6_0_2= act7_0_6;
  assign act7_6_1_2= act7_1_6;
  assign act7_6_0_3= act7_0_6;
  assign act7_6_1_3= act7_1_6;
  assign act7_7_0_1= act7_0_7;
  assign act7_7_1_1= act7_1_7;
  assign act7_7_0_2= act7_0_7;
  assign act7_7_1_2= act7_1_7;
  assign act7_7_0_3= act7_0_7;
  assign act7_7_1_3= act7_1_7;
  assign act7_8_0_1= act7_0_8;
  assign act7_8_1_1= act7_1_8;
  assign act7_8_0_2= act7_0_8;
  assign act7_8_1_2= act7_1_8;
  assign act7_8_0_3= act7_0_8;
  assign act7_8_1_3= act7_1_8;
  assign act7_9_0_1= act7_0_9;
  assign act7_9_1_1= act7_1_9;
  assign act7_9_0_2= act7_0_9;
  assign act7_9_1_2= act7_1_9;
  assign act7_9_0_3= act7_0_9;
  assign act7_9_1_3= act7_1_9;
  assign act7_10_0_1= act7_0_10;
  assign act7_10_1_1= act7_1_10;
  assign act7_10_0_2= act7_0_10;
  assign act7_10_1_2= act7_1_10;
  assign act7_10_0_3= act7_0_10;
  assign act7_10_1_3= act7_1_10;
  assign act7_11_0_1= act7_0_11;
  assign act7_11_1_1= act7_1_11;
  assign act7_11_0_2= act7_0_11;
  assign act7_11_1_2= act7_1_11;
  assign act7_11_0_3= act7_0_11;
  assign act7_11_1_3= act7_1_11;
  assign act7_12_0_1= act7_0_12;
  assign act7_12_1_1= act7_1_12;
  assign act7_12_0_2= act7_0_12;
  assign act7_12_1_2= act7_1_12;
  assign act7_12_0_3= act7_0_12;
  assign act7_12_1_3= act7_1_12;
  assign act7_13_0_1= act7_0_13;
  assign act7_13_1_1= act7_1_13;
  assign act7_13_0_2= act7_0_13;
  assign act7_13_1_2= act7_1_13;
  assign act7_13_0_3= act7_0_13;
  assign act7_13_1_3= act7_1_13;
  assign act7_14_0_1= act7_0_14;
  assign act7_14_1_1= act7_1_14;
  assign act7_14_0_2= act7_0_14;
  assign act7_14_1_2= act7_1_14;
  assign act7_14_0_3= act7_0_14;
  assign act7_14_1_3= act7_1_14;
  assign act7_15_0_1= act7_0_15;
  assign act7_15_1_1= act7_1_15;
  assign act7_15_0_2= act7_0_15;
  assign act7_15_1_2= act7_1_15;
  assign act7_15_0_3= act7_0_15;
  assign act7_15_1_3= act7_1_15;
 
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
  weighted_inputs_1 w1_8    (.inputs(inputs8_1), .w(w1_0_1[8]), .wi(weighted_inputs1_8_0));
  weighted_inputs_1 w1_8_bar(.inputs(inputs8_1), .w(w1_1_1[8]), .wi(weighted_inputs1_8_1));
  weighted_inputs_1 w1_9    (.inputs(inputs9_1), .w(w1_0_1[9]), .wi(weighted_inputs1_9_0));
  weighted_inputs_1 w1_9_bar(.inputs(inputs9_1), .w(w1_1_1[9]), .wi(weighted_inputs1_9_1));
  weighted_inputs_1 w1_10    (.inputs(inputs10_1), .w(w1_0_1[10]), .wi(weighted_inputs1_10_0));
  weighted_inputs_1 w1_10_bar(.inputs(inputs10_1), .w(w1_1_1[10]), .wi(weighted_inputs1_10_1));
  weighted_inputs_1 w1_11    (.inputs(inputs11_1), .w(w1_0_1[11]), .wi(weighted_inputs1_11_0));
  weighted_inputs_1 w1_11_bar(.inputs(inputs11_1), .w(w1_1_1[11]), .wi(weighted_inputs1_11_1));
  weighted_inputs_1 w1_12    (.inputs(inputs12_1), .w(w1_0_1[12]), .wi(weighted_inputs1_12_0));
  weighted_inputs_1 w1_12_bar(.inputs(inputs12_1), .w(w1_1_1[12]), .wi(weighted_inputs1_12_1));
  weighted_inputs_1 w1_13    (.inputs(inputs13_1), .w(w1_0_1[13]), .wi(weighted_inputs1_13_0));
  weighted_inputs_1 w1_13_bar(.inputs(inputs13_1), .w(w1_1_1[13]), .wi(weighted_inputs1_13_1));
  weighted_inputs_1 w1_14    (.inputs(inputs14_1), .w(w1_0_1[14]), .wi(weighted_inputs1_14_0));
  weighted_inputs_1 w1_14_bar(.inputs(inputs14_1), .w(w1_1_1[14]), .wi(weighted_inputs1_14_1));
  weighted_inputs_1 w1_15    (.inputs(inputs15_1), .w(w1_0_1[15]), .wi(weighted_inputs1_15_0));
  weighted_inputs_1 w1_15_bar(.inputs(inputs15_1), .w(w1_1_1[15]), .wi(weighted_inputs1_15_1));
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
  weighted_inputs_1 w2_8    (.inputs(inputs8_1), .w(w2_0_1[8]), .wi(weighted_inputs2_8_0));
  weighted_inputs_1 w2_8_bar(.inputs(inputs8_1), .w(w2_1_1[8]), .wi(weighted_inputs2_8_1));
  weighted_inputs_1 w2_9    (.inputs(inputs9_1), .w(w2_0_1[9]), .wi(weighted_inputs2_9_0));
  weighted_inputs_1 w2_9_bar(.inputs(inputs9_1), .w(w2_1_1[9]), .wi(weighted_inputs2_9_1));
  weighted_inputs_1 w2_10    (.inputs(inputs10_1), .w(w2_0_1[10]), .wi(weighted_inputs2_10_0));
  weighted_inputs_1 w2_10_bar(.inputs(inputs10_1), .w(w2_1_1[10]), .wi(weighted_inputs2_10_1));
  weighted_inputs_1 w2_11    (.inputs(inputs11_1), .w(w2_0_1[11]), .wi(weighted_inputs2_11_0));
  weighted_inputs_1 w2_11_bar(.inputs(inputs11_1), .w(w2_1_1[11]), .wi(weighted_inputs2_11_1));
  weighted_inputs_1 w2_12    (.inputs(inputs12_1), .w(w2_0_1[12]), .wi(weighted_inputs2_12_0));
  weighted_inputs_1 w2_12_bar(.inputs(inputs12_1), .w(w2_1_1[12]), .wi(weighted_inputs2_12_1));
  weighted_inputs_1 w2_13    (.inputs(inputs13_1), .w(w2_0_1[13]), .wi(weighted_inputs2_13_0));
  weighted_inputs_1 w2_13_bar(.inputs(inputs13_1), .w(w2_1_1[13]), .wi(weighted_inputs2_13_1));
  weighted_inputs_1 w2_14    (.inputs(inputs14_1), .w(w2_0_1[14]), .wi(weighted_inputs2_14_0));
  weighted_inputs_1 w2_14_bar(.inputs(inputs14_1), .w(w2_1_1[14]), .wi(weighted_inputs2_14_1));
  weighted_inputs_1 w2_15    (.inputs(inputs15_1), .w(w2_0_1[15]), .wi(weighted_inputs2_15_0));
  weighted_inputs_1 w2_15_bar(.inputs(inputs15_1), .w(w2_1_1[15]), .wi(weighted_inputs2_15_1));
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
  weighted_inputs_1 w3_8    (.inputs(inputs8_1), .w(w3_0_1[8]), .wi(weighted_inputs3_8_0));
  weighted_inputs_1 w3_8_bar(.inputs(inputs8_1), .w(w3_1_1[8]), .wi(weighted_inputs3_8_1));
  weighted_inputs_1 w3_9    (.inputs(inputs9_1), .w(w3_0_1[9]), .wi(weighted_inputs3_9_0));
  weighted_inputs_1 w3_9_bar(.inputs(inputs9_1), .w(w3_1_1[9]), .wi(weighted_inputs3_9_1));
  weighted_inputs_1 w3_10    (.inputs(inputs10_1), .w(w3_0_1[10]), .wi(weighted_inputs3_10_0));
  weighted_inputs_1 w3_10_bar(.inputs(inputs10_1), .w(w3_1_1[10]), .wi(weighted_inputs3_10_1));
  weighted_inputs_1 w3_11    (.inputs(inputs11_1), .w(w3_0_1[11]), .wi(weighted_inputs3_11_0));
  weighted_inputs_1 w3_11_bar(.inputs(inputs11_1), .w(w3_1_1[11]), .wi(weighted_inputs3_11_1));
  weighted_inputs_1 w3_12    (.inputs(inputs12_1), .w(w3_0_1[12]), .wi(weighted_inputs3_12_0));
  weighted_inputs_1 w3_12_bar(.inputs(inputs12_1), .w(w3_1_1[12]), .wi(weighted_inputs3_12_1));
  weighted_inputs_1 w3_13    (.inputs(inputs13_1), .w(w3_0_1[13]), .wi(weighted_inputs3_13_0));
  weighted_inputs_1 w3_13_bar(.inputs(inputs13_1), .w(w3_1_1[13]), .wi(weighted_inputs3_13_1));
  weighted_inputs_1 w3_14    (.inputs(inputs14_1), .w(w3_0_1[14]), .wi(weighted_inputs3_14_0));
  weighted_inputs_1 w3_14_bar(.inputs(inputs14_1), .w(w3_1_1[14]), .wi(weighted_inputs3_14_1));
  weighted_inputs_1 w3_15    (.inputs(inputs15_1), .w(w3_0_1[15]), .wi(weighted_inputs3_15_0));
  weighted_inputs_1 w3_15_bar(.inputs(inputs15_1), .w(w3_1_1[15]), .wi(weighted_inputs3_15_1));
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
  weighted_inputs_1 w4_8    (.inputs(inputs8_1), .w(w4_0_1[8]), .wi(weighted_inputs4_8_0));
  weighted_inputs_1 w4_8_bar(.inputs(inputs8_1), .w(w4_1_1[8]), .wi(weighted_inputs4_8_1));
  weighted_inputs_1 w4_9    (.inputs(inputs9_1), .w(w4_0_1[9]), .wi(weighted_inputs4_9_0));
  weighted_inputs_1 w4_9_bar(.inputs(inputs9_1), .w(w4_1_1[9]), .wi(weighted_inputs4_9_1));
  weighted_inputs_1 w4_10    (.inputs(inputs10_1), .w(w4_0_1[10]), .wi(weighted_inputs4_10_0));
  weighted_inputs_1 w4_10_bar(.inputs(inputs10_1), .w(w4_1_1[10]), .wi(weighted_inputs4_10_1));
  weighted_inputs_1 w4_11    (.inputs(inputs11_1), .w(w4_0_1[11]), .wi(weighted_inputs4_11_0));
  weighted_inputs_1 w4_11_bar(.inputs(inputs11_1), .w(w4_1_1[11]), .wi(weighted_inputs4_11_1));
  weighted_inputs_1 w4_12    (.inputs(inputs12_1), .w(w4_0_1[12]), .wi(weighted_inputs4_12_0));
  weighted_inputs_1 w4_12_bar(.inputs(inputs12_1), .w(w4_1_1[12]), .wi(weighted_inputs4_12_1));
  weighted_inputs_1 w4_13    (.inputs(inputs13_1), .w(w4_0_1[13]), .wi(weighted_inputs4_13_0));
  weighted_inputs_1 w4_13_bar(.inputs(inputs13_1), .w(w4_1_1[13]), .wi(weighted_inputs4_13_1));
  weighted_inputs_1 w4_14    (.inputs(inputs14_1), .w(w4_0_1[14]), .wi(weighted_inputs4_14_0));
  weighted_inputs_1 w4_14_bar(.inputs(inputs14_1), .w(w4_1_1[14]), .wi(weighted_inputs4_14_1));
  weighted_inputs_1 w4_15    (.inputs(inputs15_1), .w(w4_0_1[15]), .wi(weighted_inputs4_15_0));
  weighted_inputs_1 w4_15_bar(.inputs(inputs15_1), .w(w4_1_1[15]), .wi(weighted_inputs4_15_1));
  weighted_inputs_1 w5_0    (.inputs(inputs0_1), .w(w5_0_1[0]), .wi(weighted_inputs5_0_0));
  weighted_inputs_1 w5_0_bar(.inputs(inputs0_1), .w(w5_1_1[0]), .wi(weighted_inputs5_0_1));
  weighted_inputs_1 w5_1    (.inputs(inputs1_1), .w(w5_0_1[1]), .wi(weighted_inputs5_1_0));
  weighted_inputs_1 w5_1_bar(.inputs(inputs1_1), .w(w5_1_1[1]), .wi(weighted_inputs5_1_1));
  weighted_inputs_1 w5_2    (.inputs(inputs2_1), .w(w5_0_1[2]), .wi(weighted_inputs5_2_0));
  weighted_inputs_1 w5_2_bar(.inputs(inputs2_1), .w(w5_1_1[2]), .wi(weighted_inputs5_2_1));
  weighted_inputs_1 w5_3    (.inputs(inputs3_1), .w(w5_0_1[3]), .wi(weighted_inputs5_3_0));
  weighted_inputs_1 w5_3_bar(.inputs(inputs3_1), .w(w5_1_1[3]), .wi(weighted_inputs5_3_1));
  weighted_inputs_1 w5_4    (.inputs(inputs4_1), .w(w5_0_1[4]), .wi(weighted_inputs5_4_0));
  weighted_inputs_1 w5_4_bar(.inputs(inputs4_1), .w(w5_1_1[4]), .wi(weighted_inputs5_4_1));
  weighted_inputs_1 w5_5    (.inputs(inputs5_1), .w(w5_0_1[5]), .wi(weighted_inputs5_5_0));
  weighted_inputs_1 w5_5_bar(.inputs(inputs5_1), .w(w5_1_1[5]), .wi(weighted_inputs5_5_1));
  weighted_inputs_1 w5_6    (.inputs(inputs6_1), .w(w5_0_1[6]), .wi(weighted_inputs5_6_0));
  weighted_inputs_1 w5_6_bar(.inputs(inputs6_1), .w(w5_1_1[6]), .wi(weighted_inputs5_6_1));
  weighted_inputs_1 w5_7    (.inputs(inputs7_1), .w(w5_0_1[7]), .wi(weighted_inputs5_7_0));
  weighted_inputs_1 w5_7_bar(.inputs(inputs7_1), .w(w5_1_1[7]), .wi(weighted_inputs5_7_1));
  weighted_inputs_1 w5_8    (.inputs(inputs8_1), .w(w5_0_1[8]), .wi(weighted_inputs5_8_0));
  weighted_inputs_1 w5_8_bar(.inputs(inputs8_1), .w(w5_1_1[8]), .wi(weighted_inputs5_8_1));
  weighted_inputs_1 w5_9    (.inputs(inputs9_1), .w(w5_0_1[9]), .wi(weighted_inputs5_9_0));
  weighted_inputs_1 w5_9_bar(.inputs(inputs9_1), .w(w5_1_1[9]), .wi(weighted_inputs5_9_1));
  weighted_inputs_1 w5_10    (.inputs(inputs10_1), .w(w5_0_1[10]), .wi(weighted_inputs5_10_0));
  weighted_inputs_1 w5_10_bar(.inputs(inputs10_1), .w(w5_1_1[10]), .wi(weighted_inputs5_10_1));
  weighted_inputs_1 w5_11    (.inputs(inputs11_1), .w(w5_0_1[11]), .wi(weighted_inputs5_11_0));
  weighted_inputs_1 w5_11_bar(.inputs(inputs11_1), .w(w5_1_1[11]), .wi(weighted_inputs5_11_1));
  weighted_inputs_1 w5_12    (.inputs(inputs12_1), .w(w5_0_1[12]), .wi(weighted_inputs5_12_0));
  weighted_inputs_1 w5_12_bar(.inputs(inputs12_1), .w(w5_1_1[12]), .wi(weighted_inputs5_12_1));
  weighted_inputs_1 w5_13    (.inputs(inputs13_1), .w(w5_0_1[13]), .wi(weighted_inputs5_13_0));
  weighted_inputs_1 w5_13_bar(.inputs(inputs13_1), .w(w5_1_1[13]), .wi(weighted_inputs5_13_1));
  weighted_inputs_1 w5_14    (.inputs(inputs14_1), .w(w5_0_1[14]), .wi(weighted_inputs5_14_0));
  weighted_inputs_1 w5_14_bar(.inputs(inputs14_1), .w(w5_1_1[14]), .wi(weighted_inputs5_14_1));
  weighted_inputs_1 w5_15    (.inputs(inputs15_1), .w(w5_0_1[15]), .wi(weighted_inputs5_15_0));
  weighted_inputs_1 w5_15_bar(.inputs(inputs15_1), .w(w5_1_1[15]), .wi(weighted_inputs5_15_1));
  weighted_inputs_1 w6_0    (.inputs(inputs0_1), .w(w6_0_1[0]), .wi(weighted_inputs6_0_0));
  weighted_inputs_1 w6_0_bar(.inputs(inputs0_1), .w(w6_1_1[0]), .wi(weighted_inputs6_0_1));
  weighted_inputs_1 w6_1    (.inputs(inputs1_1), .w(w6_0_1[1]), .wi(weighted_inputs6_1_0));
  weighted_inputs_1 w6_1_bar(.inputs(inputs1_1), .w(w6_1_1[1]), .wi(weighted_inputs6_1_1));
  weighted_inputs_1 w6_2    (.inputs(inputs2_1), .w(w6_0_1[2]), .wi(weighted_inputs6_2_0));
  weighted_inputs_1 w6_2_bar(.inputs(inputs2_1), .w(w6_1_1[2]), .wi(weighted_inputs6_2_1));
  weighted_inputs_1 w6_3    (.inputs(inputs3_1), .w(w6_0_1[3]), .wi(weighted_inputs6_3_0));
  weighted_inputs_1 w6_3_bar(.inputs(inputs3_1), .w(w6_1_1[3]), .wi(weighted_inputs6_3_1));
  weighted_inputs_1 w6_4    (.inputs(inputs4_1), .w(w6_0_1[4]), .wi(weighted_inputs6_4_0));
  weighted_inputs_1 w6_4_bar(.inputs(inputs4_1), .w(w6_1_1[4]), .wi(weighted_inputs6_4_1));
  weighted_inputs_1 w6_5    (.inputs(inputs5_1), .w(w6_0_1[5]), .wi(weighted_inputs6_5_0));
  weighted_inputs_1 w6_5_bar(.inputs(inputs5_1), .w(w6_1_1[5]), .wi(weighted_inputs6_5_1));
  weighted_inputs_1 w6_6    (.inputs(inputs6_1), .w(w6_0_1[6]), .wi(weighted_inputs6_6_0));
  weighted_inputs_1 w6_6_bar(.inputs(inputs6_1), .w(w6_1_1[6]), .wi(weighted_inputs6_6_1));
  weighted_inputs_1 w6_7    (.inputs(inputs7_1), .w(w6_0_1[7]), .wi(weighted_inputs6_7_0));
  weighted_inputs_1 w6_7_bar(.inputs(inputs7_1), .w(w6_1_1[7]), .wi(weighted_inputs6_7_1));
  weighted_inputs_1 w6_8    (.inputs(inputs8_1), .w(w6_0_1[8]), .wi(weighted_inputs6_8_0));
  weighted_inputs_1 w6_8_bar(.inputs(inputs8_1), .w(w6_1_1[8]), .wi(weighted_inputs6_8_1));
  weighted_inputs_1 w6_9    (.inputs(inputs9_1), .w(w6_0_1[9]), .wi(weighted_inputs6_9_0));
  weighted_inputs_1 w6_9_bar(.inputs(inputs9_1), .w(w6_1_1[9]), .wi(weighted_inputs6_9_1));
  weighted_inputs_1 w6_10    (.inputs(inputs10_1), .w(w6_0_1[10]), .wi(weighted_inputs6_10_0));
  weighted_inputs_1 w6_10_bar(.inputs(inputs10_1), .w(w6_1_1[10]), .wi(weighted_inputs6_10_1));
  weighted_inputs_1 w6_11    (.inputs(inputs11_1), .w(w6_0_1[11]), .wi(weighted_inputs6_11_0));
  weighted_inputs_1 w6_11_bar(.inputs(inputs11_1), .w(w6_1_1[11]), .wi(weighted_inputs6_11_1));
  weighted_inputs_1 w6_12    (.inputs(inputs12_1), .w(w6_0_1[12]), .wi(weighted_inputs6_12_0));
  weighted_inputs_1 w6_12_bar(.inputs(inputs12_1), .w(w6_1_1[12]), .wi(weighted_inputs6_12_1));
  weighted_inputs_1 w6_13    (.inputs(inputs13_1), .w(w6_0_1[13]), .wi(weighted_inputs6_13_0));
  weighted_inputs_1 w6_13_bar(.inputs(inputs13_1), .w(w6_1_1[13]), .wi(weighted_inputs6_13_1));
  weighted_inputs_1 w6_14    (.inputs(inputs14_1), .w(w6_0_1[14]), .wi(weighted_inputs6_14_0));
  weighted_inputs_1 w6_14_bar(.inputs(inputs14_1), .w(w6_1_1[14]), .wi(weighted_inputs6_14_1));
  weighted_inputs_1 w6_15    (.inputs(inputs15_1), .w(w6_0_1[15]), .wi(weighted_inputs6_15_0));
  weighted_inputs_1 w6_15_bar(.inputs(inputs15_1), .w(w6_1_1[15]), .wi(weighted_inputs6_15_1));
  weighted_inputs_1 w7_0    (.inputs(inputs0_1), .w(w7_0_1[0]), .wi(weighted_inputs7_0_0));
  weighted_inputs_1 w7_0_bar(.inputs(inputs0_1), .w(w7_1_1[0]), .wi(weighted_inputs7_0_1));
  weighted_inputs_1 w7_1    (.inputs(inputs1_1), .w(w7_0_1[1]), .wi(weighted_inputs7_1_0));
  weighted_inputs_1 w7_1_bar(.inputs(inputs1_1), .w(w7_1_1[1]), .wi(weighted_inputs7_1_1));
  weighted_inputs_1 w7_2    (.inputs(inputs2_1), .w(w7_0_1[2]), .wi(weighted_inputs7_2_0));
  weighted_inputs_1 w7_2_bar(.inputs(inputs2_1), .w(w7_1_1[2]), .wi(weighted_inputs7_2_1));
  weighted_inputs_1 w7_3    (.inputs(inputs3_1), .w(w7_0_1[3]), .wi(weighted_inputs7_3_0));
  weighted_inputs_1 w7_3_bar(.inputs(inputs3_1), .w(w7_1_1[3]), .wi(weighted_inputs7_3_1));
  weighted_inputs_1 w7_4    (.inputs(inputs4_1), .w(w7_0_1[4]), .wi(weighted_inputs7_4_0));
  weighted_inputs_1 w7_4_bar(.inputs(inputs4_1), .w(w7_1_1[4]), .wi(weighted_inputs7_4_1));
  weighted_inputs_1 w7_5    (.inputs(inputs5_1), .w(w7_0_1[5]), .wi(weighted_inputs7_5_0));
  weighted_inputs_1 w7_5_bar(.inputs(inputs5_1), .w(w7_1_1[5]), .wi(weighted_inputs7_5_1));
  weighted_inputs_1 w7_6    (.inputs(inputs6_1), .w(w7_0_1[6]), .wi(weighted_inputs7_6_0));
  weighted_inputs_1 w7_6_bar(.inputs(inputs6_1), .w(w7_1_1[6]), .wi(weighted_inputs7_6_1));
  weighted_inputs_1 w7_7    (.inputs(inputs7_1), .w(w7_0_1[7]), .wi(weighted_inputs7_7_0));
  weighted_inputs_1 w7_7_bar(.inputs(inputs7_1), .w(w7_1_1[7]), .wi(weighted_inputs7_7_1));
  weighted_inputs_1 w7_8    (.inputs(inputs8_1), .w(w7_0_1[8]), .wi(weighted_inputs7_8_0));
  weighted_inputs_1 w7_8_bar(.inputs(inputs8_1), .w(w7_1_1[8]), .wi(weighted_inputs7_8_1));
  weighted_inputs_1 w7_9    (.inputs(inputs9_1), .w(w7_0_1[9]), .wi(weighted_inputs7_9_0));
  weighted_inputs_1 w7_9_bar(.inputs(inputs9_1), .w(w7_1_1[9]), .wi(weighted_inputs7_9_1));
  weighted_inputs_1 w7_10    (.inputs(inputs10_1), .w(w7_0_1[10]), .wi(weighted_inputs7_10_0));
  weighted_inputs_1 w7_10_bar(.inputs(inputs10_1), .w(w7_1_1[10]), .wi(weighted_inputs7_10_1));
  weighted_inputs_1 w7_11    (.inputs(inputs11_1), .w(w7_0_1[11]), .wi(weighted_inputs7_11_0));
  weighted_inputs_1 w7_11_bar(.inputs(inputs11_1), .w(w7_1_1[11]), .wi(weighted_inputs7_11_1));
  weighted_inputs_1 w7_12    (.inputs(inputs12_1), .w(w7_0_1[12]), .wi(weighted_inputs7_12_0));
  weighted_inputs_1 w7_12_bar(.inputs(inputs12_1), .w(w7_1_1[12]), .wi(weighted_inputs7_12_1));
  weighted_inputs_1 w7_13    (.inputs(inputs13_1), .w(w7_0_1[13]), .wi(weighted_inputs7_13_0));
  weighted_inputs_1 w7_13_bar(.inputs(inputs13_1), .w(w7_1_1[13]), .wi(weighted_inputs7_13_1));
  weighted_inputs_1 w7_14    (.inputs(inputs14_1), .w(w7_0_1[14]), .wi(weighted_inputs7_14_0));
  weighted_inputs_1 w7_14_bar(.inputs(inputs14_1), .w(w7_1_1[14]), .wi(weighted_inputs7_14_1));
  weighted_inputs_1 w7_15    (.inputs(inputs15_1), .w(w7_0_1[15]), .wi(weighted_inputs7_15_0));
  weighted_inputs_1 w7_15_bar(.inputs(inputs15_1), .w(w7_1_1[15]), .wi(weighted_inputs7_15_1));
  weighted_inputs_1 w8_0    (.inputs(inputs0_1), .w(w8_0_1[0]), .wi(weighted_inputs8_0_0));
  weighted_inputs_1 w8_0_bar(.inputs(inputs0_1), .w(w8_1_1[0]), .wi(weighted_inputs8_0_1));
  weighted_inputs_1 w8_1    (.inputs(inputs1_1), .w(w8_0_1[1]), .wi(weighted_inputs8_1_0));
  weighted_inputs_1 w8_1_bar(.inputs(inputs1_1), .w(w8_1_1[1]), .wi(weighted_inputs8_1_1));
  weighted_inputs_1 w8_2    (.inputs(inputs2_1), .w(w8_0_1[2]), .wi(weighted_inputs8_2_0));
  weighted_inputs_1 w8_2_bar(.inputs(inputs2_1), .w(w8_1_1[2]), .wi(weighted_inputs8_2_1));
  weighted_inputs_1 w8_3    (.inputs(inputs3_1), .w(w8_0_1[3]), .wi(weighted_inputs8_3_0));
  weighted_inputs_1 w8_3_bar(.inputs(inputs3_1), .w(w8_1_1[3]), .wi(weighted_inputs8_3_1));
  weighted_inputs_1 w8_4    (.inputs(inputs4_1), .w(w8_0_1[4]), .wi(weighted_inputs8_4_0));
  weighted_inputs_1 w8_4_bar(.inputs(inputs4_1), .w(w8_1_1[4]), .wi(weighted_inputs8_4_1));
  weighted_inputs_1 w8_5    (.inputs(inputs5_1), .w(w8_0_1[5]), .wi(weighted_inputs8_5_0));
  weighted_inputs_1 w8_5_bar(.inputs(inputs5_1), .w(w8_1_1[5]), .wi(weighted_inputs8_5_1));
  weighted_inputs_1 w8_6    (.inputs(inputs6_1), .w(w8_0_1[6]), .wi(weighted_inputs8_6_0));
  weighted_inputs_1 w8_6_bar(.inputs(inputs6_1), .w(w8_1_1[6]), .wi(weighted_inputs8_6_1));
  weighted_inputs_1 w8_7    (.inputs(inputs7_1), .w(w8_0_1[7]), .wi(weighted_inputs8_7_0));
  weighted_inputs_1 w8_7_bar(.inputs(inputs7_1), .w(w8_1_1[7]), .wi(weighted_inputs8_7_1));
  weighted_inputs_1 w8_8    (.inputs(inputs8_1), .w(w8_0_1[8]), .wi(weighted_inputs8_8_0));
  weighted_inputs_1 w8_8_bar(.inputs(inputs8_1), .w(w8_1_1[8]), .wi(weighted_inputs8_8_1));
  weighted_inputs_1 w8_9    (.inputs(inputs9_1), .w(w8_0_1[9]), .wi(weighted_inputs8_9_0));
  weighted_inputs_1 w8_9_bar(.inputs(inputs9_1), .w(w8_1_1[9]), .wi(weighted_inputs8_9_1));
  weighted_inputs_1 w8_10    (.inputs(inputs10_1), .w(w8_0_1[10]), .wi(weighted_inputs8_10_0));
  weighted_inputs_1 w8_10_bar(.inputs(inputs10_1), .w(w8_1_1[10]), .wi(weighted_inputs8_10_1));
  weighted_inputs_1 w8_11    (.inputs(inputs11_1), .w(w8_0_1[11]), .wi(weighted_inputs8_11_0));
  weighted_inputs_1 w8_11_bar(.inputs(inputs11_1), .w(w8_1_1[11]), .wi(weighted_inputs8_11_1));
  weighted_inputs_1 w8_12    (.inputs(inputs12_1), .w(w8_0_1[12]), .wi(weighted_inputs8_12_0));
  weighted_inputs_1 w8_12_bar(.inputs(inputs12_1), .w(w8_1_1[12]), .wi(weighted_inputs8_12_1));
  weighted_inputs_1 w8_13    (.inputs(inputs13_1), .w(w8_0_1[13]), .wi(weighted_inputs8_13_0));
  weighted_inputs_1 w8_13_bar(.inputs(inputs13_1), .w(w8_1_1[13]), .wi(weighted_inputs8_13_1));
  weighted_inputs_1 w8_14    (.inputs(inputs14_1), .w(w8_0_1[14]), .wi(weighted_inputs8_14_0));
  weighted_inputs_1 w8_14_bar(.inputs(inputs14_1), .w(w8_1_1[14]), .wi(weighted_inputs8_14_1));
  weighted_inputs_1 w8_15    (.inputs(inputs15_1), .w(w8_0_1[15]), .wi(weighted_inputs8_15_0));
  weighted_inputs_1 w8_15_bar(.inputs(inputs15_1), .w(w8_1_1[15]), .wi(weighted_inputs8_15_1));
 
  // adder trees for sum1 and sum1bar
  mux_2 m1 (.a(weighted_inputs1_0_0), .b(act0_0_0_1), .c(act0_0_0_2), .d(act0_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_0_0));
  mux_2 m2 (.a(weighted_inputs1_1_0), .b(act0_1_0_1), .c(act0_1_0_2), .d(act0_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_1_0));
  mux_2 m3 (.a(weighted_inputs1_2_0), .b(act0_2_0_1), .c(act0_2_0_2), .d(act0_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_2_0));
  mux_2 m4 (.a(weighted_inputs1_3_0), .b(act0_3_0_1), .c(act0_3_0_2), .d(act0_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_3_0));
  mux_2 m5 (.a(weighted_inputs1_4_0), .b(act0_4_0_1), .c(act0_4_0_2), .d(act0_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_4_0));
  mux_2 m6 (.a(weighted_inputs1_5_0), .b(act0_5_0_1), .c(act0_5_0_2), .d(act0_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_5_0));
  mux_2 m7 (.a(weighted_inputs1_6_0), .b(act0_6_0_1), .c(act0_6_0_2), .d(act0_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_6_0));
  mux_2 m8 (.a(weighted_inputs1_7_0), .b(act0_7_0_1), .c(act0_7_0_2), .d(act0_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_7_0));
  mux_2 m9 (.a(weighted_inputs1_8_0), .b(act0_8_0_1), .c(act0_8_0_2), .d(act0_8_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_8_0));
  mux_2 m10 (.a(weighted_inputs1_9_0), .b(act0_9_0_1), .c(act0_9_0_2), .d(act0_9_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_9_0));
  mux_2 m11 (.a(weighted_inputs1_10_0), .b(act0_10_0_1), .c(act0_10_0_2), .d(act0_10_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_10_0));
  mux_2 m12 (.a(weighted_inputs1_11_0), .b(act0_11_0_1), .c(act0_11_0_2), .d(act0_11_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_11_0));
  mux_2 m13 (.a(weighted_inputs1_12_0), .b(act0_12_0_1), .c(act0_12_0_2), .d(act0_12_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_12_0));
  mux_2 m14 (.a(weighted_inputs1_13_0), .b(act0_13_0_1), .c(act0_13_0_2), .d(act0_13_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_13_0));
  mux_2 m15 (.a(weighted_inputs1_14_0), .b(act0_14_0_1), .c(act0_14_0_2), .d(act0_14_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_14_0));
  mux_2 m16 (.a(weighted_inputs1_15_0), .b(act0_15_0_1), .c(act0_15_0_2), .d(act0_15_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_15_0));
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
    .in8(new_weighted_inputs1_8_0),
    .in9(new_weighted_inputs1_9_0),
    .in10(new_weighted_inputs1_10_0),
    .in11(new_weighted_inputs1_11_0),
    .in12(new_weighted_inputs1_12_0),
    .in13(new_weighted_inputs1_13_0),
    .in14(new_weighted_inputs1_14_0),
    .in15(new_weighted_inputs1_15_0),
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
    .in8(new_weighted_inputs1_8_0),
    .in9(new_weighted_inputs1_9_0),
    .in10(new_weighted_inputs1_10_0),
    .in11(new_weighted_inputs1_11_0),
    .in12(new_weighted_inputs1_12_0),
    .in13(new_weighted_inputs1_13_0),
    .in14(new_weighted_inputs1_14_0),
    .in15(new_weighted_inputs1_15_0),
    .sum(sum1bar[0])
  );

  mux_2 m17 (.a(weighted_inputs2_0_0), .b(act1_0_0_1), .c(act1_0_0_2), .d(act1_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_0_0));
  mux_2 m18 (.a(weighted_inputs2_1_0), .b(act1_1_0_1), .c(act1_1_0_2), .d(act1_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_1_0));
  mux_2 m19 (.a(weighted_inputs2_2_0), .b(act1_2_0_1), .c(act1_2_0_2), .d(act1_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_2_0));
  mux_2 m20 (.a(weighted_inputs2_3_0), .b(act1_3_0_1), .c(act1_3_0_2), .d(act1_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_3_0));
  mux_2 m21 (.a(weighted_inputs2_4_0), .b(act1_4_0_1), .c(act1_4_0_2), .d(act1_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_4_0));
  mux_2 m22 (.a(weighted_inputs2_5_0), .b(act1_5_0_1), .c(act1_5_0_2), .d(act1_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_5_0));
  mux_2 m23 (.a(weighted_inputs2_6_0), .b(act1_6_0_1), .c(act1_6_0_2), .d(act1_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_6_0));
  mux_2 m24 (.a(weighted_inputs2_7_0), .b(act1_7_0_1), .c(act1_7_0_2), .d(act1_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_7_0));
  mux_2 m25 (.a(weighted_inputs2_8_0), .b(act1_8_0_1), .c(act1_8_0_2), .d(act1_8_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_8_0));
  mux_2 m26 (.a(weighted_inputs2_9_0), .b(act1_9_0_1), .c(act1_9_0_2), .d(act1_9_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_9_0));
  mux_2 m27 (.a(weighted_inputs2_10_0), .b(act1_10_0_1), .c(act1_10_0_2), .d(act1_10_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_10_0));
  mux_2 m28 (.a(weighted_inputs2_11_0), .b(act1_11_0_1), .c(act1_11_0_2), .d(act1_11_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_11_0));
  mux_2 m29 (.a(weighted_inputs2_12_0), .b(act1_12_0_1), .c(act1_12_0_2), .d(act1_12_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_12_0));
  mux_2 m30 (.a(weighted_inputs2_13_0), .b(act1_13_0_1), .c(act1_13_0_2), .d(act1_13_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_13_0));
  mux_2 m31 (.a(weighted_inputs2_14_0), .b(act1_14_0_1), .c(act1_14_0_2), .d(act1_14_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_14_0));
  mux_2 m32 (.a(weighted_inputs2_15_0), .b(act1_15_0_1), .c(act1_15_0_2), .d(act1_15_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_15_0));
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
    .in8(new_weighted_inputs2_8_0),
    .in9(new_weighted_inputs2_9_0),
    .in10(new_weighted_inputs2_10_0),
    .in11(new_weighted_inputs2_11_0),
    .in12(new_weighted_inputs2_12_0),
    .in13(new_weighted_inputs2_13_0),
    .in14(new_weighted_inputs2_14_0),
    .in15(new_weighted_inputs2_15_0),
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
    .in8(new_weighted_inputs2_8_0),
    .in9(new_weighted_inputs2_9_0),
    .in10(new_weighted_inputs2_10_0),
    .in11(new_weighted_inputs2_11_0),
    .in12(new_weighted_inputs2_12_0),
    .in13(new_weighted_inputs2_13_0),
    .in14(new_weighted_inputs2_14_0),
    .in15(new_weighted_inputs2_15_0),
    .sum(sum1bar[1])
  );

  mux_2 m33 (.a(weighted_inputs3_0_0), .b(act2_0_0_1), .c(act2_0_0_2), .d(act2_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_0_0));
  mux_2 m34 (.a(weighted_inputs3_1_0), .b(act2_1_0_1), .c(act2_1_0_2), .d(act2_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_1_0));
  mux_2 m35 (.a(weighted_inputs3_2_0), .b(act2_2_0_1), .c(act2_2_0_2), .d(act2_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_2_0));
  mux_2 m36 (.a(weighted_inputs3_3_0), .b(act2_3_0_1), .c(act2_3_0_2), .d(act2_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_3_0));
  mux_2 m37 (.a(weighted_inputs3_4_0), .b(act2_4_0_1), .c(act2_4_0_2), .d(act2_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_4_0));
  mux_2 m38 (.a(weighted_inputs3_5_0), .b(act2_5_0_1), .c(act2_5_0_2), .d(act2_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_5_0));
  mux_2 m39 (.a(weighted_inputs3_6_0), .b(act2_6_0_1), .c(act2_6_0_2), .d(act2_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_6_0));
  mux_2 m40 (.a(weighted_inputs3_7_0), .b(act2_7_0_1), .c(act2_7_0_2), .d(act2_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_7_0));
  mux_2 m41 (.a(weighted_inputs3_8_0), .b(act2_8_0_1), .c(act2_8_0_2), .d(act2_8_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_8_0));
  mux_2 m42 (.a(weighted_inputs3_9_0), .b(act2_9_0_1), .c(act2_9_0_2), .d(act2_9_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_9_0));
  mux_2 m43 (.a(weighted_inputs3_10_0), .b(act2_10_0_1), .c(act2_10_0_2), .d(act2_10_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_10_0));
  mux_2 m44 (.a(weighted_inputs3_11_0), .b(act2_11_0_1), .c(act2_11_0_2), .d(act2_11_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_11_0));
  mux_2 m45 (.a(weighted_inputs3_12_0), .b(act2_12_0_1), .c(act2_12_0_2), .d(act2_12_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_12_0));
  mux_2 m46 (.a(weighted_inputs3_13_0), .b(act2_13_0_1), .c(act2_13_0_2), .d(act2_13_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_13_0));
  mux_2 m47 (.a(weighted_inputs3_14_0), .b(act2_14_0_1), .c(act2_14_0_2), .d(act2_14_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_14_0));
  mux_2 m48 (.a(weighted_inputs3_15_0), .b(act2_15_0_1), .c(act2_15_0_2), .d(act2_15_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_15_0));
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
    .in8(new_weighted_inputs3_8_0),
    .in9(new_weighted_inputs3_9_0),
    .in10(new_weighted_inputs3_10_0),
    .in11(new_weighted_inputs3_11_0),
    .in12(new_weighted_inputs3_12_0),
    .in13(new_weighted_inputs3_13_0),
    .in14(new_weighted_inputs3_14_0),
    .in15(new_weighted_inputs3_15_0),
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
    .in8(new_weighted_inputs3_8_0),
    .in9(new_weighted_inputs3_9_0),
    .in10(new_weighted_inputs3_10_0),
    .in11(new_weighted_inputs3_11_0),
    .in12(new_weighted_inputs3_12_0),
    .in13(new_weighted_inputs3_13_0),
    .in14(new_weighted_inputs3_14_0),
    .in15(new_weighted_inputs3_15_0),
    .sum(sum1bar[2])
  );

  mux_2 m49 (.a(weighted_inputs4_0_0), .b(act3_0_0_1), .c(act3_0_0_2), .d(act3_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_0_0));
  mux_2 m50 (.a(weighted_inputs4_1_0), .b(act3_1_0_1), .c(act3_1_0_2), .d(act3_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_1_0));
  mux_2 m51 (.a(weighted_inputs4_2_0), .b(act3_2_0_1), .c(act3_2_0_2), .d(act3_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_2_0));
  mux_2 m52 (.a(weighted_inputs4_3_0), .b(act3_3_0_1), .c(act3_3_0_2), .d(act3_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_3_0));
  mux_2 m53 (.a(weighted_inputs4_4_0), .b(act3_4_0_1), .c(act3_4_0_2), .d(act3_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_4_0));
  mux_2 m54 (.a(weighted_inputs4_5_0), .b(act3_5_0_1), .c(act3_5_0_2), .d(act3_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_5_0));
  mux_2 m55 (.a(weighted_inputs4_6_0), .b(act3_6_0_1), .c(act3_6_0_2), .d(act3_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_6_0));
  mux_2 m56 (.a(weighted_inputs4_7_0), .b(act3_7_0_1), .c(act3_7_0_2), .d(act3_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_7_0));
  mux_2 m57 (.a(weighted_inputs4_8_0), .b(act3_8_0_1), .c(act3_8_0_2), .d(act3_8_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_8_0));
  mux_2 m58 (.a(weighted_inputs4_9_0), .b(act3_9_0_1), .c(act3_9_0_2), .d(act3_9_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_9_0));
  mux_2 m59 (.a(weighted_inputs4_10_0), .b(act3_10_0_1), .c(act3_10_0_2), .d(act3_10_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_10_0));
  mux_2 m60 (.a(weighted_inputs4_11_0), .b(act3_11_0_1), .c(act3_11_0_2), .d(act3_11_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_11_0));
  mux_2 m61 (.a(weighted_inputs4_12_0), .b(act3_12_0_1), .c(act3_12_0_2), .d(act3_12_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_12_0));
  mux_2 m62 (.a(weighted_inputs4_13_0), .b(act3_13_0_1), .c(act3_13_0_2), .d(act3_13_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_13_0));
  mux_2 m63 (.a(weighted_inputs4_14_0), .b(act3_14_0_1), .c(act3_14_0_2), .d(act3_14_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_14_0));
  mux_2 m64 (.a(weighted_inputs4_15_0), .b(act3_15_0_1), .c(act3_15_0_2), .d(act3_15_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_15_0));
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
    .in8(new_weighted_inputs4_8_0),
    .in9(new_weighted_inputs4_9_0),
    .in10(new_weighted_inputs4_10_0),
    .in11(new_weighted_inputs4_11_0),
    .in12(new_weighted_inputs4_12_0),
    .in13(new_weighted_inputs4_13_0),
    .in14(new_weighted_inputs4_14_0),
    .in15(new_weighted_inputs4_15_0),
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
    .in8(new_weighted_inputs4_8_0),
    .in9(new_weighted_inputs4_9_0),
    .in10(new_weighted_inputs4_10_0),
    .in11(new_weighted_inputs4_11_0),
    .in12(new_weighted_inputs4_12_0),
    .in13(new_weighted_inputs4_13_0),
    .in14(new_weighted_inputs4_14_0),
    .in15(new_weighted_inputs4_15_0),
    .sum(sum1bar[3])
  );

  mux_2 m65 (.a(weighted_inputs5_0_0), .b(act4_0_0_1), .c(act4_0_0_2), .d(act4_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_0_0));
  mux_2 m66 (.a(weighted_inputs5_1_0), .b(act4_1_0_1), .c(act4_1_0_2), .d(act4_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_1_0));
  mux_2 m67 (.a(weighted_inputs5_2_0), .b(act4_2_0_1), .c(act4_2_0_2), .d(act4_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_2_0));
  mux_2 m68 (.a(weighted_inputs5_3_0), .b(act4_3_0_1), .c(act4_3_0_2), .d(act4_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_3_0));
  mux_2 m69 (.a(weighted_inputs5_4_0), .b(act4_4_0_1), .c(act4_4_0_2), .d(act4_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_4_0));
  mux_2 m70 (.a(weighted_inputs5_5_0), .b(act4_5_0_1), .c(act4_5_0_2), .d(act4_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_5_0));
  mux_2 m71 (.a(weighted_inputs5_6_0), .b(act4_6_0_1), .c(act4_6_0_2), .d(act4_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_6_0));
  mux_2 m72 (.a(weighted_inputs5_7_0), .b(act4_7_0_1), .c(act4_7_0_2), .d(act4_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_7_0));
  mux_2 m73 (.a(weighted_inputs5_8_0), .b(act4_8_0_1), .c(act4_8_0_2), .d(act4_8_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_8_0));
  mux_2 m74 (.a(weighted_inputs5_9_0), .b(act4_9_0_1), .c(act4_9_0_2), .d(act4_9_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_9_0));
  mux_2 m75 (.a(weighted_inputs5_10_0), .b(act4_10_0_1), .c(act4_10_0_2), .d(act4_10_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_10_0));
  mux_2 m76 (.a(weighted_inputs5_11_0), .b(act4_11_0_1), .c(act4_11_0_2), .d(act4_11_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_11_0));
  mux_2 m77 (.a(weighted_inputs5_12_0), .b(act4_12_0_1), .c(act4_12_0_2), .d(act4_12_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_12_0));
  mux_2 m78 (.a(weighted_inputs5_13_0), .b(act4_13_0_1), .c(act4_13_0_2), .d(act4_13_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_13_0));
  mux_2 m79 (.a(weighted_inputs5_14_0), .b(act4_14_0_1), .c(act4_14_0_2), .d(act4_14_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_14_0));
  mux_2 m80 (.a(weighted_inputs5_15_0), .b(act4_15_0_1), .c(act4_15_0_2), .d(act4_15_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_15_0));
  adder_tree add4 (
    .clk(clk),
    .in0(new_weighted_inputs5_0_0),
    .in1(new_weighted_inputs5_1_0),
    .in2(new_weighted_inputs5_2_0),
    .in3(new_weighted_inputs5_3_0),
    .in4(new_weighted_inputs5_4_0),
    .in5(new_weighted_inputs5_5_0),
    .in6(new_weighted_inputs5_6_0),
    .in7(new_weighted_inputs5_7_0),
    .in8(new_weighted_inputs5_8_0),
    .in9(new_weighted_inputs5_9_0),
    .in10(new_weighted_inputs5_10_0),
    .in11(new_weighted_inputs5_11_0),
    .in12(new_weighted_inputs5_12_0),
    .in13(new_weighted_inputs5_13_0),
    .in14(new_weighted_inputs5_14_0),
    .in15(new_weighted_inputs5_15_0),
    .sum(sum1[4])
  );
  adder_tree_bar addb4 (
    .clk(clk),
    .in0(new_weighted_inputs5_0_0),
    .in1(new_weighted_inputs5_1_0),
    .in2(new_weighted_inputs5_2_0),
    .in3(new_weighted_inputs5_3_0),
    .in4(new_weighted_inputs5_4_0),
    .in5(new_weighted_inputs5_5_0),
    .in6(new_weighted_inputs5_6_0),
    .in7(new_weighted_inputs5_7_0),
    .in8(new_weighted_inputs5_8_0),
    .in9(new_weighted_inputs5_9_0),
    .in10(new_weighted_inputs5_10_0),
    .in11(new_weighted_inputs5_11_0),
    .in12(new_weighted_inputs5_12_0),
    .in13(new_weighted_inputs5_13_0),
    .in14(new_weighted_inputs5_14_0),
    .in15(new_weighted_inputs5_15_0),
    .sum(sum1bar[4])
  );

  mux_2 m81 (.a(weighted_inputs6_0_0), .b(act5_0_0_1), .c(act5_0_0_2), .d(act5_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_0_0));
  mux_2 m82 (.a(weighted_inputs6_1_0), .b(act5_1_0_1), .c(act5_1_0_2), .d(act5_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_1_0));
  mux_2 m83 (.a(weighted_inputs6_2_0), .b(act5_2_0_1), .c(act5_2_0_2), .d(act5_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_2_0));
  mux_2 m84 (.a(weighted_inputs6_3_0), .b(act5_3_0_1), .c(act5_3_0_2), .d(act5_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_3_0));
  mux_2 m85 (.a(weighted_inputs6_4_0), .b(act5_4_0_1), .c(act5_4_0_2), .d(act5_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_4_0));
  mux_2 m86 (.a(weighted_inputs6_5_0), .b(act5_5_0_1), .c(act5_5_0_2), .d(act5_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_5_0));
  mux_2 m87 (.a(weighted_inputs6_6_0), .b(act5_6_0_1), .c(act5_6_0_2), .d(act5_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_6_0));
  mux_2 m88 (.a(weighted_inputs6_7_0), .b(act5_7_0_1), .c(act5_7_0_2), .d(act5_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_7_0));
  mux_2 m89 (.a(weighted_inputs6_8_0), .b(act5_8_0_1), .c(act5_8_0_2), .d(act5_8_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_8_0));
  mux_2 m90 (.a(weighted_inputs6_9_0), .b(act5_9_0_1), .c(act5_9_0_2), .d(act5_9_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_9_0));
  mux_2 m91 (.a(weighted_inputs6_10_0), .b(act5_10_0_1), .c(act5_10_0_2), .d(act5_10_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_10_0));
  mux_2 m92 (.a(weighted_inputs6_11_0), .b(act5_11_0_1), .c(act5_11_0_2), .d(act5_11_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_11_0));
  mux_2 m93 (.a(weighted_inputs6_12_0), .b(act5_12_0_1), .c(act5_12_0_2), .d(act5_12_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_12_0));
  mux_2 m94 (.a(weighted_inputs6_13_0), .b(act5_13_0_1), .c(act5_13_0_2), .d(act5_13_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_13_0));
  mux_2 m95 (.a(weighted_inputs6_14_0), .b(act5_14_0_1), .c(act5_14_0_2), .d(act5_14_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_14_0));
  mux_2 m96 (.a(weighted_inputs6_15_0), .b(act5_15_0_1), .c(act5_15_0_2), .d(act5_15_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_15_0));
  adder_tree add5 (
    .clk(clk),
    .in0(new_weighted_inputs6_0_0),
    .in1(new_weighted_inputs6_1_0),
    .in2(new_weighted_inputs6_2_0),
    .in3(new_weighted_inputs6_3_0),
    .in4(new_weighted_inputs6_4_0),
    .in5(new_weighted_inputs6_5_0),
    .in6(new_weighted_inputs6_6_0),
    .in7(new_weighted_inputs6_7_0),
    .in8(new_weighted_inputs6_8_0),
    .in9(new_weighted_inputs6_9_0),
    .in10(new_weighted_inputs6_10_0),
    .in11(new_weighted_inputs6_11_0),
    .in12(new_weighted_inputs6_12_0),
    .in13(new_weighted_inputs6_13_0),
    .in14(new_weighted_inputs6_14_0),
    .in15(new_weighted_inputs6_15_0),
    .sum(sum1[5])
  );
  adder_tree_bar addb5 (
    .clk(clk),
    .in0(new_weighted_inputs6_0_0),
    .in1(new_weighted_inputs6_1_0),
    .in2(new_weighted_inputs6_2_0),
    .in3(new_weighted_inputs6_3_0),
    .in4(new_weighted_inputs6_4_0),
    .in5(new_weighted_inputs6_5_0),
    .in6(new_weighted_inputs6_6_0),
    .in7(new_weighted_inputs6_7_0),
    .in8(new_weighted_inputs6_8_0),
    .in9(new_weighted_inputs6_9_0),
    .in10(new_weighted_inputs6_10_0),
    .in11(new_weighted_inputs6_11_0),
    .in12(new_weighted_inputs6_12_0),
    .in13(new_weighted_inputs6_13_0),
    .in14(new_weighted_inputs6_14_0),
    .in15(new_weighted_inputs6_15_0),
    .sum(sum1bar[5])
  );

  mux_2 m97 (.a(weighted_inputs7_0_0), .b(act6_0_0_1), .c(act6_0_0_2), .d(act6_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_0_0));
  mux_2 m98 (.a(weighted_inputs7_1_0), .b(act6_1_0_1), .c(act6_1_0_2), .d(act6_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_1_0));
  mux_2 m99 (.a(weighted_inputs7_2_0), .b(act6_2_0_1), .c(act6_2_0_2), .d(act6_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_2_0));
  mux_2 m100 (.a(weighted_inputs7_3_0), .b(act6_3_0_1), .c(act6_3_0_2), .d(act6_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_3_0));
  mux_2 m101 (.a(weighted_inputs7_4_0), .b(act6_4_0_1), .c(act6_4_0_2), .d(act6_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_4_0));
  mux_2 m102 (.a(weighted_inputs7_5_0), .b(act6_5_0_1), .c(act6_5_0_2), .d(act6_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_5_0));
  mux_2 m103 (.a(weighted_inputs7_6_0), .b(act6_6_0_1), .c(act6_6_0_2), .d(act6_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_6_0));
  mux_2 m104 (.a(weighted_inputs7_7_0), .b(act6_7_0_1), .c(act6_7_0_2), .d(act6_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_7_0));
  mux_2 m105 (.a(weighted_inputs7_8_0), .b(act6_8_0_1), .c(act6_8_0_2), .d(act6_8_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_8_0));
  mux_2 m106 (.a(weighted_inputs7_9_0), .b(act6_9_0_1), .c(act6_9_0_2), .d(act6_9_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_9_0));
  mux_2 m107 (.a(weighted_inputs7_10_0), .b(act6_10_0_1), .c(act6_10_0_2), .d(act6_10_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_10_0));
  mux_2 m108 (.a(weighted_inputs7_11_0), .b(act6_11_0_1), .c(act6_11_0_2), .d(act6_11_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_11_0));
  mux_2 m109 (.a(weighted_inputs7_12_0), .b(act6_12_0_1), .c(act6_12_0_2), .d(act6_12_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_12_0));
  mux_2 m110 (.a(weighted_inputs7_13_0), .b(act6_13_0_1), .c(act6_13_0_2), .d(act6_13_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_13_0));
  mux_2 m111 (.a(weighted_inputs7_14_0), .b(act6_14_0_1), .c(act6_14_0_2), .d(act6_14_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_14_0));
  mux_2 m112 (.a(weighted_inputs7_15_0), .b(act6_15_0_1), .c(act6_15_0_2), .d(act6_15_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_15_0));
  adder_tree add6 (
    .clk(clk),
    .in0(new_weighted_inputs7_0_0),
    .in1(new_weighted_inputs7_1_0),
    .in2(new_weighted_inputs7_2_0),
    .in3(new_weighted_inputs7_3_0),
    .in4(new_weighted_inputs7_4_0),
    .in5(new_weighted_inputs7_5_0),
    .in6(new_weighted_inputs7_6_0),
    .in7(new_weighted_inputs7_7_0),
    .in8(new_weighted_inputs7_8_0),
    .in9(new_weighted_inputs7_9_0),
    .in10(new_weighted_inputs7_10_0),
    .in11(new_weighted_inputs7_11_0),
    .in12(new_weighted_inputs7_12_0),
    .in13(new_weighted_inputs7_13_0),
    .in14(new_weighted_inputs7_14_0),
    .in15(new_weighted_inputs7_15_0),
    .sum(sum1[6])
  );
  adder_tree_bar addb6 (
    .clk(clk),
    .in0(new_weighted_inputs7_0_0),
    .in1(new_weighted_inputs7_1_0),
    .in2(new_weighted_inputs7_2_0),
    .in3(new_weighted_inputs7_3_0),
    .in4(new_weighted_inputs7_4_0),
    .in5(new_weighted_inputs7_5_0),
    .in6(new_weighted_inputs7_6_0),
    .in7(new_weighted_inputs7_7_0),
    .in8(new_weighted_inputs7_8_0),
    .in9(new_weighted_inputs7_9_0),
    .in10(new_weighted_inputs7_10_0),
    .in11(new_weighted_inputs7_11_0),
    .in12(new_weighted_inputs7_12_0),
    .in13(new_weighted_inputs7_13_0),
    .in14(new_weighted_inputs7_14_0),
    .in15(new_weighted_inputs7_15_0),
    .sum(sum1bar[6])
  );

  mux_2 m113 (.a(weighted_inputs8_0_0), .b(act7_0_0_1), .c(act7_0_0_2), .d(act7_0_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_0_0));
  mux_2 m114 (.a(weighted_inputs8_1_0), .b(act7_1_0_1), .c(act7_1_0_2), .d(act7_1_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_1_0));
  mux_2 m115 (.a(weighted_inputs8_2_0), .b(act7_2_0_1), .c(act7_2_0_2), .d(act7_2_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_2_0));
  mux_2 m116 (.a(weighted_inputs8_3_0), .b(act7_3_0_1), .c(act7_3_0_2), .d(act7_3_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_3_0));
  mux_2 m117 (.a(weighted_inputs8_4_0), .b(act7_4_0_1), .c(act7_4_0_2), .d(act7_4_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_4_0));
  mux_2 m118 (.a(weighted_inputs8_5_0), .b(act7_5_0_1), .c(act7_5_0_2), .d(act7_5_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_5_0));
  mux_2 m119 (.a(weighted_inputs8_6_0), .b(act7_6_0_1), .c(act7_6_0_2), .d(act7_6_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_6_0));
  mux_2 m120 (.a(weighted_inputs8_7_0), .b(act7_7_0_1), .c(act7_7_0_2), .d(act7_7_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_7_0));
  mux_2 m121 (.a(weighted_inputs8_8_0), .b(act7_8_0_1), .c(act7_8_0_2), .d(act7_8_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_8_0));
  mux_2 m122 (.a(weighted_inputs8_9_0), .b(act7_9_0_1), .c(act7_9_0_2), .d(act7_9_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_9_0));
  mux_2 m123 (.a(weighted_inputs8_10_0), .b(act7_10_0_1), .c(act7_10_0_2), .d(act7_10_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_10_0));
  mux_2 m124 (.a(weighted_inputs8_11_0), .b(act7_11_0_1), .c(act7_11_0_2), .d(act7_11_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_11_0));
  mux_2 m125 (.a(weighted_inputs8_12_0), .b(act7_12_0_1), .c(act7_12_0_2), .d(act7_12_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_12_0));
  mux_2 m126 (.a(weighted_inputs8_13_0), .b(act7_13_0_1), .c(act7_13_0_2), .d(act7_13_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_13_0));
  mux_2 m127 (.a(weighted_inputs8_14_0), .b(act7_14_0_1), .c(act7_14_0_2), .d(act7_14_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_14_0));
  mux_2 m128 (.a(weighted_inputs8_15_0), .b(act7_15_0_1), .c(act7_15_0_2), .d(act7_15_0_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_15_0));
  adder_tree add7 (
    .clk(clk),
    .in0(new_weighted_inputs8_0_0),
    .in1(new_weighted_inputs8_1_0),
    .in2(new_weighted_inputs8_2_0),
    .in3(new_weighted_inputs8_3_0),
    .in4(new_weighted_inputs8_4_0),
    .in5(new_weighted_inputs8_5_0),
    .in6(new_weighted_inputs8_6_0),
    .in7(new_weighted_inputs8_7_0),
    .in8(new_weighted_inputs8_8_0),
    .in9(new_weighted_inputs8_9_0),
    .in10(new_weighted_inputs8_10_0),
    .in11(new_weighted_inputs8_11_0),
    .in12(new_weighted_inputs8_12_0),
    .in13(new_weighted_inputs8_13_0),
    .in14(new_weighted_inputs8_14_0),
    .in15(new_weighted_inputs8_15_0),
    .sum(sum1[7])
  );
  adder_tree_bar addb7 (
    .clk(clk),
    .in0(new_weighted_inputs8_0_0),
    .in1(new_weighted_inputs8_1_0),
    .in2(new_weighted_inputs8_2_0),
    .in3(new_weighted_inputs8_3_0),
    .in4(new_weighted_inputs8_4_0),
    .in5(new_weighted_inputs8_5_0),
    .in6(new_weighted_inputs8_6_0),
    .in7(new_weighted_inputs8_7_0),
    .in8(new_weighted_inputs8_8_0),
    .in9(new_weighted_inputs8_9_0),
    .in10(new_weighted_inputs8_10_0),
    .in11(new_weighted_inputs8_11_0),
    .in12(new_weighted_inputs8_12_0),
    .in13(new_weighted_inputs8_13_0),
    .in14(new_weighted_inputs8_14_0),
    .in15(new_weighted_inputs8_15_0),
    .sum(sum1bar[7])
  );

  // adder trees for sum2 and sum2bar
  mux_2 m129 (.a(weighted_inputs1_0_1), .b(act0_0_1_1), .c(act0_0_1_2), .d(act0_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_0_1));
  mux_2 m130 (.a(weighted_inputs1_1_1), .b(act0_1_1_1), .c(act0_1_1_2), .d(act0_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_1_1));
  mux_2 m131 (.a(weighted_inputs1_2_1), .b(act0_2_1_1), .c(act0_2_1_2), .d(act0_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_2_1));
  mux_2 m132 (.a(weighted_inputs1_3_1), .b(act0_3_1_1), .c(act0_3_1_2), .d(act0_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_3_1));
  mux_2 m133 (.a(weighted_inputs1_4_1), .b(act0_4_1_1), .c(act0_4_1_2), .d(act0_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_4_1));
  mux_2 m134 (.a(weighted_inputs1_5_1), .b(act0_5_1_1), .c(act0_5_1_2), .d(act0_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_5_1));
  mux_2 m135 (.a(weighted_inputs1_6_1), .b(act0_6_1_1), .c(act0_6_1_2), .d(act0_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_6_1));
  mux_2 m136 (.a(weighted_inputs1_7_1), .b(act0_7_1_1), .c(act0_7_1_2), .d(act0_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_7_1));
  mux_2 m137 (.a(weighted_inputs1_8_1), .b(act0_8_1_1), .c(act0_8_1_2), .d(act0_8_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_8_1));
  mux_2 m138 (.a(weighted_inputs1_9_1), .b(act0_9_1_1), .c(act0_9_1_2), .d(act0_9_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_9_1));
  mux_2 m139 (.a(weighted_inputs1_10_1), .b(act0_10_1_1), .c(act0_10_1_2), .d(act0_10_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_10_1));
  mux_2 m140 (.a(weighted_inputs1_11_1), .b(act0_11_1_1), .c(act0_11_1_2), .d(act0_11_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_11_1));
  mux_2 m141 (.a(weighted_inputs1_12_1), .b(act0_12_1_1), .c(act0_12_1_2), .d(act0_12_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_12_1));
  mux_2 m142 (.a(weighted_inputs1_13_1), .b(act0_13_1_1), .c(act0_13_1_2), .d(act0_13_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_13_1));
  mux_2 m143 (.a(weighted_inputs1_14_1), .b(act0_14_1_1), .c(act0_14_1_2), .d(act0_14_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_14_1));
  mux_2 m144 (.a(weighted_inputs1_15_1), .b(act0_15_1_1), .c(act0_15_1_2), .d(act0_15_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs1_15_1));
  adder_tree add8 (
    .clk(clk),
    .in0(new_weighted_inputs1_0_1),
    .in1(new_weighted_inputs1_1_1),
    .in2(new_weighted_inputs1_2_1),
    .in3(new_weighted_inputs1_3_1),
    .in4(new_weighted_inputs1_4_1),
    .in5(new_weighted_inputs1_5_1),
    .in6(new_weighted_inputs1_6_1),
    .in7(new_weighted_inputs1_7_1),
    .in8(new_weighted_inputs1_8_1),
    .in9(new_weighted_inputs1_9_1),
    .in10(new_weighted_inputs1_10_1),
    .in11(new_weighted_inputs1_11_1),
    .in12(new_weighted_inputs1_12_1),
    .in13(new_weighted_inputs1_13_1),
    .in14(new_weighted_inputs1_14_1),
    .in15(new_weighted_inputs1_15_1),
    .sum(sum2[0])
  );
  adder_tree_bar addb8 (
    .clk(clk),
    .in0(new_weighted_inputs1_0_1),
    .in1(new_weighted_inputs1_1_1),
    .in2(new_weighted_inputs1_2_1),
    .in3(new_weighted_inputs1_3_1),
    .in4(new_weighted_inputs1_4_1),
    .in5(new_weighted_inputs1_5_1),
    .in6(new_weighted_inputs1_6_1),
    .in7(new_weighted_inputs1_7_1),
    .in8(new_weighted_inputs1_8_1),
    .in9(new_weighted_inputs1_9_1),
    .in10(new_weighted_inputs1_10_1),
    .in11(new_weighted_inputs1_11_1),
    .in12(new_weighted_inputs1_12_1),
    .in13(new_weighted_inputs1_13_1),
    .in14(new_weighted_inputs1_14_1),
    .in15(new_weighted_inputs1_15_1),
    .sum(sum2bar[0])
  );

  mux_2 m145 (.a(weighted_inputs2_0_1), .b(act1_0_1_1), .c(act1_0_1_2), .d(act1_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_0_1));
  mux_2 m146 (.a(weighted_inputs2_1_1), .b(act1_1_1_1), .c(act1_1_1_2), .d(act1_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_1_1));
  mux_2 m147 (.a(weighted_inputs2_2_1), .b(act1_2_1_1), .c(act1_2_1_2), .d(act1_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_2_1));
  mux_2 m148 (.a(weighted_inputs2_3_1), .b(act1_3_1_1), .c(act1_3_1_2), .d(act1_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_3_1));
  mux_2 m149 (.a(weighted_inputs2_4_1), .b(act1_4_1_1), .c(act1_4_1_2), .d(act1_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_4_1));
  mux_2 m150 (.a(weighted_inputs2_5_1), .b(act1_5_1_1), .c(act1_5_1_2), .d(act1_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_5_1));
  mux_2 m151 (.a(weighted_inputs2_6_1), .b(act1_6_1_1), .c(act1_6_1_2), .d(act1_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_6_1));
  mux_2 m152 (.a(weighted_inputs2_7_1), .b(act1_7_1_1), .c(act1_7_1_2), .d(act1_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_7_1));
  mux_2 m153 (.a(weighted_inputs2_8_1), .b(act1_8_1_1), .c(act1_8_1_2), .d(act1_8_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_8_1));
  mux_2 m154 (.a(weighted_inputs2_9_1), .b(act1_9_1_1), .c(act1_9_1_2), .d(act1_9_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_9_1));
  mux_2 m155 (.a(weighted_inputs2_10_1), .b(act1_10_1_1), .c(act1_10_1_2), .d(act1_10_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_10_1));
  mux_2 m156 (.a(weighted_inputs2_11_1), .b(act1_11_1_1), .c(act1_11_1_2), .d(act1_11_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_11_1));
  mux_2 m157 (.a(weighted_inputs2_12_1), .b(act1_12_1_1), .c(act1_12_1_2), .d(act1_12_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_12_1));
  mux_2 m158 (.a(weighted_inputs2_13_1), .b(act1_13_1_1), .c(act1_13_1_2), .d(act1_13_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_13_1));
  mux_2 m159 (.a(weighted_inputs2_14_1), .b(act1_14_1_1), .c(act1_14_1_2), .d(act1_14_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_14_1));
  mux_2 m160 (.a(weighted_inputs2_15_1), .b(act1_15_1_1), .c(act1_15_1_2), .d(act1_15_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs2_15_1));
  adder_tree add9 (
    .clk(clk),
    .in0(new_weighted_inputs2_0_1),
    .in1(new_weighted_inputs2_1_1),
    .in2(new_weighted_inputs2_2_1),
    .in3(new_weighted_inputs2_3_1),
    .in4(new_weighted_inputs2_4_1),
    .in5(new_weighted_inputs2_5_1),
    .in6(new_weighted_inputs2_6_1),
    .in7(new_weighted_inputs2_7_1),
    .in8(new_weighted_inputs2_8_1),
    .in9(new_weighted_inputs2_9_1),
    .in10(new_weighted_inputs2_10_1),
    .in11(new_weighted_inputs2_11_1),
    .in12(new_weighted_inputs2_12_1),
    .in13(new_weighted_inputs2_13_1),
    .in14(new_weighted_inputs2_14_1),
    .in15(new_weighted_inputs2_15_1),
    .sum(sum2[1])
  );
  adder_tree_bar addb9 (
    .clk(clk),
    .in0(new_weighted_inputs2_0_1),
    .in1(new_weighted_inputs2_1_1),
    .in2(new_weighted_inputs2_2_1),
    .in3(new_weighted_inputs2_3_1),
    .in4(new_weighted_inputs2_4_1),
    .in5(new_weighted_inputs2_5_1),
    .in6(new_weighted_inputs2_6_1),
    .in7(new_weighted_inputs2_7_1),
    .in8(new_weighted_inputs2_8_1),
    .in9(new_weighted_inputs2_9_1),
    .in10(new_weighted_inputs2_10_1),
    .in11(new_weighted_inputs2_11_1),
    .in12(new_weighted_inputs2_12_1),
    .in13(new_weighted_inputs2_13_1),
    .in14(new_weighted_inputs2_14_1),
    .in15(new_weighted_inputs2_15_1),
    .sum(sum2bar[1])
  );

  mux_2 m161 (.a(weighted_inputs3_0_1), .b(act2_0_1_1), .c(act2_0_1_2), .d(act2_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_0_1));
  mux_2 m162 (.a(weighted_inputs3_1_1), .b(act2_1_1_1), .c(act2_1_1_2), .d(act2_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_1_1));
  mux_2 m163 (.a(weighted_inputs3_2_1), .b(act2_2_1_1), .c(act2_2_1_2), .d(act2_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_2_1));
  mux_2 m164 (.a(weighted_inputs3_3_1), .b(act2_3_1_1), .c(act2_3_1_2), .d(act2_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_3_1));
  mux_2 m165 (.a(weighted_inputs3_4_1), .b(act2_4_1_1), .c(act2_4_1_2), .d(act2_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_4_1));
  mux_2 m166 (.a(weighted_inputs3_5_1), .b(act2_5_1_1), .c(act2_5_1_2), .d(act2_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_5_1));
  mux_2 m167 (.a(weighted_inputs3_6_1), .b(act2_6_1_1), .c(act2_6_1_2), .d(act2_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_6_1));
  mux_2 m168 (.a(weighted_inputs3_7_1), .b(act2_7_1_1), .c(act2_7_1_2), .d(act2_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_7_1));
  mux_2 m169 (.a(weighted_inputs3_8_1), .b(act2_8_1_1), .c(act2_8_1_2), .d(act2_8_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_8_1));
  mux_2 m170 (.a(weighted_inputs3_9_1), .b(act2_9_1_1), .c(act2_9_1_2), .d(act2_9_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_9_1));
  mux_2 m171 (.a(weighted_inputs3_10_1), .b(act2_10_1_1), .c(act2_10_1_2), .d(act2_10_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_10_1));
  mux_2 m172 (.a(weighted_inputs3_11_1), .b(act2_11_1_1), .c(act2_11_1_2), .d(act2_11_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_11_1));
  mux_2 m173 (.a(weighted_inputs3_12_1), .b(act2_12_1_1), .c(act2_12_1_2), .d(act2_12_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_12_1));
  mux_2 m174 (.a(weighted_inputs3_13_1), .b(act2_13_1_1), .c(act2_13_1_2), .d(act2_13_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_13_1));
  mux_2 m175 (.a(weighted_inputs3_14_1), .b(act2_14_1_1), .c(act2_14_1_2), .d(act2_14_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_14_1));
  mux_2 m176 (.a(weighted_inputs3_15_1), .b(act2_15_1_1), .c(act2_15_1_2), .d(act2_15_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs3_15_1));
  adder_tree add10 (
    .clk(clk),
    .in0(new_weighted_inputs3_0_1),
    .in1(new_weighted_inputs3_1_1),
    .in2(new_weighted_inputs3_2_1),
    .in3(new_weighted_inputs3_3_1),
    .in4(new_weighted_inputs3_4_1),
    .in5(new_weighted_inputs3_5_1),
    .in6(new_weighted_inputs3_6_1),
    .in7(new_weighted_inputs3_7_1),
    .in8(new_weighted_inputs3_8_1),
    .in9(new_weighted_inputs3_9_1),
    .in10(new_weighted_inputs3_10_1),
    .in11(new_weighted_inputs3_11_1),
    .in12(new_weighted_inputs3_12_1),
    .in13(new_weighted_inputs3_13_1),
    .in14(new_weighted_inputs3_14_1),
    .in15(new_weighted_inputs3_15_1),
    .sum(sum2[2])
  );
  adder_tree_bar addb10 (
    .clk(clk),
    .in0(new_weighted_inputs3_0_1),
    .in1(new_weighted_inputs3_1_1),
    .in2(new_weighted_inputs3_2_1),
    .in3(new_weighted_inputs3_3_1),
    .in4(new_weighted_inputs3_4_1),
    .in5(new_weighted_inputs3_5_1),
    .in6(new_weighted_inputs3_6_1),
    .in7(new_weighted_inputs3_7_1),
    .in8(new_weighted_inputs3_8_1),
    .in9(new_weighted_inputs3_9_1),
    .in10(new_weighted_inputs3_10_1),
    .in11(new_weighted_inputs3_11_1),
    .in12(new_weighted_inputs3_12_1),
    .in13(new_weighted_inputs3_13_1),
    .in14(new_weighted_inputs3_14_1),
    .in15(new_weighted_inputs3_15_1),
    .sum(sum2bar[2])
  );

  mux_2 m177 (.a(weighted_inputs4_0_1), .b(act3_0_1_1), .c(act3_0_1_2), .d(act3_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_0_1));
  mux_2 m178 (.a(weighted_inputs4_1_1), .b(act3_1_1_1), .c(act3_1_1_2), .d(act3_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_1_1));
  mux_2 m179 (.a(weighted_inputs4_2_1), .b(act3_2_1_1), .c(act3_2_1_2), .d(act3_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_2_1));
  mux_2 m180 (.a(weighted_inputs4_3_1), .b(act3_3_1_1), .c(act3_3_1_2), .d(act3_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_3_1));
  mux_2 m181 (.a(weighted_inputs4_4_1), .b(act3_4_1_1), .c(act3_4_1_2), .d(act3_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_4_1));
  mux_2 m182 (.a(weighted_inputs4_5_1), .b(act3_5_1_1), .c(act3_5_1_2), .d(act3_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_5_1));
  mux_2 m183 (.a(weighted_inputs4_6_1), .b(act3_6_1_1), .c(act3_6_1_2), .d(act3_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_6_1));
  mux_2 m184 (.a(weighted_inputs4_7_1), .b(act3_7_1_1), .c(act3_7_1_2), .d(act3_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_7_1));
  mux_2 m185 (.a(weighted_inputs4_8_1), .b(act3_8_1_1), .c(act3_8_1_2), .d(act3_8_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_8_1));
  mux_2 m186 (.a(weighted_inputs4_9_1), .b(act3_9_1_1), .c(act3_9_1_2), .d(act3_9_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_9_1));
  mux_2 m187 (.a(weighted_inputs4_10_1), .b(act3_10_1_1), .c(act3_10_1_2), .d(act3_10_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_10_1));
  mux_2 m188 (.a(weighted_inputs4_11_1), .b(act3_11_1_1), .c(act3_11_1_2), .d(act3_11_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_11_1));
  mux_2 m189 (.a(weighted_inputs4_12_1), .b(act3_12_1_1), .c(act3_12_1_2), .d(act3_12_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_12_1));
  mux_2 m190 (.a(weighted_inputs4_13_1), .b(act3_13_1_1), .c(act3_13_1_2), .d(act3_13_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_13_1));
  mux_2 m191 (.a(weighted_inputs4_14_1), .b(act3_14_1_1), .c(act3_14_1_2), .d(act3_14_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_14_1));
  mux_2 m192 (.a(weighted_inputs4_15_1), .b(act3_15_1_1), .c(act3_15_1_2), .d(act3_15_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs4_15_1));
  adder_tree add11 (
    .clk(clk),
    .in0(new_weighted_inputs4_0_1),
    .in1(new_weighted_inputs4_1_1),
    .in2(new_weighted_inputs4_2_1),
    .in3(new_weighted_inputs4_3_1),
    .in4(new_weighted_inputs4_4_1),
    .in5(new_weighted_inputs4_5_1),
    .in6(new_weighted_inputs4_6_1),
    .in7(new_weighted_inputs4_7_1),
    .in8(new_weighted_inputs4_8_1),
    .in9(new_weighted_inputs4_9_1),
    .in10(new_weighted_inputs4_10_1),
    .in11(new_weighted_inputs4_11_1),
    .in12(new_weighted_inputs4_12_1),
    .in13(new_weighted_inputs4_13_1),
    .in14(new_weighted_inputs4_14_1),
    .in15(new_weighted_inputs4_15_1),
    .sum(sum2[3])
  );
  adder_tree_bar addb11 (
    .clk(clk),
    .in0(new_weighted_inputs4_0_1),
    .in1(new_weighted_inputs4_1_1),
    .in2(new_weighted_inputs4_2_1),
    .in3(new_weighted_inputs4_3_1),
    .in4(new_weighted_inputs4_4_1),
    .in5(new_weighted_inputs4_5_1),
    .in6(new_weighted_inputs4_6_1),
    .in7(new_weighted_inputs4_7_1),
    .in8(new_weighted_inputs4_8_1),
    .in9(new_weighted_inputs4_9_1),
    .in10(new_weighted_inputs4_10_1),
    .in11(new_weighted_inputs4_11_1),
    .in12(new_weighted_inputs4_12_1),
    .in13(new_weighted_inputs4_13_1),
    .in14(new_weighted_inputs4_14_1),
    .in15(new_weighted_inputs4_15_1),
    .sum(sum2bar[3])
  );

  mux_2 m193 (.a(weighted_inputs5_0_1), .b(act4_0_1_1), .c(act4_0_1_2), .d(act4_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_0_1));
  mux_2 m194 (.a(weighted_inputs5_1_1), .b(act4_1_1_1), .c(act4_1_1_2), .d(act4_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_1_1));
  mux_2 m195 (.a(weighted_inputs5_2_1), .b(act4_2_1_1), .c(act4_2_1_2), .d(act4_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_2_1));
  mux_2 m196 (.a(weighted_inputs5_3_1), .b(act4_3_1_1), .c(act4_3_1_2), .d(act4_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_3_1));
  mux_2 m197 (.a(weighted_inputs5_4_1), .b(act4_4_1_1), .c(act4_4_1_2), .d(act4_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_4_1));
  mux_2 m198 (.a(weighted_inputs5_5_1), .b(act4_5_1_1), .c(act4_5_1_2), .d(act4_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_5_1));
  mux_2 m199 (.a(weighted_inputs5_6_1), .b(act4_6_1_1), .c(act4_6_1_2), .d(act4_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_6_1));
  mux_2 m200 (.a(weighted_inputs5_7_1), .b(act4_7_1_1), .c(act4_7_1_2), .d(act4_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_7_1));
  mux_2 m201 (.a(weighted_inputs5_8_1), .b(act4_8_1_1), .c(act4_8_1_2), .d(act4_8_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_8_1));
  mux_2 m202 (.a(weighted_inputs5_9_1), .b(act4_9_1_1), .c(act4_9_1_2), .d(act4_9_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_9_1));
  mux_2 m203 (.a(weighted_inputs5_10_1), .b(act4_10_1_1), .c(act4_10_1_2), .d(act4_10_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_10_1));
  mux_2 m204 (.a(weighted_inputs5_11_1), .b(act4_11_1_1), .c(act4_11_1_2), .d(act4_11_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_11_1));
  mux_2 m205 (.a(weighted_inputs5_12_1), .b(act4_12_1_1), .c(act4_12_1_2), .d(act4_12_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_12_1));
  mux_2 m206 (.a(weighted_inputs5_13_1), .b(act4_13_1_1), .c(act4_13_1_2), .d(act4_13_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_13_1));
  mux_2 m207 (.a(weighted_inputs5_14_1), .b(act4_14_1_1), .c(act4_14_1_2), .d(act4_14_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_14_1));
  mux_2 m208 (.a(weighted_inputs5_15_1), .b(act4_15_1_1), .c(act4_15_1_2), .d(act4_15_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs5_15_1));
  adder_tree add12 (
    .clk(clk),
    .in0(new_weighted_inputs5_0_1),
    .in1(new_weighted_inputs5_1_1),
    .in2(new_weighted_inputs5_2_1),
    .in3(new_weighted_inputs5_3_1),
    .in4(new_weighted_inputs5_4_1),
    .in5(new_weighted_inputs5_5_1),
    .in6(new_weighted_inputs5_6_1),
    .in7(new_weighted_inputs5_7_1),
    .in8(new_weighted_inputs5_8_1),
    .in9(new_weighted_inputs5_9_1),
    .in10(new_weighted_inputs5_10_1),
    .in11(new_weighted_inputs5_11_1),
    .in12(new_weighted_inputs5_12_1),
    .in13(new_weighted_inputs5_13_1),
    .in14(new_weighted_inputs5_14_1),
    .in15(new_weighted_inputs5_15_1),
    .sum(sum2[4])
  );
  adder_tree_bar addb12 (
    .clk(clk),
    .in0(new_weighted_inputs5_0_1),
    .in1(new_weighted_inputs5_1_1),
    .in2(new_weighted_inputs5_2_1),
    .in3(new_weighted_inputs5_3_1),
    .in4(new_weighted_inputs5_4_1),
    .in5(new_weighted_inputs5_5_1),
    .in6(new_weighted_inputs5_6_1),
    .in7(new_weighted_inputs5_7_1),
    .in8(new_weighted_inputs5_8_1),
    .in9(new_weighted_inputs5_9_1),
    .in10(new_weighted_inputs5_10_1),
    .in11(new_weighted_inputs5_11_1),
    .in12(new_weighted_inputs5_12_1),
    .in13(new_weighted_inputs5_13_1),
    .in14(new_weighted_inputs5_14_1),
    .in15(new_weighted_inputs5_15_1),
    .sum(sum2bar[4])
  );

  mux_2 m209 (.a(weighted_inputs6_0_1), .b(act5_0_1_1), .c(act5_0_1_2), .d(act5_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_0_1));
  mux_2 m210 (.a(weighted_inputs6_1_1), .b(act5_1_1_1), .c(act5_1_1_2), .d(act5_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_1_1));
  mux_2 m211 (.a(weighted_inputs6_2_1), .b(act5_2_1_1), .c(act5_2_1_2), .d(act5_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_2_1));
  mux_2 m212 (.a(weighted_inputs6_3_1), .b(act5_3_1_1), .c(act5_3_1_2), .d(act5_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_3_1));
  mux_2 m213 (.a(weighted_inputs6_4_1), .b(act5_4_1_1), .c(act5_4_1_2), .d(act5_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_4_1));
  mux_2 m214 (.a(weighted_inputs6_5_1), .b(act5_5_1_1), .c(act5_5_1_2), .d(act5_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_5_1));
  mux_2 m215 (.a(weighted_inputs6_6_1), .b(act5_6_1_1), .c(act5_6_1_2), .d(act5_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_6_1));
  mux_2 m216 (.a(weighted_inputs6_7_1), .b(act5_7_1_1), .c(act5_7_1_2), .d(act5_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_7_1));
  mux_2 m217 (.a(weighted_inputs6_8_1), .b(act5_8_1_1), .c(act5_8_1_2), .d(act5_8_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_8_1));
  mux_2 m218 (.a(weighted_inputs6_9_1), .b(act5_9_1_1), .c(act5_9_1_2), .d(act5_9_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_9_1));
  mux_2 m219 (.a(weighted_inputs6_10_1), .b(act5_10_1_1), .c(act5_10_1_2), .d(act5_10_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_10_1));
  mux_2 m220 (.a(weighted_inputs6_11_1), .b(act5_11_1_1), .c(act5_11_1_2), .d(act5_11_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_11_1));
  mux_2 m221 (.a(weighted_inputs6_12_1), .b(act5_12_1_1), .c(act5_12_1_2), .d(act5_12_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_12_1));
  mux_2 m222 (.a(weighted_inputs6_13_1), .b(act5_13_1_1), .c(act5_13_1_2), .d(act5_13_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_13_1));
  mux_2 m223 (.a(weighted_inputs6_14_1), .b(act5_14_1_1), .c(act5_14_1_2), .d(act5_14_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_14_1));
  mux_2 m224 (.a(weighted_inputs6_15_1), .b(act5_15_1_1), .c(act5_15_1_2), .d(act5_15_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs6_15_1));
  adder_tree add13 (
    .clk(clk),
    .in0(new_weighted_inputs6_0_1),
    .in1(new_weighted_inputs6_1_1),
    .in2(new_weighted_inputs6_2_1),
    .in3(new_weighted_inputs6_3_1),
    .in4(new_weighted_inputs6_4_1),
    .in5(new_weighted_inputs6_5_1),
    .in6(new_weighted_inputs6_6_1),
    .in7(new_weighted_inputs6_7_1),
    .in8(new_weighted_inputs6_8_1),
    .in9(new_weighted_inputs6_9_1),
    .in10(new_weighted_inputs6_10_1),
    .in11(new_weighted_inputs6_11_1),
    .in12(new_weighted_inputs6_12_1),
    .in13(new_weighted_inputs6_13_1),
    .in14(new_weighted_inputs6_14_1),
    .in15(new_weighted_inputs6_15_1),
    .sum(sum2[5])
  );
  adder_tree_bar addb13 (
    .clk(clk),
    .in0(new_weighted_inputs6_0_1),
    .in1(new_weighted_inputs6_1_1),
    .in2(new_weighted_inputs6_2_1),
    .in3(new_weighted_inputs6_3_1),
    .in4(new_weighted_inputs6_4_1),
    .in5(new_weighted_inputs6_5_1),
    .in6(new_weighted_inputs6_6_1),
    .in7(new_weighted_inputs6_7_1),
    .in8(new_weighted_inputs6_8_1),
    .in9(new_weighted_inputs6_9_1),
    .in10(new_weighted_inputs6_10_1),
    .in11(new_weighted_inputs6_11_1),
    .in12(new_weighted_inputs6_12_1),
    .in13(new_weighted_inputs6_13_1),
    .in14(new_weighted_inputs6_14_1),
    .in15(new_weighted_inputs6_15_1),
    .sum(sum2bar[5])
  );

  mux_2 m225 (.a(weighted_inputs7_0_1), .b(act6_0_1_1), .c(act6_0_1_2), .d(act6_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_0_1));
  mux_2 m226 (.a(weighted_inputs7_1_1), .b(act6_1_1_1), .c(act6_1_1_2), .d(act6_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_1_1));
  mux_2 m227 (.a(weighted_inputs7_2_1), .b(act6_2_1_1), .c(act6_2_1_2), .d(act6_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_2_1));
  mux_2 m228 (.a(weighted_inputs7_3_1), .b(act6_3_1_1), .c(act6_3_1_2), .d(act6_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_3_1));
  mux_2 m229 (.a(weighted_inputs7_4_1), .b(act6_4_1_1), .c(act6_4_1_2), .d(act6_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_4_1));
  mux_2 m230 (.a(weighted_inputs7_5_1), .b(act6_5_1_1), .c(act6_5_1_2), .d(act6_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_5_1));
  mux_2 m231 (.a(weighted_inputs7_6_1), .b(act6_6_1_1), .c(act6_6_1_2), .d(act6_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_6_1));
  mux_2 m232 (.a(weighted_inputs7_7_1), .b(act6_7_1_1), .c(act6_7_1_2), .d(act6_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_7_1));
  mux_2 m233 (.a(weighted_inputs7_8_1), .b(act6_8_1_1), .c(act6_8_1_2), .d(act6_8_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_8_1));
  mux_2 m234 (.a(weighted_inputs7_9_1), .b(act6_9_1_1), .c(act6_9_1_2), .d(act6_9_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_9_1));
  mux_2 m235 (.a(weighted_inputs7_10_1), .b(act6_10_1_1), .c(act6_10_1_2), .d(act6_10_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_10_1));
  mux_2 m236 (.a(weighted_inputs7_11_1), .b(act6_11_1_1), .c(act6_11_1_2), .d(act6_11_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_11_1));
  mux_2 m237 (.a(weighted_inputs7_12_1), .b(act6_12_1_1), .c(act6_12_1_2), .d(act6_12_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_12_1));
  mux_2 m238 (.a(weighted_inputs7_13_1), .b(act6_13_1_1), .c(act6_13_1_2), .d(act6_13_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_13_1));
  mux_2 m239 (.a(weighted_inputs7_14_1), .b(act6_14_1_1), .c(act6_14_1_2), .d(act6_14_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_14_1));
  mux_2 m240 (.a(weighted_inputs7_15_1), .b(act6_15_1_1), .c(act6_15_1_2), .d(act6_15_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs7_15_1));
  adder_tree add14 (
    .clk(clk),
    .in0(new_weighted_inputs7_0_1),
    .in1(new_weighted_inputs7_1_1),
    .in2(new_weighted_inputs7_2_1),
    .in3(new_weighted_inputs7_3_1),
    .in4(new_weighted_inputs7_4_1),
    .in5(new_weighted_inputs7_5_1),
    .in6(new_weighted_inputs7_6_1),
    .in7(new_weighted_inputs7_7_1),
    .in8(new_weighted_inputs7_8_1),
    .in9(new_weighted_inputs7_9_1),
    .in10(new_weighted_inputs7_10_1),
    .in11(new_weighted_inputs7_11_1),
    .in12(new_weighted_inputs7_12_1),
    .in13(new_weighted_inputs7_13_1),
    .in14(new_weighted_inputs7_14_1),
    .in15(new_weighted_inputs7_15_1),
    .sum(sum2[6])
  );
  adder_tree_bar addb14 (
    .clk(clk),
    .in0(new_weighted_inputs7_0_1),
    .in1(new_weighted_inputs7_1_1),
    .in2(new_weighted_inputs7_2_1),
    .in3(new_weighted_inputs7_3_1),
    .in4(new_weighted_inputs7_4_1),
    .in5(new_weighted_inputs7_5_1),
    .in6(new_weighted_inputs7_6_1),
    .in7(new_weighted_inputs7_7_1),
    .in8(new_weighted_inputs7_8_1),
    .in9(new_weighted_inputs7_9_1),
    .in10(new_weighted_inputs7_10_1),
    .in11(new_weighted_inputs7_11_1),
    .in12(new_weighted_inputs7_12_1),
    .in13(new_weighted_inputs7_13_1),
    .in14(new_weighted_inputs7_14_1),
    .in15(new_weighted_inputs7_15_1),
    .sum(sum2bar[6])
  );

  mux_2 m241 (.a(weighted_inputs8_0_1), .b(act7_0_1_1), .c(act7_0_1_2), .d(act7_0_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_0_1));
  mux_2 m242 (.a(weighted_inputs8_1_1), .b(act7_1_1_1), .c(act7_1_1_2), .d(act7_1_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_1_1));
  mux_2 m243 (.a(weighted_inputs8_2_1), .b(act7_2_1_1), .c(act7_2_1_2), .d(act7_2_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_2_1));
  mux_2 m244 (.a(weighted_inputs8_3_1), .b(act7_3_1_1), .c(act7_3_1_2), .d(act7_3_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_3_1));
  mux_2 m245 (.a(weighted_inputs8_4_1), .b(act7_4_1_1), .c(act7_4_1_2), .d(act7_4_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_4_1));
  mux_2 m246 (.a(weighted_inputs8_5_1), .b(act7_5_1_1), .c(act7_5_1_2), .d(act7_5_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_5_1));
  mux_2 m247 (.a(weighted_inputs8_6_1), .b(act7_6_1_1), .c(act7_6_1_2), .d(act7_6_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_6_1));
  mux_2 m248 (.a(weighted_inputs8_7_1), .b(act7_7_1_1), .c(act7_7_1_2), .d(act7_7_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_7_1));
  mux_2 m249 (.a(weighted_inputs8_8_1), .b(act7_8_1_1), .c(act7_8_1_2), .d(act7_8_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_8_1));
  mux_2 m250 (.a(weighted_inputs8_9_1), .b(act7_9_1_1), .c(act7_9_1_2), .d(act7_9_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_9_1));
  mux_2 m251 (.a(weighted_inputs8_10_1), .b(act7_10_1_1), .c(act7_10_1_2), .d(act7_10_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_10_1));
  mux_2 m252 (.a(weighted_inputs8_11_1), .b(act7_11_1_1), .c(act7_11_1_2), .d(act7_11_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_11_1));
  mux_2 m253 (.a(weighted_inputs8_12_1), .b(act7_12_1_1), .c(act7_12_1_2), .d(act7_12_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_12_1));
  mux_2 m254 (.a(weighted_inputs8_13_1), .b(act7_13_1_1), .c(act7_13_1_2), .d(act7_13_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_13_1));
  mux_2 m255 (.a(weighted_inputs8_14_1), .b(act7_14_1_1), .c(act7_14_1_2), .d(act7_14_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_14_1));
  mux_2 m256 (.a(weighted_inputs8_15_1), .b(act7_15_1_1), .c(act7_15_1_2), .d(act7_15_1_3), .s0(s[0]), .s1(s[1]), .y(new_weighted_inputs8_15_1));
  adder_tree add15 (
    .clk(clk),
    .in0(new_weighted_inputs8_0_1),
    .in1(new_weighted_inputs8_1_1),
    .in2(new_weighted_inputs8_2_1),
    .in3(new_weighted_inputs8_3_1),
    .in4(new_weighted_inputs8_4_1),
    .in5(new_weighted_inputs8_5_1),
    .in6(new_weighted_inputs8_6_1),
    .in7(new_weighted_inputs8_7_1),
    .in8(new_weighted_inputs8_8_1),
    .in9(new_weighted_inputs8_9_1),
    .in10(new_weighted_inputs8_10_1),
    .in11(new_weighted_inputs8_11_1),
    .in12(new_weighted_inputs8_12_1),
    .in13(new_weighted_inputs8_13_1),
    .in14(new_weighted_inputs8_14_1),
    .in15(new_weighted_inputs8_15_1),
    .sum(sum2[7])
  );
  adder_tree_bar addb15 (
    .clk(clk),
    .in0(new_weighted_inputs8_0_1),
    .in1(new_weighted_inputs8_1_1),
    .in2(new_weighted_inputs8_2_1),
    .in3(new_weighted_inputs8_3_1),
    .in4(new_weighted_inputs8_4_1),
    .in5(new_weighted_inputs8_5_1),
    .in6(new_weighted_inputs8_6_1),
    .in7(new_weighted_inputs8_7_1),
    .in8(new_weighted_inputs8_8_1),
    .in9(new_weighted_inputs8_9_1),
    .in10(new_weighted_inputs8_10_1),
    .in11(new_weighted_inputs8_11_1),
    .in12(new_weighted_inputs8_12_1),
    .in13(new_weighted_inputs8_13_1),
    .in14(new_weighted_inputs8_14_1),
    .in15(new_weighted_inputs8_15_1),
    .sum(sum2bar[7])
  );

  wire [6:0] b1;
  wire [6:0] b2;
  wire [6:0] b3;
  wire [6:0] b4;
  wire [6:0] b5;
  wire [6:0] b6;
  wire [6:0] b7;
  wire [6:0] b8;

  mux_5 mux0  (.a(b1_1), .b(b1_2), .c(b1_3), .d(b1_4), .s0(s[0]), .s1(s[1]), .y(b1));
  mux_5 mux1  (.a(b2_1), .b(b2_2), .c(b2_3), .d(b2_4), .s0(s[0]), .s1(s[1]), .y(b2));
  mux_5 mux2  (.a(b3_1), .b(b3_2), .c(b3_3), .d(b3_4), .s0(s[0]), .s1(s[1]), .y(b3));
  mux_5 mux3  (.a(b4_1), .b(b4_2), .c(b4_3), .d(b4_4), .s0(s[0]), .s1(s[1]), .y(b4));
  mux_5 mux4  (.a(b5_1), .b(b5_2), .c(b5_3), .d(b5_4), .s0(s[0]), .s1(s[1]), .y(b5));
  mux_5 mux5  (.a(b6_1), .b(b6_2), .c(b6_3), .d(b6_4), .s0(s[0]), .s1(s[1]), .y(b6));
  mux_5 mux6  (.a(b7_1), .b(b7_2), .c(b7_3), .d(b7_4), .s0(s[0]), .s1(s[1]), .y(b7));
  mux_5 mux7  (.a(b8_1), .b(b8_2), .c(b8_3), .d(b8_4), .s0(s[0]), .s1(s[1]), .y(b8));

  // bias addition
  add7bit     u0  (.a(sum1[0]),     .b(b1), .cin(1'b0), .y(biased_sum1[0]));
  add7bitbar ub0 (.a(sum1bar[0]), .b(b1), .cin(1'b0), .y(biased_sum1bar[0]));
  add7bit     u8  (.a(sum2[0]),     .b(b1), .cin(1'b0), .y(biased_sum2[0]));
  add7bitbar ub8 (.a(sum2bar[0]), .b(b1), .cin(1'b0), .y(biased_sum2bar[0]));
  add7bit     u1  (.a(sum1[1]),     .b(b2), .cin(1'b0), .y(biased_sum1[1]));
  add7bitbar ub1 (.a(sum1bar[1]), .b(b2), .cin(1'b0), .y(biased_sum1bar[1]));
  add7bit     u9  (.a(sum2[1]),     .b(b2), .cin(1'b0), .y(biased_sum2[1]));
  add7bitbar ub9 (.a(sum2bar[1]), .b(b2), .cin(1'b0), .y(biased_sum2bar[1]));
  add7bit     u2  (.a(sum1[2]),     .b(b3), .cin(1'b0), .y(biased_sum1[2]));
  add7bitbar ub2 (.a(sum1bar[2]), .b(b3), .cin(1'b0), .y(biased_sum1bar[2]));
  add7bit     u10  (.a(sum2[2]),     .b(b3), .cin(1'b0), .y(biased_sum2[2]));
  add7bitbar ub10 (.a(sum2bar[2]), .b(b3), .cin(1'b0), .y(biased_sum2bar[2]));
  add7bit     u3  (.a(sum1[3]),     .b(b4), .cin(1'b0), .y(biased_sum1[3]));
  add7bitbar ub3 (.a(sum1bar[3]), .b(b4), .cin(1'b0), .y(biased_sum1bar[3]));
  add7bit     u11  (.a(sum2[3]),     .b(b4), .cin(1'b0), .y(biased_sum2[3]));
  add7bitbar ub11 (.a(sum2bar[3]), .b(b4), .cin(1'b0), .y(biased_sum2bar[3]));
  add7bit     u4  (.a(sum1[4]),     .b(b5), .cin(1'b0), .y(biased_sum1[4]));
  add7bitbar ub4 (.a(sum1bar[4]), .b(b5), .cin(1'b0), .y(biased_sum1bar[4]));
  add7bit     u12  (.a(sum2[4]),     .b(b5), .cin(1'b0), .y(biased_sum2[4]));
  add7bitbar ub12 (.a(sum2bar[4]), .b(b5), .cin(1'b0), .y(biased_sum2bar[4]));
  add7bit     u5  (.a(sum1[5]),     .b(b6), .cin(1'b0), .y(biased_sum1[5]));
  add7bitbar ub5 (.a(sum1bar[5]), .b(b6), .cin(1'b0), .y(biased_sum1bar[5]));
  add7bit     u13  (.a(sum2[5]),     .b(b6), .cin(1'b0), .y(biased_sum2[5]));
  add7bitbar ub13 (.a(sum2bar[5]), .b(b6), .cin(1'b0), .y(biased_sum2bar[5]));
  add7bit     u6  (.a(sum1[6]),     .b(b7), .cin(1'b0), .y(biased_sum1[6]));
  add7bitbar ub6 (.a(sum1bar[6]), .b(b7), .cin(1'b0), .y(biased_sum1bar[6]));
  add7bit     u14  (.a(sum2[6]),     .b(b7), .cin(1'b0), .y(biased_sum2[6]));
  add7bitbar ub14 (.a(sum2bar[6]), .b(b7), .cin(1'b0), .y(biased_sum2bar[6]));
  add7bit     u7  (.a(sum1[7]),     .b(b8), .cin(1'b0), .y(biased_sum1[7]));
  add7bitbar ub7 (.a(sum1bar[7]), .b(b8), .cin(1'b0), .y(biased_sum1bar[7]));
  add7bit     u15  (.a(sum2[7]),     .b(b8), .cin(1'b0), .y(biased_sum2[7]));
  add7bitbar ub15 (.a(sum2bar[7]), .b(b8), .cin(1'b0), .y(biased_sum2bar[7]));

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

    assign biased_sum4_0 = biased_sum1[4];
    assign biased_sum4_1 = biased_sum2[4];
    assign biased_sum4_0bar = biased_sum1bar[4];
    assign biased_sum4_1bar = biased_sum2bar[4];

    assign biased_sum5_0 = biased_sum1[5];
    assign biased_sum5_1 = biased_sum2[5];
    assign biased_sum5_0bar = biased_sum1bar[5];
    assign biased_sum5_1bar = biased_sum2bar[5];

    assign biased_sum6_0 = biased_sum1[6];
    assign biased_sum6_1 = biased_sum2[6];
    assign biased_sum6_0bar = biased_sum1bar[6];
    assign biased_sum6_1bar = biased_sum2bar[6];

    assign biased_sum7_0 = biased_sum1[7];
    assign biased_sum7_1 = biased_sum2[7];
    assign biased_sum7_0bar = biased_sum1bar[7];
    assign biased_sum7_1bar = biased_sum2bar[7];


  always @(posedge clk) begin
    $display("----- BNN LAYER  OUTPUTS -----");
    $display("sum1: %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7]);
    $display("sum2: %b %b %b %b %b %b %b %b", sum2[0], sum2[1], sum2[2], sum2[3], sum2[4], sum2[5], sum2[6], sum2[7]);
    $display("sum1bar: %b %b %b %b %b %b %b %b", sum1bar[0], sum1bar[1], sum1bar[2], sum1bar[3], sum1bar[4], sum1bar[5], sum1bar[6], sum1bar[7]);
    $display("sum2bar: %b %b %b %b %b %b %b %b", sum2bar[0], sum2bar[1], sum2bar[2], sum2bar[3], sum2bar[4], sum2bar[5], sum2bar[6], sum2bar[7]);
    $display("bias values: %b %b %b %b %b %b %b %b", b1, b2, b3, b4, b5, b6, b7, b8);
    $display("biased_sum1: %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7]);
    $display("biased_sum2: %b %b %b %b %b %b %b %b", biased_sum2[0], biased_sum2[1], biased_sum2[2], biased_sum2[3], biased_sum2[4], biased_sum2[5], biased_sum2[6], biased_sum2[7]);
    $display("biased_sum1bar: %b %b %b %b %b %b %b %b", biased_sum1bar[0], biased_sum1bar[1], biased_sum1bar[2], biased_sum1bar[3], biased_sum1bar[4], biased_sum1bar[5], biased_sum1bar[6], biased_sum1bar[7]);
    $display("biased_sum2bar: %b %b %b %b %b %b %b %b", biased_sum2bar[0], biased_sum2bar[1], biased_sum2bar[2], biased_sum2bar[3], biased_sum2bar[4], biased_sum2bar[5], biased_sum2bar[6], biased_sum2bar[7]);
  end

  reg r0_0;
  reg r1_0;
  reg r2_0;
  reg r3_0;
  reg r4_0;
  reg r5_0;
  reg r6_0;
  reg r7_0;
  reg r0_1;
  reg r1_1;
  reg r2_1;
  reg r3_1;
  reg r4_1;
  reg r5_1;
  reg r6_1;
  reg r7_1;
  reg r0_2;
  reg r1_2;
  reg r2_2;
  reg r3_2;
  reg r4_2;
  reg r5_2;
  reg r6_2;
  reg r7_2;
  reg r0_3;
  reg r1_3;
  reg r2_3;
  reg r3_3;
  reg r4_3;
  reg r5_3;
  reg r6_3;
  reg r7_3;
  reg r0_4;
  reg r1_4;
  reg r2_4;
  reg r3_4;
  reg r4_4;
  reg r5_4;
  reg r6_4;
  reg r7_4;
  reg r0_5;
  reg r1_5;
  reg r2_5;
  reg r3_5;
  reg r4_5;
  reg r5_5;
  reg r6_5;
  reg r7_5;
  reg r0_6;
  reg r1_6;
  reg r2_6;
  reg r3_6;
  reg r4_6;
  reg r5_6;
  reg r6_6;
  reg r7_6;
  reg r0_7;
  reg r1_7;
  reg r2_7;
  reg r3_7;
  reg r4_7;
  reg r5_7;
  reg r6_7;
  reg r7_7;

  initial begin
    r0_0 = $random;
    r1_0 = $random;
    r2_0 = $random;
    r3_0 = $random;
    r4_0 = $random;
    r5_0 = $random;
    r6_0 = $random;
    r7_0 = $random;
    r0_1 = $random;
    r1_1 = $random;
    r2_1 = $random;
    r3_1 = $random;
    r4_1 = $random;
    r5_1 = $random;
    r6_1 = $random;
    r7_1 = $random;
    r0_2 = $random;
    r1_2 = $random;
    r2_2 = $random;
    r3_2 = $random;
    r4_2 = $random;
    r5_2 = $random;
    r6_2 = $random;
    r7_2 = $random;
    r0_3 = $random;
    r1_3 = $random;
    r2_3 = $random;
    r3_3 = $random;
    r4_3 = $random;
    r5_3 = $random;
    r6_3 = $random;
    r7_3 = $random;
    r0_4 = $random;
    r1_4 = $random;
    r2_4 = $random;
    r3_4 = $random;
    r4_4 = $random;
    r5_4 = $random;
    r6_4 = $random;
    r7_4 = $random;
    r0_5 = $random;
    r1_5 = $random;
    r2_5 = $random;
    r3_5 = $random;
    r4_5 = $random;
    r5_5 = $random;
    r6_5 = $random;
    r7_5 = $random;
    r0_6 = $random;
    r1_6 = $random;
    r2_6 = $random;
    r3_6 = $random;
    r4_6 = $random;
    r5_6 = $random;
    r6_6 = $random;
    r7_6 = $random;
    r0_7 = $random;
    r1_7 = $random;
    r2_7 = $random;
    r3_7 = $random;
    r4_7 = $random;
    r5_7 = $random;
    r6_7 = $random;
    r7_7 = $random;
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
    .inputs4_0(biased_sum4_0),
    .inputs4_1(biased_sum4_1),
    .inputs5_0(biased_sum5_0),
    .inputs5_1(biased_sum5_1),
    .inputs6_0(biased_sum6_0),
    .inputs6_1(biased_sum6_1),
    .inputs7_0(biased_sum7_0),
    .inputs7_1(biased_sum7_1),
    .r0_0(r0_0),
    .r1_0(r1_0),
    .r2_0(r2_0),
    .r3_0(r3_0),
    .r4_0(r4_0),
    .r5_0(r5_0),
    .r6_0(r6_0),
    .r7_0(r7_0),
    .r0_1(r0_1),
    .r1_1(r1_1),
    .r2_1(r2_1),
    .r3_1(r3_1),
    .r4_1(r4_1),
    .r5_1(r5_1),
    .r6_1(r6_1),
    .r7_1(r7_1),
    .r0_2(r0_2),
    .r1_2(r1_2),
    .r2_2(r2_2),
    .r3_2(r3_2),
    .r4_2(r4_2),
    .r5_2(r5_2),
    .r6_2(r6_2),
    .r7_2(r7_2),
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r6_3(r6_3),
    .r7_3(r7_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r6_4(r6_4),
    .r7_4(r7_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r6_5(r6_5),
    .r7_5(r7_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r6_6(r6_6),
    .r7_6(r7_6),
    .r0_7(r0_7),
    .r1_7(r1_7),
    .r2_7(r2_7),
    .r3_7(r3_7),
    .r4_7(r4_7),
    .r5_7(r5_7),
    .r6_7(r6_7),
    .r7_7(r7_7),
    .masked_activation0(masked_activation0_1),
    .masked_activation1(masked_activation1_1),
    .masked_activation2(masked_activation2_1),
    .masked_activation3(masked_activation3_1),
    .masked_activation4(masked_activation4_1),
    .masked_activation5(masked_activation5_1),
    .masked_activation6(masked_activation6_1),
    .masked_activation7(masked_activation7_1),
    .mask0(mask0_1),
    .mask1(mask1_1),
    .mask2(mask2_1),
    .mask3(mask3_1),
    .mask4(mask4_1),
    .mask5(mask5_1),
    .mask6(mask6_1),
    .mask7(mask7_1)
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
    .inputs4_0(biased_sum4_0bar),
    .inputs4_1(biased_sum4_1bar),
    .inputs5_0(biased_sum5_0bar),
    .inputs5_1(biased_sum5_1bar),
    .inputs6_0(biased_sum6_0bar),
    .inputs6_1(biased_sum6_1bar),
    .inputs7_0(biased_sum7_0bar),
    .inputs7_1(biased_sum7_1bar),
    .r0_0(r0_0),
    .r1_0(r1_0),
    .r2_0(r2_0),
    .r3_0(r3_0),
    .r4_0(r4_0),
    .r5_0(r5_0),
    .r6_0(r6_0),
    .r7_0(r7_0),
    .r0_1(r0_1),
    .r1_1(r1_1),
    .r2_1(r2_1),
    .r3_1(r3_1),
    .r4_1(r4_1),
    .r5_1(r5_1),
    .r6_1(r6_1),
    .r7_1(r7_1),
    .r0_2(r0_2),
    .r1_2(r1_2),
    .r2_2(r2_2),
    .r3_2(r3_2),
    .r4_2(r4_2),
    .r5_2(r5_2),
    .r6_2(r6_2),
    .r7_2(r7_2),
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r6_3(r6_3),
    .r7_3(r7_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r6_4(r6_4),
    .r7_4(r7_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r6_5(r6_5),
    .r7_5(r7_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r6_6(r6_6),
    .r7_6(r7_6),
    .r0_7(r0_7),
    .r1_7(r1_7),
    .r2_7(r2_7),
    .r3_7(r3_7),
    .r4_7(r4_7),
    .r5_7(r5_7),
    .r6_7(r6_7),
    .r7_7(r7_7),
    .masked_activation0(masked_activation0bar_1),
    .masked_activation1(masked_activation1bar_1),
    .masked_activation2(masked_activation2bar_1),
    .masked_activation3(masked_activation3bar_1),
    .masked_activation4(masked_activation4bar_1),
    .masked_activation5(masked_activation5bar_1),
    .masked_activation6(masked_activation6bar_1),
    .masked_activation7(masked_activation7bar_1),
    .mask0(mask0bar_1),
    .mask1(mask1bar_1),
    .mask2(mask2bar_1),
    .mask3(mask3bar_1),
    .mask4(mask4bar_1),
    .mask5(mask5bar_1),
    .mask6(mask6bar_1),
    .mask7(mask7bar_1)
  );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done <= 1'b0;
      biased_sum0_0_r    <= 8'd0;  biased_sum0_1_r    <= 8'd0;
      biased_sum0_0bar_r <= 8'd0;  biased_sum0_1bar_r <= 8'd0;
      masked_activation0_1_r <= 1'b0; masked_activation0bar_1_r <= 1'b0;
      mask0_1_r             <= 1'b0;             mask0bar_1_r             <= 1'b0;
      biased_sum1_0_r    <= 8'd0;  biased_sum1_1_r    <= 8'd0;
      biased_sum1_0bar_r <= 8'd0;  biased_sum1_1bar_r <= 8'd0;
      masked_activation1_1_r <= 1'b0; masked_activation1bar_1_r <= 1'b0;
      mask1_1_r             <= 1'b0;             mask1bar_1_r             <= 1'b0;
      biased_sum2_0_r    <= 8'd0;  biased_sum2_1_r    <= 8'd0;
      biased_sum2_0bar_r <= 8'd0;  biased_sum2_1bar_r <= 8'd0;
      masked_activation2_1_r <= 1'b0; masked_activation2bar_1_r <= 1'b0;
      mask2_1_r             <= 1'b0;             mask2bar_1_r             <= 1'b0;
      biased_sum3_0_r    <= 8'd0;  biased_sum3_1_r    <= 8'd0;
      biased_sum3_0bar_r <= 8'd0;  biased_sum3_1bar_r <= 8'd0;
      masked_activation3_1_r <= 1'b0; masked_activation3bar_1_r <= 1'b0;
      mask3_1_r             <= 1'b0;             mask3bar_1_r             <= 1'b0;
      biased_sum4_0_r    <= 8'd0;  biased_sum4_1_r    <= 8'd0;
      biased_sum4_0bar_r <= 8'd0;  biased_sum4_1bar_r <= 8'd0;
      masked_activation4_1_r <= 1'b0; masked_activation4bar_1_r <= 1'b0;
      mask4_1_r             <= 1'b0;             mask4bar_1_r             <= 1'b0;
      biased_sum5_0_r    <= 8'd0;  biased_sum5_1_r    <= 8'd0;
      biased_sum5_0bar_r <= 8'd0;  biased_sum5_1bar_r <= 8'd0;
      masked_activation5_1_r <= 1'b0; masked_activation5bar_1_r <= 1'b0;
      mask5_1_r             <= 1'b0;             mask5bar_1_r             <= 1'b0;
      biased_sum6_0_r    <= 8'd0;  biased_sum6_1_r    <= 8'd0;
      biased_sum6_0bar_r <= 8'd0;  biased_sum6_1bar_r <= 8'd0;
      masked_activation6_1_r <= 1'b0; masked_activation6bar_1_r <= 1'b0;
      mask6_1_r             <= 1'b0;             mask6bar_1_r             <= 1'b0;
      biased_sum7_0_r    <= 8'd0;  biased_sum7_1_r    <= 8'd0;
      biased_sum7_0bar_r <= 8'd0;  biased_sum7_1bar_r <= 8'd0;
      masked_activation7_1_r <= 1'b0; masked_activation7bar_1_r <= 1'b0;
      mask7_1_r             <= 1'b0;             mask7bar_1_r             <= 1'b0;
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
      biased_sum4_0_r    <= biased_sum4_0;  biased_sum4_1_r    <= biased_sum4_1;
      biased_sum4_0bar_r <= biased_sum4_0bar;  biased_sum4_1bar_r <= biased_sum4_1bar;
      masked_activation4_1_r <= masked_activation4_1; masked_activation4bar_1_r <= masked_activation4bar_1;
      mask4_1_r             <= mask4_1;             mask4bar_1_r             <= mask4bar_1;
      biased_sum5_0_r    <= biased_sum5_0;  biased_sum5_1_r    <= biased_sum5_1;
      biased_sum5_0bar_r <= biased_sum5_0bar;  biased_sum5_1bar_r <= biased_sum5_1bar;
      masked_activation5_1_r <= masked_activation5_1; masked_activation5bar_1_r <= masked_activation5bar_1;
      mask5_1_r             <= mask5_1;             mask5bar_1_r             <= mask5bar_1;
      biased_sum6_0_r    <= biased_sum6_0;  biased_sum6_1_r    <= biased_sum6_1;
      biased_sum6_0bar_r <= biased_sum6_0bar;  biased_sum6_1bar_r <= biased_sum6_1bar;
      masked_activation6_1_r <= masked_activation6_1; masked_activation6bar_1_r <= masked_activation6bar_1;
      mask6_1_r             <= mask6_1;             mask6bar_1_r             <= mask6bar_1;
      biased_sum7_0_r    <= biased_sum7_0;  biased_sum7_1_r    <= biased_sum7_1;
      biased_sum7_0bar_r <= biased_sum7_0bar;  biased_sum7_1bar_r <= biased_sum7_1bar;
      masked_activation7_1_r <= masked_activation7_1; masked_activation7bar_1_r <= masked_activation7bar_1;
      mask7_1_r             <= mask7_1;             mask7bar_1_r             <= mask7bar_1;
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

    input  wire [1:0] r_mask,

    output wire [2:0] arith_share0,

    output wire [2:0] arith_share1
);

    wire [2:0] y0;

    wire [2:0] y1;


    assign y0 = { r_mask, x0 };

    assign y1 = { r_mask, x1 };


    // stage1 for LSB

    assign arith_share0[0] = y0[0];


    mux m1(.a(y0[1]), .b(y1[0] ^ y0[1]), .s(arith_share0[0]), .y(arith_share0[1]));

    mux m2(.a(y0[1] ^ y0[2]), .b(y0[2] ^ y1[1]), .s(arith_share0[1]), .y(arith_share0[2]));


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
    input  wire        masked_activation4_1,
    input  wire        masked_activation5_1,
    input  wire        masked_activation6_1,
    input  wire        masked_activation7_1,
    input  wire        mask0_1,
    input  wire        mask1_1,
    input  wire        mask2_1,
    input  wire        mask3_1,
    input  wire        mask4_1,
    input  wire        mask5_1,
    input  wire        mask6_1,
    input  wire        mask7_1,

    // Weight vectors for the three sub-rounds
    input  wire [15:0]  w1_0_2, w1_1_2, w2_0_2, w2_1_2, w3_0_2, w3_1_2, w4_0_2, w4_1_2, w5_0_2, w5_1_2, w6_0_2, w6_1_2, w7_0_2, w7_1_2, w8_0_2, w8_1_2,
    input  wire [15:0]  w1_0_3, w1_1_3, w2_0_3, w2_1_3, w3_0_3, w3_1_3, w4_0_3, w4_1_3, w5_0_3, w5_1_3, w6_0_3, w6_1_3, w7_0_3, w7_1_3, w8_0_3, w8_1_3,
    input  wire [15:0]  w1_0_4, w1_1_4, w2_0_4, w2_1_4, w3_0_4, w3_1_4, w4_0_4, w4_1_4, w5_0_4, w5_1_4, w6_0_4, w6_1_4, w7_0_4, w7_1_4, w8_0_4, w8_1_4,

    // Selection bits
    input  wire [1:0]  s,

    // Registered arithmetic-shares outputs (_r suffix)
    output reg  [2:0]act0_0_0_r,
    output reg  [2:0]act0_0_1_r,
    output reg  [2:0]act0_0_2_r,
    output reg  [2:0]act0_0_3_r,
    output reg  [2:0]act0_0_4_r,
    output reg  [2:0]act0_0_5_r,
    output reg  [2:0]act0_0_6_r,
    output reg  [2:0]act0_0_7_r,
    output reg  [2:0]act0_0_8_r,
    output reg  [2:0]act0_0_9_r,
    output reg  [2:0]act0_0_10_r,
    output reg  [2:0]act0_0_11_r,
    output reg  [2:0]act0_0_12_r,
    output reg  [2:0]act0_0_13_r,
    output reg  [2:0]act0_0_14_r,
    output reg  [2:0]act0_0_15_r,
    output reg  [2:0]act0_1_0_r,
    output reg  [2:0]act0_1_1_r,
    output reg  [2:0]act0_1_2_r,
    output reg  [2:0]act0_1_3_r,
    output reg  [2:0]act0_1_4_r,
    output reg  [2:0]act0_1_5_r,
    output reg  [2:0]act0_1_6_r,
    output reg  [2:0]act0_1_7_r,
    output reg  [2:0]act0_1_8_r,
    output reg  [2:0]act0_1_9_r,
    output reg  [2:0]act0_1_10_r,
    output reg  [2:0]act0_1_11_r,
    output reg  [2:0]act0_1_12_r,
    output reg  [2:0]act0_1_13_r,
    output reg  [2:0]act0_1_14_r,
    output reg  [2:0]act0_1_15_r,
    output reg  [2:0]act1_0_0_r,
    output reg  [2:0]act1_0_1_r,
    output reg  [2:0]act1_0_2_r,
    output reg  [2:0]act1_0_3_r,
    output reg  [2:0]act1_0_4_r,
    output reg  [2:0]act1_0_5_r,
    output reg  [2:0]act1_0_6_r,
    output reg  [2:0]act1_0_7_r,
    output reg  [2:0]act1_0_8_r,
    output reg  [2:0]act1_0_9_r,
    output reg  [2:0]act1_0_10_r,
    output reg  [2:0]act1_0_11_r,
    output reg  [2:0]act1_0_12_r,
    output reg  [2:0]act1_0_13_r,
    output reg  [2:0]act1_0_14_r,
    output reg  [2:0]act1_0_15_r,
    output reg  [2:0]act1_1_0_r,
    output reg  [2:0]act1_1_1_r,
    output reg  [2:0]act1_1_2_r,
    output reg  [2:0]act1_1_3_r,
    output reg  [2:0]act1_1_4_r,
    output reg  [2:0]act1_1_5_r,
    output reg  [2:0]act1_1_6_r,
    output reg  [2:0]act1_1_7_r,
    output reg  [2:0]act1_1_8_r,
    output reg  [2:0]act1_1_9_r,
    output reg  [2:0]act1_1_10_r,
    output reg  [2:0]act1_1_11_r,
    output reg  [2:0]act1_1_12_r,
    output reg  [2:0]act1_1_13_r,
    output reg  [2:0]act1_1_14_r,
    output reg  [2:0]act1_1_15_r,
    output reg  [2:0]act2_0_0_r,
    output reg  [2:0]act2_0_1_r,
    output reg  [2:0]act2_0_2_r,
    output reg  [2:0]act2_0_3_r,
    output reg  [2:0]act2_0_4_r,
    output reg  [2:0]act2_0_5_r,
    output reg  [2:0]act2_0_6_r,
    output reg  [2:0]act2_0_7_r,
    output reg  [2:0]act2_0_8_r,
    output reg  [2:0]act2_0_9_r,
    output reg  [2:0]act2_0_10_r,
    output reg  [2:0]act2_0_11_r,
    output reg  [2:0]act2_0_12_r,
    output reg  [2:0]act2_0_13_r,
    output reg  [2:0]act2_0_14_r,
    output reg  [2:0]act2_0_15_r,
    output reg  [2:0]act2_1_0_r,
    output reg  [2:0]act2_1_1_r,
    output reg  [2:0]act2_1_2_r,
    output reg  [2:0]act2_1_3_r,
    output reg  [2:0]act2_1_4_r,
    output reg  [2:0]act2_1_5_r,
    output reg  [2:0]act2_1_6_r,
    output reg  [2:0]act2_1_7_r,
    output reg  [2:0]act2_1_8_r,
    output reg  [2:0]act2_1_9_r,
    output reg  [2:0]act2_1_10_r,
    output reg  [2:0]act2_1_11_r,
    output reg  [2:0]act2_1_12_r,
    output reg  [2:0]act2_1_13_r,
    output reg  [2:0]act2_1_14_r,
    output reg  [2:0]act2_1_15_r,
    output reg  [2:0]act3_0_0_r,
    output reg  [2:0]act3_0_1_r,
    output reg  [2:0]act3_0_2_r,
    output reg  [2:0]act3_0_3_r,
    output reg  [2:0]act3_0_4_r,
    output reg  [2:0]act3_0_5_r,
    output reg  [2:0]act3_0_6_r,
    output reg  [2:0]act3_0_7_r,
    output reg  [2:0]act3_0_8_r,
    output reg  [2:0]act3_0_9_r,
    output reg  [2:0]act3_0_10_r,
    output reg  [2:0]act3_0_11_r,
    output reg  [2:0]act3_0_12_r,
    output reg  [2:0]act3_0_13_r,
    output reg  [2:0]act3_0_14_r,
    output reg  [2:0]act3_0_15_r,
    output reg  [2:0]act3_1_0_r,
    output reg  [2:0]act3_1_1_r,
    output reg  [2:0]act3_1_2_r,
    output reg  [2:0]act3_1_3_r,
    output reg  [2:0]act3_1_4_r,
    output reg  [2:0]act3_1_5_r,
    output reg  [2:0]act3_1_6_r,
    output reg  [2:0]act3_1_7_r,
    output reg  [2:0]act3_1_8_r,
    output reg  [2:0]act3_1_9_r,
    output reg  [2:0]act3_1_10_r,
    output reg  [2:0]act3_1_11_r,
    output reg  [2:0]act3_1_12_r,
    output reg  [2:0]act3_1_13_r,
    output reg  [2:0]act3_1_14_r,
    output reg  [2:0]act3_1_15_r,
    output reg  [2:0]act4_0_0_r,
    output reg  [2:0]act4_0_1_r,
    output reg  [2:0]act4_0_2_r,
    output reg  [2:0]act4_0_3_r,
    output reg  [2:0]act4_0_4_r,
    output reg  [2:0]act4_0_5_r,
    output reg  [2:0]act4_0_6_r,
    output reg  [2:0]act4_0_7_r,
    output reg  [2:0]act4_0_8_r,
    output reg  [2:0]act4_0_9_r,
    output reg  [2:0]act4_0_10_r,
    output reg  [2:0]act4_0_11_r,
    output reg  [2:0]act4_0_12_r,
    output reg  [2:0]act4_0_13_r,
    output reg  [2:0]act4_0_14_r,
    output reg  [2:0]act4_0_15_r,
    output reg  [2:0]act4_1_0_r,
    output reg  [2:0]act4_1_1_r,
    output reg  [2:0]act4_1_2_r,
    output reg  [2:0]act4_1_3_r,
    output reg  [2:0]act4_1_4_r,
    output reg  [2:0]act4_1_5_r,
    output reg  [2:0]act4_1_6_r,
    output reg  [2:0]act4_1_7_r,
    output reg  [2:0]act4_1_8_r,
    output reg  [2:0]act4_1_9_r,
    output reg  [2:0]act4_1_10_r,
    output reg  [2:0]act4_1_11_r,
    output reg  [2:0]act4_1_12_r,
    output reg  [2:0]act4_1_13_r,
    output reg  [2:0]act4_1_14_r,
    output reg  [2:0]act4_1_15_r,
    output reg  [2:0]act5_0_0_r,
    output reg  [2:0]act5_0_1_r,
    output reg  [2:0]act5_0_2_r,
    output reg  [2:0]act5_0_3_r,
    output reg  [2:0]act5_0_4_r,
    output reg  [2:0]act5_0_5_r,
    output reg  [2:0]act5_0_6_r,
    output reg  [2:0]act5_0_7_r,
    output reg  [2:0]act5_0_8_r,
    output reg  [2:0]act5_0_9_r,
    output reg  [2:0]act5_0_10_r,
    output reg  [2:0]act5_0_11_r,
    output reg  [2:0]act5_0_12_r,
    output reg  [2:0]act5_0_13_r,
    output reg  [2:0]act5_0_14_r,
    output reg  [2:0]act5_0_15_r,
    output reg  [2:0]act5_1_0_r,
    output reg  [2:0]act5_1_1_r,
    output reg  [2:0]act5_1_2_r,
    output reg  [2:0]act5_1_3_r,
    output reg  [2:0]act5_1_4_r,
    output reg  [2:0]act5_1_5_r,
    output reg  [2:0]act5_1_6_r,
    output reg  [2:0]act5_1_7_r,
    output reg  [2:0]act5_1_8_r,
    output reg  [2:0]act5_1_9_r,
    output reg  [2:0]act5_1_10_r,
    output reg  [2:0]act5_1_11_r,
    output reg  [2:0]act5_1_12_r,
    output reg  [2:0]act5_1_13_r,
    output reg  [2:0]act5_1_14_r,
    output reg  [2:0]act5_1_15_r,
    output reg  [2:0]act6_0_0_r,
    output reg  [2:0]act6_0_1_r,
    output reg  [2:0]act6_0_2_r,
    output reg  [2:0]act6_0_3_r,
    output reg  [2:0]act6_0_4_r,
    output reg  [2:0]act6_0_5_r,
    output reg  [2:0]act6_0_6_r,
    output reg  [2:0]act6_0_7_r,
    output reg  [2:0]act6_0_8_r,
    output reg  [2:0]act6_0_9_r,
    output reg  [2:0]act6_0_10_r,
    output reg  [2:0]act6_0_11_r,
    output reg  [2:0]act6_0_12_r,
    output reg  [2:0]act6_0_13_r,
    output reg  [2:0]act6_0_14_r,
    output reg  [2:0]act6_0_15_r,
    output reg  [2:0]act6_1_0_r,
    output reg  [2:0]act6_1_1_r,
    output reg  [2:0]act6_1_2_r,
    output reg  [2:0]act6_1_3_r,
    output reg  [2:0]act6_1_4_r,
    output reg  [2:0]act6_1_5_r,
    output reg  [2:0]act6_1_6_r,
    output reg  [2:0]act6_1_7_r,
    output reg  [2:0]act6_1_8_r,
    output reg  [2:0]act6_1_9_r,
    output reg  [2:0]act6_1_10_r,
    output reg  [2:0]act6_1_11_r,
    output reg  [2:0]act6_1_12_r,
    output reg  [2:0]act6_1_13_r,
    output reg  [2:0]act6_1_14_r,
    output reg  [2:0]act6_1_15_r,
    output reg  [2:0]act7_0_0_r,
    output reg  [2:0]act7_0_1_r,
    output reg  [2:0]act7_0_2_r,
    output reg  [2:0]act7_0_3_r,
    output reg  [2:0]act7_0_4_r,
    output reg  [2:0]act7_0_5_r,
    output reg  [2:0]act7_0_6_r,
    output reg  [2:0]act7_0_7_r,
    output reg  [2:0]act7_0_8_r,
    output reg  [2:0]act7_0_9_r,
    output reg  [2:0]act7_0_10_r,
    output reg  [2:0]act7_0_11_r,
    output reg  [2:0]act7_0_12_r,
    output reg  [2:0]act7_0_13_r,
    output reg  [2:0]act7_0_14_r,
    output reg  [2:0]act7_0_15_r,
    output reg  [2:0]act7_1_0_r,
    output reg  [2:0]act7_1_1_r,
    output reg  [2:0]act7_1_2_r,
    output reg  [2:0]act7_1_3_r,
    output reg  [2:0]act7_1_4_r,
    output reg  [2:0]act7_1_5_r,
    output reg  [2:0]act7_1_6_r,
    output reg  [2:0]act7_1_7_r,
    output reg  [2:0]act7_1_8_r,
    output reg  [2:0]act7_1_9_r,
    output reg  [2:0]act7_1_10_r,
    output reg  [2:0]act7_1_11_r,
    output reg  [2:0]act7_1_12_r,
    output reg  [2:0]act7_1_13_r,
    output reg  [2:0]act7_1_14_r,
    output reg  [2:0]act7_1_15_r
);

  //--------------------------------------------------------------------------
  // 1) COMBINATIONAL WIRES
  //--------------------------------------------------------------------------
  reg [1:0] ar0, ar1, ar2, ar3, ar4, ar5, ar6, ar7;

  initial begin
    ar0    = $random;
    ar1    = $random;
    ar2    = $random;
    ar3    = $random;
    ar4    = $random;
    ar5    = $random;
    ar6    = $random;
    ar7    = $random;
    #1;
  end

  // Arithmetic shares driven by each converter (32 converters × 2 shares)
  wire [2:0] act0_0_0_1;
  wire [2:0] act0_0_1_1;
  wire [2:0] act0_0_0_2;
  wire [2:0] act0_0_1_2;
  wire [2:0] act0_0_0_3;
  wire [2:0] act0_0_1_3;
  wire [2:0] act0_1_0_1;
  wire [2:0] act0_1_1_1;
  wire [2:0] act0_1_0_2;
  wire [2:0] act0_1_1_2;
  wire [2:0] act0_1_0_3;
  wire [2:0] act0_1_1_3;
  wire [2:0] act0_2_0_1;
  wire [2:0] act0_2_1_1;
  wire [2:0] act0_2_0_2;
  wire [2:0] act0_2_1_2;
  wire [2:0] act0_2_0_3;
  wire [2:0] act0_2_1_3;
  wire [2:0] act0_3_0_1;
  wire [2:0] act0_3_1_1;
  wire [2:0] act0_3_0_2;
  wire [2:0] act0_3_1_2;
  wire [2:0] act0_3_0_3;
  wire [2:0] act0_3_1_3;
  wire [2:0] act0_4_0_1;
  wire [2:0] act0_4_1_1;
  wire [2:0] act0_4_0_2;
  wire [2:0] act0_4_1_2;
  wire [2:0] act0_4_0_3;
  wire [2:0] act0_4_1_3;
  wire [2:0] act0_5_0_1;
  wire [2:0] act0_5_1_1;
  wire [2:0] act0_5_0_2;
  wire [2:0] act0_5_1_2;
  wire [2:0] act0_5_0_3;
  wire [2:0] act0_5_1_3;
  wire [2:0] act0_6_0_1;
  wire [2:0] act0_6_1_1;
  wire [2:0] act0_6_0_2;
  wire [2:0] act0_6_1_2;
  wire [2:0] act0_6_0_3;
  wire [2:0] act0_6_1_3;
  wire [2:0] act0_7_0_1;
  wire [2:0] act0_7_1_1;
  wire [2:0] act0_7_0_2;
  wire [2:0] act0_7_1_2;
  wire [2:0] act0_7_0_3;
  wire [2:0] act0_7_1_3;
  wire [2:0] act0_8_0_1;
  wire [2:0] act0_8_1_1;
  wire [2:0] act0_8_0_2;
  wire [2:0] act0_8_1_2;
  wire [2:0] act0_8_0_3;
  wire [2:0] act0_8_1_3;
  wire [2:0] act0_9_0_1;
  wire [2:0] act0_9_1_1;
  wire [2:0] act0_9_0_2;
  wire [2:0] act0_9_1_2;
  wire [2:0] act0_9_0_3;
  wire [2:0] act0_9_1_3;
  wire [2:0] act0_10_0_1;
  wire [2:0] act0_10_1_1;
  wire [2:0] act0_10_0_2;
  wire [2:0] act0_10_1_2;
  wire [2:0] act0_10_0_3;
  wire [2:0] act0_10_1_3;
  wire [2:0] act0_11_0_1;
  wire [2:0] act0_11_1_1;
  wire [2:0] act0_11_0_2;
  wire [2:0] act0_11_1_2;
  wire [2:0] act0_11_0_3;
  wire [2:0] act0_11_1_3;
  wire [2:0] act0_12_0_1;
  wire [2:0] act0_12_1_1;
  wire [2:0] act0_12_0_2;
  wire [2:0] act0_12_1_2;
  wire [2:0] act0_12_0_3;
  wire [2:0] act0_12_1_3;
  wire [2:0] act0_13_0_1;
  wire [2:0] act0_13_1_1;
  wire [2:0] act0_13_0_2;
  wire [2:0] act0_13_1_2;
  wire [2:0] act0_13_0_3;
  wire [2:0] act0_13_1_3;
  wire [2:0] act0_14_0_1;
  wire [2:0] act0_14_1_1;
  wire [2:0] act0_14_0_2;
  wire [2:0] act0_14_1_2;
  wire [2:0] act0_14_0_3;
  wire [2:0] act0_14_1_3;
  wire [2:0] act0_15_0_1;
  wire [2:0] act0_15_1_1;
  wire [2:0] act0_15_0_2;
  wire [2:0] act0_15_1_2;
  wire [2:0] act0_15_0_3;
  wire [2:0] act0_15_1_3;
  wire [2:0] act1_0_0_1;
  wire [2:0] act1_0_1_1;
  wire [2:0] act1_0_0_2;
  wire [2:0] act1_0_1_2;
  wire [2:0] act1_0_0_3;
  wire [2:0] act1_0_1_3;
  wire [2:0] act1_1_0_1;
  wire [2:0] act1_1_1_1;
  wire [2:0] act1_1_0_2;
  wire [2:0] act1_1_1_2;
  wire [2:0] act1_1_0_3;
  wire [2:0] act1_1_1_3;
  wire [2:0] act1_2_0_1;
  wire [2:0] act1_2_1_1;
  wire [2:0] act1_2_0_2;
  wire [2:0] act1_2_1_2;
  wire [2:0] act1_2_0_3;
  wire [2:0] act1_2_1_3;
  wire [2:0] act1_3_0_1;
  wire [2:0] act1_3_1_1;
  wire [2:0] act1_3_0_2;
  wire [2:0] act1_3_1_2;
  wire [2:0] act1_3_0_3;
  wire [2:0] act1_3_1_3;
  wire [2:0] act1_4_0_1;
  wire [2:0] act1_4_1_1;
  wire [2:0] act1_4_0_2;
  wire [2:0] act1_4_1_2;
  wire [2:0] act1_4_0_3;
  wire [2:0] act1_4_1_3;
  wire [2:0] act1_5_0_1;
  wire [2:0] act1_5_1_1;
  wire [2:0] act1_5_0_2;
  wire [2:0] act1_5_1_2;
  wire [2:0] act1_5_0_3;
  wire [2:0] act1_5_1_3;
  wire [2:0] act1_6_0_1;
  wire [2:0] act1_6_1_1;
  wire [2:0] act1_6_0_2;
  wire [2:0] act1_6_1_2;
  wire [2:0] act1_6_0_3;
  wire [2:0] act1_6_1_3;
  wire [2:0] act1_7_0_1;
  wire [2:0] act1_7_1_1;
  wire [2:0] act1_7_0_2;
  wire [2:0] act1_7_1_2;
  wire [2:0] act1_7_0_3;
  wire [2:0] act1_7_1_3;
  wire [2:0] act1_8_0_1;
  wire [2:0] act1_8_1_1;
  wire [2:0] act1_8_0_2;
  wire [2:0] act1_8_1_2;
  wire [2:0] act1_8_0_3;
  wire [2:0] act1_8_1_3;
  wire [2:0] act1_9_0_1;
  wire [2:0] act1_9_1_1;
  wire [2:0] act1_9_0_2;
  wire [2:0] act1_9_1_2;
  wire [2:0] act1_9_0_3;
  wire [2:0] act1_9_1_3;
  wire [2:0] act1_10_0_1;
  wire [2:0] act1_10_1_1;
  wire [2:0] act1_10_0_2;
  wire [2:0] act1_10_1_2;
  wire [2:0] act1_10_0_3;
  wire [2:0] act1_10_1_3;
  wire [2:0] act1_11_0_1;
  wire [2:0] act1_11_1_1;
  wire [2:0] act1_11_0_2;
  wire [2:0] act1_11_1_2;
  wire [2:0] act1_11_0_3;
  wire [2:0] act1_11_1_3;
  wire [2:0] act1_12_0_1;
  wire [2:0] act1_12_1_1;
  wire [2:0] act1_12_0_2;
  wire [2:0] act1_12_1_2;
  wire [2:0] act1_12_0_3;
  wire [2:0] act1_12_1_3;
  wire [2:0] act1_13_0_1;
  wire [2:0] act1_13_1_1;
  wire [2:0] act1_13_0_2;
  wire [2:0] act1_13_1_2;
  wire [2:0] act1_13_0_3;
  wire [2:0] act1_13_1_3;
  wire [2:0] act1_14_0_1;
  wire [2:0] act1_14_1_1;
  wire [2:0] act1_14_0_2;
  wire [2:0] act1_14_1_2;
  wire [2:0] act1_14_0_3;
  wire [2:0] act1_14_1_3;
  wire [2:0] act1_15_0_1;
  wire [2:0] act1_15_1_1;
  wire [2:0] act1_15_0_2;
  wire [2:0] act1_15_1_2;
  wire [2:0] act1_15_0_3;
  wire [2:0] act1_15_1_3;
  wire [2:0] act2_0_0_1;
  wire [2:0] act2_0_1_1;
  wire [2:0] act2_0_0_2;
  wire [2:0] act2_0_1_2;
  wire [2:0] act2_0_0_3;
  wire [2:0] act2_0_1_3;
  wire [2:0] act2_1_0_1;
  wire [2:0] act2_1_1_1;
  wire [2:0] act2_1_0_2;
  wire [2:0] act2_1_1_2;
  wire [2:0] act2_1_0_3;
  wire [2:0] act2_1_1_3;
  wire [2:0] act2_2_0_1;
  wire [2:0] act2_2_1_1;
  wire [2:0] act2_2_0_2;
  wire [2:0] act2_2_1_2;
  wire [2:0] act2_2_0_3;
  wire [2:0] act2_2_1_3;
  wire [2:0] act2_3_0_1;
  wire [2:0] act2_3_1_1;
  wire [2:0] act2_3_0_2;
  wire [2:0] act2_3_1_2;
  wire [2:0] act2_3_0_3;
  wire [2:0] act2_3_1_3;
  wire [2:0] act2_4_0_1;
  wire [2:0] act2_4_1_1;
  wire [2:0] act2_4_0_2;
  wire [2:0] act2_4_1_2;
  wire [2:0] act2_4_0_3;
  wire [2:0] act2_4_1_3;
  wire [2:0] act2_5_0_1;
  wire [2:0] act2_5_1_1;
  wire [2:0] act2_5_0_2;
  wire [2:0] act2_5_1_2;
  wire [2:0] act2_5_0_3;
  wire [2:0] act2_5_1_3;
  wire [2:0] act2_6_0_1;
  wire [2:0] act2_6_1_1;
  wire [2:0] act2_6_0_2;
  wire [2:0] act2_6_1_2;
  wire [2:0] act2_6_0_3;
  wire [2:0] act2_6_1_3;
  wire [2:0] act2_7_0_1;
  wire [2:0] act2_7_1_1;
  wire [2:0] act2_7_0_2;
  wire [2:0] act2_7_1_2;
  wire [2:0] act2_7_0_3;
  wire [2:0] act2_7_1_3;
  wire [2:0] act2_8_0_1;
  wire [2:0] act2_8_1_1;
  wire [2:0] act2_8_0_2;
  wire [2:0] act2_8_1_2;
  wire [2:0] act2_8_0_3;
  wire [2:0] act2_8_1_3;
  wire [2:0] act2_9_0_1;
  wire [2:0] act2_9_1_1;
  wire [2:0] act2_9_0_2;
  wire [2:0] act2_9_1_2;
  wire [2:0] act2_9_0_3;
  wire [2:0] act2_9_1_3;
  wire [2:0] act2_10_0_1;
  wire [2:0] act2_10_1_1;
  wire [2:0] act2_10_0_2;
  wire [2:0] act2_10_1_2;
  wire [2:0] act2_10_0_3;
  wire [2:0] act2_10_1_3;
  wire [2:0] act2_11_0_1;
  wire [2:0] act2_11_1_1;
  wire [2:0] act2_11_0_2;
  wire [2:0] act2_11_1_2;
  wire [2:0] act2_11_0_3;
  wire [2:0] act2_11_1_3;
  wire [2:0] act2_12_0_1;
  wire [2:0] act2_12_1_1;
  wire [2:0] act2_12_0_2;
  wire [2:0] act2_12_1_2;
  wire [2:0] act2_12_0_3;
  wire [2:0] act2_12_1_3;
  wire [2:0] act2_13_0_1;
  wire [2:0] act2_13_1_1;
  wire [2:0] act2_13_0_2;
  wire [2:0] act2_13_1_2;
  wire [2:0] act2_13_0_3;
  wire [2:0] act2_13_1_3;
  wire [2:0] act2_14_0_1;
  wire [2:0] act2_14_1_1;
  wire [2:0] act2_14_0_2;
  wire [2:0] act2_14_1_2;
  wire [2:0] act2_14_0_3;
  wire [2:0] act2_14_1_3;
  wire [2:0] act2_15_0_1;
  wire [2:0] act2_15_1_1;
  wire [2:0] act2_15_0_2;
  wire [2:0] act2_15_1_2;
  wire [2:0] act2_15_0_3;
  wire [2:0] act2_15_1_3;
  wire [2:0] act3_0_0_1;
  wire [2:0] act3_0_1_1;
  wire [2:0] act3_0_0_2;
  wire [2:0] act3_0_1_2;
  wire [2:0] act3_0_0_3;
  wire [2:0] act3_0_1_3;
  wire [2:0] act3_1_0_1;
  wire [2:0] act3_1_1_1;
  wire [2:0] act3_1_0_2;
  wire [2:0] act3_1_1_2;
  wire [2:0] act3_1_0_3;
  wire [2:0] act3_1_1_3;
  wire [2:0] act3_2_0_1;
  wire [2:0] act3_2_1_1;
  wire [2:0] act3_2_0_2;
  wire [2:0] act3_2_1_2;
  wire [2:0] act3_2_0_3;
  wire [2:0] act3_2_1_3;
  wire [2:0] act3_3_0_1;
  wire [2:0] act3_3_1_1;
  wire [2:0] act3_3_0_2;
  wire [2:0] act3_3_1_2;
  wire [2:0] act3_3_0_3;
  wire [2:0] act3_3_1_3;
  wire [2:0] act3_4_0_1;
  wire [2:0] act3_4_1_1;
  wire [2:0] act3_4_0_2;
  wire [2:0] act3_4_1_2;
  wire [2:0] act3_4_0_3;
  wire [2:0] act3_4_1_3;
  wire [2:0] act3_5_0_1;
  wire [2:0] act3_5_1_1;
  wire [2:0] act3_5_0_2;
  wire [2:0] act3_5_1_2;
  wire [2:0] act3_5_0_3;
  wire [2:0] act3_5_1_3;
  wire [2:0] act3_6_0_1;
  wire [2:0] act3_6_1_1;
  wire [2:0] act3_6_0_2;
  wire [2:0] act3_6_1_2;
  wire [2:0] act3_6_0_3;
  wire [2:0] act3_6_1_3;
  wire [2:0] act3_7_0_1;
  wire [2:0] act3_7_1_1;
  wire [2:0] act3_7_0_2;
  wire [2:0] act3_7_1_2;
  wire [2:0] act3_7_0_3;
  wire [2:0] act3_7_1_3;
  wire [2:0] act3_8_0_1;
  wire [2:0] act3_8_1_1;
  wire [2:0] act3_8_0_2;
  wire [2:0] act3_8_1_2;
  wire [2:0] act3_8_0_3;
  wire [2:0] act3_8_1_3;
  wire [2:0] act3_9_0_1;
  wire [2:0] act3_9_1_1;
  wire [2:0] act3_9_0_2;
  wire [2:0] act3_9_1_2;
  wire [2:0] act3_9_0_3;
  wire [2:0] act3_9_1_3;
  wire [2:0] act3_10_0_1;
  wire [2:0] act3_10_1_1;
  wire [2:0] act3_10_0_2;
  wire [2:0] act3_10_1_2;
  wire [2:0] act3_10_0_3;
  wire [2:0] act3_10_1_3;
  wire [2:0] act3_11_0_1;
  wire [2:0] act3_11_1_1;
  wire [2:0] act3_11_0_2;
  wire [2:0] act3_11_1_2;
  wire [2:0] act3_11_0_3;
  wire [2:0] act3_11_1_3;
  wire [2:0] act3_12_0_1;
  wire [2:0] act3_12_1_1;
  wire [2:0] act3_12_0_2;
  wire [2:0] act3_12_1_2;
  wire [2:0] act3_12_0_3;
  wire [2:0] act3_12_1_3;
  wire [2:0] act3_13_0_1;
  wire [2:0] act3_13_1_1;
  wire [2:0] act3_13_0_2;
  wire [2:0] act3_13_1_2;
  wire [2:0] act3_13_0_3;
  wire [2:0] act3_13_1_3;
  wire [2:0] act3_14_0_1;
  wire [2:0] act3_14_1_1;
  wire [2:0] act3_14_0_2;
  wire [2:0] act3_14_1_2;
  wire [2:0] act3_14_0_3;
  wire [2:0] act3_14_1_3;
  wire [2:0] act3_15_0_1;
  wire [2:0] act3_15_1_1;
  wire [2:0] act3_15_0_2;
  wire [2:0] act3_15_1_2;
  wire [2:0] act3_15_0_3;
  wire [2:0] act3_15_1_3;
  wire [2:0] act4_0_0_1;
  wire [2:0] act4_0_1_1;
  wire [2:0] act4_0_0_2;
  wire [2:0] act4_0_1_2;
  wire [2:0] act4_0_0_3;
  wire [2:0] act4_0_1_3;
  wire [2:0] act4_1_0_1;
  wire [2:0] act4_1_1_1;
  wire [2:0] act4_1_0_2;
  wire [2:0] act4_1_1_2;
  wire [2:0] act4_1_0_3;
  wire [2:0] act4_1_1_3;
  wire [2:0] act4_2_0_1;
  wire [2:0] act4_2_1_1;
  wire [2:0] act4_2_0_2;
  wire [2:0] act4_2_1_2;
  wire [2:0] act4_2_0_3;
  wire [2:0] act4_2_1_3;
  wire [2:0] act4_3_0_1;
  wire [2:0] act4_3_1_1;
  wire [2:0] act4_3_0_2;
  wire [2:0] act4_3_1_2;
  wire [2:0] act4_3_0_3;
  wire [2:0] act4_3_1_3;
  wire [2:0] act4_4_0_1;
  wire [2:0] act4_4_1_1;
  wire [2:0] act4_4_0_2;
  wire [2:0] act4_4_1_2;
  wire [2:0] act4_4_0_3;
  wire [2:0] act4_4_1_3;
  wire [2:0] act4_5_0_1;
  wire [2:0] act4_5_1_1;
  wire [2:0] act4_5_0_2;
  wire [2:0] act4_5_1_2;
  wire [2:0] act4_5_0_3;
  wire [2:0] act4_5_1_3;
  wire [2:0] act4_6_0_1;
  wire [2:0] act4_6_1_1;
  wire [2:0] act4_6_0_2;
  wire [2:0] act4_6_1_2;
  wire [2:0] act4_6_0_3;
  wire [2:0] act4_6_1_3;
  wire [2:0] act4_7_0_1;
  wire [2:0] act4_7_1_1;
  wire [2:0] act4_7_0_2;
  wire [2:0] act4_7_1_2;
  wire [2:0] act4_7_0_3;
  wire [2:0] act4_7_1_3;
  wire [2:0] act4_8_0_1;
  wire [2:0] act4_8_1_1;
  wire [2:0] act4_8_0_2;
  wire [2:0] act4_8_1_2;
  wire [2:0] act4_8_0_3;
  wire [2:0] act4_8_1_3;
  wire [2:0] act4_9_0_1;
  wire [2:0] act4_9_1_1;
  wire [2:0] act4_9_0_2;
  wire [2:0] act4_9_1_2;
  wire [2:0] act4_9_0_3;
  wire [2:0] act4_9_1_3;
  wire [2:0] act4_10_0_1;
  wire [2:0] act4_10_1_1;
  wire [2:0] act4_10_0_2;
  wire [2:0] act4_10_1_2;
  wire [2:0] act4_10_0_3;
  wire [2:0] act4_10_1_3;
  wire [2:0] act4_11_0_1;
  wire [2:0] act4_11_1_1;
  wire [2:0] act4_11_0_2;
  wire [2:0] act4_11_1_2;
  wire [2:0] act4_11_0_3;
  wire [2:0] act4_11_1_3;
  wire [2:0] act4_12_0_1;
  wire [2:0] act4_12_1_1;
  wire [2:0] act4_12_0_2;
  wire [2:0] act4_12_1_2;
  wire [2:0] act4_12_0_3;
  wire [2:0] act4_12_1_3;
  wire [2:0] act4_13_0_1;
  wire [2:0] act4_13_1_1;
  wire [2:0] act4_13_0_2;
  wire [2:0] act4_13_1_2;
  wire [2:0] act4_13_0_3;
  wire [2:0] act4_13_1_3;
  wire [2:0] act4_14_0_1;
  wire [2:0] act4_14_1_1;
  wire [2:0] act4_14_0_2;
  wire [2:0] act4_14_1_2;
  wire [2:0] act4_14_0_3;
  wire [2:0] act4_14_1_3;
  wire [2:0] act4_15_0_1;
  wire [2:0] act4_15_1_1;
  wire [2:0] act4_15_0_2;
  wire [2:0] act4_15_1_2;
  wire [2:0] act4_15_0_3;
  wire [2:0] act4_15_1_3;
  wire [2:0] act5_0_0_1;
  wire [2:0] act5_0_1_1;
  wire [2:0] act5_0_0_2;
  wire [2:0] act5_0_1_2;
  wire [2:0] act5_0_0_3;
  wire [2:0] act5_0_1_3;
  wire [2:0] act5_1_0_1;
  wire [2:0] act5_1_1_1;
  wire [2:0] act5_1_0_2;
  wire [2:0] act5_1_1_2;
  wire [2:0] act5_1_0_3;
  wire [2:0] act5_1_1_3;
  wire [2:0] act5_2_0_1;
  wire [2:0] act5_2_1_1;
  wire [2:0] act5_2_0_2;
  wire [2:0] act5_2_1_2;
  wire [2:0] act5_2_0_3;
  wire [2:0] act5_2_1_3;
  wire [2:0] act5_3_0_1;
  wire [2:0] act5_3_1_1;
  wire [2:0] act5_3_0_2;
  wire [2:0] act5_3_1_2;
  wire [2:0] act5_3_0_3;
  wire [2:0] act5_3_1_3;
  wire [2:0] act5_4_0_1;
  wire [2:0] act5_4_1_1;
  wire [2:0] act5_4_0_2;
  wire [2:0] act5_4_1_2;
  wire [2:0] act5_4_0_3;
  wire [2:0] act5_4_1_3;
  wire [2:0] act5_5_0_1;
  wire [2:0] act5_5_1_1;
  wire [2:0] act5_5_0_2;
  wire [2:0] act5_5_1_2;
  wire [2:0] act5_5_0_3;
  wire [2:0] act5_5_1_3;
  wire [2:0] act5_6_0_1;
  wire [2:0] act5_6_1_1;
  wire [2:0] act5_6_0_2;
  wire [2:0] act5_6_1_2;
  wire [2:0] act5_6_0_3;
  wire [2:0] act5_6_1_3;
  wire [2:0] act5_7_0_1;
  wire [2:0] act5_7_1_1;
  wire [2:0] act5_7_0_2;
  wire [2:0] act5_7_1_2;
  wire [2:0] act5_7_0_3;
  wire [2:0] act5_7_1_3;
  wire [2:0] act5_8_0_1;
  wire [2:0] act5_8_1_1;
  wire [2:0] act5_8_0_2;
  wire [2:0] act5_8_1_2;
  wire [2:0] act5_8_0_3;
  wire [2:0] act5_8_1_3;
  wire [2:0] act5_9_0_1;
  wire [2:0] act5_9_1_1;
  wire [2:0] act5_9_0_2;
  wire [2:0] act5_9_1_2;
  wire [2:0] act5_9_0_3;
  wire [2:0] act5_9_1_3;
  wire [2:0] act5_10_0_1;
  wire [2:0] act5_10_1_1;
  wire [2:0] act5_10_0_2;
  wire [2:0] act5_10_1_2;
  wire [2:0] act5_10_0_3;
  wire [2:0] act5_10_1_3;
  wire [2:0] act5_11_0_1;
  wire [2:0] act5_11_1_1;
  wire [2:0] act5_11_0_2;
  wire [2:0] act5_11_1_2;
  wire [2:0] act5_11_0_3;
  wire [2:0] act5_11_1_3;
  wire [2:0] act5_12_0_1;
  wire [2:0] act5_12_1_1;
  wire [2:0] act5_12_0_2;
  wire [2:0] act5_12_1_2;
  wire [2:0] act5_12_0_3;
  wire [2:0] act5_12_1_3;
  wire [2:0] act5_13_0_1;
  wire [2:0] act5_13_1_1;
  wire [2:0] act5_13_0_2;
  wire [2:0] act5_13_1_2;
  wire [2:0] act5_13_0_3;
  wire [2:0] act5_13_1_3;
  wire [2:0] act5_14_0_1;
  wire [2:0] act5_14_1_1;
  wire [2:0] act5_14_0_2;
  wire [2:0] act5_14_1_2;
  wire [2:0] act5_14_0_3;
  wire [2:0] act5_14_1_3;
  wire [2:0] act5_15_0_1;
  wire [2:0] act5_15_1_1;
  wire [2:0] act5_15_0_2;
  wire [2:0] act5_15_1_2;
  wire [2:0] act5_15_0_3;
  wire [2:0] act5_15_1_3;
  wire [2:0] act6_0_0_1;
  wire [2:0] act6_0_1_1;
  wire [2:0] act6_0_0_2;
  wire [2:0] act6_0_1_2;
  wire [2:0] act6_0_0_3;
  wire [2:0] act6_0_1_3;
  wire [2:0] act6_1_0_1;
  wire [2:0] act6_1_1_1;
  wire [2:0] act6_1_0_2;
  wire [2:0] act6_1_1_2;
  wire [2:0] act6_1_0_3;
  wire [2:0] act6_1_1_3;
  wire [2:0] act6_2_0_1;
  wire [2:0] act6_2_1_1;
  wire [2:0] act6_2_0_2;
  wire [2:0] act6_2_1_2;
  wire [2:0] act6_2_0_3;
  wire [2:0] act6_2_1_3;
  wire [2:0] act6_3_0_1;
  wire [2:0] act6_3_1_1;
  wire [2:0] act6_3_0_2;
  wire [2:0] act6_3_1_2;
  wire [2:0] act6_3_0_3;
  wire [2:0] act6_3_1_3;
  wire [2:0] act6_4_0_1;
  wire [2:0] act6_4_1_1;
  wire [2:0] act6_4_0_2;
  wire [2:0] act6_4_1_2;
  wire [2:0] act6_4_0_3;
  wire [2:0] act6_4_1_3;
  wire [2:0] act6_5_0_1;
  wire [2:0] act6_5_1_1;
  wire [2:0] act6_5_0_2;
  wire [2:0] act6_5_1_2;
  wire [2:0] act6_5_0_3;
  wire [2:0] act6_5_1_3;
  wire [2:0] act6_6_0_1;
  wire [2:0] act6_6_1_1;
  wire [2:0] act6_6_0_2;
  wire [2:0] act6_6_1_2;
  wire [2:0] act6_6_0_3;
  wire [2:0] act6_6_1_3;
  wire [2:0] act6_7_0_1;
  wire [2:0] act6_7_1_1;
  wire [2:0] act6_7_0_2;
  wire [2:0] act6_7_1_2;
  wire [2:0] act6_7_0_3;
  wire [2:0] act6_7_1_3;
  wire [2:0] act6_8_0_1;
  wire [2:0] act6_8_1_1;
  wire [2:0] act6_8_0_2;
  wire [2:0] act6_8_1_2;
  wire [2:0] act6_8_0_3;
  wire [2:0] act6_8_1_3;
  wire [2:0] act6_9_0_1;
  wire [2:0] act6_9_1_1;
  wire [2:0] act6_9_0_2;
  wire [2:0] act6_9_1_2;
  wire [2:0] act6_9_0_3;
  wire [2:0] act6_9_1_3;
  wire [2:0] act6_10_0_1;
  wire [2:0] act6_10_1_1;
  wire [2:0] act6_10_0_2;
  wire [2:0] act6_10_1_2;
  wire [2:0] act6_10_0_3;
  wire [2:0] act6_10_1_3;
  wire [2:0] act6_11_0_1;
  wire [2:0] act6_11_1_1;
  wire [2:0] act6_11_0_2;
  wire [2:0] act6_11_1_2;
  wire [2:0] act6_11_0_3;
  wire [2:0] act6_11_1_3;
  wire [2:0] act6_12_0_1;
  wire [2:0] act6_12_1_1;
  wire [2:0] act6_12_0_2;
  wire [2:0] act6_12_1_2;
  wire [2:0] act6_12_0_3;
  wire [2:0] act6_12_1_3;
  wire [2:0] act6_13_0_1;
  wire [2:0] act6_13_1_1;
  wire [2:0] act6_13_0_2;
  wire [2:0] act6_13_1_2;
  wire [2:0] act6_13_0_3;
  wire [2:0] act6_13_1_3;
  wire [2:0] act6_14_0_1;
  wire [2:0] act6_14_1_1;
  wire [2:0] act6_14_0_2;
  wire [2:0] act6_14_1_2;
  wire [2:0] act6_14_0_3;
  wire [2:0] act6_14_1_3;
  wire [2:0] act6_15_0_1;
  wire [2:0] act6_15_1_1;
  wire [2:0] act6_15_0_2;
  wire [2:0] act6_15_1_2;
  wire [2:0] act6_15_0_3;
  wire [2:0] act6_15_1_3;
  wire [2:0] act7_0_0_1;
  wire [2:0] act7_0_1_1;
  wire [2:0] act7_0_0_2;
  wire [2:0] act7_0_1_2;
  wire [2:0] act7_0_0_3;
  wire [2:0] act7_0_1_3;
  wire [2:0] act7_1_0_1;
  wire [2:0] act7_1_1_1;
  wire [2:0] act7_1_0_2;
  wire [2:0] act7_1_1_2;
  wire [2:0] act7_1_0_3;
  wire [2:0] act7_1_1_3;
  wire [2:0] act7_2_0_1;
  wire [2:0] act7_2_1_1;
  wire [2:0] act7_2_0_2;
  wire [2:0] act7_2_1_2;
  wire [2:0] act7_2_0_3;
  wire [2:0] act7_2_1_3;
  wire [2:0] act7_3_0_1;
  wire [2:0] act7_3_1_1;
  wire [2:0] act7_3_0_2;
  wire [2:0] act7_3_1_2;
  wire [2:0] act7_3_0_3;
  wire [2:0] act7_3_1_3;
  wire [2:0] act7_4_0_1;
  wire [2:0] act7_4_1_1;
  wire [2:0] act7_4_0_2;
  wire [2:0] act7_4_1_2;
  wire [2:0] act7_4_0_3;
  wire [2:0] act7_4_1_3;
  wire [2:0] act7_5_0_1;
  wire [2:0] act7_5_1_1;
  wire [2:0] act7_5_0_2;
  wire [2:0] act7_5_1_2;
  wire [2:0] act7_5_0_3;
  wire [2:0] act7_5_1_3;
  wire [2:0] act7_6_0_1;
  wire [2:0] act7_6_1_1;
  wire [2:0] act7_6_0_2;
  wire [2:0] act7_6_1_2;
  wire [2:0] act7_6_0_3;
  wire [2:0] act7_6_1_3;
  wire [2:0] act7_7_0_1;
  wire [2:0] act7_7_1_1;
  wire [2:0] act7_7_0_2;
  wire [2:0] act7_7_1_2;
  wire [2:0] act7_7_0_3;
  wire [2:0] act7_7_1_3;
  wire [2:0] act7_8_0_1;
  wire [2:0] act7_8_1_1;
  wire [2:0] act7_8_0_2;
  wire [2:0] act7_8_1_2;
  wire [2:0] act7_8_0_3;
  wire [2:0] act7_8_1_3;
  wire [2:0] act7_9_0_1;
  wire [2:0] act7_9_1_1;
  wire [2:0] act7_9_0_2;
  wire [2:0] act7_9_1_2;
  wire [2:0] act7_9_0_3;
  wire [2:0] act7_9_1_3;
  wire [2:0] act7_10_0_1;
  wire [2:0] act7_10_1_1;
  wire [2:0] act7_10_0_2;
  wire [2:0] act7_10_1_2;
  wire [2:0] act7_10_0_3;
  wire [2:0] act7_10_1_3;
  wire [2:0] act7_11_0_1;
  wire [2:0] act7_11_1_1;
  wire [2:0] act7_11_0_2;
  wire [2:0] act7_11_1_2;
  wire [2:0] act7_11_0_3;
  wire [2:0] act7_11_1_3;
  wire [2:0] act7_12_0_1;
  wire [2:0] act7_12_1_1;
  wire [2:0] act7_12_0_2;
  wire [2:0] act7_12_1_2;
  wire [2:0] act7_12_0_3;
  wire [2:0] act7_12_1_3;
  wire [2:0] act7_13_0_1;
  wire [2:0] act7_13_1_1;
  wire [2:0] act7_13_0_2;
  wire [2:0] act7_13_1_2;
  wire [2:0] act7_13_0_3;
  wire [2:0] act7_13_1_3;
  wire [2:0] act7_14_0_1;
  wire [2:0] act7_14_1_1;
  wire [2:0] act7_14_0_2;
  wire [2:0] act7_14_1_2;
  wire [2:0] act7_14_0_3;
  wire [2:0] act7_14_1_3;
  wire [2:0] act7_15_0_1;
  wire [2:0] act7_15_1_1;
  wire [2:0] act7_15_0_2;
  wire [2:0] act7_15_1_2;
  wire [2:0] act7_15_0_3;
  wire [2:0] act7_15_1_3;

  // Layer 1, act0
  wire [2:0] act0_0_0;
  wire [2:0] act0_1_0;
  wire [2:0] act0_0_1;
  wire [2:0] act0_1_1;
  wire [2:0] act0_0_2;
  wire [2:0] act0_1_2;
  wire [2:0] act0_0_3;
  wire [2:0] act0_1_3;
  wire [2:0] act0_0_4;
  wire [2:0] act0_1_4;
  wire [2:0] act0_0_5;
  wire [2:0] act0_1_5;
  wire [2:0] act0_0_6;
  wire [2:0] act0_1_6;
  wire [2:0] act0_0_7;
  wire [2:0] act0_1_7;
  wire [2:0] act0_0_8;
  wire [2:0] act0_1_8;
  wire [2:0] act0_0_9;
  wire [2:0] act0_1_9;
  wire [2:0] act0_0_10;
  wire [2:0] act0_1_10;
  wire [2:0] act0_0_11;
  wire [2:0] act0_1_11;
  wire [2:0] act0_0_12;
  wire [2:0] act0_1_12;
  wire [2:0] act0_0_13;
  wire [2:0] act0_1_13;
  wire [2:0] act0_0_14;
  wire [2:0] act0_1_14;
  wire [2:0] act0_0_15;
  wire [2:0] act0_1_15;

  // Layer 1, act1
  wire [2:0] act1_0_0;
  wire [2:0] act1_1_0;
  wire [2:0] act1_0_1;
  wire [2:0] act1_1_1;
  wire [2:0] act1_0_2;
  wire [2:0] act1_1_2;
  wire [2:0] act1_0_3;
  wire [2:0] act1_1_3;
  wire [2:0] act1_0_4;
  wire [2:0] act1_1_4;
  wire [2:0] act1_0_5;
  wire [2:0] act1_1_5;
  wire [2:0] act1_0_6;
  wire [2:0] act1_1_6;
  wire [2:0] act1_0_7;
  wire [2:0] act1_1_7;
  wire [2:0] act1_0_8;
  wire [2:0] act1_1_8;
  wire [2:0] act1_0_9;
  wire [2:0] act1_1_9;
  wire [2:0] act1_0_10;
  wire [2:0] act1_1_10;
  wire [2:0] act1_0_11;
  wire [2:0] act1_1_11;
  wire [2:0] act1_0_12;
  wire [2:0] act1_1_12;
  wire [2:0] act1_0_13;
  wire [2:0] act1_1_13;
  wire [2:0] act1_0_14;
  wire [2:0] act1_1_14;
  wire [2:0] act1_0_15;
  wire [2:0] act1_1_15;

  // Layer 1, act2
  wire [2:0] act2_0_0;
  wire [2:0] act2_1_0;
  wire [2:0] act2_0_1;
  wire [2:0] act2_1_1;
  wire [2:0] act2_0_2;
  wire [2:0] act2_1_2;
  wire [2:0] act2_0_3;
  wire [2:0] act2_1_3;
  wire [2:0] act2_0_4;
  wire [2:0] act2_1_4;
  wire [2:0] act2_0_5;
  wire [2:0] act2_1_5;
  wire [2:0] act2_0_6;
  wire [2:0] act2_1_6;
  wire [2:0] act2_0_7;
  wire [2:0] act2_1_7;
  wire [2:0] act2_0_8;
  wire [2:0] act2_1_8;
  wire [2:0] act2_0_9;
  wire [2:0] act2_1_9;
  wire [2:0] act2_0_10;
  wire [2:0] act2_1_10;
  wire [2:0] act2_0_11;
  wire [2:0] act2_1_11;
  wire [2:0] act2_0_12;
  wire [2:0] act2_1_12;
  wire [2:0] act2_0_13;
  wire [2:0] act2_1_13;
  wire [2:0] act2_0_14;
  wire [2:0] act2_1_14;
  wire [2:0] act2_0_15;
  wire [2:0] act2_1_15;

  // Layer 1, act3
  wire [2:0] act3_0_0;
  wire [2:0] act3_1_0;
  wire [2:0] act3_0_1;
  wire [2:0] act3_1_1;
  wire [2:0] act3_0_2;
  wire [2:0] act3_1_2;
  wire [2:0] act3_0_3;
  wire [2:0] act3_1_3;
  wire [2:0] act3_0_4;
  wire [2:0] act3_1_4;
  wire [2:0] act3_0_5;
  wire [2:0] act3_1_5;
  wire [2:0] act3_0_6;
  wire [2:0] act3_1_6;
  wire [2:0] act3_0_7;
  wire [2:0] act3_1_7;
  wire [2:0] act3_0_8;
  wire [2:0] act3_1_8;
  wire [2:0] act3_0_9;
  wire [2:0] act3_1_9;
  wire [2:0] act3_0_10;
  wire [2:0] act3_1_10;
  wire [2:0] act3_0_11;
  wire [2:0] act3_1_11;
  wire [2:0] act3_0_12;
  wire [2:0] act3_1_12;
  wire [2:0] act3_0_13;
  wire [2:0] act3_1_13;
  wire [2:0] act3_0_14;
  wire [2:0] act3_1_14;
  wire [2:0] act3_0_15;
  wire [2:0] act3_1_15;

  // Layer 1, act4
  wire [2:0] act4_0_0;
  wire [2:0] act4_1_0;
  wire [2:0] act4_0_1;
  wire [2:0] act4_1_1;
  wire [2:0] act4_0_2;
  wire [2:0] act4_1_2;
  wire [2:0] act4_0_3;
  wire [2:0] act4_1_3;
  wire [2:0] act4_0_4;
  wire [2:0] act4_1_4;
  wire [2:0] act4_0_5;
  wire [2:0] act4_1_5;
  wire [2:0] act4_0_6;
  wire [2:0] act4_1_6;
  wire [2:0] act4_0_7;
  wire [2:0] act4_1_7;
  wire [2:0] act4_0_8;
  wire [2:0] act4_1_8;
  wire [2:0] act4_0_9;
  wire [2:0] act4_1_9;
  wire [2:0] act4_0_10;
  wire [2:0] act4_1_10;
  wire [2:0] act4_0_11;
  wire [2:0] act4_1_11;
  wire [2:0] act4_0_12;
  wire [2:0] act4_1_12;
  wire [2:0] act4_0_13;
  wire [2:0] act4_1_13;
  wire [2:0] act4_0_14;
  wire [2:0] act4_1_14;
  wire [2:0] act4_0_15;
  wire [2:0] act4_1_15;

  // Layer 1, act5
  wire [2:0] act5_0_0;
  wire [2:0] act5_1_0;
  wire [2:0] act5_0_1;
  wire [2:0] act5_1_1;
  wire [2:0] act5_0_2;
  wire [2:0] act5_1_2;
  wire [2:0] act5_0_3;
  wire [2:0] act5_1_3;
  wire [2:0] act5_0_4;
  wire [2:0] act5_1_4;
  wire [2:0] act5_0_5;
  wire [2:0] act5_1_5;
  wire [2:0] act5_0_6;
  wire [2:0] act5_1_6;
  wire [2:0] act5_0_7;
  wire [2:0] act5_1_7;
  wire [2:0] act5_0_8;
  wire [2:0] act5_1_8;
  wire [2:0] act5_0_9;
  wire [2:0] act5_1_9;
  wire [2:0] act5_0_10;
  wire [2:0] act5_1_10;
  wire [2:0] act5_0_11;
  wire [2:0] act5_1_11;
  wire [2:0] act5_0_12;
  wire [2:0] act5_1_12;
  wire [2:0] act5_0_13;
  wire [2:0] act5_1_13;
  wire [2:0] act5_0_14;
  wire [2:0] act5_1_14;
  wire [2:0] act5_0_15;
  wire [2:0] act5_1_15;

  // Layer 1, act6
  wire [2:0] act6_0_0;
  wire [2:0] act6_1_0;
  wire [2:0] act6_0_1;
  wire [2:0] act6_1_1;
  wire [2:0] act6_0_2;
  wire [2:0] act6_1_2;
  wire [2:0] act6_0_3;
  wire [2:0] act6_1_3;
  wire [2:0] act6_0_4;
  wire [2:0] act6_1_4;
  wire [2:0] act6_0_5;
  wire [2:0] act6_1_5;
  wire [2:0] act6_0_6;
  wire [2:0] act6_1_6;
  wire [2:0] act6_0_7;
  wire [2:0] act6_1_7;
  wire [2:0] act6_0_8;
  wire [2:0] act6_1_8;
  wire [2:0] act6_0_9;
  wire [2:0] act6_1_9;
  wire [2:0] act6_0_10;
  wire [2:0] act6_1_10;
  wire [2:0] act6_0_11;
  wire [2:0] act6_1_11;
  wire [2:0] act6_0_12;
  wire [2:0] act6_1_12;
  wire [2:0] act6_0_13;
  wire [2:0] act6_1_13;
  wire [2:0] act6_0_14;
  wire [2:0] act6_1_14;
  wire [2:0] act6_0_15;
  wire [2:0] act6_1_15;

  // Layer 1, act7
  wire [2:0] act7_0_0;
  wire [2:0] act7_1_0;
  wire [2:0] act7_0_1;
  wire [2:0] act7_1_1;
  wire [2:0] act7_0_2;
  wire [2:0] act7_1_2;
  wire [2:0] act7_0_3;
  wire [2:0] act7_1_3;
  wire [2:0] act7_0_4;
  wire [2:0] act7_1_4;
  wire [2:0] act7_0_5;
  wire [2:0] act7_1_5;
  wire [2:0] act7_0_6;
  wire [2:0] act7_1_6;
  wire [2:0] act7_0_7;
  wire [2:0] act7_1_7;
  wire [2:0] act7_0_8;
  wire [2:0] act7_1_8;
  wire [2:0] act7_0_9;
  wire [2:0] act7_1_9;
  wire [2:0] act7_0_10;
  wire [2:0] act7_1_10;
  wire [2:0] act7_0_11;
  wire [2:0] act7_1_11;
  wire [2:0] act7_0_12;
  wire [2:0] act7_1_12;
  wire [2:0] act7_0_13;
  wire [2:0] act7_1_13;
  wire [2:0] act7_0_14;
  wire [2:0] act7_1_14;
  wire [2:0] act7_0_15;
  wire [2:0] act7_1_15;

  wire [15:0] w1_0;
  wire [15:0] w1_1;
  wire [15:0] w2_0;
  wire [15:0] w2_1;
  wire [15:0] w3_0;
  wire [15:0] w3_1;
  wire [15:0] w4_0;
  wire [15:0] w4_1;
  wire [15:0] w5_0;
  wire [15:0] w5_1;
  wire [15:0] w6_0;
  wire [15:0] w6_1;
  wire [15:0] w7_0;
  wire [15:0] w7_1;
  wire [15:0] w8_0;
  wire [15:0] w8_1;

  // Muxes for w1_0
  mux_3 m00_0 (.a(w1_0_2[0]), .b(w1_0_3[0]), .c(w1_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w1_0[0]));
  mux_3 m00_1 (.a(w1_0_2[1]), .b(w1_0_3[1]), .c(w1_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w1_0[1]));
  mux_3 m00_2 (.a(w1_0_2[2]), .b(w1_0_3[2]), .c(w1_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w1_0[2]));
  mux_3 m00_3 (.a(w1_0_2[3]), .b(w1_0_3[3]), .c(w1_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w1_0[3]));
  mux_3 m00_4 (.a(w1_0_2[4]), .b(w1_0_3[4]), .c(w1_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w1_0[4]));
  mux_3 m00_5 (.a(w1_0_2[5]), .b(w1_0_3[5]), .c(w1_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w1_0[5]));
  mux_3 m00_6 (.a(w1_0_2[6]), .b(w1_0_3[6]), .c(w1_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w1_0[6]));
  mux_3 m00_7 (.a(w1_0_2[7]), .b(w1_0_3[7]), .c(w1_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w1_0[7]));
  mux_3 m00_8 (.a(w1_0_2[8]), .b(w1_0_3[8]), .c(w1_0_4[8]), .s0(s[0]), .s1(s[1]), .y(w1_0[8]));
  mux_3 m00_9 (.a(w1_0_2[9]), .b(w1_0_3[9]), .c(w1_0_4[9]), .s0(s[0]), .s1(s[1]), .y(w1_0[9]));
  mux_3 m00_10 (.a(w1_0_2[10]), .b(w1_0_3[10]), .c(w1_0_4[10]), .s0(s[0]), .s1(s[1]), .y(w1_0[10]));
  mux_3 m00_11 (.a(w1_0_2[11]), .b(w1_0_3[11]), .c(w1_0_4[11]), .s0(s[0]), .s1(s[1]), .y(w1_0[11]));
  mux_3 m00_12 (.a(w1_0_2[12]), .b(w1_0_3[12]), .c(w1_0_4[12]), .s0(s[0]), .s1(s[1]), .y(w1_0[12]));
  mux_3 m00_13 (.a(w1_0_2[13]), .b(w1_0_3[13]), .c(w1_0_4[13]), .s0(s[0]), .s1(s[1]), .y(w1_0[13]));
  mux_3 m00_14 (.a(w1_0_2[14]), .b(w1_0_3[14]), .c(w1_0_4[14]), .s0(s[0]), .s1(s[1]), .y(w1_0[14]));
  mux_3 m00_15 (.a(w1_0_2[15]), .b(w1_0_3[15]), .c(w1_0_4[15]), .s0(s[0]), .s1(s[1]), .y(w1_0[15]));

  // Muxes for w2_0
  mux_3 m10_0 (.a(w2_0_2[0]), .b(w2_0_3[0]), .c(w2_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w2_0[0]));
  mux_3 m10_1 (.a(w2_0_2[1]), .b(w2_0_3[1]), .c(w2_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w2_0[1]));
  mux_3 m10_2 (.a(w2_0_2[2]), .b(w2_0_3[2]), .c(w2_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w2_0[2]));
  mux_3 m10_3 (.a(w2_0_2[3]), .b(w2_0_3[3]), .c(w2_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w2_0[3]));
  mux_3 m10_4 (.a(w2_0_2[4]), .b(w2_0_3[4]), .c(w2_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w2_0[4]));
  mux_3 m10_5 (.a(w2_0_2[5]), .b(w2_0_3[5]), .c(w2_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w2_0[5]));
  mux_3 m10_6 (.a(w2_0_2[6]), .b(w2_0_3[6]), .c(w2_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w2_0[6]));
  mux_3 m10_7 (.a(w2_0_2[7]), .b(w2_0_3[7]), .c(w2_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w2_0[7]));
  mux_3 m10_8 (.a(w2_0_2[8]), .b(w2_0_3[8]), .c(w2_0_4[8]), .s0(s[0]), .s1(s[1]), .y(w2_0[8]));
  mux_3 m10_9 (.a(w2_0_2[9]), .b(w2_0_3[9]), .c(w2_0_4[9]), .s0(s[0]), .s1(s[1]), .y(w2_0[9]));
  mux_3 m10_10 (.a(w2_0_2[10]), .b(w2_0_3[10]), .c(w2_0_4[10]), .s0(s[0]), .s1(s[1]), .y(w2_0[10]));
  mux_3 m10_11 (.a(w2_0_2[11]), .b(w2_0_3[11]), .c(w2_0_4[11]), .s0(s[0]), .s1(s[1]), .y(w2_0[11]));
  mux_3 m10_12 (.a(w2_0_2[12]), .b(w2_0_3[12]), .c(w2_0_4[12]), .s0(s[0]), .s1(s[1]), .y(w2_0[12]));
  mux_3 m10_13 (.a(w2_0_2[13]), .b(w2_0_3[13]), .c(w2_0_4[13]), .s0(s[0]), .s1(s[1]), .y(w2_0[13]));
  mux_3 m10_14 (.a(w2_0_2[14]), .b(w2_0_3[14]), .c(w2_0_4[14]), .s0(s[0]), .s1(s[1]), .y(w2_0[14]));
  mux_3 m10_15 (.a(w2_0_2[15]), .b(w2_0_3[15]), .c(w2_0_4[15]), .s0(s[0]), .s1(s[1]), .y(w2_0[15]));

  // Muxes for w3_0
  mux_3 m20_0 (.a(w3_0_2[0]), .b(w3_0_3[0]), .c(w3_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w3_0[0]));
  mux_3 m20_1 (.a(w3_0_2[1]), .b(w3_0_3[1]), .c(w3_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w3_0[1]));
  mux_3 m20_2 (.a(w3_0_2[2]), .b(w3_0_3[2]), .c(w3_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w3_0[2]));
  mux_3 m20_3 (.a(w3_0_2[3]), .b(w3_0_3[3]), .c(w3_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w3_0[3]));
  mux_3 m20_4 (.a(w3_0_2[4]), .b(w3_0_3[4]), .c(w3_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w3_0[4]));
  mux_3 m20_5 (.a(w3_0_2[5]), .b(w3_0_3[5]), .c(w3_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w3_0[5]));
  mux_3 m20_6 (.a(w3_0_2[6]), .b(w3_0_3[6]), .c(w3_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w3_0[6]));
  mux_3 m20_7 (.a(w3_0_2[7]), .b(w3_0_3[7]), .c(w3_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w3_0[7]));
  mux_3 m20_8 (.a(w3_0_2[8]), .b(w3_0_3[8]), .c(w3_0_4[8]), .s0(s[0]), .s1(s[1]), .y(w3_0[8]));
  mux_3 m20_9 (.a(w3_0_2[9]), .b(w3_0_3[9]), .c(w3_0_4[9]), .s0(s[0]), .s1(s[1]), .y(w3_0[9]));
  mux_3 m20_10 (.a(w3_0_2[10]), .b(w3_0_3[10]), .c(w3_0_4[10]), .s0(s[0]), .s1(s[1]), .y(w3_0[10]));
  mux_3 m20_11 (.a(w3_0_2[11]), .b(w3_0_3[11]), .c(w3_0_4[11]), .s0(s[0]), .s1(s[1]), .y(w3_0[11]));
  mux_3 m20_12 (.a(w3_0_2[12]), .b(w3_0_3[12]), .c(w3_0_4[12]), .s0(s[0]), .s1(s[1]), .y(w3_0[12]));
  mux_3 m20_13 (.a(w3_0_2[13]), .b(w3_0_3[13]), .c(w3_0_4[13]), .s0(s[0]), .s1(s[1]), .y(w3_0[13]));
  mux_3 m20_14 (.a(w3_0_2[14]), .b(w3_0_3[14]), .c(w3_0_4[14]), .s0(s[0]), .s1(s[1]), .y(w3_0[14]));
  mux_3 m20_15 (.a(w3_0_2[15]), .b(w3_0_3[15]), .c(w3_0_4[15]), .s0(s[0]), .s1(s[1]), .y(w3_0[15]));

  // Muxes for w4_0
  mux_3 m30_0 (.a(w4_0_2[0]), .b(w4_0_3[0]), .c(w4_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w4_0[0]));
  mux_3 m30_1 (.a(w4_0_2[1]), .b(w4_0_3[1]), .c(w4_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w4_0[1]));
  mux_3 m30_2 (.a(w4_0_2[2]), .b(w4_0_3[2]), .c(w4_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w4_0[2]));
  mux_3 m30_3 (.a(w4_0_2[3]), .b(w4_0_3[3]), .c(w4_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w4_0[3]));
  mux_3 m30_4 (.a(w4_0_2[4]), .b(w4_0_3[4]), .c(w4_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w4_0[4]));
  mux_3 m30_5 (.a(w4_0_2[5]), .b(w4_0_3[5]), .c(w4_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w4_0[5]));
  mux_3 m30_6 (.a(w4_0_2[6]), .b(w4_0_3[6]), .c(w4_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w4_0[6]));
  mux_3 m30_7 (.a(w4_0_2[7]), .b(w4_0_3[7]), .c(w4_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w4_0[7]));
  mux_3 m30_8 (.a(w4_0_2[8]), .b(w4_0_3[8]), .c(w4_0_4[8]), .s0(s[0]), .s1(s[1]), .y(w4_0[8]));
  mux_3 m30_9 (.a(w4_0_2[9]), .b(w4_0_3[9]), .c(w4_0_4[9]), .s0(s[0]), .s1(s[1]), .y(w4_0[9]));
  mux_3 m30_10 (.a(w4_0_2[10]), .b(w4_0_3[10]), .c(w4_0_4[10]), .s0(s[0]), .s1(s[1]), .y(w4_0[10]));
  mux_3 m30_11 (.a(w4_0_2[11]), .b(w4_0_3[11]), .c(w4_0_4[11]), .s0(s[0]), .s1(s[1]), .y(w4_0[11]));
  mux_3 m30_12 (.a(w4_0_2[12]), .b(w4_0_3[12]), .c(w4_0_4[12]), .s0(s[0]), .s1(s[1]), .y(w4_0[12]));
  mux_3 m30_13 (.a(w4_0_2[13]), .b(w4_0_3[13]), .c(w4_0_4[13]), .s0(s[0]), .s1(s[1]), .y(w4_0[13]));
  mux_3 m30_14 (.a(w4_0_2[14]), .b(w4_0_3[14]), .c(w4_0_4[14]), .s0(s[0]), .s1(s[1]), .y(w4_0[14]));
  mux_3 m30_15 (.a(w4_0_2[15]), .b(w4_0_3[15]), .c(w4_0_4[15]), .s0(s[0]), .s1(s[1]), .y(w4_0[15]));

  // Muxes for w5_0
  mux_3 m40_0 (.a(w5_0_2[0]), .b(w5_0_3[0]), .c(w5_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w5_0[0]));
  mux_3 m40_1 (.a(w5_0_2[1]), .b(w5_0_3[1]), .c(w5_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w5_0[1]));
  mux_3 m40_2 (.a(w5_0_2[2]), .b(w5_0_3[2]), .c(w5_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w5_0[2]));
  mux_3 m40_3 (.a(w5_0_2[3]), .b(w5_0_3[3]), .c(w5_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w5_0[3]));
  mux_3 m40_4 (.a(w5_0_2[4]), .b(w5_0_3[4]), .c(w5_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w5_0[4]));
  mux_3 m40_5 (.a(w5_0_2[5]), .b(w5_0_3[5]), .c(w5_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w5_0[5]));
  mux_3 m40_6 (.a(w5_0_2[6]), .b(w5_0_3[6]), .c(w5_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w5_0[6]));
  mux_3 m40_7 (.a(w5_0_2[7]), .b(w5_0_3[7]), .c(w5_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w5_0[7]));
  mux_3 m40_8 (.a(w5_0_2[8]), .b(w5_0_3[8]), .c(w5_0_4[8]), .s0(s[0]), .s1(s[1]), .y(w5_0[8]));
  mux_3 m40_9 (.a(w5_0_2[9]), .b(w5_0_3[9]), .c(w5_0_4[9]), .s0(s[0]), .s1(s[1]), .y(w5_0[9]));
  mux_3 m40_10 (.a(w5_0_2[10]), .b(w5_0_3[10]), .c(w5_0_4[10]), .s0(s[0]), .s1(s[1]), .y(w5_0[10]));
  mux_3 m40_11 (.a(w5_0_2[11]), .b(w5_0_3[11]), .c(w5_0_4[11]), .s0(s[0]), .s1(s[1]), .y(w5_0[11]));
  mux_3 m40_12 (.a(w5_0_2[12]), .b(w5_0_3[12]), .c(w5_0_4[12]), .s0(s[0]), .s1(s[1]), .y(w5_0[12]));
  mux_3 m40_13 (.a(w5_0_2[13]), .b(w5_0_3[13]), .c(w5_0_4[13]), .s0(s[0]), .s1(s[1]), .y(w5_0[13]));
  mux_3 m40_14 (.a(w5_0_2[14]), .b(w5_0_3[14]), .c(w5_0_4[14]), .s0(s[0]), .s1(s[1]), .y(w5_0[14]));
  mux_3 m40_15 (.a(w5_0_2[15]), .b(w5_0_3[15]), .c(w5_0_4[15]), .s0(s[0]), .s1(s[1]), .y(w5_0[15]));

  // Muxes for w6_0
  mux_3 m50_0 (.a(w6_0_2[0]), .b(w6_0_3[0]), .c(w6_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w6_0[0]));
  mux_3 m50_1 (.a(w6_0_2[1]), .b(w6_0_3[1]), .c(w6_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w6_0[1]));
  mux_3 m50_2 (.a(w6_0_2[2]), .b(w6_0_3[2]), .c(w6_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w6_0[2]));
  mux_3 m50_3 (.a(w6_0_2[3]), .b(w6_0_3[3]), .c(w6_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w6_0[3]));
  mux_3 m50_4 (.a(w6_0_2[4]), .b(w6_0_3[4]), .c(w6_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w6_0[4]));
  mux_3 m50_5 (.a(w6_0_2[5]), .b(w6_0_3[5]), .c(w6_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w6_0[5]));
  mux_3 m50_6 (.a(w6_0_2[6]), .b(w6_0_3[6]), .c(w6_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w6_0[6]));
  mux_3 m50_7 (.a(w6_0_2[7]), .b(w6_0_3[7]), .c(w6_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w6_0[7]));
  mux_3 m50_8 (.a(w6_0_2[8]), .b(w6_0_3[8]), .c(w6_0_4[8]), .s0(s[0]), .s1(s[1]), .y(w6_0[8]));
  mux_3 m50_9 (.a(w6_0_2[9]), .b(w6_0_3[9]), .c(w6_0_4[9]), .s0(s[0]), .s1(s[1]), .y(w6_0[9]));
  mux_3 m50_10 (.a(w6_0_2[10]), .b(w6_0_3[10]), .c(w6_0_4[10]), .s0(s[0]), .s1(s[1]), .y(w6_0[10]));
  mux_3 m50_11 (.a(w6_0_2[11]), .b(w6_0_3[11]), .c(w6_0_4[11]), .s0(s[0]), .s1(s[1]), .y(w6_0[11]));
  mux_3 m50_12 (.a(w6_0_2[12]), .b(w6_0_3[12]), .c(w6_0_4[12]), .s0(s[0]), .s1(s[1]), .y(w6_0[12]));
  mux_3 m50_13 (.a(w6_0_2[13]), .b(w6_0_3[13]), .c(w6_0_4[13]), .s0(s[0]), .s1(s[1]), .y(w6_0[13]));
  mux_3 m50_14 (.a(w6_0_2[14]), .b(w6_0_3[14]), .c(w6_0_4[14]), .s0(s[0]), .s1(s[1]), .y(w6_0[14]));
  mux_3 m50_15 (.a(w6_0_2[15]), .b(w6_0_3[15]), .c(w6_0_4[15]), .s0(s[0]), .s1(s[1]), .y(w6_0[15]));

  // Muxes for w7_0
  mux_3 m60_0 (.a(w7_0_2[0]), .b(w7_0_3[0]), .c(w7_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w7_0[0]));
  mux_3 m60_1 (.a(w7_0_2[1]), .b(w7_0_3[1]), .c(w7_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w7_0[1]));
  mux_3 m60_2 (.a(w7_0_2[2]), .b(w7_0_3[2]), .c(w7_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w7_0[2]));
  mux_3 m60_3 (.a(w7_0_2[3]), .b(w7_0_3[3]), .c(w7_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w7_0[3]));
  mux_3 m60_4 (.a(w7_0_2[4]), .b(w7_0_3[4]), .c(w7_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w7_0[4]));
  mux_3 m60_5 (.a(w7_0_2[5]), .b(w7_0_3[5]), .c(w7_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w7_0[5]));
  mux_3 m60_6 (.a(w7_0_2[6]), .b(w7_0_3[6]), .c(w7_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w7_0[6]));
  mux_3 m60_7 (.a(w7_0_2[7]), .b(w7_0_3[7]), .c(w7_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w7_0[7]));
  mux_3 m60_8 (.a(w7_0_2[8]), .b(w7_0_3[8]), .c(w7_0_4[8]), .s0(s[0]), .s1(s[1]), .y(w7_0[8]));
  mux_3 m60_9 (.a(w7_0_2[9]), .b(w7_0_3[9]), .c(w7_0_4[9]), .s0(s[0]), .s1(s[1]), .y(w7_0[9]));
  mux_3 m60_10 (.a(w7_0_2[10]), .b(w7_0_3[10]), .c(w7_0_4[10]), .s0(s[0]), .s1(s[1]), .y(w7_0[10]));
  mux_3 m60_11 (.a(w7_0_2[11]), .b(w7_0_3[11]), .c(w7_0_4[11]), .s0(s[0]), .s1(s[1]), .y(w7_0[11]));
  mux_3 m60_12 (.a(w7_0_2[12]), .b(w7_0_3[12]), .c(w7_0_4[12]), .s0(s[0]), .s1(s[1]), .y(w7_0[12]));
  mux_3 m60_13 (.a(w7_0_2[13]), .b(w7_0_3[13]), .c(w7_0_4[13]), .s0(s[0]), .s1(s[1]), .y(w7_0[13]));
  mux_3 m60_14 (.a(w7_0_2[14]), .b(w7_0_3[14]), .c(w7_0_4[14]), .s0(s[0]), .s1(s[1]), .y(w7_0[14]));
  mux_3 m60_15 (.a(w7_0_2[15]), .b(w7_0_3[15]), .c(w7_0_4[15]), .s0(s[0]), .s1(s[1]), .y(w7_0[15]));

  // Muxes for w8_0
  mux_3 m70_0 (.a(w8_0_2[0]), .b(w8_0_3[0]), .c(w8_0_4[0]), .s0(s[0]), .s1(s[1]), .y(w8_0[0]));
  mux_3 m70_1 (.a(w8_0_2[1]), .b(w8_0_3[1]), .c(w8_0_4[1]), .s0(s[0]), .s1(s[1]), .y(w8_0[1]));
  mux_3 m70_2 (.a(w8_0_2[2]), .b(w8_0_3[2]), .c(w8_0_4[2]), .s0(s[0]), .s1(s[1]), .y(w8_0[2]));
  mux_3 m70_3 (.a(w8_0_2[3]), .b(w8_0_3[3]), .c(w8_0_4[3]), .s0(s[0]), .s1(s[1]), .y(w8_0[3]));
  mux_3 m70_4 (.a(w8_0_2[4]), .b(w8_0_3[4]), .c(w8_0_4[4]), .s0(s[0]), .s1(s[1]), .y(w8_0[4]));
  mux_3 m70_5 (.a(w8_0_2[5]), .b(w8_0_3[5]), .c(w8_0_4[5]), .s0(s[0]), .s1(s[1]), .y(w8_0[5]));
  mux_3 m70_6 (.a(w8_0_2[6]), .b(w8_0_3[6]), .c(w8_0_4[6]), .s0(s[0]), .s1(s[1]), .y(w8_0[6]));
  mux_3 m70_7 (.a(w8_0_2[7]), .b(w8_0_3[7]), .c(w8_0_4[7]), .s0(s[0]), .s1(s[1]), .y(w8_0[7]));
  mux_3 m70_8 (.a(w8_0_2[8]), .b(w8_0_3[8]), .c(w8_0_4[8]), .s0(s[0]), .s1(s[1]), .y(w8_0[8]));
  mux_3 m70_9 (.a(w8_0_2[9]), .b(w8_0_3[9]), .c(w8_0_4[9]), .s0(s[0]), .s1(s[1]), .y(w8_0[9]));
  mux_3 m70_10 (.a(w8_0_2[10]), .b(w8_0_3[10]), .c(w8_0_4[10]), .s0(s[0]), .s1(s[1]), .y(w8_0[10]));
  mux_3 m70_11 (.a(w8_0_2[11]), .b(w8_0_3[11]), .c(w8_0_4[11]), .s0(s[0]), .s1(s[1]), .y(w8_0[11]));
  mux_3 m70_12 (.a(w8_0_2[12]), .b(w8_0_3[12]), .c(w8_0_4[12]), .s0(s[0]), .s1(s[1]), .y(w8_0[12]));
  mux_3 m70_13 (.a(w8_0_2[13]), .b(w8_0_3[13]), .c(w8_0_4[13]), .s0(s[0]), .s1(s[1]), .y(w8_0[13]));
  mux_3 m70_14 (.a(w8_0_2[14]), .b(w8_0_3[14]), .c(w8_0_4[14]), .s0(s[0]), .s1(s[1]), .y(w8_0[14]));
  mux_3 m70_15 (.a(w8_0_2[15]), .b(w8_0_3[15]), .c(w8_0_4[15]), .s0(s[0]), .s1(s[1]), .y(w8_0[15]));

  // Layer with weight vector _2
  wire [15:0] new_masked_activation0_0 = {
      (~^( masked_activation0_1 ^ w1_0[15] )),
      (~^( masked_activation0_1 ^ w1_0[14] )),
      (~^( masked_activation0_1 ^ w1_0[13] )),
      (~^( masked_activation0_1 ^ w1_0[12] )),
      (~^( masked_activation0_1 ^ w1_0[11] )),
      (~^( masked_activation0_1 ^ w1_0[10] )),
      (~^( masked_activation0_1 ^ w1_0[9] )),
      (~^( masked_activation0_1 ^ w1_0[8] )),
      (~^( masked_activation0_1 ^ w1_0[7] )),
      (~^( masked_activation0_1 ^ w1_0[6] )),
      (~^( masked_activation0_1 ^ w1_0[5] )),
      (~^( masked_activation0_1 ^ w1_0[4] )),
      (~^( masked_activation0_1 ^ w1_0[3] )),
      (~^( masked_activation0_1 ^ w1_0[2] )),
      (~^( masked_activation0_1 ^ w1_0[1] )),
      (~^( masked_activation0_1 ^ w1_0[0] ))
  };
  wire [15:0] new_mask0_0 = {
      ~( mask0_1 ^ w1_1[15] ),
      ~( mask0_1 ^ w1_1[14] ),
      ~( mask0_1 ^ w1_1[13] ),
      ~( mask0_1 ^ w1_1[12] ),
      ~( mask0_1 ^ w1_1[11] ),
      ~( mask0_1 ^ w1_1[10] ),
      ~( mask0_1 ^ w1_1[9] ),
      ~( mask0_1 ^ w1_1[8] ),
      ~( mask0_1 ^ w1_1[7] ),
      ~( mask0_1 ^ w1_1[6] ),
      ~( mask0_1 ^ w1_1[5] ),
      ~( mask0_1 ^ w1_1[4] ),
      ~( mask0_1 ^ w1_1[3] ),
      ~( mask0_1 ^ w1_1[2] ),
      ~( mask0_1 ^ w1_1[1] ),
      ~( mask0_1 ^ w1_1[0] )
  };

  wire [15:0] new_masked_activation1_0 = {
      (~^( masked_activation1_1 ^ w2_0[15] )),
      (~^( masked_activation1_1 ^ w2_0[14] )),
      (~^( masked_activation1_1 ^ w2_0[13] )),
      (~^( masked_activation1_1 ^ w2_0[12] )),
      (~^( masked_activation1_1 ^ w2_0[11] )),
      (~^( masked_activation1_1 ^ w2_0[10] )),
      (~^( masked_activation1_1 ^ w2_0[9] )),
      (~^( masked_activation1_1 ^ w2_0[8] )),
      (~^( masked_activation1_1 ^ w2_0[7] )),
      (~^( masked_activation1_1 ^ w2_0[6] )),
      (~^( masked_activation1_1 ^ w2_0[5] )),
      (~^( masked_activation1_1 ^ w2_0[4] )),
      (~^( masked_activation1_1 ^ w2_0[3] )),
      (~^( masked_activation1_1 ^ w2_0[2] )),
      (~^( masked_activation1_1 ^ w2_0[1] )),
      (~^( masked_activation1_1 ^ w2_0[0] ))
  };
  wire [15:0] new_mask1_0 = {
      ~( mask1_1 ^ w2_1[15] ),
      ~( mask1_1 ^ w2_1[14] ),
      ~( mask1_1 ^ w2_1[13] ),
      ~( mask1_1 ^ w2_1[12] ),
      ~( mask1_1 ^ w2_1[11] ),
      ~( mask1_1 ^ w2_1[10] ),
      ~( mask1_1 ^ w2_1[9] ),
      ~( mask1_1 ^ w2_1[8] ),
      ~( mask1_1 ^ w2_1[7] ),
      ~( mask1_1 ^ w2_1[6] ),
      ~( mask1_1 ^ w2_1[5] ),
      ~( mask1_1 ^ w2_1[4] ),
      ~( mask1_1 ^ w2_1[3] ),
      ~( mask1_1 ^ w2_1[2] ),
      ~( mask1_1 ^ w2_1[1] ),
      ~( mask1_1 ^ w2_1[0] )
  };

  wire [15:0] new_masked_activation2_0 = {
      (~^( masked_activation2_1 ^ w3_0[15] )),
      (~^( masked_activation2_1 ^ w3_0[14] )),
      (~^( masked_activation2_1 ^ w3_0[13] )),
      (~^( masked_activation2_1 ^ w3_0[12] )),
      (~^( masked_activation2_1 ^ w3_0[11] )),
      (~^( masked_activation2_1 ^ w3_0[10] )),
      (~^( masked_activation2_1 ^ w3_0[9] )),
      (~^( masked_activation2_1 ^ w3_0[8] )),
      (~^( masked_activation2_1 ^ w3_0[7] )),
      (~^( masked_activation2_1 ^ w3_0[6] )),
      (~^( masked_activation2_1 ^ w3_0[5] )),
      (~^( masked_activation2_1 ^ w3_0[4] )),
      (~^( masked_activation2_1 ^ w3_0[3] )),
      (~^( masked_activation2_1 ^ w3_0[2] )),
      (~^( masked_activation2_1 ^ w3_0[1] )),
      (~^( masked_activation2_1 ^ w3_0[0] ))
  };
  wire [15:0] new_mask2_0 = {
      ~( mask2_1 ^ w3_1[15] ),
      ~( mask2_1 ^ w3_1[14] ),
      ~( mask2_1 ^ w3_1[13] ),
      ~( mask2_1 ^ w3_1[12] ),
      ~( mask2_1 ^ w3_1[11] ),
      ~( mask2_1 ^ w3_1[10] ),
      ~( mask2_1 ^ w3_1[9] ),
      ~( mask2_1 ^ w3_1[8] ),
      ~( mask2_1 ^ w3_1[7] ),
      ~( mask2_1 ^ w3_1[6] ),
      ~( mask2_1 ^ w3_1[5] ),
      ~( mask2_1 ^ w3_1[4] ),
      ~( mask2_1 ^ w3_1[3] ),
      ~( mask2_1 ^ w3_1[2] ),
      ~( mask2_1 ^ w3_1[1] ),
      ~( mask2_1 ^ w3_1[0] )
  };

  wire [15:0] new_masked_activation3_0 = {
      (~^( masked_activation3_1 ^ w4_0[15] )),
      (~^( masked_activation3_1 ^ w4_0[14] )),
      (~^( masked_activation3_1 ^ w4_0[13] )),
      (~^( masked_activation3_1 ^ w4_0[12] )),
      (~^( masked_activation3_1 ^ w4_0[11] )),
      (~^( masked_activation3_1 ^ w4_0[10] )),
      (~^( masked_activation3_1 ^ w4_0[9] )),
      (~^( masked_activation3_1 ^ w4_0[8] )),
      (~^( masked_activation3_1 ^ w4_0[7] )),
      (~^( masked_activation3_1 ^ w4_0[6] )),
      (~^( masked_activation3_1 ^ w4_0[5] )),
      (~^( masked_activation3_1 ^ w4_0[4] )),
      (~^( masked_activation3_1 ^ w4_0[3] )),
      (~^( masked_activation3_1 ^ w4_0[2] )),
      (~^( masked_activation3_1 ^ w4_0[1] )),
      (~^( masked_activation3_1 ^ w4_0[0] ))
  };
  wire [15:0] new_mask3_0 = {
      ~( mask3_1 ^ w4_1[15] ),
      ~( mask3_1 ^ w4_1[14] ),
      ~( mask3_1 ^ w4_1[13] ),
      ~( mask3_1 ^ w4_1[12] ),
      ~( mask3_1 ^ w4_1[11] ),
      ~( mask3_1 ^ w4_1[10] ),
      ~( mask3_1 ^ w4_1[9] ),
      ~( mask3_1 ^ w4_1[8] ),
      ~( mask3_1 ^ w4_1[7] ),
      ~( mask3_1 ^ w4_1[6] ),
      ~( mask3_1 ^ w4_1[5] ),
      ~( mask3_1 ^ w4_1[4] ),
      ~( mask3_1 ^ w4_1[3] ),
      ~( mask3_1 ^ w4_1[2] ),
      ~( mask3_1 ^ w4_1[1] ),
      ~( mask3_1 ^ w4_1[0] )
  };

  wire [15:0] new_masked_activation4_0 = {
      (~^( masked_activation4_1 ^ w5_0[15] )),
      (~^( masked_activation4_1 ^ w5_0[14] )),
      (~^( masked_activation4_1 ^ w5_0[13] )),
      (~^( masked_activation4_1 ^ w5_0[12] )),
      (~^( masked_activation4_1 ^ w5_0[11] )),
      (~^( masked_activation4_1 ^ w5_0[10] )),
      (~^( masked_activation4_1 ^ w5_0[9] )),
      (~^( masked_activation4_1 ^ w5_0[8] )),
      (~^( masked_activation4_1 ^ w5_0[7] )),
      (~^( masked_activation4_1 ^ w5_0[6] )),
      (~^( masked_activation4_1 ^ w5_0[5] )),
      (~^( masked_activation4_1 ^ w5_0[4] )),
      (~^( masked_activation4_1 ^ w5_0[3] )),
      (~^( masked_activation4_1 ^ w5_0[2] )),
      (~^( masked_activation4_1 ^ w5_0[1] )),
      (~^( masked_activation4_1 ^ w5_0[0] ))
  };
  wire [15:0] new_mask4_0 = {
      ~( mask4_1 ^ w5_1[15] ),
      ~( mask4_1 ^ w5_1[14] ),
      ~( mask4_1 ^ w5_1[13] ),
      ~( mask4_1 ^ w5_1[12] ),
      ~( mask4_1 ^ w5_1[11] ),
      ~( mask4_1 ^ w5_1[10] ),
      ~( mask4_1 ^ w5_1[9] ),
      ~( mask4_1 ^ w5_1[8] ),
      ~( mask4_1 ^ w5_1[7] ),
      ~( mask4_1 ^ w5_1[6] ),
      ~( mask4_1 ^ w5_1[5] ),
      ~( mask4_1 ^ w5_1[4] ),
      ~( mask4_1 ^ w5_1[3] ),
      ~( mask4_1 ^ w5_1[2] ),
      ~( mask4_1 ^ w5_1[1] ),
      ~( mask4_1 ^ w5_1[0] )
  };

  wire [15:0] new_masked_activation5_0 = {
      (~^( masked_activation5_1 ^ w6_0[15] )),
      (~^( masked_activation5_1 ^ w6_0[14] )),
      (~^( masked_activation5_1 ^ w6_0[13] )),
      (~^( masked_activation5_1 ^ w6_0[12] )),
      (~^( masked_activation5_1 ^ w6_0[11] )),
      (~^( masked_activation5_1 ^ w6_0[10] )),
      (~^( masked_activation5_1 ^ w6_0[9] )),
      (~^( masked_activation5_1 ^ w6_0[8] )),
      (~^( masked_activation5_1 ^ w6_0[7] )),
      (~^( masked_activation5_1 ^ w6_0[6] )),
      (~^( masked_activation5_1 ^ w6_0[5] )),
      (~^( masked_activation5_1 ^ w6_0[4] )),
      (~^( masked_activation5_1 ^ w6_0[3] )),
      (~^( masked_activation5_1 ^ w6_0[2] )),
      (~^( masked_activation5_1 ^ w6_0[1] )),
      (~^( masked_activation5_1 ^ w6_0[0] ))
  };
  wire [15:0] new_mask5_0 = {
      ~( mask5_1 ^ w6_1[15] ),
      ~( mask5_1 ^ w6_1[14] ),
      ~( mask5_1 ^ w6_1[13] ),
      ~( mask5_1 ^ w6_1[12] ),
      ~( mask5_1 ^ w6_1[11] ),
      ~( mask5_1 ^ w6_1[10] ),
      ~( mask5_1 ^ w6_1[9] ),
      ~( mask5_1 ^ w6_1[8] ),
      ~( mask5_1 ^ w6_1[7] ),
      ~( mask5_1 ^ w6_1[6] ),
      ~( mask5_1 ^ w6_1[5] ),
      ~( mask5_1 ^ w6_1[4] ),
      ~( mask5_1 ^ w6_1[3] ),
      ~( mask5_1 ^ w6_1[2] ),
      ~( mask5_1 ^ w6_1[1] ),
      ~( mask5_1 ^ w6_1[0] )
  };

  wire [15:0] new_masked_activation6_0 = {
      (~^( masked_activation6_1 ^ w7_0[15] )),
      (~^( masked_activation6_1 ^ w7_0[14] )),
      (~^( masked_activation6_1 ^ w7_0[13] )),
      (~^( masked_activation6_1 ^ w7_0[12] )),
      (~^( masked_activation6_1 ^ w7_0[11] )),
      (~^( masked_activation6_1 ^ w7_0[10] )),
      (~^( masked_activation6_1 ^ w7_0[9] )),
      (~^( masked_activation6_1 ^ w7_0[8] )),
      (~^( masked_activation6_1 ^ w7_0[7] )),
      (~^( masked_activation6_1 ^ w7_0[6] )),
      (~^( masked_activation6_1 ^ w7_0[5] )),
      (~^( masked_activation6_1 ^ w7_0[4] )),
      (~^( masked_activation6_1 ^ w7_0[3] )),
      (~^( masked_activation6_1 ^ w7_0[2] )),
      (~^( masked_activation6_1 ^ w7_0[1] )),
      (~^( masked_activation6_1 ^ w7_0[0] ))
  };
  wire [15:0] new_mask6_0 = {
      ~( mask6_1 ^ w7_1[15] ),
      ~( mask6_1 ^ w7_1[14] ),
      ~( mask6_1 ^ w7_1[13] ),
      ~( mask6_1 ^ w7_1[12] ),
      ~( mask6_1 ^ w7_1[11] ),
      ~( mask6_1 ^ w7_1[10] ),
      ~( mask6_1 ^ w7_1[9] ),
      ~( mask6_1 ^ w7_1[8] ),
      ~( mask6_1 ^ w7_1[7] ),
      ~( mask6_1 ^ w7_1[6] ),
      ~( mask6_1 ^ w7_1[5] ),
      ~( mask6_1 ^ w7_1[4] ),
      ~( mask6_1 ^ w7_1[3] ),
      ~( mask6_1 ^ w7_1[2] ),
      ~( mask6_1 ^ w7_1[1] ),
      ~( mask6_1 ^ w7_1[0] )
  };

  wire [15:0] new_masked_activation7_0 = {
      (~^( masked_activation7_1 ^ w8_0[15] )),
      (~^( masked_activation7_1 ^ w8_0[14] )),
      (~^( masked_activation7_1 ^ w8_0[13] )),
      (~^( masked_activation7_1 ^ w8_0[12] )),
      (~^( masked_activation7_1 ^ w8_0[11] )),
      (~^( masked_activation7_1 ^ w8_0[10] )),
      (~^( masked_activation7_1 ^ w8_0[9] )),
      (~^( masked_activation7_1 ^ w8_0[8] )),
      (~^( masked_activation7_1 ^ w8_0[7] )),
      (~^( masked_activation7_1 ^ w8_0[6] )),
      (~^( masked_activation7_1 ^ w8_0[5] )),
      (~^( masked_activation7_1 ^ w8_0[4] )),
      (~^( masked_activation7_1 ^ w8_0[3] )),
      (~^( masked_activation7_1 ^ w8_0[2] )),
      (~^( masked_activation7_1 ^ w8_0[1] )),
      (~^( masked_activation7_1 ^ w8_0[0] ))
  };
  wire [15:0] new_mask7_0 = {
      ~( mask7_1 ^ w8_1[15] ),
      ~( mask7_1 ^ w8_1[14] ),
      ~( mask7_1 ^ w8_1[13] ),
      ~( mask7_1 ^ w8_1[12] ),
      ~( mask7_1 ^ w8_1[11] ),
      ~( mask7_1 ^ w8_1[10] ),
      ~( mask7_1 ^ w8_1[9] ),
      ~( mask7_1 ^ w8_1[8] ),
      ~( mask7_1 ^ w8_1[7] ),
      ~( mask7_1 ^ w8_1[6] ),
      ~( mask7_1 ^ w8_1[5] ),
      ~( mask7_1 ^ w8_1[4] ),
      ~( mask7_1 ^ w8_1[3] ),
      ~( mask7_1 ^ w8_1[2] ),
      ~( mask7_1 ^ w8_1[1] ),
      ~( mask7_1 ^ w8_1[0] )
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
  mux_3 m01_8 (.a(w1_1_2[8]), .b(w1_1_3[8]), .c(w1_1_4[8]), .s0(s[0]), .s1(s[1]), .y(w1_1[8]));
  mux_3 m01_9 (.a(w1_1_2[9]), .b(w1_1_3[9]), .c(w1_1_4[9]), .s0(s[0]), .s1(s[1]), .y(w1_1[9]));
  mux_3 m01_10 (.a(w1_1_2[10]), .b(w1_1_3[10]), .c(w1_1_4[10]), .s0(s[0]), .s1(s[1]), .y(w1_1[10]));
  mux_3 m01_11 (.a(w1_1_2[11]), .b(w1_1_3[11]), .c(w1_1_4[11]), .s0(s[0]), .s1(s[1]), .y(w1_1[11]));
  mux_3 m01_12 (.a(w1_1_2[12]), .b(w1_1_3[12]), .c(w1_1_4[12]), .s0(s[0]), .s1(s[1]), .y(w1_1[12]));
  mux_3 m01_13 (.a(w1_1_2[13]), .b(w1_1_3[13]), .c(w1_1_4[13]), .s0(s[0]), .s1(s[1]), .y(w1_1[13]));
  mux_3 m01_14 (.a(w1_1_2[14]), .b(w1_1_3[14]), .c(w1_1_4[14]), .s0(s[0]), .s1(s[1]), .y(w1_1[14]));
  mux_3 m01_15 (.a(w1_1_2[15]), .b(w1_1_3[15]), .c(w1_1_4[15]), .s0(s[0]), .s1(s[1]), .y(w1_1[15]));

  // Muxes for w2_1
  mux_3 m11_0 (.a(w2_1_2[0]), .b(w2_1_3[0]), .c(w2_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w2_1[0]));
  mux_3 m11_1 (.a(w2_1_2[1]), .b(w2_1_3[1]), .c(w2_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w2_1[1]));
  mux_3 m11_2 (.a(w2_1_2[2]), .b(w2_1_3[2]), .c(w2_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w2_1[2]));
  mux_3 m11_3 (.a(w2_1_2[3]), .b(w2_1_3[3]), .c(w2_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w2_1[3]));
  mux_3 m11_4 (.a(w2_1_2[4]), .b(w2_1_3[4]), .c(w2_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w2_1[4]));
  mux_3 m11_5 (.a(w2_1_2[5]), .b(w2_1_3[5]), .c(w2_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w2_1[5]));
  mux_3 m11_6 (.a(w2_1_2[6]), .b(w2_1_3[6]), .c(w2_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w2_1[6]));
  mux_3 m11_7 (.a(w2_1_2[7]), .b(w2_1_3[7]), .c(w2_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w2_1[7]));
  mux_3 m11_8 (.a(w2_1_2[8]), .b(w2_1_3[8]), .c(w2_1_4[8]), .s0(s[0]), .s1(s[1]), .y(w2_1[8]));
  mux_3 m11_9 (.a(w2_1_2[9]), .b(w2_1_3[9]), .c(w2_1_4[9]), .s0(s[0]), .s1(s[1]), .y(w2_1[9]));
  mux_3 m11_10 (.a(w2_1_2[10]), .b(w2_1_3[10]), .c(w2_1_4[10]), .s0(s[0]), .s1(s[1]), .y(w2_1[10]));
  mux_3 m11_11 (.a(w2_1_2[11]), .b(w2_1_3[11]), .c(w2_1_4[11]), .s0(s[0]), .s1(s[1]), .y(w2_1[11]));
  mux_3 m11_12 (.a(w2_1_2[12]), .b(w2_1_3[12]), .c(w2_1_4[12]), .s0(s[0]), .s1(s[1]), .y(w2_1[12]));
  mux_3 m11_13 (.a(w2_1_2[13]), .b(w2_1_3[13]), .c(w2_1_4[13]), .s0(s[0]), .s1(s[1]), .y(w2_1[13]));
  mux_3 m11_14 (.a(w2_1_2[14]), .b(w2_1_3[14]), .c(w2_1_4[14]), .s0(s[0]), .s1(s[1]), .y(w2_1[14]));
  mux_3 m11_15 (.a(w2_1_2[15]), .b(w2_1_3[15]), .c(w2_1_4[15]), .s0(s[0]), .s1(s[1]), .y(w2_1[15]));

  // Muxes for w3_1
  mux_3 m21_0 (.a(w3_1_2[0]), .b(w3_1_3[0]), .c(w3_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w3_1[0]));
  mux_3 m21_1 (.a(w3_1_2[1]), .b(w3_1_3[1]), .c(w3_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w3_1[1]));
  mux_3 m21_2 (.a(w3_1_2[2]), .b(w3_1_3[2]), .c(w3_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w3_1[2]));
  mux_3 m21_3 (.a(w3_1_2[3]), .b(w3_1_3[3]), .c(w3_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w3_1[3]));
  mux_3 m21_4 (.a(w3_1_2[4]), .b(w3_1_3[4]), .c(w3_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w3_1[4]));
  mux_3 m21_5 (.a(w3_1_2[5]), .b(w3_1_3[5]), .c(w3_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w3_1[5]));
  mux_3 m21_6 (.a(w3_1_2[6]), .b(w3_1_3[6]), .c(w3_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w3_1[6]));
  mux_3 m21_7 (.a(w3_1_2[7]), .b(w3_1_3[7]), .c(w3_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w3_1[7]));
  mux_3 m21_8 (.a(w3_1_2[8]), .b(w3_1_3[8]), .c(w3_1_4[8]), .s0(s[0]), .s1(s[1]), .y(w3_1[8]));
  mux_3 m21_9 (.a(w3_1_2[9]), .b(w3_1_3[9]), .c(w3_1_4[9]), .s0(s[0]), .s1(s[1]), .y(w3_1[9]));
  mux_3 m21_10 (.a(w3_1_2[10]), .b(w3_1_3[10]), .c(w3_1_4[10]), .s0(s[0]), .s1(s[1]), .y(w3_1[10]));
  mux_3 m21_11 (.a(w3_1_2[11]), .b(w3_1_3[11]), .c(w3_1_4[11]), .s0(s[0]), .s1(s[1]), .y(w3_1[11]));
  mux_3 m21_12 (.a(w3_1_2[12]), .b(w3_1_3[12]), .c(w3_1_4[12]), .s0(s[0]), .s1(s[1]), .y(w3_1[12]));
  mux_3 m21_13 (.a(w3_1_2[13]), .b(w3_1_3[13]), .c(w3_1_4[13]), .s0(s[0]), .s1(s[1]), .y(w3_1[13]));
  mux_3 m21_14 (.a(w3_1_2[14]), .b(w3_1_3[14]), .c(w3_1_4[14]), .s0(s[0]), .s1(s[1]), .y(w3_1[14]));
  mux_3 m21_15 (.a(w3_1_2[15]), .b(w3_1_3[15]), .c(w3_1_4[15]), .s0(s[0]), .s1(s[1]), .y(w3_1[15]));

  // Muxes for w4_1
  mux_3 m31_0 (.a(w4_1_2[0]), .b(w4_1_3[0]), .c(w4_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w4_1[0]));
  mux_3 m31_1 (.a(w4_1_2[1]), .b(w4_1_3[1]), .c(w4_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w4_1[1]));
  mux_3 m31_2 (.a(w4_1_2[2]), .b(w4_1_3[2]), .c(w4_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w4_1[2]));
  mux_3 m31_3 (.a(w4_1_2[3]), .b(w4_1_3[3]), .c(w4_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w4_1[3]));
  mux_3 m31_4 (.a(w4_1_2[4]), .b(w4_1_3[4]), .c(w4_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w4_1[4]));
  mux_3 m31_5 (.a(w4_1_2[5]), .b(w4_1_3[5]), .c(w4_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w4_1[5]));
  mux_3 m31_6 (.a(w4_1_2[6]), .b(w4_1_3[6]), .c(w4_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w4_1[6]));
  mux_3 m31_7 (.a(w4_1_2[7]), .b(w4_1_3[7]), .c(w4_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w4_1[7]));
  mux_3 m31_8 (.a(w4_1_2[8]), .b(w4_1_3[8]), .c(w4_1_4[8]), .s0(s[0]), .s1(s[1]), .y(w4_1[8]));
  mux_3 m31_9 (.a(w4_1_2[9]), .b(w4_1_3[9]), .c(w4_1_4[9]), .s0(s[0]), .s1(s[1]), .y(w4_1[9]));
  mux_3 m31_10 (.a(w4_1_2[10]), .b(w4_1_3[10]), .c(w4_1_4[10]), .s0(s[0]), .s1(s[1]), .y(w4_1[10]));
  mux_3 m31_11 (.a(w4_1_2[11]), .b(w4_1_3[11]), .c(w4_1_4[11]), .s0(s[0]), .s1(s[1]), .y(w4_1[11]));
  mux_3 m31_12 (.a(w4_1_2[12]), .b(w4_1_3[12]), .c(w4_1_4[12]), .s0(s[0]), .s1(s[1]), .y(w4_1[12]));
  mux_3 m31_13 (.a(w4_1_2[13]), .b(w4_1_3[13]), .c(w4_1_4[13]), .s0(s[0]), .s1(s[1]), .y(w4_1[13]));
  mux_3 m31_14 (.a(w4_1_2[14]), .b(w4_1_3[14]), .c(w4_1_4[14]), .s0(s[0]), .s1(s[1]), .y(w4_1[14]));
  mux_3 m31_15 (.a(w4_1_2[15]), .b(w4_1_3[15]), .c(w4_1_4[15]), .s0(s[0]), .s1(s[1]), .y(w4_1[15]));

  // Muxes for w5_1
  mux_3 m41_0 (.a(w5_1_2[0]), .b(w5_1_3[0]), .c(w5_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w5_1[0]));
  mux_3 m41_1 (.a(w5_1_2[1]), .b(w5_1_3[1]), .c(w5_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w5_1[1]));
  mux_3 m41_2 (.a(w5_1_2[2]), .b(w5_1_3[2]), .c(w5_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w5_1[2]));
  mux_3 m41_3 (.a(w5_1_2[3]), .b(w5_1_3[3]), .c(w5_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w5_1[3]));
  mux_3 m41_4 (.a(w5_1_2[4]), .b(w5_1_3[4]), .c(w5_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w5_1[4]));
  mux_3 m41_5 (.a(w5_1_2[5]), .b(w5_1_3[5]), .c(w5_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w5_1[5]));
  mux_3 m41_6 (.a(w5_1_2[6]), .b(w5_1_3[6]), .c(w5_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w5_1[6]));
  mux_3 m41_7 (.a(w5_1_2[7]), .b(w5_1_3[7]), .c(w5_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w5_1[7]));
  mux_3 m41_8 (.a(w5_1_2[8]), .b(w5_1_3[8]), .c(w5_1_4[8]), .s0(s[0]), .s1(s[1]), .y(w5_1[8]));
  mux_3 m41_9 (.a(w5_1_2[9]), .b(w5_1_3[9]), .c(w5_1_4[9]), .s0(s[0]), .s1(s[1]), .y(w5_1[9]));
  mux_3 m41_10 (.a(w5_1_2[10]), .b(w5_1_3[10]), .c(w5_1_4[10]), .s0(s[0]), .s1(s[1]), .y(w5_1[10]));
  mux_3 m41_11 (.a(w5_1_2[11]), .b(w5_1_3[11]), .c(w5_1_4[11]), .s0(s[0]), .s1(s[1]), .y(w5_1[11]));
  mux_3 m41_12 (.a(w5_1_2[12]), .b(w5_1_3[12]), .c(w5_1_4[12]), .s0(s[0]), .s1(s[1]), .y(w5_1[12]));
  mux_3 m41_13 (.a(w5_1_2[13]), .b(w5_1_3[13]), .c(w5_1_4[13]), .s0(s[0]), .s1(s[1]), .y(w5_1[13]));
  mux_3 m41_14 (.a(w5_1_2[14]), .b(w5_1_3[14]), .c(w5_1_4[14]), .s0(s[0]), .s1(s[1]), .y(w5_1[14]));
  mux_3 m41_15 (.a(w5_1_2[15]), .b(w5_1_3[15]), .c(w5_1_4[15]), .s0(s[0]), .s1(s[1]), .y(w5_1[15]));

  // Muxes for w6_1
  mux_3 m51_0 (.a(w6_1_2[0]), .b(w6_1_3[0]), .c(w6_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w6_1[0]));
  mux_3 m51_1 (.a(w6_1_2[1]), .b(w6_1_3[1]), .c(w6_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w6_1[1]));
  mux_3 m51_2 (.a(w6_1_2[2]), .b(w6_1_3[2]), .c(w6_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w6_1[2]));
  mux_3 m51_3 (.a(w6_1_2[3]), .b(w6_1_3[3]), .c(w6_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w6_1[3]));
  mux_3 m51_4 (.a(w6_1_2[4]), .b(w6_1_3[4]), .c(w6_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w6_1[4]));
  mux_3 m51_5 (.a(w6_1_2[5]), .b(w6_1_3[5]), .c(w6_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w6_1[5]));
  mux_3 m51_6 (.a(w6_1_2[6]), .b(w6_1_3[6]), .c(w6_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w6_1[6]));
  mux_3 m51_7 (.a(w6_1_2[7]), .b(w6_1_3[7]), .c(w6_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w6_1[7]));
  mux_3 m51_8 (.a(w6_1_2[8]), .b(w6_1_3[8]), .c(w6_1_4[8]), .s0(s[0]), .s1(s[1]), .y(w6_1[8]));
  mux_3 m51_9 (.a(w6_1_2[9]), .b(w6_1_3[9]), .c(w6_1_4[9]), .s0(s[0]), .s1(s[1]), .y(w6_1[9]));
  mux_3 m51_10 (.a(w6_1_2[10]), .b(w6_1_3[10]), .c(w6_1_4[10]), .s0(s[0]), .s1(s[1]), .y(w6_1[10]));
  mux_3 m51_11 (.a(w6_1_2[11]), .b(w6_1_3[11]), .c(w6_1_4[11]), .s0(s[0]), .s1(s[1]), .y(w6_1[11]));
  mux_3 m51_12 (.a(w6_1_2[12]), .b(w6_1_3[12]), .c(w6_1_4[12]), .s0(s[0]), .s1(s[1]), .y(w6_1[12]));
  mux_3 m51_13 (.a(w6_1_2[13]), .b(w6_1_3[13]), .c(w6_1_4[13]), .s0(s[0]), .s1(s[1]), .y(w6_1[13]));
  mux_3 m51_14 (.a(w6_1_2[14]), .b(w6_1_3[14]), .c(w6_1_4[14]), .s0(s[0]), .s1(s[1]), .y(w6_1[14]));
  mux_3 m51_15 (.a(w6_1_2[15]), .b(w6_1_3[15]), .c(w6_1_4[15]), .s0(s[0]), .s1(s[1]), .y(w6_1[15]));

  // Muxes for w7_1
  mux_3 m61_0 (.a(w7_1_2[0]), .b(w7_1_3[0]), .c(w7_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w7_1[0]));
  mux_3 m61_1 (.a(w7_1_2[1]), .b(w7_1_3[1]), .c(w7_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w7_1[1]));
  mux_3 m61_2 (.a(w7_1_2[2]), .b(w7_1_3[2]), .c(w7_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w7_1[2]));
  mux_3 m61_3 (.a(w7_1_2[3]), .b(w7_1_3[3]), .c(w7_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w7_1[3]));
  mux_3 m61_4 (.a(w7_1_2[4]), .b(w7_1_3[4]), .c(w7_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w7_1[4]));
  mux_3 m61_5 (.a(w7_1_2[5]), .b(w7_1_3[5]), .c(w7_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w7_1[5]));
  mux_3 m61_6 (.a(w7_1_2[6]), .b(w7_1_3[6]), .c(w7_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w7_1[6]));
  mux_3 m61_7 (.a(w7_1_2[7]), .b(w7_1_3[7]), .c(w7_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w7_1[7]));
  mux_3 m61_8 (.a(w7_1_2[8]), .b(w7_1_3[8]), .c(w7_1_4[8]), .s0(s[0]), .s1(s[1]), .y(w7_1[8]));
  mux_3 m61_9 (.a(w7_1_2[9]), .b(w7_1_3[9]), .c(w7_1_4[9]), .s0(s[0]), .s1(s[1]), .y(w7_1[9]));
  mux_3 m61_10 (.a(w7_1_2[10]), .b(w7_1_3[10]), .c(w7_1_4[10]), .s0(s[0]), .s1(s[1]), .y(w7_1[10]));
  mux_3 m61_11 (.a(w7_1_2[11]), .b(w7_1_3[11]), .c(w7_1_4[11]), .s0(s[0]), .s1(s[1]), .y(w7_1[11]));
  mux_3 m61_12 (.a(w7_1_2[12]), .b(w7_1_3[12]), .c(w7_1_4[12]), .s0(s[0]), .s1(s[1]), .y(w7_1[12]));
  mux_3 m61_13 (.a(w7_1_2[13]), .b(w7_1_3[13]), .c(w7_1_4[13]), .s0(s[0]), .s1(s[1]), .y(w7_1[13]));
  mux_3 m61_14 (.a(w7_1_2[14]), .b(w7_1_3[14]), .c(w7_1_4[14]), .s0(s[0]), .s1(s[1]), .y(w7_1[14]));
  mux_3 m61_15 (.a(w7_1_2[15]), .b(w7_1_3[15]), .c(w7_1_4[15]), .s0(s[0]), .s1(s[1]), .y(w7_1[15]));

  // Muxes for w8_1
  mux_3 m71_0 (.a(w8_1_2[0]), .b(w8_1_3[0]), .c(w8_1_4[0]), .s0(s[0]), .s1(s[1]), .y(w8_1[0]));
  mux_3 m71_1 (.a(w8_1_2[1]), .b(w8_1_3[1]), .c(w8_1_4[1]), .s0(s[0]), .s1(s[1]), .y(w8_1[1]));
  mux_3 m71_2 (.a(w8_1_2[2]), .b(w8_1_3[2]), .c(w8_1_4[2]), .s0(s[0]), .s1(s[1]), .y(w8_1[2]));
  mux_3 m71_3 (.a(w8_1_2[3]), .b(w8_1_3[3]), .c(w8_1_4[3]), .s0(s[0]), .s1(s[1]), .y(w8_1[3]));
  mux_3 m71_4 (.a(w8_1_2[4]), .b(w8_1_3[4]), .c(w8_1_4[4]), .s0(s[0]), .s1(s[1]), .y(w8_1[4]));
  mux_3 m71_5 (.a(w8_1_2[5]), .b(w8_1_3[5]), .c(w8_1_4[5]), .s0(s[0]), .s1(s[1]), .y(w8_1[5]));
  mux_3 m71_6 (.a(w8_1_2[6]), .b(w8_1_3[6]), .c(w8_1_4[6]), .s0(s[0]), .s1(s[1]), .y(w8_1[6]));
  mux_3 m71_7 (.a(w8_1_2[7]), .b(w8_1_3[7]), .c(w8_1_4[7]), .s0(s[0]), .s1(s[1]), .y(w8_1[7]));
  mux_3 m71_8 (.a(w8_1_2[8]), .b(w8_1_3[8]), .c(w8_1_4[8]), .s0(s[0]), .s1(s[1]), .y(w8_1[8]));
  mux_3 m71_9 (.a(w8_1_2[9]), .b(w8_1_3[9]), .c(w8_1_4[9]), .s0(s[0]), .s1(s[1]), .y(w8_1[9]));
  mux_3 m71_10 (.a(w8_1_2[10]), .b(w8_1_3[10]), .c(w8_1_4[10]), .s0(s[0]), .s1(s[1]), .y(w8_1[10]));
  mux_3 m71_11 (.a(w8_1_2[11]), .b(w8_1_3[11]), .c(w8_1_4[11]), .s0(s[0]), .s1(s[1]), .y(w8_1[11]));
  mux_3 m71_12 (.a(w8_1_2[12]), .b(w8_1_3[12]), .c(w8_1_4[12]), .s0(s[0]), .s1(s[1]), .y(w8_1[12]));
  mux_3 m71_13 (.a(w8_1_2[13]), .b(w8_1_3[13]), .c(w8_1_4[13]), .s0(s[0]), .s1(s[1]), .y(w8_1[13]));
  mux_3 m71_14 (.a(w8_1_2[14]), .b(w8_1_3[14]), .c(w8_1_4[14]), .s0(s[0]), .s1(s[1]), .y(w8_1[14]));
  mux_3 m71_15 (.a(w8_1_2[15]), .b(w8_1_3[15]), .c(w8_1_4[15]), .s0(s[0]), .s1(s[1]), .y(w8_1[15]));

  // node 1
  mux_4 mux0_0_0 (.a(act0_0_0_1), .b(act0_0_0_2), .c(act0_0_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_0));
  mux_4 mux0_0_1 (.a(act0_1_0_1), .b(act0_1_0_2), .c(act0_1_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_1));
  mux_4 mux0_0_2 (.a(act0_2_0_1), .b(act0_2_0_2), .c(act0_2_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_2));
  mux_4 mux0_0_3 (.a(act0_3_0_1), .b(act0_3_0_2), .c(act0_3_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_3));
  mux_4 mux0_0_4 (.a(act0_4_0_1), .b(act0_4_0_2), .c(act0_4_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_4));
  mux_4 mux0_0_5 (.a(act0_5_0_1), .b(act0_5_0_2), .c(act0_5_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_5));
  mux_4 mux0_0_6 (.a(act0_6_0_1), .b(act0_6_0_2), .c(act0_6_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_6));
  mux_4 mux0_0_7 (.a(act0_7_0_1), .b(act0_7_0_2), .c(act0_7_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_7));
  mux_4 mux0_0_8 (.a(act0_8_0_1), .b(act0_8_0_2), .c(act0_8_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_8));
  mux_4 mux0_0_9 (.a(act0_9_0_1), .b(act0_9_0_2), .c(act0_9_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_9));
  mux_4 mux0_0_10 (.a(act0_10_0_1), .b(act0_10_0_2), .c(act0_10_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_10));
  mux_4 mux0_0_11 (.a(act0_11_0_1), .b(act0_11_0_2), .c(act0_11_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_11));
  mux_4 mux0_0_12 (.a(act0_12_0_1), .b(act0_12_0_2), .c(act0_12_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_12));
  mux_4 mux0_0_13 (.a(act0_13_0_1), .b(act0_13_0_2), .c(act0_13_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_13));
  mux_4 mux0_0_14 (.a(act0_14_0_1), .b(act0_14_0_2), .c(act0_14_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_14));
  mux_4 mux0_0_15 (.a(act0_15_0_1), .b(act0_15_0_2), .c(act0_15_0_3), .s0(s[0]), .s1(s[1]), .y(act0_0_15));
  mux_4 mux0_1_0 (.a(act0_0_1_1), .b(act0_0_1_2), .c(act0_0_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_0));
  mux_4 mux0_1_1 (.a(act0_1_1_1), .b(act0_1_1_2), .c(act0_1_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_1));
  mux_4 mux0_1_2 (.a(act0_2_1_1), .b(act0_2_1_2), .c(act0_2_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_2));
  mux_4 mux0_1_3 (.a(act0_3_1_1), .b(act0_3_1_2), .c(act0_3_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_3));
  mux_4 mux0_1_4 (.a(act0_4_1_1), .b(act0_4_1_2), .c(act0_4_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_4));
  mux_4 mux0_1_5 (.a(act0_5_1_1), .b(act0_5_1_2), .c(act0_5_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_5));
  mux_4 mux0_1_6 (.a(act0_6_1_1), .b(act0_6_1_2), .c(act0_6_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_6));
  mux_4 mux0_1_7 (.a(act0_7_1_1), .b(act0_7_1_2), .c(act0_7_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_7));
  mux_4 mux0_1_8 (.a(act0_8_1_1), .b(act0_8_1_2), .c(act0_8_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_8));
  mux_4 mux0_1_9 (.a(act0_9_1_1), .b(act0_9_1_2), .c(act0_9_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_9));
  mux_4 mux0_1_10 (.a(act0_10_1_1), .b(act0_10_1_2), .c(act0_10_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_10));
  mux_4 mux0_1_11 (.a(act0_11_1_1), .b(act0_11_1_2), .c(act0_11_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_11));
  mux_4 mux0_1_12 (.a(act0_12_1_1), .b(act0_12_1_2), .c(act0_12_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_12));
  mux_4 mux0_1_13 (.a(act0_13_1_1), .b(act0_13_1_2), .c(act0_13_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_13));
  mux_4 mux0_1_14 (.a(act0_14_1_1), .b(act0_14_1_2), .c(act0_14_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_14));
  mux_4 mux0_1_15 (.a(act0_15_1_1), .b(act0_15_1_2), .c(act0_15_1_3), .s0(s[0]), .s1(s[1]), .y(act0_1_15));

  // node 2
  mux_4 mux1_0_0 (.a(act1_0_0_1), .b(act1_0_0_2), .c(act1_0_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_0));
  mux_4 mux1_0_1 (.a(act1_1_0_1), .b(act1_1_0_2), .c(act1_1_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_1));
  mux_4 mux1_0_2 (.a(act1_2_0_1), .b(act1_2_0_2), .c(act1_2_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_2));
  mux_4 mux1_0_3 (.a(act1_3_0_1), .b(act1_3_0_2), .c(act1_3_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_3));
  mux_4 mux1_0_4 (.a(act1_4_0_1), .b(act1_4_0_2), .c(act1_4_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_4));
  mux_4 mux1_0_5 (.a(act1_5_0_1), .b(act1_5_0_2), .c(act1_5_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_5));
  mux_4 mux1_0_6 (.a(act1_6_0_1), .b(act1_6_0_2), .c(act1_6_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_6));
  mux_4 mux1_0_7 (.a(act1_7_0_1), .b(act1_7_0_2), .c(act1_7_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_7));
  mux_4 mux1_0_8 (.a(act1_8_0_1), .b(act1_8_0_2), .c(act1_8_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_8));
  mux_4 mux1_0_9 (.a(act1_9_0_1), .b(act1_9_0_2), .c(act1_9_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_9));
  mux_4 mux1_0_10 (.a(act1_10_0_1), .b(act1_10_0_2), .c(act1_10_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_10));
  mux_4 mux1_0_11 (.a(act1_11_0_1), .b(act1_11_0_2), .c(act1_11_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_11));
  mux_4 mux1_0_12 (.a(act1_12_0_1), .b(act1_12_0_2), .c(act1_12_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_12));
  mux_4 mux1_0_13 (.a(act1_13_0_1), .b(act1_13_0_2), .c(act1_13_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_13));
  mux_4 mux1_0_14 (.a(act1_14_0_1), .b(act1_14_0_2), .c(act1_14_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_14));
  mux_4 mux1_0_15 (.a(act1_15_0_1), .b(act1_15_0_2), .c(act1_15_0_3), .s0(s[0]), .s1(s[1]), .y(act1_0_15));
  mux_4 mux1_1_0 (.a(act1_0_1_1), .b(act1_0_1_2), .c(act1_0_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_0));
  mux_4 mux1_1_1 (.a(act1_1_1_1), .b(act1_1_1_2), .c(act1_1_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_1));
  mux_4 mux1_1_2 (.a(act1_2_1_1), .b(act1_2_1_2), .c(act1_2_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_2));
  mux_4 mux1_1_3 (.a(act1_3_1_1), .b(act1_3_1_2), .c(act1_3_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_3));
  mux_4 mux1_1_4 (.a(act1_4_1_1), .b(act1_4_1_2), .c(act1_4_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_4));
  mux_4 mux1_1_5 (.a(act1_5_1_1), .b(act1_5_1_2), .c(act1_5_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_5));
  mux_4 mux1_1_6 (.a(act1_6_1_1), .b(act1_6_1_2), .c(act1_6_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_6));
  mux_4 mux1_1_7 (.a(act1_7_1_1), .b(act1_7_1_2), .c(act1_7_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_7));
  mux_4 mux1_1_8 (.a(act1_8_1_1), .b(act1_8_1_2), .c(act1_8_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_8));
  mux_4 mux1_1_9 (.a(act1_9_1_1), .b(act1_9_1_2), .c(act1_9_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_9));
  mux_4 mux1_1_10 (.a(act1_10_1_1), .b(act1_10_1_2), .c(act1_10_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_10));
  mux_4 mux1_1_11 (.a(act1_11_1_1), .b(act1_11_1_2), .c(act1_11_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_11));
  mux_4 mux1_1_12 (.a(act1_12_1_1), .b(act1_12_1_2), .c(act1_12_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_12));
  mux_4 mux1_1_13 (.a(act1_13_1_1), .b(act1_13_1_2), .c(act1_13_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_13));
  mux_4 mux1_1_14 (.a(act1_14_1_1), .b(act1_14_1_2), .c(act1_14_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_14));
  mux_4 mux1_1_15 (.a(act1_15_1_1), .b(act1_15_1_2), .c(act1_15_1_3), .s0(s[0]), .s1(s[1]), .y(act1_1_15));

  // node 3
  mux_4 mux2_0_0 (.a(act2_0_0_1), .b(act2_0_0_2), .c(act2_0_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_0));
  mux_4 mux2_0_1 (.a(act2_1_0_1), .b(act2_1_0_2), .c(act2_1_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_1));
  mux_4 mux2_0_2 (.a(act2_2_0_1), .b(act2_2_0_2), .c(act2_2_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_2));
  mux_4 mux2_0_3 (.a(act2_3_0_1), .b(act2_3_0_2), .c(act2_3_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_3));
  mux_4 mux2_0_4 (.a(act2_4_0_1), .b(act2_4_0_2), .c(act2_4_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_4));
  mux_4 mux2_0_5 (.a(act2_5_0_1), .b(act2_5_0_2), .c(act2_5_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_5));
  mux_4 mux2_0_6 (.a(act2_6_0_1), .b(act2_6_0_2), .c(act2_6_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_6));
  mux_4 mux2_0_7 (.a(act2_7_0_1), .b(act2_7_0_2), .c(act2_7_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_7));
  mux_4 mux2_0_8 (.a(act2_8_0_1), .b(act2_8_0_2), .c(act2_8_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_8));
  mux_4 mux2_0_9 (.a(act2_9_0_1), .b(act2_9_0_2), .c(act2_9_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_9));
  mux_4 mux2_0_10 (.a(act2_10_0_1), .b(act2_10_0_2), .c(act2_10_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_10));
  mux_4 mux2_0_11 (.a(act2_11_0_1), .b(act2_11_0_2), .c(act2_11_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_11));
  mux_4 mux2_0_12 (.a(act2_12_0_1), .b(act2_12_0_2), .c(act2_12_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_12));
  mux_4 mux2_0_13 (.a(act2_13_0_1), .b(act2_13_0_2), .c(act2_13_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_13));
  mux_4 mux2_0_14 (.a(act2_14_0_1), .b(act2_14_0_2), .c(act2_14_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_14));
  mux_4 mux2_0_15 (.a(act2_15_0_1), .b(act2_15_0_2), .c(act2_15_0_3), .s0(s[0]), .s1(s[1]), .y(act2_0_15));
  mux_4 mux2_1_0 (.a(act2_0_1_1), .b(act2_0_1_2), .c(act2_0_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_0));
  mux_4 mux2_1_1 (.a(act2_1_1_1), .b(act2_1_1_2), .c(act2_1_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_1));
  mux_4 mux2_1_2 (.a(act2_2_1_1), .b(act2_2_1_2), .c(act2_2_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_2));
  mux_4 mux2_1_3 (.a(act2_3_1_1), .b(act2_3_1_2), .c(act2_3_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_3));
  mux_4 mux2_1_4 (.a(act2_4_1_1), .b(act2_4_1_2), .c(act2_4_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_4));
  mux_4 mux2_1_5 (.a(act2_5_1_1), .b(act2_5_1_2), .c(act2_5_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_5));
  mux_4 mux2_1_6 (.a(act2_6_1_1), .b(act2_6_1_2), .c(act2_6_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_6));
  mux_4 mux2_1_7 (.a(act2_7_1_1), .b(act2_7_1_2), .c(act2_7_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_7));
  mux_4 mux2_1_8 (.a(act2_8_1_1), .b(act2_8_1_2), .c(act2_8_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_8));
  mux_4 mux2_1_9 (.a(act2_9_1_1), .b(act2_9_1_2), .c(act2_9_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_9));
  mux_4 mux2_1_10 (.a(act2_10_1_1), .b(act2_10_1_2), .c(act2_10_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_10));
  mux_4 mux2_1_11 (.a(act2_11_1_1), .b(act2_11_1_2), .c(act2_11_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_11));
  mux_4 mux2_1_12 (.a(act2_12_1_1), .b(act2_12_1_2), .c(act2_12_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_12));
  mux_4 mux2_1_13 (.a(act2_13_1_1), .b(act2_13_1_2), .c(act2_13_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_13));
  mux_4 mux2_1_14 (.a(act2_14_1_1), .b(act2_14_1_2), .c(act2_14_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_14));
  mux_4 mux2_1_15 (.a(act2_15_1_1), .b(act2_15_1_2), .c(act2_15_1_3), .s0(s[0]), .s1(s[1]), .y(act2_1_15));

  // node 4
  mux_4 mux3_0_0 (.a(act3_0_0_1), .b(act3_0_0_2), .c(act3_0_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_0));
  mux_4 mux3_0_1 (.a(act3_1_0_1), .b(act3_1_0_2), .c(act3_1_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_1));
  mux_4 mux3_0_2 (.a(act3_2_0_1), .b(act3_2_0_2), .c(act3_2_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_2));
  mux_4 mux3_0_3 (.a(act3_3_0_1), .b(act3_3_0_2), .c(act3_3_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_3));
  mux_4 mux3_0_4 (.a(act3_4_0_1), .b(act3_4_0_2), .c(act3_4_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_4));
  mux_4 mux3_0_5 (.a(act3_5_0_1), .b(act3_5_0_2), .c(act3_5_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_5));
  mux_4 mux3_0_6 (.a(act3_6_0_1), .b(act3_6_0_2), .c(act3_6_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_6));
  mux_4 mux3_0_7 (.a(act3_7_0_1), .b(act3_7_0_2), .c(act3_7_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_7));
  mux_4 mux3_0_8 (.a(act3_8_0_1), .b(act3_8_0_2), .c(act3_8_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_8));
  mux_4 mux3_0_9 (.a(act3_9_0_1), .b(act3_9_0_2), .c(act3_9_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_9));
  mux_4 mux3_0_10 (.a(act3_10_0_1), .b(act3_10_0_2), .c(act3_10_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_10));
  mux_4 mux3_0_11 (.a(act3_11_0_1), .b(act3_11_0_2), .c(act3_11_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_11));
  mux_4 mux3_0_12 (.a(act3_12_0_1), .b(act3_12_0_2), .c(act3_12_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_12));
  mux_4 mux3_0_13 (.a(act3_13_0_1), .b(act3_13_0_2), .c(act3_13_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_13));
  mux_4 mux3_0_14 (.a(act3_14_0_1), .b(act3_14_0_2), .c(act3_14_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_14));
  mux_4 mux3_0_15 (.a(act3_15_0_1), .b(act3_15_0_2), .c(act3_15_0_3), .s0(s[0]), .s1(s[1]), .y(act3_0_15));
  mux_4 mux3_1_0 (.a(act3_0_1_1), .b(act3_0_1_2), .c(act3_0_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_0));
  mux_4 mux3_1_1 (.a(act3_1_1_1), .b(act3_1_1_2), .c(act3_1_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_1));
  mux_4 mux3_1_2 (.a(act3_2_1_1), .b(act3_2_1_2), .c(act3_2_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_2));
  mux_4 mux3_1_3 (.a(act3_3_1_1), .b(act3_3_1_2), .c(act3_3_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_3));
  mux_4 mux3_1_4 (.a(act3_4_1_1), .b(act3_4_1_2), .c(act3_4_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_4));
  mux_4 mux3_1_5 (.a(act3_5_1_1), .b(act3_5_1_2), .c(act3_5_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_5));
  mux_4 mux3_1_6 (.a(act3_6_1_1), .b(act3_6_1_2), .c(act3_6_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_6));
  mux_4 mux3_1_7 (.a(act3_7_1_1), .b(act3_7_1_2), .c(act3_7_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_7));
  mux_4 mux3_1_8 (.a(act3_8_1_1), .b(act3_8_1_2), .c(act3_8_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_8));
  mux_4 mux3_1_9 (.a(act3_9_1_1), .b(act3_9_1_2), .c(act3_9_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_9));
  mux_4 mux3_1_10 (.a(act3_10_1_1), .b(act3_10_1_2), .c(act3_10_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_10));
  mux_4 mux3_1_11 (.a(act3_11_1_1), .b(act3_11_1_2), .c(act3_11_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_11));
  mux_4 mux3_1_12 (.a(act3_12_1_1), .b(act3_12_1_2), .c(act3_12_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_12));
  mux_4 mux3_1_13 (.a(act3_13_1_1), .b(act3_13_1_2), .c(act3_13_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_13));
  mux_4 mux3_1_14 (.a(act3_14_1_1), .b(act3_14_1_2), .c(act3_14_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_14));
  mux_4 mux3_1_15 (.a(act3_15_1_1), .b(act3_15_1_2), .c(act3_15_1_3), .s0(s[0]), .s1(s[1]), .y(act3_1_15));

  // node 5
  mux_4 mux4_0_0 (.a(act4_0_0_1), .b(act4_0_0_2), .c(act4_0_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_0));
  mux_4 mux4_0_1 (.a(act4_1_0_1), .b(act4_1_0_2), .c(act4_1_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_1));
  mux_4 mux4_0_2 (.a(act4_2_0_1), .b(act4_2_0_2), .c(act4_2_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_2));
  mux_4 mux4_0_3 (.a(act4_3_0_1), .b(act4_3_0_2), .c(act4_3_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_3));
  mux_4 mux4_0_4 (.a(act4_4_0_1), .b(act4_4_0_2), .c(act4_4_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_4));
  mux_4 mux4_0_5 (.a(act4_5_0_1), .b(act4_5_0_2), .c(act4_5_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_5));
  mux_4 mux4_0_6 (.a(act4_6_0_1), .b(act4_6_0_2), .c(act4_6_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_6));
  mux_4 mux4_0_7 (.a(act4_7_0_1), .b(act4_7_0_2), .c(act4_7_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_7));
  mux_4 mux4_0_8 (.a(act4_8_0_1), .b(act4_8_0_2), .c(act4_8_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_8));
  mux_4 mux4_0_9 (.a(act4_9_0_1), .b(act4_9_0_2), .c(act4_9_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_9));
  mux_4 mux4_0_10 (.a(act4_10_0_1), .b(act4_10_0_2), .c(act4_10_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_10));
  mux_4 mux4_0_11 (.a(act4_11_0_1), .b(act4_11_0_2), .c(act4_11_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_11));
  mux_4 mux4_0_12 (.a(act4_12_0_1), .b(act4_12_0_2), .c(act4_12_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_12));
  mux_4 mux4_0_13 (.a(act4_13_0_1), .b(act4_13_0_2), .c(act4_13_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_13));
  mux_4 mux4_0_14 (.a(act4_14_0_1), .b(act4_14_0_2), .c(act4_14_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_14));
  mux_4 mux4_0_15 (.a(act4_15_0_1), .b(act4_15_0_2), .c(act4_15_0_3), .s0(s[0]), .s1(s[1]), .y(act4_0_15));
  mux_4 mux4_1_0 (.a(act4_0_1_1), .b(act4_0_1_2), .c(act4_0_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_0));
  mux_4 mux4_1_1 (.a(act4_1_1_1), .b(act4_1_1_2), .c(act4_1_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_1));
  mux_4 mux4_1_2 (.a(act4_2_1_1), .b(act4_2_1_2), .c(act4_2_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_2));
  mux_4 mux4_1_3 (.a(act4_3_1_1), .b(act4_3_1_2), .c(act4_3_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_3));
  mux_4 mux4_1_4 (.a(act4_4_1_1), .b(act4_4_1_2), .c(act4_4_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_4));
  mux_4 mux4_1_5 (.a(act4_5_1_1), .b(act4_5_1_2), .c(act4_5_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_5));
  mux_4 mux4_1_6 (.a(act4_6_1_1), .b(act4_6_1_2), .c(act4_6_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_6));
  mux_4 mux4_1_7 (.a(act4_7_1_1), .b(act4_7_1_2), .c(act4_7_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_7));
  mux_4 mux4_1_8 (.a(act4_8_1_1), .b(act4_8_1_2), .c(act4_8_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_8));
  mux_4 mux4_1_9 (.a(act4_9_1_1), .b(act4_9_1_2), .c(act4_9_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_9));
  mux_4 mux4_1_10 (.a(act4_10_1_1), .b(act4_10_1_2), .c(act4_10_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_10));
  mux_4 mux4_1_11 (.a(act4_11_1_1), .b(act4_11_1_2), .c(act4_11_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_11));
  mux_4 mux4_1_12 (.a(act4_12_1_1), .b(act4_12_1_2), .c(act4_12_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_12));
  mux_4 mux4_1_13 (.a(act4_13_1_1), .b(act4_13_1_2), .c(act4_13_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_13));
  mux_4 mux4_1_14 (.a(act4_14_1_1), .b(act4_14_1_2), .c(act4_14_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_14));
  mux_4 mux4_1_15 (.a(act4_15_1_1), .b(act4_15_1_2), .c(act4_15_1_3), .s0(s[0]), .s1(s[1]), .y(act4_1_15));

  // node 6
  mux_4 mux5_0_0 (.a(act5_0_0_1), .b(act5_0_0_2), .c(act5_0_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_0));
  mux_4 mux5_0_1 (.a(act5_1_0_1), .b(act5_1_0_2), .c(act5_1_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_1));
  mux_4 mux5_0_2 (.a(act5_2_0_1), .b(act5_2_0_2), .c(act5_2_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_2));
  mux_4 mux5_0_3 (.a(act5_3_0_1), .b(act5_3_0_2), .c(act5_3_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_3));
  mux_4 mux5_0_4 (.a(act5_4_0_1), .b(act5_4_0_2), .c(act5_4_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_4));
  mux_4 mux5_0_5 (.a(act5_5_0_1), .b(act5_5_0_2), .c(act5_5_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_5));
  mux_4 mux5_0_6 (.a(act5_6_0_1), .b(act5_6_0_2), .c(act5_6_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_6));
  mux_4 mux5_0_7 (.a(act5_7_0_1), .b(act5_7_0_2), .c(act5_7_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_7));
  mux_4 mux5_0_8 (.a(act5_8_0_1), .b(act5_8_0_2), .c(act5_8_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_8));
  mux_4 mux5_0_9 (.a(act5_9_0_1), .b(act5_9_0_2), .c(act5_9_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_9));
  mux_4 mux5_0_10 (.a(act5_10_0_1), .b(act5_10_0_2), .c(act5_10_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_10));
  mux_4 mux5_0_11 (.a(act5_11_0_1), .b(act5_11_0_2), .c(act5_11_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_11));
  mux_4 mux5_0_12 (.a(act5_12_0_1), .b(act5_12_0_2), .c(act5_12_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_12));
  mux_4 mux5_0_13 (.a(act5_13_0_1), .b(act5_13_0_2), .c(act5_13_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_13));
  mux_4 mux5_0_14 (.a(act5_14_0_1), .b(act5_14_0_2), .c(act5_14_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_14));
  mux_4 mux5_0_15 (.a(act5_15_0_1), .b(act5_15_0_2), .c(act5_15_0_3), .s0(s[0]), .s1(s[1]), .y(act5_0_15));
  mux_4 mux5_1_0 (.a(act5_0_1_1), .b(act5_0_1_2), .c(act5_0_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_0));
  mux_4 mux5_1_1 (.a(act5_1_1_1), .b(act5_1_1_2), .c(act5_1_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_1));
  mux_4 mux5_1_2 (.a(act5_2_1_1), .b(act5_2_1_2), .c(act5_2_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_2));
  mux_4 mux5_1_3 (.a(act5_3_1_1), .b(act5_3_1_2), .c(act5_3_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_3));
  mux_4 mux5_1_4 (.a(act5_4_1_1), .b(act5_4_1_2), .c(act5_4_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_4));
  mux_4 mux5_1_5 (.a(act5_5_1_1), .b(act5_5_1_2), .c(act5_5_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_5));
  mux_4 mux5_1_6 (.a(act5_6_1_1), .b(act5_6_1_2), .c(act5_6_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_6));
  mux_4 mux5_1_7 (.a(act5_7_1_1), .b(act5_7_1_2), .c(act5_7_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_7));
  mux_4 mux5_1_8 (.a(act5_8_1_1), .b(act5_8_1_2), .c(act5_8_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_8));
  mux_4 mux5_1_9 (.a(act5_9_1_1), .b(act5_9_1_2), .c(act5_9_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_9));
  mux_4 mux5_1_10 (.a(act5_10_1_1), .b(act5_10_1_2), .c(act5_10_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_10));
  mux_4 mux5_1_11 (.a(act5_11_1_1), .b(act5_11_1_2), .c(act5_11_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_11));
  mux_4 mux5_1_12 (.a(act5_12_1_1), .b(act5_12_1_2), .c(act5_12_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_12));
  mux_4 mux5_1_13 (.a(act5_13_1_1), .b(act5_13_1_2), .c(act5_13_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_13));
  mux_4 mux5_1_14 (.a(act5_14_1_1), .b(act5_14_1_2), .c(act5_14_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_14));
  mux_4 mux5_1_15 (.a(act5_15_1_1), .b(act5_15_1_2), .c(act5_15_1_3), .s0(s[0]), .s1(s[1]), .y(act5_1_15));

  // node 7
  mux_4 mux6_0_0 (.a(act6_0_0_1), .b(act6_0_0_2), .c(act6_0_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_0));
  mux_4 mux6_0_1 (.a(act6_1_0_1), .b(act6_1_0_2), .c(act6_1_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_1));
  mux_4 mux6_0_2 (.a(act6_2_0_1), .b(act6_2_0_2), .c(act6_2_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_2));
  mux_4 mux6_0_3 (.a(act6_3_0_1), .b(act6_3_0_2), .c(act6_3_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_3));
  mux_4 mux6_0_4 (.a(act6_4_0_1), .b(act6_4_0_2), .c(act6_4_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_4));
  mux_4 mux6_0_5 (.a(act6_5_0_1), .b(act6_5_0_2), .c(act6_5_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_5));
  mux_4 mux6_0_6 (.a(act6_6_0_1), .b(act6_6_0_2), .c(act6_6_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_6));
  mux_4 mux6_0_7 (.a(act6_7_0_1), .b(act6_7_0_2), .c(act6_7_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_7));
  mux_4 mux6_0_8 (.a(act6_8_0_1), .b(act6_8_0_2), .c(act6_8_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_8));
  mux_4 mux6_0_9 (.a(act6_9_0_1), .b(act6_9_0_2), .c(act6_9_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_9));
  mux_4 mux6_0_10 (.a(act6_10_0_1), .b(act6_10_0_2), .c(act6_10_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_10));
  mux_4 mux6_0_11 (.a(act6_11_0_1), .b(act6_11_0_2), .c(act6_11_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_11));
  mux_4 mux6_0_12 (.a(act6_12_0_1), .b(act6_12_0_2), .c(act6_12_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_12));
  mux_4 mux6_0_13 (.a(act6_13_0_1), .b(act6_13_0_2), .c(act6_13_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_13));
  mux_4 mux6_0_14 (.a(act6_14_0_1), .b(act6_14_0_2), .c(act6_14_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_14));
  mux_4 mux6_0_15 (.a(act6_15_0_1), .b(act6_15_0_2), .c(act6_15_0_3), .s0(s[0]), .s1(s[1]), .y(act6_0_15));
  mux_4 mux6_1_0 (.a(act6_0_1_1), .b(act6_0_1_2), .c(act6_0_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_0));
  mux_4 mux6_1_1 (.a(act6_1_1_1), .b(act6_1_1_2), .c(act6_1_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_1));
  mux_4 mux6_1_2 (.a(act6_2_1_1), .b(act6_2_1_2), .c(act6_2_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_2));
  mux_4 mux6_1_3 (.a(act6_3_1_1), .b(act6_3_1_2), .c(act6_3_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_3));
  mux_4 mux6_1_4 (.a(act6_4_1_1), .b(act6_4_1_2), .c(act6_4_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_4));
  mux_4 mux6_1_5 (.a(act6_5_1_1), .b(act6_5_1_2), .c(act6_5_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_5));
  mux_4 mux6_1_6 (.a(act6_6_1_1), .b(act6_6_1_2), .c(act6_6_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_6));
  mux_4 mux6_1_7 (.a(act6_7_1_1), .b(act6_7_1_2), .c(act6_7_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_7));
  mux_4 mux6_1_8 (.a(act6_8_1_1), .b(act6_8_1_2), .c(act6_8_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_8));
  mux_4 mux6_1_9 (.a(act6_9_1_1), .b(act6_9_1_2), .c(act6_9_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_9));
  mux_4 mux6_1_10 (.a(act6_10_1_1), .b(act6_10_1_2), .c(act6_10_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_10));
  mux_4 mux6_1_11 (.a(act6_11_1_1), .b(act6_11_1_2), .c(act6_11_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_11));
  mux_4 mux6_1_12 (.a(act6_12_1_1), .b(act6_12_1_2), .c(act6_12_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_12));
  mux_4 mux6_1_13 (.a(act6_13_1_1), .b(act6_13_1_2), .c(act6_13_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_13));
  mux_4 mux6_1_14 (.a(act6_14_1_1), .b(act6_14_1_2), .c(act6_14_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_14));
  mux_4 mux6_1_15 (.a(act6_15_1_1), .b(act6_15_1_2), .c(act6_15_1_3), .s0(s[0]), .s1(s[1]), .y(act6_1_15));

  // node 8
  mux_4 mux7_0_0 (.a(act7_0_0_1), .b(act7_0_0_2), .c(act7_0_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_0));
  mux_4 mux7_0_1 (.a(act7_1_0_1), .b(act7_1_0_2), .c(act7_1_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_1));
  mux_4 mux7_0_2 (.a(act7_2_0_1), .b(act7_2_0_2), .c(act7_2_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_2));
  mux_4 mux7_0_3 (.a(act7_3_0_1), .b(act7_3_0_2), .c(act7_3_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_3));
  mux_4 mux7_0_4 (.a(act7_4_0_1), .b(act7_4_0_2), .c(act7_4_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_4));
  mux_4 mux7_0_5 (.a(act7_5_0_1), .b(act7_5_0_2), .c(act7_5_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_5));
  mux_4 mux7_0_6 (.a(act7_6_0_1), .b(act7_6_0_2), .c(act7_6_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_6));
  mux_4 mux7_0_7 (.a(act7_7_0_1), .b(act7_7_0_2), .c(act7_7_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_7));
  mux_4 mux7_0_8 (.a(act7_8_0_1), .b(act7_8_0_2), .c(act7_8_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_8));
  mux_4 mux7_0_9 (.a(act7_9_0_1), .b(act7_9_0_2), .c(act7_9_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_9));
  mux_4 mux7_0_10 (.a(act7_10_0_1), .b(act7_10_0_2), .c(act7_10_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_10));
  mux_4 mux7_0_11 (.a(act7_11_0_1), .b(act7_11_0_2), .c(act7_11_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_11));
  mux_4 mux7_0_12 (.a(act7_12_0_1), .b(act7_12_0_2), .c(act7_12_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_12));
  mux_4 mux7_0_13 (.a(act7_13_0_1), .b(act7_13_0_2), .c(act7_13_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_13));
  mux_4 mux7_0_14 (.a(act7_14_0_1), .b(act7_14_0_2), .c(act7_14_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_14));
  mux_4 mux7_0_15 (.a(act7_15_0_1), .b(act7_15_0_2), .c(act7_15_0_3), .s0(s[0]), .s1(s[1]), .y(act7_0_15));
  mux_4 mux7_1_0 (.a(act7_0_1_1), .b(act7_0_1_2), .c(act7_0_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_0));
  mux_4 mux7_1_1 (.a(act7_1_1_1), .b(act7_1_1_2), .c(act7_1_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_1));
  mux_4 mux7_1_2 (.a(act7_2_1_1), .b(act7_2_1_2), .c(act7_2_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_2));
  mux_4 mux7_1_3 (.a(act7_3_1_1), .b(act7_3_1_2), .c(act7_3_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_3));
  mux_4 mux7_1_4 (.a(act7_4_1_1), .b(act7_4_1_2), .c(act7_4_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_4));
  mux_4 mux7_1_5 (.a(act7_5_1_1), .b(act7_5_1_2), .c(act7_5_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_5));
  mux_4 mux7_1_6 (.a(act7_6_1_1), .b(act7_6_1_2), .c(act7_6_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_6));
  mux_4 mux7_1_7 (.a(act7_7_1_1), .b(act7_7_1_2), .c(act7_7_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_7));
  mux_4 mux7_1_8 (.a(act7_8_1_1), .b(act7_8_1_2), .c(act7_8_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_8));
  mux_4 mux7_1_9 (.a(act7_9_1_1), .b(act7_9_1_2), .c(act7_9_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_9));
  mux_4 mux7_1_10 (.a(act7_10_1_1), .b(act7_10_1_2), .c(act7_10_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_10));
  mux_4 mux7_1_11 (.a(act7_11_1_1), .b(act7_11_1_2), .c(act7_11_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_11));
  mux_4 mux7_1_12 (.a(act7_12_1_1), .b(act7_12_1_2), .c(act7_12_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_12));
  mux_4 mux7_1_13 (.a(act7_13_1_1), .b(act7_13_1_2), .c(act7_13_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_13));
  mux_4 mux7_1_14 (.a(act7_14_1_1), .b(act7_14_1_2), .c(act7_14_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_14));
  mux_4 mux7_1_15 (.a(act7_15_1_1), .b(act7_15_1_2), .c(act7_15_1_3), .s0(s[0]), .s1(s[1]), .y(act7_1_15));

  // Boolean→Arithmetic converters
  boolean_arithmetic_coversion_1 conv00 (.x0(new_masked_activation0_0[0]), .x1(new_mask0_0[0]), .r_mask(ar0), .arith_share0(act0_0_0), .arith_share1(act0_1_0));
  boolean_arithmetic_coversion_1 conv01 (.x0(new_masked_activation0_0[1]), .x1(new_mask0_0[1]), .r_mask(ar0), .arith_share0(act0_0_1), .arith_share1(act0_1_1));
  boolean_arithmetic_coversion_1 conv02 (.x0(new_masked_activation0_0[2]), .x1(new_mask0_0[2]), .r_mask(ar0), .arith_share0(act0_0_2), .arith_share1(act0_1_2));
  boolean_arithmetic_coversion_1 conv03 (.x0(new_masked_activation0_0[3]), .x1(new_mask0_0[3]), .r_mask(ar0), .arith_share0(act0_0_3), .arith_share1(act0_1_3));
  boolean_arithmetic_coversion_1 conv04 (.x0(new_masked_activation0_0[4]), .x1(new_mask0_0[4]), .r_mask(ar0), .arith_share0(act0_0_4), .arith_share1(act0_1_4));
  boolean_arithmetic_coversion_1 conv05 (.x0(new_masked_activation0_0[5]), .x1(new_mask0_0[5]), .r_mask(ar0), .arith_share0(act0_0_5), .arith_share1(act0_1_5));
  boolean_arithmetic_coversion_1 conv06 (.x0(new_masked_activation0_0[6]), .x1(new_mask0_0[6]), .r_mask(ar0), .arith_share0(act0_0_6), .arith_share1(act0_1_6));
  boolean_arithmetic_coversion_1 conv07 (.x0(new_masked_activation0_0[7]), .x1(new_mask0_0[7]), .r_mask(ar0), .arith_share0(act0_0_7), .arith_share1(act0_1_7));
  boolean_arithmetic_coversion_1 conv08 (.x0(new_masked_activation0_0[8]), .x1(new_mask0_0[8]), .r_mask(ar0), .arith_share0(act0_0_8), .arith_share1(act0_1_8));
  boolean_arithmetic_coversion_1 conv09 (.x0(new_masked_activation0_0[9]), .x1(new_mask0_0[9]), .r_mask(ar0), .arith_share0(act0_0_9), .arith_share1(act0_1_9));
  boolean_arithmetic_coversion_1 conv10 (.x0(new_masked_activation0_0[10]), .x1(new_mask0_0[10]), .r_mask(ar0), .arith_share0(act0_0_10), .arith_share1(act0_1_10));
  boolean_arithmetic_coversion_1 conv11 (.x0(new_masked_activation0_0[11]), .x1(new_mask0_0[11]), .r_mask(ar0), .arith_share0(act0_0_11), .arith_share1(act0_1_11));
  boolean_arithmetic_coversion_1 conv12 (.x0(new_masked_activation0_0[12]), .x1(new_mask0_0[12]), .r_mask(ar0), .arith_share0(act0_0_12), .arith_share1(act0_1_12));
  boolean_arithmetic_coversion_1 conv13 (.x0(new_masked_activation0_0[13]), .x1(new_mask0_0[13]), .r_mask(ar0), .arith_share0(act0_0_13), .arith_share1(act0_1_13));
  boolean_arithmetic_coversion_1 conv14 (.x0(new_masked_activation0_0[14]), .x1(new_mask0_0[14]), .r_mask(ar0), .arith_share0(act0_0_14), .arith_share1(act0_1_14));
  boolean_arithmetic_coversion_1 conv15 (.x0(new_masked_activation0_0[15]), .x1(new_mask0_0[15]), .r_mask(ar0), .arith_share0(act0_0_15), .arith_share1(act0_1_15));

  boolean_arithmetic_coversion_1 conv16 (.x0(new_masked_activation1_0[0]), .x1(new_mask1_0[0]), .r_mask(ar1), .arith_share0(act1_0_0), .arith_share1(act1_1_0));
  boolean_arithmetic_coversion_1 conv17 (.x0(new_masked_activation1_0[1]), .x1(new_mask1_0[1]), .r_mask(ar1), .arith_share0(act1_0_1), .arith_share1(act1_1_1));
  boolean_arithmetic_coversion_1 conv18 (.x0(new_masked_activation1_0[2]), .x1(new_mask1_0[2]), .r_mask(ar1), .arith_share0(act1_0_2), .arith_share1(act1_1_2));
  boolean_arithmetic_coversion_1 conv19 (.x0(new_masked_activation1_0[3]), .x1(new_mask1_0[3]), .r_mask(ar1), .arith_share0(act1_0_3), .arith_share1(act1_1_3));
  boolean_arithmetic_coversion_1 conv20 (.x0(new_masked_activation1_0[4]), .x1(new_mask1_0[4]), .r_mask(ar1), .arith_share0(act1_0_4), .arith_share1(act1_1_4));
  boolean_arithmetic_coversion_1 conv21 (.x0(new_masked_activation1_0[5]), .x1(new_mask1_0[5]), .r_mask(ar1), .arith_share0(act1_0_5), .arith_share1(act1_1_5));
  boolean_arithmetic_coversion_1 conv22 (.x0(new_masked_activation1_0[6]), .x1(new_mask1_0[6]), .r_mask(ar1), .arith_share0(act1_0_6), .arith_share1(act1_1_6));
  boolean_arithmetic_coversion_1 conv23 (.x0(new_masked_activation1_0[7]), .x1(new_mask1_0[7]), .r_mask(ar1), .arith_share0(act1_0_7), .arith_share1(act1_1_7));
  boolean_arithmetic_coversion_1 conv24 (.x0(new_masked_activation1_0[8]), .x1(new_mask1_0[8]), .r_mask(ar1), .arith_share0(act1_0_8), .arith_share1(act1_1_8));
  boolean_arithmetic_coversion_1 conv25 (.x0(new_masked_activation1_0[9]), .x1(new_mask1_0[9]), .r_mask(ar1), .arith_share0(act1_0_9), .arith_share1(act1_1_9));
  boolean_arithmetic_coversion_1 conv26 (.x0(new_masked_activation1_0[10]), .x1(new_mask1_0[10]), .r_mask(ar1), .arith_share0(act1_0_10), .arith_share1(act1_1_10));
  boolean_arithmetic_coversion_1 conv27 (.x0(new_masked_activation1_0[11]), .x1(new_mask1_0[11]), .r_mask(ar1), .arith_share0(act1_0_11), .arith_share1(act1_1_11));
  boolean_arithmetic_coversion_1 conv28 (.x0(new_masked_activation1_0[12]), .x1(new_mask1_0[12]), .r_mask(ar1), .arith_share0(act1_0_12), .arith_share1(act1_1_12));
  boolean_arithmetic_coversion_1 conv29 (.x0(new_masked_activation1_0[13]), .x1(new_mask1_0[13]), .r_mask(ar1), .arith_share0(act1_0_13), .arith_share1(act1_1_13));
  boolean_arithmetic_coversion_1 conv30 (.x0(new_masked_activation1_0[14]), .x1(new_mask1_0[14]), .r_mask(ar1), .arith_share0(act1_0_14), .arith_share1(act1_1_14));
  boolean_arithmetic_coversion_1 conv31 (.x0(new_masked_activation1_0[15]), .x1(new_mask1_0[15]), .r_mask(ar1), .arith_share0(act1_0_15), .arith_share1(act1_1_15));

  boolean_arithmetic_coversion_1 conv32 (.x0(new_masked_activation2_0[0]), .x1(new_mask2_0[0]), .r_mask(ar2), .arith_share0(act2_0_0), .arith_share1(act2_1_0));
  boolean_arithmetic_coversion_1 conv33 (.x0(new_masked_activation2_0[1]), .x1(new_mask2_0[1]), .r_mask(ar2), .arith_share0(act2_0_1), .arith_share1(act2_1_1));
  boolean_arithmetic_coversion_1 conv34 (.x0(new_masked_activation2_0[2]), .x1(new_mask2_0[2]), .r_mask(ar2), .arith_share0(act2_0_2), .arith_share1(act2_1_2));
  boolean_arithmetic_coversion_1 conv35 (.x0(new_masked_activation2_0[3]), .x1(new_mask2_0[3]), .r_mask(ar2), .arith_share0(act2_0_3), .arith_share1(act2_1_3));
  boolean_arithmetic_coversion_1 conv36 (.x0(new_masked_activation2_0[4]), .x1(new_mask2_0[4]), .r_mask(ar2), .arith_share0(act2_0_4), .arith_share1(act2_1_4));
  boolean_arithmetic_coversion_1 conv37 (.x0(new_masked_activation2_0[5]), .x1(new_mask2_0[5]), .r_mask(ar2), .arith_share0(act2_0_5), .arith_share1(act2_1_5));
  boolean_arithmetic_coversion_1 conv38 (.x0(new_masked_activation2_0[6]), .x1(new_mask2_0[6]), .r_mask(ar2), .arith_share0(act2_0_6), .arith_share1(act2_1_6));
  boolean_arithmetic_coversion_1 conv39 (.x0(new_masked_activation2_0[7]), .x1(new_mask2_0[7]), .r_mask(ar2), .arith_share0(act2_0_7), .arith_share1(act2_1_7));
  boolean_arithmetic_coversion_1 conv40 (.x0(new_masked_activation2_0[8]), .x1(new_mask2_0[8]), .r_mask(ar2), .arith_share0(act2_0_8), .arith_share1(act2_1_8));
  boolean_arithmetic_coversion_1 conv41 (.x0(new_masked_activation2_0[9]), .x1(new_mask2_0[9]), .r_mask(ar2), .arith_share0(act2_0_9), .arith_share1(act2_1_9));
  boolean_arithmetic_coversion_1 conv42 (.x0(new_masked_activation2_0[10]), .x1(new_mask2_0[10]), .r_mask(ar2), .arith_share0(act2_0_10), .arith_share1(act2_1_10));
  boolean_arithmetic_coversion_1 conv43 (.x0(new_masked_activation2_0[11]), .x1(new_mask2_0[11]), .r_mask(ar2), .arith_share0(act2_0_11), .arith_share1(act2_1_11));
  boolean_arithmetic_coversion_1 conv44 (.x0(new_masked_activation2_0[12]), .x1(new_mask2_0[12]), .r_mask(ar2), .arith_share0(act2_0_12), .arith_share1(act2_1_12));
  boolean_arithmetic_coversion_1 conv45 (.x0(new_masked_activation2_0[13]), .x1(new_mask2_0[13]), .r_mask(ar2), .arith_share0(act2_0_13), .arith_share1(act2_1_13));
  boolean_arithmetic_coversion_1 conv46 (.x0(new_masked_activation2_0[14]), .x1(new_mask2_0[14]), .r_mask(ar2), .arith_share0(act2_0_14), .arith_share1(act2_1_14));
  boolean_arithmetic_coversion_1 conv47 (.x0(new_masked_activation2_0[15]), .x1(new_mask2_0[15]), .r_mask(ar2), .arith_share0(act2_0_15), .arith_share1(act2_1_15));

  boolean_arithmetic_coversion_1 conv48 (.x0(new_masked_activation3_0[0]), .x1(new_mask3_0[0]), .r_mask(ar3), .arith_share0(act3_0_0), .arith_share1(act3_1_0));
  boolean_arithmetic_coversion_1 conv49 (.x0(new_masked_activation3_0[1]), .x1(new_mask3_0[1]), .r_mask(ar3), .arith_share0(act3_0_1), .arith_share1(act3_1_1));
  boolean_arithmetic_coversion_1 conv50 (.x0(new_masked_activation3_0[2]), .x1(new_mask3_0[2]), .r_mask(ar3), .arith_share0(act3_0_2), .arith_share1(act3_1_2));
  boolean_arithmetic_coversion_1 conv51 (.x0(new_masked_activation3_0[3]), .x1(new_mask3_0[3]), .r_mask(ar3), .arith_share0(act3_0_3), .arith_share1(act3_1_3));
  boolean_arithmetic_coversion_1 conv52 (.x0(new_masked_activation3_0[4]), .x1(new_mask3_0[4]), .r_mask(ar3), .arith_share0(act3_0_4), .arith_share1(act3_1_4));
  boolean_arithmetic_coversion_1 conv53 (.x0(new_masked_activation3_0[5]), .x1(new_mask3_0[5]), .r_mask(ar3), .arith_share0(act3_0_5), .arith_share1(act3_1_5));
  boolean_arithmetic_coversion_1 conv54 (.x0(new_masked_activation3_0[6]), .x1(new_mask3_0[6]), .r_mask(ar3), .arith_share0(act3_0_6), .arith_share1(act3_1_6));
  boolean_arithmetic_coversion_1 conv55 (.x0(new_masked_activation3_0[7]), .x1(new_mask3_0[7]), .r_mask(ar3), .arith_share0(act3_0_7), .arith_share1(act3_1_7));
  boolean_arithmetic_coversion_1 conv56 (.x0(new_masked_activation3_0[8]), .x1(new_mask3_0[8]), .r_mask(ar3), .arith_share0(act3_0_8), .arith_share1(act3_1_8));
  boolean_arithmetic_coversion_1 conv57 (.x0(new_masked_activation3_0[9]), .x1(new_mask3_0[9]), .r_mask(ar3), .arith_share0(act3_0_9), .arith_share1(act3_1_9));
  boolean_arithmetic_coversion_1 conv58 (.x0(new_masked_activation3_0[10]), .x1(new_mask3_0[10]), .r_mask(ar3), .arith_share0(act3_0_10), .arith_share1(act3_1_10));
  boolean_arithmetic_coversion_1 conv59 (.x0(new_masked_activation3_0[11]), .x1(new_mask3_0[11]), .r_mask(ar3), .arith_share0(act3_0_11), .arith_share1(act3_1_11));
  boolean_arithmetic_coversion_1 conv60 (.x0(new_masked_activation3_0[12]), .x1(new_mask3_0[12]), .r_mask(ar3), .arith_share0(act3_0_12), .arith_share1(act3_1_12));
  boolean_arithmetic_coversion_1 conv61 (.x0(new_masked_activation3_0[13]), .x1(new_mask3_0[13]), .r_mask(ar3), .arith_share0(act3_0_13), .arith_share1(act3_1_13));
  boolean_arithmetic_coversion_1 conv62 (.x0(new_masked_activation3_0[14]), .x1(new_mask3_0[14]), .r_mask(ar3), .arith_share0(act3_0_14), .arith_share1(act3_1_14));
  boolean_arithmetic_coversion_1 conv63 (.x0(new_masked_activation3_0[15]), .x1(new_mask3_0[15]), .r_mask(ar3), .arith_share0(act3_0_15), .arith_share1(act3_1_15));

  boolean_arithmetic_coversion_1 conv64 (.x0(new_masked_activation4_0[0]), .x1(new_mask4_0[0]), .r_mask(ar4), .arith_share0(act4_0_0), .arith_share1(act4_1_0));
  boolean_arithmetic_coversion_1 conv65 (.x0(new_masked_activation4_0[1]), .x1(new_mask4_0[1]), .r_mask(ar4), .arith_share0(act4_0_1), .arith_share1(act4_1_1));
  boolean_arithmetic_coversion_1 conv66 (.x0(new_masked_activation4_0[2]), .x1(new_mask4_0[2]), .r_mask(ar4), .arith_share0(act4_0_2), .arith_share1(act4_1_2));
  boolean_arithmetic_coversion_1 conv67 (.x0(new_masked_activation4_0[3]), .x1(new_mask4_0[3]), .r_mask(ar4), .arith_share0(act4_0_3), .arith_share1(act4_1_3));
  boolean_arithmetic_coversion_1 conv68 (.x0(new_masked_activation4_0[4]), .x1(new_mask4_0[4]), .r_mask(ar4), .arith_share0(act4_0_4), .arith_share1(act4_1_4));
  boolean_arithmetic_coversion_1 conv69 (.x0(new_masked_activation4_0[5]), .x1(new_mask4_0[5]), .r_mask(ar4), .arith_share0(act4_0_5), .arith_share1(act4_1_5));
  boolean_arithmetic_coversion_1 conv70 (.x0(new_masked_activation4_0[6]), .x1(new_mask4_0[6]), .r_mask(ar4), .arith_share0(act4_0_6), .arith_share1(act4_1_6));
  boolean_arithmetic_coversion_1 conv71 (.x0(new_masked_activation4_0[7]), .x1(new_mask4_0[7]), .r_mask(ar4), .arith_share0(act4_0_7), .arith_share1(act4_1_7));
  boolean_arithmetic_coversion_1 conv72 (.x0(new_masked_activation4_0[8]), .x1(new_mask4_0[8]), .r_mask(ar4), .arith_share0(act4_0_8), .arith_share1(act4_1_8));
  boolean_arithmetic_coversion_1 conv73 (.x0(new_masked_activation4_0[9]), .x1(new_mask4_0[9]), .r_mask(ar4), .arith_share0(act4_0_9), .arith_share1(act4_1_9));
  boolean_arithmetic_coversion_1 conv74 (.x0(new_masked_activation4_0[10]), .x1(new_mask4_0[10]), .r_mask(ar4), .arith_share0(act4_0_10), .arith_share1(act4_1_10));
  boolean_arithmetic_coversion_1 conv75 (.x0(new_masked_activation4_0[11]), .x1(new_mask4_0[11]), .r_mask(ar4), .arith_share0(act4_0_11), .arith_share1(act4_1_11));
  boolean_arithmetic_coversion_1 conv76 (.x0(new_masked_activation4_0[12]), .x1(new_mask4_0[12]), .r_mask(ar4), .arith_share0(act4_0_12), .arith_share1(act4_1_12));
  boolean_arithmetic_coversion_1 conv77 (.x0(new_masked_activation4_0[13]), .x1(new_mask4_0[13]), .r_mask(ar4), .arith_share0(act4_0_13), .arith_share1(act4_1_13));
  boolean_arithmetic_coversion_1 conv78 (.x0(new_masked_activation4_0[14]), .x1(new_mask4_0[14]), .r_mask(ar4), .arith_share0(act4_0_14), .arith_share1(act4_1_14));
  boolean_arithmetic_coversion_1 conv79 (.x0(new_masked_activation4_0[15]), .x1(new_mask4_0[15]), .r_mask(ar4), .arith_share0(act4_0_15), .arith_share1(act4_1_15));

  boolean_arithmetic_coversion_1 conv80 (.x0(new_masked_activation5_0[0]), .x1(new_mask5_0[0]), .r_mask(ar5), .arith_share0(act5_0_0), .arith_share1(act5_1_0));
  boolean_arithmetic_coversion_1 conv81 (.x0(new_masked_activation5_0[1]), .x1(new_mask5_0[1]), .r_mask(ar5), .arith_share0(act5_0_1), .arith_share1(act5_1_1));
  boolean_arithmetic_coversion_1 conv82 (.x0(new_masked_activation5_0[2]), .x1(new_mask5_0[2]), .r_mask(ar5), .arith_share0(act5_0_2), .arith_share1(act5_1_2));
  boolean_arithmetic_coversion_1 conv83 (.x0(new_masked_activation5_0[3]), .x1(new_mask5_0[3]), .r_mask(ar5), .arith_share0(act5_0_3), .arith_share1(act5_1_3));
  boolean_arithmetic_coversion_1 conv84 (.x0(new_masked_activation5_0[4]), .x1(new_mask5_0[4]), .r_mask(ar5), .arith_share0(act5_0_4), .arith_share1(act5_1_4));
  boolean_arithmetic_coversion_1 conv85 (.x0(new_masked_activation5_0[5]), .x1(new_mask5_0[5]), .r_mask(ar5), .arith_share0(act5_0_5), .arith_share1(act5_1_5));
  boolean_arithmetic_coversion_1 conv86 (.x0(new_masked_activation5_0[6]), .x1(new_mask5_0[6]), .r_mask(ar5), .arith_share0(act5_0_6), .arith_share1(act5_1_6));
  boolean_arithmetic_coversion_1 conv87 (.x0(new_masked_activation5_0[7]), .x1(new_mask5_0[7]), .r_mask(ar5), .arith_share0(act5_0_7), .arith_share1(act5_1_7));
  boolean_arithmetic_coversion_1 conv88 (.x0(new_masked_activation5_0[8]), .x1(new_mask5_0[8]), .r_mask(ar5), .arith_share0(act5_0_8), .arith_share1(act5_1_8));
  boolean_arithmetic_coversion_1 conv89 (.x0(new_masked_activation5_0[9]), .x1(new_mask5_0[9]), .r_mask(ar5), .arith_share0(act5_0_9), .arith_share1(act5_1_9));
  boolean_arithmetic_coversion_1 conv90 (.x0(new_masked_activation5_0[10]), .x1(new_mask5_0[10]), .r_mask(ar5), .arith_share0(act5_0_10), .arith_share1(act5_1_10));
  boolean_arithmetic_coversion_1 conv91 (.x0(new_masked_activation5_0[11]), .x1(new_mask5_0[11]), .r_mask(ar5), .arith_share0(act5_0_11), .arith_share1(act5_1_11));
  boolean_arithmetic_coversion_1 conv92 (.x0(new_masked_activation5_0[12]), .x1(new_mask5_0[12]), .r_mask(ar5), .arith_share0(act5_0_12), .arith_share1(act5_1_12));
  boolean_arithmetic_coversion_1 conv93 (.x0(new_masked_activation5_0[13]), .x1(new_mask5_0[13]), .r_mask(ar5), .arith_share0(act5_0_13), .arith_share1(act5_1_13));
  boolean_arithmetic_coversion_1 conv94 (.x0(new_masked_activation5_0[14]), .x1(new_mask5_0[14]), .r_mask(ar5), .arith_share0(act5_0_14), .arith_share1(act5_1_14));
  boolean_arithmetic_coversion_1 conv95 (.x0(new_masked_activation5_0[15]), .x1(new_mask5_0[15]), .r_mask(ar5), .arith_share0(act5_0_15), .arith_share1(act5_1_15));

  boolean_arithmetic_coversion_1 conv96 (.x0(new_masked_activation6_0[0]), .x1(new_mask6_0[0]), .r_mask(ar6), .arith_share0(act6_0_0), .arith_share1(act6_1_0));
  boolean_arithmetic_coversion_1 conv97 (.x0(new_masked_activation6_0[1]), .x1(new_mask6_0[1]), .r_mask(ar6), .arith_share0(act6_0_1), .arith_share1(act6_1_1));
  boolean_arithmetic_coversion_1 conv98 (.x0(new_masked_activation6_0[2]), .x1(new_mask6_0[2]), .r_mask(ar6), .arith_share0(act6_0_2), .arith_share1(act6_1_2));
  boolean_arithmetic_coversion_1 conv99 (.x0(new_masked_activation6_0[3]), .x1(new_mask6_0[3]), .r_mask(ar6), .arith_share0(act6_0_3), .arith_share1(act6_1_3));
  boolean_arithmetic_coversion_1 conv100 (.x0(new_masked_activation6_0[4]), .x1(new_mask6_0[4]), .r_mask(ar6), .arith_share0(act6_0_4), .arith_share1(act6_1_4));
  boolean_arithmetic_coversion_1 conv101 (.x0(new_masked_activation6_0[5]), .x1(new_mask6_0[5]), .r_mask(ar6), .arith_share0(act6_0_5), .arith_share1(act6_1_5));
  boolean_arithmetic_coversion_1 conv102 (.x0(new_masked_activation6_0[6]), .x1(new_mask6_0[6]), .r_mask(ar6), .arith_share0(act6_0_6), .arith_share1(act6_1_6));
  boolean_arithmetic_coversion_1 conv103 (.x0(new_masked_activation6_0[7]), .x1(new_mask6_0[7]), .r_mask(ar6), .arith_share0(act6_0_7), .arith_share1(act6_1_7));
  boolean_arithmetic_coversion_1 conv104 (.x0(new_masked_activation6_0[8]), .x1(new_mask6_0[8]), .r_mask(ar6), .arith_share0(act6_0_8), .arith_share1(act6_1_8));
  boolean_arithmetic_coversion_1 conv105 (.x0(new_masked_activation6_0[9]), .x1(new_mask6_0[9]), .r_mask(ar6), .arith_share0(act6_0_9), .arith_share1(act6_1_9));
  boolean_arithmetic_coversion_1 conv106 (.x0(new_masked_activation6_0[10]), .x1(new_mask6_0[10]), .r_mask(ar6), .arith_share0(act6_0_10), .arith_share1(act6_1_10));
  boolean_arithmetic_coversion_1 conv107 (.x0(new_masked_activation6_0[11]), .x1(new_mask6_0[11]), .r_mask(ar6), .arith_share0(act6_0_11), .arith_share1(act6_1_11));
  boolean_arithmetic_coversion_1 conv108 (.x0(new_masked_activation6_0[12]), .x1(new_mask6_0[12]), .r_mask(ar6), .arith_share0(act6_0_12), .arith_share1(act6_1_12));
  boolean_arithmetic_coversion_1 conv109 (.x0(new_masked_activation6_0[13]), .x1(new_mask6_0[13]), .r_mask(ar6), .arith_share0(act6_0_13), .arith_share1(act6_1_13));
  boolean_arithmetic_coversion_1 conv110 (.x0(new_masked_activation6_0[14]), .x1(new_mask6_0[14]), .r_mask(ar6), .arith_share0(act6_0_14), .arith_share1(act6_1_14));
  boolean_arithmetic_coversion_1 conv111 (.x0(new_masked_activation6_0[15]), .x1(new_mask6_0[15]), .r_mask(ar6), .arith_share0(act6_0_15), .arith_share1(act6_1_15));

  boolean_arithmetic_coversion_1 conv112 (.x0(new_masked_activation7_0[0]), .x1(new_mask7_0[0]), .r_mask(ar7), .arith_share0(act7_0_0), .arith_share1(act7_1_0));
  boolean_arithmetic_coversion_1 conv113 (.x0(new_masked_activation7_0[1]), .x1(new_mask7_0[1]), .r_mask(ar7), .arith_share0(act7_0_1), .arith_share1(act7_1_1));
  boolean_arithmetic_coversion_1 conv114 (.x0(new_masked_activation7_0[2]), .x1(new_mask7_0[2]), .r_mask(ar7), .arith_share0(act7_0_2), .arith_share1(act7_1_2));
  boolean_arithmetic_coversion_1 conv115 (.x0(new_masked_activation7_0[3]), .x1(new_mask7_0[3]), .r_mask(ar7), .arith_share0(act7_0_3), .arith_share1(act7_1_3));
  boolean_arithmetic_coversion_1 conv116 (.x0(new_masked_activation7_0[4]), .x1(new_mask7_0[4]), .r_mask(ar7), .arith_share0(act7_0_4), .arith_share1(act7_1_4));
  boolean_arithmetic_coversion_1 conv117 (.x0(new_masked_activation7_0[5]), .x1(new_mask7_0[5]), .r_mask(ar7), .arith_share0(act7_0_5), .arith_share1(act7_1_5));
  boolean_arithmetic_coversion_1 conv118 (.x0(new_masked_activation7_0[6]), .x1(new_mask7_0[6]), .r_mask(ar7), .arith_share0(act7_0_6), .arith_share1(act7_1_6));
  boolean_arithmetic_coversion_1 conv119 (.x0(new_masked_activation7_0[7]), .x1(new_mask7_0[7]), .r_mask(ar7), .arith_share0(act7_0_7), .arith_share1(act7_1_7));
  boolean_arithmetic_coversion_1 conv120 (.x0(new_masked_activation7_0[8]), .x1(new_mask7_0[8]), .r_mask(ar7), .arith_share0(act7_0_8), .arith_share1(act7_1_8));
  boolean_arithmetic_coversion_1 conv121 (.x0(new_masked_activation7_0[9]), .x1(new_mask7_0[9]), .r_mask(ar7), .arith_share0(act7_0_9), .arith_share1(act7_1_9));
  boolean_arithmetic_coversion_1 conv122 (.x0(new_masked_activation7_0[10]), .x1(new_mask7_0[10]), .r_mask(ar7), .arith_share0(act7_0_10), .arith_share1(act7_1_10));
  boolean_arithmetic_coversion_1 conv123 (.x0(new_masked_activation7_0[11]), .x1(new_mask7_0[11]), .r_mask(ar7), .arith_share0(act7_0_11), .arith_share1(act7_1_11));
  boolean_arithmetic_coversion_1 conv124 (.x0(new_masked_activation7_0[12]), .x1(new_mask7_0[12]), .r_mask(ar7), .arith_share0(act7_0_12), .arith_share1(act7_1_12));
  boolean_arithmetic_coversion_1 conv125 (.x0(new_masked_activation7_0[13]), .x1(new_mask7_0[13]), .r_mask(ar7), .arith_share0(act7_0_13), .arith_share1(act7_1_13));
  boolean_arithmetic_coversion_1 conv126 (.x0(new_masked_activation7_0[14]), .x1(new_mask7_0[14]), .r_mask(ar7), .arith_share0(act7_0_14), .arith_share1(act7_1_14));
  boolean_arithmetic_coversion_1 conv127 (.x0(new_masked_activation7_0[15]), .x1(new_mask7_0[15]), .r_mask(ar7), .arith_share0(act7_0_15), .arith_share1(act7_1_15));

  // snapshot into registers
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      done <= 1'b0;
        act0_0_0_r <= 3'd0 ;
        act0_0_1_r <= 3'd0 ;
        act0_0_2_r <= 3'd0 ;
        act0_0_3_r <= 3'd0 ;
        act0_0_4_r <= 3'd0 ;
        act0_0_5_r <= 3'd0 ;
        act0_0_6_r <= 3'd0 ;
        act0_0_7_r <= 3'd0 ;
        act0_0_8_r <= 3'd0 ;
        act0_0_9_r <= 3'd0 ;
        act0_0_10_r <= 3'd0 ;
        act0_0_11_r <= 3'd0 ;
        act0_0_12_r <= 3'd0 ;
        act0_0_13_r <= 3'd0 ;
        act0_0_14_r <= 3'd0 ;
        act0_0_15_r <= 3'd0 ;
        act0_1_0_r <= 3'd0 ;
        act0_1_1_r <= 3'd0 ;
        act0_1_2_r <= 3'd0 ;
        act0_1_3_r <= 3'd0 ;
        act0_1_4_r <= 3'd0 ;
        act0_1_5_r <= 3'd0 ;
        act0_1_6_r <= 3'd0 ;
        act0_1_7_r <= 3'd0 ;
        act0_1_8_r <= 3'd0 ;
        act0_1_9_r <= 3'd0 ;
        act0_1_10_r <= 3'd0 ;
        act0_1_11_r <= 3'd0 ;
        act0_1_12_r <= 3'd0 ;
        act0_1_13_r <= 3'd0 ;
        act0_1_14_r <= 3'd0 ;
        act0_1_15_r <= 3'd0 ;
        act1_0_0_r <= 3'd0 ;
        act1_0_1_r <= 3'd0 ;
        act1_0_2_r <= 3'd0 ;
        act1_0_3_r <= 3'd0 ;
        act1_0_4_r <= 3'd0 ;
        act1_0_5_r <= 3'd0 ;
        act1_0_6_r <= 3'd0 ;
        act1_0_7_r <= 3'd0 ;
        act1_0_8_r <= 3'd0 ;
        act1_0_9_r <= 3'd0 ;
        act1_0_10_r <= 3'd0 ;
        act1_0_11_r <= 3'd0 ;
        act1_0_12_r <= 3'd0 ;
        act1_0_13_r <= 3'd0 ;
        act1_0_14_r <= 3'd0 ;
        act1_0_15_r <= 3'd0 ;
        act1_1_0_r <= 3'd0 ;
        act1_1_1_r <= 3'd0 ;
        act1_1_2_r <= 3'd0 ;
        act1_1_3_r <= 3'd0 ;
        act1_1_4_r <= 3'd0 ;
        act1_1_5_r <= 3'd0 ;
        act1_1_6_r <= 3'd0 ;
        act1_1_7_r <= 3'd0 ;
        act1_1_8_r <= 3'd0 ;
        act1_1_9_r <= 3'd0 ;
        act1_1_10_r <= 3'd0 ;
        act1_1_11_r <= 3'd0 ;
        act1_1_12_r <= 3'd0 ;
        act1_1_13_r <= 3'd0 ;
        act1_1_14_r <= 3'd0 ;
        act1_1_15_r <= 3'd0 ;
        act2_0_0_r <= 3'd0 ;
        act2_0_1_r <= 3'd0 ;
        act2_0_2_r <= 3'd0 ;
        act2_0_3_r <= 3'd0 ;
        act2_0_4_r <= 3'd0 ;
        act2_0_5_r <= 3'd0 ;
        act2_0_6_r <= 3'd0 ;
        act2_0_7_r <= 3'd0 ;
        act2_0_8_r <= 3'd0 ;
        act2_0_9_r <= 3'd0 ;
        act2_0_10_r <= 3'd0 ;
        act2_0_11_r <= 3'd0 ;
        act2_0_12_r <= 3'd0 ;
        act2_0_13_r <= 3'd0 ;
        act2_0_14_r <= 3'd0 ;
        act2_0_15_r <= 3'd0 ;
        act2_1_0_r <= 3'd0 ;
        act2_1_1_r <= 3'd0 ;
        act2_1_2_r <= 3'd0 ;
        act2_1_3_r <= 3'd0 ;
        act2_1_4_r <= 3'd0 ;
        act2_1_5_r <= 3'd0 ;
        act2_1_6_r <= 3'd0 ;
        act2_1_7_r <= 3'd0 ;
        act2_1_8_r <= 3'd0 ;
        act2_1_9_r <= 3'd0 ;
        act2_1_10_r <= 3'd0 ;
        act2_1_11_r <= 3'd0 ;
        act2_1_12_r <= 3'd0 ;
        act2_1_13_r <= 3'd0 ;
        act2_1_14_r <= 3'd0 ;
        act2_1_15_r <= 3'd0 ;
        act3_0_0_r <= 3'd0 ;
        act3_0_1_r <= 3'd0 ;
        act3_0_2_r <= 3'd0 ;
        act3_0_3_r <= 3'd0 ;
        act3_0_4_r <= 3'd0 ;
        act3_0_5_r <= 3'd0 ;
        act3_0_6_r <= 3'd0 ;
        act3_0_7_r <= 3'd0 ;
        act3_0_8_r <= 3'd0 ;
        act3_0_9_r <= 3'd0 ;
        act3_0_10_r <= 3'd0 ;
        act3_0_11_r <= 3'd0 ;
        act3_0_12_r <= 3'd0 ;
        act3_0_13_r <= 3'd0 ;
        act3_0_14_r <= 3'd0 ;
        act3_0_15_r <= 3'd0 ;
        act3_1_0_r <= 3'd0 ;
        act3_1_1_r <= 3'd0 ;
        act3_1_2_r <= 3'd0 ;
        act3_1_3_r <= 3'd0 ;
        act3_1_4_r <= 3'd0 ;
        act3_1_5_r <= 3'd0 ;
        act3_1_6_r <= 3'd0 ;
        act3_1_7_r <= 3'd0 ;
        act3_1_8_r <= 3'd0 ;
        act3_1_9_r <= 3'd0 ;
        act3_1_10_r <= 3'd0 ;
        act3_1_11_r <= 3'd0 ;
        act3_1_12_r <= 3'd0 ;
        act3_1_13_r <= 3'd0 ;
        act3_1_14_r <= 3'd0 ;
        act3_1_15_r <= 3'd0 ;
        act4_0_0_r <= 3'd0 ;
        act4_0_1_r <= 3'd0 ;
        act4_0_2_r <= 3'd0 ;
        act4_0_3_r <= 3'd0 ;
        act4_0_4_r <= 3'd0 ;
        act4_0_5_r <= 3'd0 ;
        act4_0_6_r <= 3'd0 ;
        act4_0_7_r <= 3'd0 ;
        act4_0_8_r <= 3'd0 ;
        act4_0_9_r <= 3'd0 ;
        act4_0_10_r <= 3'd0 ;
        act4_0_11_r <= 3'd0 ;
        act4_0_12_r <= 3'd0 ;
        act4_0_13_r <= 3'd0 ;
        act4_0_14_r <= 3'd0 ;
        act4_0_15_r <= 3'd0 ;
        act4_1_0_r <= 3'd0 ;
        act4_1_1_r <= 3'd0 ;
        act4_1_2_r <= 3'd0 ;
        act4_1_3_r <= 3'd0 ;
        act4_1_4_r <= 3'd0 ;
        act4_1_5_r <= 3'd0 ;
        act4_1_6_r <= 3'd0 ;
        act4_1_7_r <= 3'd0 ;
        act4_1_8_r <= 3'd0 ;
        act4_1_9_r <= 3'd0 ;
        act4_1_10_r <= 3'd0 ;
        act4_1_11_r <= 3'd0 ;
        act4_1_12_r <= 3'd0 ;
        act4_1_13_r <= 3'd0 ;
        act4_1_14_r <= 3'd0 ;
        act4_1_15_r <= 3'd0 ;
        act5_0_0_r <= 3'd0 ;
        act5_0_1_r <= 3'd0 ;
        act5_0_2_r <= 3'd0 ;
        act5_0_3_r <= 3'd0 ;
        act5_0_4_r <= 3'd0 ;
        act5_0_5_r <= 3'd0 ;
        act5_0_6_r <= 3'd0 ;
        act5_0_7_r <= 3'd0 ;
        act5_0_8_r <= 3'd0 ;
        act5_0_9_r <= 3'd0 ;
        act5_0_10_r <= 3'd0 ;
        act5_0_11_r <= 3'd0 ;
        act5_0_12_r <= 3'd0 ;
        act5_0_13_r <= 3'd0 ;
        act5_0_14_r <= 3'd0 ;
        act5_0_15_r <= 3'd0 ;
        act5_1_0_r <= 3'd0 ;
        act5_1_1_r <= 3'd0 ;
        act5_1_2_r <= 3'd0 ;
        act5_1_3_r <= 3'd0 ;
        act5_1_4_r <= 3'd0 ;
        act5_1_5_r <= 3'd0 ;
        act5_1_6_r <= 3'd0 ;
        act5_1_7_r <= 3'd0 ;
        act5_1_8_r <= 3'd0 ;
        act5_1_9_r <= 3'd0 ;
        act5_1_10_r <= 3'd0 ;
        act5_1_11_r <= 3'd0 ;
        act5_1_12_r <= 3'd0 ;
        act5_1_13_r <= 3'd0 ;
        act5_1_14_r <= 3'd0 ;
        act5_1_15_r <= 3'd0 ;
        act6_0_0_r <= 3'd0 ;
        act6_0_1_r <= 3'd0 ;
        act6_0_2_r <= 3'd0 ;
        act6_0_3_r <= 3'd0 ;
        act6_0_4_r <= 3'd0 ;
        act6_0_5_r <= 3'd0 ;
        act6_0_6_r <= 3'd0 ;
        act6_0_7_r <= 3'd0 ;
        act6_0_8_r <= 3'd0 ;
        act6_0_9_r <= 3'd0 ;
        act6_0_10_r <= 3'd0 ;
        act6_0_11_r <= 3'd0 ;
        act6_0_12_r <= 3'd0 ;
        act6_0_13_r <= 3'd0 ;
        act6_0_14_r <= 3'd0 ;
        act6_0_15_r <= 3'd0 ;
        act6_1_0_r <= 3'd0 ;
        act6_1_1_r <= 3'd0 ;
        act6_1_2_r <= 3'd0 ;
        act6_1_3_r <= 3'd0 ;
        act6_1_4_r <= 3'd0 ;
        act6_1_5_r <= 3'd0 ;
        act6_1_6_r <= 3'd0 ;
        act6_1_7_r <= 3'd0 ;
        act6_1_8_r <= 3'd0 ;
        act6_1_9_r <= 3'd0 ;
        act6_1_10_r <= 3'd0 ;
        act6_1_11_r <= 3'd0 ;
        act6_1_12_r <= 3'd0 ;
        act6_1_13_r <= 3'd0 ;
        act6_1_14_r <= 3'd0 ;
        act6_1_15_r <= 3'd0 ;
        act7_0_0_r <= 3'd0 ;
        act7_0_1_r <= 3'd0 ;
        act7_0_2_r <= 3'd0 ;
        act7_0_3_r <= 3'd0 ;
        act7_0_4_r <= 3'd0 ;
        act7_0_5_r <= 3'd0 ;
        act7_0_6_r <= 3'd0 ;
        act7_0_7_r <= 3'd0 ;
        act7_0_8_r <= 3'd0 ;
        act7_0_9_r <= 3'd0 ;
        act7_0_10_r <= 3'd0 ;
        act7_0_11_r <= 3'd0 ;
        act7_0_12_r <= 3'd0 ;
        act7_0_13_r <= 3'd0 ;
        act7_0_14_r <= 3'd0 ;
        act7_0_15_r <= 3'd0 ;
        act7_1_0_r <= 3'd0 ;
        act7_1_1_r <= 3'd0 ;
        act7_1_2_r <= 3'd0 ;
        act7_1_3_r <= 3'd0 ;
        act7_1_4_r <= 3'd0 ;
        act7_1_5_r <= 3'd0 ;
        act7_1_6_r <= 3'd0 ;
        act7_1_7_r <= 3'd0 ;
        act7_1_8_r <= 3'd0 ;
        act7_1_9_r <= 3'd0 ;
        act7_1_10_r <= 3'd0 ;
        act7_1_11_r <= 3'd0 ;
        act7_1_12_r <= 3'd0 ;
        act7_1_13_r <= 3'd0 ;
        act7_1_14_r <= 3'd0 ;
        act7_1_15_r <= 3'd0 ;
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
        act0_0_8_r <= act0_0_8 ;
        act0_0_9_r <= act0_0_9 ;
        act0_0_10_r <= act0_0_10 ;
        act0_0_11_r <= act0_0_11 ;
        act0_0_12_r <= act0_0_12 ;
        act0_0_13_r <= act0_0_13 ;
        act0_0_14_r <= act0_0_14 ;
        act0_0_15_r <= act0_0_15 ;
        act0_1_0_r <= act0_1_0 ;
        act0_1_1_r <= act0_1_1 ;
        act0_1_2_r <= act0_1_2 ;
        act0_1_3_r <= act0_1_3 ;
        act0_1_4_r <= act0_1_4 ;
        act0_1_5_r <= act0_1_5 ;
        act0_1_6_r <= act0_1_6 ;
        act0_1_7_r <= act0_1_7 ;
        act0_1_8_r <= act0_1_8 ;
        act0_1_9_r <= act0_1_9 ;
        act0_1_10_r <= act0_1_10 ;
        act0_1_11_r <= act0_1_11 ;
        act0_1_12_r <= act0_1_12 ;
        act0_1_13_r <= act0_1_13 ;
        act0_1_14_r <= act0_1_14 ;
        act0_1_15_r <= act0_1_15 ;
        act1_0_0_r <= act1_0_0 ;
        act1_0_1_r <= act1_0_1 ;
        act1_0_2_r <= act1_0_2 ;
        act1_0_3_r <= act1_0_3 ;
        act1_0_4_r <= act1_0_4 ;
        act1_0_5_r <= act1_0_5 ;
        act1_0_6_r <= act1_0_6 ;
        act1_0_7_r <= act1_0_7 ;
        act1_0_8_r <= act1_0_8 ;
        act1_0_9_r <= act1_0_9 ;
        act1_0_10_r <= act1_0_10 ;
        act1_0_11_r <= act1_0_11 ;
        act1_0_12_r <= act1_0_12 ;
        act1_0_13_r <= act1_0_13 ;
        act1_0_14_r <= act1_0_14 ;
        act1_0_15_r <= act1_0_15 ;
        act1_1_0_r <= act1_1_0 ;
        act1_1_1_r <= act1_1_1 ;
        act1_1_2_r <= act1_1_2 ;
        act1_1_3_r <= act1_1_3 ;
        act1_1_4_r <= act1_1_4 ;
        act1_1_5_r <= act1_1_5 ;
        act1_1_6_r <= act1_1_6 ;
        act1_1_7_r <= act1_1_7 ;
        act1_1_8_r <= act1_1_8 ;
        act1_1_9_r <= act1_1_9 ;
        act1_1_10_r <= act1_1_10 ;
        act1_1_11_r <= act1_1_11 ;
        act1_1_12_r <= act1_1_12 ;
        act1_1_13_r <= act1_1_13 ;
        act1_1_14_r <= act1_1_14 ;
        act1_1_15_r <= act1_1_15 ;
        act2_0_0_r <= act2_0_0 ;
        act2_0_1_r <= act2_0_1 ;
        act2_0_2_r <= act2_0_2 ;
        act2_0_3_r <= act2_0_3 ;
        act2_0_4_r <= act2_0_4 ;
        act2_0_5_r <= act2_0_5 ;
        act2_0_6_r <= act2_0_6 ;
        act2_0_7_r <= act2_0_7 ;
        act2_0_8_r <= act2_0_8 ;
        act2_0_9_r <= act2_0_9 ;
        act2_0_10_r <= act2_0_10 ;
        act2_0_11_r <= act2_0_11 ;
        act2_0_12_r <= act2_0_12 ;
        act2_0_13_r <= act2_0_13 ;
        act2_0_14_r <= act2_0_14 ;
        act2_0_15_r <= act2_0_15 ;
        act2_1_0_r <= act2_1_0 ;
        act2_1_1_r <= act2_1_1 ;
        act2_1_2_r <= act2_1_2 ;
        act2_1_3_r <= act2_1_3 ;
        act2_1_4_r <= act2_1_4 ;
        act2_1_5_r <= act2_1_5 ;
        act2_1_6_r <= act2_1_6 ;
        act2_1_7_r <= act2_1_7 ;
        act2_1_8_r <= act2_1_8 ;
        act2_1_9_r <= act2_1_9 ;
        act2_1_10_r <= act2_1_10 ;
        act2_1_11_r <= act2_1_11 ;
        act2_1_12_r <= act2_1_12 ;
        act2_1_13_r <= act2_1_13 ;
        act2_1_14_r <= act2_1_14 ;
        act2_1_15_r <= act2_1_15 ;
        act3_0_0_r <= act3_0_0 ;
        act3_0_1_r <= act3_0_1 ;
        act3_0_2_r <= act3_0_2 ;
        act3_0_3_r <= act3_0_3 ;
        act3_0_4_r <= act3_0_4 ;
        act3_0_5_r <= act3_0_5 ;
        act3_0_6_r <= act3_0_6 ;
        act3_0_7_r <= act3_0_7 ;
        act3_0_8_r <= act3_0_8 ;
        act3_0_9_r <= act3_0_9 ;
        act3_0_10_r <= act3_0_10 ;
        act3_0_11_r <= act3_0_11 ;
        act3_0_12_r <= act3_0_12 ;
        act3_0_13_r <= act3_0_13 ;
        act3_0_14_r <= act3_0_14 ;
        act3_0_15_r <= act3_0_15 ;
        act3_1_0_r <= act3_1_0 ;
        act3_1_1_r <= act3_1_1 ;
        act3_1_2_r <= act3_1_2 ;
        act3_1_3_r <= act3_1_3 ;
        act3_1_4_r <= act3_1_4 ;
        act3_1_5_r <= act3_1_5 ;
        act3_1_6_r <= act3_1_6 ;
        act3_1_7_r <= act3_1_7 ;
        act3_1_8_r <= act3_1_8 ;
        act3_1_9_r <= act3_1_9 ;
        act3_1_10_r <= act3_1_10 ;
        act3_1_11_r <= act3_1_11 ;
        act3_1_12_r <= act3_1_12 ;
        act3_1_13_r <= act3_1_13 ;
        act3_1_14_r <= act3_1_14 ;
        act3_1_15_r <= act3_1_15 ;
        act4_0_0_r <= act4_0_0 ;
        act4_0_1_r <= act4_0_1 ;
        act4_0_2_r <= act4_0_2 ;
        act4_0_3_r <= act4_0_3 ;
        act4_0_4_r <= act4_0_4 ;
        act4_0_5_r <= act4_0_5 ;
        act4_0_6_r <= act4_0_6 ;
        act4_0_7_r <= act4_0_7 ;
        act4_0_8_r <= act4_0_8 ;
        act4_0_9_r <= act4_0_9 ;
        act4_0_10_r <= act4_0_10 ;
        act4_0_11_r <= act4_0_11 ;
        act4_0_12_r <= act4_0_12 ;
        act4_0_13_r <= act4_0_13 ;
        act4_0_14_r <= act4_0_14 ;
        act4_0_15_r <= act4_0_15 ;
        act4_1_0_r <= act4_1_0 ;
        act4_1_1_r <= act4_1_1 ;
        act4_1_2_r <= act4_1_2 ;
        act4_1_3_r <= act4_1_3 ;
        act4_1_4_r <= act4_1_4 ;
        act4_1_5_r <= act4_1_5 ;
        act4_1_6_r <= act4_1_6 ;
        act4_1_7_r <= act4_1_7 ;
        act4_1_8_r <= act4_1_8 ;
        act4_1_9_r <= act4_1_9 ;
        act4_1_10_r <= act4_1_10 ;
        act4_1_11_r <= act4_1_11 ;
        act4_1_12_r <= act4_1_12 ;
        act4_1_13_r <= act4_1_13 ;
        act4_1_14_r <= act4_1_14 ;
        act4_1_15_r <= act4_1_15 ;
        act5_0_0_r <= act5_0_0 ;
        act5_0_1_r <= act5_0_1 ;
        act5_0_2_r <= act5_0_2 ;
        act5_0_3_r <= act5_0_3 ;
        act5_0_4_r <= act5_0_4 ;
        act5_0_5_r <= act5_0_5 ;
        act5_0_6_r <= act5_0_6 ;
        act5_0_7_r <= act5_0_7 ;
        act5_0_8_r <= act5_0_8 ;
        act5_0_9_r <= act5_0_9 ;
        act5_0_10_r <= act5_0_10 ;
        act5_0_11_r <= act5_0_11 ;
        act5_0_12_r <= act5_0_12 ;
        act5_0_13_r <= act5_0_13 ;
        act5_0_14_r <= act5_0_14 ;
        act5_0_15_r <= act5_0_15 ;
        act5_1_0_r <= act5_1_0 ;
        act5_1_1_r <= act5_1_1 ;
        act5_1_2_r <= act5_1_2 ;
        act5_1_3_r <= act5_1_3 ;
        act5_1_4_r <= act5_1_4 ;
        act5_1_5_r <= act5_1_5 ;
        act5_1_6_r <= act5_1_6 ;
        act5_1_7_r <= act5_1_7 ;
        act5_1_8_r <= act5_1_8 ;
        act5_1_9_r <= act5_1_9 ;
        act5_1_10_r <= act5_1_10 ;
        act5_1_11_r <= act5_1_11 ;
        act5_1_12_r <= act5_1_12 ;
        act5_1_13_r <= act5_1_13 ;
        act5_1_14_r <= act5_1_14 ;
        act5_1_15_r <= act5_1_15 ;
        act6_0_0_r <= act6_0_0 ;
        act6_0_1_r <= act6_0_1 ;
        act6_0_2_r <= act6_0_2 ;
        act6_0_3_r <= act6_0_3 ;
        act6_0_4_r <= act6_0_4 ;
        act6_0_5_r <= act6_0_5 ;
        act6_0_6_r <= act6_0_6 ;
        act6_0_7_r <= act6_0_7 ;
        act6_0_8_r <= act6_0_8 ;
        act6_0_9_r <= act6_0_9 ;
        act6_0_10_r <= act6_0_10 ;
        act6_0_11_r <= act6_0_11 ;
        act6_0_12_r <= act6_0_12 ;
        act6_0_13_r <= act6_0_13 ;
        act6_0_14_r <= act6_0_14 ;
        act6_0_15_r <= act6_0_15 ;
        act6_1_0_r <= act6_1_0 ;
        act6_1_1_r <= act6_1_1 ;
        act6_1_2_r <= act6_1_2 ;
        act6_1_3_r <= act6_1_3 ;
        act6_1_4_r <= act6_1_4 ;
        act6_1_5_r <= act6_1_5 ;
        act6_1_6_r <= act6_1_6 ;
        act6_1_7_r <= act6_1_7 ;
        act6_1_8_r <= act6_1_8 ;
        act6_1_9_r <= act6_1_9 ;
        act6_1_10_r <= act6_1_10 ;
        act6_1_11_r <= act6_1_11 ;
        act6_1_12_r <= act6_1_12 ;
        act6_1_13_r <= act6_1_13 ;
        act6_1_14_r <= act6_1_14 ;
        act6_1_15_r <= act6_1_15 ;
        act7_0_0_r <= act7_0_0 ;
        act7_0_1_r <= act7_0_1 ;
        act7_0_2_r <= act7_0_2 ;
        act7_0_3_r <= act7_0_3 ;
        act7_0_4_r <= act7_0_4 ;
        act7_0_5_r <= act7_0_5 ;
        act7_0_6_r <= act7_0_6 ;
        act7_0_7_r <= act7_0_7 ;
        act7_0_8_r <= act7_0_8 ;
        act7_0_9_r <= act7_0_9 ;
        act7_0_10_r <= act7_0_10 ;
        act7_0_11_r <= act7_0_11 ;
        act7_0_12_r <= act7_0_12 ;
        act7_0_13_r <= act7_0_13 ;
        act7_0_14_r <= act7_0_14 ;
        act7_0_15_r <= act7_0_15 ;
        act7_1_0_r <= act7_1_0 ;
        act7_1_1_r <= act7_1_1 ;
        act7_1_2_r <= act7_1_2 ;
        act7_1_3_r <= act7_1_3 ;
        act7_1_4_r <= act7_1_4 ;
        act7_1_5_r <= act7_1_5 ;
        act7_1_6_r <= act7_1_6 ;
        act7_1_7_r <= act7_1_7 ;
        act7_1_8_r <= act7_1_8 ;
        act7_1_9_r <= act7_1_9 ;
        act7_1_10_r <= act7_1_10 ;
        act7_1_11_r <= act7_1_11 ;
        act7_1_12_r <= act7_1_12 ;
        act7_1_13_r <= act7_1_13 ;
        act7_1_14_r <= act7_1_14 ;
        act7_1_15_r <= act7_1_15 ;
        done <= 1'b1;
      end else begin
        done <= 1'b0;
      end
    end
  end
endmodule
module subtractor (
    input  wire signed [7:0] A,
    input  wire signed [7:0] B,
    output wire signed [8:0] Result
);
    assign Result = A - B;
endmodule

module comparator_1 (
    input  wire [8:0] inputs0_0,
    input  wire [8:0] inputs0_1,
    input  wire r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0,
    output wire comparator
);
    // internal r_out chain
    wire r1 , r2 , r3 , r4 , r5 , r6 , r7 , r8 , r9;
    wire masked_c0_0 , masked_c1_0 , masked_c2_0 , masked_c3_0 , masked_c4_0 , masked_c5_0 , masked_c6_0 , masked_c7_0 , masked_c8_0;

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

    wire carry = r9 ^ masked_c8_0;
    // final compare: if carry ^ inputs0_0[N-1] ^ inputs0_1[N-1] == 0 → comparator = 1
    assign comparator = (carry ^ inputs0_0[8] ^ inputs0_1[8]) ? 1'b0 : 1'b1;
endmodule


module output_layer (
  input  wire clk,
  input  wire [7:0] biased_sum0_0,
  input  wire [7:0] biased_sum0_1,
  input  wire [7:0] biased_sum0_0bar,
  input  wire [7:0] biased_sum0_1bar,
  input  wire [7:0] biased_sum1_0,
  input  wire [7:0] biased_sum1_1,
  input  wire [7:0] biased_sum1_0bar,
  input  wire [7:0] biased_sum1_1bar,
  input  wire [7:0] biased_sum2_0,
  input  wire [7:0] biased_sum2_1,
  input  wire [7:0] biased_sum2_0bar,
  input  wire [7:0] biased_sum2_1bar,
  input  wire [7:0] biased_sum3_0,
  input  wire [7:0] biased_sum3_1,
  input  wire [7:0] biased_sum3_0bar,
  input  wire [7:0] biased_sum3_1bar,
    output reg  a0, a0_bar,
    output reg  a1, a1_bar,
    output reg  a2, a2_bar,
    output reg  a3, a3_bar
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
    reg r7_1;
    reg r7_1bar;
    reg r8_1;
    reg r8_1bar;
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
    reg r7_2;
    reg r7_2bar;
    reg r8_2;
    reg r8_2bar;

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
     r0_1= $random;
     r0_1bar = $random;
     r1_1= $random;
     r1_1bar = $random;
     r2_1= $random;
     r2_1bar = $random;
     r3_1= $random;
     r3_1bar = $random;
     r4_1= $random;
     r4_1bar = $random;
     r5_1= $random;
     r5_1bar = $random;
     r6_1= $random;
     r6_1bar = $random;
     r7_1= $random;
     r7_1bar = $random;
     r8_1= $random;
     r8_1bar = $random;
     r0_2= $random;
     r0_2bar = $random;
     r1_2= $random;
     r1_2bar = $random;
     r2_2= $random;
     r2_2bar = $random;
     r3_2= $random;
     r3_2bar = $random;
     r4_2= $random;
     r4_2bar = $random;
     r5_2= $random;
     r5_2bar = $random;
     r6_2= $random;
     r6_2bar = $random;
     r7_2= $random;
     r7_2bar = $random;
     r8_2= $random;
     r8_2bar = $random;
    #1;
  end

    wire [8:0] temp0_0, temp0_1, temp0_0bar, temp0_1bar;
    subtractor s0a (.A(biased_sum0_0), .B(biased_sum1_0), .Result(temp0_0));
    subtractor s0b (.A(biased_sum0_1), .B(biased_sum1_1), .Result(temp0_1));
    subtractor s0abar (.A(biased_sum0_0bar), .B(biased_sum1_0bar), .Result(temp0_0bar));
    subtractor s0bbar (.A(biased_sum0_1bar), .B(biased_sum1_1bar), .Result(temp0_1bar));
    wire comp0, comp0_bar;
    comparator_1 c0 (
        .inputs0_0(temp0_0), .inputs0_1(temp0_1),
        .r0_0(r0_0), .r1_0(r1_0), .r2_0(r2_0), .r3_0(r3_0), .r4_0(r4_0), .r5_0(r5_0), .r6_0(r6_0), .r7_0(r7_0), .r8_0(r8_0),
        .comparator(comp0)
    );
    comparator_1 c0_bar (
        .inputs0_0(temp0_0bar), .inputs0_1(temp0_1bar),
        .r0_0(r0_0bar), .r1_0(r1_0bar), .r2_0(r2_0bar), .r3_0(r3_0bar), .r4_0(r4_0bar), .r5_0(r5_0bar), .r6_0(r6_0bar), .r7_0(r7_0bar), .r8_0(r8_0bar),
        .comparator(comp0_bar)
    );
    reg [7:0] stage1_0_0, stage1_0_1, stage1_0_0bar, stage1_0_1bar;
    always @(posedge clk) begin
        if (comp0)      begin stage1_0_0 <= biased_sum0_0;    stage1_0_1 <= biased_sum0_1;    end
        else                    begin stage1_0_0 <= biased_sum1_0;    stage1_0_1 <= biased_sum1_1;    end
        if (comp0_bar)  begin stage1_0_0bar <= biased_sum0_0bar; stage1_0_1bar <= biased_sum0_1bar; end
        else                    begin stage1_0_0bar <= biased_sum1_0bar; stage1_0_1bar <= biased_sum1_1bar; end
    end

    wire [8:0] temp1_0, temp1_1, temp1_0bar, temp1_1bar;
    subtractor s1a (.A(biased_sum2_0), .B(biased_sum3_0), .Result(temp1_0));
    subtractor s1b (.A(biased_sum2_1), .B(biased_sum3_1), .Result(temp1_1));
    subtractor s1abar (.A(biased_sum2_0bar), .B(biased_sum3_0bar), .Result(temp1_0bar));
    subtractor s1bbar (.A(biased_sum2_1bar), .B(biased_sum3_1bar), .Result(temp1_1bar));
    wire comp1, comp1_bar;
    comparator_1 c1 (
        .inputs0_0(temp1_0), .inputs0_1(temp1_1),
        .r0_0(r0_1), .r1_0(r1_1), .r2_0(r2_1), .r3_0(r3_1), .r4_0(r4_1), .r5_0(r5_1), .r6_0(r6_1), .r7_0(r7_1), .r8_0(r8_1),
        .comparator(comp1)
    );
    comparator_1 c1_bar (
        .inputs0_0(temp1_0bar), .inputs0_1(temp1_1bar),
        .r0_0(r0_1bar), .r1_0(r1_1bar), .r2_0(r2_1bar), .r3_0(r3_1bar), .r4_0(r4_1bar), .r5_0(r5_1bar), .r6_0(r6_1bar), .r7_0(r7_1bar), .r8_0(r8_1bar),
        .comparator(comp1_bar)
    );
    reg [7:0] stage1_1_0, stage1_1_1, stage1_1_0bar, stage1_1_1bar;
    always @(posedge clk) begin
        if (comp1)      begin stage1_1_0 <= biased_sum2_0;    stage1_1_1 <= biased_sum2_1;    end
        else                    begin stage1_1_0 <= biased_sum3_0;    stage1_1_1 <= biased_sum3_1;    end
        if (comp1_bar)  begin stage1_1_0bar <= biased_sum2_0bar; stage1_1_1bar <= biased_sum2_1bar; end
        else                    begin stage1_1_0bar <= biased_sum3_0bar; stage1_1_1bar <= biased_sum3_1bar; end
    end

    wire [8:0] temp2_0, temp2_1, temp2_0bar, temp2_1bar;
    subtractor s2a (.A(stage1_0_0), .B(stage1_1_0), .Result(temp2_0));
    subtractor s2b (.A(stage1_0_1), .B(stage1_1_1), .Result(temp2_1));
    subtractor s2abar (.A(stage1_0_0bar), .B(stage1_1_0bar), .Result(temp2_0bar));
    subtractor s2bbar (.A(stage1_0_1bar), .B(stage1_1_1bar), .Result(temp2_1bar));
    wire comp2, comp2_bar;
    comparator_1 c2 (
        .inputs0_0(temp2_0), .inputs0_1(temp2_1),
        .r0_0(r0_2), .r1_0(r1_2), .r2_0(r2_2), .r3_0(r3_2), .r4_0(r4_2), .r5_0(r5_2), .r6_0(r6_2), .r7_0(r7_2), .r8_0(r8_2),
        .comparator(comp2)
    );
    comparator_1 c2_bar (
        .inputs0_0(temp2_0bar), .inputs0_1(temp2_1bar),
        .r0_0(r0_2bar), .r1_0(r1_2bar), .r2_0(r2_2bar), .r3_0(r3_2bar), .r4_0(r4_2bar), .r5_0(r5_2bar), .r6_0(r6_2bar), .r7_0(r7_2bar), .r8_0(r8_2bar),
        .comparator(comp2_bar)
    );
    reg [7:0] stage2_0_0, stage2_0_1, stage2_0_0bar, stage2_0_1bar;
    always @(posedge clk) begin
        if (comp2)      begin stage2_0_0 <= stage1_0_0;    stage2_0_1 <= stage1_0_1;    end
        else                    begin stage2_0_0 <= stage1_1_0;    stage2_0_1 <= stage1_1_1;    end
        if (comp2_bar)  begin stage2_0_0bar <= stage1_0_0bar; stage2_0_1bar <= stage1_0_1bar; end
        else                    begin stage2_0_0bar <= stage1_1_0bar; stage2_0_1bar <= stage1_1_1bar; end
    end

    always @(posedge clk) begin
        a0 <= 0; a0_bar <= 0;
        a1 <= 0; a1_bar <= 0;
        a2 <= 0; a2_bar <= 0;
        a3 <= 0; a3_bar <= 0;

        if (comp0 == 1 && comp2 == 1) a0     <= 1;
        else if (comp0 == 0 && comp2 == 1) a1     <= 1;
        else if (comp1 == 1 && comp2 == 0) a2     <= 1;
        else             a3     <= 1;

        if (comp0_bar == 1 && comp2_bar == 1) a0_bar     <= 1;
        else if (comp0_bar == 0 && comp2_bar == 1) a1_bar     <= 1;
        else if (comp1_bar == 1 && comp2_bar == 0) a2_bar     <= 1;
        else             a3_bar     <= 1;
    end
endmodule
module iterative_controller (
    input wire  clk,
    input wire  rst_n,
    input wire  start,
    output reg   done,
    input wire [2:0] inputs0_1,
    input wire [2:0] inputs1_1,
    input wire [2:0] inputs2_1,
    input wire [2:0] inputs3_1,
    input wire [2:0] inputs4_1,
    input wire [2:0] inputs5_1,
    input wire [2:0] inputs6_1,
    input wire [2:0] inputs7_1,
    input wire [2:0] inputs8_1,
    input wire [2:0] inputs9_1,
    input wire [2:0] inputs10_1,
    input wire [2:0] inputs11_1,
    input wire [2:0] inputs12_1,
    input wire [2:0] inputs13_1,
    input wire [2:0] inputs14_1,
    input wire [2:0] inputs15_1,
    input wire [15:0] w1_0_1, w1_1_1,
    input wire [15:0] w1_0_2, w1_1_2,
    input wire [15:0] w1_0_3, w1_1_3,
    input wire [15:0] w1_0_4, w1_1_4,
    input wire [15:0] w2_0_1, w2_1_1,
    input wire [15:0] w2_0_2, w2_1_2,
    input wire [15:0] w2_0_3, w2_1_3,
    input wire [15:0] w2_0_4, w2_1_4,
    input wire [15:0] w3_0_1, w3_1_1,
    input wire [15:0] w3_0_2, w3_1_2,
    input wire [15:0] w3_0_3, w3_1_3,
    input wire [15:0] w3_0_4, w3_1_4,
    input wire [15:0] w4_0_1, w4_1_1,
    input wire [15:0] w4_0_2, w4_1_2,
    input wire [15:0] w4_0_3, w4_1_3,
    input wire [15:0] w4_0_4, w4_1_4,
    input wire [15:0] w5_0_1, w5_1_1,
    input wire [15:0] w5_0_2, w5_1_2,
    input wire [15:0] w5_0_3, w5_1_3,
    input wire [15:0] w5_0_4, w5_1_4,
    input wire [15:0] w6_0_1, w6_1_1,
    input wire [15:0] w6_0_2, w6_1_2,
    input wire [15:0] w6_0_3, w6_1_3,
    input wire [15:0] w6_0_4, w6_1_4,
    input wire [15:0] w7_0_1, w7_1_1,
    input wire [15:0] w7_0_2, w7_1_2,
    input wire [15:0] w7_0_3, w7_1_3,
    input wire [15:0] w7_0_4, w7_1_4,
    input wire [15:0] w8_0_1, w8_1_1,
    input wire [15:0] w8_0_2, w8_1_2,
    input wire [15:0] w8_0_3, w8_1_3,
    input wire [15:0] w8_0_4, w8_1_4,
    input wire [6:0] b1_1,
    input wire [6:0] b1_2,
    input wire [6:0] b1_3,
    input wire [6:0] b1_4,
    input wire [6:0] b1_5,
    input wire [6:0] b1_6,
    input wire [6:0] b1_7,
    input wire [6:0] b1_8,
    input wire [6:0] b2_1,
    input wire [6:0] b2_2,
    input wire [6:0] b2_3,
    input wire [6:0] b2_4,
    input wire [6:0] b2_5,
    input wire [6:0] b2_6,
    input wire [6:0] b2_7,
    input wire [6:0] b2_8,
    input wire [6:0] b3_1,
    input wire [6:0] b3_2,
    input wire [6:0] b3_3,
    input wire [6:0] b3_4,
    input wire [6:0] b3_5,
    input wire [6:0] b3_6,
    input wire [6:0] b3_7,
    input wire [6:0] b3_8,
    input wire [6:0] b4_1,
    input wire [6:0] b4_2,
    input wire [6:0] b4_3,
    input wire [6:0] b4_4,
    input wire [6:0] b4_5,
    input wire [6:0] b4_6,
    input wire [6:0] b4_7,
    input wire [6:0] b4_8,
    input wire [6:0] b5_1,
    input wire [6:0] b5_2,
    input wire [6:0] b5_3,
    input wire [6:0] b5_4,
    input wire [6:0] b5_5,
    input wire [6:0] b5_6,
    input wire [6:0] b5_7,
    input wire [6:0] b5_8,
    input wire [6:0] b6_1,
    input wire [6:0] b6_2,
    input wire [6:0] b6_3,
    input wire [6:0] b6_4,
    input wire [6:0] b6_5,
    input wire [6:0] b6_6,
    input wire [6:0] b6_7,
    input wire [6:0] b6_8,
    input wire [6:0] b7_1,
    input wire [6:0] b7_2,
    input wire [6:0] b7_3,
    input wire [6:0] b7_4,
    input wire [6:0] b7_5,
    input wire [6:0] b7_6,
    input wire [6:0] b7_7,
    input wire [6:0] b7_8,
    input wire [6:0] b8_1,
    input wire [6:0] b8_2,
    input wire [6:0] b8_3,
    input wire [6:0] b8_4,
    input wire [6:0] b8_5,
    input wire [6:0] b8_6,
    input wire [6:0] b8_7,
    input wire [6:0] b8_8,
    output wire  [2:0]act0_0_0_r,
    output wire  [2:0]act0_0_1_r,
    output wire  [2:0]act0_0_2_r,
    output wire  [2:0]act0_0_3_r,
    output wire  [2:0]act0_0_4_r,
    output wire  [2:0]act0_0_5_r,
    output wire  [2:0]act0_0_6_r,
    output wire  [2:0]act0_0_7_r,
    output wire  [2:0]act0_0_8_r,
    output wire  [2:0]act0_0_9_r,
    output wire  [2:0]act0_0_10_r,
    output wire  [2:0]act0_0_11_r,
    output wire  [2:0]act0_0_12_r,
    output wire  [2:0]act0_0_13_r,
    output wire  [2:0]act0_0_14_r,
    output wire  [2:0]act0_0_15_r,
    output wire  [2:0]act0_1_0_r,
    output wire  [2:0]act0_1_1_r,
    output wire  [2:0]act0_1_2_r,
    output wire  [2:0]act0_1_3_r,
    output wire  [2:0]act0_1_4_r,
    output wire  [2:0]act0_1_5_r,
    output wire  [2:0]act0_1_6_r,
    output wire  [2:0]act0_1_7_r,
    output wire  [2:0]act0_1_8_r,
    output wire  [2:0]act0_1_9_r,
    output wire  [2:0]act0_1_10_r,
    output wire  [2:0]act0_1_11_r,
    output wire  [2:0]act0_1_12_r,
    output wire  [2:0]act0_1_13_r,
    output wire  [2:0]act0_1_14_r,
    output wire  [2:0]act0_1_15_r,
    output wire  [2:0]act1_0_0_r,
    output wire  [2:0]act1_0_1_r,
    output wire  [2:0]act1_0_2_r,
    output wire  [2:0]act1_0_3_r,
    output wire  [2:0]act1_0_4_r,
    output wire  [2:0]act1_0_5_r,
    output wire  [2:0]act1_0_6_r,
    output wire  [2:0]act1_0_7_r,
    output wire  [2:0]act1_0_8_r,
    output wire  [2:0]act1_0_9_r,
    output wire  [2:0]act1_0_10_r,
    output wire  [2:0]act1_0_11_r,
    output wire  [2:0]act1_0_12_r,
    output wire  [2:0]act1_0_13_r,
    output wire  [2:0]act1_0_14_r,
    output wire  [2:0]act1_0_15_r,
    output wire  [2:0]act1_1_0_r,
    output wire  [2:0]act1_1_1_r,
    output wire  [2:0]act1_1_2_r,
    output wire  [2:0]act1_1_3_r,
    output wire  [2:0]act1_1_4_r,
    output wire  [2:0]act1_1_5_r,
    output wire  [2:0]act1_1_6_r,
    output wire  [2:0]act1_1_7_r,
    output wire  [2:0]act1_1_8_r,
    output wire  [2:0]act1_1_9_r,
    output wire  [2:0]act1_1_10_r,
    output wire  [2:0]act1_1_11_r,
    output wire  [2:0]act1_1_12_r,
    output wire  [2:0]act1_1_13_r,
    output wire  [2:0]act1_1_14_r,
    output wire  [2:0]act1_1_15_r,
    output wire  [2:0]act2_0_0_r,
    output wire  [2:0]act2_0_1_r,
    output wire  [2:0]act2_0_2_r,
    output wire  [2:0]act2_0_3_r,
    output wire  [2:0]act2_0_4_r,
    output wire  [2:0]act2_0_5_r,
    output wire  [2:0]act2_0_6_r,
    output wire  [2:0]act2_0_7_r,
    output wire  [2:0]act2_0_8_r,
    output wire  [2:0]act2_0_9_r,
    output wire  [2:0]act2_0_10_r,
    output wire  [2:0]act2_0_11_r,
    output wire  [2:0]act2_0_12_r,
    output wire  [2:0]act2_0_13_r,
    output wire  [2:0]act2_0_14_r,
    output wire  [2:0]act2_0_15_r,
    output wire  [2:0]act2_1_0_r,
    output wire  [2:0]act2_1_1_r,
    output wire  [2:0]act2_1_2_r,
    output wire  [2:0]act2_1_3_r,
    output wire  [2:0]act2_1_4_r,
    output wire  [2:0]act2_1_5_r,
    output wire  [2:0]act2_1_6_r,
    output wire  [2:0]act2_1_7_r,
    output wire  [2:0]act2_1_8_r,
    output wire  [2:0]act2_1_9_r,
    output wire  [2:0]act2_1_10_r,
    output wire  [2:0]act2_1_11_r,
    output wire  [2:0]act2_1_12_r,
    output wire  [2:0]act2_1_13_r,
    output wire  [2:0]act2_1_14_r,
    output wire  [2:0]act2_1_15_r,
    output wire  [2:0]act3_0_0_r,
    output wire  [2:0]act3_0_1_r,
    output wire  [2:0]act3_0_2_r,
    output wire  [2:0]act3_0_3_r,
    output wire  [2:0]act3_0_4_r,
    output wire  [2:0]act3_0_5_r,
    output wire  [2:0]act3_0_6_r,
    output wire  [2:0]act3_0_7_r,
    output wire  [2:0]act3_0_8_r,
    output wire  [2:0]act3_0_9_r,
    output wire  [2:0]act3_0_10_r,
    output wire  [2:0]act3_0_11_r,
    output wire  [2:0]act3_0_12_r,
    output wire  [2:0]act3_0_13_r,
    output wire  [2:0]act3_0_14_r,
    output wire  [2:0]act3_0_15_r,
    output wire  [2:0]act3_1_0_r,
    output wire  [2:0]act3_1_1_r,
    output wire  [2:0]act3_1_2_r,
    output wire  [2:0]act3_1_3_r,
    output wire  [2:0]act3_1_4_r,
    output wire  [2:0]act3_1_5_r,
    output wire  [2:0]act3_1_6_r,
    output wire  [2:0]act3_1_7_r,
    output wire  [2:0]act3_1_8_r,
    output wire  [2:0]act3_1_9_r,
    output wire  [2:0]act3_1_10_r,
    output wire  [2:0]act3_1_11_r,
    output wire  [2:0]act3_1_12_r,
    output wire  [2:0]act3_1_13_r,
    output wire  [2:0]act3_1_14_r,
    output wire  [2:0]act3_1_15_r,
    output wire  [2:0]act4_0_0_r,
    output wire  [2:0]act4_0_1_r,
    output wire  [2:0]act4_0_2_r,
    output wire  [2:0]act4_0_3_r,
    output wire  [2:0]act4_0_4_r,
    output wire  [2:0]act4_0_5_r,
    output wire  [2:0]act4_0_6_r,
    output wire  [2:0]act4_0_7_r,
    output wire  [2:0]act4_0_8_r,
    output wire  [2:0]act4_0_9_r,
    output wire  [2:0]act4_0_10_r,
    output wire  [2:0]act4_0_11_r,
    output wire  [2:0]act4_0_12_r,
    output wire  [2:0]act4_0_13_r,
    output wire  [2:0]act4_0_14_r,
    output wire  [2:0]act4_0_15_r,
    output wire  [2:0]act4_1_0_r,
    output wire  [2:0]act4_1_1_r,
    output wire  [2:0]act4_1_2_r,
    output wire  [2:0]act4_1_3_r,
    output wire  [2:0]act4_1_4_r,
    output wire  [2:0]act4_1_5_r,
    output wire  [2:0]act4_1_6_r,
    output wire  [2:0]act4_1_7_r,
    output wire  [2:0]act4_1_8_r,
    output wire  [2:0]act4_1_9_r,
    output wire  [2:0]act4_1_10_r,
    output wire  [2:0]act4_1_11_r,
    output wire  [2:0]act4_1_12_r,
    output wire  [2:0]act4_1_13_r,
    output wire  [2:0]act4_1_14_r,
    output wire  [2:0]act4_1_15_r,
    output wire  [2:0]act5_0_0_r,
    output wire  [2:0]act5_0_1_r,
    output wire  [2:0]act5_0_2_r,
    output wire  [2:0]act5_0_3_r,
    output wire  [2:0]act5_0_4_r,
    output wire  [2:0]act5_0_5_r,
    output wire  [2:0]act5_0_6_r,
    output wire  [2:0]act5_0_7_r,
    output wire  [2:0]act5_0_8_r,
    output wire  [2:0]act5_0_9_r,
    output wire  [2:0]act5_0_10_r,
    output wire  [2:0]act5_0_11_r,
    output wire  [2:0]act5_0_12_r,
    output wire  [2:0]act5_0_13_r,
    output wire  [2:0]act5_0_14_r,
    output wire  [2:0]act5_0_15_r,
    output wire  [2:0]act5_1_0_r,
    output wire  [2:0]act5_1_1_r,
    output wire  [2:0]act5_1_2_r,
    output wire  [2:0]act5_1_3_r,
    output wire  [2:0]act5_1_4_r,
    output wire  [2:0]act5_1_5_r,
    output wire  [2:0]act5_1_6_r,
    output wire  [2:0]act5_1_7_r,
    output wire  [2:0]act5_1_8_r,
    output wire  [2:0]act5_1_9_r,
    output wire  [2:0]act5_1_10_r,
    output wire  [2:0]act5_1_11_r,
    output wire  [2:0]act5_1_12_r,
    output wire  [2:0]act5_1_13_r,
    output wire  [2:0]act5_1_14_r,
    output wire  [2:0]act5_1_15_r,
    output wire  [2:0]act6_0_0_r,
    output wire  [2:0]act6_0_1_r,
    output wire  [2:0]act6_0_2_r,
    output wire  [2:0]act6_0_3_r,
    output wire  [2:0]act6_0_4_r,
    output wire  [2:0]act6_0_5_r,
    output wire  [2:0]act6_0_6_r,
    output wire  [2:0]act6_0_7_r,
    output wire  [2:0]act6_0_8_r,
    output wire  [2:0]act6_0_9_r,
    output wire  [2:0]act6_0_10_r,
    output wire  [2:0]act6_0_11_r,
    output wire  [2:0]act6_0_12_r,
    output wire  [2:0]act6_0_13_r,
    output wire  [2:0]act6_0_14_r,
    output wire  [2:0]act6_0_15_r,
    output wire  [2:0]act6_1_0_r,
    output wire  [2:0]act6_1_1_r,
    output wire  [2:0]act6_1_2_r,
    output wire  [2:0]act6_1_3_r,
    output wire  [2:0]act6_1_4_r,
    output wire  [2:0]act6_1_5_r,
    output wire  [2:0]act6_1_6_r,
    output wire  [2:0]act6_1_7_r,
    output wire  [2:0]act6_1_8_r,
    output wire  [2:0]act6_1_9_r,
    output wire  [2:0]act6_1_10_r,
    output wire  [2:0]act6_1_11_r,
    output wire  [2:0]act6_1_12_r,
    output wire  [2:0]act6_1_13_r,
    output wire  [2:0]act6_1_14_r,
    output wire  [2:0]act6_1_15_r,
    output wire  [2:0]act7_0_0_r,
    output wire  [2:0]act7_0_1_r,
    output wire  [2:0]act7_0_2_r,
    output wire  [2:0]act7_0_3_r,
    output wire  [2:0]act7_0_4_r,
    output wire  [2:0]act7_0_5_r,
    output wire  [2:0]act7_0_6_r,
    output wire  [2:0]act7_0_7_r,
    output wire  [2:0]act7_0_8_r,
    output wire  [2:0]act7_0_9_r,
    output wire  [2:0]act7_0_10_r,
    output wire  [2:0]act7_0_11_r,
    output wire  [2:0]act7_0_12_r,
    output wire  [2:0]act7_0_13_r,
    output wire  [2:0]act7_0_14_r,
    output wire  [2:0]act7_0_15_r,
    output wire  [2:0]act7_1_0_r,
    output wire  [2:0]act7_1_1_r,
    output wire  [2:0]act7_1_2_r,
    output wire  [2:0]act7_1_3_r,
    output wire  [2:0]act7_1_4_r,
    output wire  [2:0]act7_1_5_r,
    output wire  [2:0]act7_1_6_r,
    output wire  [2:0]act7_1_7_r,
    output wire  [2:0]act7_1_8_r,
    output wire  [2:0]act7_1_9_r,
    output wire  [2:0]act7_1_10_r,
    output wire  [2:0]act7_1_11_r,
    output wire  [2:0]act7_1_12_r,
    output wire  [2:0]act7_1_13_r,
    output wire  [2:0]act7_1_14_r,
    output wire  [2:0]act7_1_15_r
);

  reg  [1:0]  s_count;
  reg [2:0] act0_0_0_layer;
  reg [2:0] act0_1_0_layer;
  reg [2:0] act0_0_1_layer;
  reg [2:0] act0_1_1_layer;
  reg [2:0] act0_0_2_layer;
  reg [2:0] act0_1_2_layer;
  reg [2:0] act0_0_3_layer;
  reg [2:0] act0_1_3_layer;
  reg [2:0] act0_0_4_layer;
  reg [2:0] act0_1_4_layer;
  reg [2:0] act0_0_5_layer;
  reg [2:0] act0_1_5_layer;
  reg [2:0] act0_0_6_layer;
  reg [2:0] act0_1_6_layer;
  reg [2:0] act0_0_7_layer;
  reg [2:0] act0_1_7_layer;
  reg [2:0] act0_0_8_layer;
  reg [2:0] act0_1_8_layer;
  reg [2:0] act0_0_9_layer;
  reg [2:0] act0_1_9_layer;
  reg [2:0] act0_0_10_layer;
  reg [2:0] act0_1_10_layer;
  reg [2:0] act0_0_11_layer;
  reg [2:0] act0_1_11_layer;
  reg [2:0] act0_0_12_layer;
  reg [2:0] act0_1_12_layer;
  reg [2:0] act0_0_13_layer;
  reg [2:0] act0_1_13_layer;
  reg [2:0] act0_0_14_layer;
  reg [2:0] act0_1_14_layer;
  reg [2:0] act0_0_15_layer;
  reg [2:0] act0_1_15_layer;
  reg [2:0] act1_0_0_layer;
  reg [2:0] act1_1_0_layer;
  reg [2:0] act1_0_1_layer;
  reg [2:0] act1_1_1_layer;
  reg [2:0] act1_0_2_layer;
  reg [2:0] act1_1_2_layer;
  reg [2:0] act1_0_3_layer;
  reg [2:0] act1_1_3_layer;
  reg [2:0] act1_0_4_layer;
  reg [2:0] act1_1_4_layer;
  reg [2:0] act1_0_5_layer;
  reg [2:0] act1_1_5_layer;
  reg [2:0] act1_0_6_layer;
  reg [2:0] act1_1_6_layer;
  reg [2:0] act1_0_7_layer;
  reg [2:0] act1_1_7_layer;
  reg [2:0] act1_0_8_layer;
  reg [2:0] act1_1_8_layer;
  reg [2:0] act1_0_9_layer;
  reg [2:0] act1_1_9_layer;
  reg [2:0] act1_0_10_layer;
  reg [2:0] act1_1_10_layer;
  reg [2:0] act1_0_11_layer;
  reg [2:0] act1_1_11_layer;
  reg [2:0] act1_0_12_layer;
  reg [2:0] act1_1_12_layer;
  reg [2:0] act1_0_13_layer;
  reg [2:0] act1_1_13_layer;
  reg [2:0] act1_0_14_layer;
  reg [2:0] act1_1_14_layer;
  reg [2:0] act1_0_15_layer;
  reg [2:0] act1_1_15_layer;
  reg [2:0] act2_0_0_layer;
  reg [2:0] act2_1_0_layer;
  reg [2:0] act2_0_1_layer;
  reg [2:0] act2_1_1_layer;
  reg [2:0] act2_0_2_layer;
  reg [2:0] act2_1_2_layer;
  reg [2:0] act2_0_3_layer;
  reg [2:0] act2_1_3_layer;
  reg [2:0] act2_0_4_layer;
  reg [2:0] act2_1_4_layer;
  reg [2:0] act2_0_5_layer;
  reg [2:0] act2_1_5_layer;
  reg [2:0] act2_0_6_layer;
  reg [2:0] act2_1_6_layer;
  reg [2:0] act2_0_7_layer;
  reg [2:0] act2_1_7_layer;
  reg [2:0] act2_0_8_layer;
  reg [2:0] act2_1_8_layer;
  reg [2:0] act2_0_9_layer;
  reg [2:0] act2_1_9_layer;
  reg [2:0] act2_0_10_layer;
  reg [2:0] act2_1_10_layer;
  reg [2:0] act2_0_11_layer;
  reg [2:0] act2_1_11_layer;
  reg [2:0] act2_0_12_layer;
  reg [2:0] act2_1_12_layer;
  reg [2:0] act2_0_13_layer;
  reg [2:0] act2_1_13_layer;
  reg [2:0] act2_0_14_layer;
  reg [2:0] act2_1_14_layer;
  reg [2:0] act2_0_15_layer;
  reg [2:0] act2_1_15_layer;
  reg [2:0] act3_0_0_layer;
  reg [2:0] act3_1_0_layer;
  reg [2:0] act3_0_1_layer;
  reg [2:0] act3_1_1_layer;
  reg [2:0] act3_0_2_layer;
  reg [2:0] act3_1_2_layer;
  reg [2:0] act3_0_3_layer;
  reg [2:0] act3_1_3_layer;
  reg [2:0] act3_0_4_layer;
  reg [2:0] act3_1_4_layer;
  reg [2:0] act3_0_5_layer;
  reg [2:0] act3_1_5_layer;
  reg [2:0] act3_0_6_layer;
  reg [2:0] act3_1_6_layer;
  reg [2:0] act3_0_7_layer;
  reg [2:0] act3_1_7_layer;
  reg [2:0] act3_0_8_layer;
  reg [2:0] act3_1_8_layer;
  reg [2:0] act3_0_9_layer;
  reg [2:0] act3_1_9_layer;
  reg [2:0] act3_0_10_layer;
  reg [2:0] act3_1_10_layer;
  reg [2:0] act3_0_11_layer;
  reg [2:0] act3_1_11_layer;
  reg [2:0] act3_0_12_layer;
  reg [2:0] act3_1_12_layer;
  reg [2:0] act3_0_13_layer;
  reg [2:0] act3_1_13_layer;
  reg [2:0] act3_0_14_layer;
  reg [2:0] act3_1_14_layer;
  reg [2:0] act3_0_15_layer;
  reg [2:0] act3_1_15_layer;
  reg [2:0] act4_0_0_layer;
  reg [2:0] act4_1_0_layer;
  reg [2:0] act4_0_1_layer;
  reg [2:0] act4_1_1_layer;
  reg [2:0] act4_0_2_layer;
  reg [2:0] act4_1_2_layer;
  reg [2:0] act4_0_3_layer;
  reg [2:0] act4_1_3_layer;
  reg [2:0] act4_0_4_layer;
  reg [2:0] act4_1_4_layer;
  reg [2:0] act4_0_5_layer;
  reg [2:0] act4_1_5_layer;
  reg [2:0] act4_0_6_layer;
  reg [2:0] act4_1_6_layer;
  reg [2:0] act4_0_7_layer;
  reg [2:0] act4_1_7_layer;
  reg [2:0] act4_0_8_layer;
  reg [2:0] act4_1_8_layer;
  reg [2:0] act4_0_9_layer;
  reg [2:0] act4_1_9_layer;
  reg [2:0] act4_0_10_layer;
  reg [2:0] act4_1_10_layer;
  reg [2:0] act4_0_11_layer;
  reg [2:0] act4_1_11_layer;
  reg [2:0] act4_0_12_layer;
  reg [2:0] act4_1_12_layer;
  reg [2:0] act4_0_13_layer;
  reg [2:0] act4_1_13_layer;
  reg [2:0] act4_0_14_layer;
  reg [2:0] act4_1_14_layer;
  reg [2:0] act4_0_15_layer;
  reg [2:0] act4_1_15_layer;
  reg [2:0] act5_0_0_layer;
  reg [2:0] act5_1_0_layer;
  reg [2:0] act5_0_1_layer;
  reg [2:0] act5_1_1_layer;
  reg [2:0] act5_0_2_layer;
  reg [2:0] act5_1_2_layer;
  reg [2:0] act5_0_3_layer;
  reg [2:0] act5_1_3_layer;
  reg [2:0] act5_0_4_layer;
  reg [2:0] act5_1_4_layer;
  reg [2:0] act5_0_5_layer;
  reg [2:0] act5_1_5_layer;
  reg [2:0] act5_0_6_layer;
  reg [2:0] act5_1_6_layer;
  reg [2:0] act5_0_7_layer;
  reg [2:0] act5_1_7_layer;
  reg [2:0] act5_0_8_layer;
  reg [2:0] act5_1_8_layer;
  reg [2:0] act5_0_9_layer;
  reg [2:0] act5_1_9_layer;
  reg [2:0] act5_0_10_layer;
  reg [2:0] act5_1_10_layer;
  reg [2:0] act5_0_11_layer;
  reg [2:0] act5_1_11_layer;
  reg [2:0] act5_0_12_layer;
  reg [2:0] act5_1_12_layer;
  reg [2:0] act5_0_13_layer;
  reg [2:0] act5_1_13_layer;
  reg [2:0] act5_0_14_layer;
  reg [2:0] act5_1_14_layer;
  reg [2:0] act5_0_15_layer;
  reg [2:0] act5_1_15_layer;
  reg [2:0] act6_0_0_layer;
  reg [2:0] act6_1_0_layer;
  reg [2:0] act6_0_1_layer;
  reg [2:0] act6_1_1_layer;
  reg [2:0] act6_0_2_layer;
  reg [2:0] act6_1_2_layer;
  reg [2:0] act6_0_3_layer;
  reg [2:0] act6_1_3_layer;
  reg [2:0] act6_0_4_layer;
  reg [2:0] act6_1_4_layer;
  reg [2:0] act6_0_5_layer;
  reg [2:0] act6_1_5_layer;
  reg [2:0] act6_0_6_layer;
  reg [2:0] act6_1_6_layer;
  reg [2:0] act6_0_7_layer;
  reg [2:0] act6_1_7_layer;
  reg [2:0] act6_0_8_layer;
  reg [2:0] act6_1_8_layer;
  reg [2:0] act6_0_9_layer;
  reg [2:0] act6_1_9_layer;
  reg [2:0] act6_0_10_layer;
  reg [2:0] act6_1_10_layer;
  reg [2:0] act6_0_11_layer;
  reg [2:0] act6_1_11_layer;
  reg [2:0] act6_0_12_layer;
  reg [2:0] act6_1_12_layer;
  reg [2:0] act6_0_13_layer;
  reg [2:0] act6_1_13_layer;
  reg [2:0] act6_0_14_layer;
  reg [2:0] act6_1_14_layer;
  reg [2:0] act6_0_15_layer;
  reg [2:0] act6_1_15_layer;
  reg [2:0] act7_0_0_layer;
  reg [2:0] act7_1_0_layer;
  reg [2:0] act7_0_1_layer;
  reg [2:0] act7_1_1_layer;
  reg [2:0] act7_0_2_layer;
  reg [2:0] act7_1_2_layer;
  reg [2:0] act7_0_3_layer;
  reg [2:0] act7_1_3_layer;
  reg [2:0] act7_0_4_layer;
  reg [2:0] act7_1_4_layer;
  reg [2:0] act7_0_5_layer;
  reg [2:0] act7_1_5_layer;
  reg [2:0] act7_0_6_layer;
  reg [2:0] act7_1_6_layer;
  reg [2:0] act7_0_7_layer;
  reg [2:0] act7_1_7_layer;
  reg [2:0] act7_0_8_layer;
  reg [2:0] act7_1_8_layer;
  reg [2:0] act7_0_9_layer;
  reg [2:0] act7_1_9_layer;
  reg [2:0] act7_0_10_layer;
  reg [2:0] act7_1_10_layer;
  reg [2:0] act7_0_11_layer;
  reg [2:0] act7_1_11_layer;
  reg [2:0] act7_0_12_layer;
  reg [2:0] act7_1_12_layer;
  reg [2:0] act7_0_13_layer;
  reg [2:0] act7_1_13_layer;
  reg [2:0] act7_0_14_layer;
  reg [2:0] act7_1_14_layer;
  reg [2:0] act7_0_15_layer;
  reg [2:0] act7_1_15_layer;

  // internal wires
  wire [7:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar;
  wire masked_activation0_1, masked_activation0bar_1;
  wire mask0_1, mask0bar_1;
  wire  a0, a0_bar;
  wire [7:0] biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar;
  wire masked_activation1_1, masked_activation1bar_1;
  wire mask1_1, mask1bar_1;
  wire  a1, a1_bar;
  wire [7:0] biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar;
  wire masked_activation2_1, masked_activation2bar_1;
  wire mask2_1, mask2bar_1;
  wire  a2, a2_bar;
  wire [7:0] biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar;
  wire masked_activation3_1, masked_activation3bar_1;
  wire mask3_1, mask3bar_1;
  wire  a3, a3_bar;
  wire [7:0] biased_sum4_0, biased_sum4_1, biased_sum4_0bar, biased_sum4_1bar;
  wire masked_activation4_1, masked_activation4bar_1;
  wire mask4_1, mask4bar_1;
  wire  a4, a4_bar;
  wire [7:0] biased_sum5_0, biased_sum5_1, biased_sum5_0bar, biased_sum5_1bar;
  wire masked_activation5_1, masked_activation5bar_1;
  wire mask5_1, mask5bar_1;
  wire  a5, a5_bar;
  wire [7:0] biased_sum6_0, biased_sum6_1, biased_sum6_0bar, biased_sum6_1bar;
  wire masked_activation6_1, masked_activation6bar_1;
  wire mask6_1, mask6bar_1;
  wire  a6, a6_bar;
  wire [7:0] biased_sum7_0, biased_sum7_1, biased_sum7_0bar, biased_sum7_1bar;
  wire masked_activation7_1, masked_activation7bar_1;
  wire mask7_1, mask7bar_1;
  wire  a7, a7_bar;
  


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
            act0_0_0_layer <= 3'd0;        act0_0_1_layer <= 3'd0;
            act0_0_2_layer <= 3'd0;        act0_0_3_layer <= 3'd0;
            act0_0_4_layer <= 3'd0;        act0_0_5_layer <= 3'd0;
            act0_0_6_layer <= 3'd0;        act0_0_7_layer <= 3'd0;
            act0_0_8_layer <= 3'd0;        act0_0_9_layer <= 3'd0;
            act0_0_10_layer <= 3'd0;        act0_0_11_layer <= 3'd0;
            act0_0_12_layer <= 3'd0;        act0_0_13_layer <= 3'd0;
            act0_0_14_layer <= 3'd0;        act0_0_15_layer <= 3'd0;

            act0_1_0_layer <= 3'd0;        act0_1_1_layer <= 3'd0;
            act0_1_2_layer <= 3'd0;        act0_1_3_layer <= 3'd0;
            act0_1_4_layer <= 3'd0;        act0_1_5_layer <= 3'd0;
            act0_1_6_layer <= 3'd0;        act0_1_7_layer <= 3'd0;
            act0_1_8_layer <= 3'd0;        act0_1_9_layer <= 3'd0;
            act0_1_10_layer <= 3'd0;        act0_1_11_layer <= 3'd0;
            act0_1_12_layer <= 3'd0;        act0_1_13_layer <= 3'd0;
            act0_1_14_layer <= 3'd0;        act0_1_15_layer <= 3'd0;

            act1_0_0_layer <= 3'd0;        act1_0_1_layer <= 3'd0;
            act1_0_2_layer <= 3'd0;        act1_0_3_layer <= 3'd0;
            act1_0_4_layer <= 3'd0;        act1_0_5_layer <= 3'd0;
            act1_0_6_layer <= 3'd0;        act1_0_7_layer <= 3'd0;
            act1_0_8_layer <= 3'd0;        act1_0_9_layer <= 3'd0;
            act1_0_10_layer <= 3'd0;        act1_0_11_layer <= 3'd0;
            act1_0_12_layer <= 3'd0;        act1_0_13_layer <= 3'd0;
            act1_0_14_layer <= 3'd0;        act1_0_15_layer <= 3'd0;

            act1_1_0_layer <= 3'd0;        act1_1_1_layer <= 3'd0;
            act1_1_2_layer <= 3'd0;        act1_1_3_layer <= 3'd0;
            act1_1_4_layer <= 3'd0;        act1_1_5_layer <= 3'd0;
            act1_1_6_layer <= 3'd0;        act1_1_7_layer <= 3'd0;
            act1_1_8_layer <= 3'd0;        act1_1_9_layer <= 3'd0;
            act1_1_10_layer <= 3'd0;        act1_1_11_layer <= 3'd0;
            act1_1_12_layer <= 3'd0;        act1_1_13_layer <= 3'd0;
            act1_1_14_layer <= 3'd0;        act1_1_15_layer <= 3'd0;

            act2_0_0_layer <= 3'd0;        act2_0_1_layer <= 3'd0;
            act2_0_2_layer <= 3'd0;        act2_0_3_layer <= 3'd0;
            act2_0_4_layer <= 3'd0;        act2_0_5_layer <= 3'd0;
            act2_0_6_layer <= 3'd0;        act2_0_7_layer <= 3'd0;
            act2_0_8_layer <= 3'd0;        act2_0_9_layer <= 3'd0;
            act2_0_10_layer <= 3'd0;        act2_0_11_layer <= 3'd0;
            act2_0_12_layer <= 3'd0;        act2_0_13_layer <= 3'd0;
            act2_0_14_layer <= 3'd0;        act2_0_15_layer <= 3'd0;

            act2_1_0_layer <= 3'd0;        act2_1_1_layer <= 3'd0;
            act2_1_2_layer <= 3'd0;        act2_1_3_layer <= 3'd0;
            act2_1_4_layer <= 3'd0;        act2_1_5_layer <= 3'd0;
            act2_1_6_layer <= 3'd0;        act2_1_7_layer <= 3'd0;
            act2_1_8_layer <= 3'd0;        act2_1_9_layer <= 3'd0;
            act2_1_10_layer <= 3'd0;        act2_1_11_layer <= 3'd0;
            act2_1_12_layer <= 3'd0;        act2_1_13_layer <= 3'd0;
            act2_1_14_layer <= 3'd0;        act2_1_15_layer <= 3'd0;

            act3_0_0_layer <= 3'd0;        act3_0_1_layer <= 3'd0;
            act3_0_2_layer <= 3'd0;        act3_0_3_layer <= 3'd0;
            act3_0_4_layer <= 3'd0;        act3_0_5_layer <= 3'd0;
            act3_0_6_layer <= 3'd0;        act3_0_7_layer <= 3'd0;
            act3_0_8_layer <= 3'd0;        act3_0_9_layer <= 3'd0;
            act3_0_10_layer <= 3'd0;        act3_0_11_layer <= 3'd0;
            act3_0_12_layer <= 3'd0;        act3_0_13_layer <= 3'd0;
            act3_0_14_layer <= 3'd0;        act3_0_15_layer <= 3'd0;

            act3_1_0_layer <= 3'd0;        act3_1_1_layer <= 3'd0;
            act3_1_2_layer <= 3'd0;        act3_1_3_layer <= 3'd0;
            act3_1_4_layer <= 3'd0;        act3_1_5_layer <= 3'd0;
            act3_1_6_layer <= 3'd0;        act3_1_7_layer <= 3'd0;
            act3_1_8_layer <= 3'd0;        act3_1_9_layer <= 3'd0;
            act3_1_10_layer <= 3'd0;        act3_1_11_layer <= 3'd0;
            act3_1_12_layer <= 3'd0;        act3_1_13_layer <= 3'd0;
            act3_1_14_layer <= 3'd0;        act3_1_15_layer <= 3'd0;

            act4_0_0_layer <= 3'd0;        act4_0_1_layer <= 3'd0;
            act4_0_2_layer <= 3'd0;        act4_0_3_layer <= 3'd0;
            act4_0_4_layer <= 3'd0;        act4_0_5_layer <= 3'd0;
            act4_0_6_layer <= 3'd0;        act4_0_7_layer <= 3'd0;
            act4_0_8_layer <= 3'd0;        act4_0_9_layer <= 3'd0;
            act4_0_10_layer <= 3'd0;        act4_0_11_layer <= 3'd0;
            act4_0_12_layer <= 3'd0;        act4_0_13_layer <= 3'd0;
            act4_0_14_layer <= 3'd0;        act4_0_15_layer <= 3'd0;

            act4_1_0_layer <= 3'd0;        act4_1_1_layer <= 3'd0;
            act4_1_2_layer <= 3'd0;        act4_1_3_layer <= 3'd0;
            act4_1_4_layer <= 3'd0;        act4_1_5_layer <= 3'd0;
            act4_1_6_layer <= 3'd0;        act4_1_7_layer <= 3'd0;
            act4_1_8_layer <= 3'd0;        act4_1_9_layer <= 3'd0;
            act4_1_10_layer <= 3'd0;        act4_1_11_layer <= 3'd0;
            act4_1_12_layer <= 3'd0;        act4_1_13_layer <= 3'd0;
            act4_1_14_layer <= 3'd0;        act4_1_15_layer <= 3'd0;

            act5_0_0_layer <= 3'd0;        act5_0_1_layer <= 3'd0;
            act5_0_2_layer <= 3'd0;        act5_0_3_layer <= 3'd0;
            act5_0_4_layer <= 3'd0;        act5_0_5_layer <= 3'd0;
            act5_0_6_layer <= 3'd0;        act5_0_7_layer <= 3'd0;
            act5_0_8_layer <= 3'd0;        act5_0_9_layer <= 3'd0;
            act5_0_10_layer <= 3'd0;        act5_0_11_layer <= 3'd0;
            act5_0_12_layer <= 3'd0;        act5_0_13_layer <= 3'd0;
            act5_0_14_layer <= 3'd0;        act5_0_15_layer <= 3'd0;

            act5_1_0_layer <= 3'd0;        act5_1_1_layer <= 3'd0;
            act5_1_2_layer <= 3'd0;        act5_1_3_layer <= 3'd0;
            act5_1_4_layer <= 3'd0;        act5_1_5_layer <= 3'd0;
            act5_1_6_layer <= 3'd0;        act5_1_7_layer <= 3'd0;
            act5_1_8_layer <= 3'd0;        act5_1_9_layer <= 3'd0;
            act5_1_10_layer <= 3'd0;        act5_1_11_layer <= 3'd0;
            act5_1_12_layer <= 3'd0;        act5_1_13_layer <= 3'd0;
            act5_1_14_layer <= 3'd0;        act5_1_15_layer <= 3'd0;

            act6_0_0_layer <= 3'd0;        act6_0_1_layer <= 3'd0;
            act6_0_2_layer <= 3'd0;        act6_0_3_layer <= 3'd0;
            act6_0_4_layer <= 3'd0;        act6_0_5_layer <= 3'd0;
            act6_0_6_layer <= 3'd0;        act6_0_7_layer <= 3'd0;
            act6_0_8_layer <= 3'd0;        act6_0_9_layer <= 3'd0;
            act6_0_10_layer <= 3'd0;        act6_0_11_layer <= 3'd0;
            act6_0_12_layer <= 3'd0;        act6_0_13_layer <= 3'd0;
            act6_0_14_layer <= 3'd0;        act6_0_15_layer <= 3'd0;

            act6_1_0_layer <= 3'd0;        act6_1_1_layer <= 3'd0;
            act6_1_2_layer <= 3'd0;        act6_1_3_layer <= 3'd0;
            act6_1_4_layer <= 3'd0;        act6_1_5_layer <= 3'd0;
            act6_1_6_layer <= 3'd0;        act6_1_7_layer <= 3'd0;
            act6_1_8_layer <= 3'd0;        act6_1_9_layer <= 3'd0;
            act6_1_10_layer <= 3'd0;        act6_1_11_layer <= 3'd0;
            act6_1_12_layer <= 3'd0;        act6_1_13_layer <= 3'd0;
            act6_1_14_layer <= 3'd0;        act6_1_15_layer <= 3'd0;

            act7_0_0_layer <= 3'd0;        act7_0_1_layer <= 3'd0;
            act7_0_2_layer <= 3'd0;        act7_0_3_layer <= 3'd0;
            act7_0_4_layer <= 3'd0;        act7_0_5_layer <= 3'd0;
            act7_0_6_layer <= 3'd0;        act7_0_7_layer <= 3'd0;
            act7_0_8_layer <= 3'd0;        act7_0_9_layer <= 3'd0;
            act7_0_10_layer <= 3'd0;        act7_0_11_layer <= 3'd0;
            act7_0_12_layer <= 3'd0;        act7_0_13_layer <= 3'd0;
            act7_0_14_layer <= 3'd0;        act7_0_15_layer <= 3'd0;

            act7_1_0_layer <= 3'd0;        act7_1_1_layer <= 3'd0;
            act7_1_2_layer <= 3'd0;        act7_1_3_layer <= 3'd0;
            act7_1_4_layer <= 3'd0;        act7_1_5_layer <= 3'd0;
            act7_1_6_layer <= 3'd0;        act7_1_7_layer <= 3'd0;
            act7_1_8_layer <= 3'd0;        act7_1_9_layer <= 3'd0;
            act7_1_10_layer <= 3'd0;        act7_1_11_layer <= 3'd0;
            act7_1_12_layer <= 3'd0;        act7_1_13_layer <= 3'd0;
            act7_1_14_layer <= 3'd0;        act7_1_15_layer <= 3'd0;
  end else if (state == WAIT_SHARE && done_share) begin
      // capture the outputs of m2 into the next iteration's m1 inputs
            act0_0_0_layer <= act0_0_0_r;        act0_0_1_layer <= act0_0_1_r;
            act0_0_2_layer <= act0_0_2_r;        act0_0_3_layer <= act0_0_3_r;
            act0_0_4_layer <= act0_0_4_r;        act0_0_5_layer <= act0_0_5_r;
            act0_0_6_layer <= act0_0_6_r;        act0_0_7_layer <= act0_0_7_r;
            act0_0_8_layer <= act0_0_8_r;        act0_0_9_layer <= act0_0_9_r;
            act0_0_10_layer <= act0_0_10_r;        act0_0_11_layer <= act0_0_11_r;
            act0_0_12_layer <= act0_0_12_r;        act0_0_13_layer <= act0_0_13_r;
            act0_0_14_layer <= act0_0_14_r;        act0_0_15_layer <= act0_0_15_r;

            act0_1_0_layer <= act0_1_0_r;        act0_1_1_layer <= act0_1_1_r;
            act0_1_2_layer <= act0_1_2_r;        act0_1_3_layer <= act0_1_3_r;
            act0_1_4_layer <= act0_1_4_r;        act0_1_5_layer <= act0_1_5_r;
            act0_1_6_layer <= act0_1_6_r;        act0_1_7_layer <= act0_1_7_r;
            act0_1_8_layer <= act0_1_8_r;        act0_1_9_layer <= act0_1_9_r;
            act0_1_10_layer <= act0_1_10_r;        act0_1_11_layer <= act0_1_11_r;
            act0_1_12_layer <= act0_1_12_r;        act0_1_13_layer <= act0_1_13_r;
            act0_1_14_layer <= act0_1_14_r;        act0_1_15_layer <= act0_1_15_r;

            act1_0_0_layer <= act1_0_0_r;        act1_0_1_layer <= act1_0_1_r;
            act1_0_2_layer <= act1_0_2_r;        act1_0_3_layer <= act1_0_3_r;
            act1_0_4_layer <= act1_0_4_r;        act1_0_5_layer <= act1_0_5_r;
            act1_0_6_layer <= act1_0_6_r;        act1_0_7_layer <= act1_0_7_r;
            act1_0_8_layer <= act1_0_8_r;        act1_0_9_layer <= act1_0_9_r;
            act1_0_10_layer <= act1_0_10_r;        act1_0_11_layer <= act1_0_11_r;
            act1_0_12_layer <= act1_0_12_r;        act1_0_13_layer <= act1_0_13_r;
            act1_0_14_layer <= act1_0_14_r;        act1_0_15_layer <= act1_0_15_r;

            act1_1_0_layer <= act1_1_0_r;        act1_1_1_layer <= act1_1_1_r;
            act1_1_2_layer <= act1_1_2_r;        act1_1_3_layer <= act1_1_3_r;
            act1_1_4_layer <= act1_1_4_r;        act1_1_5_layer <= act1_1_5_r;
            act1_1_6_layer <= act1_1_6_r;        act1_1_7_layer <= act1_1_7_r;
            act1_1_8_layer <= act1_1_8_r;        act1_1_9_layer <= act1_1_9_r;
            act1_1_10_layer <= act1_1_10_r;        act1_1_11_layer <= act1_1_11_r;
            act1_1_12_layer <= act1_1_12_r;        act1_1_13_layer <= act1_1_13_r;
            act1_1_14_layer <= act1_1_14_r;        act1_1_15_layer <= act1_1_15_r;

            act2_0_0_layer <= act2_0_0_r;        act2_0_1_layer <= act2_0_1_r;
            act2_0_2_layer <= act2_0_2_r;        act2_0_3_layer <= act2_0_3_r;
            act2_0_4_layer <= act2_0_4_r;        act2_0_5_layer <= act2_0_5_r;
            act2_0_6_layer <= act2_0_6_r;        act2_0_7_layer <= act2_0_7_r;
            act2_0_8_layer <= act2_0_8_r;        act2_0_9_layer <= act2_0_9_r;
            act2_0_10_layer <= act2_0_10_r;        act2_0_11_layer <= act2_0_11_r;
            act2_0_12_layer <= act2_0_12_r;        act2_0_13_layer <= act2_0_13_r;
            act2_0_14_layer <= act2_0_14_r;        act2_0_15_layer <= act2_0_15_r;

            act2_1_0_layer <= act2_1_0_r;        act2_1_1_layer <= act2_1_1_r;
            act2_1_2_layer <= act2_1_2_r;        act2_1_3_layer <= act2_1_3_r;
            act2_1_4_layer <= act2_1_4_r;        act2_1_5_layer <= act2_1_5_r;
            act2_1_6_layer <= act2_1_6_r;        act2_1_7_layer <= act2_1_7_r;
            act2_1_8_layer <= act2_1_8_r;        act2_1_9_layer <= act2_1_9_r;
            act2_1_10_layer <= act2_1_10_r;        act2_1_11_layer <= act2_1_11_r;
            act2_1_12_layer <= act2_1_12_r;        act2_1_13_layer <= act2_1_13_r;
            act2_1_14_layer <= act2_1_14_r;        act2_1_15_layer <= act2_1_15_r;

            act3_0_0_layer <= act3_0_0_r;        act3_0_1_layer <= act3_0_1_r;
            act3_0_2_layer <= act3_0_2_r;        act3_0_3_layer <= act3_0_3_r;
            act3_0_4_layer <= act3_0_4_r;        act3_0_5_layer <= act3_0_5_r;
            act3_0_6_layer <= act3_0_6_r;        act3_0_7_layer <= act3_0_7_r;
            act3_0_8_layer <= act3_0_8_r;        act3_0_9_layer <= act3_0_9_r;
            act3_0_10_layer <= act3_0_10_r;        act3_0_11_layer <= act3_0_11_r;
            act3_0_12_layer <= act3_0_12_r;        act3_0_13_layer <= act3_0_13_r;
            act3_0_14_layer <= act3_0_14_r;        act3_0_15_layer <= act3_0_15_r;

            act3_1_0_layer <= act3_1_0_r;        act3_1_1_layer <= act3_1_1_r;
            act3_1_2_layer <= act3_1_2_r;        act3_1_3_layer <= act3_1_3_r;
            act3_1_4_layer <= act3_1_4_r;        act3_1_5_layer <= act3_1_5_r;
            act3_1_6_layer <= act3_1_6_r;        act3_1_7_layer <= act3_1_7_r;
            act3_1_8_layer <= act3_1_8_r;        act3_1_9_layer <= act3_1_9_r;
            act3_1_10_layer <= act3_1_10_r;        act3_1_11_layer <= act3_1_11_r;
            act3_1_12_layer <= act3_1_12_r;        act3_1_13_layer <= act3_1_13_r;
            act3_1_14_layer <= act3_1_14_r;        act3_1_15_layer <= act3_1_15_r;

            act4_0_0_layer <= act4_0_0_r;        act4_0_1_layer <= act4_0_1_r;
            act4_0_2_layer <= act4_0_2_r;        act4_0_3_layer <= act4_0_3_r;
            act4_0_4_layer <= act4_0_4_r;        act4_0_5_layer <= act4_0_5_r;
            act4_0_6_layer <= act4_0_6_r;        act4_0_7_layer <= act4_0_7_r;
            act4_0_8_layer <= act4_0_8_r;        act4_0_9_layer <= act4_0_9_r;
            act4_0_10_layer <= act4_0_10_r;        act4_0_11_layer <= act4_0_11_r;
            act4_0_12_layer <= act4_0_12_r;        act4_0_13_layer <= act4_0_13_r;
            act4_0_14_layer <= act4_0_14_r;        act4_0_15_layer <= act4_0_15_r;

            act4_1_0_layer <= act4_1_0_r;        act4_1_1_layer <= act4_1_1_r;
            act4_1_2_layer <= act4_1_2_r;        act4_1_3_layer <= act4_1_3_r;
            act4_1_4_layer <= act4_1_4_r;        act4_1_5_layer <= act4_1_5_r;
            act4_1_6_layer <= act4_1_6_r;        act4_1_7_layer <= act4_1_7_r;
            act4_1_8_layer <= act4_1_8_r;        act4_1_9_layer <= act4_1_9_r;
            act4_1_10_layer <= act4_1_10_r;        act4_1_11_layer <= act4_1_11_r;
            act4_1_12_layer <= act4_1_12_r;        act4_1_13_layer <= act4_1_13_r;
            act4_1_14_layer <= act4_1_14_r;        act4_1_15_layer <= act4_1_15_r;

            act5_0_0_layer <= act5_0_0_r;        act5_0_1_layer <= act5_0_1_r;
            act5_0_2_layer <= act5_0_2_r;        act5_0_3_layer <= act5_0_3_r;
            act5_0_4_layer <= act5_0_4_r;        act5_0_5_layer <= act5_0_5_r;
            act5_0_6_layer <= act5_0_6_r;        act5_0_7_layer <= act5_0_7_r;
            act5_0_8_layer <= act5_0_8_r;        act5_0_9_layer <= act5_0_9_r;
            act5_0_10_layer <= act5_0_10_r;        act5_0_11_layer <= act5_0_11_r;
            act5_0_12_layer <= act5_0_12_r;        act5_0_13_layer <= act5_0_13_r;
            act5_0_14_layer <= act5_0_14_r;        act5_0_15_layer <= act5_0_15_r;

            act5_1_0_layer <= act5_1_0_r;        act5_1_1_layer <= act5_1_1_r;
            act5_1_2_layer <= act5_1_2_r;        act5_1_3_layer <= act5_1_3_r;
            act5_1_4_layer <= act5_1_4_r;        act5_1_5_layer <= act5_1_5_r;
            act5_1_6_layer <= act5_1_6_r;        act5_1_7_layer <= act5_1_7_r;
            act5_1_8_layer <= act5_1_8_r;        act5_1_9_layer <= act5_1_9_r;
            act5_1_10_layer <= act5_1_10_r;        act5_1_11_layer <= act5_1_11_r;
            act5_1_12_layer <= act5_1_12_r;        act5_1_13_layer <= act5_1_13_r;
            act5_1_14_layer <= act5_1_14_r;        act5_1_15_layer <= act5_1_15_r;

            act6_0_0_layer <= act6_0_0_r;        act6_0_1_layer <= act6_0_1_r;
            act6_0_2_layer <= act6_0_2_r;        act6_0_3_layer <= act6_0_3_r;
            act6_0_4_layer <= act6_0_4_r;        act6_0_5_layer <= act6_0_5_r;
            act6_0_6_layer <= act6_0_6_r;        act6_0_7_layer <= act6_0_7_r;
            act6_0_8_layer <= act6_0_8_r;        act6_0_9_layer <= act6_0_9_r;
            act6_0_10_layer <= act6_0_10_r;        act6_0_11_layer <= act6_0_11_r;
            act6_0_12_layer <= act6_0_12_r;        act6_0_13_layer <= act6_0_13_r;
            act6_0_14_layer <= act6_0_14_r;        act6_0_15_layer <= act6_0_15_r;

            act6_1_0_layer <= act6_1_0_r;        act6_1_1_layer <= act6_1_1_r;
            act6_1_2_layer <= act6_1_2_r;        act6_1_3_layer <= act6_1_3_r;
            act6_1_4_layer <= act6_1_4_r;        act6_1_5_layer <= act6_1_5_r;
            act6_1_6_layer <= act6_1_6_r;        act6_1_7_layer <= act6_1_7_r;
            act6_1_8_layer <= act6_1_8_r;        act6_1_9_layer <= act6_1_9_r;
            act6_1_10_layer <= act6_1_10_r;        act6_1_11_layer <= act6_1_11_r;
            act6_1_12_layer <= act6_1_12_r;        act6_1_13_layer <= act6_1_13_r;
            act6_1_14_layer <= act6_1_14_r;        act6_1_15_layer <= act6_1_15_r;

            act7_0_0_layer <= act7_0_0_r;        act7_0_1_layer <= act7_0_1_r;
            act7_0_2_layer <= act7_0_2_r;        act7_0_3_layer <= act7_0_3_r;
            act7_0_4_layer <= act7_0_4_r;        act7_0_5_layer <= act7_0_5_r;
            act7_0_6_layer <= act7_0_6_r;        act7_0_7_layer <= act7_0_7_r;
            act7_0_8_layer <= act7_0_8_r;        act7_0_9_layer <= act7_0_9_r;
            act7_0_10_layer <= act7_0_10_r;        act7_0_11_layer <= act7_0_11_r;
            act7_0_12_layer <= act7_0_12_r;        act7_0_13_layer <= act7_0_13_r;
            act7_0_14_layer <= act7_0_14_r;        act7_0_15_layer <= act7_0_15_r;

            act7_1_0_layer <= act7_1_0_r;        act7_1_1_layer <= act7_1_1_r;
            act7_1_2_layer <= act7_1_2_r;        act7_1_3_layer <= act7_1_3_r;
            act7_1_4_layer <= act7_1_4_r;        act7_1_5_layer <= act7_1_5_r;
            act7_1_6_layer <= act7_1_6_r;        act7_1_7_layer <= act7_1_7_r;
            act7_1_8_layer <= act7_1_8_r;        act7_1_9_layer <= act7_1_9_r;
            act7_1_10_layer <= act7_1_10_r;        act7_1_11_layer <= act7_1_11_r;
            act7_1_12_layer <= act7_1_12_r;        act7_1_13_layer <= act7_1_13_r;
            act7_1_14_layer <= act7_1_14_r;        act7_1_15_layer <= act7_1_15_r;
  end
   else begin 
            act0_0_0_layer <= act0_0_0_layer;        act0_0_1_layer <= act0_0_1_layer;
            act0_0_2_layer <= act0_0_2_layer;        act0_0_3_layer <= act0_0_3_layer;
            act0_0_4_layer <= act0_0_4_layer;        act0_0_5_layer <= act0_0_5_layer;
            act0_0_6_layer <= act0_0_6_layer;        act0_0_7_layer <= act0_0_7_layer;
            act0_0_8_layer <= act0_0_8_layer;        act0_0_9_layer <= act0_0_9_layer;
            act0_0_10_layer <= act0_0_10_layer;        act0_0_11_layer <= act0_0_11_layer;
            act0_0_12_layer <= act0_0_12_layer;        act0_0_13_layer <= act0_0_13_layer;
            act0_0_14_layer <= act0_0_14_layer;        act0_0_15_layer <= act0_0_15_layer;

            act0_1_0_layer <= act0_1_0_layer;        act0_1_1_layer <= act0_1_1_layer;
            act0_1_2_layer <= act0_1_2_layer;        act0_1_3_layer <= act0_1_3_layer;
            act0_1_4_layer <= act0_1_4_layer;        act0_1_5_layer <= act0_1_5_layer;
            act0_1_6_layer <= act0_1_6_layer;        act0_1_7_layer <= act0_1_7_layer;
            act0_1_8_layer <= act0_1_8_layer;        act0_1_9_layer <= act0_1_9_layer;
            act0_1_10_layer <= act0_1_10_layer;        act0_1_11_layer <= act0_1_11_layer;
            act0_1_12_layer <= act0_1_12_layer;        act0_1_13_layer <= act0_1_13_layer;
            act0_1_14_layer <= act0_1_14_layer;        act0_1_15_layer <= act0_1_15_layer;

            act1_0_0_layer <= act1_0_0_layer;        act1_0_1_layer <= act1_0_1_layer;
            act1_0_2_layer <= act1_0_2_layer;        act1_0_3_layer <= act1_0_3_layer;
            act1_0_4_layer <= act1_0_4_layer;        act1_0_5_layer <= act1_0_5_layer;
            act1_0_6_layer <= act1_0_6_layer;        act1_0_7_layer <= act1_0_7_layer;
            act1_0_8_layer <= act1_0_8_layer;        act1_0_9_layer <= act1_0_9_layer;
            act1_0_10_layer <= act1_0_10_layer;        act1_0_11_layer <= act1_0_11_layer;
            act1_0_12_layer <= act1_0_12_layer;        act1_0_13_layer <= act1_0_13_layer;
            act1_0_14_layer <= act1_0_14_layer;        act1_0_15_layer <= act1_0_15_layer;

            act1_1_0_layer <= act1_1_0_layer;        act1_1_1_layer <= act1_1_1_layer;
            act1_1_2_layer <= act1_1_2_layer;        act1_1_3_layer <= act1_1_3_layer;
            act1_1_4_layer <= act1_1_4_layer;        act1_1_5_layer <= act1_1_5_layer;
            act1_1_6_layer <= act1_1_6_layer;        act1_1_7_layer <= act1_1_7_layer;
            act1_1_8_layer <= act1_1_8_layer;        act1_1_9_layer <= act1_1_9_layer;
            act1_1_10_layer <= act1_1_10_layer;        act1_1_11_layer <= act1_1_11_layer;
            act1_1_12_layer <= act1_1_12_layer;        act1_1_13_layer <= act1_1_13_layer;
            act1_1_14_layer <= act1_1_14_layer;        act1_1_15_layer <= act1_1_15_layer;

            act2_0_0_layer <= act2_0_0_layer;        act2_0_1_layer <= act2_0_1_layer;
            act2_0_2_layer <= act2_0_2_layer;        act2_0_3_layer <= act2_0_3_layer;
            act2_0_4_layer <= act2_0_4_layer;        act2_0_5_layer <= act2_0_5_layer;
            act2_0_6_layer <= act2_0_6_layer;        act2_0_7_layer <= act2_0_7_layer;
            act2_0_8_layer <= act2_0_8_layer;        act2_0_9_layer <= act2_0_9_layer;
            act2_0_10_layer <= act2_0_10_layer;        act2_0_11_layer <= act2_0_11_layer;
            act2_0_12_layer <= act2_0_12_layer;        act2_0_13_layer <= act2_0_13_layer;
            act2_0_14_layer <= act2_0_14_layer;        act2_0_15_layer <= act2_0_15_layer;

            act2_1_0_layer <= act2_1_0_layer;        act2_1_1_layer <= act2_1_1_layer;
            act2_1_2_layer <= act2_1_2_layer;        act2_1_3_layer <= act2_1_3_layer;
            act2_1_4_layer <= act2_1_4_layer;        act2_1_5_layer <= act2_1_5_layer;
            act2_1_6_layer <= act2_1_6_layer;        act2_1_7_layer <= act2_1_7_layer;
            act2_1_8_layer <= act2_1_8_layer;        act2_1_9_layer <= act2_1_9_layer;
            act2_1_10_layer <= act2_1_10_layer;        act2_1_11_layer <= act2_1_11_layer;
            act2_1_12_layer <= act2_1_12_layer;        act2_1_13_layer <= act2_1_13_layer;
            act2_1_14_layer <= act2_1_14_layer;        act2_1_15_layer <= act2_1_15_layer;

            act3_0_0_layer <= act3_0_0_layer;        act3_0_1_layer <= act3_0_1_layer;
            act3_0_2_layer <= act3_0_2_layer;        act3_0_3_layer <= act3_0_3_layer;
            act3_0_4_layer <= act3_0_4_layer;        act3_0_5_layer <= act3_0_5_layer;
            act3_0_6_layer <= act3_0_6_layer;        act3_0_7_layer <= act3_0_7_layer;
            act3_0_8_layer <= act3_0_8_layer;        act3_0_9_layer <= act3_0_9_layer;
            act3_0_10_layer <= act3_0_10_layer;        act3_0_11_layer <= act3_0_11_layer;
            act3_0_12_layer <= act3_0_12_layer;        act3_0_13_layer <= act3_0_13_layer;
            act3_0_14_layer <= act3_0_14_layer;        act3_0_15_layer <= act3_0_15_layer;

            act3_1_0_layer <= act3_1_0_layer;        act3_1_1_layer <= act3_1_1_layer;
            act3_1_2_layer <= act3_1_2_layer;        act3_1_3_layer <= act3_1_3_layer;
            act3_1_4_layer <= act3_1_4_layer;        act3_1_5_layer <= act3_1_5_layer;
            act3_1_6_layer <= act3_1_6_layer;        act3_1_7_layer <= act3_1_7_layer;
            act3_1_8_layer <= act3_1_8_layer;        act3_1_9_layer <= act3_1_9_layer;
            act3_1_10_layer <= act3_1_10_layer;        act3_1_11_layer <= act3_1_11_layer;
            act3_1_12_layer <= act3_1_12_layer;        act3_1_13_layer <= act3_1_13_layer;
            act3_1_14_layer <= act3_1_14_layer;        act3_1_15_layer <= act3_1_15_layer;

            act4_0_0_layer <= act4_0_0_layer;        act4_0_1_layer <= act4_0_1_layer;
            act4_0_2_layer <= act4_0_2_layer;        act4_0_3_layer <= act4_0_3_layer;
            act4_0_4_layer <= act4_0_4_layer;        act4_0_5_layer <= act4_0_5_layer;
            act4_0_6_layer <= act4_0_6_layer;        act4_0_7_layer <= act4_0_7_layer;
            act4_0_8_layer <= act4_0_8_layer;        act4_0_9_layer <= act4_0_9_layer;
            act4_0_10_layer <= act4_0_10_layer;        act4_0_11_layer <= act4_0_11_layer;
            act4_0_12_layer <= act4_0_12_layer;        act4_0_13_layer <= act4_0_13_layer;
            act4_0_14_layer <= act4_0_14_layer;        act4_0_15_layer <= act4_0_15_layer;

            act4_1_0_layer <= act4_1_0_layer;        act4_1_1_layer <= act4_1_1_layer;
            act4_1_2_layer <= act4_1_2_layer;        act4_1_3_layer <= act4_1_3_layer;
            act4_1_4_layer <= act4_1_4_layer;        act4_1_5_layer <= act4_1_5_layer;
            act4_1_6_layer <= act4_1_6_layer;        act4_1_7_layer <= act4_1_7_layer;
            act4_1_8_layer <= act4_1_8_layer;        act4_1_9_layer <= act4_1_9_layer;
            act4_1_10_layer <= act4_1_10_layer;        act4_1_11_layer <= act4_1_11_layer;
            act4_1_12_layer <= act4_1_12_layer;        act4_1_13_layer <= act4_1_13_layer;
            act4_1_14_layer <= act4_1_14_layer;        act4_1_15_layer <= act4_1_15_layer;

            act5_0_0_layer <= act5_0_0_layer;        act5_0_1_layer <= act5_0_1_layer;
            act5_0_2_layer <= act5_0_2_layer;        act5_0_3_layer <= act5_0_3_layer;
            act5_0_4_layer <= act5_0_4_layer;        act5_0_5_layer <= act5_0_5_layer;
            act5_0_6_layer <= act5_0_6_layer;        act5_0_7_layer <= act5_0_7_layer;
            act5_0_8_layer <= act5_0_8_layer;        act5_0_9_layer <= act5_0_9_layer;
            act5_0_10_layer <= act5_0_10_layer;        act5_0_11_layer <= act5_0_11_layer;
            act5_0_12_layer <= act5_0_12_layer;        act5_0_13_layer <= act5_0_13_layer;
            act5_0_14_layer <= act5_0_14_layer;        act5_0_15_layer <= act5_0_15_layer;

            act5_1_0_layer <= act5_1_0_layer;        act5_1_1_layer <= act5_1_1_layer;
            act5_1_2_layer <= act5_1_2_layer;        act5_1_3_layer <= act5_1_3_layer;
            act5_1_4_layer <= act5_1_4_layer;        act5_1_5_layer <= act5_1_5_layer;
            act5_1_6_layer <= act5_1_6_layer;        act5_1_7_layer <= act5_1_7_layer;
            act5_1_8_layer <= act5_1_8_layer;        act5_1_9_layer <= act5_1_9_layer;
            act5_1_10_layer <= act5_1_10_layer;        act5_1_11_layer <= act5_1_11_layer;
            act5_1_12_layer <= act5_1_12_layer;        act5_1_13_layer <= act5_1_13_layer;
            act5_1_14_layer <= act5_1_14_layer;        act5_1_15_layer <= act5_1_15_layer;

            act6_0_0_layer <= act6_0_0_layer;        act6_0_1_layer <= act6_0_1_layer;
            act6_0_2_layer <= act6_0_2_layer;        act6_0_3_layer <= act6_0_3_layer;
            act6_0_4_layer <= act6_0_4_layer;        act6_0_5_layer <= act6_0_5_layer;
            act6_0_6_layer <= act6_0_6_layer;        act6_0_7_layer <= act6_0_7_layer;
            act6_0_8_layer <= act6_0_8_layer;        act6_0_9_layer <= act6_0_9_layer;
            act6_0_10_layer <= act6_0_10_layer;        act6_0_11_layer <= act6_0_11_layer;
            act6_0_12_layer <= act6_0_12_layer;        act6_0_13_layer <= act6_0_13_layer;
            act6_0_14_layer <= act6_0_14_layer;        act6_0_15_layer <= act6_0_15_layer;

            act6_1_0_layer <= act6_1_0_layer;        act6_1_1_layer <= act6_1_1_layer;
            act6_1_2_layer <= act6_1_2_layer;        act6_1_3_layer <= act6_1_3_layer;
            act6_1_4_layer <= act6_1_4_layer;        act6_1_5_layer <= act6_1_5_layer;
            act6_1_6_layer <= act6_1_6_layer;        act6_1_7_layer <= act6_1_7_layer;
            act6_1_8_layer <= act6_1_8_layer;        act6_1_9_layer <= act6_1_9_layer;
            act6_1_10_layer <= act6_1_10_layer;        act6_1_11_layer <= act6_1_11_layer;
            act6_1_12_layer <= act6_1_12_layer;        act6_1_13_layer <= act6_1_13_layer;
            act6_1_14_layer <= act6_1_14_layer;        act6_1_15_layer <= act6_1_15_layer;

            act7_0_0_layer <= act7_0_0_layer;        act7_0_1_layer <= act7_0_1_layer;
            act7_0_2_layer <= act7_0_2_layer;        act7_0_3_layer <= act7_0_3_layer;
            act7_0_4_layer <= act7_0_4_layer;        act7_0_5_layer <= act7_0_5_layer;
            act7_0_6_layer <= act7_0_6_layer;        act7_0_7_layer <= act7_0_7_layer;
            act7_0_8_layer <= act7_0_8_layer;        act7_0_9_layer <= act7_0_9_layer;
            act7_0_10_layer <= act7_0_10_layer;        act7_0_11_layer <= act7_0_11_layer;
            act7_0_12_layer <= act7_0_12_layer;        act7_0_13_layer <= act7_0_13_layer;
            act7_0_14_layer <= act7_0_14_layer;        act7_0_15_layer <= act7_0_15_layer;

            act7_1_0_layer <= act7_1_0_layer;        act7_1_1_layer <= act7_1_1_layer;
            act7_1_2_layer <= act7_1_2_layer;        act7_1_3_layer <= act7_1_3_layer;
            act7_1_4_layer <= act7_1_4_layer;        act7_1_5_layer <= act7_1_5_layer;
            act7_1_6_layer <= act7_1_6_layer;        act7_1_7_layer <= act7_1_7_layer;
            act7_1_8_layer <= act7_1_8_layer;        act7_1_9_layer <= act7_1_9_layer;
            act7_1_10_layer <= act7_1_10_layer;        act7_1_11_layer <= act7_1_11_layer;
            act7_1_12_layer <= act7_1_12_layer;        act7_1_13_layer <= act7_1_13_layer;
            act7_1_14_layer <= act7_1_14_layer;        act7_1_15_layer <= act7_1_15_layer;
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
    .inputs8_1              (inputs8_1),
    .inputs9_1              (inputs9_1),
    .inputs10_1             (inputs10_1),
    .inputs11_1             (inputs11_1),
    .inputs12_1             (inputs12_1),
    .inputs13_1             (inputs13_1),
    .inputs14_1             (inputs14_1),
    .inputs15_1             (inputs15_1),

// Updated port connections – every signal previously ending in _r is now suffixed _layer
    .act0_0_0               (act0_0_0_layer),
    .act0_0_1               (act0_0_1_layer),
    .act0_0_2               (act0_0_2_layer),
    .act0_0_3               (act0_0_3_layer),
    .act0_0_4               (act0_0_4_layer),
    .act0_0_5               (act0_0_5_layer),
    .act0_0_6               (act0_0_6_layer),
    .act0_0_7               (act0_0_7_layer),
    .act0_0_8               (act0_0_8_layer),
    .act0_0_9               (act0_0_9_layer),
    .act0_0_10              (act0_0_10_layer),
    .act0_0_11              (act0_0_11_layer),
    .act0_0_12              (act0_0_12_layer),
    .act0_0_13              (act0_0_13_layer),
    .act0_0_14              (act0_0_14_layer),
    .act0_0_15              (act0_0_15_layer),
    .act0_1_0               (act0_1_0_layer),
    .act0_1_1               (act0_1_1_layer),
    .act0_1_2               (act0_1_2_layer),
    .act0_1_3               (act0_1_3_layer),
    .act0_1_4               (act0_1_4_layer),
    .act0_1_5               (act0_1_5_layer),
    .act0_1_6               (act0_1_6_layer),
    .act0_1_7               (act0_1_7_layer),
    .act0_1_8               (act0_1_8_layer),
    .act0_1_9               (act0_1_9_layer),
    .act0_1_10              (act0_1_10_layer),
    .act0_1_11              (act0_1_11_layer),
    .act0_1_12              (act0_1_12_layer),
    .act0_1_13              (act0_1_13_layer),
    .act0_1_14              (act0_1_14_layer),
    .act0_1_15              (act0_1_15_layer),
    .act1_0_0               (act1_0_0_layer),
    .act1_0_1               (act1_0_1_layer),
    .act1_0_2               (act1_0_2_layer),
    .act1_0_3               (act1_0_3_layer),
    .act1_0_4               (act1_0_4_layer),
    .act1_0_5               (act1_0_5_layer),
    .act1_0_6               (act1_0_6_layer),
    .act1_0_7               (act1_0_7_layer),
    .act1_0_8               (act1_0_8_layer),
    .act1_0_9               (act1_0_9_layer),
    .act1_0_10              (act1_0_10_layer),
    .act1_0_11              (act1_0_11_layer),
    .act1_0_12              (act1_0_12_layer),
    .act1_0_13              (act1_0_13_layer),
    .act1_0_14              (act1_0_14_layer),
    .act1_0_15              (act1_0_15_layer),
    .act1_1_0               (act1_1_0_layer),
    .act1_1_1               (act1_1_1_layer),
    .act1_1_2               (act1_1_2_layer),
    .act1_1_3               (act1_1_3_layer),
    .act1_1_4               (act1_1_4_layer),
    .act1_1_5               (act1_1_5_layer),
    .act1_1_6               (act1_1_6_layer),
    .act1_1_7               (act1_1_7_layer),
    .act1_1_8               (act1_1_8_layer),
    .act1_1_9               (act1_1_9_layer),
    .act1_1_10              (act1_1_10_layer),
    .act1_1_11              (act1_1_11_layer),
    .act1_1_12              (act1_1_12_layer),
    .act1_1_13              (act1_1_13_layer),
    .act1_1_14              (act1_1_14_layer),
    .act1_1_15              (act1_1_15_layer),
    .act2_0_0               (act2_0_0_layer),
    .act2_0_1               (act2_0_1_layer),
    .act2_0_2               (act2_0_2_layer),
    .act2_0_3               (act2_0_3_layer),
    .act2_0_4               (act2_0_4_layer),
    .act2_0_5               (act2_0_5_layer),
    .act2_0_6               (act2_0_6_layer),
    .act2_0_7               (act2_0_7_layer),
    .act2_0_8               (act2_0_8_layer),
    .act2_0_9               (act2_0_9_layer),
    .act2_0_10              (act2_0_10_layer),
    .act2_0_11              (act2_0_11_layer),
    .act2_0_12              (act2_0_12_layer),
    .act2_0_13              (act2_0_13_layer),
    .act2_0_14              (act2_0_14_layer),
    .act2_0_15              (act2_0_15_layer),
    .act2_1_0               (act2_1_0_layer),
    .act2_1_1               (act2_1_1_layer),
    .act2_1_2               (act2_1_2_layer),
    .act2_1_3               (act2_1_3_layer),
    .act2_1_4               (act2_1_4_layer),
    .act2_1_5               (act2_1_5_layer),
    .act2_1_6               (act2_1_6_layer),
    .act2_1_7               (act2_1_7_layer),
    .act2_1_8               (act2_1_8_layer),
    .act2_1_9               (act2_1_9_layer),
    .act2_1_10              (act2_1_10_layer),
    .act2_1_11              (act2_1_11_layer),
    .act2_1_12              (act2_1_12_layer),
    .act2_1_13              (act2_1_13_layer),
    .act2_1_14              (act2_1_14_layer),
    .act2_1_15              (act2_1_15_layer),
    .act3_0_0               (act3_0_0_layer),
    .act3_0_1               (act3_0_1_layer),
    .act3_0_2               (act3_0_2_layer),
    .act3_0_3               (act3_0_3_layer),
    .act3_0_4               (act3_0_4_layer),
    .act3_0_5               (act3_0_5_layer),
    .act3_0_6               (act3_0_6_layer),
    .act3_0_7               (act3_0_7_layer),
    .act3_0_8               (act3_0_8_layer),
    .act3_0_9               (act3_0_9_layer),
    .act3_0_10              (act3_0_10_layer),
    .act3_0_11              (act3_0_11_layer),
    .act3_0_12              (act3_0_12_layer),
    .act3_0_13              (act3_0_13_layer),
    .act3_0_14              (act3_0_14_layer),
    .act3_0_15              (act3_0_15_layer),
    .act3_1_0               (act3_1_0_layer),
    .act3_1_1               (act3_1_1_layer),
    .act3_1_2               (act3_1_2_layer),
    .act3_1_3               (act3_1_3_layer),
    .act3_1_4               (act3_1_4_layer),
    .act3_1_5               (act3_1_5_layer),
    .act3_1_6               (act3_1_6_layer),
    .act3_1_7               (act3_1_7_layer),
    .act3_1_8               (act3_1_8_layer),
    .act3_1_9               (act3_1_9_layer),
    .act3_1_10              (act3_1_10_layer),
    .act3_1_11              (act3_1_11_layer),
    .act3_1_12              (act3_1_12_layer),
    .act3_1_13              (act3_1_13_layer),
    .act3_1_14              (act3_1_14_layer),
    .act3_1_15              (act3_1_15_layer),
    .act4_0_0               (act4_0_0_layer),
    .act4_0_1               (act4_0_1_layer),
    .act4_0_2               (act4_0_2_layer),
    .act4_0_3               (act4_0_3_layer),
    .act4_0_4               (act4_0_4_layer),
    .act4_0_5               (act4_0_5_layer),
    .act4_0_6               (act4_0_6_layer),
    .act4_0_7               (act4_0_7_layer),
    .act4_0_8               (act4_0_8_layer),
    .act4_0_9               (act4_0_9_layer),
    .act4_0_10              (act4_0_10_layer),
    .act4_0_11              (act4_0_11_layer),
    .act4_0_12              (act4_0_12_layer),
    .act4_0_13              (act4_0_13_layer),
    .act4_0_14              (act4_0_14_layer),
    .act4_0_15              (act4_0_15_layer),
    .act4_1_0               (act4_1_0_layer),
    .act4_1_1               (act4_1_1_layer),
    .act4_1_2               (act4_1_2_layer),
    .act4_1_3               (act4_1_3_layer),
    .act4_1_4               (act4_1_4_layer),
    .act4_1_5               (act4_1_5_layer),
    .act4_1_6               (act4_1_6_layer),
    .act4_1_7               (act4_1_7_layer),
    .act4_1_8               (act4_1_8_layer),
    .act4_1_9               (act4_1_9_layer),
    .act4_1_10              (act4_1_10_layer),
    .act4_1_11              (act4_1_11_layer),
    .act4_1_12              (act4_1_12_layer),
    .act4_1_13              (act4_1_13_layer),
    .act4_1_14              (act4_1_14_layer),
    .act4_1_15              (act4_1_15_layer),
    .act5_0_0               (act5_0_0_layer),
    .act5_0_1               (act5_0_1_layer),
    .act5_0_2               (act5_0_2_layer),
    .act5_0_3               (act5_0_3_layer),
    .act5_0_4               (act5_0_4_layer),
    .act5_0_5               (act5_0_5_layer),
    .act5_0_6               (act5_0_6_layer),
    .act5_0_7               (act5_0_7_layer),
    .act5_0_8               (act5_0_8_layer),
    .act5_0_9               (act5_0_9_layer),
    .act5_0_10              (act5_0_10_layer),
    .act5_0_11              (act5_0_11_layer),
    .act5_0_12              (act5_0_12_layer),
    .act5_0_13              (act5_0_13_layer),
    .act5_0_14              (act5_0_14_layer),
    .act5_0_15              (act5_0_15_layer),
    .act5_1_0               (act5_1_0_layer),
    .act5_1_1               (act5_1_1_layer),
    .act5_1_2               (act5_1_2_layer),
    .act5_1_3               (act5_1_3_layer),
    .act5_1_4               (act5_1_4_layer),
    .act5_1_5               (act5_1_5_layer),
    .act5_1_6               (act5_1_6_layer),
    .act5_1_7               (act5_1_7_layer),
    .act5_1_8               (act5_1_8_layer),
    .act5_1_9               (act5_1_9_layer),
    .act5_1_10              (act5_1_10_layer),
    .act5_1_11              (act5_1_11_layer),
    .act5_1_12              (act5_1_12_layer),
    .act5_1_13              (act5_1_13_layer),
    .act5_1_14              (act5_1_14_layer),
    .act5_1_15              (act5_1_15_layer),
    .act6_0_0               (act6_0_0_layer),
    .act6_0_1               (act6_0_1_layer),
    .act6_0_2               (act6_0_2_layer),
    .act6_0_3               (act6_0_3_layer),
    .act6_0_4               (act6_0_4_layer),
    .act6_0_5               (act6_0_5_layer),
    .act6_0_6               (act6_0_6_layer),
    .act6_0_7               (act6_0_7_layer),
    .act6_0_8               (act6_0_8_layer),
    .act6_0_9               (act6_0_9_layer),
    .act6_0_10              (act6_0_10_layer),
    .act6_0_11              (act6_0_11_layer),
    .act6_0_12              (act6_0_12_layer),
    .act6_0_13              (act6_0_13_layer),
    .act6_0_14              (act6_0_14_layer),
    .act6_0_15              (act6_0_15_layer),
    .act6_1_0               (act6_1_0_layer),
    .act6_1_1               (act6_1_1_layer),
    .act6_1_2               (act6_1_2_layer),
    .act6_1_3               (act6_1_3_layer),
    .act6_1_4               (act6_1_4_layer),
    .act6_1_5               (act6_1_5_layer),
    .act6_1_6               (act6_1_6_layer),
    .act6_1_7               (act6_1_7_layer),
    .act6_1_8               (act6_1_8_layer),
    .act6_1_9               (act6_1_9_layer),
    .act6_1_10              (act6_1_10_layer),
    .act6_1_11              (act6_1_11_layer),
    .act6_1_12              (act6_1_12_layer),
    .act6_1_13              (act6_1_13_layer),
    .act6_1_14              (act6_1_14_layer),
    .act6_1_15              (act6_1_15_layer),
    .act7_0_0               (act7_0_0_layer),
    .act7_0_1               (act7_0_1_layer),
    .act7_0_2               (act7_0_2_layer),
    .act7_0_3               (act7_0_3_layer),
    .act7_0_4               (act7_0_4_layer),
    .act7_0_5               (act7_0_5_layer),
    .act7_0_6               (act7_0_6_layer),
    .act7_0_7               (act7_0_7_layer),
    .act7_0_8               (act7_0_8_layer),
    .act7_0_9               (act7_0_9_layer),
    .act7_0_10              (act7_0_10_layer),
    .act7_0_11              (act7_0_11_layer),
    .act7_0_12              (act7_0_12_layer),
    .act7_0_13              (act7_0_13_layer),
    .act7_0_14              (act7_0_14_layer),
    .act7_0_15              (act7_0_15_layer),
    .act7_1_0               (act7_1_0_layer),
    .act7_1_1               (act7_1_1_layer),
    .act7_1_2               (act7_1_2_layer),
    .act7_1_3               (act7_1_3_layer),
    .act7_1_4               (act7_1_4_layer),
    .act7_1_5               (act7_1_5_layer),
    .act7_1_6               (act7_1_6_layer),
    .act7_1_7               (act7_1_7_layer),
    .act7_1_8               (act7_1_8_layer),
    .act7_1_9               (act7_1_9_layer),
    .act7_1_10              (act7_1_10_layer),
    .act7_1_11              (act7_1_11_layer),
    .act7_1_12              (act7_1_12_layer),
    .act7_1_13              (act7_1_13_layer),
    .act7_1_14              (act7_1_14_layer),
    .act7_1_15              (act7_1_15_layer),

    .w1_0_1                 (w1_0_1),
    .w1_1_1                 (w1_1_1),
    .w2_0_1                 (w2_0_1),
    .w2_1_1                 (w2_1_1),
    .w3_0_1                 (w3_0_1),
    .w3_1_1                 (w3_1_1),
    .w4_0_1                 (w4_0_1),
    .w4_1_1                 (w4_1_1),
    .w5_0_1                 (w5_0_1),
    .w5_1_1                 (w5_1_1),
    .w6_0_1                 (w6_0_1),
    .w6_1_1                 (w6_1_1),
    .w7_0_1                 (w7_0_1),
    .w7_1_1                 (w7_1_1),
    .w8_0_1                 (w8_0_1),
    .w8_1_1                 (w8_1_1),

    .b1_1                   (b1_1),
    .b2_1                   (b2_1),
    .b3_1                   (b3_1),
    .b4_1                   (b4_1),
    .b5_1                   (b5_1),
    .b6_1                   (b6_1),
    .b7_1                   (b7_1),
    .b8_1                   (b8_1),
    .b1_2                   (b1_2),
    .b2_2                   (b2_2),
    .b3_2                   (b3_2),
    .b4_2                   (b4_2),
    .b5_2                   (b5_2),
    .b6_2                   (b6_2),
    .b7_2                   (b7_2),
    .b8_2                   (b8_2),
    .b1_3                   (b1_3),
    .b2_3                   (b2_3),
    .b3_3                   (b3_3),
    .b4_3                   (b4_3),
    .b5_3                   (b5_3),
    .b6_3                   (b6_3),
    .b7_3                   (b7_3),
    .b8_3                   (b8_3),
    .b1_4                   (b1_4),
    .b2_4                   (b2_4),
    .b3_4                   (b3_4),
    .b4_4                   (b4_4),
    .b5_4                   (b5_4),
    .b6_4                   (b6_4),
    .b7_4                   (b7_4),
    .b8_4                   (b8_4),

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
    .biased_sum4_0_r        (biased_sum4_0),
    .biased_sum4_0bar_r     (biased_sum4_0bar),
    .biased_sum4_1_r        (biased_sum4_1),
    .biased_sum4_1bar_r     (biased_sum4_1bar),
    .biased_sum5_0_r        (biased_sum5_0),
    .biased_sum5_0bar_r     (biased_sum5_0bar),
    .biased_sum5_1_r        (biased_sum5_1),
    .biased_sum5_1bar_r     (biased_sum5_1bar),
    .biased_sum6_0_r        (biased_sum6_0),
    .biased_sum6_0bar_r     (biased_sum6_0bar),
    .biased_sum6_1_r        (biased_sum6_1),
    .biased_sum6_1bar_r     (biased_sum6_1bar),
    .biased_sum7_0_r        (biased_sum7_0),
    .biased_sum7_0bar_r     (biased_sum7_0bar),
    .biased_sum7_1_r        (biased_sum7_1),
    .biased_sum7_1bar_r     (biased_sum7_1bar),

    .masked_activation0_1_r (masked_activation0_1),
    .masked_activation1_1_r (masked_activation1_1),
    .masked_activation2_1_r (masked_activation2_1),
    .masked_activation3_1_r (masked_activation3_1),
    .masked_activation4_1_r (masked_activation4_1),
    .masked_activation5_1_r (masked_activation5_1),
    .masked_activation6_1_r (masked_activation6_1),
    .masked_activation7_1_r (masked_activation7_1),
    .masked_activation0bar_1_r (masked_activation0bar_1),
    .masked_activation1bar_1_r (masked_activation1bar_1),
    .masked_activation2bar_1_r (masked_activation2bar_1),
    .masked_activation3bar_1_r (masked_activation3bar_1),
    .masked_activation4bar_1_r (masked_activation4bar_1),
    .masked_activation5bar_1_r (masked_activation5bar_1),
    .masked_activation6bar_1_r (masked_activation6bar_1),
    .masked_activation7bar_1_r (masked_activation7bar_1),

    .mask0_1_r              (mask0_1),
    .mask1_1_r              (mask1_1),
    .mask2_1_r              (mask2_1),
    .mask3_1_r              (mask3_1),
    .mask4_1_r              (mask4_1),
    .mask5_1_r              (mask5_1),
    .mask6_1_r              (mask6_1),
    .mask7_1_r              (mask7_1),
    .mask0bar_1_r           (mask0bar_1),
    .mask1bar_1_r           (mask1bar_1),
    .mask2bar_1_r           (mask2bar_1),
    .mask3bar_1_r           (mask3bar_1),
    .mask4bar_1_r           (mask4bar_1),
    .mask5bar_1_r           (mask5bar_1),
    .mask6bar_1_r           (mask6bar_1),
    .mask7bar_1_r           (mask7bar_1)
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
    .masked_activation4_1   (masked_activation4_1),
    .masked_activation5_1   (masked_activation5_1),
    .masked_activation6_1   (masked_activation6_1),
    .masked_activation7_1   (masked_activation7_1),
    .mask0_1                (mask0_1),
    .mask1_1                (mask1_1),
    .mask2_1                (mask2_1),
    .mask3_1                (mask3_1),
    .mask4_1                (mask4_1),
    .mask5_1                (mask5_1),
    .mask6_1                (mask6_1),
    .mask7_1                (mask7_1),

    .w1_0_2                 (w1_0_2),
    .w1_1_2                 (w1_1_2),
    .w2_0_2                 (w2_0_2),
    .w2_1_2                 (w2_1_2),
    .w3_0_2                 (w3_0_2),
    .w3_1_2                 (w3_1_2),
    .w4_0_2                 (w4_0_2),
    .w4_1_2                 (w4_1_2),
    .w5_0_2                 (w5_0_2),
    .w5_1_2                 (w5_1_2),
    .w6_0_2                 (w6_0_2),
    .w6_1_2                 (w6_1_2),
    .w7_0_2                 (w7_0_2),
    .w7_1_2                 (w7_1_2),
    .w8_0_2                 (w8_0_2),
    .w8_1_2                 (w8_1_2),
    .w1_0_3                 (w1_0_3),
    .w1_1_3                 (w1_1_3),
    .w2_0_3                 (w2_0_3),
    .w2_1_3                 (w2_1_3),
    .w3_0_3                 (w3_0_3),
    .w3_1_3                 (w3_1_3),
    .w4_0_3                 (w4_0_3),
    .w4_1_3                 (w4_1_3),
    .w5_0_3                 (w5_0_3),
    .w5_1_3                 (w5_1_3),
    .w6_0_3                 (w6_0_3),
    .w6_1_3                 (w6_1_3),
    .w7_0_3                 (w7_0_3),
    .w7_1_3                 (w7_1_3),
    .w8_0_3                 (w8_0_3),
    .w8_1_3                 (w8_1_3),
    .w1_0_4                 (w1_0_4),
    .w1_1_4                 (w1_1_4),
    .w2_0_4                 (w2_0_4),
    .w2_1_4                 (w2_1_4),
    .w3_0_4                 (w3_0_4),
    .w3_1_4                 (w3_1_4),
    .w4_0_4                 (w4_0_4),
    .w4_1_4                 (w4_1_4),
    .w5_0_4                 (w5_0_4),
    .w5_1_4                 (w5_1_4),
    .w6_0_4                 (w6_0_4),
    .w6_1_4                 (w6_1_4),
    .w7_0_4                 (w7_0_4),
    .w7_1_4                 (w7_1_4),
    .w8_0_4                 (w8_0_4),
    .w8_1_4                 (w8_1_4),

    .s                      (s_count),

    .act0_0_0_r             (act0_0_0_r),
    .act0_0_1_r             (act0_0_1_r),
    .act0_0_2_r             (act0_0_2_r),
    .act0_0_3_r             (act0_0_3_r),
    .act0_0_4_r             (act0_0_4_r),
    .act0_0_5_r             (act0_0_5_r),
    .act0_0_6_r             (act0_0_6_r),
    .act0_0_7_r             (act0_0_7_r),
    .act0_0_8_r             (act0_0_8_r),
    .act0_0_9_r             (act0_0_9_r),
    .act0_0_10_r            (act0_0_10_r),
    .act0_0_11_r            (act0_0_11_r),
    .act0_0_12_r            (act0_0_12_r),
    .act0_0_13_r            (act0_0_13_r),
    .act0_0_14_r            (act0_0_14_r),
    .act0_0_15_r            (act0_0_15_r),
    .act0_1_0_r             (act0_1_0_r),
    .act0_1_1_r             (act0_1_1_r),
    .act0_1_2_r             (act0_1_2_r),
    .act0_1_3_r             (act0_1_3_r),
    .act0_1_4_r             (act0_1_4_r),
    .act0_1_5_r             (act0_1_5_r),
    .act0_1_6_r             (act0_1_6_r),
    .act0_1_7_r             (act0_1_7_r),
    .act0_1_8_r             (act0_1_8_r),
    .act0_1_9_r             (act0_1_9_r),
    .act0_1_10_r            (act0_1_10_r),
    .act0_1_11_r            (act0_1_11_r),
    .act0_1_12_r            (act0_1_12_r),
    .act0_1_13_r            (act0_1_13_r),
    .act0_1_14_r            (act0_1_14_r),
    .act0_1_15_r            (act0_1_15_r),
    .act1_0_0_r             (act1_0_0_r),
    .act1_0_1_r             (act1_0_1_r),
    .act1_0_2_r             (act1_0_2_r),
    .act1_0_3_r             (act1_0_3_r),
    .act1_0_4_r             (act1_0_4_r),
    .act1_0_5_r             (act1_0_5_r),
    .act1_0_6_r             (act1_0_6_r),
    .act1_0_7_r             (act1_0_7_r),
    .act1_0_8_r             (act1_0_8_r),
    .act1_0_9_r             (act1_0_9_r),
    .act1_0_10_r            (act1_0_10_r),
    .act1_0_11_r            (act1_0_11_r),
    .act1_0_12_r            (act1_0_12_r),
    .act1_0_13_r            (act1_0_13_r),
    .act1_0_14_r            (act1_0_14_r),
    .act1_0_15_r            (act1_0_15_r),
    .act1_1_0_r             (act1_1_0_r),
    .act1_1_1_r             (act1_1_1_r),
    .act1_1_2_r             (act1_1_2_r),
    .act1_1_3_r             (act1_1_3_r),
    .act1_1_4_r             (act1_1_4_r),
    .act1_1_5_r             (act1_1_5_r),
    .act1_1_6_r             (act1_1_6_r),
    .act1_1_7_r             (act1_1_7_r),
    .act1_1_8_r             (act1_1_8_r),
    .act1_1_9_r             (act1_1_9_r),
    .act1_1_10_r            (act1_1_10_r),
    .act1_1_11_r            (act1_1_11_r),
    .act1_1_12_r            (act1_1_12_r),
    .act1_1_13_r            (act1_1_13_r),
    .act1_1_14_r            (act1_1_14_r),
    .act1_1_15_r            (act1_1_15_r),
    .act2_0_0_r             (act2_0_0_r),
    .act2_0_1_r             (act2_0_1_r),
    .act2_0_2_r             (act2_0_2_r),
    .act2_0_3_r             (act2_0_3_r),
    .act2_0_4_r             (act2_0_4_r),
    .act2_0_5_r             (act2_0_5_r),
    .act2_0_6_r             (act2_0_6_r),
    .act2_0_7_r             (act2_0_7_r),
    .act2_0_8_r             (act2_0_8_r),
    .act2_0_9_r             (act2_0_9_r),
    .act2_0_10_r            (act2_0_10_r),
    .act2_0_11_r            (act2_0_11_r),
    .act2_0_12_r            (act2_0_12_r),
    .act2_0_13_r            (act2_0_13_r),
    .act2_0_14_r            (act2_0_14_r),
    .act2_0_15_r            (act2_0_15_r),
    .act2_1_0_r             (act2_1_0_r),
    .act2_1_1_r             (act2_1_1_r),
    .act2_1_2_r             (act2_1_2_r),
    .act2_1_3_r             (act2_1_3_r),
    .act2_1_4_r             (act2_1_4_r),
    .act2_1_5_r             (act2_1_5_r),
    .act2_1_6_r             (act2_1_6_r),
    .act2_1_7_r             (act2_1_7_r),
    .act2_1_8_r             (act2_1_8_r),
    .act2_1_9_r             (act2_1_9_r),
    .act2_1_10_r            (act2_1_10_r),
    .act2_1_11_r            (act2_1_11_r),
    .act2_1_12_r            (act2_1_12_r),
    .act2_1_13_r            (act2_1_13_r),
    .act2_1_14_r            (act2_1_14_r),
    .act2_1_15_r            (act2_1_15_r),
    .act3_0_0_r             (act3_0_0_r),
    .act3_0_1_r             (act3_0_1_r),
    .act3_0_2_r             (act3_0_2_r),
    .act3_0_3_r             (act3_0_3_r),
    .act3_0_4_r             (act3_0_4_r),
    .act3_0_5_r             (act3_0_5_r),
    .act3_0_6_r             (act3_0_6_r),
    .act3_0_7_r             (act3_0_7_r),
    .act3_0_8_r             (act3_0_8_r),
    .act3_0_9_r             (act3_0_9_r),
    .act3_0_10_r            (act3_0_10_r),
    .act3_0_11_r            (act3_0_11_r),
    .act3_0_12_r            (act3_0_12_r),
    .act3_0_13_r            (act3_0_13_r),
    .act3_0_14_r            (act3_0_14_r),
    .act3_0_15_r            (act3_0_15_r),
    .act3_1_0_r             (act3_1_0_r),
    .act3_1_1_r             (act3_1_1_r),
    .act3_1_2_r             (act3_1_2_r),
    .act3_1_3_r             (act3_1_3_r),
    .act3_1_4_r             (act3_1_4_r),
    .act3_1_5_r             (act3_1_5_r),
    .act3_1_6_r             (act3_1_6_r),
    .act3_1_7_r             (act3_1_7_r),
    .act3_1_8_r             (act3_1_8_r),
    .act3_1_9_r             (act3_1_9_r),
    .act3_1_10_r            (act3_1_10_r),
    .act3_1_11_r            (act3_1_11_r),
    .act3_1_12_r            (act3_1_12_r),
    .act3_1_13_r            (act3_1_13_r),
    .act3_1_14_r            (act3_1_14_r),
    .act3_1_15_r            (act3_1_15_r),
    .act4_0_0_r             (act4_0_0_r),
    .act4_0_1_r             (act4_0_1_r),
    .act4_0_2_r             (act4_0_2_r),
    .act4_0_3_r             (act4_0_3_r),
    .act4_0_4_r             (act4_0_4_r),
    .act4_0_5_r             (act4_0_5_r),
    .act4_0_6_r             (act4_0_6_r),
    .act4_0_7_r             (act4_0_7_r),
    .act4_0_8_r             (act4_0_8_r),
    .act4_0_9_r             (act4_0_9_r),
    .act4_0_10_r            (act4_0_10_r),
    .act4_0_11_r            (act4_0_11_r),
    .act4_0_12_r            (act4_0_12_r),
    .act4_0_13_r            (act4_0_13_r),
    .act4_0_14_r            (act4_0_14_r),
    .act4_0_15_r            (act4_0_15_r),
    .act4_1_0_r             (act4_1_0_r),
    .act4_1_1_r             (act4_1_1_r),
    .act4_1_2_r             (act4_1_2_r),
    .act4_1_3_r             (act4_1_3_r),
    .act4_1_4_r             (act4_1_4_r),
    .act4_1_5_r             (act4_1_5_r),
    .act4_1_6_r             (act4_1_6_r),
    .act4_1_7_r             (act4_1_7_r),
    .act4_1_8_r             (act4_1_8_r),
    .act4_1_9_r             (act4_1_9_r),
    .act4_1_10_r            (act4_1_10_r),
    .act4_1_11_r            (act4_1_11_r),
    .act4_1_12_r            (act4_1_12_r),
    .act4_1_13_r            (act4_1_13_r),
    .act4_1_14_r            (act4_1_14_r),
    .act4_1_15_r            (act4_1_15_r),
    .act5_0_0_r             (act5_0_0_r),
    .act5_0_1_r             (act5_0_1_r),
    .act5_0_2_r             (act5_0_2_r),
    .act5_0_3_r             (act5_0_3_r),
    .act5_0_4_r             (act5_0_4_r),
    .act5_0_5_r             (act5_0_5_r),
    .act5_0_6_r             (act5_0_6_r),
    .act5_0_7_r             (act5_0_7_r),
    .act5_0_8_r             (act5_0_8_r),
    .act5_0_9_r             (act5_0_9_r),
    .act5_0_10_r            (act5_0_10_r),
    .act5_0_11_r            (act5_0_11_r),
    .act5_0_12_r            (act5_0_12_r),
    .act5_0_13_r            (act5_0_13_r),
    .act5_0_14_r            (act5_0_14_r),
    .act5_0_15_r            (act5_0_15_r),
    .act5_1_0_r             (act5_1_0_r),
    .act5_1_1_r             (act5_1_1_r),
    .act5_1_2_r             (act5_1_2_r),
    .act5_1_3_r             (act5_1_3_r),
    .act5_1_4_r             (act5_1_4_r),
    .act5_1_5_r             (act5_1_5_r),
    .act5_1_6_r             (act5_1_6_r),
    .act5_1_7_r             (act5_1_7_r),
    .act5_1_8_r             (act5_1_8_r),
    .act5_1_9_r             (act5_1_9_r),
    .act5_1_10_r            (act5_1_10_r),
    .act5_1_11_r            (act5_1_11_r),
    .act5_1_12_r            (act5_1_12_r),
    .act5_1_13_r            (act5_1_13_r),
    .act5_1_14_r            (act5_1_14_r),
    .act5_1_15_r            (act5_1_15_r),
    .act6_0_0_r             (act6_0_0_r),
    .act6_0_1_r             (act6_0_1_r),
    .act6_0_2_r             (act6_0_2_r),
    .act6_0_3_r             (act6_0_3_r),
    .act6_0_4_r             (act6_0_4_r),
    .act6_0_5_r             (act6_0_5_r),
    .act6_0_6_r             (act6_0_6_r),
    .act6_0_7_r             (act6_0_7_r),
    .act6_0_8_r             (act6_0_8_r),
    .act6_0_9_r             (act6_0_9_r),
    .act6_0_10_r            (act6_0_10_r),
    .act6_0_11_r            (act6_0_11_r),
    .act6_0_12_r            (act6_0_12_r),
    .act6_0_13_r            (act6_0_13_r),
    .act6_0_14_r            (act6_0_14_r),
    .act6_0_15_r            (act6_0_15_r),
    .act6_1_0_r             (act6_1_0_r),
    .act6_1_1_r             (act6_1_1_r),
    .act6_1_2_r             (act6_1_2_r),
    .act6_1_3_r             (act6_1_3_r),
    .act6_1_4_r             (act6_1_4_r),
    .act6_1_5_r             (act6_1_5_r),
    .act6_1_6_r             (act6_1_6_r),
    .act6_1_7_r             (act6_1_7_r),
    .act6_1_8_r             (act6_1_8_r),
    .act6_1_9_r             (act6_1_9_r),
    .act6_1_10_r            (act6_1_10_r),
    .act6_1_11_r            (act6_1_11_r),
    .act6_1_12_r            (act6_1_12_r),
    .act6_1_13_r            (act6_1_13_r),
    .act6_1_14_r            (act6_1_14_r),
    .act6_1_15_r            (act6_1_15_r),
    .act7_0_0_r             (act7_0_0_r),
    .act7_0_1_r             (act7_0_1_r),
    .act7_0_2_r             (act7_0_2_r),
    .act7_0_3_r             (act7_0_3_r),
    .act7_0_4_r             (act7_0_4_r),
    .act7_0_5_r             (act7_0_5_r),
    .act7_0_6_r             (act7_0_6_r),
    .act7_0_7_r             (act7_0_7_r),
    .act7_0_8_r             (act7_0_8_r),
    .act7_0_9_r             (act7_0_9_r),
    .act7_0_10_r            (act7_0_10_r),
    .act7_0_11_r            (act7_0_11_r),
    .act7_0_12_r            (act7_0_12_r),
    .act7_0_13_r            (act7_0_13_r),
    .act7_0_14_r            (act7_0_14_r),
    .act7_0_15_r            (act7_0_15_r),
    .act7_1_0_r             (act7_1_0_r),
    .act7_1_1_r             (act7_1_1_r),
    .act7_1_2_r             (act7_1_2_r),
    .act7_1_3_r             (act7_1_3_r),
    .act7_1_4_r             (act7_1_4_r),
    .act7_1_5_r             (act7_1_5_r),
    .act7_1_6_r             (act7_1_6_r),
    .act7_1_7_r             (act7_1_7_r),
    .act7_1_8_r             (act7_1_8_r),
    .act7_1_9_r             (act7_1_9_r),
    .act7_1_10_r            (act7_1_10_r),
    .act7_1_11_r            (act7_1_11_r),
    .act7_1_12_r            (act7_1_12_r),
    .act7_1_13_r            (act7_1_13_r),
    .act7_1_14_r            (act7_1_14_r),
    .act7_1_15_r            (act7_1_15_r)
  );

  output_layer dut (
    .clk                    (clk),
    .biased_sum0_0    (biased_sum0_0),
    .biased_sum0_1    (biased_sum0_1),
    .biased_sum1_0    (biased_sum1_0),
    .biased_sum1_1    (biased_sum1_1),
    .biased_sum2_0    (biased_sum2_0),
    .biased_sum2_1    (biased_sum2_1),
    .biased_sum3_0    (biased_sum3_0),
    .biased_sum3_1    (biased_sum3_1),
    .biased_sum0_0bar (biased_sum0_0bar),
    .biased_sum0_1bar (biased_sum0_1bar),
    .biased_sum1_0bar (biased_sum1_0bar),
    .biased_sum1_1bar (biased_sum1_1bar),
    .biased_sum2_0bar (biased_sum2_0bar),
    .biased_sum2_1bar (biased_sum2_1bar),
    .biased_sum3_0bar (biased_sum3_0bar),
    .biased_sum3_1bar (biased_sum3_1bar),
    .a0               (a0),
    .a1               (a1),
    .a2               (a2),
    .a3               (a3),
    .a0_bar           (a0_bar),
    .a1_bar           (a1_bar),
    .a2_bar           (a2_bar),
    .a3_bar           (a3_bar)
  );

endmodule

