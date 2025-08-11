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



module adder_tree_1 (
    input  wire [2:0] in0,
    input  wire [2:0] in1,
    input  wire [2:0] in2,
    input  wire [2:0] in3,
    input  wire [2:0] in4,
    input  wire [2:0] in5,
    input  wire [2:0] in6,
    input  wire [2:0] in7,
    output wire [5:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [5:0] stage2_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [5:0] stage2_0;

    add3bit_1 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bit_1 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bit_1 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bit_1 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add4bit_1 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bit_1 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add5bit_1 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage2_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage2_0 = {1'b0, stage2_0_lo};
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
    output wire [5:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [5:0] stage2_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [5:0] stage2_0;

    add3bitbar_1 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bitbar_1 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add4bitbar_1 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bitbar_1 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add5bitbar_1 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage2_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage2_0 = {1'b0, stage2_0_lo};
    end
endmodule


module layer1(
    input [2:0] inputs0_1 , inputs1_1 , inputs2_1 , inputs3_1 , inputs4_1 , inputs5_1 , inputs6_1 , inputs7_1,
    input [7:0] w1_0_1, w1_1_1, w2_0_1, w2_1_1, w3_0_1, w3_1_1, w4_0_1, w4_1_1,
    input [5:0] b1_1, b2_1, b3_1, b4_1,
    output [6:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar
);
    wire [2:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [2:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [2:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [2:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [2:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [2:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [2:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [2:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [2:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [2:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [2:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [2:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [2:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [2:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [2:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [2:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [2:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [2:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [2:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [2:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [2:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [2:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [2:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [2:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [2:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [2:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [2:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [2:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [2:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [2:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [2:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [2:0] weighted_inputs4_7_0, weighted_inputs4_7_1;

    wire [5:0] sum1 [3:0];
    wire [5:0] sum2 [3:0];
    wire [6:0] biased_sum1 [3:0];
    wire [6:0] biased_sum2 [3:0];
    wire [5:0] sum1bar [3:0];
    wire [5:0] sum2bar [3:0];
    wire [6:0] biased_sum1bar [3:0];
    wire [6:0] biased_sum2bar [3:0];
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
    weighted_inputs_1 w8 (.inputs(inputs0_1), .w(w2_0_1[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_1 w8_bar (.inputs(inputs0_1), .w(w2_1_1[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_1 w9 (.inputs(inputs1_1), .w(w2_0_1[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_1 w9_bar (.inputs(inputs1_1), .w(w2_1_1[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_1 w10 (.inputs(inputs2_1), .w(w2_0_1[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_1 w10_bar (.inputs(inputs2_1), .w(w2_1_1[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_1 w11 (.inputs(inputs3_1), .w(w2_0_1[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_1 w11_bar (.inputs(inputs3_1), .w(w2_1_1[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_1 w12 (.inputs(inputs4_1), .w(w2_0_1[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_1 w12_bar (.inputs(inputs4_1), .w(w2_1_1[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_1 w13 (.inputs(inputs5_1), .w(w2_0_1[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_1 w13_bar (.inputs(inputs5_1), .w(w2_1_1[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_1 w14 (.inputs(inputs6_1), .w(w2_0_1[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_1 w14_bar (.inputs(inputs6_1), .w(w2_1_1[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_1 w15 (.inputs(inputs7_1), .w(w2_0_1[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_1 w15_bar (.inputs(inputs7_1), .w(w2_1_1[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_1 w16 (.inputs(inputs0_1), .w(w3_0_1[0]), .wi(weighted_inputs3_0_0));
    weighted_inputs_1 w16_bar (.inputs(inputs0_1), .w(w3_1_1[0]), .wi(weighted_inputs3_0_1));
    weighted_inputs_1 w17 (.inputs(inputs1_1), .w(w3_0_1[1]), .wi(weighted_inputs3_1_0));
    weighted_inputs_1 w17_bar (.inputs(inputs1_1), .w(w3_1_1[1]), .wi(weighted_inputs3_1_1));
    weighted_inputs_1 w18 (.inputs(inputs2_1), .w(w3_0_1[2]), .wi(weighted_inputs3_2_0));
    weighted_inputs_1 w18_bar (.inputs(inputs2_1), .w(w3_1_1[2]), .wi(weighted_inputs3_2_1));
    weighted_inputs_1 w19 (.inputs(inputs3_1), .w(w3_0_1[3]), .wi(weighted_inputs3_3_0));
    weighted_inputs_1 w19_bar (.inputs(inputs3_1), .w(w3_1_1[3]), .wi(weighted_inputs3_3_1));
    weighted_inputs_1 w20 (.inputs(inputs4_1), .w(w3_0_1[4]), .wi(weighted_inputs3_4_0));
    weighted_inputs_1 w20_bar (.inputs(inputs4_1), .w(w3_1_1[4]), .wi(weighted_inputs3_4_1));
    weighted_inputs_1 w21 (.inputs(inputs5_1), .w(w3_0_1[5]), .wi(weighted_inputs3_5_0));
    weighted_inputs_1 w21_bar (.inputs(inputs5_1), .w(w3_1_1[5]), .wi(weighted_inputs3_5_1));
    weighted_inputs_1 w22 (.inputs(inputs6_1), .w(w3_0_1[6]), .wi(weighted_inputs3_6_0));
    weighted_inputs_1 w22_bar (.inputs(inputs6_1), .w(w3_1_1[6]), .wi(weighted_inputs3_6_1));
    weighted_inputs_1 w23 (.inputs(inputs7_1), .w(w3_0_1[7]), .wi(weighted_inputs3_7_0));
    weighted_inputs_1 w23_bar (.inputs(inputs7_1), .w(w3_1_1[7]), .wi(weighted_inputs3_7_1));
    weighted_inputs_1 w24 (.inputs(inputs0_1), .w(w4_0_1[0]), .wi(weighted_inputs4_0_0));
    weighted_inputs_1 w24_bar (.inputs(inputs0_1), .w(w4_1_1[0]), .wi(weighted_inputs4_0_1));
    weighted_inputs_1 w25 (.inputs(inputs1_1), .w(w4_0_1[1]), .wi(weighted_inputs4_1_0));
    weighted_inputs_1 w25_bar (.inputs(inputs1_1), .w(w4_1_1[1]), .wi(weighted_inputs4_1_1));
    weighted_inputs_1 w26 (.inputs(inputs2_1), .w(w4_0_1[2]), .wi(weighted_inputs4_2_0));
    weighted_inputs_1 w26_bar (.inputs(inputs2_1), .w(w4_1_1[2]), .wi(weighted_inputs4_2_1));
    weighted_inputs_1 w27 (.inputs(inputs3_1), .w(w4_0_1[3]), .wi(weighted_inputs4_3_0));
    weighted_inputs_1 w27_bar (.inputs(inputs3_1), .w(w4_1_1[3]), .wi(weighted_inputs4_3_1));
    weighted_inputs_1 w28 (.inputs(inputs4_1), .w(w4_0_1[4]), .wi(weighted_inputs4_4_0));
    weighted_inputs_1 w28_bar (.inputs(inputs4_1), .w(w4_1_1[4]), .wi(weighted_inputs4_4_1));
    weighted_inputs_1 w29 (.inputs(inputs5_1), .w(w4_0_1[5]), .wi(weighted_inputs4_5_0));
    weighted_inputs_1 w29_bar (.inputs(inputs5_1), .w(w4_1_1[5]), .wi(weighted_inputs4_5_1));
    weighted_inputs_1 w30 (.inputs(inputs6_1), .w(w4_0_1[6]), .wi(weighted_inputs4_6_0));
    weighted_inputs_1 w30_bar (.inputs(inputs6_1), .w(w4_1_1[6]), .wi(weighted_inputs4_6_1));
    weighted_inputs_1 w31 (.inputs(inputs7_1), .w(w4_0_1[7]), .wi(weighted_inputs4_7_0));
    weighted_inputs_1 w31_bar (.inputs(inputs7_1), .w(w4_1_1[7]), .wi(weighted_inputs4_7_1));
    adder_tree_1 add0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .sum(sum1[0])
    );
    adder_tree_1 add4(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
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
        .sum(sum1bar[0])
    );
    adder_tree_bar_1 addb4(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
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
        .sum(sum1[1])
    );
    adder_tree_1 add5(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
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
        .sum(sum1bar[1])
    );
    adder_tree_bar_1 addb5(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
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
        .sum(sum1[2])
    );
    adder_tree_1 add6(
        .in0(weighted_inputs3_0_1),
        .in1(weighted_inputs3_1_1),
        .in2(weighted_inputs3_2_1),
        .in3(weighted_inputs3_3_1),
        .in4(weighted_inputs3_4_1),
        .in5(weighted_inputs3_5_1),
        .in6(weighted_inputs3_6_1),
        .in7(weighted_inputs3_7_1),
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
        .sum(sum1bar[2])
    );
    adder_tree_bar_1 addb6(
        .in0(weighted_inputs3_0_1),
        .in1(weighted_inputs3_1_1),
        .in2(weighted_inputs3_2_1),
        .in3(weighted_inputs3_3_1),
        .in4(weighted_inputs3_4_1),
        .in5(weighted_inputs3_5_1),
        .in6(weighted_inputs3_6_1),
        .in7(weighted_inputs3_7_1),
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
        .sum(sum1[3])
    );
    adder_tree_1 add7(
        .in0(weighted_inputs4_0_1),
        .in1(weighted_inputs4_1_1),
        .in2(weighted_inputs4_2_1),
        .in3(weighted_inputs4_3_1),
        .in4(weighted_inputs4_4_1),
        .in5(weighted_inputs4_5_1),
        .in6(weighted_inputs4_6_1),
        .in7(weighted_inputs4_7_1),
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
        .sum(sum1bar[3])
    );
    adder_tree_bar_1 addb7(
        .in0(weighted_inputs4_0_1),
        .in1(weighted_inputs4_1_1),
        .in2(weighted_inputs4_2_1),
        .in3(weighted_inputs4_3_1),
        .in4(weighted_inputs4_4_1),
        .in5(weighted_inputs4_5_1),
        .in6(weighted_inputs4_6_1),
        .in7(weighted_inputs4_7_1),
        .sum(sum2bar[3])
    );
    add6bit_1 u0 (.a(sum1[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1[0]));
    add6bit_1 u4 (.a(sum2[0]), .b(b1_1), .cin(1'b0), .y(biased_sum2[0]));
    add6bitbar_1 ub0 (.a(sum1bar[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1bar[0]));
    add6bitbar_1 ub4 (.a(sum2bar[0]), .b(b1_1), .cin(1'b0), .y(biased_sum2bar[0]));
    add6bit_1 u1 (.a(sum1[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1[1]));
    add6bit_1 u5 (.a(sum2[1]), .b(b2_1), .cin(1'b0), .y(biased_sum2[1]));
    add6bitbar_1 ub1 (.a(sum1bar[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1bar[1]));
    add6bitbar_1 ub5 (.a(sum2bar[1]), .b(b2_1), .cin(1'b0), .y(biased_sum2bar[1]));
    add6bit_1 u2 (.a(sum1[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1[2]));
    add6bit_1 u6 (.a(sum2[2]), .b(b3_1), .cin(1'b0), .y(biased_sum2[2]));
    add6bitbar_1 ub2 (.a(sum1bar[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1bar[2]));
    add6bitbar_1 ub6 (.a(sum2bar[2]), .b(b3_1), .cin(1'b0), .y(biased_sum2bar[2]));
    add6bit_1 u3 (.a(sum1[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1[3]));
    add6bit_1 u7 (.a(sum2[3]), .b(b4_1), .cin(1'b0), .y(biased_sum2[3]));
    add6bitbar_1 ub3 (.a(sum1bar[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1bar[3]));
    add6bitbar_1 ub7 (.a(sum2bar[3]), .b(b4_1), .cin(1'b0), .y(biased_sum2bar[3]));
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
        $display("----- BNN LAYER 1 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b", inputs0_1, inputs1_1, inputs2_1, inputs3_1, inputs4_1, inputs5_1, inputs6_1, inputs7_1);
        $display("Weights0: %b %b %b %b", w1_0_1, w2_0_1, w3_0_1, w4_0_1);
        $display("Weights1: %b %b %b %b", w1_1_1, w2_1_1, w3_1_1, w4_1_1);
        $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
        $display("sum2: %b %b %b %b", sum2[0], sum2[1], sum2[2], sum2[3]);
        $display("sum1bar: %b %b %b %b", sum1bar[0], sum1bar[1], sum1bar[2], sum1bar[3]);
        $display("sum2bar: %b %b %b %b", sum2bar[0], sum2bar[1], sum2bar[2], sum2bar[3]);
        $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
        $display("biased_sum2: %b %b %b %b", biased_sum2[0], biased_sum2[1], biased_sum2[2], biased_sum2[3]);
        $display("biased_sum1bar: %0d %0d %0d %0d", biased_sum1bar[0], biased_sum1bar[1], biased_sum1bar[2], biased_sum1bar[3]);
        $display("biased_sum2bar: %0d %0d %0d %0d", biased_sum2bar[0], biased_sum2bar[1], biased_sum2bar[2], biased_sum2bar[3]);
    end
endmodule


module activation_1 (

    input [6:0] inputs0_0,
    input [6:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6, r7;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0, masked_c6_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0), .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0), .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0), .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0), .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0), .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0), .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));
    lut1 l6 (.a(inputs0_0[6]), .b(inputs0_1[6]), .c_in(masked_c5_0), .r_flow(r6), .r_i(r6_0), .r_out(r7), .c_masked(masked_c6_0));

    wire carry = r7 ^ masked_c6_0;
    wire activation = (carry ^ inputs0_0[6] ^ inputs0_1[6]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r7;
    assign mask = r7;

endmodule

module activation_array_1 (
    input  [6:0] inputs0_0, inputs0_1,
    input  [6:0] inputs1_0, inputs1_1,
    input  [6:0] inputs2_0, inputs2_1,
    input  [6:0] inputs3_0, inputs3_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1, r6_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3, r6_3,
    output wire masked_activation0,
    output wire masked_activation1,
    output wire masked_activation2,
    output wire masked_activation3,
    output wire mask0,
    output wire mask1,
    output wire mask2,
    output wire mask3
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
        .masked_activation(masked_activation3),
        .mask(mask3)
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
  input  wire [7:0] w1_0_1, w1_1_1,
  input  wire [7:0] w2_0_1, w2_1_1,
  input  wire [7:0] w3_0_1, w3_1_1,
  input  wire [7:0] w4_0_1, w4_1_1,
  input  wire [5:0] b1_1, b2_1, b3_1, b4_1,
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
  input wire [1:0] ar0, ar0bar,
  input wire [1:0] ar1, ar1bar,
  input wire [1:0] ar2, ar2bar,
  input wire [1:0] ar3, ar3bar,
  output wire masked_activation0_1, masked_activation0bar_1,
  output wire mask0_1, mask0bar_1,
  output wire masked_activation1_1, masked_activation1bar_1,
  output wire mask1_1, mask1bar_1,
  output wire masked_activation2_1, masked_activation2bar_1,
  output wire mask2_1, mask2bar_1,
  output wire masked_activation3_1, masked_activation3bar_1,
  output wire mask3_1, mask3bar_1,
  output wire [2:0] act0_0_1, act0_1_1,
  output wire [2:0] act0_0bar_1, act0_1bar_1,
  output wire [2:0] act1_0_1, act1_1_1,
  output wire [2:0] act1_0bar_1, act1_1bar_1,
  output wire [2:0] act2_0_1, act2_1_1,
  output wire [2:0] act2_0bar_1, act2_1bar_1,
  output wire [2:0] act3_0_1, act3_1_1,
  output wire [2:0] act3_0bar_1, act3_1bar_1
);

  wire [6:0] biased_sum0_0, biased_sum0_0bar;
  wire [6:0] biased_sum0_1, biased_sum0_1bar;
  wire [6:0] biased_sum1_0, biased_sum1_0bar;
  wire [6:0] biased_sum1_1, biased_sum1_1bar;
  wire [6:0] biased_sum2_0, biased_sum2_0bar;
  wire [6:0] biased_sum2_1, biased_sum2_1bar;
  wire [6:0] biased_sum3_0, biased_sum3_0bar;
  wire [6:0] biased_sum3_1, biased_sum3_1bar;

    layer1 l1 (
    .inputs0_1(inputs0_1),
    .inputs1_1(inputs1_1),
    .inputs2_1(inputs2_1),
    .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1),
    .inputs5_1(inputs5_1),
    .inputs6_1(inputs6_1),
    .inputs7_1(inputs7_1),
    .w1_0_1(w1_0_1), .w1_1_1(w1_1_1),
    .w2_0_1(w2_0_1), .w2_1_1(w2_1_1),
    .w3_0_1(w3_0_1), .w3_1_1(w3_1_1),
    .w4_0_1(w4_0_1), .w4_1_1(w4_1_1),
    .b1_1(b1_1),
    .b2_1(b2_1),
    .b3_1(b3_1),
    .b4_1(b4_1),
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
    .masked_activation0(masked_activation0bar_1),
    .masked_activation1(masked_activation1bar_1),
    .masked_activation2(masked_activation2bar_1),
    .masked_activation3(masked_activation3bar_1),
    .mask0(mask0bar_1),
    .mask1(mask1bar_1),
    .mask2(mask2bar_1),
    .mask3(mask3bar_1)
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

    always @(*) begin
    $display("----- LAYER 1   boolean activations -----");
    $display("masked_activation : %b %b %b %b", masked_activation0_1, masked_activation1_1, masked_activation2_1, masked_activation3_1);
    $display("masked_activationbar : %b %b %b %b", masked_activation0bar_1, masked_activation1bar_1, masked_activation2bar_1, masked_activation3bar_1);
    $display("mask : %b %b %b %b", mask0_1, mask1_1, mask2_1, mask3_1);
    $display("maskbar : %b %b %b %b", mask0bar_1, mask1bar_1, mask2bar_1, mask3bar_1);
  end

  always @(*) begin
    $display("----- LAYER 1  arithmetic activations -----");
    $display("masked_activation_arith : %b %b %b %b", act0_0_1, act1_0_1, act2_0_1, act3_0_1);
    $display("mask_arith : %b %b %b %b", act0_1_1, act1_1_1, act2_1_1, act3_1_1);
    $display("masked_activationbar_arith : %b %b %b %b", act0_0bar_1, act1_0bar_1, act2_0bar_1, act3_0bar_1);
    $display("mask_arithbar : %b %b %b %b", act0_1bar_1, act1_1bar_1, act2_1bar_1, act3_1bar_1);
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



module adder_tree_2 (
    input  wire [2:0] in0,
    input  wire [2:0] in1,
    input  wire [2:0] in2,
    input  wire [2:0] in3,
    input  wire [2:0] in4,
    input  wire [2:0] in5,
    input  wire [2:0] in6,
    input  wire [2:0] in7,
    output wire [5:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [5:0] stage2_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [5:0] stage2_0;

    add3bit_2 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bit_2 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bit_2 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bit_2 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add4bit_2 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bit_2 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add5bit_2 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage2_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage2_0 = {1'b0, stage2_0_lo};
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
    output wire [5:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [5:0] stage2_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [5:0] stage2_0;

    add3bitbar_2 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bitbar_2 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bitbar_2 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add5bitbar_2 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage2_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage2_0 = {1'b0, stage2_0_lo};
    end
endmodule


module layer2(
    input [2:0] inputs0_2 , inputs1_2 , inputs2_2 , inputs3_2 , inputs4_2 , inputs5_2 , inputs6_2 , inputs7_2,
    input [7:0] w1_0_2, w1_1_2, w2_0_2, w2_1_2, w3_0_2, w3_1_2, w4_0_2, w4_1_2,
    input [5:0] b1_2, b2_2, b3_2, b4_2,
    output [6:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar
);
    wire [2:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [2:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [2:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [2:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [2:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [2:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [2:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [2:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [2:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [2:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [2:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [2:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [2:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [2:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [2:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [2:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [2:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [2:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [2:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [2:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [2:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [2:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [2:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [2:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [2:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [2:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [2:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [2:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [2:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [2:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [2:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [2:0] weighted_inputs4_7_0, weighted_inputs4_7_1;

    wire [5:0] sum1 [3:0];
    wire [5:0] sum2 [3:0];
    wire [6:0] biased_sum1 [3:0];
    wire [6:0] biased_sum2 [3:0];
    wire [5:0] sum1bar [3:0];
    wire [5:0] sum2bar [3:0];
    wire [6:0] biased_sum1bar [3:0];
    wire [6:0] biased_sum2bar [3:0];
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
    weighted_inputs_1 w8 (.inputs(inputs0_2), .w(w2_0_2[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_1 w8_bar (.inputs(inputs0_2), .w(w2_1_2[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_1 w9 (.inputs(inputs1_2), .w(w2_0_2[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_1 w9_bar (.inputs(inputs1_2), .w(w2_1_2[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_1 w10 (.inputs(inputs2_2), .w(w2_0_2[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_1 w10_bar (.inputs(inputs2_2), .w(w2_1_2[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_1 w11 (.inputs(inputs3_2), .w(w2_0_2[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_1 w11_bar (.inputs(inputs3_2), .w(w2_1_2[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_1 w12 (.inputs(inputs4_2), .w(w2_0_2[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_1 w12_bar (.inputs(inputs4_2), .w(w2_1_2[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_1 w13 (.inputs(inputs5_2), .w(w2_0_2[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_1 w13_bar (.inputs(inputs5_2), .w(w2_1_2[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_1 w14 (.inputs(inputs6_2), .w(w2_0_2[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_1 w14_bar (.inputs(inputs6_2), .w(w2_1_2[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_1 w15 (.inputs(inputs7_2), .w(w2_0_2[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_1 w15_bar (.inputs(inputs7_2), .w(w2_1_2[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_1 w16 (.inputs(inputs0_2), .w(w3_0_2[0]), .wi(weighted_inputs3_0_0));
    weighted_inputs_1 w16_bar (.inputs(inputs0_2), .w(w3_1_2[0]), .wi(weighted_inputs3_0_1));
    weighted_inputs_1 w17 (.inputs(inputs1_2), .w(w3_0_2[1]), .wi(weighted_inputs3_1_0));
    weighted_inputs_1 w17_bar (.inputs(inputs1_2), .w(w3_1_2[1]), .wi(weighted_inputs3_1_1));
    weighted_inputs_1 w18 (.inputs(inputs2_2), .w(w3_0_2[2]), .wi(weighted_inputs3_2_0));
    weighted_inputs_1 w18_bar (.inputs(inputs2_2), .w(w3_1_2[2]), .wi(weighted_inputs3_2_1));
    weighted_inputs_1 w19 (.inputs(inputs3_2), .w(w3_0_2[3]), .wi(weighted_inputs3_3_0));
    weighted_inputs_1 w19_bar (.inputs(inputs3_2), .w(w3_1_2[3]), .wi(weighted_inputs3_3_1));
    weighted_inputs_1 w20 (.inputs(inputs4_2), .w(w3_0_2[4]), .wi(weighted_inputs3_4_0));
    weighted_inputs_1 w20_bar (.inputs(inputs4_2), .w(w3_1_2[4]), .wi(weighted_inputs3_4_1));
    weighted_inputs_1 w21 (.inputs(inputs5_2), .w(w3_0_2[5]), .wi(weighted_inputs3_5_0));
    weighted_inputs_1 w21_bar (.inputs(inputs5_2), .w(w3_1_2[5]), .wi(weighted_inputs3_5_1));
    weighted_inputs_1 w22 (.inputs(inputs6_2), .w(w3_0_2[6]), .wi(weighted_inputs3_6_0));
    weighted_inputs_1 w22_bar (.inputs(inputs6_2), .w(w3_1_2[6]), .wi(weighted_inputs3_6_1));
    weighted_inputs_1 w23 (.inputs(inputs7_2), .w(w3_0_2[7]), .wi(weighted_inputs3_7_0));
    weighted_inputs_1 w23_bar (.inputs(inputs7_2), .w(w3_1_2[7]), .wi(weighted_inputs3_7_1));
    weighted_inputs_1 w24 (.inputs(inputs0_2), .w(w4_0_2[0]), .wi(weighted_inputs4_0_0));
    weighted_inputs_1 w24_bar (.inputs(inputs0_2), .w(w4_1_2[0]), .wi(weighted_inputs4_0_1));
    weighted_inputs_1 w25 (.inputs(inputs1_2), .w(w4_0_2[1]), .wi(weighted_inputs4_1_0));
    weighted_inputs_1 w25_bar (.inputs(inputs1_2), .w(w4_1_2[1]), .wi(weighted_inputs4_1_1));
    weighted_inputs_1 w26 (.inputs(inputs2_2), .w(w4_0_2[2]), .wi(weighted_inputs4_2_0));
    weighted_inputs_1 w26_bar (.inputs(inputs2_2), .w(w4_1_2[2]), .wi(weighted_inputs4_2_1));
    weighted_inputs_1 w27 (.inputs(inputs3_2), .w(w4_0_2[3]), .wi(weighted_inputs4_3_0));
    weighted_inputs_1 w27_bar (.inputs(inputs3_2), .w(w4_1_2[3]), .wi(weighted_inputs4_3_1));
    weighted_inputs_1 w28 (.inputs(inputs4_2), .w(w4_0_2[4]), .wi(weighted_inputs4_4_0));
    weighted_inputs_1 w28_bar (.inputs(inputs4_2), .w(w4_1_2[4]), .wi(weighted_inputs4_4_1));
    weighted_inputs_1 w29 (.inputs(inputs5_2), .w(w4_0_2[5]), .wi(weighted_inputs4_5_0));
    weighted_inputs_1 w29_bar (.inputs(inputs5_2), .w(w4_1_2[5]), .wi(weighted_inputs4_5_1));
    weighted_inputs_1 w30 (.inputs(inputs6_2), .w(w4_0_2[6]), .wi(weighted_inputs4_6_0));
    weighted_inputs_1 w30_bar (.inputs(inputs6_2), .w(w4_1_2[6]), .wi(weighted_inputs4_6_1));
    weighted_inputs_1 w31 (.inputs(inputs7_2), .w(w4_0_2[7]), .wi(weighted_inputs4_7_0));
    weighted_inputs_1 w31_bar (.inputs(inputs7_2), .w(w4_1_2[7]), .wi(weighted_inputs4_7_1));
    adder_tree_2 add0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
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
        .sum(sum2bar[3])
    );
    add6bit_2 u0 (.a(sum1[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1[0]));
    add6bit_2 u4 (.a(sum2[0]), .b(b1_2), .cin(1'b0), .y(biased_sum2[0]));
    add6bitbar_2 ub0 (.a(sum1bar[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1bar[0]));
    add6bitbar_2 ub4 (.a(sum2bar[0]), .b(b1_2), .cin(1'b0), .y(biased_sum2bar[0]));
    add6bit_2 u1 (.a(sum1[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1[1]));
    add6bit_2 u5 (.a(sum2[1]), .b(b2_2), .cin(1'b0), .y(biased_sum2[1]));
    add6bitbar_2 ub1 (.a(sum1bar[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1bar[1]));
    add6bitbar_2 ub5 (.a(sum2bar[1]), .b(b2_2), .cin(1'b0), .y(biased_sum2bar[1]));
    add6bit_2 u2 (.a(sum1[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1[2]));
    add6bit_2 u6 (.a(sum2[2]), .b(b3_2), .cin(1'b0), .y(biased_sum2[2]));
    add6bitbar_2 ub2 (.a(sum1bar[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1bar[2]));
    add6bitbar_2 ub6 (.a(sum2bar[2]), .b(b3_2), .cin(1'b0), .y(biased_sum2bar[2]));
    add6bit_2 u3 (.a(sum1[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1[3]));
    add6bit_2 u7 (.a(sum2[3]), .b(b4_2), .cin(1'b0), .y(biased_sum2[3]));
    add6bitbar_2 ub3 (.a(sum1bar[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1bar[3]));
    add6bitbar_2 ub7 (.a(sum2bar[3]), .b(b4_2), .cin(1'b0), .y(biased_sum2bar[3]));
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
        $display("Inputs : %b %b %b %b %b %b %b %b", inputs0_2, inputs1_2, inputs2_2, inputs3_2, inputs4_2, inputs5_2, inputs6_2, inputs7_2);
        $display("Weights0: %b %b %b %b", w1_0_2, w2_0_2, w3_0_2, w4_0_2);
        $display("Weights1: %b %b %b %b", w1_1_2, w2_1_2, w3_1_2, w4_1_2);
        $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
        $display("sum2: %b %b %b %b", sum2[0], sum2[1], sum2[2], sum2[3]);
        $display("sum1bar: %b %b %b %b", sum1bar[0], sum1bar[1], sum1bar[2], sum1bar[3]);
        $display("sum2bar: %b %b %b %b", sum2bar[0], sum2bar[1], sum2bar[2], sum2bar[3]);
        $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
        $display("biased_sum2: %b %b %b %b", biased_sum2[0], biased_sum2[1], biased_sum2[2], biased_sum2[3]);
        $display("biased_sum1bar: %0d %0d %0d %0d", biased_sum1bar[0], biased_sum1bar[1], biased_sum1bar[2], biased_sum1bar[3]);
        $display("biased_sum2bar: %0d %0d %0d %0d", biased_sum2bar[0], biased_sum2bar[1], biased_sum2bar[2], biased_sum2bar[3]);
    end
endmodule


module activation_2 (

    input [6:0] inputs0_0,
    input [6:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6, r7;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0, masked_c6_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0), .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0), .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0), .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0), .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0), .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0), .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));
    lut1 l6 (.a(inputs0_0[6]), .b(inputs0_1[6]), .c_in(masked_c5_0), .r_flow(r6), .r_i(r6_0), .r_out(r7), .c_masked(masked_c6_0));

    wire carry = r7 ^ masked_c6_0;
    wire activation = (carry ^ inputs0_0[6] ^ inputs0_1[6]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r7;
    assign mask = r7;

endmodule

module activation_array_2 (
    input  [6:0] inputs0_0, inputs0_1,
    input  [6:0] inputs1_0, inputs1_1,
    input  [6:0] inputs2_0, inputs2_1,
    input  [6:0] inputs3_0, inputs3_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1, r6_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3, r6_3,
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
  input  wire [7:0] w1_0_2, w1_1_2,
  input  wire [7:0] w2_0_2, w2_1_2,
  input  wire [7:0] w3_0_2, w3_1_2,
  input  wire [7:0] w4_0_2, w4_1_2,
  input  wire [5:0] b1_2, b2_2, b3_2, b4_2,
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

  wire [6:0] biased_sum0_0, biased_sum0_0bar;
  wire [6:0] biased_sum0_1, biased_sum0_1bar;
  wire [6:0] biased_sum1_0, biased_sum1_0bar;
  wire [6:0] biased_sum1_1, biased_sum1_1bar;
  wire [6:0] biased_sum2_0, biased_sum2_0bar;
  wire [6:0] biased_sum2_1, biased_sum2_1bar;
  wire [6:0] biased_sum3_0, biased_sum3_0bar;
  wire [6:0] biased_sum3_1, biased_sum3_1bar;

    layer2 l1 (
    .inputs0_2(inputs0_2),
    .inputs1_2(inputs1_2),
    .inputs2_2(inputs2_2),
    .inputs3_2(inputs3_2),
    .inputs4_2(inputs4_2),
    .inputs5_2(inputs5_2),
    .inputs6_2(inputs6_2),
    .inputs7_2(inputs7_2),
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



module adder_tree_3 (
    input  wire [2:0] in0,
    input  wire [2:0] in1,
    input  wire [2:0] in2,
    input  wire [2:0] in3,
    input  wire [2:0] in4,
    input  wire [2:0] in5,
    input  wire [2:0] in6,
    input  wire [2:0] in7,
    output wire [5:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [5:0] stage2_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [5:0] stage2_0;

    add3bit_3 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bit_3 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bit_3 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bit_3 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add4bit_3 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bit_3 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add5bit_3 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage2_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage2_0 = {1'b0, stage2_0_lo};
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
    output wire [5:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [5:0] stage2_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [5:0] stage2_0;

    add3bitbar_3 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bitbar_3 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add4bitbar_3 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bitbar_3 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add5bitbar_3 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage2_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage2_0 = {1'b0, stage2_0_lo};
    end
endmodule


module layer3(
    input [2:0] inputs0_3 , inputs1_3 , inputs2_3 , inputs3_3 , inputs4_3 , inputs5_3 , inputs6_3 , inputs7_3,
    input [7:0] w1_0_3, w1_1_3, w2_0_3, w2_1_3, w3_0_3, w3_1_3, w4_0_3, w4_1_3,
    input [5:0] b1_3, b2_3, b3_3, b4_3,
    output [6:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar
);
    wire [2:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [2:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [2:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [2:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [2:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [2:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [2:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [2:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [2:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [2:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [2:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [2:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [2:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [2:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [2:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [2:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [2:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [2:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [2:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [2:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [2:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [2:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [2:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [2:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [2:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [2:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [2:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [2:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [2:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [2:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [2:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [2:0] weighted_inputs4_7_0, weighted_inputs4_7_1;

    wire [5:0] sum1 [3:0];
    wire [5:0] sum2 [3:0];
    wire [6:0] biased_sum1 [3:0];
    wire [6:0] biased_sum2 [3:0];
    wire [5:0] sum1bar [3:0];
    wire [5:0] sum2bar [3:0];
    wire [6:0] biased_sum1bar [3:0];
    wire [6:0] biased_sum2bar [3:0];
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
    weighted_inputs_1 w8 (.inputs(inputs0_3), .w(w2_0_3[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_1 w8_bar (.inputs(inputs0_3), .w(w2_1_3[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_1 w9 (.inputs(inputs1_3), .w(w2_0_3[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_1 w9_bar (.inputs(inputs1_3), .w(w2_1_3[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_1 w10 (.inputs(inputs2_3), .w(w2_0_3[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_1 w10_bar (.inputs(inputs2_3), .w(w2_1_3[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_1 w11 (.inputs(inputs3_3), .w(w2_0_3[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_1 w11_bar (.inputs(inputs3_3), .w(w2_1_3[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_1 w12 (.inputs(inputs4_3), .w(w2_0_3[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_1 w12_bar (.inputs(inputs4_3), .w(w2_1_3[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_1 w13 (.inputs(inputs5_3), .w(w2_0_3[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_1 w13_bar (.inputs(inputs5_3), .w(w2_1_3[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_1 w14 (.inputs(inputs6_3), .w(w2_0_3[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_1 w14_bar (.inputs(inputs6_3), .w(w2_1_3[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_1 w15 (.inputs(inputs7_3), .w(w2_0_3[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_1 w15_bar (.inputs(inputs7_3), .w(w2_1_3[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_1 w16 (.inputs(inputs0_3), .w(w3_0_3[0]), .wi(weighted_inputs3_0_0));
    weighted_inputs_1 w16_bar (.inputs(inputs0_3), .w(w3_1_3[0]), .wi(weighted_inputs3_0_1));
    weighted_inputs_1 w17 (.inputs(inputs1_3), .w(w3_0_3[1]), .wi(weighted_inputs3_1_0));
    weighted_inputs_1 w17_bar (.inputs(inputs1_3), .w(w3_1_3[1]), .wi(weighted_inputs3_1_1));
    weighted_inputs_1 w18 (.inputs(inputs2_3), .w(w3_0_3[2]), .wi(weighted_inputs3_2_0));
    weighted_inputs_1 w18_bar (.inputs(inputs2_3), .w(w3_1_3[2]), .wi(weighted_inputs3_2_1));
    weighted_inputs_1 w19 (.inputs(inputs3_3), .w(w3_0_3[3]), .wi(weighted_inputs3_3_0));
    weighted_inputs_1 w19_bar (.inputs(inputs3_3), .w(w3_1_3[3]), .wi(weighted_inputs3_3_1));
    weighted_inputs_1 w20 (.inputs(inputs4_3), .w(w3_0_3[4]), .wi(weighted_inputs3_4_0));
    weighted_inputs_1 w20_bar (.inputs(inputs4_3), .w(w3_1_3[4]), .wi(weighted_inputs3_4_1));
    weighted_inputs_1 w21 (.inputs(inputs5_3), .w(w3_0_3[5]), .wi(weighted_inputs3_5_0));
    weighted_inputs_1 w21_bar (.inputs(inputs5_3), .w(w3_1_3[5]), .wi(weighted_inputs3_5_1));
    weighted_inputs_1 w22 (.inputs(inputs6_3), .w(w3_0_3[6]), .wi(weighted_inputs3_6_0));
    weighted_inputs_1 w22_bar (.inputs(inputs6_3), .w(w3_1_3[6]), .wi(weighted_inputs3_6_1));
    weighted_inputs_1 w23 (.inputs(inputs7_3), .w(w3_0_3[7]), .wi(weighted_inputs3_7_0));
    weighted_inputs_1 w23_bar (.inputs(inputs7_3), .w(w3_1_3[7]), .wi(weighted_inputs3_7_1));
    weighted_inputs_1 w24 (.inputs(inputs0_3), .w(w4_0_3[0]), .wi(weighted_inputs4_0_0));
    weighted_inputs_1 w24_bar (.inputs(inputs0_3), .w(w4_1_3[0]), .wi(weighted_inputs4_0_1));
    weighted_inputs_1 w25 (.inputs(inputs1_3), .w(w4_0_3[1]), .wi(weighted_inputs4_1_0));
    weighted_inputs_1 w25_bar (.inputs(inputs1_3), .w(w4_1_3[1]), .wi(weighted_inputs4_1_1));
    weighted_inputs_1 w26 (.inputs(inputs2_3), .w(w4_0_3[2]), .wi(weighted_inputs4_2_0));
    weighted_inputs_1 w26_bar (.inputs(inputs2_3), .w(w4_1_3[2]), .wi(weighted_inputs4_2_1));
    weighted_inputs_1 w27 (.inputs(inputs3_3), .w(w4_0_3[3]), .wi(weighted_inputs4_3_0));
    weighted_inputs_1 w27_bar (.inputs(inputs3_3), .w(w4_1_3[3]), .wi(weighted_inputs4_3_1));
    weighted_inputs_1 w28 (.inputs(inputs4_3), .w(w4_0_3[4]), .wi(weighted_inputs4_4_0));
    weighted_inputs_1 w28_bar (.inputs(inputs4_3), .w(w4_1_3[4]), .wi(weighted_inputs4_4_1));
    weighted_inputs_1 w29 (.inputs(inputs5_3), .w(w4_0_3[5]), .wi(weighted_inputs4_5_0));
    weighted_inputs_1 w29_bar (.inputs(inputs5_3), .w(w4_1_3[5]), .wi(weighted_inputs4_5_1));
    weighted_inputs_1 w30 (.inputs(inputs6_3), .w(w4_0_3[6]), .wi(weighted_inputs4_6_0));
    weighted_inputs_1 w30_bar (.inputs(inputs6_3), .w(w4_1_3[6]), .wi(weighted_inputs4_6_1));
    weighted_inputs_1 w31 (.inputs(inputs7_3), .w(w4_0_3[7]), .wi(weighted_inputs4_7_0));
    weighted_inputs_1 w31_bar (.inputs(inputs7_3), .w(w4_1_3[7]), .wi(weighted_inputs4_7_1));
    adder_tree_3 add0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .sum(sum1[0])
    );
    adder_tree_3 add4(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
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
        .sum(sum1bar[0])
    );
    adder_tree_bar_3 addb4(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
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
        .sum(sum1[1])
    );
    adder_tree_3 add5(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
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
        .sum(sum1bar[1])
    );
    adder_tree_bar_3 addb5(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .sum(sum2bar[1])
    );
    adder_tree_3 add2(
        .in0(weighted_inputs3_0_0),
        .in1(weighted_inputs3_1_0),
        .in2(weighted_inputs3_2_0),
        .in3(weighted_inputs3_3_0),
        .in4(weighted_inputs3_4_0),
        .in5(weighted_inputs3_5_0),
        .in6(weighted_inputs3_6_0),
        .in7(weighted_inputs3_7_0),
        .sum(sum1[2])
    );
    adder_tree_3 add6(
        .in0(weighted_inputs3_0_1),
        .in1(weighted_inputs3_1_1),
        .in2(weighted_inputs3_2_1),
        .in3(weighted_inputs3_3_1),
        .in4(weighted_inputs3_4_1),
        .in5(weighted_inputs3_5_1),
        .in6(weighted_inputs3_6_1),
        .in7(weighted_inputs3_7_1),
        .sum(sum2[2])
    );
    adder_tree_bar_3 addb2(
        .in0(weighted_inputs3_0_0),
        .in1(weighted_inputs3_1_0),
        .in2(weighted_inputs3_2_0),
        .in3(weighted_inputs3_3_0),
        .in4(weighted_inputs3_4_0),
        .in5(weighted_inputs3_5_0),
        .in6(weighted_inputs3_6_0),
        .in7(weighted_inputs3_7_0),
        .sum(sum1bar[2])
    );
    adder_tree_bar_3 addb6(
        .in0(weighted_inputs3_0_1),
        .in1(weighted_inputs3_1_1),
        .in2(weighted_inputs3_2_1),
        .in3(weighted_inputs3_3_1),
        .in4(weighted_inputs3_4_1),
        .in5(weighted_inputs3_5_1),
        .in6(weighted_inputs3_6_1),
        .in7(weighted_inputs3_7_1),
        .sum(sum2bar[2])
    );
    adder_tree_3 add3(
        .in0(weighted_inputs4_0_0),
        .in1(weighted_inputs4_1_0),
        .in2(weighted_inputs4_2_0),
        .in3(weighted_inputs4_3_0),
        .in4(weighted_inputs4_4_0),
        .in5(weighted_inputs4_5_0),
        .in6(weighted_inputs4_6_0),
        .in7(weighted_inputs4_7_0),
        .sum(sum1[3])
    );
    adder_tree_3 add7(
        .in0(weighted_inputs4_0_1),
        .in1(weighted_inputs4_1_1),
        .in2(weighted_inputs4_2_1),
        .in3(weighted_inputs4_3_1),
        .in4(weighted_inputs4_4_1),
        .in5(weighted_inputs4_5_1),
        .in6(weighted_inputs4_6_1),
        .in7(weighted_inputs4_7_1),
        .sum(sum2[3])
    );
    adder_tree_bar_3 addb3(
        .in0(weighted_inputs4_0_0),
        .in1(weighted_inputs4_1_0),
        .in2(weighted_inputs4_2_0),
        .in3(weighted_inputs4_3_0),
        .in4(weighted_inputs4_4_0),
        .in5(weighted_inputs4_5_0),
        .in6(weighted_inputs4_6_0),
        .in7(weighted_inputs4_7_0),
        .sum(sum1bar[3])
    );
    adder_tree_bar_3 addb7(
        .in0(weighted_inputs4_0_1),
        .in1(weighted_inputs4_1_1),
        .in2(weighted_inputs4_2_1),
        .in3(weighted_inputs4_3_1),
        .in4(weighted_inputs4_4_1),
        .in5(weighted_inputs4_5_1),
        .in6(weighted_inputs4_6_1),
        .in7(weighted_inputs4_7_1),
        .sum(sum2bar[3])
    );
    add6bit_3 u0 (.a(sum1[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1[0]));
    add6bit_3 u4 (.a(sum2[0]), .b(b1_3), .cin(1'b0), .y(biased_sum2[0]));
    add6bitbar_3 ub0 (.a(sum1bar[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1bar[0]));
    add6bitbar_3 ub4 (.a(sum2bar[0]), .b(b1_3), .cin(1'b0), .y(biased_sum2bar[0]));
    add6bit_3 u1 (.a(sum1[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1[1]));
    add6bit_3 u5 (.a(sum2[1]), .b(b2_3), .cin(1'b0), .y(biased_sum2[1]));
    add6bitbar_3 ub1 (.a(sum1bar[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1bar[1]));
    add6bitbar_3 ub5 (.a(sum2bar[1]), .b(b2_3), .cin(1'b0), .y(biased_sum2bar[1]));
    add6bit_3 u2 (.a(sum1[2]), .b(b3_3), .cin(1'b0), .y(biased_sum1[2]));
    add6bit_3 u6 (.a(sum2[2]), .b(b3_3), .cin(1'b0), .y(biased_sum2[2]));
    add6bitbar_3 ub2 (.a(sum1bar[2]), .b(b3_3), .cin(1'b0), .y(biased_sum1bar[2]));
    add6bitbar_3 ub6 (.a(sum2bar[2]), .b(b3_3), .cin(1'b0), .y(biased_sum2bar[2]));
    add6bit_3 u3 (.a(sum1[3]), .b(b4_3), .cin(1'b0), .y(biased_sum1[3]));
    add6bit_3 u7 (.a(sum2[3]), .b(b4_3), .cin(1'b0), .y(biased_sum2[3]));
    add6bitbar_3 ub3 (.a(sum1bar[3]), .b(b4_3), .cin(1'b0), .y(biased_sum1bar[3]));
    add6bitbar_3 ub7 (.a(sum2bar[3]), .b(b4_3), .cin(1'b0), .y(biased_sum2bar[3]));
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
        $display("----- BNN LAYER 3 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b", inputs0_3, inputs1_3, inputs2_3, inputs3_3, inputs4_3, inputs5_3, inputs6_3, inputs7_3);
        $display("Weights0: %b %b %b %b", w1_0_3, w2_0_3, w3_0_3, w4_0_3);
        $display("Weights1: %b %b %b %b", w1_1_3, w2_1_3, w3_1_3, w4_1_3);
        $display("sum1: %b %b %b %b", sum1[0], sum1[1], sum1[2], sum1[3]);
        $display("sum2: %b %b %b %b", sum2[0], sum2[1], sum2[2], sum2[3]);
        $display("sum1bar: %b %b %b %b", sum1bar[0], sum1bar[1], sum1bar[2], sum1bar[3]);
        $display("sum2bar: %b %b %b %b", sum2bar[0], sum2bar[1], sum2bar[2], sum2bar[3]);
        $display("biased_sum1: %b %b %b %b", biased_sum1[0], biased_sum1[1], biased_sum1[2], biased_sum1[3]);
        $display("biased_sum2: %b %b %b %b", biased_sum2[0], biased_sum2[1], biased_sum2[2], biased_sum2[3]);
        $display("biased_sum1bar: %0d %0d %0d %0d", biased_sum1bar[0], biased_sum1bar[1], biased_sum1bar[2], biased_sum1bar[3]);
        $display("biased_sum2bar: %0d %0d %0d %0d", biased_sum2bar[0], biased_sum2bar[1], biased_sum2bar[2], biased_sum2bar[3]);
    end
endmodule


module activation_3 (

    input [6:0] inputs0_0,
    input [6:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6, r7;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0, masked_c6_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0), .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0), .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0), .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0), .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0), .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0), .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));
    lut1 l6 (.a(inputs0_0[6]), .b(inputs0_1[6]), .c_in(masked_c5_0), .r_flow(r6), .r_i(r6_0), .r_out(r7), .c_masked(masked_c6_0));

    wire carry = r7 ^ masked_c6_0;
    wire activation = (carry ^ inputs0_0[6] ^ inputs0_1[6]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r7;
    assign mask = r7;

endmodule

module activation_array_3 (
    input  [6:0] inputs0_0, inputs0_1,
    input  [6:0] inputs1_0, inputs1_1,
    input  [6:0] inputs2_0, inputs2_1,
    input  [6:0] inputs3_0, inputs3_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1, r6_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3, r6_3,
    output wire masked_activation0,
    output wire masked_activation1,
    output wire masked_activation2,
    output wire masked_activation3,
    output wire mask0,
    output wire mask1,
    output wire mask2,
    output wire mask3
);

    activation_3 a0 (
        .inputs0_0(inputs0_0), .inputs0_1(inputs0_1),
        .r0_0(r0_0),
        .r1_0(r1_0),
        .r2_0(r2_0),
        .r3_0(r3_0),
        .r4_0(r4_0),
        .r5_0(r5_0),
        .r6_0(r6_0),
        .masked_activation(masked_activation0),
        .mask(mask0)
    );

    activation_3 a1 (
        .inputs0_0(inputs1_0), .inputs0_1(inputs1_1),
        .r0_0(r0_1),
        .r1_0(r1_1),
        .r2_0(r2_1),
        .r3_0(r3_1),
        .r4_0(r4_1),
        .r5_0(r5_1),
        .r6_0(r6_1),
        .masked_activation(masked_activation1),
        .mask(mask1)
    );

    activation_3 a2 (
        .inputs0_0(inputs2_0), .inputs0_1(inputs2_1),
        .r0_0(r0_2),
        .r1_0(r1_2),
        .r2_0(r2_2),
        .r3_0(r3_2),
        .r4_0(r4_2),
        .r5_0(r5_2),
        .r6_0(r6_2),
        .masked_activation(masked_activation2),
        .mask(mask2)
    );

    activation_3 a3 (
        .inputs0_0(inputs3_0), .inputs0_1(inputs3_1),
        .r0_0(r0_3),
        .r1_0(r1_3),
        .r2_0(r2_3),
        .r3_0(r3_3),
        .r4_0(r4_3),
        .r5_0(r5_3),
        .r6_0(r6_3),
        .masked_activation(masked_activation3),
        .mask(mask3)
    );

endmodule

`timescale 1ns/1ps

module mux_3 (

    input  wire a, b, s,

    output wire y
);

assign y = (~s & a)|(s & b);
endmodule


module boolean_arithmetic_coversion_3 (

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


    mux_3 m1(.a(y0[1]), .b(y1[0] ^ y0[1]), .s(arith_share0[0]), .y(arith_share0[1]));

    mux_3 m2(.a(y0[1] ^ y0[2]), .b(y0[2] ^ y1[1]), .s(arith_share0[1]), .y(arith_share0[2]));


    assign arith_share1 = y1;

endmodule




module activation_and_conversion_3(
  input  wire [2:0] inputs0_3,
  input  wire [2:0] inputs1_3,
  input  wire [2:0] inputs2_3,
  input  wire [2:0] inputs3_3,
  input  wire [2:0] inputs4_3,
  input  wire [2:0] inputs5_3,
  input  wire [2:0] inputs6_3,
  input  wire [2:0] inputs7_3,
  input  wire [7:0] w1_0_3, w1_1_3,
  input  wire [7:0] w2_0_3, w2_1_3,
  input  wire [7:0] w3_0_3, w3_1_3,
  input  wire [7:0] w4_0_3, w4_1_3,
  input  wire [5:0] b1_3, b2_3, b3_3, b4_3,
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
  input wire [1:0] ar0, ar0bar,
  input wire [1:0] ar1, ar1bar,
  input wire [1:0] ar2, ar2bar,
  input wire [1:0] ar3, ar3bar,
  output wire masked_activation0_3, masked_activation0bar_3,
  output wire mask0_3, mask0bar_3,
  output wire masked_activation1_3, masked_activation1bar_3,
  output wire mask1_3, mask1bar_3,
  output wire masked_activation2_3, masked_activation2bar_3,
  output wire mask2_3, mask2bar_3,
  output wire masked_activation3_3, masked_activation3bar_3,
  output wire mask3_3, mask3bar_3,
  output wire [2:0] act0_0_3, act0_1_3,
  output wire [2:0] act0_0bar_3, act0_1bar_3,
  output wire [2:0] act1_0_3, act1_1_3,
  output wire [2:0] act1_0bar_3, act1_1bar_3,
  output wire [2:0] act2_0_3, act2_1_3,
  output wire [2:0] act2_0bar_3, act2_1bar_3,
  output wire [2:0] act3_0_3, act3_1_3,
  output wire [2:0] act3_0bar_3, act3_1bar_3
);

  wire [6:0] biased_sum0_0, biased_sum0_0bar;
  wire [6:0] biased_sum0_1, biased_sum0_1bar;
  wire [6:0] biased_sum1_0, biased_sum1_0bar;
  wire [6:0] biased_sum1_1, biased_sum1_1bar;
  wire [6:0] biased_sum2_0, biased_sum2_0bar;
  wire [6:0] biased_sum2_1, biased_sum2_1bar;
  wire [6:0] biased_sum3_0, biased_sum3_0bar;
  wire [6:0] biased_sum3_1, biased_sum3_1bar;

    layer3 l1 (
    .inputs0_3(inputs0_3),
    .inputs1_3(inputs1_3),
    .inputs2_3(inputs2_3),
    .inputs3_3(inputs3_3),
    .inputs4_3(inputs4_3),
    .inputs5_3(inputs5_3),
    .inputs6_3(inputs6_3),
    .inputs7_3(inputs7_3),
    .w1_0_3(w1_0_3), .w1_1_3(w1_1_3),
    .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
    .w3_0_3(w3_0_3), .w3_1_3(w3_1_3),
    .w4_0_3(w4_0_3), .w4_1_3(w4_1_3),
    .b1_3(b1_3),
    .b2_3(b2_3),
    .b3_3(b3_3),
    .b4_3(b4_3),
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

    activation_array_3 act1 (
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
    .masked_activation0(masked_activation0_3),
    .masked_activation1(masked_activation1_3),
    .masked_activation2(masked_activation2_3),
    .masked_activation3(masked_activation3_3),
    .mask0(mask0_3),
    .mask1(mask1_3),
    .mask2(mask2_3),
    .mask3(mask3_3)
  );

    activation_array_3 act2 (
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
    .masked_activation0(masked_activation0bar_3),
    .masked_activation1(masked_activation1bar_3),
    .masked_activation2(masked_activation2bar_3),
    .masked_activation3(masked_activation3bar_3),
    .mask0(mask0bar_3),
    .mask1(mask1bar_3),
    .mask2(mask2bar_3),
    .mask3(mask3bar_3)
  );

    boolean_arithmetic_coversion_3 conv0 (
    .x0(masked_activation0_3),
    .x1(mask0_3),
    .r_mask(ar0),
    .arith_share0(act0_0_3),
    .arith_share1(act0_1_3)
  );

  boolean_arithmetic_coversion_3 conv0b (
    .x0(masked_activation0bar_3),
    .x1(mask0bar_3),
    .r_mask(ar0bar),
    .arith_share0(act0_0bar_3),
    .arith_share1(act0_1bar_3)
  );

  boolean_arithmetic_coversion_3 conv1 (
    .x0(masked_activation1_3),
    .x1(mask1_3),
    .r_mask(ar1),
    .arith_share0(act1_0_3),
    .arith_share1(act1_1_3)
  );

  boolean_arithmetic_coversion_3 conv1b (
    .x0(masked_activation1bar_3),
    .x1(mask1bar_3),
    .r_mask(ar1bar),
    .arith_share0(act1_0bar_3),
    .arith_share1(act1_1bar_3)
  );

  boolean_arithmetic_coversion_3 conv2 (
    .x0(masked_activation2_3),
    .x1(mask2_3),
    .r_mask(ar2),
    .arith_share0(act2_0_3),
    .arith_share1(act2_1_3)
  );

  boolean_arithmetic_coversion_3 conv2b (
    .x0(masked_activation2bar_3),
    .x1(mask2bar_3),
    .r_mask(ar2bar),
    .arith_share0(act2_0bar_3),
    .arith_share1(act2_1bar_3)
  );

  boolean_arithmetic_coversion_3 conv3 (
    .x0(masked_activation3_3),
    .x1(mask3_3),
    .r_mask(ar3),
    .arith_share0(act3_0_3),
    .arith_share1(act3_1_3)
  );

  boolean_arithmetic_coversion_3 conv3b (
    .x0(masked_activation3bar_3),
    .x1(mask3bar_3),
    .r_mask(ar3bar),
    .arith_share0(act3_0bar_3),
    .arith_share1(act3_1bar_3)
  );

    always @(*) begin
    $display("----- LAYER 3   boolean activations -----");
    $display("masked_activation : %b %b %b %b", masked_activation0_3, masked_activation1_3, masked_activation2_3, masked_activation3_3);
    $display("masked_activationbar : %b %b %b %b", masked_activation0bar_3, masked_activation1bar_3, masked_activation2bar_3, masked_activation3bar_3);
    $display("mask : %b %b %b %b", mask0_3, mask1_3, mask2_3, mask3_3);
    $display("maskbar : %b %b %b %b", mask0bar_3, mask1bar_3, mask2bar_3, mask3bar_3);
  end

  always @(*) begin
    $display("----- LAYER 3  arithmetic activations -----");
    $display("masked_activation_arith : %b %b %b %b", act0_0_3, act1_0_3, act2_0_3, act3_0_3);
    $display("mask_arith : %b %b %b %b", act0_1_3, act1_1_3, act2_1_3, act3_1_3);
    $display("masked_activationbar_arith : %b %b %b %b", act0_0bar_3, act1_0bar_3, act2_0bar_3, act3_0bar_3);
    $display("mask_arithbar : %b %b %b %b", act0_1bar_3, act1_1bar_3, act2_1bar_3, act3_1bar_3);
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

module add6bit_4(
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

full_adder_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adder_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adder_4 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adder_4 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adder_4 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adder_4 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNAND_4 wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNAND_4 wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNAND_4 wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNAND_4 wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout;

endmodule


module half_adderbar_4(
  output S,
  output C,
  input A,
  input B
);
  assign S = A ^ B;
  assign C = A & B;
endmodule

module full_adderbar_4(
  output S,
  output C,
  input X,
  input Y,
  input Z
);
  wire S1, D1, D2;
  half_adderbar_4 HA1(.S(S1), .C(D1), .A(X), .B(Y));
  half_adderbar_4 HA2(.S(S), .C(D2), .A(S1), .B(Z));
  assign C = D1 | D2;
endmodule

module WddlNANDbar_4(
  input A,
  input B,
  input C,
  output S,
  output S1
);
  assign S = ~(A & B & C);
  assign S1 = ~S;
endmodule

module add3bitbar_4(
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

full_adderbar_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_4 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));

WddlNANDbar_4 wn1(.A(~a[2]), .B(b[2]), .C(~c3), .S(s1), .S1(s1_1));
WddlNANDbar_4 wn2(.A(a[2]), .B(~b[2]), .C(~c3), .S(s2), .S1(s2_1));
WddlNANDbar_4 wn3(.A(a[2]), .B(b[2]), .C(c3), .S(s3), .S1(s3_1));
WddlNANDbar_4 wn4(.A(~a[2]), .B(~b[2]), .C(c3), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[3] = cout_bar;

endmodule

module add4bitbar_4(
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

full_adderbar_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_4 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_4 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));

WddlNANDbar_4 wn1(.A(~a[3]), .B(b[3]), .C(~c4), .S(s1), .S1(s1_1));
WddlNANDbar_4 wn2(.A(a[3]), .B(~b[3]), .C(~c4), .S(s2), .S1(s2_1));
WddlNANDbar_4 wn3(.A(a[3]), .B(b[3]), .C(c4), .S(s3), .S1(s3_1));
WddlNANDbar_4 wn4(.A(~a[3]), .B(~b[3]), .C(c4), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[4] = cout_bar;

endmodule

module add5bitbar_4(
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

full_adderbar_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_4 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_4 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_4 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));

WddlNANDbar_4 wn1(.A(~a[4]), .B(b[4]), .C(~c5), .S(s1), .S1(s1_1));
WddlNANDbar_4 wn2(.A(a[4]), .B(~b[4]), .C(~c5), .S(s2), .S1(s2_1));
WddlNANDbar_4 wn3(.A(a[4]), .B(b[4]), .C(c5), .S(s3), .S1(s3_1));
WddlNANDbar_4 wn4(.A(~a[4]), .B(~b[4]), .C(c5), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[5] = cout_bar;

endmodule

module add6bitbar_4(
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

full_adderbar_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_4 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_4 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_4 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_4 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));

WddlNANDbar_4 wn1(.A(~a[5]), .B(b[5]), .C(~c6), .S(s1), .S1(s1_1));
WddlNANDbar_4 wn2(.A(a[5]), .B(~b[5]), .C(~c6), .S(s2), .S1(s2_1));
WddlNANDbar_4 wn3(.A(a[5]), .B(b[5]), .C(c6), .S(s3), .S1(s3_1));
WddlNANDbar_4 wn4(.A(~a[5]), .B(~b[5]), .C(c6), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[6] = cout_bar;

endmodule



module adder_tree_4 (
    input  wire [2:0] in0,
    input  wire [2:0] in1,
    input  wire [2:0] in2,
    input  wire [2:0] in3,
    input  wire [2:0] in4,
    input  wire [2:0] in5,
    input  wire [2:0] in6,
    input  wire [2:0] in7,
    output wire [5:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [5:0] stage2_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [5:0] stage2_0;

    add3bit_4 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bit_4 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bit_4 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bit_4 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add4bit_4 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bit_4 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add5bit_4 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage2_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage2_0 = {1'b0, stage2_0_lo};
    end
endmodule


module adder_tree_bar_4 (
    input  wire [2:0] in0,
    input  wire [2:0] in1,
    input  wire [2:0] in2,
    input  wire [2:0] in3,
    input  wire [2:0] in4,
    input  wire [2:0] in5,
    input  wire [2:0] in6,
    input  wire [2:0] in7,
    output wire [5:0] sum
);

    wire [3:0] stage0_0_lo;
    wire [3:0] stage0_1_lo;
    wire [3:0] stage0_2_lo;
    wire [3:0] stage0_3_lo;
    wire [4:0] stage1_0_lo;
    wire [4:0] stage1_1_lo;
    wire [5:0] stage2_0_lo;
    reg  [3:0] stage0_0;
    reg  [3:0] stage0_1;
    reg  [3:0] stage0_2;
    reg  [3:0] stage0_3;
    reg  [4:0] stage1_0;
    reg  [4:0] stage1_1;
    reg  [5:0] stage2_0;

    add3bitbar_4 u0_0 (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo), .cout(), .cout_bar());
    add3bitbar_4 u0_1 (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo), .cout(), .cout_bar());
    add3bitbar_4 u0_2 (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo), .cout(), .cout_bar());
    add3bitbar_4 u0_3 (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo), .cout(), .cout_bar());
    add4bitbar_4 u1_0 (.a(stage0_0), .b(stage0_1), .cin(1'b0), .y(stage1_0_lo), .cout(), .cout_bar());
    add4bitbar_4 u1_1 (.a(stage0_2), .b(stage0_3), .cin(1'b0), .y(stage1_1_lo), .cout(), .cout_bar());
    add5bitbar_4 u2_0 (.a(stage1_0), .b(stage1_1), .cin(1'b0), .y(stage2_0_lo), .cout(), .cout_bar());

    assign sum = {1'b0, stage2_0_lo};

    always @(*) begin
        stage0_0 = {1'b0, stage0_0_lo};
        stage0_1 = {1'b0, stage0_1_lo};
        stage0_2 = {1'b0, stage0_2_lo};
        stage0_3 = {1'b0, stage0_3_lo};
        stage1_0 = {1'b0, stage1_0_lo};
        stage1_1 = {1'b0, stage1_1_lo};
        stage2_0 = {1'b0, stage2_0_lo};
    end
endmodule


module layer4(
    input [2:0] inputs0_4 , inputs1_4 , inputs2_4 , inputs3_4 , inputs4_4 , inputs5_4 , inputs6_4 , inputs7_4,
    input [7:0] w1_0_4, w1_1_4, w2_0_4, w2_1_4,
    input [5:0] b1_4, b2_4,
    output [6:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar
);
    wire [2:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [2:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [2:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [2:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [2:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [2:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [2:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [2:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [2:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [2:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [2:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [2:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [2:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [2:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [2:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [2:0] weighted_inputs2_7_0, weighted_inputs2_7_1;

    wire [5:0] sum1 [1:0];
    wire [5:0] sum2 [1:0];
    wire [6:0] biased_sum1 [1:0];
    wire [6:0] biased_sum2 [1:0];
    wire [5:0] sum1bar [1:0];
    wire [5:0] sum2bar [1:0];
    wire [6:0] biased_sum1bar [1:0];
    wire [6:0] biased_sum2bar [1:0];
    weighted_inputs_1 w0 (.inputs(inputs0_4), .w(w1_0_4[0]), .wi(weighted_inputs1_0_0));
    weighted_inputs_1 w0_bar (.inputs(inputs0_4), .w(w1_1_4[0]), .wi(weighted_inputs1_0_1));
    weighted_inputs_1 w1 (.inputs(inputs1_4), .w(w1_0_4[1]), .wi(weighted_inputs1_1_0));
    weighted_inputs_1 w1_bar (.inputs(inputs1_4), .w(w1_1_4[1]), .wi(weighted_inputs1_1_1));
    weighted_inputs_1 w2 (.inputs(inputs2_4), .w(w1_0_4[2]), .wi(weighted_inputs1_2_0));
    weighted_inputs_1 w2_bar (.inputs(inputs2_4), .w(w1_1_4[2]), .wi(weighted_inputs1_2_1));
    weighted_inputs_1 w3 (.inputs(inputs3_4), .w(w1_0_4[3]), .wi(weighted_inputs1_3_0));
    weighted_inputs_1 w3_bar (.inputs(inputs3_4), .w(w1_1_4[3]), .wi(weighted_inputs1_3_1));
    weighted_inputs_1 w4 (.inputs(inputs4_4), .w(w1_0_4[4]), .wi(weighted_inputs1_4_0));
    weighted_inputs_1 w4_bar (.inputs(inputs4_4), .w(w1_1_4[4]), .wi(weighted_inputs1_4_1));
    weighted_inputs_1 w5 (.inputs(inputs5_4), .w(w1_0_4[5]), .wi(weighted_inputs1_5_0));
    weighted_inputs_1 w5_bar (.inputs(inputs5_4), .w(w1_1_4[5]), .wi(weighted_inputs1_5_1));
    weighted_inputs_1 w6 (.inputs(inputs6_4), .w(w1_0_4[6]), .wi(weighted_inputs1_6_0));
    weighted_inputs_1 w6_bar (.inputs(inputs6_4), .w(w1_1_4[6]), .wi(weighted_inputs1_6_1));
    weighted_inputs_1 w7 (.inputs(inputs7_4), .w(w1_0_4[7]), .wi(weighted_inputs1_7_0));
    weighted_inputs_1 w7_bar (.inputs(inputs7_4), .w(w1_1_4[7]), .wi(weighted_inputs1_7_1));
    weighted_inputs_1 w8 (.inputs(inputs0_4), .w(w2_0_4[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_1 w8_bar (.inputs(inputs0_4), .w(w2_1_4[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_1 w9 (.inputs(inputs1_4), .w(w2_0_4[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_1 w9_bar (.inputs(inputs1_4), .w(w2_1_4[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_1 w10 (.inputs(inputs2_4), .w(w2_0_4[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_1 w10_bar (.inputs(inputs2_4), .w(w2_1_4[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_1 w11 (.inputs(inputs3_4), .w(w2_0_4[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_1 w11_bar (.inputs(inputs3_4), .w(w2_1_4[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_1 w12 (.inputs(inputs4_4), .w(w2_0_4[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_1 w12_bar (.inputs(inputs4_4), .w(w2_1_4[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_1 w13 (.inputs(inputs5_4), .w(w2_0_4[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_1 w13_bar (.inputs(inputs5_4), .w(w2_1_4[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_1 w14 (.inputs(inputs6_4), .w(w2_0_4[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_1 w14_bar (.inputs(inputs6_4), .w(w2_1_4[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_1 w15 (.inputs(inputs7_4), .w(w2_0_4[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_1 w15_bar (.inputs(inputs7_4), .w(w2_1_4[7]), .wi(weighted_inputs2_7_1));
    adder_tree_4 add0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .sum(sum1[0])
    );
    adder_tree_4 add2(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
        .sum(sum2[0])
    );
    adder_tree_bar_4 addb0(
        .in0(weighted_inputs1_0_0),
        .in1(weighted_inputs1_1_0),
        .in2(weighted_inputs1_2_0),
        .in3(weighted_inputs1_3_0),
        .in4(weighted_inputs1_4_0),
        .in5(weighted_inputs1_5_0),
        .in6(weighted_inputs1_6_0),
        .in7(weighted_inputs1_7_0),
        .sum(sum1bar[0])
    );
    adder_tree_bar_4 addb2(
        .in0(weighted_inputs1_0_1),
        .in1(weighted_inputs1_1_1),
        .in2(weighted_inputs1_2_1),
        .in3(weighted_inputs1_3_1),
        .in4(weighted_inputs1_4_1),
        .in5(weighted_inputs1_5_1),
        .in6(weighted_inputs1_6_1),
        .in7(weighted_inputs1_7_1),
        .sum(sum2bar[0])
    );
    adder_tree_4 add1(
        .in0(weighted_inputs2_0_0),
        .in1(weighted_inputs2_1_0),
        .in2(weighted_inputs2_2_0),
        .in3(weighted_inputs2_3_0),
        .in4(weighted_inputs2_4_0),
        .in5(weighted_inputs2_5_0),
        .in6(weighted_inputs2_6_0),
        .in7(weighted_inputs2_7_0),
        .sum(sum1[1])
    );
    adder_tree_4 add3(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .sum(sum2[1])
    );
    adder_tree_bar_4 addb1(
        .in0(weighted_inputs2_0_0),
        .in1(weighted_inputs2_1_0),
        .in2(weighted_inputs2_2_0),
        .in3(weighted_inputs2_3_0),
        .in4(weighted_inputs2_4_0),
        .in5(weighted_inputs2_5_0),
        .in6(weighted_inputs2_6_0),
        .in7(weighted_inputs2_7_0),
        .sum(sum1bar[1])
    );
    adder_tree_bar_4 addb3(
        .in0(weighted_inputs2_0_1),
        .in1(weighted_inputs2_1_1),
        .in2(weighted_inputs2_2_1),
        .in3(weighted_inputs2_3_1),
        .in4(weighted_inputs2_4_1),
        .in5(weighted_inputs2_5_1),
        .in6(weighted_inputs2_6_1),
        .in7(weighted_inputs2_7_1),
        .sum(sum2bar[1])
    );
    add6bit_4 u0 (.a(sum1[0]), .b(b1_4), .cin(1'b0), .y(biased_sum1[0]));
    add6bit_4 u2 (.a(sum2[0]), .b(b1_4), .cin(1'b0), .y(biased_sum2[0]));
    add6bitbar_4 ub0 (.a(sum1bar[0]), .b(b1_4), .cin(1'b0), .y(biased_sum1bar[0]));
    add6bitbar_4 ub2 (.a(sum2bar[0]), .b(b1_4), .cin(1'b0), .y(biased_sum2bar[0]));
    add6bit_4 u1 (.a(sum1[1]), .b(b2_4), .cin(1'b0), .y(biased_sum1[1]));
    add6bit_4 u3 (.a(sum2[1]), .b(b2_4), .cin(1'b0), .y(biased_sum2[1]));
    add6bitbar_4 ub1 (.a(sum1bar[1]), .b(b2_4), .cin(1'b0), .y(biased_sum1bar[1]));
    add6bitbar_4 ub3 (.a(sum2bar[1]), .b(b2_4), .cin(1'b0), .y(biased_sum2bar[1]));
    assign biased_sum0_0 = biased_sum1[0];
    assign biased_sum0_1 = biased_sum2[0];
    assign biased_sum0_0bar = biased_sum1bar[0];
    assign biased_sum0_1bar = biased_sum2bar[0];
    assign biased_sum1_0 = biased_sum1[1];
    assign biased_sum1_1 = biased_sum2[1];
    assign biased_sum1_0bar = biased_sum1bar[1];
    assign biased_sum1_1bar = biased_sum2bar[1];
    always @(*) begin
        $display("----- BNN LAYER 4 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b", inputs0_4, inputs1_4, inputs2_4, inputs3_4, inputs4_4, inputs5_4, inputs6_4, inputs7_4);
        $display("Weights0: %b %b", w1_0_4, w2_0_4);
        $display("Weights1: %b %b", w1_1_4, w2_1_4);
        $display("sum1: %b %b", sum1[0], sum1[1]);
        $display("sum2: %b %b", sum2[0], sum2[1]);
        $display("sum1bar: %b %b", sum1bar[0], sum1bar[1]);
        $display("sum2bar: %b %b", sum2bar[0], sum2bar[1]);
        $display("biased_sum1: %b %b ", biased_sum1[0], biased_sum1[1]);
        $display("biased_sum2:%b %b ", biased_sum2[0], biased_sum2[1]);
        $display("biased_sum1bar: %0d %0d ", biased_sum1bar[0], biased_sum1bar[1]);
        $display("biased_sum2bar: %0d %0d ", biased_sum2bar[0], biased_sum2bar[1]);
    end
endmodule


module subtractor (
    input  wire signed [6:0] A,
    input  wire signed [6:0] B,
    output wire signed [7:0] Result
);
    assign Result = A - B;
endmodule

module comparator_1 (
    input  wire [7:0] inputs0_0,
    input  wire [7:0] inputs0_1,
    input  wire r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0,
    output wire comparator
);
    // internal r_out chain
    wire r1 , r2 , r3 , r4 , r5 , r6 , r7 , r8;
    wire masked_c0_0 , masked_c1_0 , masked_c2_0 , masked_c3_0 , masked_c4_0 , masked_c5_0 , masked_c6_0 , masked_c7_0;

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

    wire carry = r8 ^ masked_c7_0;
    // final compare: if carry ^ inputs0_0[N-1] ^ inputs0_1[N-1] == 0 → comparator = 1
    assign comparator = (carry ^ inputs0_0[7] ^ inputs0_1[7]) ? 1'b0 : 1'b1;
endmodule


module output_layer_max (
  input  wire [2:0] inputs0_4,
  input  wire [2:0] inputs1_4,
  input  wire [2:0] inputs2_4,
  input  wire [2:0] inputs3_4,
  input  wire [2:0] inputs4_4,
  input  wire [2:0] inputs5_4,
  input  wire [2:0] inputs6_4,
  input  wire [2:0] inputs7_4,
    input  wire [7:0] w1_0_4, w1_1_4,
    input  wire [7:0] w2_0_4, w2_1_4,
    input  wire [5:0] b1_4,
    input  wire [5:0] b2_4,
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
    output reg  a0, a0_bar,
    output reg  a1, a1_bar
);

    wire [6:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar;
    wire [6:0] biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar;

    layer4 l1 (
        .inputs0_4(inputs0_4),
        .inputs1_4(inputs1_4),
        .inputs2_4(inputs2_4),
        .inputs3_4(inputs3_4),
        .inputs4_4(inputs4_4),
        .inputs5_4(inputs5_4),
        .inputs6_4(inputs6_4),
        .inputs7_4(inputs7_4),
        .w1_0_4(w1_0_4), .w1_1_4(w1_1_4),
        .w2_0_4(w2_0_4), .w2_1_4(w2_1_4),
        .b1_4(b1_4),
        .b2_4(b2_4),
        .biased_sum0_0(biased_sum0_0),
        .biased_sum0_1(biased_sum0_1),
        .biased_sum1_0(biased_sum1_0),
        .biased_sum1_1(biased_sum1_1),
        .biased_sum0_0bar(biased_sum0_0bar),
        .biased_sum0_1bar(biased_sum0_1bar),
        .biased_sum1_0bar(biased_sum1_0bar),
        .biased_sum1_1bar(biased_sum1_1bar)
    );

    wire [7:0] temp0_0, temp0_1, temp0_0bar, temp0_1bar;
    subtractor s0a (.A(biased_sum0_0), .B(biased_sum1_0), .Result(temp0_0));
    subtractor s0b (.A(biased_sum0_1), .B(biased_sum1_1), .Result(temp0_1));
    subtractor s0abar (.A(biased_sum0_0bar), .B(biased_sum1_0bar), .Result(temp0_0bar));
    subtractor s0bbar (.A(biased_sum0_1bar), .B(biased_sum1_1bar), .Result(temp0_1bar));
    wire comp0, comp0_bar;
    comparator_1 c0 (
        .inputs0_0(temp0_0), .inputs0_1(temp0_1),
        .r0_0(r0_0), .r1_0(r1_0), .r2_0(r2_0), .r3_0(r3_0), .r4_0(r4_0), .r5_0(r5_0), .r6_0(r6_0), .r7_0(r7_0),
        .comparator(comp0)
    );
    comparator_1 c0_bar (
        .inputs0_0(temp0_0bar), .inputs0_1(temp0_1bar),
        .r0_0(r0_0bar), .r1_0(r1_0bar), .r2_0(r2_0bar), .r3_0(r3_0bar), .r4_0(r4_0bar), .r5_0(r5_0bar), .r6_0(r6_0bar), .r7_0(r7_0bar),
        .comparator(comp0_bar)
    );
    reg [6:0] stage1_0_0, stage1_0_1, stage1_0_0bar, stage1_0_1bar;
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
    input  wire [2:0] inputs0_1,
    input  wire [2:0] inputs1_1,
    input  wire [2:0] inputs2_1,
    input  wire [2:0] inputs3_1,
    input  wire [2:0] inputs4_1,
    input  wire [2:0] inputs5_1,
    input  wire [2:0] inputs6_1,
    input  wire [2:0] inputs7_1,
    // Layer-1 weights & biases
    input  wire [7:0] w1_0_1, w1_1_1,
    input  wire [7:0] w2_0_1, w2_1_1,
    input  wire [7:0] w3_0_1, w3_1_1,
    input  wire [7:0] w4_0_1, w4_1_1,
    input  wire [5:0] b1_1, b2_1, b3_1, b4_1,

    // Layer-2 weights & biases
    input  wire [7:0] w1_0_2, w1_1_2,
    input  wire [7:0] w2_0_2, w2_1_2,
    input  wire [7:0] w3_0_2, w3_1_2,
    input  wire [7:0] w4_0_2, w4_1_2,
    input  wire [5:0] b1_2, b2_2, b3_2, b4_2,

    // Layer-3 weights & biases (output layer)
    input  wire [7:0] w1_0_3, w1_1_3,
    input  wire [7:0] w2_0_3, w2_1_3,
    input  wire [7:0] w3_0_3, w3_1_3,
    input  wire [7:0] w4_0_3, w4_1_3,
    input  wire [5:0] b1_3,
    input  wire [5:0] b2_3,
    input  wire [5:0] b3_3,
    input  wire [5:0] b4_3,

    // Layer-4 weights & biases (output layer)
    input  wire [7:0] w1_0_4, w1_1_4,
    input  wire [7:0] w2_0_4, w2_1_4,
    input  wire [5:0] b1_4,
    input  wire [5:0] b2_4,

    // Final outputs
    output wire a0, a0_bar,
    output wire a1, a1_bar
);

  //--------------------------------------------------------------------------
  // Layer-1 randomness taps
  //--------------------------------------------------------------------------
  reg  r0_0_1;
  reg  r1_0_1;
  reg  r2_0_1;
  reg  r3_0_1;
  reg  r4_0_1;
  reg  r5_0_1;
  reg  r6_0_1;
  reg  r0_1_1;
  reg  r1_1_1;
  reg  r2_1_1;
  reg  r3_1_1;
  reg  r4_1_1;
  reg  r5_1_1;
  reg  r6_1_1;
  reg  r0_2_1;
  reg  r1_2_1;
  reg  r2_2_1;
  reg  r3_2_1;
  reg  r4_2_1;
  reg  r5_2_1;
  reg  r6_2_1;
  reg  r0_3_1;
  reg  r1_3_1;
  reg  r2_3_1;
  reg  r3_3_1;
  reg  r4_3_1;
  reg  r5_3_1;
  reg  r6_3_1;
  initial begin
    r0_0_1 = $random;
    r1_0_1 = $random;
    r2_0_1 = $random;
    r3_0_1 = $random;
    r4_0_1 = $random;
    r5_0_1 = $random;
    r6_0_1 = $random;
    r0_1_1 = $random;
    r1_1_1 = $random;
    r2_1_1 = $random;
    r3_1_1 = $random;
    r4_1_1 = $random;
    r5_1_1 = $random;
    r6_1_1 = $random;
    r0_2_1 = $random;
    r1_2_1 = $random;
    r2_2_1 = $random;
    r3_2_1 = $random;
    r4_2_1 = $random;
    r5_2_1 = $random;
    r6_2_1 = $random;
    r0_3_1 = $random;
    r1_3_1 = $random;
    r2_3_1 = $random;
    r3_3_1 = $random;
    r4_3_1 = $random;
    r5_3_1 = $random;
    r6_3_1 = $random;
    #1;
  end

  // Layer-1 arithmetic‐share randomness taps
  reg [1:0] ar0_1, ar1_1, ar2_1, ar3_1;
  reg [1:0] ar0bar_1, ar1bar_1, ar2bar_1, ar3bar_1;

  initial begin
    ar0_1    = $random;
    ar0bar_1 = $random;
    ar1_1    = $random;
    ar1bar_1 = $random;
    ar2_1    = $random;
    ar2bar_1 = $random;
    ar3_1    = $random;
    ar3bar_1 = $random;
    #1;
  end

 wire masked_activation0_1, masked_activation0bar_1;
 wire masked_activation1_1, masked_activation1bar_1;
 wire masked_activation2_1, masked_activation2bar_1;
 wire masked_activation3_1, masked_activation3bar_1;
 wire mask0_1, mask0bar_1;
 wire mask1_1, mask1bar_1;
 wire mask2_1, mask2bar_1;
 wire mask3_1, mask3bar_1;
  wire [2:0] act0_0_1, act0_1_1;
  wire [2:0] act1_0_1, act1_1_1;
  wire [2:0] act2_0_1, act2_1_1;
  wire [2:0] act3_0_1, act3_1_1;
 wire [2:0] act0_0bar_1, act0_1bar_1;
 wire [2:0] act1_0bar_1, act1_1bar_1;
 wire [2:0] act2_0bar_1, act2_1bar_1;
 wire [2:0] act3_0bar_1, act3_1bar_1;
  activation_and_conversion_1 layer1_inst (
    .inputs0_1(inputs0_1),
    .inputs1_1(inputs1_1),
    .inputs2_1(inputs2_1),
    .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1),
    .inputs5_1(inputs5_1),
    .inputs6_1(inputs6_1),
    .inputs7_1(inputs7_1),
    .w1_0_1(w1_0_1), .w1_1_1(w1_1_1),
    .w2_0_1(w2_0_1), .w2_1_1(w2_1_1),
    .w3_0_1(w3_0_1), .w3_1_1(w3_1_1),
    .w4_0_1(w4_0_1), .w4_1_1(w4_1_1),
    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1),
    .r0_0(r0_0_1),
    .r1_0(r1_0_1),
    .r2_0(r2_0_1),
    .r3_0(r3_0_1),
    .r4_0(r4_0_1),
    .r5_0(r5_0_1),
    .r6_0(r6_0_1),
    .r0_1(r0_1_1),
    .r1_1(r1_1_1),
    .r2_1(r2_1_1),
    .r3_1(r3_1_1),
    .r4_1(r4_1_1),
    .r5_1(r5_1_1),
    .r6_1(r6_1_1),
    .r0_2(r0_2_1),
    .r1_2(r1_2_1),
    .r2_2(r2_2_1),
    .r3_2(r3_2_1),
    .r4_2(r4_2_1),
    .r5_2(r5_2_1),
    .r6_2(r6_2_1),
    .r0_3(r0_3_1),
    .r1_3(r1_3_1),
    .r2_3(r2_3_1),
    .r3_3(r3_3_1),
    .r4_3(r4_3_1),
    .r5_3(r5_3_1),
    .r6_3(r6_3_1),
    .masked_activation0_1(masked_activation0_1), .masked_activation0bar_1(masked_activation0bar_1),
    .masked_activation1_1(masked_activation1_1), .masked_activation1bar_1(masked_activation1bar_1),
    .masked_activation2_1(masked_activation2_1), .masked_activation2bar_1(masked_activation2bar_1),
    .masked_activation3_1(masked_activation3_1), .masked_activation3bar_1(masked_activation3bar_1),
    .mask0_1(mask0_1), .mask0bar_1(mask0bar_1),
    .mask1_1(mask1_1), .mask1bar_1(mask1bar_1),
    .mask2_1(mask2_1), .mask2bar_1(mask2bar_1),
    .mask3_1(mask3_1), .mask3bar_1(mask3bar_1),
      .ar0(ar0_1), .ar0bar(ar0bar_1),   .ar1(ar1_1), .ar1bar(ar1bar_1),   .ar2(ar2_1), .ar2bar(ar2bar_1),   .ar3(ar3_1), .ar3bar(ar3bar_1),
    .act0_0_1(act0_0_1), .act0_1_1(act0_1_1), .act0_0bar_1(act0_0bar_1), .act0_1bar_1(act0_1bar_1),
    .act1_0_1(act1_0_1), .act1_1_1(act1_1_1), .act1_0bar_1(act1_0bar_1), .act1_1bar_1(act1_1bar_1),
    .act2_0_1(act2_0_1), .act2_1_1(act2_1_1), .act2_0bar_1(act2_0bar_1), .act2_1bar_1(act2_1bar_1),
    .act3_0_1(act3_0_1), .act3_1_1(act3_1_1), .act3_0bar_1(act3_0bar_1), .act3_1bar_1(act3_1bar_1)
  );

  //--------------------------------------------------------------------------
  // Layer-2 randomness taps
  //--------------------------------------------------------------------------
  reg  r0_0_2;
  reg  r1_0_2;
  reg  r2_0_2;
  reg  r3_0_2;
  reg  r4_0_2;
  reg  r5_0_2;
  reg  r6_0_2;
  reg  r0_1_2;
  reg  r1_1_2;
  reg  r2_1_2;
  reg  r3_1_2;
  reg  r4_1_2;
  reg  r5_1_2;
  reg  r6_1_2;
  reg  r0_2_2;
  reg  r1_2_2;
  reg  r2_2_2;
  reg  r3_2_2;
  reg  r4_2_2;
  reg  r5_2_2;
  reg  r6_2_2;
  reg  r0_3_2;
  reg  r1_3_2;
  reg  r2_3_2;
  reg  r3_3_2;
  reg  r4_3_2;
  reg  r5_3_2;
  reg  r6_3_2;
  initial begin
    r0_0_2 = $random;
    r1_0_2 = $random;
    r2_0_2 = $random;
    r3_0_2 = $random;
    r4_0_2 = $random;
    r5_0_2 = $random;
    r6_0_2 = $random;
    r0_1_2 = $random;
    r1_1_2 = $random;
    r2_1_2 = $random;
    r3_1_2 = $random;
    r4_1_2 = $random;
    r5_1_2 = $random;
    r6_1_2 = $random;
    r0_2_2 = $random;
    r1_2_2 = $random;
    r2_2_2 = $random;
    r3_2_2 = $random;
    r4_2_2 = $random;
    r5_2_2 = $random;
    r6_2_2 = $random;
    r0_3_2 = $random;
    r1_3_2 = $random;
    r2_3_2 = $random;
    r3_3_2 = $random;
    r4_3_2 = $random;
    r5_3_2 = $random;
    r6_3_2 = $random;
    #1;
  end

  // Layer-2 arithmetic‐share randomness taps
  reg [1:0] ar0_2, ar1_2, ar2_2, ar3_2;
  reg [1:0] ar0bar_2, ar1bar_2, ar2bar_2, ar3bar_2;

  initial begin
    ar0_2    = $random;
    ar0bar_2 = $random;
    ar1_2    = $random;
    ar1bar_2 = $random;
    ar2_2    = $random;
    ar2bar_2 = $random;
    ar3_2    = $random;
    ar3bar_2 = $random;
    #1;
  end

 wire masked_activation0_2, masked_activation0bar_2;
 wire masked_activation1_2, masked_activation1bar_2;
 wire masked_activation2_2, masked_activation2bar_2;
 wire masked_activation3_2, masked_activation3bar_2;
 wire mask0_2, mask0bar_2;
 wire mask1_2, mask1bar_2;
 wire mask2_2, mask2bar_2;
 wire mask3_2, mask3bar_2;
 wire [2:0] act0_0_2, act0_1_2;
 wire [2:0] act1_0_2, act1_1_2;
 wire [2:0] act2_0_2, act2_1_2;
 wire [2:0] act3_0_2, act3_1_2;
 wire [2:0] act0_0bar_2, act0_1bar_2;
 wire [2:0] act1_0bar_2, act1_1bar_2;
 wire [2:0] act2_0bar_2, act2_1bar_2;
 wire [2:0] act3_0bar_2, act3_1bar_2;

 
  activation_and_conversion_2 layer2_inst (
    .inputs0_2(act0_0_1),
    .inputs1_2(act1_0_1),
    .inputs2_2(act2_0_1),
    .inputs3_2(act3_0_1),
    .inputs4_2(act0_1_1),
    .inputs5_2(act1_1_1),
    .inputs6_2(act2_1_1),
    .inputs7_2(act3_1_1),
    .w1_0_2(w1_0_2), .w1_1_2(w1_1_2),
    .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
    .w3_0_2(w3_0_2), .w3_1_2(w3_1_2),
    .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2),
    .r0_0(r0_0_2),
    .r1_0(r1_0_2),
    .r2_0(r2_0_2),
    .r3_0(r3_0_2),
    .r4_0(r4_0_2),
    .r5_0(r5_0_2),
    .r6_0(r6_0_2),
    .r0_1(r0_1_2),
    .r1_1(r1_1_2),
    .r2_1(r2_1_2),
    .r3_1(r3_1_2),
    .r4_1(r4_1_2),
    .r5_1(r5_1_2),
    .r6_1(r6_1_2),
    .r0_2(r0_2_2),
    .r1_2(r1_2_2),
    .r2_2(r2_2_2),
    .r3_2(r3_2_2),
    .r4_2(r4_2_2),
    .r5_2(r5_2_2),
    .r6_2(r6_2_2),
    .r0_3(r0_3_2),
    .r1_3(r1_3_2),
    .r2_3(r2_3_2),
    .r3_3(r3_3_2),
    .r4_3(r4_3_2),
    .r5_3(r5_3_2),
    .r6_3(r6_3_2),
    .masked_activation0_2(masked_activation0_2), .masked_activation0bar_2(masked_activation0bar_2),
    .masked_activation1_2(masked_activation1_2), .masked_activation1bar_2(masked_activation1bar_2),
    .masked_activation2_2(masked_activation2_2), .masked_activation2bar_2(masked_activation2bar_2),
    .masked_activation3_2(masked_activation3_2), .masked_activation3bar_2(masked_activation3bar_2),
    .mask0_2(mask0_2), .mask0bar_2(mask0bar_2),
    .mask1_2(mask1_2), .mask1bar_2(mask1bar_2),
    .mask2_2(mask2_2), .mask2bar_2(mask2bar_2),
    .mask3_2(mask3_2), .mask3bar_2(mask3bar_2),
      .ar0(ar0_2), .ar0bar(ar0bar_2),   .ar1(ar1_2), .ar1bar(ar1bar_2),   .ar2(ar2_2), .ar2bar(ar2bar_2),   .ar3(ar3_2), .ar3bar(ar3bar_2),
    .act0_0_2(act0_0_2), .act0_1_2(act0_1_2), .act0_0bar_2(act0_0bar_2), .act0_1bar_2(act0_1bar_2),
    .act1_0_2(act1_0_2), .act1_1_2(act1_1_2), .act1_0bar_2(act1_0bar_2), .act1_1bar_2(act1_1bar_2),
    .act2_0_2(act2_0_2), .act2_1_2(act2_1_2), .act2_0bar_2(act2_0bar_2), .act2_1bar_2(act2_1bar_2),
    .act3_0_2(act3_0_2), .act3_1_2(act3_1_2), .act3_0bar_2(act3_0bar_2), .act3_1bar_2(act3_1bar_2)
  );

  //--------------------------------------------------------------------------
  // Layer-3 randomness taps
  //--------------------------------------------------------------------------
  reg  r0_0_3;
  reg  r1_0_3;
  reg  r2_0_3;
  reg  r3_0_3;
  reg  r4_0_3;
  reg  r5_0_3;
  reg  r6_0_3;
  reg  r0_1_3;
  reg  r1_1_3;
  reg  r2_1_3;
  reg  r3_1_3;
  reg  r4_1_3;
  reg  r5_1_3;
  reg  r6_1_3;
  reg  r0_2_3;
  reg  r1_2_3;
  reg  r2_2_3;
  reg  r3_2_3;
  reg  r4_2_3;
  reg  r5_2_3;
  reg  r6_2_3;
  reg  r0_3_3;
  reg  r1_3_3;
  reg  r2_3_3;
  reg  r3_3_3;
  reg  r4_3_3;
  reg  r5_3_3;
  reg  r6_3_3;
  initial begin
    r0_0_3 = $random;
    r1_0_3 = $random;
    r2_0_3 = $random;
    r3_0_3 = $random;
    r4_0_3 = $random;
    r5_0_3 = $random;
    r6_0_3 = $random;
    r0_1_3 = $random;
    r1_1_3 = $random;
    r2_1_3 = $random;
    r3_1_3 = $random;
    r4_1_3 = $random;
    r5_1_3 = $random;
    r6_1_3 = $random;
    r0_2_3 = $random;
    r1_2_3 = $random;
    r2_2_3 = $random;
    r3_2_3 = $random;
    r4_2_3 = $random;
    r5_2_3 = $random;
    r6_2_3 = $random;
    r0_3_3 = $random;
    r1_3_3 = $random;
    r2_3_3 = $random;
    r3_3_3 = $random;
    r4_3_3 = $random;
    r5_3_3 = $random;
    r6_3_3 = $random;
    #1;
  end

  // Layer-3 arithmetic‐share randomness taps
  reg [1:0] ar0_3, ar1_3, ar2_3, ar3_3;
  reg [1:0] ar0bar_3, ar1bar_3, ar2bar_3, ar3bar_3;

  initial begin
    ar0_3    = $random;
    ar0bar_3 = $random;
    ar1_3    = $random;
    ar1bar_3 = $random;
    ar2_3    = $random;
    ar2bar_3 = $random;
    ar3_3    = $random;
    ar3bar_3 = $random;
    #1;
  end

 wire masked_activation0_3, masked_activation0bar_3;
 wire masked_activation1_3, masked_activation1bar_3;
 wire masked_activation2_3, masked_activation2bar_3;
 wire masked_activation3_3, masked_activation3bar_3;
 wire mask0_3, mask0bar_3;
 wire mask1_3, mask1bar_3;
 wire mask2_3, mask2bar_3;
 wire mask3_3, mask3bar_3;
  wire [2:0] act0_0_3, act0_1_3;
  wire [2:0] act1_0_3, act1_1_3;
  wire [2:0] act2_0_3, act2_1_3;
  wire [2:0] act3_0_3, act3_1_3;
 wire [2:0] act0_0bar_3, act0_1bar_3;
 wire [2:0] act1_0bar_3, act1_1bar_3;
 wire [2:0] act2_0bar_3, act2_1bar_3;
 wire [2:0] act3_0bar_3, act3_1bar_3;
  activation_and_conversion_3 layer3_inst (
    .inputs0_3(act0_0_2),
    .inputs1_3(act1_0_2),
    .inputs2_3(act2_0_2),
    .inputs3_3(act3_0_2),
    .inputs4_3(act0_1_2),
    .inputs5_3(act1_1_2),
    .inputs6_3(act2_1_2),
    .inputs7_3(act3_1_2),
    .w1_0_3(w1_0_3), .w1_1_3(w1_1_3),
    .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
    .w3_0_3(w3_0_3), .w3_1_3(w3_1_3),
    .w4_0_3(w4_0_3), .w4_1_3(w4_1_3),
    .b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3),
    .r0_0(r0_0_3),
    .r1_0(r1_0_3),
    .r2_0(r2_0_3),
    .r3_0(r3_0_3),
    .r4_0(r4_0_3),
    .r5_0(r5_0_3),
    .r6_0(r6_0_3),
    .r0_1(r0_1_3),
    .r1_1(r1_1_3),
    .r2_1(r2_1_3),
    .r3_1(r3_1_3),
    .r4_1(r4_1_3),
    .r5_1(r5_1_3),
    .r6_1(r6_1_3),
    .r0_2(r0_2_3),
    .r1_2(r1_2_3),
    .r2_2(r2_2_3),
    .r3_2(r3_2_3),
    .r4_2(r4_2_3),
    .r5_2(r5_2_3),
    .r6_2(r6_2_3),
    .r0_3(r0_3_3),
    .r1_3(r1_3_3),
    .r2_3(r2_3_3),
    .r3_3(r3_3_3),
    .r4_3(r4_3_3),
    .r5_3(r5_3_3),
    .r6_3(r6_3_3),
    .masked_activation0_3(masked_activation0_3), .masked_activation0bar_3(masked_activation0bar_3),
    .masked_activation1_3(masked_activation1_3), .masked_activation1bar_3(masked_activation1bar_3),
    .masked_activation2_3(masked_activation2_3), .masked_activation2bar_3(masked_activation2bar_3),
    .masked_activation3_3(masked_activation3_3), .masked_activation3bar_3(masked_activation3bar_3),
    .mask0_3(mask0_3), .mask0bar_3(mask0bar_3),
    .mask1_3(mask1_3), .mask1bar_3(mask1bar_3),
    .mask2_3(mask2_3), .mask2bar_3(mask2bar_3),
    .mask3_3(mask3_3), .mask3bar_3(mask3bar_3),
      .ar0(ar0_3), .ar0bar(ar0bar_3),   .ar1(ar1_3), .ar1bar(ar1bar_3),   .ar2(ar2_3), .ar2bar(ar2bar_3),   .ar3(ar3_3), .ar3bar(ar3bar_3),
    .act0_0_3(act0_0_3), .act0_1_3(act0_1_3), .act0_0bar_3(act0_0bar_3), .act0_1bar_3(act0_1bar_3),
    .act1_0_3(act1_0_3), .act1_1_3(act1_1_3), .act1_0bar_3(act1_0bar_3), .act1_1bar_3(act1_1bar_3),
    .act2_0_3(act2_0_3), .act2_1_3(act2_1_3), .act2_0bar_3(act2_0bar_3), .act2_1bar_3(act2_1bar_3),
    .act3_0_3(act3_0_3), .act3_1_3(act3_1_3), .act3_0bar_3(act3_0bar_3), .act3_1bar_3(act3_1bar_3)
  );

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
    reg r7_0;
    reg r7_0bar;
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
    r7_0 = $random;
    r7_0bar = $random;
    #1;
  end

  output_layer_max layer4 (
    .inputs0_4(act0_0_3),
    .inputs1_4(act1_0_3),
    .inputs2_4(act2_0_3),
    .inputs3_4(act3_0_3),
    .inputs4_4(act0_1_3),
    .inputs5_4(act1_1_3),
    .inputs6_4(act2_1_3),
    .inputs7_4(act3_1_3),
    .w1_0_4(w1_0_4), .w1_1_4(w1_1_4),
    .w2_0_4(w2_0_4), .w2_1_4(w2_1_4),
    .b1_4(b1_4), .b2_4(b2_4),
    .r0_0(r0_0), .r0_0bar(r0_0bar),
    .r1_0(r1_0), .r1_0bar(r1_0bar),
    .r2_0(r2_0), .r2_0bar(r2_0bar),
    .r3_0(r3_0), .r3_0bar(r3_0bar),
    .r4_0(r4_0), .r4_0bar(r4_0bar),
    .r5_0(r5_0), .r5_0bar(r5_0bar),
    .r6_0(r6_0), .r6_0bar(r6_0bar),
    .r7_0(r7_0), .r7_0bar(r7_0bar),
    .a0(a0), .a0_bar(a0_bar),
    .a1(a1), .a1_bar(a1_bar)
  );

endmodule
`default_nettype wire

