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

module add3bit_1(
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

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNAND_1 wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout;

endmodule

module add4bit_1(
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

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNAND_1 wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout;

endmodule

module add5bit_1(
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

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNAND_1 wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout;

endmodule

module add6bit_1(
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

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNAND_1 wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout;

endmodule

module add7bit_1(
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

full_adder_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));

WddlNAND_1 wn1(.A(~a[6]), .B(b[6]), .C(~c7), .S(s1), .S1(s1_1));
WddlNAND_1 wn2(.A(a[6]), .B(~b[6]), .C(~c7), .S(s2), .S1(s2_1));
WddlNAND_1 wn3(.A(a[6]), .B(b[6]), .C(c7), .S(s3), .S1(s3_1));
WddlNAND_1 wn4(.A(~a[6]), .B(~b[6]), .C(c7), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[7] = cout;

endmodule


module half_adderbar_1(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adderbar_1(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adderbar_1 HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adderbar_1 HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNANDbar_1(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule

module add3bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNANDbar_1 wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout_bar;

endmodule

module add4bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNANDbar_1 wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout_bar;

endmodule

module add5bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNANDbar_1 wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout_bar;

endmodule

module add6bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNANDbar_1 wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout_bar;

endmodule

module add7bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));

WddlNANDbar_1 wn1(.A(~a[6]), .B(b[6]), .C(~c7), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[6]), .B(~b[6]), .C(~c7), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[6]), .B(b[6]), .C(c7), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[6]), .B(~b[6]), .C(c7), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[7] = cout_bar;

endmodule



module adder_tree_1 (
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

    add3bit_1 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bit_1 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bit_1 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bit_1 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add3bit_1 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo), .cout(), .cout_bar());
    add3bit_1 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo), .cout(), .cout_bar());
    add3bit_1 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo), .cout(), .cout_bar());
    add3bit_1 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo), .cout(), .cout_bar());
    add4bit_1 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bit_1 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add4bit_1 u1_2 (.a(stage0_4), .b(stage0_5), .cin(1'b0), .y(stage1_2_lo), .cout(), .cout_bar());
    add4bit_1 u1_3 (.a(stage0_6), .b(stage0_7), .cin(1'b0), .y(stage1_3_lo), .cout(), .cout_bar());
    add5bit_1 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());
    add5bit_1 u2_1 (.a(stage1_2), .b(stage1_3), .cin(1'b0), .y(stage2_1_lo), .cout(), .cout_bar());
    add6bit_1 u3_0 (.a(stage2_0), .b(stage2_1), .cin(1'b0), .y(stage3_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage3_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage0_4 = {1'b0, stage0_4_lo};
        stage0_5 = {1'b0, stage0_5_lo};
        stage0_6 = {1'b0, stage0_6_lo};
        stage0_7 = {1'b0, stage0_7_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage1_2 = {1'b0, stage1_2_lo};
        stage1_3 = {1'b0, stage1_3_lo};
        stage2_0 = {1'b0, stage2_0_lo};
        stage2_1 = {1'b0, stage2_1_lo};
        stage3_0 = {1'b0, stage3_0_lo};
    end
endmodule


module adder_tree_bar_1 (
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

    add3bitbar_1 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo), .cout(), .cout_bar());
    add4bitbar_1 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bitbar_1 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add4bitbar_1 u1_2 (.a(stage0_4), .b(stage0_5), .cin(1'b0), .y(stage1_2_lo), .cout(), .cout_bar());
    add4bitbar_1 u1_3 (.a(stage0_6), .b(stage0_7), .cin(1'b0), .y(stage1_3_lo), .cout(), .cout_bar());
    add5bitbar_1 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());
    add5bitbar_1 u2_1 (.a(stage1_2), .b(stage1_3), .cin(1'b0), .y(stage2_1_lo), .cout(), .cout_bar());
    add6bitbar_1 u3_0 (.a(stage2_0), .b(stage2_1), .cin(1'b0), .y(stage3_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage3_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage0_4 = {1'b0, stage0_4_lo};
        stage0_5 = {1'b0, stage0_5_lo};
        stage0_6 = {1'b0, stage0_6_lo};
        stage0_7 = {1'b0, stage0_7_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage1_2 = {1'b0, stage1_2_lo};
        stage1_3 = {1'b0, stage1_3_lo};
        stage2_0 = {1'b0, stage2_0_lo};
        stage2_1 = {1'b0, stage2_1_lo};
        stage3_0 = {1'b0, stage3_0_lo};
    end
endmodule


module layer1(
    input [2:0] inputs0_1 , inputs1_1 , inputs2_1 , inputs3_1 , inputs4_1 , inputs5_1 , inputs6_1 , inputs7_1 , inputs8_1 , inputs9_1 , inputs10_1 , inputs11_1 , inputs12_1 , inputs13_1 , inputs14_1 , inputs15_1,
    input [15:0] w1_0_1, w1_1_1, w2_0_1, w2_1_1, w3_0_1, w3_1_1, w4_0_1, w4_1_1, w5_0_1, w5_1_1, w6_0_1, w6_1_1, w7_0_1, w7_1_1, w8_0_1, w8_1_1,
    input [6:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1,
    output [7:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar, biased_sum4_0, biased_sum4_1, biased_sum4_0bar, biased_sum4_1bar, biased_sum5_0, biased_sum5_1, biased_sum5_0bar, biased_sum5_1bar, biased_sum6_0, biased_sum6_1, biased_sum6_0bar, biased_sum6_1bar, biased_sum7_0, biased_sum7_1, biased_sum7_0bar, biased_sum7_1bar
);
    wire [2:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [2:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [2:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [2:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [2:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [2:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [2:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [2:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [2:0] weighted_inputs1_8_0, weighted_inputs1_8_1;
    wire [2:0] weighted_inputs1_9_0, weighted_inputs1_9_1;
    wire [2:0] weighted_inputs1_10_0, weighted_inputs1_10_1;
    wire [2:0] weighted_inputs1_11_0, weighted_inputs1_11_1;
    wire [2:0] weighted_inputs1_12_0, weighted_inputs1_12_1;
    wire [2:0] weighted_inputs1_13_0, weighted_inputs1_13_1;
    wire [2:0] weighted_inputs1_14_0, weighted_inputs1_14_1;
    wire [2:0] weighted_inputs1_15_0, weighted_inputs1_15_1;
    wire [2:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [2:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [2:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [2:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [2:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [2:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [2:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [2:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [2:0] weighted_inputs2_8_0, weighted_inputs2_8_1;
    wire [2:0] weighted_inputs2_9_0, weighted_inputs2_9_1;
    wire [2:0] weighted_inputs2_10_0, weighted_inputs2_10_1;
    wire [2:0] weighted_inputs2_11_0, weighted_inputs2_11_1;
    wire [2:0] weighted_inputs2_12_0, weighted_inputs2_12_1;
    wire [2:0] weighted_inputs2_13_0, weighted_inputs2_13_1;
    wire [2:0] weighted_inputs2_14_0, weighted_inputs2_14_1;
    wire [2:0] weighted_inputs2_15_0, weighted_inputs2_15_1;
    wire [2:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [2:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [2:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [2:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [2:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [2:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [2:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [2:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [2:0] weighted_inputs3_8_0, weighted_inputs3_8_1;
    wire [2:0] weighted_inputs3_9_0, weighted_inputs3_9_1;
    wire [2:0] weighted_inputs3_10_0, weighted_inputs3_10_1;
    wire [2:0] weighted_inputs3_11_0, weighted_inputs3_11_1;
    wire [2:0] weighted_inputs3_12_0, weighted_inputs3_12_1;
    wire [2:0] weighted_inputs3_13_0, weighted_inputs3_13_1;
    wire [2:0] weighted_inputs3_14_0, weighted_inputs3_14_1;
    wire [2:0] weighted_inputs3_15_0, weighted_inputs3_15_1;
    wire [2:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [2:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [2:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [2:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [2:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [2:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [2:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [2:0] weighted_inputs4_7_0, weighted_inputs4_7_1;
    wire [2:0] weighted_inputs4_8_0, weighted_inputs4_8_1;
    wire [2:0] weighted_inputs4_9_0, weighted_inputs4_9_1;
    wire [2:0] weighted_inputs4_10_0, weighted_inputs4_10_1;
    wire [2:0] weighted_inputs4_11_0, weighted_inputs4_11_1;
    wire [2:0] weighted_inputs4_12_0, weighted_inputs4_12_1;
    wire [2:0] weighted_inputs4_13_0, weighted_inputs4_13_1;
    wire [2:0] weighted_inputs4_14_0, weighted_inputs4_14_1;
    wire [2:0] weighted_inputs4_15_0, weighted_inputs4_15_1;
    wire [2:0] weighted_inputs5_0_0, weighted_inputs5_0_1;
    wire [2:0] weighted_inputs5_1_0, weighted_inputs5_1_1;
    wire [2:0] weighted_inputs5_2_0, weighted_inputs5_2_1;
    wire [2:0] weighted_inputs5_3_0, weighted_inputs5_3_1;
    wire [2:0] weighted_inputs5_4_0, weighted_inputs5_4_1;
    wire [2:0] weighted_inputs5_5_0, weighted_inputs5_5_1;
    wire [2:0] weighted_inputs5_6_0, weighted_inputs5_6_1;
    wire [2:0] weighted_inputs5_7_0, weighted_inputs5_7_1;
    wire [2:0] weighted_inputs5_8_0, weighted_inputs5_8_1;
    wire [2:0] weighted_inputs5_9_0, weighted_inputs5_9_1;
    wire [2:0] weighted_inputs5_10_0, weighted_inputs5_10_1;
    wire [2:0] weighted_inputs5_11_0, weighted_inputs5_11_1;
    wire [2:0] weighted_inputs5_12_0, weighted_inputs5_12_1;
    wire [2:0] weighted_inputs5_13_0, weighted_inputs5_13_1;
    wire [2:0] weighted_inputs5_14_0, weighted_inputs5_14_1;
    wire [2:0] weighted_inputs5_15_0, weighted_inputs5_15_1;
    wire [2:0] weighted_inputs6_0_0, weighted_inputs6_0_1;
    wire [2:0] weighted_inputs6_1_0, weighted_inputs6_1_1;
    wire [2:0] weighted_inputs6_2_0, weighted_inputs6_2_1;
    wire [2:0] weighted_inputs6_3_0, weighted_inputs6_3_1;
    wire [2:0] weighted_inputs6_4_0, weighted_inputs6_4_1;
    wire [2:0] weighted_inputs6_5_0, weighted_inputs6_5_1;
    wire [2:0] weighted_inputs6_6_0, weighted_inputs6_6_1;
    wire [2:0] weighted_inputs6_7_0, weighted_inputs6_7_1;
    wire [2:0] weighted_inputs6_8_0, weighted_inputs6_8_1;
    wire [2:0] weighted_inputs6_9_0, weighted_inputs6_9_1;
    wire [2:0] weighted_inputs6_10_0, weighted_inputs6_10_1;
    wire [2:0] weighted_inputs6_11_0, weighted_inputs6_11_1;
    wire [2:0] weighted_inputs6_12_0, weighted_inputs6_12_1;
    wire [2:0] weighted_inputs6_13_0, weighted_inputs6_13_1;
    wire [2:0] weighted_inputs6_14_0, weighted_inputs6_14_1;
    wire [2:0] weighted_inputs6_15_0, weighted_inputs6_15_1;
    wire [2:0] weighted_inputs7_0_0, weighted_inputs7_0_1;
    wire [2:0] weighted_inputs7_1_0, weighted_inputs7_1_1;
    wire [2:0] weighted_inputs7_2_0, weighted_inputs7_2_1;
    wire [2:0] weighted_inputs7_3_0, weighted_inputs7_3_1;
    wire [2:0] weighted_inputs7_4_0, weighted_inputs7_4_1;
    wire [2:0] weighted_inputs7_5_0, weighted_inputs7_5_1;
    wire [2:0] weighted_inputs7_6_0, weighted_inputs7_6_1;
    wire [2:0] weighted_inputs7_7_0, weighted_inputs7_7_1;
    wire [2:0] weighted_inputs7_8_0, weighted_inputs7_8_1;
    wire [2:0] weighted_inputs7_9_0, weighted_inputs7_9_1;
    wire [2:0] weighted_inputs7_10_0, weighted_inputs7_10_1;
    wire [2:0] weighted_inputs7_11_0, weighted_inputs7_11_1;
    wire [2:0] weighted_inputs7_12_0, weighted_inputs7_12_1;
    wire [2:0] weighted_inputs7_13_0, weighted_inputs7_13_1;
    wire [2:0] weighted_inputs7_14_0, weighted_inputs7_14_1;
    wire [2:0] weighted_inputs7_15_0, weighted_inputs7_15_1;
    wire [2:0] weighted_inputs8_0_0, weighted_inputs8_0_1;
    wire [2:0] weighted_inputs8_1_0, weighted_inputs8_1_1;
    wire [2:0] weighted_inputs8_2_0, weighted_inputs8_2_1;
    wire [2:0] weighted_inputs8_3_0, weighted_inputs8_3_1;
    wire [2:0] weighted_inputs8_4_0, weighted_inputs8_4_1;
    wire [2:0] weighted_inputs8_5_0, weighted_inputs8_5_1;
    wire [2:0] weighted_inputs8_6_0, weighted_inputs8_6_1;
    wire [2:0] weighted_inputs8_7_0, weighted_inputs8_7_1;
    wire [2:0] weighted_inputs8_8_0, weighted_inputs8_8_1;
    wire [2:0] weighted_inputs8_9_0, weighted_inputs8_9_1;
    wire [2:0] weighted_inputs8_10_0, weighted_inputs8_10_1;
    wire [2:0] weighted_inputs8_11_0, weighted_inputs8_11_1;
    wire [2:0] weighted_inputs8_12_0, weighted_inputs8_12_1;
    wire [2:0] weighted_inputs8_13_0, weighted_inputs8_13_1;
    wire [2:0] weighted_inputs8_14_0, weighted_inputs8_14_1;
    wire [2:0] weighted_inputs8_15_0, weighted_inputs8_15_1;

    wire [6:0] sum1 [7:0];
    wire [6:0] sum2 [7:0];
    wire [7:0] biased_sum1 [7:0];
    wire [7:0] biased_sum2 [7:0];
    wire [6:0] sum1bar [7:0];
    wire [6:0] sum2bar [7:0];
    wire [7:0] biased_sum1bar [7:0];
    wire [7:0] biased_sum2bar [7:0];
    weighted_inputs_1 w0 (.inputs(inputs0_1), .w(w1_0_1[0]), .wi(weighted_inputs1_0_0));
    weighted_inputs_1 w0_bar (.inputs(inputs0_1), .w(w1_1_1[0]), .wi(weighted_inputs1_0_1));
    weighted_inputs_1 w1 (.inputs(inputs1_1), .w(w1_0_1[1]), .wi(weighted_inputs1_1_0));
    weighted_inputs_1 w1_bar (.inputs(inputs1_1), .w(w1_1_1[1]), .wi(weighted_inputs1_1_1));
    weighted_inputs_1 w2 (.inputs(inputs2_1), .w(w1_0_1[2]), .wi(weighted_inputs1_2_0));
    weighted_inputs_1 w2_bar (.inputs(inputs2_1), .w(w1_1_1[2]), .wi(weighted_inputs1_2_1));
    weighted_inputs_1 w3 (.inputs(inputs3_1), .w(w1_0_1[3]), .wi(weighted_inputs1_3_0));
    weighted_inputs_1 w3_bar (.inputs(inputs3_1), .w(w1_1_1[3]), .wi(weighted_inputs1_3_1));
    weighted_inputs_1 w4 (.inputs(inputs4_1), .w(w1_0_1[4]), .wi(weighted_inputs1_4_0));
    weighted_inputs_1 w4_bar (.inputs(inputs4_1), .w(w1_1_1[4]), .wi(weighted_inputs1_4_1));
    weighted_inputs_1 w5 (.inputs(inputs5_1), .w(w1_0_1[5]), .wi(weighted_inputs1_5_0));
    weighted_inputs_1 w5_bar (.inputs(inputs5_1), .w(w1_1_1[5]), .wi(weighted_inputs1_5_1));
    weighted_inputs_1 w6 (.inputs(inputs6_1), .w(w1_0_1[6]), .wi(weighted_inputs1_6_0));
    weighted_inputs_1 w6_bar (.inputs(inputs6_1), .w(w1_1_1[6]), .wi(weighted_inputs1_6_1));
    weighted_inputs_1 w7 (.inputs(inputs7_1), .w(w1_0_1[7]), .wi(weighted_inputs1_7_0));
    weighted_inputs_1 w7_bar (.inputs(inputs7_1), .w(w1_1_1[7]), .wi(weighted_inputs1_7_1));
    weighted_inputs_1 w8 (.inputs(inputs8_1), .w(w1_0_1[8]), .wi(weighted_inputs1_8_0));
    weighted_inputs_1 w8_bar (.inputs(inputs8_1), .w(w1_1_1[8]), .wi(weighted_inputs1_8_1));
    weighted_inputs_1 w9 (.inputs(inputs9_1), .w(w1_0_1[9]), .wi(weighted_inputs1_9_0));
    weighted_inputs_1 w9_bar (.inputs(inputs9_1), .w(w1_1_1[9]), .wi(weighted_inputs1_9_1));
    weighted_inputs_1 w10 (.inputs(inputs10_1), .w(w1_0_1[10]), .wi(weighted_inputs1_10_0));
    weighted_inputs_1 w10_bar (.inputs(inputs10_1), .w(w1_1_1[10]), .wi(weighted_inputs1_10_1));
    weighted_inputs_1 w11 (.inputs(inputs11_1), .w(w1_0_1[11]), .wi(weighted_inputs1_11_0));
    weighted_inputs_1 w11_bar (.inputs(inputs11_1), .w(w1_1_1[11]), .wi(weighted_inputs1_11_1));
    weighted_inputs_1 w12 (.inputs(inputs12_1), .w(w1_0_1[12]), .wi(weighted_inputs1_12_0));
    weighted_inputs_1 w12_bar (.inputs(inputs12_1), .w(w1_1_1[12]), .wi(weighted_inputs1_12_1));
    weighted_inputs_1 w13 (.inputs(inputs13_1), .w(w1_0_1[13]), .wi(weighted_inputs1_13_0));
    weighted_inputs_1 w13_bar (.inputs(inputs13_1), .w(w1_1_1[13]), .wi(weighted_inputs1_13_1));
    weighted_inputs_1 w14 (.inputs(inputs14_1), .w(w1_0_1[14]), .wi(weighted_inputs1_14_0));
    weighted_inputs_1 w14_bar (.inputs(inputs14_1), .w(w1_1_1[14]), .wi(weighted_inputs1_14_1));
    weighted_inputs_1 w15 (.inputs(inputs15_1), .w(w1_0_1[15]), .wi(weighted_inputs1_15_0));
    weighted_inputs_1 w15_bar (.inputs(inputs15_1), .w(w1_1_1[15]), .wi(weighted_inputs1_15_1));
    weighted_inputs_1 w16 (.inputs(inputs0_1), .w(w2_0_1[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_1 w16_bar (.inputs(inputs0_1), .w(w2_1_1[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_1 w17 (.inputs(inputs1_1), .w(w2_0_1[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_1 w17_bar (.inputs(inputs1_1), .w(w2_1_1[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_1 w18 (.inputs(inputs2_1), .w(w2_0_1[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_1 w18_bar (.inputs(inputs2_1), .w(w2_1_1[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_1 w19 (.inputs(inputs3_1), .w(w2_0_1[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_1 w19_bar (.inputs(inputs3_1), .w(w2_1_1[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_1 w20 (.inputs(inputs4_1), .w(w2_0_1[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_1 w20_bar (.inputs(inputs4_1), .w(w2_1_1[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_1 w21 (.inputs(inputs5_1), .w(w2_0_1[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_1 w21_bar (.inputs(inputs5_1), .w(w2_1_1[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_1 w22 (.inputs(inputs6_1), .w(w2_0_1[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_1 w22_bar (.inputs(inputs6_1), .w(w2_1_1[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_1 w23 (.inputs(inputs7_1), .w(w2_0_1[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_1 w23_bar (.inputs(inputs7_1), .w(w2_1_1[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_1 w24 (.inputs(inputs8_1), .w(w2_0_1[8]), .wi(weighted_inputs2_8_0));
    weighted_inputs_1 w24_bar (.inputs(inputs8_1), .w(w2_1_1[8]), .wi(weighted_inputs2_8_1));
    weighted_inputs_1 w25 (.inputs(inputs9_1), .w(w2_0_1[9]), .wi(weighted_inputs2_9_0));
    weighted_inputs_1 w25_bar (.inputs(inputs9_1), .w(w2_1_1[9]), .wi(weighted_inputs2_9_1));
    weighted_inputs_1 w26 (.inputs(inputs10_1), .w(w2_0_1[10]), .wi(weighted_inputs2_10_0));
    weighted_inputs_1 w26_bar (.inputs(inputs10_1), .w(w2_1_1[10]), .wi(weighted_inputs2_10_1));
    weighted_inputs_1 w27 (.inputs(inputs11_1), .w(w2_0_1[11]), .wi(weighted_inputs2_11_0));
    weighted_inputs_1 w27_bar (.inputs(inputs11_1), .w(w2_1_1[11]), .wi(weighted_inputs2_11_1));
    weighted_inputs_1 w28 (.inputs(inputs12_1), .w(w2_0_1[12]), .wi(weighted_inputs2_12_0));
    weighted_inputs_1 w28_bar (.inputs(inputs12_1), .w(w2_1_1[12]), .wi(weighted_inputs2_12_1));
    weighted_inputs_1 w29 (.inputs(inputs13_1), .w(w2_0_1[13]), .wi(weighted_inputs2_13_0));
    weighted_inputs_1 w29_bar (.inputs(inputs13_1), .w(w2_1_1[13]), .wi(weighted_inputs2_13_1));
    weighted_inputs_1 w30 (.inputs(inputs14_1), .w(w2_0_1[14]), .wi(weighted_inputs2_14_0));
    weighted_inputs_1 w30_bar (.inputs(inputs14_1), .w(w2_1_1[14]), .wi(weighted_inputs2_14_1));
    weighted_inputs_1 w31 (.inputs(inputs15_1), .w(w2_0_1[15]), .wi(weighted_inputs2_15_0));
    weighted_inputs_1 w31_bar (.inputs(inputs15_1), .w(w2_1_1[15]), .wi(weighted_inputs2_15_1));
    weighted_inputs_1 w32 (.inputs(inputs0_1), .w(w3_0_1[0]), .wi(weighted_inputs3_0_0));
    weighted_inputs_1 w32_bar (.inputs(inputs0_1), .w(w3_1_1[0]), .wi(weighted_inputs3_0_1));
    weighted_inputs_1 w33 (.inputs(inputs1_1), .w(w3_0_1[1]), .wi(weighted_inputs3_1_0));
    weighted_inputs_1 w33_bar (.inputs(inputs1_1), .w(w3_1_1[1]), .wi(weighted_inputs3_1_1));
    weighted_inputs_1 w34 (.inputs(inputs2_1), .w(w3_0_1[2]), .wi(weighted_inputs3_2_0));
    weighted_inputs_1 w34_bar (.inputs(inputs2_1), .w(w3_1_1[2]), .wi(weighted_inputs3_2_1));
    weighted_inputs_1 w35 (.inputs(inputs3_1), .w(w3_0_1[3]), .wi(weighted_inputs3_3_0));
    weighted_inputs_1 w35_bar (.inputs(inputs3_1), .w(w3_1_1[3]), .wi(weighted_inputs3_3_1));
    weighted_inputs_1 w36 (.inputs(inputs4_1), .w(w3_0_1[4]), .wi(weighted_inputs3_4_0));
    weighted_inputs_1 w36_bar (.inputs(inputs4_1), .w(w3_1_1[4]), .wi(weighted_inputs3_4_1));
    weighted_inputs_1 w37 (.inputs(inputs5_1), .w(w3_0_1[5]), .wi(weighted_inputs3_5_0));
    weighted_inputs_1 w37_bar (.inputs(inputs5_1), .w(w3_1_1[5]), .wi(weighted_inputs3_5_1));
    weighted_inputs_1 w38 (.inputs(inputs6_1), .w(w3_0_1[6]), .wi(weighted_inputs3_6_0));
    weighted_inputs_1 w38_bar (.inputs(inputs6_1), .w(w3_1_1[6]), .wi(weighted_inputs3_6_1));
    weighted_inputs_1 w39 (.inputs(inputs7_1), .w(w3_0_1[7]), .wi(weighted_inputs3_7_0));
    weighted_inputs_1 w39_bar (.inputs(inputs7_1), .w(w3_1_1[7]), .wi(weighted_inputs3_7_1));
    weighted_inputs_1 w40 (.inputs(inputs8_1), .w(w3_0_1[8]), .wi(weighted_inputs3_8_0));
    weighted_inputs_1 w40_bar (.inputs(inputs8_1), .w(w3_1_1[8]), .wi(weighted_inputs3_8_1));
    weighted_inputs_1 w41 (.inputs(inputs9_1), .w(w3_0_1[9]), .wi(weighted_inputs3_9_0));
    weighted_inputs_1 w41_bar (.inputs(inputs9_1), .w(w3_1_1[9]), .wi(weighted_inputs3_9_1));
    weighted_inputs_1 w42 (.inputs(inputs10_1), .w(w3_0_1[10]), .wi(weighted_inputs3_10_0));
    weighted_inputs_1 w42_bar (.inputs(inputs10_1), .w(w3_1_1[10]), .wi(weighted_inputs3_10_1));
    weighted_inputs_1 w43 (.inputs(inputs11_1), .w(w3_0_1[11]), .wi(weighted_inputs3_11_0));
    weighted_inputs_1 w43_bar (.inputs(inputs11_1), .w(w3_1_1[11]), .wi(weighted_inputs3_11_1));
    weighted_inputs_1 w44 (.inputs(inputs12_1), .w(w3_0_1[12]), .wi(weighted_inputs3_12_0));
    weighted_inputs_1 w44_bar (.inputs(inputs12_1), .w(w3_1_1[12]), .wi(weighted_inputs3_12_1));
    weighted_inputs_1 w45 (.inputs(inputs13_1), .w(w3_0_1[13]), .wi(weighted_inputs3_13_0));
    weighted_inputs_1 w45_bar (.inputs(inputs13_1), .w(w3_1_1[13]), .wi(weighted_inputs3_13_1));
    weighted_inputs_1 w46 (.inputs(inputs14_1), .w(w3_0_1[14]), .wi(weighted_inputs3_14_0));
    weighted_inputs_1 w46_bar (.inputs(inputs14_1), .w(w3_1_1[14]), .wi(weighted_inputs3_14_1));
    weighted_inputs_1 w47 (.inputs(inputs15_1), .w(w3_0_1[15]), .wi(weighted_inputs3_15_0));
    weighted_inputs_1 w47_bar (.inputs(inputs15_1), .w(w3_1_1[15]), .wi(weighted_inputs3_15_1));
    weighted_inputs_1 w48 (.inputs(inputs0_1), .w(w4_0_1[0]), .wi(weighted_inputs4_0_0));
    weighted_inputs_1 w48_bar (.inputs(inputs0_1), .w(w4_1_1[0]), .wi(weighted_inputs4_0_1));
    weighted_inputs_1 w49 (.inputs(inputs1_1), .w(w4_0_1[1]), .wi(weighted_inputs4_1_0));
    weighted_inputs_1 w49_bar (.inputs(inputs1_1), .w(w4_1_1[1]), .wi(weighted_inputs4_1_1));
    weighted_inputs_1 w50 (.inputs(inputs2_1), .w(w4_0_1[2]), .wi(weighted_inputs4_2_0));
    weighted_inputs_1 w50_bar (.inputs(inputs2_1), .w(w4_1_1[2]), .wi(weighted_inputs4_2_1));
    weighted_inputs_1 w51 (.inputs(inputs3_1), .w(w4_0_1[3]), .wi(weighted_inputs4_3_0));
    weighted_inputs_1 w51_bar (.inputs(inputs3_1), .w(w4_1_1[3]), .wi(weighted_inputs4_3_1));
    weighted_inputs_1 w52 (.inputs(inputs4_1), .w(w4_0_1[4]), .wi(weighted_inputs4_4_0));
    weighted_inputs_1 w52_bar (.inputs(inputs4_1), .w(w4_1_1[4]), .wi(weighted_inputs4_4_1));
    weighted_inputs_1 w53 (.inputs(inputs5_1), .w(w4_0_1[5]), .wi(weighted_inputs4_5_0));
    weighted_inputs_1 w53_bar (.inputs(inputs5_1), .w(w4_1_1[5]), .wi(weighted_inputs4_5_1));
    weighted_inputs_1 w54 (.inputs(inputs6_1), .w(w4_0_1[6]), .wi(weighted_inputs4_6_0));
    weighted_inputs_1 w54_bar (.inputs(inputs6_1), .w(w4_1_1[6]), .wi(weighted_inputs4_6_1));
    weighted_inputs_1 w55 (.inputs(inputs7_1), .w(w4_0_1[7]), .wi(weighted_inputs4_7_0));
    weighted_inputs_1 w55_bar (.inputs(inputs7_1), .w(w4_1_1[7]), .wi(weighted_inputs4_7_1));
    weighted_inputs_1 w56 (.inputs(inputs8_1), .w(w4_0_1[8]), .wi(weighted_inputs4_8_0));
    weighted_inputs_1 w56_bar (.inputs(inputs8_1), .w(w4_1_1[8]), .wi(weighted_inputs4_8_1));
    weighted_inputs_1 w57 (.inputs(inputs9_1), .w(w4_0_1[9]), .wi(weighted_inputs4_9_0));
    weighted_inputs_1 w57_bar (.inputs(inputs9_1), .w(w4_1_1[9]), .wi(weighted_inputs4_9_1));
    weighted_inputs_1 w58 (.inputs(inputs10_1), .w(w4_0_1[10]), .wi(weighted_inputs4_10_0));
    weighted_inputs_1 w58_bar (.inputs(inputs10_1), .w(w4_1_1[10]), .wi(weighted_inputs4_10_1));
    weighted_inputs_1 w59 (.inputs(inputs11_1), .w(w4_0_1[11]), .wi(weighted_inputs4_11_0));
    weighted_inputs_1 w59_bar (.inputs(inputs11_1), .w(w4_1_1[11]), .wi(weighted_inputs4_11_1));
    weighted_inputs_1 w60 (.inputs(inputs12_1), .w(w4_0_1[12]), .wi(weighted_inputs4_12_0));
    weighted_inputs_1 w60_bar (.inputs(inputs12_1), .w(w4_1_1[12]), .wi(weighted_inputs4_12_1));
    weighted_inputs_1 w61 (.inputs(inputs13_1), .w(w4_0_1[13]), .wi(weighted_inputs4_13_0));
    weighted_inputs_1 w61_bar (.inputs(inputs13_1), .w(w4_1_1[13]), .wi(weighted_inputs4_13_1));
    weighted_inputs_1 w62 (.inputs(inputs14_1), .w(w4_0_1[14]), .wi(weighted_inputs4_14_0));
    weighted_inputs_1 w62_bar (.inputs(inputs14_1), .w(w4_1_1[14]), .wi(weighted_inputs4_14_1));
    weighted_inputs_1 w63 (.inputs(inputs15_1), .w(w4_0_1[15]), .wi(weighted_inputs4_15_0));
    weighted_inputs_1 w63_bar (.inputs(inputs15_1), .w(w4_1_1[15]), .wi(weighted_inputs4_15_1));
    weighted_inputs_1 w64 (.inputs(inputs0_1), .w(w5_0_1[0]), .wi(weighted_inputs5_0_0));
    weighted_inputs_1 w64_bar (.inputs(inputs0_1), .w(w5_1_1[0]), .wi(weighted_inputs5_0_1));
    weighted_inputs_1 w65 (.inputs(inputs1_1), .w(w5_0_1[1]), .wi(weighted_inputs5_1_0));
    weighted_inputs_1 w65_bar (.inputs(inputs1_1), .w(w5_1_1[1]), .wi(weighted_inputs5_1_1));
    weighted_inputs_1 w66 (.inputs(inputs2_1), .w(w5_0_1[2]), .wi(weighted_inputs5_2_0));
    weighted_inputs_1 w66_bar (.inputs(inputs2_1), .w(w5_1_1[2]), .wi(weighted_inputs5_2_1));
    weighted_inputs_1 w67 (.inputs(inputs3_1), .w(w5_0_1[3]), .wi(weighted_inputs5_3_0));
    weighted_inputs_1 w67_bar (.inputs(inputs3_1), .w(w5_1_1[3]), .wi(weighted_inputs5_3_1));
    weighted_inputs_1 w68 (.inputs(inputs4_1), .w(w5_0_1[4]), .wi(weighted_inputs5_4_0));
    weighted_inputs_1 w68_bar (.inputs(inputs4_1), .w(w5_1_1[4]), .wi(weighted_inputs5_4_1));
    weighted_inputs_1 w69 (.inputs(inputs5_1), .w(w5_0_1[5]), .wi(weighted_inputs5_5_0));
    weighted_inputs_1 w69_bar (.inputs(inputs5_1), .w(w5_1_1[5]), .wi(weighted_inputs5_5_1));
    weighted_inputs_1 w70 (.inputs(inputs6_1), .w(w5_0_1[6]), .wi(weighted_inputs5_6_0));
    weighted_inputs_1 w70_bar (.inputs(inputs6_1), .w(w5_1_1[6]), .wi(weighted_inputs5_6_1));
    weighted_inputs_1 w71 (.inputs(inputs7_1), .w(w5_0_1[7]), .wi(weighted_inputs5_7_0));
    weighted_inputs_1 w71_bar (.inputs(inputs7_1), .w(w5_1_1[7]), .wi(weighted_inputs5_7_1));
    weighted_inputs_1 w72 (.inputs(inputs8_1), .w(w5_0_1[8]), .wi(weighted_inputs5_8_0));
    weighted_inputs_1 w72_bar (.inputs(inputs8_1), .w(w5_1_1[8]), .wi(weighted_inputs5_8_1));
    weighted_inputs_1 w73 (.inputs(inputs9_1), .w(w5_0_1[9]), .wi(weighted_inputs5_9_0));
    weighted_inputs_1 w73_bar (.inputs(inputs9_1), .w(w5_1_1[9]), .wi(weighted_inputs5_9_1));
    weighted_inputs_1 w74 (.inputs(inputs10_1), .w(w5_0_1[10]), .wi(weighted_inputs5_10_0));
    weighted_inputs_1 w74_bar (.inputs(inputs10_1), .w(w5_1_1[10]), .wi(weighted_inputs5_10_1));
    weighted_inputs_1 w75 (.inputs(inputs11_1), .w(w5_0_1[11]), .wi(weighted_inputs5_11_0));
    weighted_inputs_1 w75_bar (.inputs(inputs11_1), .w(w5_1_1[11]), .wi(weighted_inputs5_11_1));
    weighted_inputs_1 w76 (.inputs(inputs12_1), .w(w5_0_1[12]), .wi(weighted_inputs5_12_0));
    weighted_inputs_1 w76_bar (.inputs(inputs12_1), .w(w5_1_1[12]), .wi(weighted_inputs5_12_1));
    weighted_inputs_1 w77 (.inputs(inputs13_1), .w(w5_0_1[13]), .wi(weighted_inputs5_13_0));
    weighted_inputs_1 w77_bar (.inputs(inputs13_1), .w(w5_1_1[13]), .wi(weighted_inputs5_13_1));
    weighted_inputs_1 w78 (.inputs(inputs14_1), .w(w5_0_1[14]), .wi(weighted_inputs5_14_0));
    weighted_inputs_1 w78_bar (.inputs(inputs14_1), .w(w5_1_1[14]), .wi(weighted_inputs5_14_1));
    weighted_inputs_1 w79 (.inputs(inputs15_1), .w(w5_0_1[15]), .wi(weighted_inputs5_15_0));
    weighted_inputs_1 w79_bar (.inputs(inputs15_1), .w(w5_1_1[15]), .wi(weighted_inputs5_15_1));
    weighted_inputs_1 w80 (.inputs(inputs0_1), .w(w6_0_1[0]), .wi(weighted_inputs6_0_0));
    weighted_inputs_1 w80_bar (.inputs(inputs0_1), .w(w6_1_1[0]), .wi(weighted_inputs6_0_1));
    weighted_inputs_1 w81 (.inputs(inputs1_1), .w(w6_0_1[1]), .wi(weighted_inputs6_1_0));
    weighted_inputs_1 w81_bar (.inputs(inputs1_1), .w(w6_1_1[1]), .wi(weighted_inputs6_1_1));
    weighted_inputs_1 w82 (.inputs(inputs2_1), .w(w6_0_1[2]), .wi(weighted_inputs6_2_0));
    weighted_inputs_1 w82_bar (.inputs(inputs2_1), .w(w6_1_1[2]), .wi(weighted_inputs6_2_1));
    weighted_inputs_1 w83 (.inputs(inputs3_1), .w(w6_0_1[3]), .wi(weighted_inputs6_3_0));
    weighted_inputs_1 w83_bar (.inputs(inputs3_1), .w(w6_1_1[3]), .wi(weighted_inputs6_3_1));
    weighted_inputs_1 w84 (.inputs(inputs4_1), .w(w6_0_1[4]), .wi(weighted_inputs6_4_0));
    weighted_inputs_1 w84_bar (.inputs(inputs4_1), .w(w6_1_1[4]), .wi(weighted_inputs6_4_1));
    weighted_inputs_1 w85 (.inputs(inputs5_1), .w(w6_0_1[5]), .wi(weighted_inputs6_5_0));
    weighted_inputs_1 w85_bar (.inputs(inputs5_1), .w(w6_1_1[5]), .wi(weighted_inputs6_5_1));
    weighted_inputs_1 w86 (.inputs(inputs6_1), .w(w6_0_1[6]), .wi(weighted_inputs6_6_0));
    weighted_inputs_1 w86_bar (.inputs(inputs6_1), .w(w6_1_1[6]), .wi(weighted_inputs6_6_1));
    weighted_inputs_1 w87 (.inputs(inputs7_1), .w(w6_0_1[7]), .wi(weighted_inputs6_7_0));
    weighted_inputs_1 w87_bar (.inputs(inputs7_1), .w(w6_1_1[7]), .wi(weighted_inputs6_7_1));
    weighted_inputs_1 w88 (.inputs(inputs8_1), .w(w6_0_1[8]), .wi(weighted_inputs6_8_0));
    weighted_inputs_1 w88_bar (.inputs(inputs8_1), .w(w6_1_1[8]), .wi(weighted_inputs6_8_1));
    weighted_inputs_1 w89 (.inputs(inputs9_1), .w(w6_0_1[9]), .wi(weighted_inputs6_9_0));
    weighted_inputs_1 w89_bar (.inputs(inputs9_1), .w(w6_1_1[9]), .wi(weighted_inputs6_9_1));
    weighted_inputs_1 w90 (.inputs(inputs10_1), .w(w6_0_1[10]), .wi(weighted_inputs6_10_0));
    weighted_inputs_1 w90_bar (.inputs(inputs10_1), .w(w6_1_1[10]), .wi(weighted_inputs6_10_1));
    weighted_inputs_1 w91 (.inputs(inputs11_1), .w(w6_0_1[11]), .wi(weighted_inputs6_11_0));
    weighted_inputs_1 w91_bar (.inputs(inputs11_1), .w(w6_1_1[11]), .wi(weighted_inputs6_11_1));
    weighted_inputs_1 w92 (.inputs(inputs12_1), .w(w6_0_1[12]), .wi(weighted_inputs6_12_0));
    weighted_inputs_1 w92_bar (.inputs(inputs12_1), .w(w6_1_1[12]), .wi(weighted_inputs6_12_1));
    weighted_inputs_1 w93 (.inputs(inputs13_1), .w(w6_0_1[13]), .wi(weighted_inputs6_13_0));
    weighted_inputs_1 w93_bar (.inputs(inputs13_1), .w(w6_1_1[13]), .wi(weighted_inputs6_13_1));
    weighted_inputs_1 w94 (.inputs(inputs14_1), .w(w6_0_1[14]), .wi(weighted_inputs6_14_0));
    weighted_inputs_1 w94_bar (.inputs(inputs14_1), .w(w6_1_1[14]), .wi(weighted_inputs6_14_1));
    weighted_inputs_1 w95 (.inputs(inputs15_1), .w(w6_0_1[15]), .wi(weighted_inputs6_15_0));
    weighted_inputs_1 w95_bar (.inputs(inputs15_1), .w(w6_1_1[15]), .wi(weighted_inputs6_15_1));
    weighted_inputs_1 w96 (.inputs(inputs0_1), .w(w7_0_1[0]), .wi(weighted_inputs7_0_0));
    weighted_inputs_1 w96_bar (.inputs(inputs0_1), .w(w7_1_1[0]), .wi(weighted_inputs7_0_1));
    weighted_inputs_1 w97 (.inputs(inputs1_1), .w(w7_0_1[1]), .wi(weighted_inputs7_1_0));
    weighted_inputs_1 w97_bar (.inputs(inputs1_1), .w(w7_1_1[1]), .wi(weighted_inputs7_1_1));
    weighted_inputs_1 w98 (.inputs(inputs2_1), .w(w7_0_1[2]), .wi(weighted_inputs7_2_0));
    weighted_inputs_1 w98_bar (.inputs(inputs2_1), .w(w7_1_1[2]), .wi(weighted_inputs7_2_1));
    weighted_inputs_1 w99 (.inputs(inputs3_1), .w(w7_0_1[3]), .wi(weighted_inputs7_3_0));
    weighted_inputs_1 w99_bar (.inputs(inputs3_1), .w(w7_1_1[3]), .wi(weighted_inputs7_3_1));
    weighted_inputs_1 w100 (.inputs(inputs4_1), .w(w7_0_1[4]), .wi(weighted_inputs7_4_0));
    weighted_inputs_1 w100_bar (.inputs(inputs4_1), .w(w7_1_1[4]), .wi(weighted_inputs7_4_1));
    weighted_inputs_1 w101 (.inputs(inputs5_1), .w(w7_0_1[5]), .wi(weighted_inputs7_5_0));
    weighted_inputs_1 w101_bar (.inputs(inputs5_1), .w(w7_1_1[5]), .wi(weighted_inputs7_5_1));
    weighted_inputs_1 w102 (.inputs(inputs6_1), .w(w7_0_1[6]), .wi(weighted_inputs7_6_0));
    weighted_inputs_1 w102_bar (.inputs(inputs6_1), .w(w7_1_1[6]), .wi(weighted_inputs7_6_1));
    weighted_inputs_1 w103 (.inputs(inputs7_1), .w(w7_0_1[7]), .wi(weighted_inputs7_7_0));
    weighted_inputs_1 w103_bar (.inputs(inputs7_1), .w(w7_1_1[7]), .wi(weighted_inputs7_7_1));
    weighted_inputs_1 w104 (.inputs(inputs8_1), .w(w7_0_1[8]), .wi(weighted_inputs7_8_0));
    weighted_inputs_1 w104_bar (.inputs(inputs8_1), .w(w7_1_1[8]), .wi(weighted_inputs7_8_1));
    weighted_inputs_1 w105 (.inputs(inputs9_1), .w(w7_0_1[9]), .wi(weighted_inputs7_9_0));
    weighted_inputs_1 w105_bar (.inputs(inputs9_1), .w(w7_1_1[9]), .wi(weighted_inputs7_9_1));
    weighted_inputs_1 w106 (.inputs(inputs10_1), .w(w7_0_1[10]), .wi(weighted_inputs7_10_0));
    weighted_inputs_1 w106_bar (.inputs(inputs10_1), .w(w7_1_1[10]), .wi(weighted_inputs7_10_1));
    weighted_inputs_1 w107 (.inputs(inputs11_1), .w(w7_0_1[11]), .wi(weighted_inputs7_11_0));
    weighted_inputs_1 w107_bar (.inputs(inputs11_1), .w(w7_1_1[11]), .wi(weighted_inputs7_11_1));
    weighted_inputs_1 w108 (.inputs(inputs12_1), .w(w7_0_1[12]), .wi(weighted_inputs7_12_0));
    weighted_inputs_1 w108_bar (.inputs(inputs12_1), .w(w7_1_1[12]), .wi(weighted_inputs7_12_1));
    weighted_inputs_1 w109 (.inputs(inputs13_1), .w(w7_0_1[13]), .wi(weighted_inputs7_13_0));
    weighted_inputs_1 w109_bar (.inputs(inputs13_1), .w(w7_1_1[13]), .wi(weighted_inputs7_13_1));
    weighted_inputs_1 w110 (.inputs(inputs14_1), .w(w7_0_1[14]), .wi(weighted_inputs7_14_0));
    weighted_inputs_1 w110_bar (.inputs(inputs14_1), .w(w7_1_1[14]), .wi(weighted_inputs7_14_1));
    weighted_inputs_1 w111 (.inputs(inputs15_1), .w(w7_0_1[15]), .wi(weighted_inputs7_15_0));
    weighted_inputs_1 w111_bar (.inputs(inputs15_1), .w(w7_1_1[15]), .wi(weighted_inputs7_15_1));
    weighted_inputs_1 w112 (.inputs(inputs0_1), .w(w8_0_1[0]), .wi(weighted_inputs8_0_0));
    weighted_inputs_1 w112_bar (.inputs(inputs0_1), .w(w8_1_1[0]), .wi(weighted_inputs8_0_1));
    weighted_inputs_1 w113 (.inputs(inputs1_1), .w(w8_0_1[1]), .wi(weighted_inputs8_1_0));
    weighted_inputs_1 w113_bar (.inputs(inputs1_1), .w(w8_1_1[1]), .wi(weighted_inputs8_1_1));
    weighted_inputs_1 w114 (.inputs(inputs2_1), .w(w8_0_1[2]), .wi(weighted_inputs8_2_0));
    weighted_inputs_1 w114_bar (.inputs(inputs2_1), .w(w8_1_1[2]), .wi(weighted_inputs8_2_1));
    weighted_inputs_1 w115 (.inputs(inputs3_1), .w(w8_0_1[3]), .wi(weighted_inputs8_3_0));
    weighted_inputs_1 w115_bar (.inputs(inputs3_1), .w(w8_1_1[3]), .wi(weighted_inputs8_3_1));
    weighted_inputs_1 w116 (.inputs(inputs4_1), .w(w8_0_1[4]), .wi(weighted_inputs8_4_0));
    weighted_inputs_1 w116_bar (.inputs(inputs4_1), .w(w8_1_1[4]), .wi(weighted_inputs8_4_1));
    weighted_inputs_1 w117 (.inputs(inputs5_1), .w(w8_0_1[5]), .wi(weighted_inputs8_5_0));
    weighted_inputs_1 w117_bar (.inputs(inputs5_1), .w(w8_1_1[5]), .wi(weighted_inputs8_5_1));
    weighted_inputs_1 w118 (.inputs(inputs6_1), .w(w8_0_1[6]), .wi(weighted_inputs8_6_0));
    weighted_inputs_1 w118_bar (.inputs(inputs6_1), .w(w8_1_1[6]), .wi(weighted_inputs8_6_1));
    weighted_inputs_1 w119 (.inputs(inputs7_1), .w(w8_0_1[7]), .wi(weighted_inputs8_7_0));
    weighted_inputs_1 w119_bar (.inputs(inputs7_1), .w(w8_1_1[7]), .wi(weighted_inputs8_7_1));
    weighted_inputs_1 w120 (.inputs(inputs8_1), .w(w8_0_1[8]), .wi(weighted_inputs8_8_0));
    weighted_inputs_1 w120_bar (.inputs(inputs8_1), .w(w8_1_1[8]), .wi(weighted_inputs8_8_1));
    weighted_inputs_1 w121 (.inputs(inputs9_1), .w(w8_0_1[9]), .wi(weighted_inputs8_9_0));
    weighted_inputs_1 w121_bar (.inputs(inputs9_1), .w(w8_1_1[9]), .wi(weighted_inputs8_9_1));
    weighted_inputs_1 w122 (.inputs(inputs10_1), .w(w8_0_1[10]), .wi(weighted_inputs8_10_0));
    weighted_inputs_1 w122_bar (.inputs(inputs10_1), .w(w8_1_1[10]), .wi(weighted_inputs8_10_1));
    weighted_inputs_1 w123 (.inputs(inputs11_1), .w(w8_0_1[11]), .wi(weighted_inputs8_11_0));
    weighted_inputs_1 w123_bar (.inputs(inputs11_1), .w(w8_1_1[11]), .wi(weighted_inputs8_11_1));
    weighted_inputs_1 w124 (.inputs(inputs12_1), .w(w8_0_1[12]), .wi(weighted_inputs8_12_0));
    weighted_inputs_1 w124_bar (.inputs(inputs12_1), .w(w8_1_1[12]), .wi(weighted_inputs8_12_1));
    weighted_inputs_1 w125 (.inputs(inputs13_1), .w(w8_0_1[13]), .wi(weighted_inputs8_13_0));
    weighted_inputs_1 w125_bar (.inputs(inputs13_1), .w(w8_1_1[13]), .wi(weighted_inputs8_13_1));
    weighted_inputs_1 w126 (.inputs(inputs14_1), .w(w8_0_1[14]), .wi(weighted_inputs8_14_0));
    weighted_inputs_1 w126_bar (.inputs(inputs14_1), .w(w8_1_1[14]), .wi(weighted_inputs8_14_1));
    weighted_inputs_1 w127 (.inputs(inputs15_1), .w(w8_0_1[15]), .wi(weighted_inputs8_15_0));
    weighted_inputs_1 w127_bar (.inputs(inputs15_1), .w(w8_1_1[15]), .wi(weighted_inputs8_15_1));
    adder_tree_1 add0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .in8(weighted_inputs1_8_0),
        .in9(weighted_inputs1_9_0),
        .in10(weighted_inputs1_10_0),
        .in11(weighted_inputs1_11_0),
        .in12(weighted_inputs1_12_0),
        .in13(weighted_inputs1_13_0),
        .in14(weighted_inputs1_14_0),
        .in15(weighted_inputs1_15_0),
        .sum(sum1[0])
    );
    adder_tree_1 add8(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
        .in8(weighted_inputs1_8_1),
        .in9(weighted_inputs1_9_1),
        .in10(weighted_inputs1_10_1),
        .in11(weighted_inputs1_11_1),
        .in12(weighted_inputs1_12_1),
        .in13(weighted_inputs1_13_1),
        .in14(weighted_inputs1_14_1),
        .in15(weighted_inputs1_15_1),
        .sum(sum2[0])
    );
    adder_tree_bar_1 addb0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .in8(weighted_inputs1_8_0),
        .in9(weighted_inputs1_9_0),
        .in10(weighted_inputs1_10_0),
        .in11(weighted_inputs1_11_0),
        .in12(weighted_inputs1_12_0),
        .in13(weighted_inputs1_13_0),
        .in14(weighted_inputs1_14_0),
        .in15(weighted_inputs1_15_0),
        .sum(sum1bar[0])
    );
    adder_tree_bar_1 addb8(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
        .in8(weighted_inputs1_8_1),
        .in9(weighted_inputs1_9_1),
        .in10(weighted_inputs1_10_1),
        .in11(weighted_inputs1_11_1),
        .in12(weighted_inputs1_12_1),
        .in13(weighted_inputs1_13_1),
        .in14(weighted_inputs1_14_1),
        .in15(weighted_inputs1_15_1),
        .sum(sum2bar[0])
    );
    adder_tree_1 add1(
        .in0(weighted_inputs2_0_0),
        .in1(weighted_inputs2_1_0),
        .in2(weighted_inputs2_2_0),
        .in3(weighted_inputs2_3_0),
        .in4(weighted_inputs2_4_0),
        .in5(weighted_inputs2_5_0),
        .in6(weighted_inputs2_6_0),
        .in7(weighted_inputs2_7_0),
        .in8(weighted_inputs2_8_0),
        .in9(weighted_inputs2_9_0),
        .in10(weighted_inputs2_10_0),
        .in11(weighted_inputs2_11_0),
        .in12(weighted_inputs2_12_0),
        .in13(weighted_inputs2_13_0),
        .in14(weighted_inputs2_14_0),
        .in15(weighted_inputs2_15_0),
        .sum(sum1[1])
    );
    adder_tree_1 add9(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .in8(weighted_inputs2_8_1),
        .in9(weighted_inputs2_9_1),
        .in10(weighted_inputs2_10_1),
        .in11(weighted_inputs2_11_1),
        .in12(weighted_inputs2_12_1),
        .in13(weighted_inputs2_13_1),
        .in14(weighted_inputs2_14_1),
        .in15(weighted_inputs2_15_1),
        .sum(sum2[1])
    );
    adder_tree_bar_1 addb1(
        .in0(weighted_inputs2_0_0),
        .in1(weighted_inputs2_1_0),
        .in2(weighted_inputs2_2_0),
        .in3(weighted_inputs2_3_0),
        .in4(weighted_inputs2_4_0),
        .in5(weighted_inputs2_5_0),
        .in6(weighted_inputs2_6_0),
        .in7(weighted_inputs2_7_0),
        .in8(weighted_inputs2_8_0),
        .in9(weighted_inputs2_9_0),
        .in10(weighted_inputs2_10_0),
        .in11(weighted_inputs2_11_0),
        .in12(weighted_inputs2_12_0),
        .in13(weighted_inputs2_13_0),
        .in14(weighted_inputs2_14_0),
        .in15(weighted_inputs2_15_0),
        .sum(sum1bar[1])
    );
    adder_tree_bar_1 addb9(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .in8(weighted_inputs2_8_1),
        .in9(weighted_inputs2_9_1),
        .in10(weighted_inputs2_10_1),
        .in11(weighted_inputs2_11_1),
        .in12(weighted_inputs2_12_1),
        .in13(weighted_inputs2_13_1),
        .in14(weighted_inputs2_14_1),
        .in15(weighted_inputs2_15_1),
        .sum(sum2bar[1])
    );
    adder_tree_1 add2(
        .in0(weighted_inputs3_0_0),
        .in1(weighted_inputs3_1_0),
        .in2(weighted_inputs3_2_0),
        .in3(weighted_inputs3_3_0),
        .in4(weighted_inputs3_4_0),
        .in5(weighted_inputs3_5_0),
        .in6(weighted_inputs3_6_0),
        .in7(weighted_inputs3_7_0),
        .in8(weighted_inputs3_8_0),
        .in9(weighted_inputs3_9_0),
        .in10(weighted_inputs3_10_0),
        .in11(weighted_inputs3_11_0),
        .in12(weighted_inputs3_12_0),
        .in13(weighted_inputs3_13_0),
        .in14(weighted_inputs3_14_0),
        .in15(weighted_inputs3_15_0),
        .sum(sum1[2])
    );
    adder_tree_1 add10(
        .in0(weighted_inputs3_0_1),
        .in1(weighted_inputs3_1_1),
        .in2(weighted_inputs3_2_1),
        .in3(weighted_inputs3_3_1),
        .in4(weighted_inputs3_4_1),
        .in5(weighted_inputs3_5_1),
        .in6(weighted_inputs3_6_1),
        .in7(weighted_inputs3_7_1),
        .in8(weighted_inputs3_8_1),
        .in9(weighted_inputs3_9_1),
        .in10(weighted_inputs3_10_1),
        .in11(weighted_inputs3_11_1),
        .in12(weighted_inputs3_12_1),
        .in13(weighted_inputs3_13_1),
        .in14(weighted_inputs3_14_1),
        .in15(weighted_inputs3_15_1),
        .sum(sum2[2])
    );
    adder_tree_bar_1 addb2(
        .in0(weighted_inputs3_0_0),
        .in1(weighted_inputs3_1_0),
        .in2(weighted_inputs3_2_0),
        .in3(weighted_inputs3_3_0),
        .in4(weighted_inputs3_4_0),
        .in5(weighted_inputs3_5_0),
        .in6(weighted_inputs3_6_0),
        .in7(weighted_inputs3_7_0),
        .in8(weighted_inputs3_8_0),
        .in9(weighted_inputs3_9_0),
        .in10(weighted_inputs3_10_0),
        .in11(weighted_inputs3_11_0),
        .in12(weighted_inputs3_12_0),
        .in13(weighted_inputs3_13_0),
        .in14(weighted_inputs3_14_0),
        .in15(weighted_inputs3_15_0),
        .sum(sum1bar[2])
    );
    adder_tree_bar_1 addb10(
        .in0(weighted_inputs3_0_1),
        .in1(weighted_inputs3_1_1),
        .in2(weighted_inputs3_2_1),
        .in3(weighted_inputs3_3_1),
        .in4(weighted_inputs3_4_1),
        .in5(weighted_inputs3_5_1),
        .in6(weighted_inputs3_6_1),
        .in7(weighted_inputs3_7_1),
        .in8(weighted_inputs3_8_1),
        .in9(weighted_inputs3_9_1),
        .in10(weighted_inputs3_10_1),
        .in11(weighted_inputs3_11_1),
        .in12(weighted_inputs3_12_1),
        .in13(weighted_inputs3_13_1),
        .in14(weighted_inputs3_14_1),
        .in15(weighted_inputs3_15_1),
        .sum(sum2bar[2])
    );
    adder_tree_1 add3(
        .in0(weighted_inputs4_0_0),
        .in1(weighted_inputs4_1_0),
        .in2(weighted_inputs4_2_0),
        .in3(weighted_inputs4_3_0),
        .in4(weighted_inputs4_4_0),
        .in5(weighted_inputs4_5_0),
        .in6(weighted_inputs4_6_0),
        .in7(weighted_inputs4_7_0),
        .in8(weighted_inputs4_8_0),
        .in9(weighted_inputs4_9_0),
        .in10(weighted_inputs4_10_0),
        .in11(weighted_inputs4_11_0),
        .in12(weighted_inputs4_12_0),
        .in13(weighted_inputs4_13_0),
        .in14(weighted_inputs4_14_0),
        .in15(weighted_inputs4_15_0),
        .sum(sum1[3])
    );
    adder_tree_1 add11(
        .in0(weighted_inputs4_0_1),
        .in1(weighted_inputs4_1_1),
        .in2(weighted_inputs4_2_1),
        .in3(weighted_inputs4_3_1),
        .in4(weighted_inputs4_4_1),
        .in5(weighted_inputs4_5_1),
        .in6(weighted_inputs4_6_1),
        .in7(weighted_inputs4_7_1),
        .in8(weighted_inputs4_8_1),
        .in9(weighted_inputs4_9_1),
        .in10(weighted_inputs4_10_1),
        .in11(weighted_inputs4_11_1),
        .in12(weighted_inputs4_12_1),
        .in13(weighted_inputs4_13_1),
        .in14(weighted_inputs4_14_1),
        .in15(weighted_inputs4_15_1),
        .sum(sum2[3])
    );
    adder_tree_bar_1 addb3(
        .in0(weighted_inputs4_0_0),
        .in1(weighted_inputs4_1_0),
        .in2(weighted_inputs4_2_0),
        .in3(weighted_inputs4_3_0),
        .in4(weighted_inputs4_4_0),
        .in5(weighted_inputs4_5_0),
        .in6(weighted_inputs4_6_0),
        .in7(weighted_inputs4_7_0),
        .in8(weighted_inputs4_8_0),
        .in9(weighted_inputs4_9_0),
        .in10(weighted_inputs4_10_0),
        .in11(weighted_inputs4_11_0),
        .in12(weighted_inputs4_12_0),
        .in13(weighted_inputs4_13_0),
        .in14(weighted_inputs4_14_0),
        .in15(weighted_inputs4_15_0),
        .sum(sum1bar[3])
    );
    adder_tree_bar_1 addb11(
        .in0(weighted_inputs4_0_1),
        .in1(weighted_inputs4_1_1),
        .in2(weighted_inputs4_2_1),
        .in3(weighted_inputs4_3_1),
        .in4(weighted_inputs4_4_1),
        .in5(weighted_inputs4_5_1),
        .in6(weighted_inputs4_6_1),
        .in7(weighted_inputs4_7_1),
        .in8(weighted_inputs4_8_1),
        .in9(weighted_inputs4_9_1),
        .in10(weighted_inputs4_10_1),
        .in11(weighted_inputs4_11_1),
        .in12(weighted_inputs4_12_1),
        .in13(weighted_inputs4_13_1),
        .in14(weighted_inputs4_14_1),
        .in15(weighted_inputs4_15_1),
        .sum(sum2bar[3])
    );
    adder_tree_1 add4(
        .in0(weighted_inputs5_0_0),
        .in1(weighted_inputs5_1_0),
        .in2(weighted_inputs5_2_0),
        .in3(weighted_inputs5_3_0),
        .in4(weighted_inputs5_4_0),
        .in5(weighted_inputs5_5_0),
        .in6(weighted_inputs5_6_0),
        .in7(weighted_inputs5_7_0),
        .in8(weighted_inputs5_8_0),
        .in9(weighted_inputs5_9_0),
        .in10(weighted_inputs5_10_0),
        .in11(weighted_inputs5_11_0),
        .in12(weighted_inputs5_12_0),
        .in13(weighted_inputs5_13_0),
        .in14(weighted_inputs5_14_0),
        .in15(weighted_inputs5_15_0),
        .sum(sum1[4])
    );
    adder_tree_1 add12(
        .in0(weighted_inputs5_0_1),
        .in1(weighted_inputs5_1_1),
        .in2(weighted_inputs5_2_1),
        .in3(weighted_inputs5_3_1),
        .in4(weighted_inputs5_4_1),
        .in5(weighted_inputs5_5_1),
        .in6(weighted_inputs5_6_1),
        .in7(weighted_inputs5_7_1),
        .in8(weighted_inputs5_8_1),
        .in9(weighted_inputs5_9_1),
        .in10(weighted_inputs5_10_1),
        .in11(weighted_inputs5_11_1),
        .in12(weighted_inputs5_12_1),
        .in13(weighted_inputs5_13_1),
        .in14(weighted_inputs5_14_1),
        .in15(weighted_inputs5_15_1),
        .sum(sum2[4])
    );
    adder_tree_bar_1 addb4(
        .in0(weighted_inputs5_0_0),
        .in1(weighted_inputs5_1_0),
        .in2(weighted_inputs5_2_0),
        .in3(weighted_inputs5_3_0),
        .in4(weighted_inputs5_4_0),
        .in5(weighted_inputs5_5_0),
        .in6(weighted_inputs5_6_0),
        .in7(weighted_inputs5_7_0),
        .in8(weighted_inputs5_8_0),
        .in9(weighted_inputs5_9_0),
        .in10(weighted_inputs5_10_0),
        .in11(weighted_inputs5_11_0),
        .in12(weighted_inputs5_12_0),
        .in13(weighted_inputs5_13_0),
        .in14(weighted_inputs5_14_0),
        .in15(weighted_inputs5_15_0),
        .sum(sum1bar[4])
    );
    adder_tree_bar_1 addb12(
        .in0(weighted_inputs5_0_1),
        .in1(weighted_inputs5_1_1),
        .in2(weighted_inputs5_2_1),
        .in3(weighted_inputs5_3_1),
        .in4(weighted_inputs5_4_1),
        .in5(weighted_inputs5_5_1),
        .in6(weighted_inputs5_6_1),
        .in7(weighted_inputs5_7_1),
        .in8(weighted_inputs5_8_1),
        .in9(weighted_inputs5_9_1),
        .in10(weighted_inputs5_10_1),
        .in11(weighted_inputs5_11_1),
        .in12(weighted_inputs5_12_1),
        .in13(weighted_inputs5_13_1),
        .in14(weighted_inputs5_14_1),
        .in15(weighted_inputs5_15_1),
        .sum(sum2bar[4])
    );
    adder_tree_1 add5(
        .in0(weighted_inputs6_0_0),
        .in1(weighted_inputs6_1_0),
        .in2(weighted_inputs6_2_0),
        .in3(weighted_inputs6_3_0),
        .in4(weighted_inputs6_4_0),
        .in5(weighted_inputs6_5_0),
        .in6(weighted_inputs6_6_0),
        .in7(weighted_inputs6_7_0),
        .in8(weighted_inputs6_8_0),
        .in9(weighted_inputs6_9_0),
        .in10(weighted_inputs6_10_0),
        .in11(weighted_inputs6_11_0),
        .in12(weighted_inputs6_12_0),
        .in13(weighted_inputs6_13_0),
        .in14(weighted_inputs6_14_0),
        .in15(weighted_inputs6_15_0),
        .sum(sum1[5])
    );
    adder_tree_1 add13(
        .in0(weighted_inputs6_0_1),
        .in1(weighted_inputs6_1_1),
        .in2(weighted_inputs6_2_1),
        .in3(weighted_inputs6_3_1),
        .in4(weighted_inputs6_4_1),
        .in5(weighted_inputs6_5_1),
        .in6(weighted_inputs6_6_1),
        .in7(weighted_inputs6_7_1),
        .in8(weighted_inputs6_8_1),
        .in9(weighted_inputs6_9_1),
        .in10(weighted_inputs6_10_1),
        .in11(weighted_inputs6_11_1),
        .in12(weighted_inputs6_12_1),
        .in13(weighted_inputs6_13_1),
        .in14(weighted_inputs6_14_1),
        .in15(weighted_inputs6_15_1),
        .sum(sum2[5])
    );
    adder_tree_bar_1 addb5(
        .in0(weighted_inputs6_0_0),
        .in1(weighted_inputs6_1_0),
        .in2(weighted_inputs6_2_0),
        .in3(weighted_inputs6_3_0),
        .in4(weighted_inputs6_4_0),
        .in5(weighted_inputs6_5_0),
        .in6(weighted_inputs6_6_0),
        .in7(weighted_inputs6_7_0),
        .in8(weighted_inputs6_8_0),
        .in9(weighted_inputs6_9_0),
        .in10(weighted_inputs6_10_0),
        .in11(weighted_inputs6_11_0),
        .in12(weighted_inputs6_12_0),
        .in13(weighted_inputs6_13_0),
        .in14(weighted_inputs6_14_0),
        .in15(weighted_inputs6_15_0),
        .sum(sum1bar[5])
    );
    adder_tree_bar_1 addb13(
        .in0(weighted_inputs6_0_1),
        .in1(weighted_inputs6_1_1),
        .in2(weighted_inputs6_2_1),
        .in3(weighted_inputs6_3_1),
        .in4(weighted_inputs6_4_1),
        .in5(weighted_inputs6_5_1),
        .in6(weighted_inputs6_6_1),
        .in7(weighted_inputs6_7_1),
        .in8(weighted_inputs6_8_1),
        .in9(weighted_inputs6_9_1),
        .in10(weighted_inputs6_10_1),
        .in11(weighted_inputs6_11_1),
        .in12(weighted_inputs6_12_1),
        .in13(weighted_inputs6_13_1),
        .in14(weighted_inputs6_14_1),
        .in15(weighted_inputs6_15_1),
        .sum(sum2bar[5])
    );
    adder_tree_1 add6(
        .in0(weighted_inputs7_0_0),
        .in1(weighted_inputs7_1_0),
        .in2(weighted_inputs7_2_0),
        .in3(weighted_inputs7_3_0),
        .in4(weighted_inputs7_4_0),
        .in5(weighted_inputs7_5_0),
        .in6(weighted_inputs7_6_0),
        .in7(weighted_inputs7_7_0),
        .in8(weighted_inputs7_8_0),
        .in9(weighted_inputs7_9_0),
        .in10(weighted_inputs7_10_0),
        .in11(weighted_inputs7_11_0),
        .in12(weighted_inputs7_12_0),
        .in13(weighted_inputs7_13_0),
        .in14(weighted_inputs7_14_0),
        .in15(weighted_inputs7_15_0),
        .sum(sum1[6])
    );
    adder_tree_1 add14(
        .in0(weighted_inputs7_0_1),
        .in1(weighted_inputs7_1_1),
        .in2(weighted_inputs7_2_1),
        .in3(weighted_inputs7_3_1),
        .in4(weighted_inputs7_4_1),
        .in5(weighted_inputs7_5_1),
        .in6(weighted_inputs7_6_1),
        .in7(weighted_inputs7_7_1),
        .in8(weighted_inputs7_8_1),
        .in9(weighted_inputs7_9_1),
        .in10(weighted_inputs7_10_1),
        .in11(weighted_inputs7_11_1),
        .in12(weighted_inputs7_12_1),
        .in13(weighted_inputs7_13_1),
        .in14(weighted_inputs7_14_1),
        .in15(weighted_inputs7_15_1),
        .sum(sum2[6])
    );
    adder_tree_bar_1 addb6(
        .in0(weighted_inputs7_0_0),
        .in1(weighted_inputs7_1_0),
        .in2(weighted_inputs7_2_0),
        .in3(weighted_inputs7_3_0),
        .in4(weighted_inputs7_4_0),
        .in5(weighted_inputs7_5_0),
        .in6(weighted_inputs7_6_0),
        .in7(weighted_inputs7_7_0),
        .in8(weighted_inputs7_8_0),
        .in9(weighted_inputs7_9_0),
        .in10(weighted_inputs7_10_0),
        .in11(weighted_inputs7_11_0),
        .in12(weighted_inputs7_12_0),
        .in13(weighted_inputs7_13_0),
        .in14(weighted_inputs7_14_0),
        .in15(weighted_inputs7_15_0),
        .sum(sum1bar[6])
    );
    adder_tree_bar_1 addb14(
        .in0(weighted_inputs7_0_1),
        .in1(weighted_inputs7_1_1),
        .in2(weighted_inputs7_2_1),
        .in3(weighted_inputs7_3_1),
        .in4(weighted_inputs7_4_1),
        .in5(weighted_inputs7_5_1),
        .in6(weighted_inputs7_6_1),
        .in7(weighted_inputs7_7_1),
        .in8(weighted_inputs7_8_1),
        .in9(weighted_inputs7_9_1),
        .in10(weighted_inputs7_10_1),
        .in11(weighted_inputs7_11_1),
        .in12(weighted_inputs7_12_1),
        .in13(weighted_inputs7_13_1),
        .in14(weighted_inputs7_14_1),
        .in15(weighted_inputs7_15_1),
        .sum(sum2bar[6])
    );
    adder_tree_1 add7(
        .in0(weighted_inputs8_0_0),
        .in1(weighted_inputs8_1_0),
        .in2(weighted_inputs8_2_0),
        .in3(weighted_inputs8_3_0),
        .in4(weighted_inputs8_4_0),
        .in5(weighted_inputs8_5_0),
        .in6(weighted_inputs8_6_0),
        .in7(weighted_inputs8_7_0),
        .in8(weighted_inputs8_8_0),
        .in9(weighted_inputs8_9_0),
        .in10(weighted_inputs8_10_0),
        .in11(weighted_inputs8_11_0),
        .in12(weighted_inputs8_12_0),
        .in13(weighted_inputs8_13_0),
        .in14(weighted_inputs8_14_0),
        .in15(weighted_inputs8_15_0),
        .sum(sum1[7])
    );
    adder_tree_1 add15(
        .in0(weighted_inputs8_0_1),
        .in1(weighted_inputs8_1_1),
        .in2(weighted_inputs8_2_1),
        .in3(weighted_inputs8_3_1),
        .in4(weighted_inputs8_4_1),
        .in5(weighted_inputs8_5_1),
        .in6(weighted_inputs8_6_1),
        .in7(weighted_inputs8_7_1),
        .in8(weighted_inputs8_8_1),
        .in9(weighted_inputs8_9_1),
        .in10(weighted_inputs8_10_1),
        .in11(weighted_inputs8_11_1),
        .in12(weighted_inputs8_12_1),
        .in13(weighted_inputs8_13_1),
        .in14(weighted_inputs8_14_1),
        .in15(weighted_inputs8_15_1),
        .sum(sum2[7])
    );
    adder_tree_bar_1 addb7(
        .in0(weighted_inputs8_0_0),
        .in1(weighted_inputs8_1_0),
        .in2(weighted_inputs8_2_0),
        .in3(weighted_inputs8_3_0),
        .in4(weighted_inputs8_4_0),
        .in5(weighted_inputs8_5_0),
        .in6(weighted_inputs8_6_0),
        .in7(weighted_inputs8_7_0),
        .in8(weighted_inputs8_8_0),
        .in9(weighted_inputs8_9_0),
        .in10(weighted_inputs8_10_0),
        .in11(weighted_inputs8_11_0),
        .in12(weighted_inputs8_12_0),
        .in13(weighted_inputs8_13_0),
        .in14(weighted_inputs8_14_0),
        .in15(weighted_inputs8_15_0),
        .sum(sum1bar[7])
    );
    adder_tree_bar_1 addb15(
        .in0(weighted_inputs8_0_1),
        .in1(weighted_inputs8_1_1),
        .in2(weighted_inputs8_2_1),
        .in3(weighted_inputs8_3_1),
        .in4(weighted_inputs8_4_1),
        .in5(weighted_inputs8_5_1),
        .in6(weighted_inputs8_6_1),
        .in7(weighted_inputs8_7_1),
        .in8(weighted_inputs8_8_1),
        .in9(weighted_inputs8_9_1),
        .in10(weighted_inputs8_10_1),
        .in11(weighted_inputs8_11_1),
        .in12(weighted_inputs8_12_1),
        .in13(weighted_inputs8_13_1),
        .in14(weighted_inputs8_14_1),
        .in15(weighted_inputs8_15_1),
        .sum(sum2bar[7])
    );
    add7bit_1 u0 (.a(sum1[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1[0]));
    add7bit_1 u8 (.a(sum2[0]), .b(b1_1), .cin(1'b0), .y(biased_sum2[0]));
    add7bitbar_1 ub0 (.a(sum1bar[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1bar[0]));
    add7bitbar_1 ub8 (.a(sum2bar[0]), .b(b1_1), .cin(1'b0), .y(biased_sum2bar[0]));
    add7bit_1 u1 (.a(sum1[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1[1]));
    add7bit_1 u9 (.a(sum2[1]), .b(b2_1), .cin(1'b0), .y(biased_sum2[1]));
    add7bitbar_1 ub1 (.a(sum1bar[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1bar[1]));
    add7bitbar_1 ub9 (.a(sum2bar[1]), .b(b2_1), .cin(1'b0), .y(biased_sum2bar[1]));
    add7bit_1 u2 (.a(sum1[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1[2]));
    add7bit_1 u10 (.a(sum2[2]), .b(b3_1), .cin(1'b0), .y(biased_sum2[2]));
    add7bitbar_1 ub2 (.a(sum1bar[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1bar[2]));
    add7bitbar_1 ub10 (.a(sum2bar[2]), .b(b3_1), .cin(1'b0), .y(biased_sum2bar[2]));
    add7bit_1 u3 (.a(sum1[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1[3]));
    add7bit_1 u11 (.a(sum2[3]), .b(b4_1), .cin(1'b0), .y(biased_sum2[3]));
    add7bitbar_1 ub3 (.a(sum1bar[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1bar[3]));
    add7bitbar_1 ub11 (.a(sum2bar[3]), .b(b4_1), .cin(1'b0), .y(biased_sum2bar[3]));
    add7bit_1 u4 (.a(sum1[4]), .b(b5_1), .cin(1'b0), .y(biased_sum1[4]));
    add7bit_1 u12 (.a(sum2[4]), .b(b5_1), .cin(1'b0), .y(biased_sum2[4]));
    add7bitbar_1 ub4 (.a(sum1bar[4]), .b(b5_1), .cin(1'b0), .y(biased_sum1bar[4]));
    add7bitbar_1 ub12 (.a(sum2bar[4]), .b(b5_1), .cin(1'b0), .y(biased_sum2bar[4]));
    add7bit_1 u5 (.a(sum1[5]), .b(b6_1), .cin(1'b0), .y(biased_sum1[5]));
    add7bit_1 u13 (.a(sum2[5]), .b(b6_1), .cin(1'b0), .y(biased_sum2[5]));
    add7bitbar_1 ub5 (.a(sum1bar[5]), .b(b6_1), .cin(1'b0), .y(biased_sum1bar[5]));
    add7bitbar_1 ub13 (.a(sum2bar[5]), .b(b6_1), .cin(1'b0), .y(biased_sum2bar[5]));
    add7bit_1 u6 (.a(sum1[6]), .b(b7_1), .cin(1'b0), .y(biased_sum1[6]));
    add7bit_1 u14 (.a(sum2[6]), .b(b7_1), .cin(1'b0), .y(biased_sum2[6]));
    add7bitbar_1 ub6 (.a(sum1bar[6]), .b(b7_1), .cin(1'b0), .y(biased_sum1bar[6]));
    add7bitbar_1 ub14 (.a(sum2bar[6]), .b(b7_1), .cin(1'b0), .y(biased_sum2bar[6]));
    add7bit_1 u7 (.a(sum1[7]), .b(b8_1), .cin(1'b0), .y(biased_sum1[7]));
    add7bit_1 u15 (.a(sum2[7]), .b(b8_1), .cin(1'b0), .y(biased_sum2[7]));
    add7bitbar_1 ub7 (.a(sum1bar[7]), .b(b8_1), .cin(1'b0), .y(biased_sum1bar[7]));
    add7bitbar_1 ub15 (.a(sum2bar[7]), .b(b8_1), .cin(1'b0), .y(biased_sum2bar[7]));
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
    always @(*) begin
        $display("----- BNN LAYER 1 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_1, inputs1_1, inputs2_1, inputs3_1, inputs4_1, inputs5_1, inputs6_1, inputs7_1, inputs8_1, inputs9_1, inputs10_1, inputs11_1, inputs12_1, inputs13_1, inputs14_1, inputs15_1);
        $display("Weights0: %b %b %b %b %b %b %b %b", w1_0_1, w2_0_1, w3_0_1, w4_0_1, w5_0_1, w6_0_1, w7_0_1, w8_0_1);
        $display("Weights1: %b %b %b %b %b %b %b %b", w1_1_1, w2_1_1, w3_1_1, w4_1_1, w5_1_1, w6_1_1, w7_1_1, w8_1_1);
        $display("sum1: %b %b %b %b %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3], sum1[4], sum1[5], sum1[6], sum1[7]);
        $display("sum2: %b %b %b %b %b %b %b %b", sum2[0], sum2[1], sum2[2], sum2[3], sum2[4], sum2[5], sum2[6], sum2[7]);
        $display("sum1bar: %b %b %b %b %b %b %b %b", sum1bar[0], sum1bar[1], sum1bar[2], sum1bar[3], sum1bar[4], sum1bar[5], sum1bar[6], sum1bar[7]);
        $display("sum2bar: %b %b %b %b %b %b %b %b", sum2bar[0], sum2bar[1], sum2bar[2], sum2bar[3], sum2bar[4], sum2bar[5], sum2bar[6], sum2bar[7]);
        $display("biased_sum1: %b %b %b %b %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3], biased_sum1[4], biased_sum1[5], biased_sum1[6], biased_sum1[7]);
        $display("biased_sum2: %b %b %b %b %b %b %b %b", biased_sum2[0], biased_sum2[1], biased_sum2[2], biased_sum2[3], biased_sum2[4], biased_sum2[5], biased_sum2[6], biased_sum2[7]);
        $display("biased_sum1bar: %b %b %b %b %b %b %b %b", biased_sum1bar[0], biased_sum1bar[1], biased_sum1bar[2], biased_sum1bar[3], biased_sum1bar[4], biased_sum1bar[5], biased_sum1bar[6], biased_sum1bar[7]);
        $display("biased_sum2bar: %b %b %b %b %b %b %b %b", biased_sum2bar[0], biased_sum2bar[1], biased_sum2bar[2], biased_sum2bar[3], biased_sum2bar[4], biased_sum2bar[5], biased_sum2bar[6], biased_sum2bar[7]);
    end
endmodule


module activation_1 (

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

    activation_1 a0 (
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

    activation_1 a1 (
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

    activation_1 a2 (
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

    activation_1 a3 (
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

    activation_1 a4 (
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

    activation_1 a5 (
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

    activation_1 a6 (
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

    activation_1 a7 (
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

`timescale 1ns/1ps

module mux_1 (

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


    mux_1 m1(.a(y0[1]), .b(y1[0] ^ y0[1]), .s(arith_share0[0]), .y(arith_share0[1]));

    mux_1 m2(.a(y0[1] ^ y0[2]), .b(y0[2] ^ y1[1]), .s(arith_share0[1]), .y(arith_share0[2]));


    assign arith_share1 = y1;

endmodule




module activation_and_conversion_1(
  input  wire [2:0] inputs0_1,
  input  wire [2:0] inputs1_1,
  input  wire [2:0] inputs2_1,
  input  wire [2:0] inputs3_1,
  input  wire [2:0] inputs4_1,
  input  wire [2:0] inputs5_1,
  input  wire [2:0] inputs6_1,
  input  wire [2:0] inputs7_1,
  input  wire [2:0] inputs8_1,
  input  wire [2:0] inputs9_1,
  input  wire [2:0] inputs10_1,
  input  wire [2:0] inputs11_1,
  input  wire [2:0] inputs12_1,
  input  wire [2:0] inputs13_1,
  input  wire [2:0] inputs14_1,
  input  wire [2:0] inputs15_1,
  input  wire [15:0] w1_0_1, w1_1_1,
  input  wire [15:0] w2_0_1, w2_1_1,
  input  wire [15:0] w3_0_1, w3_1_1,
  input  wire [15:0] w4_0_1, w4_1_1,
  input  wire [15:0] w5_0_1, w5_1_1,
  input  wire [15:0] w6_0_1, w6_1_1,
  input  wire [15:0] w7_0_1, w7_1_1,
  input  wire [15:0] w8_0_1, w8_1_1,
  input  wire [6:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1,
  input  wire r0_0,
  input  wire r1_0,
  input  wire r2_0,
  input  wire r3_0,
  input  wire r4_0,
  input  wire r5_0,
  input  wire r6_0,
  input  wire r7_0,
  input  wire r0_1,
  input  wire r1_1,
  input  wire r2_1,
  input  wire r3_1,
  input  wire r4_1,
  input  wire r5_1,
  input  wire r6_1,
  input  wire r7_1,
  input  wire r0_2,
  input  wire r1_2,
  input  wire r2_2,
  input  wire r3_2,
  input  wire r4_2,
  input  wire r5_2,
  input  wire r6_2,
  input  wire r7_2,
  input  wire r0_3,
  input  wire r1_3,
  input  wire r2_3,
  input  wire r3_3,
  input  wire r4_3,
  input  wire r5_3,
  input  wire r6_3,
  input  wire r7_3,
  input  wire r0_4,
  input  wire r1_4,
  input  wire r2_4,
  input  wire r3_4,
  input  wire r4_4,
  input  wire r5_4,
  input  wire r6_4,
  input  wire r7_4,
  input  wire r0_5,
  input  wire r1_5,
  input  wire r2_5,
  input  wire r3_5,
  input  wire r4_5,
  input  wire r5_5,
  input  wire r6_5,
  input  wire r7_5,
  input  wire r0_6,
  input  wire r1_6,
  input  wire r2_6,
  input  wire r3_6,
  input  wire r4_6,
  input  wire r5_6,
  input  wire r6_6,
  input  wire r7_6,
  input  wire r0_7,
  input  wire r1_7,
  input  wire r2_7,
  input  wire r3_7,
  input  wire r4_7,
  input  wire r5_7,
  input  wire r6_7,
  input  wire r7_7,
  input wire [1:0] ar0, ar0bar,
  input wire [1:0] ar1, ar1bar,
  input wire [1:0] ar2, ar2bar,
  input wire [1:0] ar3, ar3bar,
  input wire [1:0] ar4, ar4bar,
  input wire [1:0] ar5, ar5bar,
  input wire [1:0] ar6, ar6bar,
  input wire [1:0] ar7, ar7bar,
  output wire masked_activation0_1, masked_activation0bar_1,
  output wire mask0_1, mask0bar_1,
  output wire masked_activation1_1, masked_activation1bar_1,
  output wire mask1_1, mask1bar_1,
  output wire masked_activation2_1, masked_activation2bar_1,
  output wire mask2_1, mask2bar_1,
  output wire masked_activation3_1, masked_activation3bar_1,
  output wire mask3_1, mask3bar_1,
  output wire masked_activation4_1, masked_activation4bar_1,
  output wire mask4_1, mask4bar_1,
  output wire masked_activation5_1, masked_activation5bar_1,
  output wire mask5_1, mask5bar_1,
  output wire masked_activation6_1, masked_activation6bar_1,
  output wire mask6_1, mask6bar_1,
  output wire masked_activation7_1, masked_activation7bar_1,
  output wire mask7_1, mask7bar_1,
  output wire [2:0] act0_0_1, act0_1_1,
  output wire [2:0] act0_0bar_1, act0_1bar_1,
  output wire [2:0] act1_0_1, act1_1_1,
  output wire [2:0] act1_0bar_1, act1_1bar_1,
  output wire [2:0] act2_0_1, act2_1_1,
  output wire [2:0] act2_0bar_1, act2_1bar_1,
  output wire [2:0] act3_0_1, act3_1_1,
  output wire [2:0] act3_0bar_1, act3_1bar_1,
  output wire [2:0] act4_0_1, act4_1_1,
  output wire [2:0] act4_0bar_1, act4_1bar_1,
  output wire [2:0] act5_0_1, act5_1_1,
  output wire [2:0] act5_0bar_1, act5_1bar_1,
  output wire [2:0] act6_0_1, act6_1_1,
  output wire [2:0] act6_0bar_1, act6_1bar_1,
  output wire [2:0] act7_0_1, act7_1_1,
  output wire [2:0] act7_0bar_1, act7_1bar_1
);

  wire [7:0] biased_sum0_0, biased_sum0_0bar;
  wire [7:0] biased_sum0_1, biased_sum0_1bar;
  wire [7:0] biased_sum1_0, biased_sum1_0bar;
  wire [7:0] biased_sum1_1, biased_sum1_1bar;
  wire [7:0] biased_sum2_0, biased_sum2_0bar;
  wire [7:0] biased_sum2_1, biased_sum2_1bar;
  wire [7:0] biased_sum3_0, biased_sum3_0bar;
  wire [7:0] biased_sum3_1, biased_sum3_1bar;
  wire [7:0] biased_sum4_0, biased_sum4_0bar;
  wire [7:0] biased_sum4_1, biased_sum4_1bar;
  wire [7:0] biased_sum5_0, biased_sum5_0bar;
  wire [7:0] biased_sum5_1, biased_sum5_1bar;
  wire [7:0] biased_sum6_0, biased_sum6_0bar;
  wire [7:0] biased_sum6_1, biased_sum6_1bar;
  wire [7:0] biased_sum7_0, biased_sum7_0bar;
  wire [7:0] biased_sum7_1, biased_sum7_1bar;

    layer1 l1 (
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
    .w1_0_1(w1_0_1), .w1_1_1(w1_1_1),
    .w2_0_1(w2_0_1), .w2_1_1(w2_1_1),
    .w3_0_1(w3_0_1), .w3_1_1(w3_1_1),
    .w4_0_1(w4_0_1), .w4_1_1(w4_1_1),
    .w5_0_1(w5_0_1), .w5_1_1(w5_1_1),
    .w6_0_1(w6_0_1), .w6_1_1(w6_1_1),
    .w7_0_1(w7_0_1), .w7_1_1(w7_1_1),
    .w8_0_1(w8_0_1), .w8_1_1(w8_1_1),
    .b1_1(b1_1),
    .b2_1(b2_1),
    .b3_1(b3_1),
    .b4_1(b4_1),
    .b5_1(b5_1),
    .b6_1(b6_1),
    .b7_1(b7_1),
    .b8_1(b8_1),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum0_1(biased_sum0_1),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum1_1(biased_sum1_1),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum2_1(biased_sum2_1),
    .biased_sum3_0(biased_sum3_0),
    .biased_sum3_1(biased_sum3_1),
    .biased_sum4_0(biased_sum4_0),
    .biased_sum4_1(biased_sum4_1),
    .biased_sum5_0(biased_sum5_0),
    .biased_sum5_1(biased_sum5_1),
    .biased_sum6_0(biased_sum6_0),
    .biased_sum6_1(biased_sum6_1),
    .biased_sum7_0(biased_sum7_0),
    .biased_sum7_1(biased_sum7_1),
    .biased_sum0_0bar(biased_sum0_0bar),
    .biased_sum0_1bar(biased_sum0_1bar),
    .biased_sum1_0bar(biased_sum1_0bar),
    .biased_sum1_1bar(biased_sum1_1bar),
    .biased_sum2_0bar(biased_sum2_0bar),
    .biased_sum2_1bar(biased_sum2_1bar),
    .biased_sum3_0bar(biased_sum3_0bar),
    .biased_sum3_1bar(biased_sum3_1bar),
    .biased_sum4_0bar(biased_sum4_0bar),
    .biased_sum4_1bar(biased_sum4_1bar),
    .biased_sum5_0bar(biased_sum5_0bar),
    .biased_sum5_1bar(biased_sum5_1bar),
    .biased_sum6_0bar(biased_sum6_0bar),
    .biased_sum6_1bar(biased_sum6_1bar),
    .biased_sum7_0bar(biased_sum7_0bar),
    .biased_sum7_1bar(biased_sum7_1bar)
  );

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

    boolean_arithmetic_coversion_1 conv0 (
    .x0(masked_activation0_1),
    .x1(mask0_1),
    .r_mask(ar0),
    .arith_share0(act0_0_1),
    .arith_share1(act0_1_1)
  );

  boolean_arithmetic_coversion_1 conv0b (
    .x0(masked_activation0bar_1),
    .x1(mask0bar_1),
    .r_mask(ar0bar),
    .arith_share0(act0_0bar_1),
    .arith_share1(act0_1bar_1)
  );

  boolean_arithmetic_coversion_1 conv1 (
    .x0(masked_activation1_1),
    .x1(mask1_1),
    .r_mask(ar1),
    .arith_share0(act1_0_1),
    .arith_share1(act1_1_1)
  );

  boolean_arithmetic_coversion_1 conv1b (
    .x0(masked_activation1bar_1),
    .x1(mask1bar_1),
    .r_mask(ar1bar),
    .arith_share0(act1_0bar_1),
    .arith_share1(act1_1bar_1)
  );

  boolean_arithmetic_coversion_1 conv2 (
    .x0(masked_activation2_1),
    .x1(mask2_1),
    .r_mask(ar2),
    .arith_share0(act2_0_1),
    .arith_share1(act2_1_1)
  );

  boolean_arithmetic_coversion_1 conv2b (
    .x0(masked_activation2bar_1),
    .x1(mask2bar_1),
    .r_mask(ar2bar),
    .arith_share0(act2_0bar_1),
    .arith_share1(act2_1bar_1)
  );

  boolean_arithmetic_coversion_1 conv3 (
    .x0(masked_activation3_1),
    .x1(mask3_1),
    .r_mask(ar3),
    .arith_share0(act3_0_1),
    .arith_share1(act3_1_1)
  );

  boolean_arithmetic_coversion_1 conv3b (
    .x0(masked_activation3bar_1),
    .x1(mask3bar_1),
    .r_mask(ar3bar),
    .arith_share0(act3_0bar_1),
    .arith_share1(act3_1bar_1)
  );

  boolean_arithmetic_coversion_1 conv4 (
    .x0(masked_activation4_1),
    .x1(mask4_1),
    .r_mask(ar4),
    .arith_share0(act4_0_1),
    .arith_share1(act4_1_1)
  );

  boolean_arithmetic_coversion_1 conv4b (
    .x0(masked_activation4bar_1),
    .x1(mask4bar_1),
    .r_mask(ar4bar),
    .arith_share0(act4_0bar_1),
    .arith_share1(act4_1bar_1)
  );

  boolean_arithmetic_coversion_1 conv5 (
    .x0(masked_activation5_1),
    .x1(mask5_1),
    .r_mask(ar5),
    .arith_share0(act5_0_1),
    .arith_share1(act5_1_1)
  );

  boolean_arithmetic_coversion_1 conv5b (
    .x0(masked_activation5bar_1),
    .x1(mask5bar_1),
    .r_mask(ar5bar),
    .arith_share0(act5_0bar_1),
    .arith_share1(act5_1bar_1)
  );

  boolean_arithmetic_coversion_1 conv6 (
    .x0(masked_activation6_1),
    .x1(mask6_1),
    .r_mask(ar6),
    .arith_share0(act6_0_1),
    .arith_share1(act6_1_1)
  );

  boolean_arithmetic_coversion_1 conv6b (
    .x0(masked_activation6bar_1),
    .x1(mask6bar_1),
    .r_mask(ar6bar),
    .arith_share0(act6_0bar_1),
    .arith_share1(act6_1bar_1)
  );

  boolean_arithmetic_coversion_1 conv7 (
    .x0(masked_activation7_1),
    .x1(mask7_1),
    .r_mask(ar7),
    .arith_share0(act7_0_1),
    .arith_share1(act7_1_1)
  );

  boolean_arithmetic_coversion_1 conv7b (
    .x0(masked_activation7bar_1),
    .x1(mask7bar_1),
    .r_mask(ar7bar),
    .arith_share0(act7_0bar_1),
    .arith_share1(act7_1bar_1)
  );

    always @(*) begin
    $display("----- LAYER 1   boolean activations -----");
    $display("masked_activation : %b %b %b %b %b %b %b %b", masked_activation0_1, masked_activation1_1, masked_activation2_1, masked_activation3_1, masked_activation4_1, masked_activation5_1, masked_activation6_1, masked_activation7_1);
    $display("masked_activationbar : %b %b %b %b %b %b %b %b", masked_activation0bar_1, masked_activation1bar_1, masked_activation2bar_1, masked_activation3bar_1, masked_activation4bar_1, masked_activation5bar_1, masked_activation6bar_1, masked_activation7bar_1);
    $display("mask : %b %b %b %b %b %b %b %b", mask0_1, mask1_1, mask2_1, mask3_1, mask4_1, mask5_1, mask6_1, mask7_1);
    $display("maskbar : %b %b %b %b %b %b %b %b", mask0bar_1, mask1bar_1, mask2bar_1, mask3bar_1, mask4bar_1, mask5bar_1, mask6bar_1, mask7bar_1);
  end

  always @(*) begin
    $display("----- LAYER 1  arithmetic activations -----");
    $display("masked_activation_arith : %b %b %b %b %b %b %b %b", act0_0_1, act1_0_1, act2_0_1, act3_0_1, act4_0_1, act5_0_1, act6_0_1, act7_0_1);
    $display("mask_arith : %b %b %b %b %b %b %b %b", act0_1_1, act1_1_1, act2_1_1, act3_1_1, act4_1_1, act5_1_1, act6_1_1, act7_1_1);
    $display("masked_activationbar_arith : %b %b %b %b %b %b %b %b", act0_0bar_1, act1_0bar_1, act2_0bar_1, act3_0bar_1, act4_0bar_1, act5_0bar_1, act6_0bar_1, act7_0bar_1);
    $display("mask_arithbar : %b %b %b %b %b %b %b %b", act0_1bar_1, act1_1bar_1, act2_1bar_1, act3_1bar_1, act4_1bar_1, act5_1bar_1, act6_1bar_1, act7_1bar_1);
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

module add6bit_2(
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

full_adder_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_2 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_2 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNAND_2 wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNAND_2 wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNAND_2 wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNAND_2 wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout;

endmodule

module add7bit_2(
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

full_adder_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_2 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_2 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_2 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));

WddlNAND_2 wn1(.A(~a[6]), .B(b[6]), .C(~c7), .S(s1), .S1(s1_1));
WddlNAND_2 wn2(.A(a[6]), .B(~b[6]), .C(~c7), .S(s2), .S1(s2_1));
WddlNAND_2 wn3(.A(a[6]), .B(b[6]), .C(c7), .S(s3), .S1(s3_1));
WddlNAND_2 wn4(.A(~a[6]), .B(~b[6]), .C(c7), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[7] = cout;

endmodule

module add8bit_2(
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

full_adder_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_2 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_2 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_2 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adder_2 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));

WddlNAND_2 wn1(.A(~a[7]), .B(b[7]), .C(~c8), .S(s1), .S1(s1_1));
WddlNAND_2 wn2(.A(a[7]), .B(~b[7]), .C(~c8), .S(s2), .S1(s2_1));
WddlNAND_2 wn3(.A(a[7]), .B(b[7]), .C(c8), .S(s3), .S1(s3_1));
WddlNAND_2 wn4(.A(~a[7]), .B(~b[7]), .C(c8), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[8] = cout;

endmodule


module half_adderbar_2(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adderbar_2(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adderbar_2 HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adderbar_2 HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNANDbar_2(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule

module add3bitbar_2(
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

full_adderbar_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNANDbar_2 wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNANDbar_2 wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNANDbar_2 wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNANDbar_2 wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout_bar;

endmodule

module add4bitbar_2(
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

full_adderbar_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNANDbar_2 wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNANDbar_2 wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNANDbar_2 wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNANDbar_2 wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout_bar;

endmodule

module add5bitbar_2(
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

full_adderbar_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_2 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNANDbar_2 wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNANDbar_2 wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNANDbar_2 wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNANDbar_2 wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout_bar;

endmodule

module add6bitbar_2(
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

full_adderbar_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_2 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_2 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNANDbar_2 wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNANDbar_2 wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNANDbar_2 wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNANDbar_2 wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout_bar;

endmodule

module add7bitbar_2(
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

full_adderbar_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_2 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_2 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_2 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));

WddlNANDbar_2 wn1(.A(~a[6]), .B(b[6]), .C(~c7), .S(s1), .S1(s1_1));
WddlNANDbar_2 wn2(.A(a[6]), .B(~b[6]), .C(~c7), .S(s2), .S1(s2_1));
WddlNANDbar_2 wn3(.A(a[6]), .B(b[6]), .C(c7), .S(s3), .S1(s3_1));
WddlNANDbar_2 wn4(.A(~a[6]), .B(~b[6]), .C(c7), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[7] = cout_bar;

endmodule

module add8bitbar_2(
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

full_adderbar_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_2 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_2 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_2 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_2 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_2 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar_2 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));

WddlNANDbar_2 wn1(.A(~a[7]), .B(b[7]), .C(~c8), .S(s1), .S1(s1_1));
WddlNANDbar_2 wn2(.A(a[7]), .B(~b[7]), .C(~c8), .S(s2), .S1(s2_1));
WddlNANDbar_2 wn3(.A(a[7]), .B(b[7]), .C(c8), .S(s3), .S1(s3_1));
WddlNANDbar_2 wn4(.A(~a[7]), .B(~b[7]), .C(c8), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[8] = cout_bar;

endmodule



module adder_tree_2 (
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
    input  wire [2:0] in16,
    input  wire [2:0] in17,
    input  wire [2:0] in18,
    input  wire [2:0] in19,
    input  wire [2:0] in20,
    input  wire [2:0] in21,
    input  wire [2:0] in22,
    input  wire [2:0] in23,
    input  wire [2:0] in24,
    input  wire [2:0] in25,
    input  wire [2:0] in26,
    input  wire [2:0] in27,
    input  wire [2:0] in28,
    input  wire [2:0] in29,
    input  wire [2:0] in30,
    input  wire [2:0] in31,
    output wire [7:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [3:0] stage0_4_lo;
    wire [3:0] stage0_5_lo;
    wire [3:0] stage0_6_lo;
    wire [3:0] stage0_7_lo;
    wire [3:0] stage0_8_lo;
    wire [3:0] stage0_9_lo;
    wire [3:0] stage0_10_lo;
    wire [3:0] stage0_11_lo;
    wire [3:0] stage0_12_lo;
    wire [3:0] stage0_13_lo;
    wire [3:0] stage0_14_lo;
    wire [3:0] stage0_15_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [4:0] stage1_2_lo;
    wire [4:0] stage1_3_lo;
    wire [4:0] stage1_4_lo;
    wire [4:0] stage1_5_lo;
    wire [4:0] stage1_6_lo;
    wire [4:0] stage1_7_lo;
    wire [5:0] stage2_0_lo;
    wire [5:0] stage2_1_lo;
    wire [5:0] stage2_2_lo;
    wire [5:0] stage2_3_lo;
    wire [6:0] stage3_0_lo;
    wire [6:0] stage3_1_lo;
    wire [7:0] stage4_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [3:0] stage0_4;
    reg  [3:0] stage0_5;
    reg  [3:0] stage0_6;
    reg  [3:0] stage0_7;
    reg  [3:0] stage0_8;
    reg  [3:0] stage0_9;
    reg  [3:0] stage0_10;
    reg  [3:0] stage0_11;
    reg  [3:0] stage0_12;
    reg  [3:0] stage0_13;
    reg  [3:0] stage0_14;
    reg  [3:0] stage0_15;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [4:0] stage1_2;
    reg  [4:0] stage1_3;
    reg  [4:0] stage1_4;
    reg  [4:0] stage1_5;
    reg  [4:0] stage1_6;
    reg  [4:0] stage1_7;
    reg  [5:0] stage2_0;
    reg  [5:0] stage2_1;
    reg  [5:0] stage2_2;
    reg  [5:0] stage2_3;
    reg  [6:0] stage3_0;
    reg  [6:0] stage3_1;
    reg  [7:0] stage4_0;

    add3bit_2 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bit_2 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bit_2 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bit_2 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add3bit_2 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo), .cout(), .cout_bar());
    add3bit_2 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo), .cout(), .cout_bar());
    add3bit_2 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo), .cout(), .cout_bar());
    add3bit_2 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo), .cout(), .cout_bar());
    add3bit_2 u0_8 (.a(in16), .b(in17), .cin(1'b0), .y(stage0_8_lo), .cout(), .cout_bar());
    add3bit_2 u0_9 (.a(in18), .b(in19), .cin(1'b0), .y(stage0_9_lo), .cout(), .cout_bar());
    add3bit_2 u0_10 (.a(in20), .b(in21), .cin(1'b0), .y(stage0_10_lo), .cout(), .cout_bar());
    add3bit_2 u0_11 (.a(in22), .b(in23), .cin(1'b0), .y(stage0_11_lo), .cout(), .cout_bar());
    add3bit_2 u0_12 (.a(in24), .b(in25), .cin(1'b0), .y(stage0_12_lo), .cout(), .cout_bar());
    add3bit_2 u0_13 (.a(in26), .b(in27), .cin(1'b0), .y(stage0_13_lo), .cout(), .cout_bar());
    add3bit_2 u0_14 (.a(in28), .b(in29), .cin(1'b0), .y(stage0_14_lo), .cout(), .cout_bar());
    add3bit_2 u0_15 (.a(in30), .b(in31), .cin(1'b0), .y(stage0_15_lo), .cout(), .cout_bar());
    add4bit_2 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bit_2 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add4bit_2 u1_2 (.a(stage0_4), .b(stage0_5), .cin(1'b0), .y(stage1_2_lo), .cout(), .cout_bar());
    add4bit_2 u1_3 (.a(stage0_6), .b(stage0_7), .cin(1'b0), .y(stage1_3_lo), .cout(), .cout_bar());
    add4bit_2 u1_4 (.a(stage0_8), .b(stage0_9), .cin(1'b0), .y(stage1_4_lo), .cout(), .cout_bar());
    add4bit_2 u1_5 (.a(stage0_10), .b(stage0_11), .cin(1'b0), .y(stage1_5_lo), .cout(), .cout_bar());
    add4bit_2 u1_6 (.a(stage0_12), .b(stage0_13), .cin(1'b0), .y(stage1_6_lo), .cout(), .cout_bar());
    add4bit_2 u1_7 (.a(stage0_14), .b(stage0_15), .cin(1'b0), .y(stage1_7_lo), .cout(), .cout_bar());
    add5bit_2 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());
    add5bit_2 u2_1 (.a(stage1_2), .b(stage1_3), .cin(1'b0), .y(stage2_1_lo), .cout(), .cout_bar());
    add5bit_2 u2_2 (.a(stage1_4), .b(stage1_5), .cin(1'b0), .y(stage2_2_lo), .cout(), .cout_bar());
    add5bit_2 u2_3 (.a(stage1_6), .b(stage1_7), .cin(1'b0), .y(stage2_3_lo), .cout(), .cout_bar());
    add6bit_2 u3_0 (.a(stage2_0), .b(stage2_1), .cin(1'b0), .y(stage3_0_lo), .cout(), .cout_bar());
    add6bit_2 u3_1 (.a(stage2_2), .b(stage2_3), .cin(1'b0), .y(stage3_1_lo), .cout(), .cout_bar());
    add7bit_2 u4_0 (.a(stage3_0), .b(stage3_1), .cin(1'b0), .y(stage4_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage4_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage0_4 = {1'b0, stage0_4_lo};
        stage0_5 = {1'b0, stage0_5_lo};
        stage0_6 = {1'b0, stage0_6_lo};
        stage0_7 = {1'b0, stage0_7_lo};
        stage0_8 = {1'b0, stage0_8_lo};
        stage0_9 = {1'b0, stage0_9_lo};
        stage0_10 = {1'b0, stage0_10_lo};
        stage0_11 = {1'b0, stage0_11_lo};
        stage0_12 = {1'b0, stage0_12_lo};
        stage0_13 = {1'b0, stage0_13_lo};
        stage0_14 = {1'b0, stage0_14_lo};
        stage0_15 = {1'b0, stage0_15_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage1_2 = {1'b0, stage1_2_lo};
        stage1_3 = {1'b0, stage1_3_lo};
        stage1_4 = {1'b0, stage1_4_lo};
        stage1_5 = {1'b0, stage1_5_lo};
        stage1_6 = {1'b0, stage1_6_lo};
        stage1_7 = {1'b0, stage1_7_lo};
        stage2_0 = {1'b0, stage2_0_lo};
        stage2_1 = {1'b0, stage2_1_lo};
        stage2_2 = {1'b0, stage2_2_lo};
        stage2_3 = {1'b0, stage2_3_lo};
        stage3_0 = {1'b0, stage3_0_lo};
        stage3_1 = {1'b0, stage3_1_lo};
        stage4_0 = {1'b0, stage4_0_lo};
    end
endmodule


module adder_tree_bar_2 (
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
    input  wire [2:0] in16,
    input  wire [2:0] in17,
    input  wire [2:0] in18,
    input  wire [2:0] in19,
    input  wire [2:0] in20,
    input  wire [2:0] in21,
    input  wire [2:0] in22,
    input  wire [2:0] in23,
    input  wire [2:0] in24,
    input  wire [2:0] in25,
    input  wire [2:0] in26,
    input  wire [2:0] in27,
    input  wire [2:0] in28,
    input  wire [2:0] in29,
    input  wire [2:0] in30,
    input  wire [2:0] in31,
    output wire [7:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [3:0] stage0_4_lo;
    wire [3:0] stage0_5_lo;
    wire [3:0] stage0_6_lo;
    wire [3:0] stage0_7_lo;
    wire [3:0] stage0_8_lo;
    wire [3:0] stage0_9_lo;
    wire [3:0] stage0_10_lo;
    wire [3:0] stage0_11_lo;
    wire [3:0] stage0_12_lo;
    wire [3:0] stage0_13_lo;
    wire [3:0] stage0_14_lo;
    wire [3:0] stage0_15_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [4:0] stage1_2_lo;
    wire [4:0] stage1_3_lo;
    wire [4:0] stage1_4_lo;
    wire [4:0] stage1_5_lo;
    wire [4:0] stage1_6_lo;
    wire [4:0] stage1_7_lo;
    wire [5:0] stage2_0_lo;
    wire [5:0] stage2_1_lo;
    wire [5:0] stage2_2_lo;
    wire [5:0] stage2_3_lo;
    wire [6:0] stage3_0_lo;
    wire [6:0] stage3_1_lo;
    wire [7:0] stage4_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [3:0] stage0_4;
    reg  [3:0] stage0_5;
    reg  [3:0] stage0_6;
    reg  [3:0] stage0_7;
    reg  [3:0] stage0_8;
    reg  [3:0] stage0_9;
    reg  [3:0] stage0_10;
    reg  [3:0] stage0_11;
    reg  [3:0] stage0_12;
    reg  [3:0] stage0_13;
    reg  [3:0] stage0_14;
    reg  [3:0] stage0_15;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [4:0] stage1_2;
    reg  [4:0] stage1_3;
    reg  [4:0] stage1_4;
    reg  [4:0] stage1_5;
    reg  [4:0] stage1_6;
    reg  [4:0] stage1_7;
    reg  [5:0] stage2_0;
    reg  [5:0] stage2_1;
    reg  [5:0] stage2_2;
    reg  [5:0] stage2_3;
    reg  [6:0] stage3_0;
    reg  [6:0] stage3_1;
    reg  [7:0] stage4_0;

    add3bitbar_2 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_8 (.a(in16), .b(in17), .cin(1'b0), .y(stage0_8_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_9 (.a(in18), .b(in19), .cin(1'b0), .y(stage0_9_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_10 (.a(in20), .b(in21), .cin(1'b0), .y(stage0_10_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_11 (.a(in22), .b(in23), .cin(1'b0), .y(stage0_11_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_12 (.a(in24), .b(in25), .cin(1'b0), .y(stage0_12_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_13 (.a(in26), .b(in27), .cin(1'b0), .y(stage0_13_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_14 (.a(in28), .b(in29), .cin(1'b0), .y(stage0_14_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_15 (.a(in30), .b(in31), .cin(1'b0), .y(stage0_15_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_2 (.a(stage0_4), .b(stage0_5), .cin(1'b0), .y(stage1_2_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_3 (.a(stage0_6), .b(stage0_7), .cin(1'b0), .y(stage1_3_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_4 (.a(stage0_8), .b(stage0_9), .cin(1'b0), .y(stage1_4_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_5 (.a(stage0_10), .b(stage0_11), .cin(1'b0), .y(stage1_5_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_6 (.a(stage0_12), .b(stage0_13), .cin(1'b0), .y(stage1_6_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_7 (.a(stage0_14), .b(stage0_15), .cin(1'b0), .y(stage1_7_lo), .cout(), .cout_bar());
    add5bitbar_2 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());
    add5bitbar_2 u2_1 (.a(stage1_2), .b(stage1_3), .cin(1'b0), .y(stage2_1_lo), .cout(), .cout_bar());
    add5bitbar_2 u2_2 (.a(stage1_4), .b(stage1_5), .cin(1'b0), .y(stage2_2_lo), .cout(), .cout_bar());
    add5bitbar_2 u2_3 (.a(stage1_6), .b(stage1_7), .cin(1'b0), .y(stage2_3_lo), .cout(), .cout_bar());
    add6bitbar_2 u3_0 (.a(stage2_0), .b(stage2_1), .cin(1'b0), .y(stage3_0_lo), .cout(), .cout_bar());
    add6bitbar_2 u3_1 (.a(stage2_2), .b(stage2_3), .cin(1'b0), .y(stage3_1_lo), .cout(), .cout_bar());
    add7bitbar_2 u4_0 (.a(stage3_0), .b(stage3_1), .cin(1'b0), .y(stage4_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage4_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage0_4 = {1'b0, stage0_4_lo};
        stage0_5 = {1'b0, stage0_5_lo};
        stage0_6 = {1'b0, stage0_6_lo};
        stage0_7 = {1'b0, stage0_7_lo};
        stage0_8 = {1'b0, stage0_8_lo};
        stage0_9 = {1'b0, stage0_9_lo};
        stage0_10 = {1'b0, stage0_10_lo};
        stage0_11 = {1'b0, stage0_11_lo};
        stage0_12 = {1'b0, stage0_12_lo};
        stage0_13 = {1'b0, stage0_13_lo};
        stage0_14 = {1'b0, stage0_14_lo};
        stage0_15 = {1'b0, stage0_15_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage1_2 = {1'b0, stage1_2_lo};
        stage1_3 = {1'b0, stage1_3_lo};
        stage1_4 = {1'b0, stage1_4_lo};
        stage1_5 = {1'b0, stage1_5_lo};
        stage1_6 = {1'b0, stage1_6_lo};
        stage1_7 = {1'b0, stage1_7_lo};
        stage2_0 = {1'b0, stage2_0_lo};
        stage2_1 = {1'b0, stage2_1_lo};
        stage2_2 = {1'b0, stage2_2_lo};
        stage2_3 = {1'b0, stage2_3_lo};
        stage3_0 = {1'b0, stage3_0_lo};
        stage3_1 = {1'b0, stage3_1_lo};
        stage4_0 = {1'b0, stage4_0_lo};
    end
endmodule


module layer2(
    input [2:0] inputs0_2 , inputs1_2 , inputs2_2 , inputs3_2 , inputs4_2 , inputs5_2 , inputs6_2 , inputs7_2 , inputs8_2 , inputs9_2 , inputs10_2 , inputs11_2 , inputs12_2 , inputs13_2 , inputs14_2 , inputs15_2 , inputs16_2 , inputs17_2 , inputs18_2 , inputs19_2 , inputs20_2 , inputs21_2 , inputs22_2 , inputs23_2 , inputs24_2 , inputs25_2 , inputs26_2 , inputs27_2 , inputs28_2 , inputs29_2 , inputs30_2 , inputs31_2,
    input [31:0] w1_0_2, w1_1_2, w2_0_2, w2_1_2, w3_0_2, w3_1_2, w4_0_2, w4_1_2,
    input [7:0] b1_2, b2_2, b3_2, b4_2,
    output [8:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar
);
    wire [2:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [2:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [2:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [2:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [2:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [2:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [2:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [2:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [2:0] weighted_inputs1_8_0, weighted_inputs1_8_1;
    wire [2:0] weighted_inputs1_9_0, weighted_inputs1_9_1;
    wire [2:0] weighted_inputs1_10_0, weighted_inputs1_10_1;
    wire [2:0] weighted_inputs1_11_0, weighted_inputs1_11_1;
    wire [2:0] weighted_inputs1_12_0, weighted_inputs1_12_1;
    wire [2:0] weighted_inputs1_13_0, weighted_inputs1_13_1;
    wire [2:0] weighted_inputs1_14_0, weighted_inputs1_14_1;
    wire [2:0] weighted_inputs1_15_0, weighted_inputs1_15_1;
    wire [2:0] weighted_inputs1_16_0, weighted_inputs1_16_1;
    wire [2:0] weighted_inputs1_17_0, weighted_inputs1_17_1;
    wire [2:0] weighted_inputs1_18_0, weighted_inputs1_18_1;
    wire [2:0] weighted_inputs1_19_0, weighted_inputs1_19_1;
    wire [2:0] weighted_inputs1_20_0, weighted_inputs1_20_1;
    wire [2:0] weighted_inputs1_21_0, weighted_inputs1_21_1;
    wire [2:0] weighted_inputs1_22_0, weighted_inputs1_22_1;
    wire [2:0] weighted_inputs1_23_0, weighted_inputs1_23_1;
    wire [2:0] weighted_inputs1_24_0, weighted_inputs1_24_1;
    wire [2:0] weighted_inputs1_25_0, weighted_inputs1_25_1;
    wire [2:0] weighted_inputs1_26_0, weighted_inputs1_26_1;
    wire [2:0] weighted_inputs1_27_0, weighted_inputs1_27_1;
    wire [2:0] weighted_inputs1_28_0, weighted_inputs1_28_1;
    wire [2:0] weighted_inputs1_29_0, weighted_inputs1_29_1;
    wire [2:0] weighted_inputs1_30_0, weighted_inputs1_30_1;
    wire [2:0] weighted_inputs1_31_0, weighted_inputs1_31_1;
    wire [2:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [2:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [2:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [2:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [2:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [2:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [2:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [2:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [2:0] weighted_inputs2_8_0, weighted_inputs2_8_1;
    wire [2:0] weighted_inputs2_9_0, weighted_inputs2_9_1;
    wire [2:0] weighted_inputs2_10_0, weighted_inputs2_10_1;
    wire [2:0] weighted_inputs2_11_0, weighted_inputs2_11_1;
    wire [2:0] weighted_inputs2_12_0, weighted_inputs2_12_1;
    wire [2:0] weighted_inputs2_13_0, weighted_inputs2_13_1;
    wire [2:0] weighted_inputs2_14_0, weighted_inputs2_14_1;
    wire [2:0] weighted_inputs2_15_0, weighted_inputs2_15_1;
    wire [2:0] weighted_inputs2_16_0, weighted_inputs2_16_1;
    wire [2:0] weighted_inputs2_17_0, weighted_inputs2_17_1;
    wire [2:0] weighted_inputs2_18_0, weighted_inputs2_18_1;
    wire [2:0] weighted_inputs2_19_0, weighted_inputs2_19_1;
    wire [2:0] weighted_inputs2_20_0, weighted_inputs2_20_1;
    wire [2:0] weighted_inputs2_21_0, weighted_inputs2_21_1;
    wire [2:0] weighted_inputs2_22_0, weighted_inputs2_22_1;
    wire [2:0] weighted_inputs2_23_0, weighted_inputs2_23_1;
    wire [2:0] weighted_inputs2_24_0, weighted_inputs2_24_1;
    wire [2:0] weighted_inputs2_25_0, weighted_inputs2_25_1;
    wire [2:0] weighted_inputs2_26_0, weighted_inputs2_26_1;
    wire [2:0] weighted_inputs2_27_0, weighted_inputs2_27_1;
    wire [2:0] weighted_inputs2_28_0, weighted_inputs2_28_1;
    wire [2:0] weighted_inputs2_29_0, weighted_inputs2_29_1;
    wire [2:0] weighted_inputs2_30_0, weighted_inputs2_30_1;
    wire [2:0] weighted_inputs2_31_0, weighted_inputs2_31_1;
    wire [2:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [2:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [2:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [2:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [2:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [2:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [2:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [2:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [2:0] weighted_inputs3_8_0, weighted_inputs3_8_1;
    wire [2:0] weighted_inputs3_9_0, weighted_inputs3_9_1;
    wire [2:0] weighted_inputs3_10_0, weighted_inputs3_10_1;
    wire [2:0] weighted_inputs3_11_0, weighted_inputs3_11_1;
    wire [2:0] weighted_inputs3_12_0, weighted_inputs3_12_1;
    wire [2:0] weighted_inputs3_13_0, weighted_inputs3_13_1;
    wire [2:0] weighted_inputs3_14_0, weighted_inputs3_14_1;
    wire [2:0] weighted_inputs3_15_0, weighted_inputs3_15_1;
    wire [2:0] weighted_inputs3_16_0, weighted_inputs3_16_1;
    wire [2:0] weighted_inputs3_17_0, weighted_inputs3_17_1;
    wire [2:0] weighted_inputs3_18_0, weighted_inputs3_18_1;
    wire [2:0] weighted_inputs3_19_0, weighted_inputs3_19_1;
    wire [2:0] weighted_inputs3_20_0, weighted_inputs3_20_1;
    wire [2:0] weighted_inputs3_21_0, weighted_inputs3_21_1;
    wire [2:0] weighted_inputs3_22_0, weighted_inputs3_22_1;
    wire [2:0] weighted_inputs3_23_0, weighted_inputs3_23_1;
    wire [2:0] weighted_inputs3_24_0, weighted_inputs3_24_1;
    wire [2:0] weighted_inputs3_25_0, weighted_inputs3_25_1;
    wire [2:0] weighted_inputs3_26_0, weighted_inputs3_26_1;
    wire [2:0] weighted_inputs3_27_0, weighted_inputs3_27_1;
    wire [2:0] weighted_inputs3_28_0, weighted_inputs3_28_1;
    wire [2:0] weighted_inputs3_29_0, weighted_inputs3_29_1;
    wire [2:0] weighted_inputs3_30_0, weighted_inputs3_30_1;
    wire [2:0] weighted_inputs3_31_0, weighted_inputs3_31_1;
    wire [2:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [2:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [2:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [2:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [2:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [2:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [2:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [2:0] weighted_inputs4_7_0, weighted_inputs4_7_1;
    wire [2:0] weighted_inputs4_8_0, weighted_inputs4_8_1;
    wire [2:0] weighted_inputs4_9_0, weighted_inputs4_9_1;
    wire [2:0] weighted_inputs4_10_0, weighted_inputs4_10_1;
    wire [2:0] weighted_inputs4_11_0, weighted_inputs4_11_1;
    wire [2:0] weighted_inputs4_12_0, weighted_inputs4_12_1;
    wire [2:0] weighted_inputs4_13_0, weighted_inputs4_13_1;
    wire [2:0] weighted_inputs4_14_0, weighted_inputs4_14_1;
    wire [2:0] weighted_inputs4_15_0, weighted_inputs4_15_1;
    wire [2:0] weighted_inputs4_16_0, weighted_inputs4_16_1;
    wire [2:0] weighted_inputs4_17_0, weighted_inputs4_17_1;
    wire [2:0] weighted_inputs4_18_0, weighted_inputs4_18_1;
    wire [2:0] weighted_inputs4_19_0, weighted_inputs4_19_1;
    wire [2:0] weighted_inputs4_20_0, weighted_inputs4_20_1;
    wire [2:0] weighted_inputs4_21_0, weighted_inputs4_21_1;
    wire [2:0] weighted_inputs4_22_0, weighted_inputs4_22_1;
    wire [2:0] weighted_inputs4_23_0, weighted_inputs4_23_1;
    wire [2:0] weighted_inputs4_24_0, weighted_inputs4_24_1;
    wire [2:0] weighted_inputs4_25_0, weighted_inputs4_25_1;
    wire [2:0] weighted_inputs4_26_0, weighted_inputs4_26_1;
    wire [2:0] weighted_inputs4_27_0, weighted_inputs4_27_1;
    wire [2:0] weighted_inputs4_28_0, weighted_inputs4_28_1;
    wire [2:0] weighted_inputs4_29_0, weighted_inputs4_29_1;
    wire [2:0] weighted_inputs4_30_0, weighted_inputs4_30_1;
    wire [2:0] weighted_inputs4_31_0, weighted_inputs4_31_1;

    wire [7:0] sum1 [3:0];
    wire [7:0] sum2 [3:0];
    wire [8:0] biased_sum1 [3:0];
    wire [8:0] biased_sum2 [3:0];
    wire [7:0] sum1bar [3:0];
    wire [7:0] sum2bar [3:0];
    wire [8:0] biased_sum1bar [3:0];
    wire [8:0] biased_sum2bar [3:0];
    weighted_inputs_1 w0 (.inputs(inputs0_2), .w(w1_0_2[0]), .wi(weighted_inputs1_0_0));
    weighted_inputs_1 w0_bar (.inputs(inputs0_2), .w(w1_1_2[0]), .wi(weighted_inputs1_0_1));
    weighted_inputs_1 w1 (.inputs(inputs1_2), .w(w1_0_2[1]), .wi(weighted_inputs1_1_0));
    weighted_inputs_1 w1_bar (.inputs(inputs1_2), .w(w1_1_2[1]), .wi(weighted_inputs1_1_1));
    weighted_inputs_1 w2 (.inputs(inputs2_2), .w(w1_0_2[2]), .wi(weighted_inputs1_2_0));
    weighted_inputs_1 w2_bar (.inputs(inputs2_2), .w(w1_1_2[2]), .wi(weighted_inputs1_2_1));
    weighted_inputs_1 w3 (.inputs(inputs3_2), .w(w1_0_2[3]), .wi(weighted_inputs1_3_0));
    weighted_inputs_1 w3_bar (.inputs(inputs3_2), .w(w1_1_2[3]), .wi(weighted_inputs1_3_1));
    weighted_inputs_1 w4 (.inputs(inputs4_2), .w(w1_0_2[4]), .wi(weighted_inputs1_4_0));
    weighted_inputs_1 w4_bar (.inputs(inputs4_2), .w(w1_1_2[4]), .wi(weighted_inputs1_4_1));
    weighted_inputs_1 w5 (.inputs(inputs5_2), .w(w1_0_2[5]), .wi(weighted_inputs1_5_0));
    weighted_inputs_1 w5_bar (.inputs(inputs5_2), .w(w1_1_2[5]), .wi(weighted_inputs1_5_1));
    weighted_inputs_1 w6 (.inputs(inputs6_2), .w(w1_0_2[6]), .wi(weighted_inputs1_6_0));
    weighted_inputs_1 w6_bar (.inputs(inputs6_2), .w(w1_1_2[6]), .wi(weighted_inputs1_6_1));
    weighted_inputs_1 w7 (.inputs(inputs7_2), .w(w1_0_2[7]), .wi(weighted_inputs1_7_0));
    weighted_inputs_1 w7_bar (.inputs(inputs7_2), .w(w1_1_2[7]), .wi(weighted_inputs1_7_1));
    weighted_inputs_1 w8 (.inputs(inputs8_2), .w(w1_0_2[8]), .wi(weighted_inputs1_8_0));
    weighted_inputs_1 w8_bar (.inputs(inputs8_2), .w(w1_1_2[8]), .wi(weighted_inputs1_8_1));
    weighted_inputs_1 w9 (.inputs(inputs9_2), .w(w1_0_2[9]), .wi(weighted_inputs1_9_0));
    weighted_inputs_1 w9_bar (.inputs(inputs9_2), .w(w1_1_2[9]), .wi(weighted_inputs1_9_1));
    weighted_inputs_1 w10 (.inputs(inputs10_2), .w(w1_0_2[10]), .wi(weighted_inputs1_10_0));
    weighted_inputs_1 w10_bar (.inputs(inputs10_2), .w(w1_1_2[10]), .wi(weighted_inputs1_10_1));
    weighted_inputs_1 w11 (.inputs(inputs11_2), .w(w1_0_2[11]), .wi(weighted_inputs1_11_0));
    weighted_inputs_1 w11_bar (.inputs(inputs11_2), .w(w1_1_2[11]), .wi(weighted_inputs1_11_1));
    weighted_inputs_1 w12 (.inputs(inputs12_2), .w(w1_0_2[12]), .wi(weighted_inputs1_12_0));
    weighted_inputs_1 w12_bar (.inputs(inputs12_2), .w(w1_1_2[12]), .wi(weighted_inputs1_12_1));
    weighted_inputs_1 w13 (.inputs(inputs13_2), .w(w1_0_2[13]), .wi(weighted_inputs1_13_0));
    weighted_inputs_1 w13_bar (.inputs(inputs13_2), .w(w1_1_2[13]), .wi(weighted_inputs1_13_1));
    weighted_inputs_1 w14 (.inputs(inputs14_2), .w(w1_0_2[14]), .wi(weighted_inputs1_14_0));
    weighted_inputs_1 w14_bar (.inputs(inputs14_2), .w(w1_1_2[14]), .wi(weighted_inputs1_14_1));
    weighted_inputs_1 w15 (.inputs(inputs15_2), .w(w1_0_2[15]), .wi(weighted_inputs1_15_0));
    weighted_inputs_1 w15_bar (.inputs(inputs15_2), .w(w1_1_2[15]), .wi(weighted_inputs1_15_1));
    weighted_inputs_1 w16 (.inputs(inputs16_2), .w(w1_0_2[16]), .wi(weighted_inputs1_16_0));
    weighted_inputs_1 w16_bar (.inputs(inputs16_2), .w(w1_1_2[16]), .wi(weighted_inputs1_16_1));
    weighted_inputs_1 w17 (.inputs(inputs17_2), .w(w1_0_2[17]), .wi(weighted_inputs1_17_0));
    weighted_inputs_1 w17_bar (.inputs(inputs17_2), .w(w1_1_2[17]), .wi(weighted_inputs1_17_1));
    weighted_inputs_1 w18 (.inputs(inputs18_2), .w(w1_0_2[18]), .wi(weighted_inputs1_18_0));
    weighted_inputs_1 w18_bar (.inputs(inputs18_2), .w(w1_1_2[18]), .wi(weighted_inputs1_18_1));
    weighted_inputs_1 w19 (.inputs(inputs19_2), .w(w1_0_2[19]), .wi(weighted_inputs1_19_0));
    weighted_inputs_1 w19_bar (.inputs(inputs19_2), .w(w1_1_2[19]), .wi(weighted_inputs1_19_1));
    weighted_inputs_1 w20 (.inputs(inputs20_2), .w(w1_0_2[20]), .wi(weighted_inputs1_20_0));
    weighted_inputs_1 w20_bar (.inputs(inputs20_2), .w(w1_1_2[20]), .wi(weighted_inputs1_20_1));
    weighted_inputs_1 w21 (.inputs(inputs21_2), .w(w1_0_2[21]), .wi(weighted_inputs1_21_0));
    weighted_inputs_1 w21_bar (.inputs(inputs21_2), .w(w1_1_2[21]), .wi(weighted_inputs1_21_1));
    weighted_inputs_1 w22 (.inputs(inputs22_2), .w(w1_0_2[22]), .wi(weighted_inputs1_22_0));
    weighted_inputs_1 w22_bar (.inputs(inputs22_2), .w(w1_1_2[22]), .wi(weighted_inputs1_22_1));
    weighted_inputs_1 w23 (.inputs(inputs23_2), .w(w1_0_2[23]), .wi(weighted_inputs1_23_0));
    weighted_inputs_1 w23_bar (.inputs(inputs23_2), .w(w1_1_2[23]), .wi(weighted_inputs1_23_1));
    weighted_inputs_1 w24 (.inputs(inputs24_2), .w(w1_0_2[24]), .wi(weighted_inputs1_24_0));
    weighted_inputs_1 w24_bar (.inputs(inputs24_2), .w(w1_1_2[24]), .wi(weighted_inputs1_24_1));
    weighted_inputs_1 w25 (.inputs(inputs25_2), .w(w1_0_2[25]), .wi(weighted_inputs1_25_0));
    weighted_inputs_1 w25_bar (.inputs(inputs25_2), .w(w1_1_2[25]), .wi(weighted_inputs1_25_1));
    weighted_inputs_1 w26 (.inputs(inputs26_2), .w(w1_0_2[26]), .wi(weighted_inputs1_26_0));
    weighted_inputs_1 w26_bar (.inputs(inputs26_2), .w(w1_1_2[26]), .wi(weighted_inputs1_26_1));
    weighted_inputs_1 w27 (.inputs(inputs27_2), .w(w1_0_2[27]), .wi(weighted_inputs1_27_0));
    weighted_inputs_1 w27_bar (.inputs(inputs27_2), .w(w1_1_2[27]), .wi(weighted_inputs1_27_1));
    weighted_inputs_1 w28 (.inputs(inputs28_2), .w(w1_0_2[28]), .wi(weighted_inputs1_28_0));
    weighted_inputs_1 w28_bar (.inputs(inputs28_2), .w(w1_1_2[28]), .wi(weighted_inputs1_28_1));
    weighted_inputs_1 w29 (.inputs(inputs29_2), .w(w1_0_2[29]), .wi(weighted_inputs1_29_0));
    weighted_inputs_1 w29_bar (.inputs(inputs29_2), .w(w1_1_2[29]), .wi(weighted_inputs1_29_1));
    weighted_inputs_1 w30 (.inputs(inputs30_2), .w(w1_0_2[30]), .wi(weighted_inputs1_30_0));
    weighted_inputs_1 w30_bar (.inputs(inputs30_2), .w(w1_1_2[30]), .wi(weighted_inputs1_30_1));
    weighted_inputs_1 w31 (.inputs(inputs31_2), .w(w1_0_2[31]), .wi(weighted_inputs1_31_0));
    weighted_inputs_1 w31_bar (.inputs(inputs31_2), .w(w1_1_2[31]), .wi(weighted_inputs1_31_1));
    weighted_inputs_1 w32 (.inputs(inputs0_2), .w(w2_0_2[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_1 w32_bar (.inputs(inputs0_2), .w(w2_1_2[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_1 w33 (.inputs(inputs1_2), .w(w2_0_2[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_1 w33_bar (.inputs(inputs1_2), .w(w2_1_2[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_1 w34 (.inputs(inputs2_2), .w(w2_0_2[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_1 w34_bar (.inputs(inputs2_2), .w(w2_1_2[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_1 w35 (.inputs(inputs3_2), .w(w2_0_2[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_1 w35_bar (.inputs(inputs3_2), .w(w2_1_2[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_1 w36 (.inputs(inputs4_2), .w(w2_0_2[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_1 w36_bar (.inputs(inputs4_2), .w(w2_1_2[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_1 w37 (.inputs(inputs5_2), .w(w2_0_2[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_1 w37_bar (.inputs(inputs5_2), .w(w2_1_2[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_1 w38 (.inputs(inputs6_2), .w(w2_0_2[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_1 w38_bar (.inputs(inputs6_2), .w(w2_1_2[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_1 w39 (.inputs(inputs7_2), .w(w2_0_2[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_1 w39_bar (.inputs(inputs7_2), .w(w2_1_2[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_1 w40 (.inputs(inputs8_2), .w(w2_0_2[8]), .wi(weighted_inputs2_8_0));
    weighted_inputs_1 w40_bar (.inputs(inputs8_2), .w(w2_1_2[8]), .wi(weighted_inputs2_8_1));
    weighted_inputs_1 w41 (.inputs(inputs9_2), .w(w2_0_2[9]), .wi(weighted_inputs2_9_0));
    weighted_inputs_1 w41_bar (.inputs(inputs9_2), .w(w2_1_2[9]), .wi(weighted_inputs2_9_1));
    weighted_inputs_1 w42 (.inputs(inputs10_2), .w(w2_0_2[10]), .wi(weighted_inputs2_10_0));
    weighted_inputs_1 w42_bar (.inputs(inputs10_2), .w(w2_1_2[10]), .wi(weighted_inputs2_10_1));
    weighted_inputs_1 w43 (.inputs(inputs11_2), .w(w2_0_2[11]), .wi(weighted_inputs2_11_0));
    weighted_inputs_1 w43_bar (.inputs(inputs11_2), .w(w2_1_2[11]), .wi(weighted_inputs2_11_1));
    weighted_inputs_1 w44 (.inputs(inputs12_2), .w(w2_0_2[12]), .wi(weighted_inputs2_12_0));
    weighted_inputs_1 w44_bar (.inputs(inputs12_2), .w(w2_1_2[12]), .wi(weighted_inputs2_12_1));
    weighted_inputs_1 w45 (.inputs(inputs13_2), .w(w2_0_2[13]), .wi(weighted_inputs2_13_0));
    weighted_inputs_1 w45_bar (.inputs(inputs13_2), .w(w2_1_2[13]), .wi(weighted_inputs2_13_1));
    weighted_inputs_1 w46 (.inputs(inputs14_2), .w(w2_0_2[14]), .wi(weighted_inputs2_14_0));
    weighted_inputs_1 w46_bar (.inputs(inputs14_2), .w(w2_1_2[14]), .wi(weighted_inputs2_14_1));
    weighted_inputs_1 w47 (.inputs(inputs15_2), .w(w2_0_2[15]), .wi(weighted_inputs2_15_0));
    weighted_inputs_1 w47_bar (.inputs(inputs15_2), .w(w2_1_2[15]), .wi(weighted_inputs2_15_1));
    weighted_inputs_1 w48 (.inputs(inputs16_2), .w(w2_0_2[16]), .wi(weighted_inputs2_16_0));
    weighted_inputs_1 w48_bar (.inputs(inputs16_2), .w(w2_1_2[16]), .wi(weighted_inputs2_16_1));
    weighted_inputs_1 w49 (.inputs(inputs17_2), .w(w2_0_2[17]), .wi(weighted_inputs2_17_0));
    weighted_inputs_1 w49_bar (.inputs(inputs17_2), .w(w2_1_2[17]), .wi(weighted_inputs2_17_1));
    weighted_inputs_1 w50 (.inputs(inputs18_2), .w(w2_0_2[18]), .wi(weighted_inputs2_18_0));
    weighted_inputs_1 w50_bar (.inputs(inputs18_2), .w(w2_1_2[18]), .wi(weighted_inputs2_18_1));
    weighted_inputs_1 w51 (.inputs(inputs19_2), .w(w2_0_2[19]), .wi(weighted_inputs2_19_0));
    weighted_inputs_1 w51_bar (.inputs(inputs19_2), .w(w2_1_2[19]), .wi(weighted_inputs2_19_1));
    weighted_inputs_1 w52 (.inputs(inputs20_2), .w(w2_0_2[20]), .wi(weighted_inputs2_20_0));
    weighted_inputs_1 w52_bar (.inputs(inputs20_2), .w(w2_1_2[20]), .wi(weighted_inputs2_20_1));
    weighted_inputs_1 w53 (.inputs(inputs21_2), .w(w2_0_2[21]), .wi(weighted_inputs2_21_0));
    weighted_inputs_1 w53_bar (.inputs(inputs21_2), .w(w2_1_2[21]), .wi(weighted_inputs2_21_1));
    weighted_inputs_1 w54 (.inputs(inputs22_2), .w(w2_0_2[22]), .wi(weighted_inputs2_22_0));
    weighted_inputs_1 w54_bar (.inputs(inputs22_2), .w(w2_1_2[22]), .wi(weighted_inputs2_22_1));
    weighted_inputs_1 w55 (.inputs(inputs23_2), .w(w2_0_2[23]), .wi(weighted_inputs2_23_0));
    weighted_inputs_1 w55_bar (.inputs(inputs23_2), .w(w2_1_2[23]), .wi(weighted_inputs2_23_1));
    weighted_inputs_1 w56 (.inputs(inputs24_2), .w(w2_0_2[24]), .wi(weighted_inputs2_24_0));
    weighted_inputs_1 w56_bar (.inputs(inputs24_2), .w(w2_1_2[24]), .wi(weighted_inputs2_24_1));
    weighted_inputs_1 w57 (.inputs(inputs25_2), .w(w2_0_2[25]), .wi(weighted_inputs2_25_0));
    weighted_inputs_1 w57_bar (.inputs(inputs25_2), .w(w2_1_2[25]), .wi(weighted_inputs2_25_1));
    weighted_inputs_1 w58 (.inputs(inputs26_2), .w(w2_0_2[26]), .wi(weighted_inputs2_26_0));
    weighted_inputs_1 w58_bar (.inputs(inputs26_2), .w(w2_1_2[26]), .wi(weighted_inputs2_26_1));
    weighted_inputs_1 w59 (.inputs(inputs27_2), .w(w2_0_2[27]), .wi(weighted_inputs2_27_0));
    weighted_inputs_1 w59_bar (.inputs(inputs27_2), .w(w2_1_2[27]), .wi(weighted_inputs2_27_1));
    weighted_inputs_1 w60 (.inputs(inputs28_2), .w(w2_0_2[28]), .wi(weighted_inputs2_28_0));
    weighted_inputs_1 w60_bar (.inputs(inputs28_2), .w(w2_1_2[28]), .wi(weighted_inputs2_28_1));
    weighted_inputs_1 w61 (.inputs(inputs29_2), .w(w2_0_2[29]), .wi(weighted_inputs2_29_0));
    weighted_inputs_1 w61_bar (.inputs(inputs29_2), .w(w2_1_2[29]), .wi(weighted_inputs2_29_1));
    weighted_inputs_1 w62 (.inputs(inputs30_2), .w(w2_0_2[30]), .wi(weighted_inputs2_30_0));
    weighted_inputs_1 w62_bar (.inputs(inputs30_2), .w(w2_1_2[30]), .wi(weighted_inputs2_30_1));
    weighted_inputs_1 w63 (.inputs(inputs31_2), .w(w2_0_2[31]), .wi(weighted_inputs2_31_0));
    weighted_inputs_1 w63_bar (.inputs(inputs31_2), .w(w2_1_2[31]), .wi(weighted_inputs2_31_1));
    weighted_inputs_1 w64 (.inputs(inputs0_2), .w(w3_0_2[0]), .wi(weighted_inputs3_0_0));
    weighted_inputs_1 w64_bar (.inputs(inputs0_2), .w(w3_1_2[0]), .wi(weighted_inputs3_0_1));
    weighted_inputs_1 w65 (.inputs(inputs1_2), .w(w3_0_2[1]), .wi(weighted_inputs3_1_0));
    weighted_inputs_1 w65_bar (.inputs(inputs1_2), .w(w3_1_2[1]), .wi(weighted_inputs3_1_1));
    weighted_inputs_1 w66 (.inputs(inputs2_2), .w(w3_0_2[2]), .wi(weighted_inputs3_2_0));
    weighted_inputs_1 w66_bar (.inputs(inputs2_2), .w(w3_1_2[2]), .wi(weighted_inputs3_2_1));
    weighted_inputs_1 w67 (.inputs(inputs3_2), .w(w3_0_2[3]), .wi(weighted_inputs3_3_0));
    weighted_inputs_1 w67_bar (.inputs(inputs3_2), .w(w3_1_2[3]), .wi(weighted_inputs3_3_1));
    weighted_inputs_1 w68 (.inputs(inputs4_2), .w(w3_0_2[4]), .wi(weighted_inputs3_4_0));
    weighted_inputs_1 w68_bar (.inputs(inputs4_2), .w(w3_1_2[4]), .wi(weighted_inputs3_4_1));
    weighted_inputs_1 w69 (.inputs(inputs5_2), .w(w3_0_2[5]), .wi(weighted_inputs3_5_0));
    weighted_inputs_1 w69_bar (.inputs(inputs5_2), .w(w3_1_2[5]), .wi(weighted_inputs3_5_1));
    weighted_inputs_1 w70 (.inputs(inputs6_2), .w(w3_0_2[6]), .wi(weighted_inputs3_6_0));
    weighted_inputs_1 w70_bar (.inputs(inputs6_2), .w(w3_1_2[6]), .wi(weighted_inputs3_6_1));
    weighted_inputs_1 w71 (.inputs(inputs7_2), .w(w3_0_2[7]), .wi(weighted_inputs3_7_0));
    weighted_inputs_1 w71_bar (.inputs(inputs7_2), .w(w3_1_2[7]), .wi(weighted_inputs3_7_1));
    weighted_inputs_1 w72 (.inputs(inputs8_2), .w(w3_0_2[8]), .wi(weighted_inputs3_8_0));
    weighted_inputs_1 w72_bar (.inputs(inputs8_2), .w(w3_1_2[8]), .wi(weighted_inputs3_8_1));
    weighted_inputs_1 w73 (.inputs(inputs9_2), .w(w3_0_2[9]), .wi(weighted_inputs3_9_0));
    weighted_inputs_1 w73_bar (.inputs(inputs9_2), .w(w3_1_2[9]), .wi(weighted_inputs3_9_1));
    weighted_inputs_1 w74 (.inputs(inputs10_2), .w(w3_0_2[10]), .wi(weighted_inputs3_10_0));
    weighted_inputs_1 w74_bar (.inputs(inputs10_2), .w(w3_1_2[10]), .wi(weighted_inputs3_10_1));
    weighted_inputs_1 w75 (.inputs(inputs11_2), .w(w3_0_2[11]), .wi(weighted_inputs3_11_0));
    weighted_inputs_1 w75_bar (.inputs(inputs11_2), .w(w3_1_2[11]), .wi(weighted_inputs3_11_1));
    weighted_inputs_1 w76 (.inputs(inputs12_2), .w(w3_0_2[12]), .wi(weighted_inputs3_12_0));
    weighted_inputs_1 w76_bar (.inputs(inputs12_2), .w(w3_1_2[12]), .wi(weighted_inputs3_12_1));
    weighted_inputs_1 w77 (.inputs(inputs13_2), .w(w3_0_2[13]), .wi(weighted_inputs3_13_0));
    weighted_inputs_1 w77_bar (.inputs(inputs13_2), .w(w3_1_2[13]), .wi(weighted_inputs3_13_1));
    weighted_inputs_1 w78 (.inputs(inputs14_2), .w(w3_0_2[14]), .wi(weighted_inputs3_14_0));
    weighted_inputs_1 w78_bar (.inputs(inputs14_2), .w(w3_1_2[14]), .wi(weighted_inputs3_14_1));
    weighted_inputs_1 w79 (.inputs(inputs15_2), .w(w3_0_2[15]), .wi(weighted_inputs3_15_0));
    weighted_inputs_1 w79_bar (.inputs(inputs15_2), .w(w3_1_2[15]), .wi(weighted_inputs3_15_1));
    weighted_inputs_1 w80 (.inputs(inputs16_2), .w(w3_0_2[16]), .wi(weighted_inputs3_16_0));
    weighted_inputs_1 w80_bar (.inputs(inputs16_2), .w(w3_1_2[16]), .wi(weighted_inputs3_16_1));
    weighted_inputs_1 w81 (.inputs(inputs17_2), .w(w3_0_2[17]), .wi(weighted_inputs3_17_0));
    weighted_inputs_1 w81_bar (.inputs(inputs17_2), .w(w3_1_2[17]), .wi(weighted_inputs3_17_1));
    weighted_inputs_1 w82 (.inputs(inputs18_2), .w(w3_0_2[18]), .wi(weighted_inputs3_18_0));
    weighted_inputs_1 w82_bar (.inputs(inputs18_2), .w(w3_1_2[18]), .wi(weighted_inputs3_18_1));
    weighted_inputs_1 w83 (.inputs(inputs19_2), .w(w3_0_2[19]), .wi(weighted_inputs3_19_0));
    weighted_inputs_1 w83_bar (.inputs(inputs19_2), .w(w3_1_2[19]), .wi(weighted_inputs3_19_1));
    weighted_inputs_1 w84 (.inputs(inputs20_2), .w(w3_0_2[20]), .wi(weighted_inputs3_20_0));
    weighted_inputs_1 w84_bar (.inputs(inputs20_2), .w(w3_1_2[20]), .wi(weighted_inputs3_20_1));
    weighted_inputs_1 w85 (.inputs(inputs21_2), .w(w3_0_2[21]), .wi(weighted_inputs3_21_0));
    weighted_inputs_1 w85_bar (.inputs(inputs21_2), .w(w3_1_2[21]), .wi(weighted_inputs3_21_1));
    weighted_inputs_1 w86 (.inputs(inputs22_2), .w(w3_0_2[22]), .wi(weighted_inputs3_22_0));
    weighted_inputs_1 w86_bar (.inputs(inputs22_2), .w(w3_1_2[22]), .wi(weighted_inputs3_22_1));
    weighted_inputs_1 w87 (.inputs(inputs23_2), .w(w3_0_2[23]), .wi(weighted_inputs3_23_0));
    weighted_inputs_1 w87_bar (.inputs(inputs23_2), .w(w3_1_2[23]), .wi(weighted_inputs3_23_1));
    weighted_inputs_1 w88 (.inputs(inputs24_2), .w(w3_0_2[24]), .wi(weighted_inputs3_24_0));
    weighted_inputs_1 w88_bar (.inputs(inputs24_2), .w(w3_1_2[24]), .wi(weighted_inputs3_24_1));
    weighted_inputs_1 w89 (.inputs(inputs25_2), .w(w3_0_2[25]), .wi(weighted_inputs3_25_0));
    weighted_inputs_1 w89_bar (.inputs(inputs25_2), .w(w3_1_2[25]), .wi(weighted_inputs3_25_1));
    weighted_inputs_1 w90 (.inputs(inputs26_2), .w(w3_0_2[26]), .wi(weighted_inputs3_26_0));
    weighted_inputs_1 w90_bar (.inputs(inputs26_2), .w(w3_1_2[26]), .wi(weighted_inputs3_26_1));
    weighted_inputs_1 w91 (.inputs(inputs27_2), .w(w3_0_2[27]), .wi(weighted_inputs3_27_0));
    weighted_inputs_1 w91_bar (.inputs(inputs27_2), .w(w3_1_2[27]), .wi(weighted_inputs3_27_1));
    weighted_inputs_1 w92 (.inputs(inputs28_2), .w(w3_0_2[28]), .wi(weighted_inputs3_28_0));
    weighted_inputs_1 w92_bar (.inputs(inputs28_2), .w(w3_1_2[28]), .wi(weighted_inputs3_28_1));
    weighted_inputs_1 w93 (.inputs(inputs29_2), .w(w3_0_2[29]), .wi(weighted_inputs3_29_0));
    weighted_inputs_1 w93_bar (.inputs(inputs29_2), .w(w3_1_2[29]), .wi(weighted_inputs3_29_1));
    weighted_inputs_1 w94 (.inputs(inputs30_2), .w(w3_0_2[30]), .wi(weighted_inputs3_30_0));
    weighted_inputs_1 w94_bar (.inputs(inputs30_2), .w(w3_1_2[30]), .wi(weighted_inputs3_30_1));
    weighted_inputs_1 w95 (.inputs(inputs31_2), .w(w3_0_2[31]), .wi(weighted_inputs3_31_0));
    weighted_inputs_1 w95_bar (.inputs(inputs31_2), .w(w3_1_2[31]), .wi(weighted_inputs3_31_1));
    weighted_inputs_1 w96 (.inputs(inputs0_2), .w(w4_0_2[0]), .wi(weighted_inputs4_0_0));
    weighted_inputs_1 w96_bar (.inputs(inputs0_2), .w(w4_1_2[0]), .wi(weighted_inputs4_0_1));
    weighted_inputs_1 w97 (.inputs(inputs1_2), .w(w4_0_2[1]), .wi(weighted_inputs4_1_0));
    weighted_inputs_1 w97_bar (.inputs(inputs1_2), .w(w4_1_2[1]), .wi(weighted_inputs4_1_1));
    weighted_inputs_1 w98 (.inputs(inputs2_2), .w(w4_0_2[2]), .wi(weighted_inputs4_2_0));
    weighted_inputs_1 w98_bar (.inputs(inputs2_2), .w(w4_1_2[2]), .wi(weighted_inputs4_2_1));
    weighted_inputs_1 w99 (.inputs(inputs3_2), .w(w4_0_2[3]), .wi(weighted_inputs4_3_0));
    weighted_inputs_1 w99_bar (.inputs(inputs3_2), .w(w4_1_2[3]), .wi(weighted_inputs4_3_1));
    weighted_inputs_1 w100 (.inputs(inputs4_2), .w(w4_0_2[4]), .wi(weighted_inputs4_4_0));
    weighted_inputs_1 w100_bar (.inputs(inputs4_2), .w(w4_1_2[4]), .wi(weighted_inputs4_4_1));
    weighted_inputs_1 w101 (.inputs(inputs5_2), .w(w4_0_2[5]), .wi(weighted_inputs4_5_0));
    weighted_inputs_1 w101_bar (.inputs(inputs5_2), .w(w4_1_2[5]), .wi(weighted_inputs4_5_1));
    weighted_inputs_1 w102 (.inputs(inputs6_2), .w(w4_0_2[6]), .wi(weighted_inputs4_6_0));
    weighted_inputs_1 w102_bar (.inputs(inputs6_2), .w(w4_1_2[6]), .wi(weighted_inputs4_6_1));
    weighted_inputs_1 w103 (.inputs(inputs7_2), .w(w4_0_2[7]), .wi(weighted_inputs4_7_0));
    weighted_inputs_1 w103_bar (.inputs(inputs7_2), .w(w4_1_2[7]), .wi(weighted_inputs4_7_1));
    weighted_inputs_1 w104 (.inputs(inputs8_2), .w(w4_0_2[8]), .wi(weighted_inputs4_8_0));
    weighted_inputs_1 w104_bar (.inputs(inputs8_2), .w(w4_1_2[8]), .wi(weighted_inputs4_8_1));
    weighted_inputs_1 w105 (.inputs(inputs9_2), .w(w4_0_2[9]), .wi(weighted_inputs4_9_0));
    weighted_inputs_1 w105_bar (.inputs(inputs9_2), .w(w4_1_2[9]), .wi(weighted_inputs4_9_1));
    weighted_inputs_1 w106 (.inputs(inputs10_2), .w(w4_0_2[10]), .wi(weighted_inputs4_10_0));
    weighted_inputs_1 w106_bar (.inputs(inputs10_2), .w(w4_1_2[10]), .wi(weighted_inputs4_10_1));
    weighted_inputs_1 w107 (.inputs(inputs11_2), .w(w4_0_2[11]), .wi(weighted_inputs4_11_0));
    weighted_inputs_1 w107_bar (.inputs(inputs11_2), .w(w4_1_2[11]), .wi(weighted_inputs4_11_1));
    weighted_inputs_1 w108 (.inputs(inputs12_2), .w(w4_0_2[12]), .wi(weighted_inputs4_12_0));
    weighted_inputs_1 w108_bar (.inputs(inputs12_2), .w(w4_1_2[12]), .wi(weighted_inputs4_12_1));
    weighted_inputs_1 w109 (.inputs(inputs13_2), .w(w4_0_2[13]), .wi(weighted_inputs4_13_0));
    weighted_inputs_1 w109_bar (.inputs(inputs13_2), .w(w4_1_2[13]), .wi(weighted_inputs4_13_1));
    weighted_inputs_1 w110 (.inputs(inputs14_2), .w(w4_0_2[14]), .wi(weighted_inputs4_14_0));
    weighted_inputs_1 w110_bar (.inputs(inputs14_2), .w(w4_1_2[14]), .wi(weighted_inputs4_14_1));
    weighted_inputs_1 w111 (.inputs(inputs15_2), .w(w4_0_2[15]), .wi(weighted_inputs4_15_0));
    weighted_inputs_1 w111_bar (.inputs(inputs15_2), .w(w4_1_2[15]), .wi(weighted_inputs4_15_1));
    weighted_inputs_1 w112 (.inputs(inputs16_2), .w(w4_0_2[16]), .wi(weighted_inputs4_16_0));
    weighted_inputs_1 w112_bar (.inputs(inputs16_2), .w(w4_1_2[16]), .wi(weighted_inputs4_16_1));
    weighted_inputs_1 w113 (.inputs(inputs17_2), .w(w4_0_2[17]), .wi(weighted_inputs4_17_0));
    weighted_inputs_1 w113_bar (.inputs(inputs17_2), .w(w4_1_2[17]), .wi(weighted_inputs4_17_1));
    weighted_inputs_1 w114 (.inputs(inputs18_2), .w(w4_0_2[18]), .wi(weighted_inputs4_18_0));
    weighted_inputs_1 w114_bar (.inputs(inputs18_2), .w(w4_1_2[18]), .wi(weighted_inputs4_18_1));
    weighted_inputs_1 w115 (.inputs(inputs19_2), .w(w4_0_2[19]), .wi(weighted_inputs4_19_0));
    weighted_inputs_1 w115_bar (.inputs(inputs19_2), .w(w4_1_2[19]), .wi(weighted_inputs4_19_1));
    weighted_inputs_1 w116 (.inputs(inputs20_2), .w(w4_0_2[20]), .wi(weighted_inputs4_20_0));
    weighted_inputs_1 w116_bar (.inputs(inputs20_2), .w(w4_1_2[20]), .wi(weighted_inputs4_20_1));
    weighted_inputs_1 w117 (.inputs(inputs21_2), .w(w4_0_2[21]), .wi(weighted_inputs4_21_0));
    weighted_inputs_1 w117_bar (.inputs(inputs21_2), .w(w4_1_2[21]), .wi(weighted_inputs4_21_1));
    weighted_inputs_1 w118 (.inputs(inputs22_2), .w(w4_0_2[22]), .wi(weighted_inputs4_22_0));
    weighted_inputs_1 w118_bar (.inputs(inputs22_2), .w(w4_1_2[22]), .wi(weighted_inputs4_22_1));
    weighted_inputs_1 w119 (.inputs(inputs23_2), .w(w4_0_2[23]), .wi(weighted_inputs4_23_0));
    weighted_inputs_1 w119_bar (.inputs(inputs23_2), .w(w4_1_2[23]), .wi(weighted_inputs4_23_1));
    weighted_inputs_1 w120 (.inputs(inputs24_2), .w(w4_0_2[24]), .wi(weighted_inputs4_24_0));
    weighted_inputs_1 w120_bar (.inputs(inputs24_2), .w(w4_1_2[24]), .wi(weighted_inputs4_24_1));
    weighted_inputs_1 w121 (.inputs(inputs25_2), .w(w4_0_2[25]), .wi(weighted_inputs4_25_0));
    weighted_inputs_1 w121_bar (.inputs(inputs25_2), .w(w4_1_2[25]), .wi(weighted_inputs4_25_1));
    weighted_inputs_1 w122 (.inputs(inputs26_2), .w(w4_0_2[26]), .wi(weighted_inputs4_26_0));
    weighted_inputs_1 w122_bar (.inputs(inputs26_2), .w(w4_1_2[26]), .wi(weighted_inputs4_26_1));
    weighted_inputs_1 w123 (.inputs(inputs27_2), .w(w4_0_2[27]), .wi(weighted_inputs4_27_0));
    weighted_inputs_1 w123_bar (.inputs(inputs27_2), .w(w4_1_2[27]), .wi(weighted_inputs4_27_1));
    weighted_inputs_1 w124 (.inputs(inputs28_2), .w(w4_0_2[28]), .wi(weighted_inputs4_28_0));
    weighted_inputs_1 w124_bar (.inputs(inputs28_2), .w(w4_1_2[28]), .wi(weighted_inputs4_28_1));
    weighted_inputs_1 w125 (.inputs(inputs29_2), .w(w4_0_2[29]), .wi(weighted_inputs4_29_0));
    weighted_inputs_1 w125_bar (.inputs(inputs29_2), .w(w4_1_2[29]), .wi(weighted_inputs4_29_1));
    weighted_inputs_1 w126 (.inputs(inputs30_2), .w(w4_0_2[30]), .wi(weighted_inputs4_30_0));
    weighted_inputs_1 w126_bar (.inputs(inputs30_2), .w(w4_1_2[30]), .wi(weighted_inputs4_30_1));
    weighted_inputs_1 w127 (.inputs(inputs31_2), .w(w4_0_2[31]), .wi(weighted_inputs4_31_0));
    weighted_inputs_1 w127_bar (.inputs(inputs31_2), .w(w4_1_2[31]), .wi(weighted_inputs4_31_1));
    adder_tree_2 add0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .in8(weighted_inputs1_8_0),
        .in9(weighted_inputs1_9_0),
        .in10(weighted_inputs1_10_0),
        .in11(weighted_inputs1_11_0),
        .in12(weighted_inputs1_12_0),
        .in13(weighted_inputs1_13_0),
        .in14(weighted_inputs1_14_0),
        .in15(weighted_inputs1_15_0),
        .in16(weighted_inputs1_16_0),
        .in17(weighted_inputs1_17_0),
        .in18(weighted_inputs1_18_0),
        .in19(weighted_inputs1_19_0),
        .in20(weighted_inputs1_20_0),
        .in21(weighted_inputs1_21_0),
        .in22(weighted_inputs1_22_0),
        .in23(weighted_inputs1_23_0),
        .in24(weighted_inputs1_24_0),
        .in25(weighted_inputs1_25_0),
        .in26(weighted_inputs1_26_0),
        .in27(weighted_inputs1_27_0),
        .in28(weighted_inputs1_28_0),
        .in29(weighted_inputs1_29_0),
        .in30(weighted_inputs1_30_0),
        .in31(weighted_inputs1_31_0),
        .sum(sum1[0])
    );
    adder_tree_2 add4(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
        .in8(weighted_inputs1_8_1),
        .in9(weighted_inputs1_9_1),
        .in10(weighted_inputs1_10_1),
        .in11(weighted_inputs1_11_1),
        .in12(weighted_inputs1_12_1),
        .in13(weighted_inputs1_13_1),
        .in14(weighted_inputs1_14_1),
        .in15(weighted_inputs1_15_1),
        .in16(weighted_inputs1_16_1),
        .in17(weighted_inputs1_17_1),
        .in18(weighted_inputs1_18_1),
        .in19(weighted_inputs1_19_1),
        .in20(weighted_inputs1_20_1),
        .in21(weighted_inputs1_21_1),
        .in22(weighted_inputs1_22_1),
        .in23(weighted_inputs1_23_1),
        .in24(weighted_inputs1_24_1),
        .in25(weighted_inputs1_25_1),
        .in26(weighted_inputs1_26_1),
        .in27(weighted_inputs1_27_1),
        .in28(weighted_inputs1_28_1),
        .in29(weighted_inputs1_29_1),
        .in30(weighted_inputs1_30_1),
        .in31(weighted_inputs1_31_1),
        .sum(sum2[0])
    );
    adder_tree_bar_2 addb0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .in8(weighted_inputs1_8_0),
        .in9(weighted_inputs1_9_0),
        .in10(weighted_inputs1_10_0),
        .in11(weighted_inputs1_11_0),
        .in12(weighted_inputs1_12_0),
        .in13(weighted_inputs1_13_0),
        .in14(weighted_inputs1_14_0),
        .in15(weighted_inputs1_15_0),
        .in16(weighted_inputs1_16_0),
        .in17(weighted_inputs1_17_0),
        .in18(weighted_inputs1_18_0),
        .in19(weighted_inputs1_19_0),
        .in20(weighted_inputs1_20_0),
        .in21(weighted_inputs1_21_0),
        .in22(weighted_inputs1_22_0),
        .in23(weighted_inputs1_23_0),
        .in24(weighted_inputs1_24_0),
        .in25(weighted_inputs1_25_0),
        .in26(weighted_inputs1_26_0),
        .in27(weighted_inputs1_27_0),
        .in28(weighted_inputs1_28_0),
        .in29(weighted_inputs1_29_0),
        .in30(weighted_inputs1_30_0),
        .in31(weighted_inputs1_31_0),
        .sum(sum1bar[0])
    );
    adder_tree_bar_2 addb4(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
        .in8(weighted_inputs1_8_1),
        .in9(weighted_inputs1_9_1),
        .in10(weighted_inputs1_10_1),
        .in11(weighted_inputs1_11_1),
        .in12(weighted_inputs1_12_1),
        .in13(weighted_inputs1_13_1),
        .in14(weighted_inputs1_14_1),
        .in15(weighted_inputs1_15_1),
        .in16(weighted_inputs1_16_1),
        .in17(weighted_inputs1_17_1),
        .in18(weighted_inputs1_18_1),
        .in19(weighted_inputs1_19_1),
        .in20(weighted_inputs1_20_1),
        .in21(weighted_inputs1_21_1),
        .in22(weighted_inputs1_22_1),
        .in23(weighted_inputs1_23_1),
        .in24(weighted_inputs1_24_1),
        .in25(weighted_inputs1_25_1),
        .in26(weighted_inputs1_26_1),
        .in27(weighted_inputs1_27_1),
        .in28(weighted_inputs1_28_1),
        .in29(weighted_inputs1_29_1),
        .in30(weighted_inputs1_30_1),
        .in31(weighted_inputs1_31_1),
        .sum(sum2bar[0])
    );
    adder_tree_2 add1(
        .in0(weighted_inputs2_0_0),
        .in1(weighted_inputs2_1_0),
        .in2(weighted_inputs2_2_0),
        .in3(weighted_inputs2_3_0),
        .in4(weighted_inputs2_4_0),
        .in5(weighted_inputs2_5_0),
        .in6(weighted_inputs2_6_0),
        .in7(weighted_inputs2_7_0),
        .in8(weighted_inputs2_8_0),
        .in9(weighted_inputs2_9_0),
        .in10(weighted_inputs2_10_0),
        .in11(weighted_inputs2_11_0),
        .in12(weighted_inputs2_12_0),
        .in13(weighted_inputs2_13_0),
        .in14(weighted_inputs2_14_0),
        .in15(weighted_inputs2_15_0),
        .in16(weighted_inputs2_16_0),
        .in17(weighted_inputs2_17_0),
        .in18(weighted_inputs2_18_0),
        .in19(weighted_inputs2_19_0),
        .in20(weighted_inputs2_20_0),
        .in21(weighted_inputs2_21_0),
        .in22(weighted_inputs2_22_0),
        .in23(weighted_inputs2_23_0),
        .in24(weighted_inputs2_24_0),
        .in25(weighted_inputs2_25_0),
        .in26(weighted_inputs2_26_0),
        .in27(weighted_inputs2_27_0),
        .in28(weighted_inputs2_28_0),
        .in29(weighted_inputs2_29_0),
        .in30(weighted_inputs2_30_0),
        .in31(weighted_inputs2_31_0),
        .sum(sum1[1])
    );
    adder_tree_2 add5(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .in8(weighted_inputs2_8_1),
        .in9(weighted_inputs2_9_1),
        .in10(weighted_inputs2_10_1),
        .in11(weighted_inputs2_11_1),
        .in12(weighted_inputs2_12_1),
        .in13(weighted_inputs2_13_1),
        .in14(weighted_inputs2_14_1),
        .in15(weighted_inputs2_15_1),
        .in16(weighted_inputs2_16_1),
        .in17(weighted_inputs2_17_1),
        .in18(weighted_inputs2_18_1),
        .in19(weighted_inputs2_19_1),
        .in20(weighted_inputs2_20_1),
        .in21(weighted_inputs2_21_1),
        .in22(weighted_inputs2_22_1),
        .in23(weighted_inputs2_23_1),
        .in24(weighted_inputs2_24_1),
        .in25(weighted_inputs2_25_1),
        .in26(weighted_inputs2_26_1),
        .in27(weighted_inputs2_27_1),
        .in28(weighted_inputs2_28_1),
        .in29(weighted_inputs2_29_1),
        .in30(weighted_inputs2_30_1),
        .in31(weighted_inputs2_31_1),
        .sum(sum2[1])
    );
    adder_tree_bar_2 addb1(
        .in0(weighted_inputs2_0_0),
        .in1(weighted_inputs2_1_0),
        .in2(weighted_inputs2_2_0),
        .in3(weighted_inputs2_3_0),
        .in4(weighted_inputs2_4_0),
        .in5(weighted_inputs2_5_0),
        .in6(weighted_inputs2_6_0),
        .in7(weighted_inputs2_7_0),
        .in8(weighted_inputs2_8_0),
        .in9(weighted_inputs2_9_0),
        .in10(weighted_inputs2_10_0),
        .in11(weighted_inputs2_11_0),
        .in12(weighted_inputs2_12_0),
        .in13(weighted_inputs2_13_0),
        .in14(weighted_inputs2_14_0),
        .in15(weighted_inputs2_15_0),
        .in16(weighted_inputs2_16_0),
        .in17(weighted_inputs2_17_0),
        .in18(weighted_inputs2_18_0),
        .in19(weighted_inputs2_19_0),
        .in20(weighted_inputs2_20_0),
        .in21(weighted_inputs2_21_0),
        .in22(weighted_inputs2_22_0),
        .in23(weighted_inputs2_23_0),
        .in24(weighted_inputs2_24_0),
        .in25(weighted_inputs2_25_0),
        .in26(weighted_inputs2_26_0),
        .in27(weighted_inputs2_27_0),
        .in28(weighted_inputs2_28_0),
        .in29(weighted_inputs2_29_0),
        .in30(weighted_inputs2_30_0),
        .in31(weighted_inputs2_31_0),
        .sum(sum1bar[1])
    );
    adder_tree_bar_2 addb5(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .in8(weighted_inputs2_8_1),
        .in9(weighted_inputs2_9_1),
        .in10(weighted_inputs2_10_1),
        .in11(weighted_inputs2_11_1),
        .in12(weighted_inputs2_12_1),
        .in13(weighted_inputs2_13_1),
        .in14(weighted_inputs2_14_1),
        .in15(weighted_inputs2_15_1),
        .in16(weighted_inputs2_16_1),
        .in17(weighted_inputs2_17_1),
        .in18(weighted_inputs2_18_1),
        .in19(weighted_inputs2_19_1),
        .in20(weighted_inputs2_20_1),
        .in21(weighted_inputs2_21_1),
        .in22(weighted_inputs2_22_1),
        .in23(weighted_inputs2_23_1),
        .in24(weighted_inputs2_24_1),
        .in25(weighted_inputs2_25_1),
        .in26(weighted_inputs2_26_1),
        .in27(weighted_inputs2_27_1),
        .in28(weighted_inputs2_28_1),
        .in29(weighted_inputs2_29_1),
        .in30(weighted_inputs2_30_1),
        .in31(weighted_inputs2_31_1),
        .sum(sum2bar[1])
    );
    adder_tree_2 add2(
        .in0(weighted_inputs3_0_0),
        .in1(weighted_inputs3_1_0),
        .in2(weighted_inputs3_2_0),
        .in3(weighted_inputs3_3_0),
        .in4(weighted_inputs3_4_0),
        .in5(weighted_inputs3_5_0),
        .in6(weighted_inputs3_6_0),
        .in7(weighted_inputs3_7_0),
        .in8(weighted_inputs3_8_0),
        .in9(weighted_inputs3_9_0),
        .in10(weighted_inputs3_10_0),
        .in11(weighted_inputs3_11_0),
        .in12(weighted_inputs3_12_0),
        .in13(weighted_inputs3_13_0),
        .in14(weighted_inputs3_14_0),
        .in15(weighted_inputs3_15_0),
        .in16(weighted_inputs3_16_0),
        .in17(weighted_inputs3_17_0),
        .in18(weighted_inputs3_18_0),
        .in19(weighted_inputs3_19_0),
        .in20(weighted_inputs3_20_0),
        .in21(weighted_inputs3_21_0),
        .in22(weighted_inputs3_22_0),
        .in23(weighted_inputs3_23_0),
        .in24(weighted_inputs3_24_0),
        .in25(weighted_inputs3_25_0),
        .in26(weighted_inputs3_26_0),
        .in27(weighted_inputs3_27_0),
        .in28(weighted_inputs3_28_0),
        .in29(weighted_inputs3_29_0),
        .in30(weighted_inputs3_30_0),
        .in31(weighted_inputs3_31_0),
        .sum(sum1[2])
    );
    adder_tree_2 add6(
        .in0(weighted_inputs3_0_1),
        .in1(weighted_inputs3_1_1),
        .in2(weighted_inputs3_2_1),
        .in3(weighted_inputs3_3_1),
        .in4(weighted_inputs3_4_1),
        .in5(weighted_inputs3_5_1),
        .in6(weighted_inputs3_6_1),
        .in7(weighted_inputs3_7_1),
        .in8(weighted_inputs3_8_1),
        .in9(weighted_inputs3_9_1),
        .in10(weighted_inputs3_10_1),
        .in11(weighted_inputs3_11_1),
        .in12(weighted_inputs3_12_1),
        .in13(weighted_inputs3_13_1),
        .in14(weighted_inputs3_14_1),
        .in15(weighted_inputs3_15_1),
        .in16(weighted_inputs3_16_1),
        .in17(weighted_inputs3_17_1),
        .in18(weighted_inputs3_18_1),
        .in19(weighted_inputs3_19_1),
        .in20(weighted_inputs3_20_1),
        .in21(weighted_inputs3_21_1),
        .in22(weighted_inputs3_22_1),
        .in23(weighted_inputs3_23_1),
        .in24(weighted_inputs3_24_1),
        .in25(weighted_inputs3_25_1),
        .in26(weighted_inputs3_26_1),
        .in27(weighted_inputs3_27_1),
        .in28(weighted_inputs3_28_1),
        .in29(weighted_inputs3_29_1),
        .in30(weighted_inputs3_30_1),
        .in31(weighted_inputs3_31_1),
        .sum(sum2[2])
    );
    adder_tree_bar_2 addb2(
        .in0(weighted_inputs3_0_0),
        .in1(weighted_inputs3_1_0),
        .in2(weighted_inputs3_2_0),
        .in3(weighted_inputs3_3_0),
        .in4(weighted_inputs3_4_0),
        .in5(weighted_inputs3_5_0),
        .in6(weighted_inputs3_6_0),
        .in7(weighted_inputs3_7_0),
        .in8(weighted_inputs3_8_0),
        .in9(weighted_inputs3_9_0),
        .in10(weighted_inputs3_10_0),
        .in11(weighted_inputs3_11_0),
        .in12(weighted_inputs3_12_0),
        .in13(weighted_inputs3_13_0),
        .in14(weighted_inputs3_14_0),
        .in15(weighted_inputs3_15_0),
        .in16(weighted_inputs3_16_0),
        .in17(weighted_inputs3_17_0),
        .in18(weighted_inputs3_18_0),
        .in19(weighted_inputs3_19_0),
        .in20(weighted_inputs3_20_0),
        .in21(weighted_inputs3_21_0),
        .in22(weighted_inputs3_22_0),
        .in23(weighted_inputs3_23_0),
        .in24(weighted_inputs3_24_0),
        .in25(weighted_inputs3_25_0),
        .in26(weighted_inputs3_26_0),
        .in27(weighted_inputs3_27_0),
        .in28(weighted_inputs3_28_0),
        .in29(weighted_inputs3_29_0),
        .in30(weighted_inputs3_30_0),
        .in31(weighted_inputs3_31_0),
        .sum(sum1bar[2])
    );
    adder_tree_bar_2 addb6(
        .in0(weighted_inputs3_0_1),
        .in1(weighted_inputs3_1_1),
        .in2(weighted_inputs3_2_1),
        .in3(weighted_inputs3_3_1),
        .in4(weighted_inputs3_4_1),
        .in5(weighted_inputs3_5_1),
        .in6(weighted_inputs3_6_1),
        .in7(weighted_inputs3_7_1),
        .in8(weighted_inputs3_8_1),
        .in9(weighted_inputs3_9_1),
        .in10(weighted_inputs3_10_1),
        .in11(weighted_inputs3_11_1),
        .in12(weighted_inputs3_12_1),
        .in13(weighted_inputs3_13_1),
        .in14(weighted_inputs3_14_1),
        .in15(weighted_inputs3_15_1),
        .in16(weighted_inputs3_16_1),
        .in17(weighted_inputs3_17_1),
        .in18(weighted_inputs3_18_1),
        .in19(weighted_inputs3_19_1),
        .in20(weighted_inputs3_20_1),
        .in21(weighted_inputs3_21_1),
        .in22(weighted_inputs3_22_1),
        .in23(weighted_inputs3_23_1),
        .in24(weighted_inputs3_24_1),
        .in25(weighted_inputs3_25_1),
        .in26(weighted_inputs3_26_1),
        .in27(weighted_inputs3_27_1),
        .in28(weighted_inputs3_28_1),
        .in29(weighted_inputs3_29_1),
        .in30(weighted_inputs3_30_1),
        .in31(weighted_inputs3_31_1),
        .sum(sum2bar[2])
    );
    adder_tree_2 add3(
        .in0(weighted_inputs4_0_0),
        .in1(weighted_inputs4_1_0),
        .in2(weighted_inputs4_2_0),
        .in3(weighted_inputs4_3_0),
        .in4(weighted_inputs4_4_0),
        .in5(weighted_inputs4_5_0),
        .in6(weighted_inputs4_6_0),
        .in7(weighted_inputs4_7_0),
        .in8(weighted_inputs4_8_0),
        .in9(weighted_inputs4_9_0),
        .in10(weighted_inputs4_10_0),
        .in11(weighted_inputs4_11_0),
        .in12(weighted_inputs4_12_0),
        .in13(weighted_inputs4_13_0),
        .in14(weighted_inputs4_14_0),
        .in15(weighted_inputs4_15_0),
        .in16(weighted_inputs4_16_0),
        .in17(weighted_inputs4_17_0),
        .in18(weighted_inputs4_18_0),
        .in19(weighted_inputs4_19_0),
        .in20(weighted_inputs4_20_0),
        .in21(weighted_inputs4_21_0),
        .in22(weighted_inputs4_22_0),
        .in23(weighted_inputs4_23_0),
        .in24(weighted_inputs4_24_0),
        .in25(weighted_inputs4_25_0),
        .in26(weighted_inputs4_26_0),
        .in27(weighted_inputs4_27_0),
        .in28(weighted_inputs4_28_0),
        .in29(weighted_inputs4_29_0),
        .in30(weighted_inputs4_30_0),
        .in31(weighted_inputs4_31_0),
        .sum(sum1[3])
    );
    adder_tree_2 add7(
        .in0(weighted_inputs4_0_1),
        .in1(weighted_inputs4_1_1),
        .in2(weighted_inputs4_2_1),
        .in3(weighted_inputs4_3_1),
        .in4(weighted_inputs4_4_1),
        .in5(weighted_inputs4_5_1),
        .in6(weighted_inputs4_6_1),
        .in7(weighted_inputs4_7_1),
        .in8(weighted_inputs4_8_1),
        .in9(weighted_inputs4_9_1),
        .in10(weighted_inputs4_10_1),
        .in11(weighted_inputs4_11_1),
        .in12(weighted_inputs4_12_1),
        .in13(weighted_inputs4_13_1),
        .in14(weighted_inputs4_14_1),
        .in15(weighted_inputs4_15_1),
        .in16(weighted_inputs4_16_1),
        .in17(weighted_inputs4_17_1),
        .in18(weighted_inputs4_18_1),
        .in19(weighted_inputs4_19_1),
        .in20(weighted_inputs4_20_1),
        .in21(weighted_inputs4_21_1),
        .in22(weighted_inputs4_22_1),
        .in23(weighted_inputs4_23_1),
        .in24(weighted_inputs4_24_1),
        .in25(weighted_inputs4_25_1),
        .in26(weighted_inputs4_26_1),
        .in27(weighted_inputs4_27_1),
        .in28(weighted_inputs4_28_1),
        .in29(weighted_inputs4_29_1),
        .in30(weighted_inputs4_30_1),
        .in31(weighted_inputs4_31_1),
        .sum(sum2[3])
    );
    adder_tree_bar_2 addb3(
        .in0(weighted_inputs4_0_0),
        .in1(weighted_inputs4_1_0),
        .in2(weighted_inputs4_2_0),
        .in3(weighted_inputs4_3_0),
        .in4(weighted_inputs4_4_0),
        .in5(weighted_inputs4_5_0),
        .in6(weighted_inputs4_6_0),
        .in7(weighted_inputs4_7_0),
        .in8(weighted_inputs4_8_0),
        .in9(weighted_inputs4_9_0),
        .in10(weighted_inputs4_10_0),
        .in11(weighted_inputs4_11_0),
        .in12(weighted_inputs4_12_0),
        .in13(weighted_inputs4_13_0),
        .in14(weighted_inputs4_14_0),
        .in15(weighted_inputs4_15_0),
        .in16(weighted_inputs4_16_0),
        .in17(weighted_inputs4_17_0),
        .in18(weighted_inputs4_18_0),
        .in19(weighted_inputs4_19_0),
        .in20(weighted_inputs4_20_0),
        .in21(weighted_inputs4_21_0),
        .in22(weighted_inputs4_22_0),
        .in23(weighted_inputs4_23_0),
        .in24(weighted_inputs4_24_0),
        .in25(weighted_inputs4_25_0),
        .in26(weighted_inputs4_26_0),
        .in27(weighted_inputs4_27_0),
        .in28(weighted_inputs4_28_0),
        .in29(weighted_inputs4_29_0),
        .in30(weighted_inputs4_30_0),
        .in31(weighted_inputs4_31_0),
        .sum(sum1bar[3])
    );
    adder_tree_bar_2 addb7(
        .in0(weighted_inputs4_0_1),
        .in1(weighted_inputs4_1_1),
        .in2(weighted_inputs4_2_1),
        .in3(weighted_inputs4_3_1),
        .in4(weighted_inputs4_4_1),
        .in5(weighted_inputs4_5_1),
        .in6(weighted_inputs4_6_1),
        .in7(weighted_inputs4_7_1),
        .in8(weighted_inputs4_8_1),
        .in9(weighted_inputs4_9_1),
        .in10(weighted_inputs4_10_1),
        .in11(weighted_inputs4_11_1),
        .in12(weighted_inputs4_12_1),
        .in13(weighted_inputs4_13_1),
        .in14(weighted_inputs4_14_1),
        .in15(weighted_inputs4_15_1),
        .in16(weighted_inputs4_16_1),
        .in17(weighted_inputs4_17_1),
        .in18(weighted_inputs4_18_1),
        .in19(weighted_inputs4_19_1),
        .in20(weighted_inputs4_20_1),
        .in21(weighted_inputs4_21_1),
        .in22(weighted_inputs4_22_1),
        .in23(weighted_inputs4_23_1),
        .in24(weighted_inputs4_24_1),
        .in25(weighted_inputs4_25_1),
        .in26(weighted_inputs4_26_1),
        .in27(weighted_inputs4_27_1),
        .in28(weighted_inputs4_28_1),
        .in29(weighted_inputs4_29_1),
        .in30(weighted_inputs4_30_1),
        .in31(weighted_inputs4_31_1),
        .sum(sum2bar[3])
    );
    add8bit_2 u0 (.a(sum1[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1[0]));
    add8bit_2 u4 (.a(sum2[0]), .b(b1_2), .cin(1'b0), .y(biased_sum2[0]));
    add8bitbar_2 ub0 (.a(sum1bar[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1bar[0]));
    add8bitbar_2 ub4 (.a(sum2bar[0]), .b(b1_2), .cin(1'b0), .y(biased_sum2bar[0]));
    add8bit_2 u1 (.a(sum1[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1[1]));
    add8bit_2 u5 (.a(sum2[1]), .b(b2_2), .cin(1'b0), .y(biased_sum2[1]));
    add8bitbar_2 ub1 (.a(sum1bar[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1bar[1]));
    add8bitbar_2 ub5 (.a(sum2bar[1]), .b(b2_2), .cin(1'b0), .y(biased_sum2bar[1]));
    add8bit_2 u2 (.a(sum1[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1[2]));
    add8bit_2 u6 (.a(sum2[2]), .b(b3_2), .cin(1'b0), .y(biased_sum2[2]));
    add8bitbar_2 ub2 (.a(sum1bar[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1bar[2]));
    add8bitbar_2 ub6 (.a(sum2bar[2]), .b(b3_2), .cin(1'b0), .y(biased_sum2bar[2]));
    add8bit_2 u3 (.a(sum1[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1[3]));
    add8bit_2 u7 (.a(sum2[3]), .b(b4_2), .cin(1'b0), .y(biased_sum2[3]));
    add8bitbar_2 ub3 (.a(sum1bar[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1bar[3]));
    add8bitbar_2 ub7 (.a(sum2bar[3]), .b(b4_2), .cin(1'b0), .y(biased_sum2bar[3]));
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
    always @(*) begin
        $display("----- BNN LAYER 2 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_2, inputs1_2, inputs2_2, inputs3_2, inputs4_2, inputs5_2, inputs6_2, inputs7_2, inputs8_2, inputs9_2, inputs10_2, inputs11_2, inputs12_2, inputs13_2, inputs14_2, inputs15_2, inputs16_2, inputs17_2, inputs18_2, inputs19_2, inputs20_2, inputs21_2, inputs22_2, inputs23_2, inputs24_2, inputs25_2, inputs26_2, inputs27_2, inputs28_2, inputs29_2, inputs30_2, inputs31_2);
        $display("Weights0: %b %b %b %b", w1_0_2, w2_0_2, w3_0_2, w4_0_2);
        $display("Weights1: %b %b %b %b", w1_1_2, w2_1_2, w3_1_2, w4_1_2);
        $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
        $display("sum2: %b %b %b %b", sum2[0], sum2[1], sum2[2], sum2[3]);
        $display("sum1bar: %b %b %b %b", sum1bar[0], sum1bar[1], sum1bar[2], sum1bar[3]);
        $display("sum2bar: %b %b %b %b", sum2bar[0], sum2bar[1], sum2bar[2], sum2bar[3]);
        $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
        $display("biased_sum2: %b %b %b %b", biased_sum2[0], biased_sum2[1], biased_sum2[2], biased_sum2[3]);
        $display("biased_sum1bar: %b %b %b %b", biased_sum1bar[0], biased_sum1bar[1], biased_sum1bar[2], biased_sum1bar[3]);
        $display("biased_sum2bar: %b %b %b %b", biased_sum2bar[0], biased_sum2bar[1], biased_sum2bar[2], biased_sum2bar[3]);
    end
endmodule


module activation_2 (

    input [8:0] inputs0_0,
    input [8:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6, r7, r8, r9;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0, masked_c6_0, masked_c7_0, masked_c8_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0), .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0), .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0), .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0), .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0), .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0), .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));
    lut1 l6 (.a(inputs0_0[6]), .b(inputs0_1[6]), .c_in(masked_c5_0), .r_flow(r6), .r_i(r6_0), .r_out(r7), .c_masked(masked_c6_0));
    lut1 l7 (.a(inputs0_0[7]), .b(inputs0_1[7]), .c_in(masked_c6_0), .r_flow(r7), .r_i(r7_0), .r_out(r8), .c_masked(masked_c7_0));
    lut1 l8 (.a(inputs0_0[8]), .b(inputs0_1[8]), .c_in(masked_c7_0), .r_flow(r8), .r_i(r8_0), .r_out(r9), .c_masked(masked_c8_0));

    wire carry = r9 ^ masked_c8_0;
    wire activation = (carry ^ inputs0_0[8] ^ inputs0_1[8]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r9;
    assign mask = r9;

endmodule

module activation_array_2 (
    input  [8:0] inputs0_0, inputs0_1,
    input  [8:0] inputs1_0, inputs1_1,
    input  [8:0] inputs2_0, inputs2_1,
    input  [8:0] inputs3_0, inputs3_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1, r6_1, r7_1, r8_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2, r7_2, r8_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3, r6_3, r7_3, r8_3,
    output wire masked_activation0,
    output wire masked_activation1,
    output wire masked_activation2,
    output wire masked_activation3,
    output wire mask0,
    output wire mask1,
    output wire mask2,
    output wire mask3
);

    activation_2 a0 (
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
        .masked_activation(masked_activation0),
        .mask(mask0)
    );

    activation_2 a1 (
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
        .masked_activation(masked_activation1),
        .mask(mask1)
    );

    activation_2 a2 (
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
        .masked_activation(masked_activation2),
        .mask(mask2)
    );

    activation_2 a3 (
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
        .masked_activation(masked_activation3),
        .mask(mask3)
    );

endmodule

`timescale 1ns/1ps

module mux_2 (

    input  wire a, b, s,

    output wire y
);

assign y = (~s & a)|(s & b);
endmodule


module boolean_arithmetic_coversion_2 (

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


    mux_2 m1(.a(y0[1]), .b(y1[0] ^ y0[1]), .s(arith_share0[0]), .y(arith_share0[1]));

    mux_2 m2(.a(y0[1] ^ y0[2]), .b(y0[2] ^ y1[1]), .s(arith_share0[1]), .y(arith_share0[2]));


    assign arith_share1 = y1;

endmodule




module activation_and_conversion_2(
  input  wire [2:0] inputs0_2,
  input  wire [2:0] inputs1_2,
  input  wire [2:0] inputs2_2,
  input  wire [2:0] inputs3_2,
  input  wire [2:0] inputs4_2,
  input  wire [2:0] inputs5_2,
  input  wire [2:0] inputs6_2,
  input  wire [2:0] inputs7_2,
  input  wire [2:0] inputs8_2,
  input  wire [2:0] inputs9_2,
  input  wire [2:0] inputs10_2,
  input  wire [2:0] inputs11_2,
  input  wire [2:0] inputs12_2,
  input  wire [2:0] inputs13_2,
  input  wire [2:0] inputs14_2,
  input  wire [2:0] inputs15_2,
  input  wire [2:0] inputs16_2,
  input  wire [2:0] inputs17_2,
  input  wire [2:0] inputs18_2,
  input  wire [2:0] inputs19_2,
  input  wire [2:0] inputs20_2,
  input  wire [2:0] inputs21_2,
  input  wire [2:0] inputs22_2,
  input  wire [2:0] inputs23_2,
  input  wire [2:0] inputs24_2,
  input  wire [2:0] inputs25_2,
  input  wire [2:0] inputs26_2,
  input  wire [2:0] inputs27_2,
  input  wire [2:0] inputs28_2,
  input  wire [2:0] inputs29_2,
  input  wire [2:0] inputs30_2,
  input  wire [2:0] inputs31_2,
  input  wire [31:0] w1_0_2, w1_1_2,
  input  wire [31:0] w2_0_2, w2_1_2,
  input  wire [31:0] w3_0_2, w3_1_2,
  input  wire [31:0] w4_0_2, w4_1_2,
  input  wire [7:0] b1_2, b2_2, b3_2, b4_2,
  input  wire r0_0,
  input  wire r1_0,
  input  wire r2_0,
  input  wire r3_0,
  input  wire r4_0,
  input  wire r5_0,
  input  wire r6_0,
  input  wire r7_0,
  input  wire r8_0,
  input  wire r0_1,
  input  wire r1_1,
  input  wire r2_1,
  input  wire r3_1,
  input  wire r4_1,
  input  wire r5_1,
  input  wire r6_1,
  input  wire r7_1,
  input  wire r8_1,
  input  wire r0_2,
  input  wire r1_2,
  input  wire r2_2,
  input  wire r3_2,
  input  wire r4_2,
  input  wire r5_2,
  input  wire r6_2,
  input  wire r7_2,
  input  wire r8_2,
  input  wire r0_3,
  input  wire r1_3,
  input  wire r2_3,
  input  wire r3_3,
  input  wire r4_3,
  input  wire r5_3,
  input  wire r6_3,
  input  wire r7_3,
  input  wire r8_3,
  input wire [1:0] ar0, ar0bar,
  input wire [1:0] ar1, ar1bar,
  input wire [1:0] ar2, ar2bar,
  input wire [1:0] ar3, ar3bar,
  output wire masked_activation0_2, masked_activation0bar_2,
  output wire mask0_2, mask0bar_2,
  output wire masked_activation1_2, masked_activation1bar_2,
  output wire mask1_2, mask1bar_2,
  output wire masked_activation2_2, masked_activation2bar_2,
  output wire mask2_2, mask2bar_2,
  output wire masked_activation3_2, masked_activation3bar_2,
  output wire mask3_2, mask3bar_2,
  output wire [2:0] act0_0_2, act0_1_2,
  output wire [2:0] act0_0bar_2, act0_1bar_2,
  output wire [2:0] act1_0_2, act1_1_2,
  output wire [2:0] act1_0bar_2, act1_1bar_2,
  output wire [2:0] act2_0_2, act2_1_2,
  output wire [2:0] act2_0bar_2, act2_1bar_2,
  output wire [2:0] act3_0_2, act3_1_2,
  output wire [2:0] act3_0bar_2, act3_1bar_2
);

  wire [8:0] biased_sum0_0, biased_sum0_0bar;
  wire [8:0] biased_sum0_1, biased_sum0_1bar;
  wire [8:0] biased_sum1_0, biased_sum1_0bar;
  wire [8:0] biased_sum1_1, biased_sum1_1bar;
  wire [8:0] biased_sum2_0, biased_sum2_0bar;
  wire [8:0] biased_sum2_1, biased_sum2_1bar;
  wire [8:0] biased_sum3_0, biased_sum3_0bar;
  wire [8:0] biased_sum3_1, biased_sum3_1bar;

    layer2 l1 (
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
    .inputs16_2(inputs16_2),
    .inputs17_2(inputs17_2),
    .inputs18_2(inputs18_2),
    .inputs19_2(inputs19_2),
    .inputs20_2(inputs20_2),
    .inputs21_2(inputs21_2),
    .inputs22_2(inputs22_2),
    .inputs23_2(inputs23_2),
    .inputs24_2(inputs24_2),
    .inputs25_2(inputs25_2),
    .inputs26_2(inputs26_2),
    .inputs27_2(inputs27_2),
    .inputs28_2(inputs28_2),
    .inputs29_2(inputs29_2),
    .inputs30_2(inputs30_2),
    .inputs31_2(inputs31_2),
    .w1_0_2(w1_0_2), .w1_1_2(w1_1_2),
    .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
    .w3_0_2(w3_0_2), .w3_1_2(w3_1_2),
    .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
    .b1_2(b1_2),
    .b2_2(b2_2),
    .b3_2(b3_2),
    .b4_2(b4_2),
    .biased_sum0_0(biased_sum0_0),
    .biased_sum0_1(biased_sum0_1),
    .biased_sum1_0(biased_sum1_0),
    .biased_sum1_1(biased_sum1_1),
    .biased_sum2_0(biased_sum2_0),
    .biased_sum2_1(biased_sum2_1),
    .biased_sum3_0(biased_sum3_0),
    .biased_sum3_1(biased_sum3_1),
    .biased_sum0_0bar(biased_sum0_0bar),
    .biased_sum0_1bar(biased_sum0_1bar),
    .biased_sum1_0bar(biased_sum1_0bar),
    .biased_sum1_1bar(biased_sum1_1bar),
    .biased_sum2_0bar(biased_sum2_0bar),
    .biased_sum2_1bar(biased_sum2_1bar),
    .biased_sum3_0bar(biased_sum3_0bar),
    .biased_sum3_1bar(biased_sum3_1bar)
  );

    activation_array_2 act1 (
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
    .r0_1(r0_1),
    .r1_1(r1_1),
    .r2_1(r2_1),
    .r3_1(r3_1),
    .r4_1(r4_1),
    .r5_1(r5_1),
    .r6_1(r6_1),
    .r7_1(r7_1),
    .r8_1(r8_1),
    .r0_2(r0_2),
    .r1_2(r1_2),
    .r2_2(r2_2),
    .r3_2(r3_2),
    .r4_2(r4_2),
    .r5_2(r5_2),
    .r6_2(r6_2),
    .r7_2(r7_2),
    .r8_2(r8_2),
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r6_3(r6_3),
    .r7_3(r7_3),
    .r8_3(r8_3),
    .masked_activation0(masked_activation0_2),
    .masked_activation1(masked_activation1_2),
    .masked_activation2(masked_activation2_2),
    .masked_activation3(masked_activation3_2),
    .mask0(mask0_2),
    .mask1(mask1_2),
    .mask2(mask2_2),
    .mask3(mask3_2)
  );

    activation_array_2 act2 (
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
    .r0_1(r0_1),
    .r1_1(r1_1),
    .r2_1(r2_1),
    .r3_1(r3_1),
    .r4_1(r4_1),
    .r5_1(r5_1),
    .r6_1(r6_1),
    .r7_1(r7_1),
    .r8_1(r8_1),
    .r0_2(r0_2),
    .r1_2(r1_2),
    .r2_2(r2_2),
    .r3_2(r3_2),
    .r4_2(r4_2),
    .r5_2(r5_2),
    .r6_2(r6_2),
    .r7_2(r7_2),
    .r8_2(r8_2),
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r6_3(r6_3),
    .r7_3(r7_3),
    .r8_3(r8_3),
    .masked_activation0(masked_activation0bar_2),
    .masked_activation1(masked_activation1bar_2),
    .masked_activation2(masked_activation2bar_2),
    .masked_activation3(masked_activation3bar_2),
    .mask0(mask0bar_2),
    .mask1(mask1bar_2),
    .mask2(mask2bar_2),
    .mask3(mask3bar_2)
  );

    boolean_arithmetic_coversion_2 conv0 (
    .x0(masked_activation0_2),
    .x1(mask0_2),
    .r_mask(ar0),
    .arith_share0(act0_0_2),
    .arith_share1(act0_1_2)
  );

  boolean_arithmetic_coversion_2 conv0b (
    .x0(masked_activation0bar_2),
    .x1(mask0bar_2),
    .r_mask(ar0bar),
    .arith_share0(act0_0bar_2),
    .arith_share1(act0_1bar_2)
  );

  boolean_arithmetic_coversion_2 conv1 (
    .x0(masked_activation1_2),
    .x1(mask1_2),
    .r_mask(ar1),
    .arith_share0(act1_0_2),
    .arith_share1(act1_1_2)
  );

  boolean_arithmetic_coversion_2 conv1b (
    .x0(masked_activation1bar_2),
    .x1(mask1bar_2),
    .r_mask(ar1bar),
    .arith_share0(act1_0bar_2),
    .arith_share1(act1_1bar_2)
  );

  boolean_arithmetic_coversion_2 conv2 (
    .x0(masked_activation2_2),
    .x1(mask2_2),
    .r_mask(ar2),
    .arith_share0(act2_0_2),
    .arith_share1(act2_1_2)
  );

  boolean_arithmetic_coversion_2 conv2b (
    .x0(masked_activation2bar_2),
    .x1(mask2bar_2),
    .r_mask(ar2bar),
    .arith_share0(act2_0bar_2),
    .arith_share1(act2_1bar_2)
  );

  boolean_arithmetic_coversion_2 conv3 (
    .x0(masked_activation3_2),
    .x1(mask3_2),
    .r_mask(ar3),
    .arith_share0(act3_0_2),
    .arith_share1(act3_1_2)
  );

  boolean_arithmetic_coversion_2 conv3b (
    .x0(masked_activation3bar_2),
    .x1(mask3bar_2),
    .r_mask(ar3bar),
    .arith_share0(act3_0bar_2),
    .arith_share1(act3_1bar_2)
  );

    always @(*) begin
    $display("----- LAYER 2   boolean activations -----");
    $display("masked_activation : %b %b %b %b", masked_activation0_2, masked_activation1_2, masked_activation2_2, masked_activation3_2);
    $display("masked_activationbar : %b %b %b %b", masked_activation0bar_2, masked_activation1bar_2, masked_activation2bar_2, masked_activation3bar_2);
    $display("mask : %b %b %b %b", mask0_2, mask1_2, mask2_2, mask3_2);
    $display("maskbar : %b %b %b %b", mask0bar_2, mask1bar_2, mask2bar_2, mask3bar_2);
  end

  always @(*) begin
    $display("----- LAYER 2  arithmetic activations -----");
    $display("masked_activation_arith : %b %b %b %b", act0_0_2, act1_0_2, act2_0_2, act3_0_2);
    $display("mask_arith : %b %b %b %b", act0_1_2, act1_1_2, act2_1_2, act3_1_2);
    $display("masked_activationbar_arith : %b %b %b %b", act0_0bar_2, act1_0bar_2, act2_0bar_2, act3_0bar_2);
    $display("mask_arithbar : %b %b %b %b", act0_1bar_2, act1_1bar_2, act2_1bar_2, act3_1bar_2);
  end

endmodule




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

module add6bit_3(
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

full_adder_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_3 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_3 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_3 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNAND_3 wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNAND_3 wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNAND_3 wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNAND_3 wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout;

endmodule

module add7bit_3(
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

full_adder_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_3 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_3 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_3 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adder_3 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));

WddlNAND_3 wn1(.A(~a[6]), .B(b[6]), .C(~c7), .S(s1), .S1(s1_1));
WddlNAND_3 wn2(.A(a[6]), .B(~b[6]), .C(~c7), .S(s2), .S1(s2_1));
WddlNAND_3 wn3(.A(a[6]), .B(b[6]), .C(c7), .S(s3), .S1(s3_1));
WddlNAND_3 wn4(.A(~a[6]), .B(~b[6]), .C(c7), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[7] = cout;

endmodule


module half_adderbar_3(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adderbar_3(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adderbar_3 HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adderbar_3 HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNANDbar_3(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule

module add3bitbar_3(
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

full_adderbar_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNANDbar_3 wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNANDbar_3 wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNANDbar_3 wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNANDbar_3 wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout_bar;

endmodule

module add4bitbar_3(
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

full_adderbar_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_3 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNANDbar_3 wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNANDbar_3 wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNANDbar_3 wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNANDbar_3 wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout_bar;

endmodule

module add5bitbar_3(
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

full_adderbar_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_3 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_3 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNANDbar_3 wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNANDbar_3 wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNANDbar_3 wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNANDbar_3 wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout_bar;

endmodule

module add6bitbar_3(
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

full_adderbar_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_3 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_3 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_3 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNANDbar_3 wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNANDbar_3 wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNANDbar_3 wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNANDbar_3 wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout_bar;

endmodule

module add7bitbar_3(
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

full_adderbar_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_3 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_3 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_3 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_3 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_3 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));

WddlNANDbar_3 wn1(.A(~a[6]), .B(b[6]), .C(~c7), .S(s1), .S1(s1_1));
WddlNANDbar_3 wn2(.A(a[6]), .B(~b[6]), .C(~c7), .S(s2), .S1(s2_1));
WddlNANDbar_3 wn3(.A(a[6]), .B(b[6]), .C(c7), .S(s3), .S1(s3_1));
WddlNANDbar_3 wn4(.A(~a[6]), .B(~b[6]), .C(c7), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[7] = cout_bar;

endmodule



module adder_tree_3 (
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

    add3bit_3 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bit_3 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bit_3 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bit_3 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add3bit_3 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo), .cout(), .cout_bar());
    add3bit_3 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo), .cout(), .cout_bar());
    add3bit_3 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo), .cout(), .cout_bar());
    add3bit_3 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo), .cout(), .cout_bar());
    add4bit_3 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bit_3 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add4bit_3 u1_2 (.a(stage0_4), .b(stage0_5), .cin(1'b0), .y(stage1_2_lo), .cout(), .cout_bar());
    add4bit_3 u1_3 (.a(stage0_6), .b(stage0_7), .cin(1'b0), .y(stage1_3_lo), .cout(), .cout_bar());
    add5bit_3 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());
    add5bit_3 u2_1 (.a(stage1_2), .b(stage1_3), .cin(1'b0), .y(stage2_1_lo), .cout(), .cout_bar());
    add6bit_3 u3_0 (.a(stage2_0), .b(stage2_1), .cin(1'b0), .y(stage3_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage3_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage0_4 = {1'b0, stage0_4_lo};
        stage0_5 = {1'b0, stage0_5_lo};
        stage0_6 = {1'b0, stage0_6_lo};
        stage0_7 = {1'b0, stage0_7_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage1_2 = {1'b0, stage1_2_lo};
        stage1_3 = {1'b0, stage1_3_lo};
        stage2_0 = {1'b0, stage2_0_lo};
        stage2_1 = {1'b0, stage2_1_lo};
        stage3_0 = {1'b0, stage3_0_lo};
    end
endmodule


module adder_tree_bar_3 (
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

    add3bitbar_3 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_4 (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_5 (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_6 (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_7 (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo), .cout(), .cout_bar());
    add4bitbar_3 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bitbar_3 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add4bitbar_3 u1_2 (.a(stage0_4), .b(stage0_5), .cin(1'b0), .y(stage1_2_lo), .cout(), .cout_bar());
    add4bitbar_3 u1_3 (.a(stage0_6), .b(stage0_7), .cin(1'b0), .y(stage1_3_lo), .cout(), .cout_bar());
    add5bitbar_3 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());
    add5bitbar_3 u2_1 (.a(stage1_2), .b(stage1_3), .cin(1'b0), .y(stage2_1_lo), .cout(), .cout_bar());
    add6bitbar_3 u3_0 (.a(stage2_0), .b(stage2_1), .cin(1'b0), .y(stage3_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage3_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage0_4 = {1'b0, stage0_4_lo};
        stage0_5 = {1'b0, stage0_5_lo};
        stage0_6 = {1'b0, stage0_6_lo};
        stage0_7 = {1'b0, stage0_7_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage1_2 = {1'b0, stage1_2_lo};
        stage1_3 = {1'b0, stage1_3_lo};
        stage2_0 = {1'b0, stage2_0_lo};
        stage2_1 = {1'b0, stage2_1_lo};
        stage3_0 = {1'b0, stage3_0_lo};
    end
endmodule


module layer3(
    input [2:0] inputs0_3 , inputs1_3 , inputs2_3 , inputs3_3 , inputs4_3 , inputs5_3 , inputs6_3 , inputs7_3 , inputs8_3 , inputs9_3 , inputs10_3 , inputs11_3 , inputs12_3 , inputs13_3 , inputs14_3 , inputs15_3,
    input [15:0] w1_0_3, w1_1_3, w2_0_3, w2_1_3,
    input [6:0] b1_3, b2_3,
    output [7:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar
);
    wire [2:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [2:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [2:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [2:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [2:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [2:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [2:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [2:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [2:0] weighted_inputs1_8_0, weighted_inputs1_8_1;
    wire [2:0] weighted_inputs1_9_0, weighted_inputs1_9_1;
    wire [2:0] weighted_inputs1_10_0, weighted_inputs1_10_1;
    wire [2:0] weighted_inputs1_11_0, weighted_inputs1_11_1;
    wire [2:0] weighted_inputs1_12_0, weighted_inputs1_12_1;
    wire [2:0] weighted_inputs1_13_0, weighted_inputs1_13_1;
    wire [2:0] weighted_inputs1_14_0, weighted_inputs1_14_1;
    wire [2:0] weighted_inputs1_15_0, weighted_inputs1_15_1;
    wire [2:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [2:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [2:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [2:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [2:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [2:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [2:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [2:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [2:0] weighted_inputs2_8_0, weighted_inputs2_8_1;
    wire [2:0] weighted_inputs2_9_0, weighted_inputs2_9_1;
    wire [2:0] weighted_inputs2_10_0, weighted_inputs2_10_1;
    wire [2:0] weighted_inputs2_11_0, weighted_inputs2_11_1;
    wire [2:0] weighted_inputs2_12_0, weighted_inputs2_12_1;
    wire [2:0] weighted_inputs2_13_0, weighted_inputs2_13_1;
    wire [2:0] weighted_inputs2_14_0, weighted_inputs2_14_1;
    wire [2:0] weighted_inputs2_15_0, weighted_inputs2_15_1;

    wire [6:0] sum1 [1:0];
    wire [6:0] sum2 [1:0];
    wire [7:0] biased_sum1 [1:0];
    wire [7:0] biased_sum2 [1:0];
    wire [6:0] sum1bar [1:0];
    wire [6:0] sum2bar [1:0];
    wire [7:0] biased_sum1bar [1:0];
    wire [7:0] biased_sum2bar [1:0];
    weighted_inputs_1 w0 (.inputs(inputs0_3), .w(w1_0_3[0]), .wi(weighted_inputs1_0_0));
    weighted_inputs_1 w0_bar (.inputs(inputs0_3), .w(w1_1_3[0]), .wi(weighted_inputs1_0_1));
    weighted_inputs_1 w1 (.inputs(inputs1_3), .w(w1_0_3[1]), .wi(weighted_inputs1_1_0));
    weighted_inputs_1 w1_bar (.inputs(inputs1_3), .w(w1_1_3[1]), .wi(weighted_inputs1_1_1));
    weighted_inputs_1 w2 (.inputs(inputs2_3), .w(w1_0_3[2]), .wi(weighted_inputs1_2_0));
    weighted_inputs_1 w2_bar (.inputs(inputs2_3), .w(w1_1_3[2]), .wi(weighted_inputs1_2_1));
    weighted_inputs_1 w3 (.inputs(inputs3_3), .w(w1_0_3[3]), .wi(weighted_inputs1_3_0));
    weighted_inputs_1 w3_bar (.inputs(inputs3_3), .w(w1_1_3[3]), .wi(weighted_inputs1_3_1));
    weighted_inputs_1 w4 (.inputs(inputs4_3), .w(w1_0_3[4]), .wi(weighted_inputs1_4_0));
    weighted_inputs_1 w4_bar (.inputs(inputs4_3), .w(w1_1_3[4]), .wi(weighted_inputs1_4_1));
    weighted_inputs_1 w5 (.inputs(inputs5_3), .w(w1_0_3[5]), .wi(weighted_inputs1_5_0));
    weighted_inputs_1 w5_bar (.inputs(inputs5_3), .w(w1_1_3[5]), .wi(weighted_inputs1_5_1));
    weighted_inputs_1 w6 (.inputs(inputs6_3), .w(w1_0_3[6]), .wi(weighted_inputs1_6_0));
    weighted_inputs_1 w6_bar (.inputs(inputs6_3), .w(w1_1_3[6]), .wi(weighted_inputs1_6_1));
    weighted_inputs_1 w7 (.inputs(inputs7_3), .w(w1_0_3[7]), .wi(weighted_inputs1_7_0));
    weighted_inputs_1 w7_bar (.inputs(inputs7_3), .w(w1_1_3[7]), .wi(weighted_inputs1_7_1));
    weighted_inputs_1 w8 (.inputs(inputs8_3), .w(w1_0_3[8]), .wi(weighted_inputs1_8_0));
    weighted_inputs_1 w8_bar (.inputs(inputs8_3), .w(w1_1_3[8]), .wi(weighted_inputs1_8_1));
    weighted_inputs_1 w9 (.inputs(inputs9_3), .w(w1_0_3[9]), .wi(weighted_inputs1_9_0));
    weighted_inputs_1 w9_bar (.inputs(inputs9_3), .w(w1_1_3[9]), .wi(weighted_inputs1_9_1));
    weighted_inputs_1 w10 (.inputs(inputs10_3), .w(w1_0_3[10]), .wi(weighted_inputs1_10_0));
    weighted_inputs_1 w10_bar (.inputs(inputs10_3), .w(w1_1_3[10]), .wi(weighted_inputs1_10_1));
    weighted_inputs_1 w11 (.inputs(inputs11_3), .w(w1_0_3[11]), .wi(weighted_inputs1_11_0));
    weighted_inputs_1 w11_bar (.inputs(inputs11_3), .w(w1_1_3[11]), .wi(weighted_inputs1_11_1));
    weighted_inputs_1 w12 (.inputs(inputs12_3), .w(w1_0_3[12]), .wi(weighted_inputs1_12_0));
    weighted_inputs_1 w12_bar (.inputs(inputs12_3), .w(w1_1_3[12]), .wi(weighted_inputs1_12_1));
    weighted_inputs_1 w13 (.inputs(inputs13_3), .w(w1_0_3[13]), .wi(weighted_inputs1_13_0));
    weighted_inputs_1 w13_bar (.inputs(inputs13_3), .w(w1_1_3[13]), .wi(weighted_inputs1_13_1));
    weighted_inputs_1 w14 (.inputs(inputs14_3), .w(w1_0_3[14]), .wi(weighted_inputs1_14_0));
    weighted_inputs_1 w14_bar (.inputs(inputs14_3), .w(w1_1_3[14]), .wi(weighted_inputs1_14_1));
    weighted_inputs_1 w15 (.inputs(inputs15_3), .w(w1_0_3[15]), .wi(weighted_inputs1_15_0));
    weighted_inputs_1 w15_bar (.inputs(inputs15_3), .w(w1_1_3[15]), .wi(weighted_inputs1_15_1));
    weighted_inputs_1 w16 (.inputs(inputs0_3), .w(w2_0_3[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_1 w16_bar (.inputs(inputs0_3), .w(w2_1_3[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_1 w17 (.inputs(inputs1_3), .w(w2_0_3[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_1 w17_bar (.inputs(inputs1_3), .w(w2_1_3[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_1 w18 (.inputs(inputs2_3), .w(w2_0_3[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_1 w18_bar (.inputs(inputs2_3), .w(w2_1_3[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_1 w19 (.inputs(inputs3_3), .w(w2_0_3[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_1 w19_bar (.inputs(inputs3_3), .w(w2_1_3[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_1 w20 (.inputs(inputs4_3), .w(w2_0_3[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_1 w20_bar (.inputs(inputs4_3), .w(w2_1_3[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_1 w21 (.inputs(inputs5_3), .w(w2_0_3[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_1 w21_bar (.inputs(inputs5_3), .w(w2_1_3[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_1 w22 (.inputs(inputs6_3), .w(w2_0_3[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_1 w22_bar (.inputs(inputs6_3), .w(w2_1_3[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_1 w23 (.inputs(inputs7_3), .w(w2_0_3[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_1 w23_bar (.inputs(inputs7_3), .w(w2_1_3[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_1 w24 (.inputs(inputs8_3), .w(w2_0_3[8]), .wi(weighted_inputs2_8_0));
    weighted_inputs_1 w24_bar (.inputs(inputs8_3), .w(w2_1_3[8]), .wi(weighted_inputs2_8_1));
    weighted_inputs_1 w25 (.inputs(inputs9_3), .w(w2_0_3[9]), .wi(weighted_inputs2_9_0));
    weighted_inputs_1 w25_bar (.inputs(inputs9_3), .w(w2_1_3[9]), .wi(weighted_inputs2_9_1));
    weighted_inputs_1 w26 (.inputs(inputs10_3), .w(w2_0_3[10]), .wi(weighted_inputs2_10_0));
    weighted_inputs_1 w26_bar (.inputs(inputs10_3), .w(w2_1_3[10]), .wi(weighted_inputs2_10_1));
    weighted_inputs_1 w27 (.inputs(inputs11_3), .w(w2_0_3[11]), .wi(weighted_inputs2_11_0));
    weighted_inputs_1 w27_bar (.inputs(inputs11_3), .w(w2_1_3[11]), .wi(weighted_inputs2_11_1));
    weighted_inputs_1 w28 (.inputs(inputs12_3), .w(w2_0_3[12]), .wi(weighted_inputs2_12_0));
    weighted_inputs_1 w28_bar (.inputs(inputs12_3), .w(w2_1_3[12]), .wi(weighted_inputs2_12_1));
    weighted_inputs_1 w29 (.inputs(inputs13_3), .w(w2_0_3[13]), .wi(weighted_inputs2_13_0));
    weighted_inputs_1 w29_bar (.inputs(inputs13_3), .w(w2_1_3[13]), .wi(weighted_inputs2_13_1));
    weighted_inputs_1 w30 (.inputs(inputs14_3), .w(w2_0_3[14]), .wi(weighted_inputs2_14_0));
    weighted_inputs_1 w30_bar (.inputs(inputs14_3), .w(w2_1_3[14]), .wi(weighted_inputs2_14_1));
    weighted_inputs_1 w31 (.inputs(inputs15_3), .w(w2_0_3[15]), .wi(weighted_inputs2_15_0));
    weighted_inputs_1 w31_bar (.inputs(inputs15_3), .w(w2_1_3[15]), .wi(weighted_inputs2_15_1));
    adder_tree_3 add0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .in8(weighted_inputs1_8_0),
        .in9(weighted_inputs1_9_0),
        .in10(weighted_inputs1_10_0),
        .in11(weighted_inputs1_11_0),
        .in12(weighted_inputs1_12_0),
        .in13(weighted_inputs1_13_0),
        .in14(weighted_inputs1_14_0),
        .in15(weighted_inputs1_15_0),
        .sum(sum1[0])
    );
    adder_tree_3 add2(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
        .in8(weighted_inputs1_8_1),
        .in9(weighted_inputs1_9_1),
        .in10(weighted_inputs1_10_1),
        .in11(weighted_inputs1_11_1),
        .in12(weighted_inputs1_12_1),
        .in13(weighted_inputs1_13_1),
        .in14(weighted_inputs1_14_1),
        .in15(weighted_inputs1_15_1),
        .sum(sum2[0])
    );
    adder_tree_bar_3 addb0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .in8(weighted_inputs1_8_0),
        .in9(weighted_inputs1_9_0),
        .in10(weighted_inputs1_10_0),
        .in11(weighted_inputs1_11_0),
        .in12(weighted_inputs1_12_0),
        .in13(weighted_inputs1_13_0),
        .in14(weighted_inputs1_14_0),
        .in15(weighted_inputs1_15_0),
        .sum(sum1bar[0])
    );
    adder_tree_bar_3 addb2(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
        .in8(weighted_inputs1_8_1),
        .in9(weighted_inputs1_9_1),
        .in10(weighted_inputs1_10_1),
        .in11(weighted_inputs1_11_1),
        .in12(weighted_inputs1_12_1),
        .in13(weighted_inputs1_13_1),
        .in14(weighted_inputs1_14_1),
        .in15(weighted_inputs1_15_1),
        .sum(sum2bar[0])
    );
    adder_tree_3 add1(
        .in0(weighted_inputs2_0_0),
        .in1(weighted_inputs2_1_0),
        .in2(weighted_inputs2_2_0),
        .in3(weighted_inputs2_3_0),
        .in4(weighted_inputs2_4_0),
        .in5(weighted_inputs2_5_0),
        .in6(weighted_inputs2_6_0),
        .in7(weighted_inputs2_7_0),
        .in8(weighted_inputs2_8_0),
        .in9(weighted_inputs2_9_0),
        .in10(weighted_inputs2_10_0),
        .in11(weighted_inputs2_11_0),
        .in12(weighted_inputs2_12_0),
        .in13(weighted_inputs2_13_0),
        .in14(weighted_inputs2_14_0),
        .in15(weighted_inputs2_15_0),
        .sum(sum1[1])
    );
    adder_tree_3 add3(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .in8(weighted_inputs2_8_1),
        .in9(weighted_inputs2_9_1),
        .in10(weighted_inputs2_10_1),
        .in11(weighted_inputs2_11_1),
        .in12(weighted_inputs2_12_1),
        .in13(weighted_inputs2_13_1),
        .in14(weighted_inputs2_14_1),
        .in15(weighted_inputs2_15_1),
        .sum(sum2[1])
    );
    adder_tree_bar_3 addb1(
        .in0(weighted_inputs2_0_0),
        .in1(weighted_inputs2_1_0),
        .in2(weighted_inputs2_2_0),
        .in3(weighted_inputs2_3_0),
        .in4(weighted_inputs2_4_0),
        .in5(weighted_inputs2_5_0),
        .in6(weighted_inputs2_6_0),
        .in7(weighted_inputs2_7_0),
        .in8(weighted_inputs2_8_0),
        .in9(weighted_inputs2_9_0),
        .in10(weighted_inputs2_10_0),
        .in11(weighted_inputs2_11_0),
        .in12(weighted_inputs2_12_0),
        .in13(weighted_inputs2_13_0),
        .in14(weighted_inputs2_14_0),
        .in15(weighted_inputs2_15_0),
        .sum(sum1bar[1])
    );
    adder_tree_bar_3 addb3(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .in8(weighted_inputs2_8_1),
        .in9(weighted_inputs2_9_1),
        .in10(weighted_inputs2_10_1),
        .in11(weighted_inputs2_11_1),
        .in12(weighted_inputs2_12_1),
        .in13(weighted_inputs2_13_1),
        .in14(weighted_inputs2_14_1),
        .in15(weighted_inputs2_15_1),
        .sum(sum2bar[1])
    );
    add7bit_3 u0 (.a(sum1[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1[0]));
    add7bit_3 u2 (.a(sum2[0]), .b(b1_3), .cin(1'b0), .y(biased_sum2[0]));
    add7bitbar_3 ub0 (.a(sum1bar[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1bar[0]));
    add7bitbar_3 ub2 (.a(sum2bar[0]), .b(b1_3), .cin(1'b0), .y(biased_sum2bar[0]));
    add7bit_3 u1 (.a(sum1[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1[1]));
    add7bit_3 u3 (.a(sum2[1]), .b(b2_3), .cin(1'b0), .y(biased_sum2[1]));
    add7bitbar_3 ub1 (.a(sum1bar[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1bar[1]));
    add7bitbar_3 ub3 (.a(sum2bar[1]), .b(b2_3), .cin(1'b0), .y(biased_sum2bar[1]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum0_1 = biased_sum2[0];
    assign biased_sum0_0bar = biased_sum1bar[0];
    assign biased_sum0_1bar = biased_sum2bar[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum1_1 = biased_sum2[1];
    assign biased_sum1_0bar = biased_sum1bar[1];
    assign biased_sum1_1bar = biased_sum2bar[1];
    always @(*) begin
        $display("----- BNN LAYER 3 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_3, inputs1_3, inputs2_3, inputs3_3, inputs4_3, inputs5_3, inputs6_3, inputs7_3, inputs8_3, inputs9_3, inputs10_3, inputs11_3, inputs12_3, inputs13_3, inputs14_3, inputs15_3);
        $display("Weights0: %b %b", w1_0_3, w2_0_3);
        $display("Weights1: %b %b", w1_1_3, w2_1_3);
        $display("sum1: %b %b", sum1[0], sum1[1]);
        $display("sum2: %b %b", sum2[0], sum2[1]);
        $display("sum1bar: %b %b", sum1bar[0], sum1bar[1]);
        $display("sum2bar: %b %b", sum2bar[0], sum2bar[1]);
        $display("biased_sum1: %b %b", biased_sum1[0], biased_sum1[1]);
        $display("biased_sum2: %b %b", biased_sum2[0], biased_sum2[1]);
        $display("biased_sum1bar: %b %b", biased_sum1bar[0], biased_sum1bar[1]);
        $display("biased_sum2bar: %b %b", biased_sum2bar[0], biased_sum2bar[1]);
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


module output_layer_max (
  input  wire [2:0] inputs0_3,
  input  wire [2:0] inputs1_3,
  input  wire [2:0] inputs2_3,
  input  wire [2:0] inputs3_3,
  input  wire [2:0] inputs4_3,
  input  wire [2:0] inputs5_3,
  input  wire [2:0] inputs6_3,
  input  wire [2:0] inputs7_3,
  input  wire [2:0] inputs8_3,
  input  wire [2:0] inputs9_3,
  input  wire [2:0] inputs10_3,
  input  wire [2:0] inputs11_3,
  input  wire [2:0] inputs12_3,
  input  wire [2:0] inputs13_3,
  input  wire [2:0] inputs14_3,
  input  wire [2:0] inputs15_3,
    input  wire [15:0] w1_0_3, w1_1_3,
    input  wire [15:0] w2_0_3, w2_1_3,
    input  wire [6:0] b1_3,
    input  wire [6:0] b2_3,
    input  wire r0_0,
    input  wire r0_0bar,
    input  wire r1_0,
    input  wire r1_0bar,
    input  wire r2_0,
    input  wire r2_0bar,
    input  wire r3_0,
    input  wire r3_0bar,
    input  wire r4_0,
    input  wire r4_0bar,
    input  wire r5_0,
    input  wire r5_0bar,
    input  wire r6_0,
    input  wire r6_0bar,
    input  wire r7_0,
    input  wire r7_0bar,
    input  wire r8_0,
    input  wire r8_0bar,
    output reg  a0, a0_bar,
    output reg  a1, a1_bar
);

    wire [7:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar;
    wire [7:0] biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar;

    layer3 l1 (
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
        .w1_0_3(w1_0_3), .w1_1_3(w1_1_3),
        .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
        .b1_3(b1_3),
        .b2_3(b2_3),
        .biased_sum0_0(biased_sum0_0),
        .biased_sum0_1(biased_sum0_1),
        .biased_sum1_0(biased_sum1_0),
        .biased_sum1_1(biased_sum1_1),
        .biased_sum0_0bar(biased_sum0_0bar),
        .biased_sum0_1bar(biased_sum0_1bar),
        .biased_sum1_0bar(biased_sum1_0bar),
        .biased_sum1_1bar(biased_sum1_1bar)
    );

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

module connector(
    // Layer-1 inputs
    input  wire [2:0] inputs0_1, inputs1_1, inputs2_1, inputs3_1,
    input  wire [2:0] inputs4_1, inputs5_1, inputs6_1, inputs7_1,
    input  wire [2:0] inputs8_1, inputs9_1, inputs10_1, inputs11_1,
    input  wire [2:0] inputs12_1, inputs13_1, inputs14_1, inputs15_1,

    // Layer-1 weights & biases
    input  wire [15:0] w1_0_1, w1_1_1,
    input  wire [15:0] w2_0_1, w2_1_1,
    input  wire [15:0] w3_0_1, w3_1_1,
    input  wire [15:0] w4_0_1, w4_1_1,
    input  wire [15:0] w5_0_1, w5_1_1,
    input  wire [15:0] w6_0_1, w6_1_1,
    input  wire [15:0] w7_0_1, w7_1_1,
    input  wire [15:0] w8_0_1, w8_1_1,
    input  wire [ 6:0] b1_1, b2_1, b3_1, b4_1,
    input  wire [ 6:0] b5_1, b6_1, b7_1, b8_1,

    // Layer-2 weights & biases
    input  wire [31:0] w1_0_2, w1_1_2,
    input  wire [31:0] w2_0_2, w2_1_2,
    input  wire [31:0] w3_0_2, w3_1_2,
    input  wire [31:0] w4_0_2, w4_1_2,
    input  wire [ 7:0] b1_2, b2_2, b3_2, b4_2,
    //layer3 output 
    input  wire [15:0] w1_0_3, w1_1_3,
    input  wire [15:0] w2_0_3, w2_1_3,
    input  wire [6:0] b1_3,
    input  wire [6:0] b2_3,

    // Final outputs (3-bit arithmetic shares of two neurons)
    output wire  a0, a0_bar,
    output wire  a1, a1_bar    
    
);

  //--------------------------------------------------------------------------
  // Layer-1 intermediate nets
  //--------------------------------------------------------------------------

  // r-flow taps
// Instead of wire …
    reg  r0_0_1, r1_0_1, r2_0_1, r3_0_1, r4_0_1, r5_0_1, r6_0_1, r7_0_1;
    reg  r0_1_1, r1_1_1, r2_1_1, r3_1_1, r4_1_1, r5_1_1, r6_1_1, r7_1_1;
    reg  r0_2_1, r1_2_1, r2_2_1, r3_2_1, r4_2_1, r5_2_1, r6_2_1, r7_2_1;
    reg  r0_3_1, r1_3_1, r2_3_1, r3_3_1, r4_3_1, r5_3_1, r6_3_1, r7_3_1;
    reg  r0_4_1, r1_4_1, r2_4_1, r3_4_1, r4_4_1, r5_4_1, r6_4_1, r7_4_1;
    reg  r0_5_1, r1_5_1, r2_5_1, r3_5_1, r4_5_1, r5_5_1, r6_5_1, r7_5_1;
    reg  r0_6_1, r1_6_1, r2_6_1, r3_6_1, r4_6_1, r5_6_1, r6_6_1, r7_6_1;
    reg  r0_7_1, r1_7_1, r2_7_1, r3_7_1, r4_7_1, r5_7_1, r6_7_1, r7_7_1;


    initial begin
  // layer-1 randomness taps
  r0_0_1 = $random;  r1_0_1 = $random;  r2_0_1 = $random;  r3_0_1 = $random;
  r4_0_1 = $random;  r5_0_1 = $random;  r6_0_1 = $random;  r7_0_1 = $random;

  r0_1_1 = $random;  r1_1_1 = $random;  r2_1_1 = $random;  r3_1_1 = $random;
  r4_1_1 = $random;  r5_1_1 = $random;  r6_1_1 = $random;  r7_1_1 = $random;

  r0_2_1 = $random;  r1_2_1 = $random;  r2_2_1 = $random;  r3_2_1 = $random;
  r4_2_1 = $random;  r5_2_1 = $random;  r6_2_1 = $random;  r7_2_1 = $random;

  r0_3_1 = $random;  r1_3_1 = $random;  r2_3_1 = $random;  r3_3_1 = $random;
  r4_3_1 = $random;  r5_3_1 = $random;  r6_3_1 = $random;  r7_3_1 = $random;

  r0_4_1 = $random;  r1_4_1 = $random;  r2_4_1 = $random;  r3_4_1 = $random;
  r4_4_1 = $random;  r5_4_1 = $random;  r6_4_1 = $random;  r7_4_1 = $random;

  r0_5_1 = $random;  r1_5_1 = $random;  r2_5_1 = $random;  r3_5_1 = $random;
  r4_5_1 = $random;  r5_5_1 = $random;  r6_5_1 = $random;  r7_5_1 = $random;

  r0_6_1 = $random;  r1_6_1 = $random;  r2_6_1 = $random;  r3_6_1 = $random;
  r4_6_1 = $random;  r5_6_1 = $random;  r6_6_1 = $random;  r7_6_1 = $random;

  r0_7_1 = $random;  r1_7_1 = $random;  r2_7_1 = $random;  r3_7_1 = $random;
  r4_7_1 = $random;  r5_7_1 = $random;  r6_7_1 = $random;  r7_7_1 = $random;

  #1; // let everything settle
end



  // masked Boolean outputs & masks
  wire masked_activation0_1, masked_activation1_1, masked_activation2_1, masked_activation3_1;
  wire masked_activation4_1, masked_activation5_1, masked_activation6_1, masked_activation7_1;
  wire masked_activation0bar_1, masked_activation1bar_1, masked_activation2bar_1, masked_activation3bar_1;
  wire masked_activation4bar_1, masked_activation5bar_1, masked_activation6bar_1, masked_activation7bar_1;

  wire mask0_1, mask1_1, mask2_1, mask3_1;
  wire mask4_1, mask5_1, mask6_1, mask7_1;
  wire mask0bar_1, mask1bar_1, mask2bar_1, mask3bar_1;
  wire mask4bar_1, mask5bar_1, mask6bar_1, mask7bar_1;

  // Boolean→arith randomness
// arithmetic‐share randomness taps as regs
reg  [1:0] ar0_1,  ar0bar_1,  ar1_1,  ar1bar_1,  ar2_1,  ar2bar_1,  ar3_1,  ar3bar_1;
reg  [1:0] ar4_1,  ar4bar_1,  ar5_1,  ar5bar_1,  ar6_1,  ar6bar_1,  ar7_1,  ar7bar_1;

initial begin
  ar0_1   = $random;  ar0bar_1 = $random;
  ar1_1   = $random;  ar1bar_1 = $random;
  ar2_1   = $random;  ar2bar_1 = $random;
  ar3_1   = $random;  ar3bar_1 = $random;
  ar4_1   = $random;  ar4bar_1 = $random;
  ar5_1   = $random;  ar5bar_1 = $random;
  ar6_1   = $random;  ar6bar_1 = $random;
  ar7_1   = $random;  ar7bar_1 = $random;
  #1;
end


  // Arithmetic shares produced by Layer 1
  wire [2:0] act0_0_1, act0_1_1, act0_0bar_1, act0_1bar_1;
  wire [2:0] act1_0_1, act1_1_1, act1_0bar_1, act1_1bar_1;
  wire [2:0] act2_0_1, act2_1_1, act2_0bar_1, act2_1bar_1;
  wire [2:0] act3_0_1, act3_1_1, act3_0bar_1, act3_1bar_1;
  wire [2:0] act4_0_1, act4_1_1, act4_0bar_1, act4_1bar_1;
  wire [2:0] act5_0_1, act5_1_1, act5_0bar_1, act5_1bar_1;
  wire [2:0] act6_0_1, act6_1_1, act6_0bar_1, act6_1bar_1;
  wire [2:0] act7_0_1, act7_1_1, act7_0bar_1, act7_1bar_1;

  //--------------------------------------------------------------------------
  // Instantiate Layer 1
  //--------------------------------------------------------------------------
  activation_and_conversion_1 layer1_inst (
    .inputs0_1(inputs0_1), .inputs1_1(inputs1_1), .inputs2_1(inputs2_1), .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1), .inputs5_1(inputs5_1), .inputs6_1(inputs6_1), .inputs7_1(inputs7_1),
    .inputs8_1(inputs8_1), .inputs9_1(inputs9_1), .inputs10_1(inputs10_1), .inputs11_1(inputs11_1),
    .inputs12_1(inputs12_1), .inputs13_1(inputs13_1), .inputs14_1(inputs14_1), .inputs15_1(inputs15_1),

    .w1_0_1(w1_0_1), .w1_1_1(w1_1_1),
    .w2_0_1(w2_0_1), .w2_1_1(w2_1_1),
    .w3_0_1(w3_0_1), .w3_1_1(w3_1_1),
    .w4_0_1(w4_0_1), .w4_1_1(w4_1_1),
    .w5_0_1(w5_0_1), .w5_1_1(w5_1_1),
    .w6_0_1(w6_0_1), .w6_1_1(w6_1_1),
    .w7_0_1(w7_0_1), .w7_1_1(w7_1_1),
    .w8_0_1(w8_0_1), .w8_1_1(w8_1_1),

    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1),
    .b5_1(b5_1), .b6_1(b6_1), .b7_1(b7_1), .b8_1(b8_1),

    // … earlier ports …

    // rename only the port name, keep the signal names as-is
    .r0_0   (r0_0_1), .r1_0   (r1_0_1), .r2_0   (r2_0_1), .r3_0   (r3_0_1),
    .r4_0   (r4_0_1), .r5_0   (r5_0_1), .r6_0   (r6_0_1), .r7_0   (r7_0_1),

    .r0_1   (r0_1_1), .r1_1   (r1_1_1), .r2_1   (r2_1_1), .r3_1   (r3_1_1),
    .r4_1   (r4_1_1), .r5_1   (r5_1_1), .r6_1   (r6_1_1), .r7_1   (r7_1_1),

    .r0_2   (r0_2_1), .r1_2   (r1_2_1), .r2_2   (r2_2_1), .r3_2   (r3_2_1),
    .r4_2   (r4_2_1), .r5_2   (r5_2_1), .r6_2   (r6_2_1), .r7_2   (r7_2_1),

    .r0_3   (r0_3_1), .r1_3   (r1_3_1), .r2_3   (r2_3_1), .r3_3   (r3_3_1),
    .r4_3   (r4_3_1), .r5_3   (r5_3_1), .r6_3   (r6_3_1), .r7_3   (r7_3_1),

    .r0_4   (r0_4_1), .r1_4   (r1_4_1), .r2_4   (r2_4_1), .r3_4   (r3_4_1),
    .r4_4   (r4_4_1), .r5_4   (r5_4_1), .r6_4   (r6_4_1), .r7_4   (r7_4_1),

    .r0_5   (r0_5_1), .r1_5   (r1_5_1), .r2_5   (r2_5_1), .r3_5   (r3_5_1),
    .r4_5   (r4_5_1), .r5_5   (r5_5_1), .r6_5   (r6_5_1), .r7_5   (r7_5_1),

    .r0_6   (r0_6_1), .r1_6   (r1_6_1), .r2_6   (r2_6_1), .r3_6   (r3_6_1),
    .r4_6   (r4_6_1), .r5_6   (r5_6_1), .r6_6   (r6_6_1), .r7_6   (r7_6_1),

    .r0_7   (r0_7_1), .r1_7   (r1_7_1), .r2_7   (r2_7_1), .r3_7   (r3_7_1),
    .r4_7   (r4_7_1), .r5_7   (r5_7_1), .r6_7   (r6_7_1), .r7_7   (r7_7_1),

    // … then continue with the rest of your ports …


    .masked_activation0_1(masked_activation0_1),
    .masked_activation1_1(masked_activation1_1),
    .masked_activation2_1(masked_activation2_1),
    .masked_activation3_1(masked_activation3_1),
    .masked_activation4_1(masked_activation4_1),
    .masked_activation5_1(masked_activation5_1),
    .masked_activation6_1(masked_activation6_1),
    .masked_activation7_1(masked_activation7_1),

    .mask0_1(mask0_1), .mask1_1(mask1_1), .mask2_1(mask2_1), .mask3_1(mask3_1),
    .mask4_1(mask4_1), .mask5_1(mask5_1), .mask6_1(mask6_1), .mask7_1(mask7_1),

    .masked_activation0bar_1(masked_activation0bar_1),
    .masked_activation1bar_1(masked_activation1bar_1),
    .masked_activation2bar_1(masked_activation2bar_1),
    .masked_activation3bar_1(masked_activation3bar_1),
    .masked_activation4bar_1(masked_activation4bar_1),
    .masked_activation5bar_1(masked_activation5bar_1),
    .masked_activation6bar_1(masked_activation6bar_1),
    .masked_activation7bar_1(masked_activation7bar_1),

    .mask0bar_1(mask0bar_1), .mask1bar_1(mask1bar_1),
    .mask2bar_1(mask2bar_1), .mask3bar_1(mask3bar_1),
    .mask4bar_1(mask4bar_1), .mask5bar_1(mask5bar_1),
    .mask6bar_1(mask6bar_1), .mask7bar_1(mask7bar_1),

    .ar0(ar0_1),  .ar0bar(ar0bar_1),
    .ar1(ar1_1),  .ar1bar(ar1bar_1),
    .ar2(ar2_1),  .ar2bar(ar2bar_1),
    .ar3(ar3_1),  .ar3bar(ar3bar_1),
    .ar4(ar4_1),  .ar4bar(ar4bar_1),
    .ar5(ar5_1),  .ar5bar(ar5bar_1),
    .ar6(ar6_1),  .ar6bar(ar6bar_1),
    .ar7(ar7_1),  .ar7bar(ar7bar_1),

    .act0_0_1(act0_0_1),   .act0_1_1(act0_1_1),
    .act0_0bar_1(act0_0bar_1), .act0_1bar_1(act0_1bar_1),
    .act1_0_1(act1_0_1),   .act1_1_1(act1_1_1),
    .act1_0bar_1(act1_0bar_1), .act1_1bar_1(act1_1bar_1),
    .act2_0_1(act2_0_1),   .act2_1_1(act2_1_1),
    .act2_0bar_1(act2_0bar_1), .act2_1bar_1(act2_1bar_1),
    .act3_0_1(act3_0_1),   .act3_1_1(act3_1_1),
    .act3_0bar_1(act3_0bar_1), .act3_1bar_1(act3_1bar_1),
    .act4_0_1(act4_0_1),   .act4_1_1(act4_1_1),
    .act4_0bar_1(act4_0bar_1), .act4_1bar_1(act4_1bar_1),
    .act5_0_1(act5_0_1),   .act5_1_1(act5_1_1),
    .act5_0bar_1(act5_0bar_1), .act5_1bar_1(act5_1bar_1),
    .act6_0_1(act6_0_1),   .act6_1_1(act6_1_1),
    .act6_0bar_1(act6_0bar_1), .act6_1bar_1(act6_1bar_1),
    .act7_0_1(act7_0_1),   .act7_1_1(act7_1_1),
    .act7_0bar_1(act7_0bar_1), .act7_1bar_1(act7_1bar_1)
  );


  //--------------------------------------------------------------------------
  // Layer-2 intermediate nets
  //--------------------------------------------------------------------------

  // r-flow taps
    // layer-2 randomness taps as regs
    reg r0_0_2, r1_0_2, r2_0_2, r3_0_2, r4_0_2, r5_0_2, r6_0_2, r7_0_2, r8_0_2;
    reg r0_1_2, r1_1_2, r2_1_2, r3_1_2, r4_1_2, r5_1_2, r6_1_2, r7_1_2, r8_1_2;
    reg r0_2_2, r1_2_2, r2_2_2, r3_2_2, r4_2_2, r5_2_2, r6_2_2, r7_2_2, r8_2_2;
    reg r0_3_2, r1_3_2, r2_3_2, r3_3_2, r4_3_2, r5_3_2, r6_3_2, r7_3_2, r8_3_2;

initial begin
  // poke them all randomly once at time 0
  { r0_0_2, r1_0_2, r2_0_2, r3_0_2, r4_0_2, r5_0_2, r6_0_2, r7_0_2, r8_0_2 } = $random;
  { r0_1_2, r1_1_2, r2_1_2, r3_1_2, r4_1_2, r5_1_2, r6_1_2, r7_1_2, r8_1_2 } = $random;
  { r0_2_2, r1_2_2, r2_2_2, r3_2_2, r4_2_2, r5_2_2, r6_2_2, r7_2_2, r8_2_2 } = $random;
  { r0_3_2, r1_3_2, r2_3_2, r3_3_2, r4_3_2, r5_3_2, r6_3_2, r7_3_2, r8_3_2 } = $random;
  #1; // let values propagate
end


  // masked Boolean outputs & masks
  wire masked_activation0_2, masked_activation1_2, masked_activation2_2, masked_activation3_2;
  wire masked_activation0bar_2, masked_activation1bar_2, masked_activation2bar_2, masked_activation3bar_2;
  wire mask0_2, mask1_2, mask2_2, mask3_2, mask0bar_2, mask1bar_2, mask2bar_2, mask3bar_2;

  // Boolean→arith randomness
    // layer-2 arithmetic-share randomness taps as regs
    reg  [1:0] ar0_2,  ar0bar_2,  ar1_2,  ar1bar_2,  ar2_2,  ar2bar_2,  ar3_2,  ar3bar_2;

    initial begin
        ar0_2    = $random;  ar0bar_2 = $random;
        ar1_2    = $random;  ar1bar_2 = $random;
        ar2_2    = $random;  ar2bar_2 = $random;
        ar3_2    = $random;  ar3bar_2 = $random;
    #1;
    end



  // Arithmetic shares produced by Layer 2
  wire [2:0] act0_0_2, act0_1_2, act0_0bar_2, act0_1bar_2;
  wire [2:0] act1_0_2, act1_1_2, act1_0bar_2, act1_1bar_2;
  wire [2:0] act2_0_2, act2_1_2, act2_0bar_2, act2_1bar_2;
  wire [2:0] act3_0_2, act3_1_2, act3_0bar_2, act3_1bar_2;


  //--------------------------------------------------------------------------
  // Instantiate Layer 2
  //--------------------------------------------------------------------------

  activation_and_conversion_2 layer2_inst (
    .inputs0_2(act0_0_1),
    .inputs1_2(act0_1_1),
    .inputs2_2(act0_0bar_1),
    .inputs3_2(act0_1bar_1),
    .inputs4_2(act1_0_1),
    .inputs5_2(act1_1_1),
    .inputs6_2(act1_0bar_1),
    .inputs7_2(act1_1bar_1),
    .inputs8_2(act2_0_1),
    .inputs9_2(act2_1_1),
    .inputs10_2(act2_0bar_1),
    .inputs11_2(act2_1bar_1),
    .inputs12_2(act3_0_1),
    .inputs13_2(act3_1_1),
    .inputs14_2(act3_0bar_1),
    .inputs15_2(act3_1bar_1),
    .inputs16_2(act4_0_1),
    .inputs17_2(act4_1_1),
    .inputs18_2(act4_0bar_1),
    .inputs19_2(act4_1bar_1),
    .inputs20_2(act5_0_1),
    .inputs21_2(act5_1_1),
    .inputs22_2(act5_0bar_1),
    .inputs23_2(act5_1bar_1),
    .inputs24_2(act6_0_1),
    .inputs25_2(act6_1_1),
    .inputs26_2(act6_0bar_1),
    .inputs27_2(act6_1bar_1),
    .inputs28_2(act7_0_1),
    .inputs29_2(act7_1_1),
    .inputs30_2(act7_0bar_1),
    .inputs31_2(act7_1bar_1),

    .w1_0_2(w1_0_2), .w1_1_2(w1_1_2),
    .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
    .w3_0_2(w3_0_2), .w3_1_2(w3_1_2),
    .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),

    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2),

    .r0_0(r0_0_2), .r1_0(r1_0_2), .r2_0(r2_0_2),
    .r3_0(r3_0_2), .r4_0(r4_0_2), .r5_0(r5_0_2),
    .r6_0(r6_0_2), .r7_0(r7_0_2), .r8_0(r8_0_2),

    .r0_1(r0_1_2), .r1_1(r1_1_2), .r2_1(r2_1_2),
    .r3_1(r3_1_2), .r4_1(r4_1_2), .r5_1(r5_1_2),
    .r6_1(r6_1_2), .r7_1(r7_1_2), .r8_1(r8_1_2),

    .r0_2(r0_2_2), .r1_2(r1_2_2), .r2_2(r2_2_2),
    .r3_2(r3_2_2), .r4_2(r4_2_2), .r5_2(r5_2_2),
    .r6_2(r6_2_2), .r7_2(r7_2_2), .r8_2(r8_2_2),

    .r0_3(r0_3_2), .r1_3(r1_3_2), .r2_3(r2_3_2),
    .r3_3(r3_3_2), .r4_3(r4_3_2), .r5_3(r5_3_2),
    .r6_3(r6_3_2), .r7_3(r7_3_2), .r8_3(r8_3_2),

    .masked_activation0_2(masked_activation0_2),
    .masked_activation1_2(masked_activation1_2),
    .masked_activation2_2(masked_activation2_2),
    .masked_activation3_2(masked_activation3_2),

    .mask0_2(mask0_2), .mask1_2(mask1_2),
    .mask2_2(mask2_2), .mask3_2(mask3_2),

    .masked_activation0bar_2(masked_activation0bar_2),
    .masked_activation1bar_2(masked_activation1bar_2),
    .masked_activation2bar_2(masked_activation2bar_2),
    .masked_activation3bar_2(masked_activation3bar_2),

    .mask0bar_2(mask0bar_2), .mask1bar_2(mask1bar_2),
    .mask2bar_2(mask2bar_2), .mask3bar_2(mask3bar_2),

    .ar0(ar0_2), .ar0bar(ar0bar_2),
    .ar1(ar1_2), .ar1bar(ar1bar_2),
    .ar2(ar2_2), .ar2bar(ar2bar_2),
    .ar3(ar3_2), .ar3bar(ar3bar_2),

    .act0_0_2(act0_0_2),   .act0_1_2(act0_1_2),
    .act0_0bar_2(act0_0bar_2), .act0_1bar_2(act0_1bar_2),
    .act1_0_2(act1_0_2),   .act1_1_2(act1_1_2),
    .act1_0bar_2(act1_0bar_2), .act1_1bar_2(act1_1bar_2),
    .act2_0_2(act2_0_2),   .act2_1_2(act2_1_2),
    .act2_0bar_2(act2_0bar_2), .act2_1bar_2(act2_1bar_2),
    .act3_0_2(act3_0_2),   .act3_1_2(act3_1_2),
    .act3_0bar_2(act3_0bar_2), .act3_1bar_2(act3_1bar_2)
  );

    //--- expose Layer-3 randomness taps to output_layer_max ---
    reg r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0;
    reg r0_0bar, r1_0bar, r2_0bar, r3_0bar, r4_0bar, r5_0bar, r6_0bar, r7_0bar, r8_0bar;

initial begin
    r0_0    = $random;
    r1_0    = $random;
    r2_0    = $random;
    r3_0    = $random;
    r4_0    = $random;
    r5_0    = $random;
    r6_0    = $random;
    r7_0    = $random;
    r8_0    = $random;

    r0_0bar = $random;
    r1_0bar = $random;
    r2_0bar = $random;
    r3_0bar = $random;
    r4_0bar = $random;
    r5_0bar = $random;
    r6_0bar = $random;
    r7_0bar = $random;
    r8_0bar = $random;

    #1;
    end


    output_layer_max l1 (

        .inputs0_3   (act0_0_2),
        .inputs1_3   (act0_1_2),
        .inputs2_3   (act0_0bar_2),
        .inputs3_3   (act0_1bar_2),
        .inputs4_3   (act1_0_2),
        .inputs5_3   (act1_1_2),
        .inputs6_3   (act1_0bar_2),
        .inputs7_3   (act1_1bar_2),
        .inputs8_3   (act2_0_2),
        .inputs9_3   (act2_1_2),
        .inputs10_3  (act2_0bar_2),
        .inputs11_3  (act2_1bar_2),
        .inputs12_3  (act3_0_2),
        .inputs13_3  (act3_1_2),
        .inputs14_3  (act3_0bar_2),
        .inputs15_3  (act3_1bar_2),

        .w1_0_3(w1_0_3), .w1_1_3(w1_1_3),
        .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),

        .b1_3(b1_3),
        .b2_3(b2_3),   

        .r0_0(r0_0), .r1_0(r1_0), .r2_0(r2_0), .r3_0(r3_0), .r4_0(r4_0), .r5_0(r5_0), .r6_0(r6_0), .r7_0(r7_0), .r8_0(r8_0),  
        .r0_0bar(r0_0bar), .r1_0bar(r1_0bar), .r2_0bar(r2_0bar),
        .r3_0bar(r3_0bar), .r4_0bar(r4_0bar), .r5_0bar(r5_0bar),
        .r6_0bar(r6_0bar), .r7_0bar(r7_0bar), .r8_0bar(r8_0bar),

        .a0(a0),     .a0_bar(a0_bar),
        .a1(a1),     .a1_bar(a1_bar)
    
    );



endmodule

`default_nettype wire

