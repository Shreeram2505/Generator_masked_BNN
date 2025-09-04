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

module add8bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));

WddlNANDbar_1 wn1(.A(~a[7]), .B(b[7]), .C(~c8), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[7]), .B(~b[7]), .C(~c8), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[7]), .B(b[7]), .C(c8), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[7]), .B(~b[7]), .C(c8), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[8] = cout_bar;

endmodule

module add9bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adderbar_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));

WddlNANDbar_1 wn1(.A(~a[8]), .B(b[8]), .C(~c9), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[8]), .B(~b[8]), .C(~c9), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[8]), .B(b[8]), .C(c9), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[8]), .B(~b[8]), .C(c9), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[9] = cout_bar;

endmodule

module add10bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adderbar_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adderbar_1 fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));

WddlNANDbar_1 wn1(.A(~a[9]), .B(b[9]), .C(~c10), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[9]), .B(~b[9]), .C(~c10), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[9]), .B(b[9]), .C(c10), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[9]), .B(~b[9]), .C(c10), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[10] = cout_bar;

endmodule

module add11bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adderbar_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adderbar_1 fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));
full_adderbar_1 fa10(.S(y[10]), .C(c11), .X(a[10]), .Y(b[10]), .Z(c10));

WddlNANDbar_1 wn1(.A(~a[10]), .B(b[10]), .C(~c11), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[10]), .B(~b[10]), .C(~c11), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[10]), .B(b[10]), .C(c11), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[10]), .B(~b[10]), .C(c11), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[11] = cout_bar;

endmodule

module add12bitbar_1(
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

full_adderbar_1 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_1 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));
full_adderbar_1 fa2(.S(y[2]), .C(c3), .X(a[2]), .Y(b[2]), .Z(c2));
full_adderbar_1 fa3(.S(y[3]), .C(c4), .X(a[3]), .Y(b[3]), .Z(c3));
full_adderbar_1 fa4(.S(y[4]), .C(c5), .X(a[4]), .Y(b[4]), .Z(c4));
full_adderbar_1 fa5(.S(y[5]), .C(c6), .X(a[5]), .Y(b[5]), .Z(c5));
full_adderbar_1 fa6(.S(y[6]), .C(c7), .X(a[6]), .Y(b[6]), .Z(c6));
full_adderbar_1 fa7(.S(y[7]), .C(c8), .X(a[7]), .Y(b[7]), .Z(c7));
full_adderbar_1 fa8(.S(y[8]), .C(c9), .X(a[8]), .Y(b[8]), .Z(c8));
full_adderbar_1 fa9(.S(y[9]), .C(c10), .X(a[9]), .Y(b[9]), .Z(c9));
full_adderbar_1 fa10(.S(y[10]), .C(c11), .X(a[10]), .Y(b[10]), .Z(c10));
full_adderbar_1 fa11(.S(y[11]), .C(c12), .X(a[11]), .Y(b[11]), .Z(c11));

WddlNANDbar_1 wn1(.A(~a[11]), .B(b[11]), .C(~c12), .S(s1), .S1(s1_1));
WddlNANDbar_1 wn2(.A(a[11]), .B(~b[11]), .C(~c12), .S(s2), .S1(s2_1));
WddlNANDbar_1 wn3(.A(a[11]), .B(b[11]), .C(c12), .S(s3), .S1(s3_1));
WddlNANDbar_1 wn4(.A(~a[11]), .B(~b[11]), .C(c12), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[12] = cout_bar;

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


module adder_tree_bar_1 (
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

    wire [8:0] stage0_0_lo_bar_1;
    wire [8:0] stage0_1_lo_bar_1;
    wire [8:0] stage0_2_lo_bar_1;
    wire [8:0] stage0_3_lo_bar_1;
    wire [8:0] stage0_4_lo_bar_1;
    wire [8:0] stage0_5_lo_bar_1;
    wire [8:0] stage0_6_lo_bar_1;
    wire [8:0] stage0_7_lo_bar_1;
    wire [9:0] stage1_0_lo_bar_1;
    wire [9:0] stage1_1_lo_bar_1;
    wire [9:0] stage1_2_lo_bar_1;
    wire [9:0] stage1_3_lo_bar_1;
    wire [10:0] stage2_0_lo_bar_1;
    wire [10:0] stage2_1_lo_bar_1;
    wire [11:0] stage3_0_lo_bar_1;
    reg  [8:0] stage0_0_bar_1;
    reg  [8:0] stage0_1_bar_1;
    reg  [8:0] stage0_2_bar_1;
    reg  [8:0] stage0_3_bar_1;
    reg  [8:0] stage0_4_bar_1;
    reg  [8:0] stage0_5_bar_1;
    reg  [8:0] stage0_6_bar_1;
    reg  [8:0] stage0_7_bar_1;
    reg  [9:0] stage1_0_bar_1;
    reg  [9:0] stage1_1_bar_1;
    reg  [9:0] stage1_2_bar_1;
    reg  [9:0] stage1_3_bar_1;
    reg  [10:0] stage2_0_bar_1;
    reg  [10:0] stage2_1_bar_1;
    reg  [11:0] stage3_0_bar_1;

    add8bitbar_1 u0_0_bar (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_bar_1), .cout(), .cout_bar());
    add8bitbar_1 u0_1_bar (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_bar_1), .cout(), .cout_bar());
    add8bitbar_1 u0_2_bar (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_bar_1), .cout(), .cout_bar());
    add8bitbar_1 u0_3_bar (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_bar_1), .cout(), .cout_bar());
    add8bitbar_1 u0_4_bar (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_bar_1), .cout(), .cout_bar());
    add8bitbar_1 u0_5_bar (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_bar_1), .cout(), .cout_bar());
    add8bitbar_1 u0_6_bar (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_bar_1), .cout(), .cout_bar());
    add8bitbar_1 u0_7_bar (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_bar_1), .cout(), .cout_bar());
    add9bitbar_1 u1_0_bar (.a(stage0_0_bar_1), .b(stage0_1_bar_1), .cin(1'b0), .y(stage1_0_lo_bar_1), .cout(), .cout_bar());
    add9bitbar_1 u1_1_bar (.a(stage0_2_bar_1), .b(stage0_3_bar_1), .cin(1'b0), .y(stage1_1_lo_bar_1), .cout(), .cout_bar());
    add9bitbar_1 u1_2_bar (.a(stage0_4_bar_1), .b(stage0_5_bar_1), .cin(1'b0), .y(stage1_2_lo_bar_1), .cout(), .cout_bar());
    add9bitbar_1 u1_3_bar (.a(stage0_6_bar_1), .b(stage0_7_bar_1), .cin(1'b0), .y(stage1_3_lo_bar_1), .cout(), .cout_bar());
    add10bitbar_1 u2_0_bar (.a(stage1_0_bar_1), .b(stage1_1_bar_1), .cin(1'b0), .y(stage2_0_lo_bar_1), .cout(), .cout_bar());
    add10bitbar_1 u2_1_bar (.a(stage1_2_bar_1), .b(stage1_3_bar_1), .cin(1'b0), .y(stage2_1_lo_bar_1), .cout(), .cout_bar());
    add11bitbar_1 u3_0_bar (.a(stage2_0_bar_1), .b(stage2_1_bar_1), .cin(1'b0), .y(stage3_0_lo_bar_1), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_bar_1;

    always @(posedge clk) begin
        stage0_0_bar_1 <=  stage0_0_lo_bar_1;
        stage0_1_bar_1 <=  stage0_1_lo_bar_1;
        stage0_2_bar_1 <=  stage0_2_lo_bar_1;
        stage0_3_bar_1 <=  stage0_3_lo_bar_1;
        stage0_4_bar_1 <=  stage0_4_lo_bar_1;
        stage0_5_bar_1 <=  stage0_5_lo_bar_1;
        stage0_6_bar_1 <=  stage0_6_lo_bar_1;
        stage0_7_bar_1 <=  stage0_7_lo_bar_1;
        stage1_0_bar_1 <=  stage1_0_lo_bar_1;
        stage1_1_bar_1 <=  stage1_1_lo_bar_1;
        stage1_2_bar_1 <=  stage1_2_lo_bar_1;
        stage1_3_bar_1 <=  stage1_3_lo_bar_1;
        stage2_0_bar_1 <=  stage2_0_lo_bar_1;
        stage2_1_bar_1 <=  stage2_1_lo_bar_1;
        stage3_0_bar_1 <=  stage3_0_lo_bar_1;
    end
endmodule


module layer1(
    input clk,
    input [7:0] inputs0_1 , inputs1_1 , inputs2_1 , inputs3_1 , inputs4_1 , inputs5_1 , inputs6_1 , inputs7_1 , inputs8_1 , inputs9_1 , inputs10_1 , inputs11_1 , inputs12_1 , inputs13_1 , inputs14_1 , inputs15_1,
    input [15:0] w1_0_1, w1_1_1, w2_0_1, w2_1_1, w3_0_1, w3_1_1, w4_0_1, w4_1_1, w5_0_1, w5_1_1, w6_0_1, w6_1_1, w7_0_1, w7_1_1, w8_0_1, w8_1_1,
    input [11:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1,
    output [12:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar, biased_sum4_0, biased_sum4_1, biased_sum4_0bar, biased_sum4_1bar, biased_sum5_0, biased_sum5_1, biased_sum5_0bar, biased_sum5_1bar, biased_sum6_0, biased_sum6_1, biased_sum6_0bar, biased_sum6_1bar, biased_sum7_0, biased_sum7_1, biased_sum7_0bar, biased_sum7_1bar
);
    wire [7:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [7:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [7:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [7:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [7:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [7:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [7:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [7:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [7:0] weighted_inputs1_8_0, weighted_inputs1_8_1;
    wire [7:0] weighted_inputs1_9_0, weighted_inputs1_9_1;
    wire [7:0] weighted_inputs1_10_0, weighted_inputs1_10_1;
    wire [7:0] weighted_inputs1_11_0, weighted_inputs1_11_1;
    wire [7:0] weighted_inputs1_12_0, weighted_inputs1_12_1;
    wire [7:0] weighted_inputs1_13_0, weighted_inputs1_13_1;
    wire [7:0] weighted_inputs1_14_0, weighted_inputs1_14_1;
    wire [7:0] weighted_inputs1_15_0, weighted_inputs1_15_1;
    wire [7:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [7:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [7:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [7:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [7:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [7:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [7:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [7:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [7:0] weighted_inputs2_8_0, weighted_inputs2_8_1;
    wire [7:0] weighted_inputs2_9_0, weighted_inputs2_9_1;
    wire [7:0] weighted_inputs2_10_0, weighted_inputs2_10_1;
    wire [7:0] weighted_inputs2_11_0, weighted_inputs2_11_1;
    wire [7:0] weighted_inputs2_12_0, weighted_inputs2_12_1;
    wire [7:0] weighted_inputs2_13_0, weighted_inputs2_13_1;
    wire [7:0] weighted_inputs2_14_0, weighted_inputs2_14_1;
    wire [7:0] weighted_inputs2_15_0, weighted_inputs2_15_1;
    wire [7:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [7:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [7:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [7:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [7:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [7:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [7:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [7:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [7:0] weighted_inputs3_8_0, weighted_inputs3_8_1;
    wire [7:0] weighted_inputs3_9_0, weighted_inputs3_9_1;
    wire [7:0] weighted_inputs3_10_0, weighted_inputs3_10_1;
    wire [7:0] weighted_inputs3_11_0, weighted_inputs3_11_1;
    wire [7:0] weighted_inputs3_12_0, weighted_inputs3_12_1;
    wire [7:0] weighted_inputs3_13_0, weighted_inputs3_13_1;
    wire [7:0] weighted_inputs3_14_0, weighted_inputs3_14_1;
    wire [7:0] weighted_inputs3_15_0, weighted_inputs3_15_1;
    wire [7:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [7:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [7:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [7:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [7:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [7:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [7:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [7:0] weighted_inputs4_7_0, weighted_inputs4_7_1;
    wire [7:0] weighted_inputs4_8_0, weighted_inputs4_8_1;
    wire [7:0] weighted_inputs4_9_0, weighted_inputs4_9_1;
    wire [7:0] weighted_inputs4_10_0, weighted_inputs4_10_1;
    wire [7:0] weighted_inputs4_11_0, weighted_inputs4_11_1;
    wire [7:0] weighted_inputs4_12_0, weighted_inputs4_12_1;
    wire [7:0] weighted_inputs4_13_0, weighted_inputs4_13_1;
    wire [7:0] weighted_inputs4_14_0, weighted_inputs4_14_1;
    wire [7:0] weighted_inputs4_15_0, weighted_inputs4_15_1;
    wire [7:0] weighted_inputs5_0_0, weighted_inputs5_0_1;
    wire [7:0] weighted_inputs5_1_0, weighted_inputs5_1_1;
    wire [7:0] weighted_inputs5_2_0, weighted_inputs5_2_1;
    wire [7:0] weighted_inputs5_3_0, weighted_inputs5_3_1;
    wire [7:0] weighted_inputs5_4_0, weighted_inputs5_4_1;
    wire [7:0] weighted_inputs5_5_0, weighted_inputs5_5_1;
    wire [7:0] weighted_inputs5_6_0, weighted_inputs5_6_1;
    wire [7:0] weighted_inputs5_7_0, weighted_inputs5_7_1;
    wire [7:0] weighted_inputs5_8_0, weighted_inputs5_8_1;
    wire [7:0] weighted_inputs5_9_0, weighted_inputs5_9_1;
    wire [7:0] weighted_inputs5_10_0, weighted_inputs5_10_1;
    wire [7:0] weighted_inputs5_11_0, weighted_inputs5_11_1;
    wire [7:0] weighted_inputs5_12_0, weighted_inputs5_12_1;
    wire [7:0] weighted_inputs5_13_0, weighted_inputs5_13_1;
    wire [7:0] weighted_inputs5_14_0, weighted_inputs5_14_1;
    wire [7:0] weighted_inputs5_15_0, weighted_inputs5_15_1;
    wire [7:0] weighted_inputs6_0_0, weighted_inputs6_0_1;
    wire [7:0] weighted_inputs6_1_0, weighted_inputs6_1_1;
    wire [7:0] weighted_inputs6_2_0, weighted_inputs6_2_1;
    wire [7:0] weighted_inputs6_3_0, weighted_inputs6_3_1;
    wire [7:0] weighted_inputs6_4_0, weighted_inputs6_4_1;
    wire [7:0] weighted_inputs6_5_0, weighted_inputs6_5_1;
    wire [7:0] weighted_inputs6_6_0, weighted_inputs6_6_1;
    wire [7:0] weighted_inputs6_7_0, weighted_inputs6_7_1;
    wire [7:0] weighted_inputs6_8_0, weighted_inputs6_8_1;
    wire [7:0] weighted_inputs6_9_0, weighted_inputs6_9_1;
    wire [7:0] weighted_inputs6_10_0, weighted_inputs6_10_1;
    wire [7:0] weighted_inputs6_11_0, weighted_inputs6_11_1;
    wire [7:0] weighted_inputs6_12_0, weighted_inputs6_12_1;
    wire [7:0] weighted_inputs6_13_0, weighted_inputs6_13_1;
    wire [7:0] weighted_inputs6_14_0, weighted_inputs6_14_1;
    wire [7:0] weighted_inputs6_15_0, weighted_inputs6_15_1;
    wire [7:0] weighted_inputs7_0_0, weighted_inputs7_0_1;
    wire [7:0] weighted_inputs7_1_0, weighted_inputs7_1_1;
    wire [7:0] weighted_inputs7_2_0, weighted_inputs7_2_1;
    wire [7:0] weighted_inputs7_3_0, weighted_inputs7_3_1;
    wire [7:0] weighted_inputs7_4_0, weighted_inputs7_4_1;
    wire [7:0] weighted_inputs7_5_0, weighted_inputs7_5_1;
    wire [7:0] weighted_inputs7_6_0, weighted_inputs7_6_1;
    wire [7:0] weighted_inputs7_7_0, weighted_inputs7_7_1;
    wire [7:0] weighted_inputs7_8_0, weighted_inputs7_8_1;
    wire [7:0] weighted_inputs7_9_0, weighted_inputs7_9_1;
    wire [7:0] weighted_inputs7_10_0, weighted_inputs7_10_1;
    wire [7:0] weighted_inputs7_11_0, weighted_inputs7_11_1;
    wire [7:0] weighted_inputs7_12_0, weighted_inputs7_12_1;
    wire [7:0] weighted_inputs7_13_0, weighted_inputs7_13_1;
    wire [7:0] weighted_inputs7_14_0, weighted_inputs7_14_1;
    wire [7:0] weighted_inputs7_15_0, weighted_inputs7_15_1;
    wire [7:0] weighted_inputs8_0_0, weighted_inputs8_0_1;
    wire [7:0] weighted_inputs8_1_0, weighted_inputs8_1_1;
    wire [7:0] weighted_inputs8_2_0, weighted_inputs8_2_1;
    wire [7:0] weighted_inputs8_3_0, weighted_inputs8_3_1;
    wire [7:0] weighted_inputs8_4_0, weighted_inputs8_4_1;
    wire [7:0] weighted_inputs8_5_0, weighted_inputs8_5_1;
    wire [7:0] weighted_inputs8_6_0, weighted_inputs8_6_1;
    wire [7:0] weighted_inputs8_7_0, weighted_inputs8_7_1;
    wire [7:0] weighted_inputs8_8_0, weighted_inputs8_8_1;
    wire [7:0] weighted_inputs8_9_0, weighted_inputs8_9_1;
    wire [7:0] weighted_inputs8_10_0, weighted_inputs8_10_1;
    wire [7:0] weighted_inputs8_11_0, weighted_inputs8_11_1;
    wire [7:0] weighted_inputs8_12_0, weighted_inputs8_12_1;
    wire [7:0] weighted_inputs8_13_0, weighted_inputs8_13_1;
    wire [7:0] weighted_inputs8_14_0, weighted_inputs8_14_1;
    wire [7:0] weighted_inputs8_15_0, weighted_inputs8_15_1;

    wire [11:0] sum1 [7:0];
    wire [11:0] sum2 [7:0];
    wire [12:0] biased_sum1 [7:0];
    wire [12:0] biased_sum2 [7:0];
    wire [11:0] sum1bar [7:0];
    wire [11:0] sum2bar [7:0];
    wire [12:0] biased_sum1bar [7:0];
    wire [12:0] biased_sum2bar [7:0];
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
        .clk(clk), 
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
    add12bit_1 u0 (.a(sum1[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1[0]));
    add12bit_1 u8 (.a(sum2[0]), .b(b1_1), .cin(1'b0), .y(biased_sum2[0]));
    add12bitbar_1 ub0 (.a(sum1bar[0]), .b(b1_1), .cin(1'b0), .y(biased_sum1bar[0]));
    add12bitbar_1 ub8 (.a(sum2bar[0]), .b(b1_1), .cin(1'b0), .y(biased_sum2bar[0]));
    add12bit_1 u1 (.a(sum1[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1[1]));
    add12bit_1 u9 (.a(sum2[1]), .b(b2_1), .cin(1'b0), .y(biased_sum2[1]));
    add12bitbar_1 ub1 (.a(sum1bar[1]), .b(b2_1), .cin(1'b0), .y(biased_sum1bar[1]));
    add12bitbar_1 ub9 (.a(sum2bar[1]), .b(b2_1), .cin(1'b0), .y(biased_sum2bar[1]));
    add12bit_1 u2 (.a(sum1[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1[2]));
    add12bit_1 u10 (.a(sum2[2]), .b(b3_1), .cin(1'b0), .y(biased_sum2[2]));
    add12bitbar_1 ub2 (.a(sum1bar[2]), .b(b3_1), .cin(1'b0), .y(biased_sum1bar[2]));
    add12bitbar_1 ub10 (.a(sum2bar[2]), .b(b3_1), .cin(1'b0), .y(biased_sum2bar[2]));
    add12bit_1 u3 (.a(sum1[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1[3]));
    add12bit_1 u11 (.a(sum2[3]), .b(b4_1), .cin(1'b0), .y(biased_sum2[3]));
    add12bitbar_1 ub3 (.a(sum1bar[3]), .b(b4_1), .cin(1'b0), .y(biased_sum1bar[3]));
    add12bitbar_1 ub11 (.a(sum2bar[3]), .b(b4_1), .cin(1'b0), .y(biased_sum2bar[3]));
    add12bit_1 u4 (.a(sum1[4]), .b(b5_1), .cin(1'b0), .y(biased_sum1[4]));
    add12bit_1 u12 (.a(sum2[4]), .b(b5_1), .cin(1'b0), .y(biased_sum2[4]));
    add12bitbar_1 ub4 (.a(sum1bar[4]), .b(b5_1), .cin(1'b0), .y(biased_sum1bar[4]));
    add12bitbar_1 ub12 (.a(sum2bar[4]), .b(b5_1), .cin(1'b0), .y(biased_sum2bar[4]));
    add12bit_1 u5 (.a(sum1[5]), .b(b6_1), .cin(1'b0), .y(biased_sum1[5]));
    add12bit_1 u13 (.a(sum2[5]), .b(b6_1), .cin(1'b0), .y(biased_sum2[5]));
    add12bitbar_1 ub5 (.a(sum1bar[5]), .b(b6_1), .cin(1'b0), .y(biased_sum1bar[5]));
    add12bitbar_1 ub13 (.a(sum2bar[5]), .b(b6_1), .cin(1'b0), .y(biased_sum2bar[5]));
    add12bit_1 u6 (.a(sum1[6]), .b(b7_1), .cin(1'b0), .y(biased_sum1[6]));
    add12bit_1 u14 (.a(sum2[6]), .b(b7_1), .cin(1'b0), .y(biased_sum2[6]));
    add12bitbar_1 ub6 (.a(sum1bar[6]), .b(b7_1), .cin(1'b0), .y(biased_sum1bar[6]));
    add12bitbar_1 ub14 (.a(sum2bar[6]), .b(b7_1), .cin(1'b0), .y(biased_sum2bar[6]));
    add12bit_1 u7 (.a(sum1[7]), .b(b8_1), .cin(1'b0), .y(biased_sum1[7]));
    add12bit_1 u15 (.a(sum2[7]), .b(b8_1), .cin(1'b0), .y(biased_sum2[7]));
    add12bitbar_1 ub7 (.a(sum1bar[7]), .b(b8_1), .cin(1'b0), .y(biased_sum1bar[7]));
    add12bitbar_1 ub15 (.a(sum2bar[7]), .b(b8_1), .cin(1'b0), .y(biased_sum2bar[7]));
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

    input [12:0] inputs0_0,
    input [12:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0, r9_0, r10_0, r11_0, r12_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0, masked_c6_0, masked_c7_0, masked_c8_0, masked_c9_0, masked_c10_0, masked_c11_0, masked_c12_0;

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
    lut1 l12 (.a(inputs0_0[12]), .b(inputs0_1[12]), .c_in(masked_c11_0), .r_flow(r12), .r_i(r12_0), .r_out(r13), .c_masked(masked_c12_0));

    wire carry = r13 ^ masked_c12_0;
    wire activation = (carry ^ inputs0_0[12] ^ inputs0_1[12]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r13;
    assign mask = r13;

endmodule

module activation_array_1 (
    input  [12:0] inputs0_0, inputs0_1,
    input  [12:0] inputs1_0, inputs1_1,
    input  [12:0] inputs2_0, inputs2_1,
    input  [12:0] inputs3_0, inputs3_1,
    input  [12:0] inputs4_0, inputs4_1,
    input  [12:0] inputs5_0, inputs5_1,
    input  [12:0] inputs6_0, inputs6_1,
    input  [12:0] inputs7_0, inputs7_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0, r6_0, r7_0, r8_0, r9_0, r10_0, r11_0, r12_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1, r6_1, r7_1, r8_1, r9_1, r10_1, r11_1, r12_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2, r6_2, r7_2, r8_2, r9_2, r10_2, r11_2, r12_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3, r6_3, r7_3, r8_3, r9_3, r10_3, r11_3, r12_3,
    input  r0_4, r1_4, r2_4, r3_4, r4_4, r5_4, r6_4, r7_4, r8_4, r9_4, r10_4, r11_4, r12_4,
    input  r0_5, r1_5, r2_5, r3_5, r4_5, r5_5, r6_5, r7_5, r8_5, r9_5, r10_5, r11_5, r12_5,
    input  r0_6, r1_6, r2_6, r3_6, r4_6, r5_6, r6_6, r7_6, r8_6, r9_6, r10_6, r11_6, r12_6,
    input  r0_7, r1_7, r2_7, r3_7, r4_7, r5_7, r6_7, r7_7, r8_7, r9_7, r10_7, r11_7, r12_7,
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
        .r8_0(r8_0),
        .r9_0(r9_0),
        .r10_0(r10_0),
        .r11_0(r11_0),
        .r12_0(r12_0),
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
        .r8_0(r8_1),
        .r9_0(r9_1),
        .r10_0(r10_1),
        .r11_0(r11_1),
        .r12_0(r12_1),
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
        .r8_0(r8_2),
        .r9_0(r9_2),
        .r10_0(r10_2),
        .r11_0(r11_2),
        .r12_0(r12_2),
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
        .r8_0(r8_3),
        .r9_0(r9_3),
        .r10_0(r10_3),
        .r11_0(r11_3),
        .r12_0(r12_3),
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
        .r8_0(r8_4),
        .r9_0(r9_4),
        .r10_0(r10_4),
        .r11_0(r11_4),
        .r12_0(r12_4),
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
        .r8_0(r8_5),
        .r9_0(r9_5),
        .r10_0(r10_5),
        .r11_0(r11_5),
        .r12_0(r12_5),
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
        .r8_0(r8_6),
        .r9_0(r9_6),
        .r10_0(r10_6),
        .r11_0(r11_6),
        .r12_0(r12_6),
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
        .r8_0(r8_7),
        .r9_0(r9_7),
        .r10_0(r10_7),
        .r11_0(r11_7),
        .r12_0(r12_7),
        .masked_activation(masked_activation7),
        .mask(mask7)
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
  input  wire [15:0] w1_0_1, w1_1_1,
  input  wire [15:0] w2_0_1, w2_1_1,
  input  wire [15:0] w3_0_1, w3_1_1,
  input  wire [15:0] w4_0_1, w4_1_1,
  input  wire [15:0] w5_0_1, w5_1_1,
  input  wire [15:0] w6_0_1, w6_1_1,
  input  wire [15:0] w7_0_1, w7_1_1,
  input  wire [15:0] w8_0_1, w8_1_1,
  input  wire [11:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1,
  input  wire r0_0,
  input  wire r1_0,
  input  wire r2_0,
  input  wire r3_0,
  input  wire r4_0,
  input  wire r5_0,
  input  wire r6_0,
  input  wire r7_0,
  input  wire r8_0,
  input  wire r9_0,
  input  wire r10_0,
  input  wire r11_0,
  input  wire r12_0,
  input  wire r0_1,
  input  wire r1_1,
  input  wire r2_1,
  input  wire r3_1,
  input  wire r4_1,
  input  wire r5_1,
  input  wire r6_1,
  input  wire r7_1,
  input  wire r8_1,
  input  wire r9_1,
  input  wire r10_1,
  input  wire r11_1,
  input  wire r12_1,
  input  wire r0_2,
  input  wire r1_2,
  input  wire r2_2,
  input  wire r3_2,
  input  wire r4_2,
  input  wire r5_2,
  input  wire r6_2,
  input  wire r7_2,
  input  wire r8_2,
  input  wire r9_2,
  input  wire r10_2,
  input  wire r11_2,
  input  wire r12_2,
  input  wire r0_3,
  input  wire r1_3,
  input  wire r2_3,
  input  wire r3_3,
  input  wire r4_3,
  input  wire r5_3,
  input  wire r6_3,
  input  wire r7_3,
  input  wire r8_3,
  input  wire r9_3,
  input  wire r10_3,
  input  wire r11_3,
  input  wire r12_3,
  input  wire r0_4,
  input  wire r1_4,
  input  wire r2_4,
  input  wire r3_4,
  input  wire r4_4,
  input  wire r5_4,
  input  wire r6_4,
  input  wire r7_4,
  input  wire r8_4,
  input  wire r9_4,
  input  wire r10_4,
  input  wire r11_4,
  input  wire r12_4,
  input  wire r0_5,
  input  wire r1_5,
  input  wire r2_5,
  input  wire r3_5,
  input  wire r4_5,
  input  wire r5_5,
  input  wire r6_5,
  input  wire r7_5,
  input  wire r8_5,
  input  wire r9_5,
  input  wire r10_5,
  input  wire r11_5,
  input  wire r12_5,
  input  wire r0_6,
  input  wire r1_6,
  input  wire r2_6,
  input  wire r3_6,
  input  wire r4_6,
  input  wire r5_6,
  input  wire r6_6,
  input  wire r7_6,
  input  wire r8_6,
  input  wire r9_6,
  input  wire r10_6,
  input  wire r11_6,
  input  wire r12_6,
  input  wire r0_7,
  input  wire r1_7,
  input  wire r2_7,
  input  wire r3_7,
  input  wire r4_7,
  input  wire r5_7,
  input  wire r6_7,
  input  wire r7_7,
  input  wire r8_7,
  input  wire r9_7,
  input  wire r10_7,
  input  wire r11_7,
  input  wire r12_7,
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
  output wire mask7_1, mask7bar_1
);

  wire [12:0] biased_sum0_0, biased_sum0_0bar;
  wire [12:0] biased_sum0_1, biased_sum0_1bar;
  wire [12:0] biased_sum1_0, biased_sum1_0bar;
  wire [12:0] biased_sum1_1, biased_sum1_1bar;
  wire [12:0] biased_sum2_0, biased_sum2_0bar;
  wire [12:0] biased_sum2_1, biased_sum2_1bar;
  wire [12:0] biased_sum3_0, biased_sum3_0bar;
  wire [12:0] biased_sum3_1, biased_sum3_1bar;
  wire [12:0] biased_sum4_0, biased_sum4_0bar;
  wire [12:0] biased_sum4_1, biased_sum4_1bar;
  wire [12:0] biased_sum5_0, biased_sum5_0bar;
  wire [12:0] biased_sum5_1, biased_sum5_1bar;
  wire [12:0] biased_sum6_0, biased_sum6_0bar;
  wire [12:0] biased_sum6_1, biased_sum6_1bar;
  wire [12:0] biased_sum7_0, biased_sum7_0bar;
  wire [12:0] biased_sum7_1, biased_sum7_1bar;

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
    .r8_0(r8_0),
    .r9_0(r9_0),
    .r10_0(r10_0),
    .r11_0(r11_0),
    .r12_0(r12_0),
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
    .r12_1(r12_1),
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
    .r12_2(r12_2),
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
    .r12_3(r12_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r6_4(r6_4),
    .r7_4(r7_4),
    .r8_4(r8_4),
    .r9_4(r9_4),
    .r10_4(r10_4),
    .r11_4(r11_4),
    .r12_4(r12_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r6_5(r6_5),
    .r7_5(r7_5),
    .r8_5(r8_5),
    .r9_5(r9_5),
    .r10_5(r10_5),
    .r11_5(r11_5),
    .r12_5(r12_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r6_6(r6_6),
    .r7_6(r7_6),
    .r8_6(r8_6),
    .r9_6(r9_6),
    .r10_6(r10_6),
    .r11_6(r11_6),
    .r12_6(r12_6),
    .r0_7(r0_7),
    .r1_7(r1_7),
    .r2_7(r2_7),
    .r3_7(r3_7),
    .r4_7(r4_7),
    .r5_7(r5_7),
    .r6_7(r6_7),
    .r7_7(r7_7),
    .r8_7(r8_7),
    .r9_7(r9_7),
    .r10_7(r10_7),
    .r11_7(r11_7),
    .r12_7(r12_7),
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
    .r8_0(r8_0),
    .r9_0(r9_0),
    .r10_0(r10_0),
    .r11_0(r11_0),
    .r12_0(r12_0),
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
    .r12_1(r12_1),
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
    .r12_2(r12_2),
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
    .r12_3(r12_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r6_4(r6_4),
    .r7_4(r7_4),
    .r8_4(r8_4),
    .r9_4(r9_4),
    .r10_4(r10_4),
    .r11_4(r11_4),
    .r12_4(r12_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r6_5(r6_5),
    .r7_5(r7_5),
    .r8_5(r8_5),
    .r9_5(r9_5),
    .r10_5(r10_5),
    .r11_5(r11_5),
    .r12_5(r12_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r6_6(r6_6),
    .r7_6(r7_6),
    .r8_6(r8_6),
    .r9_6(r9_6),
    .r10_6(r10_6),
    .r11_6(r11_6),
    .r12_6(r12_6),
    .r0_7(r0_7),
    .r1_7(r1_7),
    .r2_7(r2_7),
    .r3_7(r3_7),
    .r4_7(r4_7),
    .r5_7(r5_7),
    .r6_7(r6_7),
    .r7_7(r7_7),
    .r8_7(r8_7),
    .r9_7(r9_7),
    .r10_7(r10_7),
    .r11_7(r11_7),
    .r12_7(r12_7),
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

    always @(posedge clk) begin
    $display("----- LAYER 1   boolean activations -----");
    $display("masked_activation : %b %b %b %b %b %b %b %b", masked_activation0_1, masked_activation1_1, masked_activation2_1, masked_activation3_1, masked_activation4_1, masked_activation5_1, masked_activation6_1, masked_activation7_1);
    $display("masked_activationbar : %b %b %b %b %b %b %b %b", masked_activation0bar_1, masked_activation1bar_1, masked_activation2bar_1, masked_activation3bar_1, masked_activation4bar_1, masked_activation5bar_1, masked_activation6bar_1, masked_activation7bar_1);
    $display("mask : %b %b %b %b %b %b %b %b", mask0_1, mask1_1, mask2_1, mask3_1, mask4_1, mask5_1, mask6_1, mask7_1);
    $display("maskbar : %b %b %b %b %b %b %b %b", mask0bar_1, mask1bar_1, mask2bar_1, mask3bar_1, mask4bar_1, mask5bar_1, mask6bar_1, mask7bar_1);
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

module add1bitbar_2(
    input wire [0:0] a,
    input wire [0:0] b,
    input wire  cin,
    output wire [1:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;

full_adderbar_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));

WddlNANDbar_2 wn1(.A(~a[0]), .B(b[0]), .C(~c1), .S(s1), .S1(s1_1));
WddlNANDbar_2 wn2(.A(a[0]), .B(~b[0]), .C(~c1), .S(s2), .S1(s2_1));
WddlNANDbar_2 wn3(.A(a[0]), .B(b[0]), .C(c1), .S(s3), .S1(s3_1));
WddlNANDbar_2 wn4(.A(~a[0]), .B(~b[0]), .C(c1), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[1] = cout_bar;

endmodule

module add2bitbar_2(
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

full_adderbar_2 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_2 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));

WddlNANDbar_2 wn1(.A(~a[1]), .B(b[1]), .C(~c2), .S(s1), .S1(s1_1));
WddlNANDbar_2 wn2(.A(a[1]), .B(~b[1]), .C(~c2), .S(s2), .S1(s2_1));
WddlNANDbar_2 wn3(.A(a[1]), .B(b[1]), .C(c2), .S(s3), .S1(s3_1));
WddlNANDbar_2 wn4(.A(~a[1]), .B(~b[1]), .C(c2), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[2] = cout_bar;

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


module adder_tree_bar_2 (
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

    wire [1:0] stage0_0_lo_bar_2;
    wire [1:0] stage0_1_lo_bar_2;
    wire [1:0] stage0_2_lo_bar_2;
    wire [1:0] stage0_3_lo_bar_2;
    wire [1:0] stage0_4_lo_bar_2;
    wire [1:0] stage0_5_lo_bar_2;
    wire [1:0] stage0_6_lo_bar_2;
    wire [1:0] stage0_7_lo_bar_2;
    wire [2:0] stage1_0_lo_bar_2;
    wire [2:0] stage1_1_lo_bar_2;
    wire [2:0] stage1_2_lo_bar_2;
    wire [2:0] stage1_3_lo_bar_2;
    wire [3:0] stage2_0_lo_bar_2;
    wire [3:0] stage2_1_lo_bar_2;
    wire [4:0] stage3_0_lo_bar_2;
    reg  [1:0] stage0_0_bar_2;
    reg  [1:0] stage0_1_bar_2;
    reg  [1:0] stage0_2_bar_2;
    reg  [1:0] stage0_3_bar_2;
    reg  [1:0] stage0_4_bar_2;
    reg  [1:0] stage0_5_bar_2;
    reg  [1:0] stage0_6_bar_2;
    reg  [1:0] stage0_7_bar_2;
    reg  [2:0] stage1_0_bar_2;
    reg  [2:0] stage1_1_bar_2;
    reg  [2:0] stage1_2_bar_2;
    reg  [2:0] stage1_3_bar_2;
    reg  [3:0] stage2_0_bar_2;
    reg  [3:0] stage2_1_bar_2;
    reg  [4:0] stage3_0_bar_2;

    add1bitbar_2 u0_0_bar (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_bar_2), .cout(), .cout_bar());
    add1bitbar_2 u0_1_bar (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_bar_2), .cout(), .cout_bar());
    add1bitbar_2 u0_2_bar (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_bar_2), .cout(), .cout_bar());
    add1bitbar_2 u0_3_bar (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_bar_2), .cout(), .cout_bar());
    add1bitbar_2 u0_4_bar (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_bar_2), .cout(), .cout_bar());
    add1bitbar_2 u0_5_bar (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_bar_2), .cout(), .cout_bar());
    add1bitbar_2 u0_6_bar (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_bar_2), .cout(), .cout_bar());
    add1bitbar_2 u0_7_bar (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_bar_2), .cout(), .cout_bar());
    add2bitbar_2 u1_0_bar (.a(stage0_0_bar_2), .b(stage0_1_bar_2), .cin(1'b0), .y(stage1_0_lo_bar_2), .cout(), .cout_bar());
    add2bitbar_2 u1_1_bar (.a(stage0_2_bar_2), .b(stage0_3_bar_2), .cin(1'b0), .y(stage1_1_lo_bar_2), .cout(), .cout_bar());
    add2bitbar_2 u1_2_bar (.a(stage0_4_bar_2), .b(stage0_5_bar_2), .cin(1'b0), .y(stage1_2_lo_bar_2), .cout(), .cout_bar());
    add2bitbar_2 u1_3_bar (.a(stage0_6_bar_2), .b(stage0_7_bar_2), .cin(1'b0), .y(stage1_3_lo_bar_2), .cout(), .cout_bar());
    add3bitbar_2 u2_0_bar (.a(stage1_0_bar_2), .b(stage1_1_bar_2), .cin(1'b0), .y(stage2_0_lo_bar_2), .cout(), .cout_bar());
    add3bitbar_2 u2_1_bar (.a(stage1_2_bar_2), .b(stage1_3_bar_2), .cin(1'b0), .y(stage2_1_lo_bar_2), .cout(), .cout_bar());
    add4bitbar_2 u3_0_bar (.a(stage2_0_bar_2), .b(stage2_1_bar_2), .cin(1'b0), .y(stage3_0_lo_bar_2), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_bar_2;

    always @(posedge clk) begin
        stage0_0_bar_2 <=  stage0_0_lo_bar_2;
        stage0_1_bar_2 <=  stage0_1_lo_bar_2;
        stage0_2_bar_2 <=  stage0_2_lo_bar_2;
        stage0_3_bar_2 <=  stage0_3_lo_bar_2;
        stage0_4_bar_2 <=  stage0_4_lo_bar_2;
        stage0_5_bar_2 <=  stage0_5_lo_bar_2;
        stage0_6_bar_2 <=  stage0_6_lo_bar_2;
        stage0_7_bar_2 <=  stage0_7_lo_bar_2;
        stage1_0_bar_2 <=  stage1_0_lo_bar_2;
        stage1_1_bar_2 <=  stage1_1_lo_bar_2;
        stage1_2_bar_2 <=  stage1_2_lo_bar_2;
        stage1_3_bar_2 <=  stage1_3_lo_bar_2;
        stage2_0_bar_2 <=  stage2_0_lo_bar_2;
        stage2_1_bar_2 <=  stage2_1_lo_bar_2;
        stage3_0_bar_2 <=  stage3_0_lo_bar_2;
    end
endmodule


module layer2(
    input clk,
    input [0:0] inputs0_2 , inputs1_2 , inputs2_2 , inputs3_2 , inputs4_2 , inputs5_2 , inputs6_2 , inputs7_2 , inputs8_2 , inputs9_2 , inputs10_2 , inputs11_2 , inputs12_2 , inputs13_2 , inputs14_2 , inputs15_2,
    input [15:0] w1_0_2, w1_1_2, w2_0_2, w2_1_2, w3_0_2, w3_1_2, w4_0_2, w4_1_2, w5_0_2, w5_1_2, w6_0_2, w6_1_2, w7_0_2, w7_1_2, w8_0_2, w8_1_2,
    input [4:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2,
    output [5:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar, biased_sum4_0, biased_sum4_1, biased_sum4_0bar, biased_sum4_1bar, biased_sum5_0, biased_sum5_1, biased_sum5_0bar, biased_sum5_1bar, biased_sum6_0, biased_sum6_1, biased_sum6_0bar, biased_sum6_1bar, biased_sum7_0, biased_sum7_1, biased_sum7_0bar, biased_sum7_1bar
);
    wire [0:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [0:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [0:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [0:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [0:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [0:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [0:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [0:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [0:0] weighted_inputs1_8_0, weighted_inputs1_8_1;
    wire [0:0] weighted_inputs1_9_0, weighted_inputs1_9_1;
    wire [0:0] weighted_inputs1_10_0, weighted_inputs1_10_1;
    wire [0:0] weighted_inputs1_11_0, weighted_inputs1_11_1;
    wire [0:0] weighted_inputs1_12_0, weighted_inputs1_12_1;
    wire [0:0] weighted_inputs1_13_0, weighted_inputs1_13_1;
    wire [0:0] weighted_inputs1_14_0, weighted_inputs1_14_1;
    wire [0:0] weighted_inputs1_15_0, weighted_inputs1_15_1;
    wire [0:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [0:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [0:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [0:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [0:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [0:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [0:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [0:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [0:0] weighted_inputs2_8_0, weighted_inputs2_8_1;
    wire [0:0] weighted_inputs2_9_0, weighted_inputs2_9_1;
    wire [0:0] weighted_inputs2_10_0, weighted_inputs2_10_1;
    wire [0:0] weighted_inputs2_11_0, weighted_inputs2_11_1;
    wire [0:0] weighted_inputs2_12_0, weighted_inputs2_12_1;
    wire [0:0] weighted_inputs2_13_0, weighted_inputs2_13_1;
    wire [0:0] weighted_inputs2_14_0, weighted_inputs2_14_1;
    wire [0:0] weighted_inputs2_15_0, weighted_inputs2_15_1;
    wire [0:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [0:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [0:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [0:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [0:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [0:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [0:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [0:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [0:0] weighted_inputs3_8_0, weighted_inputs3_8_1;
    wire [0:0] weighted_inputs3_9_0, weighted_inputs3_9_1;
    wire [0:0] weighted_inputs3_10_0, weighted_inputs3_10_1;
    wire [0:0] weighted_inputs3_11_0, weighted_inputs3_11_1;
    wire [0:0] weighted_inputs3_12_0, weighted_inputs3_12_1;
    wire [0:0] weighted_inputs3_13_0, weighted_inputs3_13_1;
    wire [0:0] weighted_inputs3_14_0, weighted_inputs3_14_1;
    wire [0:0] weighted_inputs3_15_0, weighted_inputs3_15_1;
    wire [0:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [0:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [0:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [0:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [0:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [0:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [0:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [0:0] weighted_inputs4_7_0, weighted_inputs4_7_1;
    wire [0:0] weighted_inputs4_8_0, weighted_inputs4_8_1;
    wire [0:0] weighted_inputs4_9_0, weighted_inputs4_9_1;
    wire [0:0] weighted_inputs4_10_0, weighted_inputs4_10_1;
    wire [0:0] weighted_inputs4_11_0, weighted_inputs4_11_1;
    wire [0:0] weighted_inputs4_12_0, weighted_inputs4_12_1;
    wire [0:0] weighted_inputs4_13_0, weighted_inputs4_13_1;
    wire [0:0] weighted_inputs4_14_0, weighted_inputs4_14_1;
    wire [0:0] weighted_inputs4_15_0, weighted_inputs4_15_1;
    wire [0:0] weighted_inputs5_0_0, weighted_inputs5_0_1;
    wire [0:0] weighted_inputs5_1_0, weighted_inputs5_1_1;
    wire [0:0] weighted_inputs5_2_0, weighted_inputs5_2_1;
    wire [0:0] weighted_inputs5_3_0, weighted_inputs5_3_1;
    wire [0:0] weighted_inputs5_4_0, weighted_inputs5_4_1;
    wire [0:0] weighted_inputs5_5_0, weighted_inputs5_5_1;
    wire [0:0] weighted_inputs5_6_0, weighted_inputs5_6_1;
    wire [0:0] weighted_inputs5_7_0, weighted_inputs5_7_1;
    wire [0:0] weighted_inputs5_8_0, weighted_inputs5_8_1;
    wire [0:0] weighted_inputs5_9_0, weighted_inputs5_9_1;
    wire [0:0] weighted_inputs5_10_0, weighted_inputs5_10_1;
    wire [0:0] weighted_inputs5_11_0, weighted_inputs5_11_1;
    wire [0:0] weighted_inputs5_12_0, weighted_inputs5_12_1;
    wire [0:0] weighted_inputs5_13_0, weighted_inputs5_13_1;
    wire [0:0] weighted_inputs5_14_0, weighted_inputs5_14_1;
    wire [0:0] weighted_inputs5_15_0, weighted_inputs5_15_1;
    wire [0:0] weighted_inputs6_0_0, weighted_inputs6_0_1;
    wire [0:0] weighted_inputs6_1_0, weighted_inputs6_1_1;
    wire [0:0] weighted_inputs6_2_0, weighted_inputs6_2_1;
    wire [0:0] weighted_inputs6_3_0, weighted_inputs6_3_1;
    wire [0:0] weighted_inputs6_4_0, weighted_inputs6_4_1;
    wire [0:0] weighted_inputs6_5_0, weighted_inputs6_5_1;
    wire [0:0] weighted_inputs6_6_0, weighted_inputs6_6_1;
    wire [0:0] weighted_inputs6_7_0, weighted_inputs6_7_1;
    wire [0:0] weighted_inputs6_8_0, weighted_inputs6_8_1;
    wire [0:0] weighted_inputs6_9_0, weighted_inputs6_9_1;
    wire [0:0] weighted_inputs6_10_0, weighted_inputs6_10_1;
    wire [0:0] weighted_inputs6_11_0, weighted_inputs6_11_1;
    wire [0:0] weighted_inputs6_12_0, weighted_inputs6_12_1;
    wire [0:0] weighted_inputs6_13_0, weighted_inputs6_13_1;
    wire [0:0] weighted_inputs6_14_0, weighted_inputs6_14_1;
    wire [0:0] weighted_inputs6_15_0, weighted_inputs6_15_1;
    wire [0:0] weighted_inputs7_0_0, weighted_inputs7_0_1;
    wire [0:0] weighted_inputs7_1_0, weighted_inputs7_1_1;
    wire [0:0] weighted_inputs7_2_0, weighted_inputs7_2_1;
    wire [0:0] weighted_inputs7_3_0, weighted_inputs7_3_1;
    wire [0:0] weighted_inputs7_4_0, weighted_inputs7_4_1;
    wire [0:0] weighted_inputs7_5_0, weighted_inputs7_5_1;
    wire [0:0] weighted_inputs7_6_0, weighted_inputs7_6_1;
    wire [0:0] weighted_inputs7_7_0, weighted_inputs7_7_1;
    wire [0:0] weighted_inputs7_8_0, weighted_inputs7_8_1;
    wire [0:0] weighted_inputs7_9_0, weighted_inputs7_9_1;
    wire [0:0] weighted_inputs7_10_0, weighted_inputs7_10_1;
    wire [0:0] weighted_inputs7_11_0, weighted_inputs7_11_1;
    wire [0:0] weighted_inputs7_12_0, weighted_inputs7_12_1;
    wire [0:0] weighted_inputs7_13_0, weighted_inputs7_13_1;
    wire [0:0] weighted_inputs7_14_0, weighted_inputs7_14_1;
    wire [0:0] weighted_inputs7_15_0, weighted_inputs7_15_1;
    wire [0:0] weighted_inputs8_0_0, weighted_inputs8_0_1;
    wire [0:0] weighted_inputs8_1_0, weighted_inputs8_1_1;
    wire [0:0] weighted_inputs8_2_0, weighted_inputs8_2_1;
    wire [0:0] weighted_inputs8_3_0, weighted_inputs8_3_1;
    wire [0:0] weighted_inputs8_4_0, weighted_inputs8_4_1;
    wire [0:0] weighted_inputs8_5_0, weighted_inputs8_5_1;
    wire [0:0] weighted_inputs8_6_0, weighted_inputs8_6_1;
    wire [0:0] weighted_inputs8_7_0, weighted_inputs8_7_1;
    wire [0:0] weighted_inputs8_8_0, weighted_inputs8_8_1;
    wire [0:0] weighted_inputs8_9_0, weighted_inputs8_9_1;
    wire [0:0] weighted_inputs8_10_0, weighted_inputs8_10_1;
    wire [0:0] weighted_inputs8_11_0, weighted_inputs8_11_1;
    wire [0:0] weighted_inputs8_12_0, weighted_inputs8_12_1;
    wire [0:0] weighted_inputs8_13_0, weighted_inputs8_13_1;
    wire [0:0] weighted_inputs8_14_0, weighted_inputs8_14_1;
    wire [0:0] weighted_inputs8_15_0, weighted_inputs8_15_1;

    wire [4:0] sum1 [7:0];
    wire [4:0] sum2 [7:0];
    wire [5:0] biased_sum1 [7:0];
    wire [5:0] biased_sum2 [7:0];
    wire [4:0] sum1bar [7:0];
    wire [4:0] sum2bar [7:0];
    wire [5:0] biased_sum1bar [7:0];
    wire [5:0] biased_sum2bar [7:0];
    weighted_inputs_2 w0 (.inputs(inputs0_2), .w(w1_0_2[0]), .wi(weighted_inputs1_0_0));
    weighted_inputs_2 w0_bar (.inputs(inputs0_2), .w(w1_1_2[0]), .wi(weighted_inputs1_0_1));
    weighted_inputs_2 w1 (.inputs(inputs1_2), .w(w1_0_2[1]), .wi(weighted_inputs1_1_0));
    weighted_inputs_2 w1_bar (.inputs(inputs1_2), .w(w1_1_2[1]), .wi(weighted_inputs1_1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_2), .w(w1_0_2[2]), .wi(weighted_inputs1_2_0));
    weighted_inputs_2 w2_bar (.inputs(inputs2_2), .w(w1_1_2[2]), .wi(weighted_inputs1_2_1));
    weighted_inputs_2 w3 (.inputs(inputs3_2), .w(w1_0_2[3]), .wi(weighted_inputs1_3_0));
    weighted_inputs_2 w3_bar (.inputs(inputs3_2), .w(w1_1_2[3]), .wi(weighted_inputs1_3_1));
    weighted_inputs_2 w4 (.inputs(inputs4_2), .w(w1_0_2[4]), .wi(weighted_inputs1_4_0));
    weighted_inputs_2 w4_bar (.inputs(inputs4_2), .w(w1_1_2[4]), .wi(weighted_inputs1_4_1));
    weighted_inputs_2 w5 (.inputs(inputs5_2), .w(w1_0_2[5]), .wi(weighted_inputs1_5_0));
    weighted_inputs_2 w5_bar (.inputs(inputs5_2), .w(w1_1_2[5]), .wi(weighted_inputs1_5_1));
    weighted_inputs_2 w6 (.inputs(inputs6_2), .w(w1_0_2[6]), .wi(weighted_inputs1_6_0));
    weighted_inputs_2 w6_bar (.inputs(inputs6_2), .w(w1_1_2[6]), .wi(weighted_inputs1_6_1));
    weighted_inputs_2 w7 (.inputs(inputs7_2), .w(w1_0_2[7]), .wi(weighted_inputs1_7_0));
    weighted_inputs_2 w7_bar (.inputs(inputs7_2), .w(w1_1_2[7]), .wi(weighted_inputs1_7_1));
    weighted_inputs_2 w8 (.inputs(inputs8_2), .w(w1_0_2[8]), .wi(weighted_inputs1_8_0));
    weighted_inputs_2 w8_bar (.inputs(inputs8_2), .w(w1_1_2[8]), .wi(weighted_inputs1_8_1));
    weighted_inputs_2 w9 (.inputs(inputs9_2), .w(w1_0_2[9]), .wi(weighted_inputs1_9_0));
    weighted_inputs_2 w9_bar (.inputs(inputs9_2), .w(w1_1_2[9]), .wi(weighted_inputs1_9_1));
    weighted_inputs_2 w10 (.inputs(inputs10_2), .w(w1_0_2[10]), .wi(weighted_inputs1_10_0));
    weighted_inputs_2 w10_bar (.inputs(inputs10_2), .w(w1_1_2[10]), .wi(weighted_inputs1_10_1));
    weighted_inputs_2 w11 (.inputs(inputs11_2), .w(w1_0_2[11]), .wi(weighted_inputs1_11_0));
    weighted_inputs_2 w11_bar (.inputs(inputs11_2), .w(w1_1_2[11]), .wi(weighted_inputs1_11_1));
    weighted_inputs_2 w12 (.inputs(inputs12_2), .w(w1_0_2[12]), .wi(weighted_inputs1_12_0));
    weighted_inputs_2 w12_bar (.inputs(inputs12_2), .w(w1_1_2[12]), .wi(weighted_inputs1_12_1));
    weighted_inputs_2 w13 (.inputs(inputs13_2), .w(w1_0_2[13]), .wi(weighted_inputs1_13_0));
    weighted_inputs_2 w13_bar (.inputs(inputs13_2), .w(w1_1_2[13]), .wi(weighted_inputs1_13_1));
    weighted_inputs_2 w14 (.inputs(inputs14_2), .w(w1_0_2[14]), .wi(weighted_inputs1_14_0));
    weighted_inputs_2 w14_bar (.inputs(inputs14_2), .w(w1_1_2[14]), .wi(weighted_inputs1_14_1));
    weighted_inputs_2 w15 (.inputs(inputs15_2), .w(w1_0_2[15]), .wi(weighted_inputs1_15_0));
    weighted_inputs_2 w15_bar (.inputs(inputs15_2), .w(w1_1_2[15]), .wi(weighted_inputs1_15_1));
    weighted_inputs_2 w16 (.inputs(inputs0_2), .w(w2_0_2[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_2 w16_bar (.inputs(inputs0_2), .w(w2_1_2[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_2 w17 (.inputs(inputs1_2), .w(w2_0_2[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_2 w17_bar (.inputs(inputs1_2), .w(w2_1_2[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_2 w18 (.inputs(inputs2_2), .w(w2_0_2[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_2 w18_bar (.inputs(inputs2_2), .w(w2_1_2[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_2 w19 (.inputs(inputs3_2), .w(w2_0_2[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_2 w19_bar (.inputs(inputs3_2), .w(w2_1_2[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_2 w20 (.inputs(inputs4_2), .w(w2_0_2[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_2 w20_bar (.inputs(inputs4_2), .w(w2_1_2[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_2 w21 (.inputs(inputs5_2), .w(w2_0_2[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_2 w21_bar (.inputs(inputs5_2), .w(w2_1_2[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_2 w22 (.inputs(inputs6_2), .w(w2_0_2[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_2 w22_bar (.inputs(inputs6_2), .w(w2_1_2[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_2 w23 (.inputs(inputs7_2), .w(w2_0_2[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_2 w23_bar (.inputs(inputs7_2), .w(w2_1_2[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_2 w24 (.inputs(inputs8_2), .w(w2_0_2[8]), .wi(weighted_inputs2_8_0));
    weighted_inputs_2 w24_bar (.inputs(inputs8_2), .w(w2_1_2[8]), .wi(weighted_inputs2_8_1));
    weighted_inputs_2 w25 (.inputs(inputs9_2), .w(w2_0_2[9]), .wi(weighted_inputs2_9_0));
    weighted_inputs_2 w25_bar (.inputs(inputs9_2), .w(w2_1_2[9]), .wi(weighted_inputs2_9_1));
    weighted_inputs_2 w26 (.inputs(inputs10_2), .w(w2_0_2[10]), .wi(weighted_inputs2_10_0));
    weighted_inputs_2 w26_bar (.inputs(inputs10_2), .w(w2_1_2[10]), .wi(weighted_inputs2_10_1));
    weighted_inputs_2 w27 (.inputs(inputs11_2), .w(w2_0_2[11]), .wi(weighted_inputs2_11_0));
    weighted_inputs_2 w27_bar (.inputs(inputs11_2), .w(w2_1_2[11]), .wi(weighted_inputs2_11_1));
    weighted_inputs_2 w28 (.inputs(inputs12_2), .w(w2_0_2[12]), .wi(weighted_inputs2_12_0));
    weighted_inputs_2 w28_bar (.inputs(inputs12_2), .w(w2_1_2[12]), .wi(weighted_inputs2_12_1));
    weighted_inputs_2 w29 (.inputs(inputs13_2), .w(w2_0_2[13]), .wi(weighted_inputs2_13_0));
    weighted_inputs_2 w29_bar (.inputs(inputs13_2), .w(w2_1_2[13]), .wi(weighted_inputs2_13_1));
    weighted_inputs_2 w30 (.inputs(inputs14_2), .w(w2_0_2[14]), .wi(weighted_inputs2_14_0));
    weighted_inputs_2 w30_bar (.inputs(inputs14_2), .w(w2_1_2[14]), .wi(weighted_inputs2_14_1));
    weighted_inputs_2 w31 (.inputs(inputs15_2), .w(w2_0_2[15]), .wi(weighted_inputs2_15_0));
    weighted_inputs_2 w31_bar (.inputs(inputs15_2), .w(w2_1_2[15]), .wi(weighted_inputs2_15_1));
    weighted_inputs_2 w32 (.inputs(inputs0_2), .w(w3_0_2[0]), .wi(weighted_inputs3_0_0));
    weighted_inputs_2 w32_bar (.inputs(inputs0_2), .w(w3_1_2[0]), .wi(weighted_inputs3_0_1));
    weighted_inputs_2 w33 (.inputs(inputs1_2), .w(w3_0_2[1]), .wi(weighted_inputs3_1_0));
    weighted_inputs_2 w33_bar (.inputs(inputs1_2), .w(w3_1_2[1]), .wi(weighted_inputs3_1_1));
    weighted_inputs_2 w34 (.inputs(inputs2_2), .w(w3_0_2[2]), .wi(weighted_inputs3_2_0));
    weighted_inputs_2 w34_bar (.inputs(inputs2_2), .w(w3_1_2[2]), .wi(weighted_inputs3_2_1));
    weighted_inputs_2 w35 (.inputs(inputs3_2), .w(w3_0_2[3]), .wi(weighted_inputs3_3_0));
    weighted_inputs_2 w35_bar (.inputs(inputs3_2), .w(w3_1_2[3]), .wi(weighted_inputs3_3_1));
    weighted_inputs_2 w36 (.inputs(inputs4_2), .w(w3_0_2[4]), .wi(weighted_inputs3_4_0));
    weighted_inputs_2 w36_bar (.inputs(inputs4_2), .w(w3_1_2[4]), .wi(weighted_inputs3_4_1));
    weighted_inputs_2 w37 (.inputs(inputs5_2), .w(w3_0_2[5]), .wi(weighted_inputs3_5_0));
    weighted_inputs_2 w37_bar (.inputs(inputs5_2), .w(w3_1_2[5]), .wi(weighted_inputs3_5_1));
    weighted_inputs_2 w38 (.inputs(inputs6_2), .w(w3_0_2[6]), .wi(weighted_inputs3_6_0));
    weighted_inputs_2 w38_bar (.inputs(inputs6_2), .w(w3_1_2[6]), .wi(weighted_inputs3_6_1));
    weighted_inputs_2 w39 (.inputs(inputs7_2), .w(w3_0_2[7]), .wi(weighted_inputs3_7_0));
    weighted_inputs_2 w39_bar (.inputs(inputs7_2), .w(w3_1_2[7]), .wi(weighted_inputs3_7_1));
    weighted_inputs_2 w40 (.inputs(inputs8_2), .w(w3_0_2[8]), .wi(weighted_inputs3_8_0));
    weighted_inputs_2 w40_bar (.inputs(inputs8_2), .w(w3_1_2[8]), .wi(weighted_inputs3_8_1));
    weighted_inputs_2 w41 (.inputs(inputs9_2), .w(w3_0_2[9]), .wi(weighted_inputs3_9_0));
    weighted_inputs_2 w41_bar (.inputs(inputs9_2), .w(w3_1_2[9]), .wi(weighted_inputs3_9_1));
    weighted_inputs_2 w42 (.inputs(inputs10_2), .w(w3_0_2[10]), .wi(weighted_inputs3_10_0));
    weighted_inputs_2 w42_bar (.inputs(inputs10_2), .w(w3_1_2[10]), .wi(weighted_inputs3_10_1));
    weighted_inputs_2 w43 (.inputs(inputs11_2), .w(w3_0_2[11]), .wi(weighted_inputs3_11_0));
    weighted_inputs_2 w43_bar (.inputs(inputs11_2), .w(w3_1_2[11]), .wi(weighted_inputs3_11_1));
    weighted_inputs_2 w44 (.inputs(inputs12_2), .w(w3_0_2[12]), .wi(weighted_inputs3_12_0));
    weighted_inputs_2 w44_bar (.inputs(inputs12_2), .w(w3_1_2[12]), .wi(weighted_inputs3_12_1));
    weighted_inputs_2 w45 (.inputs(inputs13_2), .w(w3_0_2[13]), .wi(weighted_inputs3_13_0));
    weighted_inputs_2 w45_bar (.inputs(inputs13_2), .w(w3_1_2[13]), .wi(weighted_inputs3_13_1));
    weighted_inputs_2 w46 (.inputs(inputs14_2), .w(w3_0_2[14]), .wi(weighted_inputs3_14_0));
    weighted_inputs_2 w46_bar (.inputs(inputs14_2), .w(w3_1_2[14]), .wi(weighted_inputs3_14_1));
    weighted_inputs_2 w47 (.inputs(inputs15_2), .w(w3_0_2[15]), .wi(weighted_inputs3_15_0));
    weighted_inputs_2 w47_bar (.inputs(inputs15_2), .w(w3_1_2[15]), .wi(weighted_inputs3_15_1));
    weighted_inputs_2 w48 (.inputs(inputs0_2), .w(w4_0_2[0]), .wi(weighted_inputs4_0_0));
    weighted_inputs_2 w48_bar (.inputs(inputs0_2), .w(w4_1_2[0]), .wi(weighted_inputs4_0_1));
    weighted_inputs_2 w49 (.inputs(inputs1_2), .w(w4_0_2[1]), .wi(weighted_inputs4_1_0));
    weighted_inputs_2 w49_bar (.inputs(inputs1_2), .w(w4_1_2[1]), .wi(weighted_inputs4_1_1));
    weighted_inputs_2 w50 (.inputs(inputs2_2), .w(w4_0_2[2]), .wi(weighted_inputs4_2_0));
    weighted_inputs_2 w50_bar (.inputs(inputs2_2), .w(w4_1_2[2]), .wi(weighted_inputs4_2_1));
    weighted_inputs_2 w51 (.inputs(inputs3_2), .w(w4_0_2[3]), .wi(weighted_inputs4_3_0));
    weighted_inputs_2 w51_bar (.inputs(inputs3_2), .w(w4_1_2[3]), .wi(weighted_inputs4_3_1));
    weighted_inputs_2 w52 (.inputs(inputs4_2), .w(w4_0_2[4]), .wi(weighted_inputs4_4_0));
    weighted_inputs_2 w52_bar (.inputs(inputs4_2), .w(w4_1_2[4]), .wi(weighted_inputs4_4_1));
    weighted_inputs_2 w53 (.inputs(inputs5_2), .w(w4_0_2[5]), .wi(weighted_inputs4_5_0));
    weighted_inputs_2 w53_bar (.inputs(inputs5_2), .w(w4_1_2[5]), .wi(weighted_inputs4_5_1));
    weighted_inputs_2 w54 (.inputs(inputs6_2), .w(w4_0_2[6]), .wi(weighted_inputs4_6_0));
    weighted_inputs_2 w54_bar (.inputs(inputs6_2), .w(w4_1_2[6]), .wi(weighted_inputs4_6_1));
    weighted_inputs_2 w55 (.inputs(inputs7_2), .w(w4_0_2[7]), .wi(weighted_inputs4_7_0));
    weighted_inputs_2 w55_bar (.inputs(inputs7_2), .w(w4_1_2[7]), .wi(weighted_inputs4_7_1));
    weighted_inputs_2 w56 (.inputs(inputs8_2), .w(w4_0_2[8]), .wi(weighted_inputs4_8_0));
    weighted_inputs_2 w56_bar (.inputs(inputs8_2), .w(w4_1_2[8]), .wi(weighted_inputs4_8_1));
    weighted_inputs_2 w57 (.inputs(inputs9_2), .w(w4_0_2[9]), .wi(weighted_inputs4_9_0));
    weighted_inputs_2 w57_bar (.inputs(inputs9_2), .w(w4_1_2[9]), .wi(weighted_inputs4_9_1));
    weighted_inputs_2 w58 (.inputs(inputs10_2), .w(w4_0_2[10]), .wi(weighted_inputs4_10_0));
    weighted_inputs_2 w58_bar (.inputs(inputs10_2), .w(w4_1_2[10]), .wi(weighted_inputs4_10_1));
    weighted_inputs_2 w59 (.inputs(inputs11_2), .w(w4_0_2[11]), .wi(weighted_inputs4_11_0));
    weighted_inputs_2 w59_bar (.inputs(inputs11_2), .w(w4_1_2[11]), .wi(weighted_inputs4_11_1));
    weighted_inputs_2 w60 (.inputs(inputs12_2), .w(w4_0_2[12]), .wi(weighted_inputs4_12_0));
    weighted_inputs_2 w60_bar (.inputs(inputs12_2), .w(w4_1_2[12]), .wi(weighted_inputs4_12_1));
    weighted_inputs_2 w61 (.inputs(inputs13_2), .w(w4_0_2[13]), .wi(weighted_inputs4_13_0));
    weighted_inputs_2 w61_bar (.inputs(inputs13_2), .w(w4_1_2[13]), .wi(weighted_inputs4_13_1));
    weighted_inputs_2 w62 (.inputs(inputs14_2), .w(w4_0_2[14]), .wi(weighted_inputs4_14_0));
    weighted_inputs_2 w62_bar (.inputs(inputs14_2), .w(w4_1_2[14]), .wi(weighted_inputs4_14_1));
    weighted_inputs_2 w63 (.inputs(inputs15_2), .w(w4_0_2[15]), .wi(weighted_inputs4_15_0));
    weighted_inputs_2 w63_bar (.inputs(inputs15_2), .w(w4_1_2[15]), .wi(weighted_inputs4_15_1));
    weighted_inputs_2 w64 (.inputs(inputs0_2), .w(w5_0_2[0]), .wi(weighted_inputs5_0_0));
    weighted_inputs_2 w64_bar (.inputs(inputs0_2), .w(w5_1_2[0]), .wi(weighted_inputs5_0_1));
    weighted_inputs_2 w65 (.inputs(inputs1_2), .w(w5_0_2[1]), .wi(weighted_inputs5_1_0));
    weighted_inputs_2 w65_bar (.inputs(inputs1_2), .w(w5_1_2[1]), .wi(weighted_inputs5_1_1));
    weighted_inputs_2 w66 (.inputs(inputs2_2), .w(w5_0_2[2]), .wi(weighted_inputs5_2_0));
    weighted_inputs_2 w66_bar (.inputs(inputs2_2), .w(w5_1_2[2]), .wi(weighted_inputs5_2_1));
    weighted_inputs_2 w67 (.inputs(inputs3_2), .w(w5_0_2[3]), .wi(weighted_inputs5_3_0));
    weighted_inputs_2 w67_bar (.inputs(inputs3_2), .w(w5_1_2[3]), .wi(weighted_inputs5_3_1));
    weighted_inputs_2 w68 (.inputs(inputs4_2), .w(w5_0_2[4]), .wi(weighted_inputs5_4_0));
    weighted_inputs_2 w68_bar (.inputs(inputs4_2), .w(w5_1_2[4]), .wi(weighted_inputs5_4_1));
    weighted_inputs_2 w69 (.inputs(inputs5_2), .w(w5_0_2[5]), .wi(weighted_inputs5_5_0));
    weighted_inputs_2 w69_bar (.inputs(inputs5_2), .w(w5_1_2[5]), .wi(weighted_inputs5_5_1));
    weighted_inputs_2 w70 (.inputs(inputs6_2), .w(w5_0_2[6]), .wi(weighted_inputs5_6_0));
    weighted_inputs_2 w70_bar (.inputs(inputs6_2), .w(w5_1_2[6]), .wi(weighted_inputs5_6_1));
    weighted_inputs_2 w71 (.inputs(inputs7_2), .w(w5_0_2[7]), .wi(weighted_inputs5_7_0));
    weighted_inputs_2 w71_bar (.inputs(inputs7_2), .w(w5_1_2[7]), .wi(weighted_inputs5_7_1));
    weighted_inputs_2 w72 (.inputs(inputs8_2), .w(w5_0_2[8]), .wi(weighted_inputs5_8_0));
    weighted_inputs_2 w72_bar (.inputs(inputs8_2), .w(w5_1_2[8]), .wi(weighted_inputs5_8_1));
    weighted_inputs_2 w73 (.inputs(inputs9_2), .w(w5_0_2[9]), .wi(weighted_inputs5_9_0));
    weighted_inputs_2 w73_bar (.inputs(inputs9_2), .w(w5_1_2[9]), .wi(weighted_inputs5_9_1));
    weighted_inputs_2 w74 (.inputs(inputs10_2), .w(w5_0_2[10]), .wi(weighted_inputs5_10_0));
    weighted_inputs_2 w74_bar (.inputs(inputs10_2), .w(w5_1_2[10]), .wi(weighted_inputs5_10_1));
    weighted_inputs_2 w75 (.inputs(inputs11_2), .w(w5_0_2[11]), .wi(weighted_inputs5_11_0));
    weighted_inputs_2 w75_bar (.inputs(inputs11_2), .w(w5_1_2[11]), .wi(weighted_inputs5_11_1));
    weighted_inputs_2 w76 (.inputs(inputs12_2), .w(w5_0_2[12]), .wi(weighted_inputs5_12_0));
    weighted_inputs_2 w76_bar (.inputs(inputs12_2), .w(w5_1_2[12]), .wi(weighted_inputs5_12_1));
    weighted_inputs_2 w77 (.inputs(inputs13_2), .w(w5_0_2[13]), .wi(weighted_inputs5_13_0));
    weighted_inputs_2 w77_bar (.inputs(inputs13_2), .w(w5_1_2[13]), .wi(weighted_inputs5_13_1));
    weighted_inputs_2 w78 (.inputs(inputs14_2), .w(w5_0_2[14]), .wi(weighted_inputs5_14_0));
    weighted_inputs_2 w78_bar (.inputs(inputs14_2), .w(w5_1_2[14]), .wi(weighted_inputs5_14_1));
    weighted_inputs_2 w79 (.inputs(inputs15_2), .w(w5_0_2[15]), .wi(weighted_inputs5_15_0));
    weighted_inputs_2 w79_bar (.inputs(inputs15_2), .w(w5_1_2[15]), .wi(weighted_inputs5_15_1));
    weighted_inputs_2 w80 (.inputs(inputs0_2), .w(w6_0_2[0]), .wi(weighted_inputs6_0_0));
    weighted_inputs_2 w80_bar (.inputs(inputs0_2), .w(w6_1_2[0]), .wi(weighted_inputs6_0_1));
    weighted_inputs_2 w81 (.inputs(inputs1_2), .w(w6_0_2[1]), .wi(weighted_inputs6_1_0));
    weighted_inputs_2 w81_bar (.inputs(inputs1_2), .w(w6_1_2[1]), .wi(weighted_inputs6_1_1));
    weighted_inputs_2 w82 (.inputs(inputs2_2), .w(w6_0_2[2]), .wi(weighted_inputs6_2_0));
    weighted_inputs_2 w82_bar (.inputs(inputs2_2), .w(w6_1_2[2]), .wi(weighted_inputs6_2_1));
    weighted_inputs_2 w83 (.inputs(inputs3_2), .w(w6_0_2[3]), .wi(weighted_inputs6_3_0));
    weighted_inputs_2 w83_bar (.inputs(inputs3_2), .w(w6_1_2[3]), .wi(weighted_inputs6_3_1));
    weighted_inputs_2 w84 (.inputs(inputs4_2), .w(w6_0_2[4]), .wi(weighted_inputs6_4_0));
    weighted_inputs_2 w84_bar (.inputs(inputs4_2), .w(w6_1_2[4]), .wi(weighted_inputs6_4_1));
    weighted_inputs_2 w85 (.inputs(inputs5_2), .w(w6_0_2[5]), .wi(weighted_inputs6_5_0));
    weighted_inputs_2 w85_bar (.inputs(inputs5_2), .w(w6_1_2[5]), .wi(weighted_inputs6_5_1));
    weighted_inputs_2 w86 (.inputs(inputs6_2), .w(w6_0_2[6]), .wi(weighted_inputs6_6_0));
    weighted_inputs_2 w86_bar (.inputs(inputs6_2), .w(w6_1_2[6]), .wi(weighted_inputs6_6_1));
    weighted_inputs_2 w87 (.inputs(inputs7_2), .w(w6_0_2[7]), .wi(weighted_inputs6_7_0));
    weighted_inputs_2 w87_bar (.inputs(inputs7_2), .w(w6_1_2[7]), .wi(weighted_inputs6_7_1));
    weighted_inputs_2 w88 (.inputs(inputs8_2), .w(w6_0_2[8]), .wi(weighted_inputs6_8_0));
    weighted_inputs_2 w88_bar (.inputs(inputs8_2), .w(w6_1_2[8]), .wi(weighted_inputs6_8_1));
    weighted_inputs_2 w89 (.inputs(inputs9_2), .w(w6_0_2[9]), .wi(weighted_inputs6_9_0));
    weighted_inputs_2 w89_bar (.inputs(inputs9_2), .w(w6_1_2[9]), .wi(weighted_inputs6_9_1));
    weighted_inputs_2 w90 (.inputs(inputs10_2), .w(w6_0_2[10]), .wi(weighted_inputs6_10_0));
    weighted_inputs_2 w90_bar (.inputs(inputs10_2), .w(w6_1_2[10]), .wi(weighted_inputs6_10_1));
    weighted_inputs_2 w91 (.inputs(inputs11_2), .w(w6_0_2[11]), .wi(weighted_inputs6_11_0));
    weighted_inputs_2 w91_bar (.inputs(inputs11_2), .w(w6_1_2[11]), .wi(weighted_inputs6_11_1));
    weighted_inputs_2 w92 (.inputs(inputs12_2), .w(w6_0_2[12]), .wi(weighted_inputs6_12_0));
    weighted_inputs_2 w92_bar (.inputs(inputs12_2), .w(w6_1_2[12]), .wi(weighted_inputs6_12_1));
    weighted_inputs_2 w93 (.inputs(inputs13_2), .w(w6_0_2[13]), .wi(weighted_inputs6_13_0));
    weighted_inputs_2 w93_bar (.inputs(inputs13_2), .w(w6_1_2[13]), .wi(weighted_inputs6_13_1));
    weighted_inputs_2 w94 (.inputs(inputs14_2), .w(w6_0_2[14]), .wi(weighted_inputs6_14_0));
    weighted_inputs_2 w94_bar (.inputs(inputs14_2), .w(w6_1_2[14]), .wi(weighted_inputs6_14_1));
    weighted_inputs_2 w95 (.inputs(inputs15_2), .w(w6_0_2[15]), .wi(weighted_inputs6_15_0));
    weighted_inputs_2 w95_bar (.inputs(inputs15_2), .w(w6_1_2[15]), .wi(weighted_inputs6_15_1));
    weighted_inputs_2 w96 (.inputs(inputs0_2), .w(w7_0_2[0]), .wi(weighted_inputs7_0_0));
    weighted_inputs_2 w96_bar (.inputs(inputs0_2), .w(w7_1_2[0]), .wi(weighted_inputs7_0_1));
    weighted_inputs_2 w97 (.inputs(inputs1_2), .w(w7_0_2[1]), .wi(weighted_inputs7_1_0));
    weighted_inputs_2 w97_bar (.inputs(inputs1_2), .w(w7_1_2[1]), .wi(weighted_inputs7_1_1));
    weighted_inputs_2 w98 (.inputs(inputs2_2), .w(w7_0_2[2]), .wi(weighted_inputs7_2_0));
    weighted_inputs_2 w98_bar (.inputs(inputs2_2), .w(w7_1_2[2]), .wi(weighted_inputs7_2_1));
    weighted_inputs_2 w99 (.inputs(inputs3_2), .w(w7_0_2[3]), .wi(weighted_inputs7_3_0));
    weighted_inputs_2 w99_bar (.inputs(inputs3_2), .w(w7_1_2[3]), .wi(weighted_inputs7_3_1));
    weighted_inputs_2 w100 (.inputs(inputs4_2), .w(w7_0_2[4]), .wi(weighted_inputs7_4_0));
    weighted_inputs_2 w100_bar (.inputs(inputs4_2), .w(w7_1_2[4]), .wi(weighted_inputs7_4_1));
    weighted_inputs_2 w101 (.inputs(inputs5_2), .w(w7_0_2[5]), .wi(weighted_inputs7_5_0));
    weighted_inputs_2 w101_bar (.inputs(inputs5_2), .w(w7_1_2[5]), .wi(weighted_inputs7_5_1));
    weighted_inputs_2 w102 (.inputs(inputs6_2), .w(w7_0_2[6]), .wi(weighted_inputs7_6_0));
    weighted_inputs_2 w102_bar (.inputs(inputs6_2), .w(w7_1_2[6]), .wi(weighted_inputs7_6_1));
    weighted_inputs_2 w103 (.inputs(inputs7_2), .w(w7_0_2[7]), .wi(weighted_inputs7_7_0));
    weighted_inputs_2 w103_bar (.inputs(inputs7_2), .w(w7_1_2[7]), .wi(weighted_inputs7_7_1));
    weighted_inputs_2 w104 (.inputs(inputs8_2), .w(w7_0_2[8]), .wi(weighted_inputs7_8_0));
    weighted_inputs_2 w104_bar (.inputs(inputs8_2), .w(w7_1_2[8]), .wi(weighted_inputs7_8_1));
    weighted_inputs_2 w105 (.inputs(inputs9_2), .w(w7_0_2[9]), .wi(weighted_inputs7_9_0));
    weighted_inputs_2 w105_bar (.inputs(inputs9_2), .w(w7_1_2[9]), .wi(weighted_inputs7_9_1));
    weighted_inputs_2 w106 (.inputs(inputs10_2), .w(w7_0_2[10]), .wi(weighted_inputs7_10_0));
    weighted_inputs_2 w106_bar (.inputs(inputs10_2), .w(w7_1_2[10]), .wi(weighted_inputs7_10_1));
    weighted_inputs_2 w107 (.inputs(inputs11_2), .w(w7_0_2[11]), .wi(weighted_inputs7_11_0));
    weighted_inputs_2 w107_bar (.inputs(inputs11_2), .w(w7_1_2[11]), .wi(weighted_inputs7_11_1));
    weighted_inputs_2 w108 (.inputs(inputs12_2), .w(w7_0_2[12]), .wi(weighted_inputs7_12_0));
    weighted_inputs_2 w108_bar (.inputs(inputs12_2), .w(w7_1_2[12]), .wi(weighted_inputs7_12_1));
    weighted_inputs_2 w109 (.inputs(inputs13_2), .w(w7_0_2[13]), .wi(weighted_inputs7_13_0));
    weighted_inputs_2 w109_bar (.inputs(inputs13_2), .w(w7_1_2[13]), .wi(weighted_inputs7_13_1));
    weighted_inputs_2 w110 (.inputs(inputs14_2), .w(w7_0_2[14]), .wi(weighted_inputs7_14_0));
    weighted_inputs_2 w110_bar (.inputs(inputs14_2), .w(w7_1_2[14]), .wi(weighted_inputs7_14_1));
    weighted_inputs_2 w111 (.inputs(inputs15_2), .w(w7_0_2[15]), .wi(weighted_inputs7_15_0));
    weighted_inputs_2 w111_bar (.inputs(inputs15_2), .w(w7_1_2[15]), .wi(weighted_inputs7_15_1));
    weighted_inputs_2 w112 (.inputs(inputs0_2), .w(w8_0_2[0]), .wi(weighted_inputs8_0_0));
    weighted_inputs_2 w112_bar (.inputs(inputs0_2), .w(w8_1_2[0]), .wi(weighted_inputs8_0_1));
    weighted_inputs_2 w113 (.inputs(inputs1_2), .w(w8_0_2[1]), .wi(weighted_inputs8_1_0));
    weighted_inputs_2 w113_bar (.inputs(inputs1_2), .w(w8_1_2[1]), .wi(weighted_inputs8_1_1));
    weighted_inputs_2 w114 (.inputs(inputs2_2), .w(w8_0_2[2]), .wi(weighted_inputs8_2_0));
    weighted_inputs_2 w114_bar (.inputs(inputs2_2), .w(w8_1_2[2]), .wi(weighted_inputs8_2_1));
    weighted_inputs_2 w115 (.inputs(inputs3_2), .w(w8_0_2[3]), .wi(weighted_inputs8_3_0));
    weighted_inputs_2 w115_bar (.inputs(inputs3_2), .w(w8_1_2[3]), .wi(weighted_inputs8_3_1));
    weighted_inputs_2 w116 (.inputs(inputs4_2), .w(w8_0_2[4]), .wi(weighted_inputs8_4_0));
    weighted_inputs_2 w116_bar (.inputs(inputs4_2), .w(w8_1_2[4]), .wi(weighted_inputs8_4_1));
    weighted_inputs_2 w117 (.inputs(inputs5_2), .w(w8_0_2[5]), .wi(weighted_inputs8_5_0));
    weighted_inputs_2 w117_bar (.inputs(inputs5_2), .w(w8_1_2[5]), .wi(weighted_inputs8_5_1));
    weighted_inputs_2 w118 (.inputs(inputs6_2), .w(w8_0_2[6]), .wi(weighted_inputs8_6_0));
    weighted_inputs_2 w118_bar (.inputs(inputs6_2), .w(w8_1_2[6]), .wi(weighted_inputs8_6_1));
    weighted_inputs_2 w119 (.inputs(inputs7_2), .w(w8_0_2[7]), .wi(weighted_inputs8_7_0));
    weighted_inputs_2 w119_bar (.inputs(inputs7_2), .w(w8_1_2[7]), .wi(weighted_inputs8_7_1));
    weighted_inputs_2 w120 (.inputs(inputs8_2), .w(w8_0_2[8]), .wi(weighted_inputs8_8_0));
    weighted_inputs_2 w120_bar (.inputs(inputs8_2), .w(w8_1_2[8]), .wi(weighted_inputs8_8_1));
    weighted_inputs_2 w121 (.inputs(inputs9_2), .w(w8_0_2[9]), .wi(weighted_inputs8_9_0));
    weighted_inputs_2 w121_bar (.inputs(inputs9_2), .w(w8_1_2[9]), .wi(weighted_inputs8_9_1));
    weighted_inputs_2 w122 (.inputs(inputs10_2), .w(w8_0_2[10]), .wi(weighted_inputs8_10_0));
    weighted_inputs_2 w122_bar (.inputs(inputs10_2), .w(w8_1_2[10]), .wi(weighted_inputs8_10_1));
    weighted_inputs_2 w123 (.inputs(inputs11_2), .w(w8_0_2[11]), .wi(weighted_inputs8_11_0));
    weighted_inputs_2 w123_bar (.inputs(inputs11_2), .w(w8_1_2[11]), .wi(weighted_inputs8_11_1));
    weighted_inputs_2 w124 (.inputs(inputs12_2), .w(w8_0_2[12]), .wi(weighted_inputs8_12_0));
    weighted_inputs_2 w124_bar (.inputs(inputs12_2), .w(w8_1_2[12]), .wi(weighted_inputs8_12_1));
    weighted_inputs_2 w125 (.inputs(inputs13_2), .w(w8_0_2[13]), .wi(weighted_inputs8_13_0));
    weighted_inputs_2 w125_bar (.inputs(inputs13_2), .w(w8_1_2[13]), .wi(weighted_inputs8_13_1));
    weighted_inputs_2 w126 (.inputs(inputs14_2), .w(w8_0_2[14]), .wi(weighted_inputs8_14_0));
    weighted_inputs_2 w126_bar (.inputs(inputs14_2), .w(w8_1_2[14]), .wi(weighted_inputs8_14_1));
    weighted_inputs_2 w127 (.inputs(inputs15_2), .w(w8_0_2[15]), .wi(weighted_inputs8_15_0));
    weighted_inputs_2 w127_bar (.inputs(inputs15_2), .w(w8_1_2[15]), .wi(weighted_inputs8_15_1));
    adder_tree_2 add0(
    .clk(clk), 
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
    adder_tree_2 add8(
    .clk(clk), 
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
    adder_tree_bar_2 addb0(
    .clk(clk), 
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
    adder_tree_bar_2 addb8(
    .clk(clk), 
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
    adder_tree_2 add1(
    .clk(clk), 
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
    adder_tree_2 add9(
    .clk(clk), 
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
    adder_tree_bar_2 addb1(
    .clk(clk), 
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
    adder_tree_bar_2 addb9(
    .clk(clk), 
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
    adder_tree_2 add2(
    .clk(clk), 
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
    adder_tree_2 add10(
    .clk(clk), 
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
    adder_tree_bar_2 addb2(
    .clk(clk), 
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
    adder_tree_bar_2 addb10(
    .clk(clk), 
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
    adder_tree_2 add3(
    .clk(clk), 
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
    adder_tree_2 add11(
    .clk(clk), 
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
    adder_tree_bar_2 addb3(
    .clk(clk), 
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
    adder_tree_bar_2 addb11(
    .clk(clk), 
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
    adder_tree_2 add4(
    .clk(clk), 
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
    adder_tree_2 add12(
    .clk(clk), 
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
    adder_tree_bar_2 addb4(
    .clk(clk), 
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
    adder_tree_bar_2 addb12(
    .clk(clk), 
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
    adder_tree_2 add5(
    .clk(clk), 
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
    adder_tree_2 add13(
    .clk(clk), 
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
    adder_tree_bar_2 addb5(
    .clk(clk), 
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
    adder_tree_bar_2 addb13(
    .clk(clk), 
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
    adder_tree_2 add6(
    .clk(clk), 
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
    adder_tree_2 add14(
    .clk(clk), 
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
    adder_tree_bar_2 addb6(
    .clk(clk), 
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
    adder_tree_bar_2 addb14(
    .clk(clk), 
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
    adder_tree_2 add7(
    .clk(clk), 
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
    adder_tree_2 add15(
    .clk(clk), 
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
    adder_tree_bar_2 addb7(
    .clk(clk), 
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
    adder_tree_bar_2 addb15(
    .clk(clk), 
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
    add5bit_2 u0 (.a(sum1[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1[0]));
    add5bit_2 u8 (.a(sum2[0]), .b(b1_2), .cin(1'b0), .y(biased_sum2[0]));
    add5bitbar_2 ub0 (.a(sum1bar[0]), .b(b1_2), .cin(1'b0), .y(biased_sum1bar[0]));
    add5bitbar_2 ub8 (.a(sum2bar[0]), .b(b1_2), .cin(1'b0), .y(biased_sum2bar[0]));
    add5bit_2 u1 (.a(sum1[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1[1]));
    add5bit_2 u9 (.a(sum2[1]), .b(b2_2), .cin(1'b0), .y(biased_sum2[1]));
    add5bitbar_2 ub1 (.a(sum1bar[1]), .b(b2_2), .cin(1'b0), .y(biased_sum1bar[1]));
    add5bitbar_2 ub9 (.a(sum2bar[1]), .b(b2_2), .cin(1'b0), .y(biased_sum2bar[1]));
    add5bit_2 u2 (.a(sum1[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1[2]));
    add5bit_2 u10 (.a(sum2[2]), .b(b3_2), .cin(1'b0), .y(biased_sum2[2]));
    add5bitbar_2 ub2 (.a(sum1bar[2]), .b(b3_2), .cin(1'b0), .y(biased_sum1bar[2]));
    add5bitbar_2 ub10 (.a(sum2bar[2]), .b(b3_2), .cin(1'b0), .y(biased_sum2bar[2]));
    add5bit_2 u3 (.a(sum1[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1[3]));
    add5bit_2 u11 (.a(sum2[3]), .b(b4_2), .cin(1'b0), .y(biased_sum2[3]));
    add5bitbar_2 ub3 (.a(sum1bar[3]), .b(b4_2), .cin(1'b0), .y(biased_sum1bar[3]));
    add5bitbar_2 ub11 (.a(sum2bar[3]), .b(b4_2), .cin(1'b0), .y(biased_sum2bar[3]));
    add5bit_2 u4 (.a(sum1[4]), .b(b5_2), .cin(1'b0), .y(biased_sum1[4]));
    add5bit_2 u12 (.a(sum2[4]), .b(b5_2), .cin(1'b0), .y(biased_sum2[4]));
    add5bitbar_2 ub4 (.a(sum1bar[4]), .b(b5_2), .cin(1'b0), .y(biased_sum1bar[4]));
    add5bitbar_2 ub12 (.a(sum2bar[4]), .b(b5_2), .cin(1'b0), .y(biased_sum2bar[4]));
    add5bit_2 u5 (.a(sum1[5]), .b(b6_2), .cin(1'b0), .y(biased_sum1[5]));
    add5bit_2 u13 (.a(sum2[5]), .b(b6_2), .cin(1'b0), .y(biased_sum2[5]));
    add5bitbar_2 ub5 (.a(sum1bar[5]), .b(b6_2), .cin(1'b0), .y(biased_sum1bar[5]));
    add5bitbar_2 ub13 (.a(sum2bar[5]), .b(b6_2), .cin(1'b0), .y(biased_sum2bar[5]));
    add5bit_2 u6 (.a(sum1[6]), .b(b7_2), .cin(1'b0), .y(biased_sum1[6]));
    add5bit_2 u14 (.a(sum2[6]), .b(b7_2), .cin(1'b0), .y(biased_sum2[6]));
    add5bitbar_2 ub6 (.a(sum1bar[6]), .b(b7_2), .cin(1'b0), .y(biased_sum1bar[6]));
    add5bitbar_2 ub14 (.a(sum2bar[6]), .b(b7_2), .cin(1'b0), .y(biased_sum2bar[6]));
    add5bit_2 u7 (.a(sum1[7]), .b(b8_2), .cin(1'b0), .y(biased_sum1[7]));
    add5bit_2 u15 (.a(sum2[7]), .b(b8_2), .cin(1'b0), .y(biased_sum2[7]));
    add5bitbar_2 ub7 (.a(sum1bar[7]), .b(b8_2), .cin(1'b0), .y(biased_sum1bar[7]));
    add5bitbar_2 ub15 (.a(sum2bar[7]), .b(b8_2), .cin(1'b0), .y(biased_sum2bar[7]));
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
        $display("----- BNN LAYER 2 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_2, inputs1_2, inputs2_2, inputs3_2, inputs4_2, inputs5_2, inputs6_2, inputs7_2, inputs8_2, inputs9_2, inputs10_2, inputs11_2, inputs12_2, inputs13_2, inputs14_2, inputs15_2);
        $display("Weights0: %b %b %b %b %b %b %b %b", w1_0_2, w2_0_2, w3_0_2, w4_0_2, w5_0_2, w6_0_2, w7_0_2, w8_0_2);
        $display("Weights1: %b %b %b %b %b %b %b %b", w1_1_2, w2_1_2, w3_1_2, w4_1_2, w5_1_2, w6_1_2, w7_1_2, w8_1_2);
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


module activation_2 (

    input [5:0] inputs0_0,
    input [5:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0), .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0), .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0), .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0), .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0), .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0), .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));

    wire carry = r6 ^ masked_c5_0;
    wire activation = (carry ^ inputs0_0[5] ^ inputs0_1[5]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r6;
    assign mask = r6;

endmodule

module activation_array_2 (
    input  [5:0] inputs0_0, inputs0_1,
    input  [5:0] inputs1_0, inputs1_1,
    input  [5:0] inputs2_0, inputs2_1,
    input  [5:0] inputs3_0, inputs3_1,
    input  [5:0] inputs4_0, inputs4_1,
    input  [5:0] inputs5_0, inputs5_1,
    input  [5:0] inputs6_0, inputs6_1,
    input  [5:0] inputs7_0, inputs7_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3,
    input  r0_4, r1_4, r2_4, r3_4, r4_4, r5_4,
    input  r0_5, r1_5, r2_5, r3_5, r4_5, r5_5,
    input  r0_6, r1_6, r2_6, r3_6, r4_6, r5_6,
    input  r0_7, r1_7, r2_7, r3_7, r4_7, r5_7,
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

    activation_2 a0 (
        .inputs0_0(inputs0_0), .inputs0_1(inputs0_1),
        .r0_0(r0_0),
        .r1_0(r1_0),
        .r2_0(r2_0),
        .r3_0(r3_0),
        .r4_0(r4_0),
        .r5_0(r5_0),
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
        .masked_activation(masked_activation3),
        .mask(mask3)
    );

    activation_2 a4 (
        .inputs0_0(inputs4_0), .inputs0_1(inputs4_1),
        .r0_0(r0_4),
        .r1_0(r1_4),
        .r2_0(r2_4),
        .r3_0(r3_4),
        .r4_0(r4_4),
        .r5_0(r5_4),
        .masked_activation(masked_activation4),
        .mask(mask4)
    );

    activation_2 a5 (
        .inputs0_0(inputs5_0), .inputs0_1(inputs5_1),
        .r0_0(r0_5),
        .r1_0(r1_5),
        .r2_0(r2_5),
        .r3_0(r3_5),
        .r4_0(r4_5),
        .r5_0(r5_5),
        .masked_activation(masked_activation5),
        .mask(mask5)
    );

    activation_2 a6 (
        .inputs0_0(inputs6_0), .inputs0_1(inputs6_1),
        .r0_0(r0_6),
        .r1_0(r1_6),
        .r2_0(r2_6),
        .r3_0(r3_6),
        .r4_0(r4_6),
        .r5_0(r5_6),
        .masked_activation(masked_activation6),
        .mask(mask6)
    );

    activation_2 a7 (
        .inputs0_0(inputs7_0), .inputs0_1(inputs7_1),
        .r0_0(r0_7),
        .r1_0(r1_7),
        .r2_0(r2_7),
        .r3_0(r3_7),
        .r4_0(r4_7),
        .r5_0(r5_7),
        .masked_activation(masked_activation7),
        .mask(mask7)
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
  input  wire [15:0] w1_0_2, w1_1_2,
  input  wire [15:0] w2_0_2, w2_1_2,
  input  wire [15:0] w3_0_2, w3_1_2,
  input  wire [15:0] w4_0_2, w4_1_2,
  input  wire [15:0] w5_0_2, w5_1_2,
  input  wire [15:0] w6_0_2, w6_1_2,
  input  wire [15:0] w7_0_2, w7_1_2,
  input  wire [15:0] w8_0_2, w8_1_2,
  input  wire [4:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2,
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
  input  wire r0_3,
  input  wire r1_3,
  input  wire r2_3,
  input  wire r3_3,
  input  wire r4_3,
  input  wire r5_3,
  input  wire r0_4,
  input  wire r1_4,
  input  wire r2_4,
  input  wire r3_4,
  input  wire r4_4,
  input  wire r5_4,
  input  wire r0_5,
  input  wire r1_5,
  input  wire r2_5,
  input  wire r3_5,
  input  wire r4_5,
  input  wire r5_5,
  input  wire r0_6,
  input  wire r1_6,
  input  wire r2_6,
  input  wire r3_6,
  input  wire r4_6,
  input  wire r5_6,
  input  wire r0_7,
  input  wire r1_7,
  input  wire r2_7,
  input  wire r3_7,
  input  wire r4_7,
  input  wire r5_7,
  output wire masked_activation0_2, masked_activation0bar_2,
  output wire mask0_2, mask0bar_2,
  output wire masked_activation1_2, masked_activation1bar_2,
  output wire mask1_2, mask1bar_2,
  output wire masked_activation2_2, masked_activation2bar_2,
  output wire mask2_2, mask2bar_2,
  output wire masked_activation3_2, masked_activation3bar_2,
  output wire mask3_2, mask3bar_2,
  output wire masked_activation4_2, masked_activation4bar_2,
  output wire mask4_2, mask4bar_2,
  output wire masked_activation5_2, masked_activation5bar_2,
  output wire mask5_2, mask5bar_2,
  output wire masked_activation6_2, masked_activation6bar_2,
  output wire mask6_2, mask6bar_2,
  output wire masked_activation7_2, masked_activation7bar_2,
  output wire mask7_2, mask7bar_2
);

  wire [5:0] biased_sum0_0, biased_sum0_0bar;
  wire [5:0] biased_sum0_1, biased_sum0_1bar;
  wire [5:0] biased_sum1_0, biased_sum1_0bar;
  wire [5:0] biased_sum1_1, biased_sum1_1bar;
  wire [5:0] biased_sum2_0, biased_sum2_0bar;
  wire [5:0] biased_sum2_1, biased_sum2_1bar;
  wire [5:0] biased_sum3_0, biased_sum3_0bar;
  wire [5:0] biased_sum3_1, biased_sum3_1bar;
  wire [5:0] biased_sum4_0, biased_sum4_0bar;
  wire [5:0] biased_sum4_1, biased_sum4_1bar;
  wire [5:0] biased_sum5_0, biased_sum5_0bar;
  wire [5:0] biased_sum5_1, biased_sum5_1bar;
  wire [5:0] biased_sum6_0, biased_sum6_0bar;
  wire [5:0] biased_sum6_1, biased_sum6_1bar;
  wire [5:0] biased_sum7_0, biased_sum7_0bar;
  wire [5:0] biased_sum7_1, biased_sum7_1bar;

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
    .w1_0_2(w1_0_2), .w1_1_2(w1_1_2),
    .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
    .w3_0_2(w3_0_2), .w3_1_2(w3_1_2),
    .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
    .w5_0_2(w5_0_2), .w5_1_2(w5_1_2),
    .w6_0_2(w6_0_2), .w6_1_2(w6_1_2),
    .w7_0_2(w7_0_2), .w7_1_2(w7_1_2),
    .w8_0_2(w8_0_2), .w8_1_2(w8_1_2),
    .b1_2(b1_2),
    .b2_2(b2_2),
    .b3_2(b3_2),
    .b4_2(b4_2),
    .b5_2(b5_2),
    .b6_2(b6_2),
    .b7_2(b7_2),
    .b8_2(b8_2),
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

    activation_array_2 act1 (
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
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r0_7(r0_7),
    .r1_7(r1_7),
    .r2_7(r2_7),
    .r3_7(r3_7),
    .r4_7(r4_7),
    .r5_7(r5_7),
    .masked_activation0(masked_activation0_2),
    .masked_activation1(masked_activation1_2),
    .masked_activation2(masked_activation2_2),
    .masked_activation3(masked_activation3_2),
    .masked_activation4(masked_activation4_2),
    .masked_activation5(masked_activation5_2),
    .masked_activation6(masked_activation6_2),
    .masked_activation7(masked_activation7_2),
    .mask0(mask0_2),
    .mask1(mask1_2),
    .mask2(mask2_2),
    .mask3(mask3_2),
    .mask4(mask4_2),
    .mask5(mask5_2),
    .mask6(mask6_2),
    .mask7(mask7_2)
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
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r0_7(r0_7),
    .r1_7(r1_7),
    .r2_7(r2_7),
    .r3_7(r3_7),
    .r4_7(r4_7),
    .r5_7(r5_7),
    .masked_activation0(masked_activation0bar_2),
    .masked_activation1(masked_activation1bar_2),
    .masked_activation2(masked_activation2bar_2),
    .masked_activation3(masked_activation3bar_2),
    .masked_activation4(masked_activation4bar_2),
    .masked_activation5(masked_activation5bar_2),
    .masked_activation6(masked_activation6bar_2),
    .masked_activation7(masked_activation7bar_2),
    .mask0(mask0bar_2),
    .mask1(mask1bar_2),
    .mask2(mask2bar_2),
    .mask3(mask3bar_2),
    .mask4(mask4bar_2),
    .mask5(mask5bar_2),
    .mask6(mask6bar_2),
    .mask7(mask7bar_2)
  );

    always @(posedge clk) begin
    $display("----- LAYER 2   boolean activations -----");
    $display("masked_activation : %b %b %b %b %b %b %b %b", masked_activation0_2, masked_activation1_2, masked_activation2_2, masked_activation3_2, masked_activation4_2, masked_activation5_2, masked_activation6_2, masked_activation7_2);
    $display("masked_activationbar : %b %b %b %b %b %b %b %b", masked_activation0bar_2, masked_activation1bar_2, masked_activation2bar_2, masked_activation3bar_2, masked_activation4bar_2, masked_activation5bar_2, masked_activation6bar_2, masked_activation7bar_2);
    $display("mask : %b %b %b %b %b %b %b %b", mask0_2, mask1_2, mask2_2, mask3_2, mask4_2, mask5_2, mask6_2, mask7_2);
    $display("maskbar : %b %b %b %b %b %b %b %b", mask0bar_2, mask1bar_2, mask2bar_2, mask3bar_2, mask4bar_2, mask5bar_2, mask6bar_2, mask7bar_2);
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

module add1bitbar_3(
    input wire [0:0] a,
    input wire [0:0] b,
    input wire  cin,
    output wire [1:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;

full_adderbar_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));

WddlNANDbar_3 wn1(.A(~a[0]), .B(b[0]), .C(~c1), .S(s1), .S1(s1_1));
WddlNANDbar_3 wn2(.A(a[0]), .B(~b[0]), .C(~c1), .S(s2), .S1(s2_1));
WddlNANDbar_3 wn3(.A(a[0]), .B(b[0]), .C(c1), .S(s3), .S1(s3_1));
WddlNANDbar_3 wn4(.A(~a[0]), .B(~b[0]), .C(c1), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[1] = cout_bar;

endmodule

module add2bitbar_3(
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

full_adderbar_3 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_3 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));

WddlNANDbar_3 wn1(.A(~a[1]), .B(b[1]), .C(~c2), .S(s1), .S1(s1_1));
WddlNANDbar_3 wn2(.A(a[1]), .B(~b[1]), .C(~c2), .S(s2), .S1(s2_1));
WddlNANDbar_3 wn3(.A(a[1]), .B(b[1]), .C(c2), .S(s3), .S1(s3_1));
WddlNANDbar_3 wn4(.A(~a[1]), .B(~b[1]), .C(c2), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[2] = cout_bar;

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


module adder_tree_bar_3 (
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

    wire [1:0] stage0_0_lo_bar_3;
    wire [1:0] stage0_1_lo_bar_3;
    wire [1:0] stage0_2_lo_bar_3;
    wire [1:0] stage0_3_lo_bar_3;
    wire [1:0] stage0_4_lo_bar_3;
    wire [1:0] stage0_5_lo_bar_3;
    wire [1:0] stage0_6_lo_bar_3;
    wire [1:0] stage0_7_lo_bar_3;
    wire [2:0] stage1_0_lo_bar_3;
    wire [2:0] stage1_1_lo_bar_3;
    wire [2:0] stage1_2_lo_bar_3;
    wire [2:0] stage1_3_lo_bar_3;
    wire [3:0] stage2_0_lo_bar_3;
    wire [3:0] stage2_1_lo_bar_3;
    wire [4:0] stage3_0_lo_bar_3;
    reg  [1:0] stage0_0_bar_3;
    reg  [1:0] stage0_1_bar_3;
    reg  [1:0] stage0_2_bar_3;
    reg  [1:0] stage0_3_bar_3;
    reg  [1:0] stage0_4_bar_3;
    reg  [1:0] stage0_5_bar_3;
    reg  [1:0] stage0_6_bar_3;
    reg  [1:0] stage0_7_bar_3;
    reg  [2:0] stage1_0_bar_3;
    reg  [2:0] stage1_1_bar_3;
    reg  [2:0] stage1_2_bar_3;
    reg  [2:0] stage1_3_bar_3;
    reg  [3:0] stage2_0_bar_3;
    reg  [3:0] stage2_1_bar_3;
    reg  [4:0] stage3_0_bar_3;

    add1bitbar_3 u0_0_bar (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_bar_3), .cout(), .cout_bar());
    add1bitbar_3 u0_1_bar (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_bar_3), .cout(), .cout_bar());
    add1bitbar_3 u0_2_bar (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_bar_3), .cout(), .cout_bar());
    add1bitbar_3 u0_3_bar (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_bar_3), .cout(), .cout_bar());
    add1bitbar_3 u0_4_bar (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_bar_3), .cout(), .cout_bar());
    add1bitbar_3 u0_5_bar (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_bar_3), .cout(), .cout_bar());
    add1bitbar_3 u0_6_bar (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_bar_3), .cout(), .cout_bar());
    add1bitbar_3 u0_7_bar (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_bar_3), .cout(), .cout_bar());
    add2bitbar_3 u1_0_bar (.a(stage0_0_bar_3), .b(stage0_1_bar_3), .cin(1'b0), .y(stage1_0_lo_bar_3), .cout(), .cout_bar());
    add2bitbar_3 u1_1_bar (.a(stage0_2_bar_3), .b(stage0_3_bar_3), .cin(1'b0), .y(stage1_1_lo_bar_3), .cout(), .cout_bar());
    add2bitbar_3 u1_2_bar (.a(stage0_4_bar_3), .b(stage0_5_bar_3), .cin(1'b0), .y(stage1_2_lo_bar_3), .cout(), .cout_bar());
    add2bitbar_3 u1_3_bar (.a(stage0_6_bar_3), .b(stage0_7_bar_3), .cin(1'b0), .y(stage1_3_lo_bar_3), .cout(), .cout_bar());
    add3bitbar_3 u2_0_bar (.a(stage1_0_bar_3), .b(stage1_1_bar_3), .cin(1'b0), .y(stage2_0_lo_bar_3), .cout(), .cout_bar());
    add3bitbar_3 u2_1_bar (.a(stage1_2_bar_3), .b(stage1_3_bar_3), .cin(1'b0), .y(stage2_1_lo_bar_3), .cout(), .cout_bar());
    add4bitbar_3 u3_0_bar (.a(stage2_0_bar_3), .b(stage2_1_bar_3), .cin(1'b0), .y(stage3_0_lo_bar_3), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_bar_3;

    always @(posedge clk) begin
        stage0_0_bar_3 <=  stage0_0_lo_bar_3;
        stage0_1_bar_3 <=  stage0_1_lo_bar_3;
        stage0_2_bar_3 <=  stage0_2_lo_bar_3;
        stage0_3_bar_3 <=  stage0_3_lo_bar_3;
        stage0_4_bar_3 <=  stage0_4_lo_bar_3;
        stage0_5_bar_3 <=  stage0_5_lo_bar_3;
        stage0_6_bar_3 <=  stage0_6_lo_bar_3;
        stage0_7_bar_3 <=  stage0_7_lo_bar_3;
        stage1_0_bar_3 <=  stage1_0_lo_bar_3;
        stage1_1_bar_3 <=  stage1_1_lo_bar_3;
        stage1_2_bar_3 <=  stage1_2_lo_bar_3;
        stage1_3_bar_3 <=  stage1_3_lo_bar_3;
        stage2_0_bar_3 <=  stage2_0_lo_bar_3;
        stage2_1_bar_3 <=  stage2_1_lo_bar_3;
        stage3_0_bar_3 <=  stage3_0_lo_bar_3;
    end
endmodule


module layer3(
    input clk,
    input [0:0] inputs0_3 , inputs1_3 , inputs2_3 , inputs3_3 , inputs4_3 , inputs5_3 , inputs6_3 , inputs7_3 , inputs8_3 , inputs9_3 , inputs10_3 , inputs11_3 , inputs12_3 , inputs13_3 , inputs14_3 , inputs15_3,
    input [15:0] w1_0_3, w1_1_3, w2_0_3, w2_1_3, w3_0_3, w3_1_3, w4_0_3, w4_1_3, w5_0_3, w5_1_3, w6_0_3, w6_1_3, w7_0_3, w7_1_3, w8_0_3, w8_1_3,
    input [4:0] b1_3, b2_3, b3_3, b4_3, b5_3, b6_3, b7_3, b8_3,
    output [5:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar, biased_sum4_0, biased_sum4_1, biased_sum4_0bar, biased_sum4_1bar, biased_sum5_0, biased_sum5_1, biased_sum5_0bar, biased_sum5_1bar, biased_sum6_0, biased_sum6_1, biased_sum6_0bar, biased_sum6_1bar, biased_sum7_0, biased_sum7_1, biased_sum7_0bar, biased_sum7_1bar
);
    wire [0:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [0:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [0:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [0:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [0:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [0:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [0:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [0:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [0:0] weighted_inputs1_8_0, weighted_inputs1_8_1;
    wire [0:0] weighted_inputs1_9_0, weighted_inputs1_9_1;
    wire [0:0] weighted_inputs1_10_0, weighted_inputs1_10_1;
    wire [0:0] weighted_inputs1_11_0, weighted_inputs1_11_1;
    wire [0:0] weighted_inputs1_12_0, weighted_inputs1_12_1;
    wire [0:0] weighted_inputs1_13_0, weighted_inputs1_13_1;
    wire [0:0] weighted_inputs1_14_0, weighted_inputs1_14_1;
    wire [0:0] weighted_inputs1_15_0, weighted_inputs1_15_1;
    wire [0:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [0:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [0:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [0:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [0:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [0:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [0:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [0:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [0:0] weighted_inputs2_8_0, weighted_inputs2_8_1;
    wire [0:0] weighted_inputs2_9_0, weighted_inputs2_9_1;
    wire [0:0] weighted_inputs2_10_0, weighted_inputs2_10_1;
    wire [0:0] weighted_inputs2_11_0, weighted_inputs2_11_1;
    wire [0:0] weighted_inputs2_12_0, weighted_inputs2_12_1;
    wire [0:0] weighted_inputs2_13_0, weighted_inputs2_13_1;
    wire [0:0] weighted_inputs2_14_0, weighted_inputs2_14_1;
    wire [0:0] weighted_inputs2_15_0, weighted_inputs2_15_1;
    wire [0:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [0:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [0:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [0:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [0:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [0:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [0:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [0:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [0:0] weighted_inputs3_8_0, weighted_inputs3_8_1;
    wire [0:0] weighted_inputs3_9_0, weighted_inputs3_9_1;
    wire [0:0] weighted_inputs3_10_0, weighted_inputs3_10_1;
    wire [0:0] weighted_inputs3_11_0, weighted_inputs3_11_1;
    wire [0:0] weighted_inputs3_12_0, weighted_inputs3_12_1;
    wire [0:0] weighted_inputs3_13_0, weighted_inputs3_13_1;
    wire [0:0] weighted_inputs3_14_0, weighted_inputs3_14_1;
    wire [0:0] weighted_inputs3_15_0, weighted_inputs3_15_1;
    wire [0:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [0:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [0:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [0:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [0:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [0:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [0:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [0:0] weighted_inputs4_7_0, weighted_inputs4_7_1;
    wire [0:0] weighted_inputs4_8_0, weighted_inputs4_8_1;
    wire [0:0] weighted_inputs4_9_0, weighted_inputs4_9_1;
    wire [0:0] weighted_inputs4_10_0, weighted_inputs4_10_1;
    wire [0:0] weighted_inputs4_11_0, weighted_inputs4_11_1;
    wire [0:0] weighted_inputs4_12_0, weighted_inputs4_12_1;
    wire [0:0] weighted_inputs4_13_0, weighted_inputs4_13_1;
    wire [0:0] weighted_inputs4_14_0, weighted_inputs4_14_1;
    wire [0:0] weighted_inputs4_15_0, weighted_inputs4_15_1;
    wire [0:0] weighted_inputs5_0_0, weighted_inputs5_0_1;
    wire [0:0] weighted_inputs5_1_0, weighted_inputs5_1_1;
    wire [0:0] weighted_inputs5_2_0, weighted_inputs5_2_1;
    wire [0:0] weighted_inputs5_3_0, weighted_inputs5_3_1;
    wire [0:0] weighted_inputs5_4_0, weighted_inputs5_4_1;
    wire [0:0] weighted_inputs5_5_0, weighted_inputs5_5_1;
    wire [0:0] weighted_inputs5_6_0, weighted_inputs5_6_1;
    wire [0:0] weighted_inputs5_7_0, weighted_inputs5_7_1;
    wire [0:0] weighted_inputs5_8_0, weighted_inputs5_8_1;
    wire [0:0] weighted_inputs5_9_0, weighted_inputs5_9_1;
    wire [0:0] weighted_inputs5_10_0, weighted_inputs5_10_1;
    wire [0:0] weighted_inputs5_11_0, weighted_inputs5_11_1;
    wire [0:0] weighted_inputs5_12_0, weighted_inputs5_12_1;
    wire [0:0] weighted_inputs5_13_0, weighted_inputs5_13_1;
    wire [0:0] weighted_inputs5_14_0, weighted_inputs5_14_1;
    wire [0:0] weighted_inputs5_15_0, weighted_inputs5_15_1;
    wire [0:0] weighted_inputs6_0_0, weighted_inputs6_0_1;
    wire [0:0] weighted_inputs6_1_0, weighted_inputs6_1_1;
    wire [0:0] weighted_inputs6_2_0, weighted_inputs6_2_1;
    wire [0:0] weighted_inputs6_3_0, weighted_inputs6_3_1;
    wire [0:0] weighted_inputs6_4_0, weighted_inputs6_4_1;
    wire [0:0] weighted_inputs6_5_0, weighted_inputs6_5_1;
    wire [0:0] weighted_inputs6_6_0, weighted_inputs6_6_1;
    wire [0:0] weighted_inputs6_7_0, weighted_inputs6_7_1;
    wire [0:0] weighted_inputs6_8_0, weighted_inputs6_8_1;
    wire [0:0] weighted_inputs6_9_0, weighted_inputs6_9_1;
    wire [0:0] weighted_inputs6_10_0, weighted_inputs6_10_1;
    wire [0:0] weighted_inputs6_11_0, weighted_inputs6_11_1;
    wire [0:0] weighted_inputs6_12_0, weighted_inputs6_12_1;
    wire [0:0] weighted_inputs6_13_0, weighted_inputs6_13_1;
    wire [0:0] weighted_inputs6_14_0, weighted_inputs6_14_1;
    wire [0:0] weighted_inputs6_15_0, weighted_inputs6_15_1;
    wire [0:0] weighted_inputs7_0_0, weighted_inputs7_0_1;
    wire [0:0] weighted_inputs7_1_0, weighted_inputs7_1_1;
    wire [0:0] weighted_inputs7_2_0, weighted_inputs7_2_1;
    wire [0:0] weighted_inputs7_3_0, weighted_inputs7_3_1;
    wire [0:0] weighted_inputs7_4_0, weighted_inputs7_4_1;
    wire [0:0] weighted_inputs7_5_0, weighted_inputs7_5_1;
    wire [0:0] weighted_inputs7_6_0, weighted_inputs7_6_1;
    wire [0:0] weighted_inputs7_7_0, weighted_inputs7_7_1;
    wire [0:0] weighted_inputs7_8_0, weighted_inputs7_8_1;
    wire [0:0] weighted_inputs7_9_0, weighted_inputs7_9_1;
    wire [0:0] weighted_inputs7_10_0, weighted_inputs7_10_1;
    wire [0:0] weighted_inputs7_11_0, weighted_inputs7_11_1;
    wire [0:0] weighted_inputs7_12_0, weighted_inputs7_12_1;
    wire [0:0] weighted_inputs7_13_0, weighted_inputs7_13_1;
    wire [0:0] weighted_inputs7_14_0, weighted_inputs7_14_1;
    wire [0:0] weighted_inputs7_15_0, weighted_inputs7_15_1;
    wire [0:0] weighted_inputs8_0_0, weighted_inputs8_0_1;
    wire [0:0] weighted_inputs8_1_0, weighted_inputs8_1_1;
    wire [0:0] weighted_inputs8_2_0, weighted_inputs8_2_1;
    wire [0:0] weighted_inputs8_3_0, weighted_inputs8_3_1;
    wire [0:0] weighted_inputs8_4_0, weighted_inputs8_4_1;
    wire [0:0] weighted_inputs8_5_0, weighted_inputs8_5_1;
    wire [0:0] weighted_inputs8_6_0, weighted_inputs8_6_1;
    wire [0:0] weighted_inputs8_7_0, weighted_inputs8_7_1;
    wire [0:0] weighted_inputs8_8_0, weighted_inputs8_8_1;
    wire [0:0] weighted_inputs8_9_0, weighted_inputs8_9_1;
    wire [0:0] weighted_inputs8_10_0, weighted_inputs8_10_1;
    wire [0:0] weighted_inputs8_11_0, weighted_inputs8_11_1;
    wire [0:0] weighted_inputs8_12_0, weighted_inputs8_12_1;
    wire [0:0] weighted_inputs8_13_0, weighted_inputs8_13_1;
    wire [0:0] weighted_inputs8_14_0, weighted_inputs8_14_1;
    wire [0:0] weighted_inputs8_15_0, weighted_inputs8_15_1;

    wire [4:0] sum1 [7:0];
    wire [4:0] sum2 [7:0];
    wire [5:0] biased_sum1 [7:0];
    wire [5:0] biased_sum2 [7:0];
    wire [4:0] sum1bar [7:0];
    wire [4:0] sum2bar [7:0];
    wire [5:0] biased_sum1bar [7:0];
    wire [5:0] biased_sum2bar [7:0];
    weighted_inputs_2 w0 (.inputs(inputs0_3), .w(w1_0_3[0]), .wi(weighted_inputs1_0_0));
    weighted_inputs_2 w0_bar (.inputs(inputs0_3), .w(w1_1_3[0]), .wi(weighted_inputs1_0_1));
    weighted_inputs_2 w1 (.inputs(inputs1_3), .w(w1_0_3[1]), .wi(weighted_inputs1_1_0));
    weighted_inputs_2 w1_bar (.inputs(inputs1_3), .w(w1_1_3[1]), .wi(weighted_inputs1_1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_3), .w(w1_0_3[2]), .wi(weighted_inputs1_2_0));
    weighted_inputs_2 w2_bar (.inputs(inputs2_3), .w(w1_1_3[2]), .wi(weighted_inputs1_2_1));
    weighted_inputs_2 w3 (.inputs(inputs3_3), .w(w1_0_3[3]), .wi(weighted_inputs1_3_0));
    weighted_inputs_2 w3_bar (.inputs(inputs3_3), .w(w1_1_3[3]), .wi(weighted_inputs1_3_1));
    weighted_inputs_2 w4 (.inputs(inputs4_3), .w(w1_0_3[4]), .wi(weighted_inputs1_4_0));
    weighted_inputs_2 w4_bar (.inputs(inputs4_3), .w(w1_1_3[4]), .wi(weighted_inputs1_4_1));
    weighted_inputs_2 w5 (.inputs(inputs5_3), .w(w1_0_3[5]), .wi(weighted_inputs1_5_0));
    weighted_inputs_2 w5_bar (.inputs(inputs5_3), .w(w1_1_3[5]), .wi(weighted_inputs1_5_1));
    weighted_inputs_2 w6 (.inputs(inputs6_3), .w(w1_0_3[6]), .wi(weighted_inputs1_6_0));
    weighted_inputs_2 w6_bar (.inputs(inputs6_3), .w(w1_1_3[6]), .wi(weighted_inputs1_6_1));
    weighted_inputs_2 w7 (.inputs(inputs7_3), .w(w1_0_3[7]), .wi(weighted_inputs1_7_0));
    weighted_inputs_2 w7_bar (.inputs(inputs7_3), .w(w1_1_3[7]), .wi(weighted_inputs1_7_1));
    weighted_inputs_2 w8 (.inputs(inputs8_3), .w(w1_0_3[8]), .wi(weighted_inputs1_8_0));
    weighted_inputs_2 w8_bar (.inputs(inputs8_3), .w(w1_1_3[8]), .wi(weighted_inputs1_8_1));
    weighted_inputs_2 w9 (.inputs(inputs9_3), .w(w1_0_3[9]), .wi(weighted_inputs1_9_0));
    weighted_inputs_2 w9_bar (.inputs(inputs9_3), .w(w1_1_3[9]), .wi(weighted_inputs1_9_1));
    weighted_inputs_2 w10 (.inputs(inputs10_3), .w(w1_0_3[10]), .wi(weighted_inputs1_10_0));
    weighted_inputs_2 w10_bar (.inputs(inputs10_3), .w(w1_1_3[10]), .wi(weighted_inputs1_10_1));
    weighted_inputs_2 w11 (.inputs(inputs11_3), .w(w1_0_3[11]), .wi(weighted_inputs1_11_0));
    weighted_inputs_2 w11_bar (.inputs(inputs11_3), .w(w1_1_3[11]), .wi(weighted_inputs1_11_1));
    weighted_inputs_2 w12 (.inputs(inputs12_3), .w(w1_0_3[12]), .wi(weighted_inputs1_12_0));
    weighted_inputs_2 w12_bar (.inputs(inputs12_3), .w(w1_1_3[12]), .wi(weighted_inputs1_12_1));
    weighted_inputs_2 w13 (.inputs(inputs13_3), .w(w1_0_3[13]), .wi(weighted_inputs1_13_0));
    weighted_inputs_2 w13_bar (.inputs(inputs13_3), .w(w1_1_3[13]), .wi(weighted_inputs1_13_1));
    weighted_inputs_2 w14 (.inputs(inputs14_3), .w(w1_0_3[14]), .wi(weighted_inputs1_14_0));
    weighted_inputs_2 w14_bar (.inputs(inputs14_3), .w(w1_1_3[14]), .wi(weighted_inputs1_14_1));
    weighted_inputs_2 w15 (.inputs(inputs15_3), .w(w1_0_3[15]), .wi(weighted_inputs1_15_0));
    weighted_inputs_2 w15_bar (.inputs(inputs15_3), .w(w1_1_3[15]), .wi(weighted_inputs1_15_1));
    weighted_inputs_2 w16 (.inputs(inputs0_3), .w(w2_0_3[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_2 w16_bar (.inputs(inputs0_3), .w(w2_1_3[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_2 w17 (.inputs(inputs1_3), .w(w2_0_3[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_2 w17_bar (.inputs(inputs1_3), .w(w2_1_3[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_2 w18 (.inputs(inputs2_3), .w(w2_0_3[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_2 w18_bar (.inputs(inputs2_3), .w(w2_1_3[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_2 w19 (.inputs(inputs3_3), .w(w2_0_3[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_2 w19_bar (.inputs(inputs3_3), .w(w2_1_3[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_2 w20 (.inputs(inputs4_3), .w(w2_0_3[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_2 w20_bar (.inputs(inputs4_3), .w(w2_1_3[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_2 w21 (.inputs(inputs5_3), .w(w2_0_3[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_2 w21_bar (.inputs(inputs5_3), .w(w2_1_3[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_2 w22 (.inputs(inputs6_3), .w(w2_0_3[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_2 w22_bar (.inputs(inputs6_3), .w(w2_1_3[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_2 w23 (.inputs(inputs7_3), .w(w2_0_3[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_2 w23_bar (.inputs(inputs7_3), .w(w2_1_3[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_2 w24 (.inputs(inputs8_3), .w(w2_0_3[8]), .wi(weighted_inputs2_8_0));
    weighted_inputs_2 w24_bar (.inputs(inputs8_3), .w(w2_1_3[8]), .wi(weighted_inputs2_8_1));
    weighted_inputs_2 w25 (.inputs(inputs9_3), .w(w2_0_3[9]), .wi(weighted_inputs2_9_0));
    weighted_inputs_2 w25_bar (.inputs(inputs9_3), .w(w2_1_3[9]), .wi(weighted_inputs2_9_1));
    weighted_inputs_2 w26 (.inputs(inputs10_3), .w(w2_0_3[10]), .wi(weighted_inputs2_10_0));
    weighted_inputs_2 w26_bar (.inputs(inputs10_3), .w(w2_1_3[10]), .wi(weighted_inputs2_10_1));
    weighted_inputs_2 w27 (.inputs(inputs11_3), .w(w2_0_3[11]), .wi(weighted_inputs2_11_0));
    weighted_inputs_2 w27_bar (.inputs(inputs11_3), .w(w2_1_3[11]), .wi(weighted_inputs2_11_1));
    weighted_inputs_2 w28 (.inputs(inputs12_3), .w(w2_0_3[12]), .wi(weighted_inputs2_12_0));
    weighted_inputs_2 w28_bar (.inputs(inputs12_3), .w(w2_1_3[12]), .wi(weighted_inputs2_12_1));
    weighted_inputs_2 w29 (.inputs(inputs13_3), .w(w2_0_3[13]), .wi(weighted_inputs2_13_0));
    weighted_inputs_2 w29_bar (.inputs(inputs13_3), .w(w2_1_3[13]), .wi(weighted_inputs2_13_1));
    weighted_inputs_2 w30 (.inputs(inputs14_3), .w(w2_0_3[14]), .wi(weighted_inputs2_14_0));
    weighted_inputs_2 w30_bar (.inputs(inputs14_3), .w(w2_1_3[14]), .wi(weighted_inputs2_14_1));
    weighted_inputs_2 w31 (.inputs(inputs15_3), .w(w2_0_3[15]), .wi(weighted_inputs2_15_0));
    weighted_inputs_2 w31_bar (.inputs(inputs15_3), .w(w2_1_3[15]), .wi(weighted_inputs2_15_1));
    weighted_inputs_2 w32 (.inputs(inputs0_3), .w(w3_0_3[0]), .wi(weighted_inputs3_0_0));
    weighted_inputs_2 w32_bar (.inputs(inputs0_3), .w(w3_1_3[0]), .wi(weighted_inputs3_0_1));
    weighted_inputs_2 w33 (.inputs(inputs1_3), .w(w3_0_3[1]), .wi(weighted_inputs3_1_0));
    weighted_inputs_2 w33_bar (.inputs(inputs1_3), .w(w3_1_3[1]), .wi(weighted_inputs3_1_1));
    weighted_inputs_2 w34 (.inputs(inputs2_3), .w(w3_0_3[2]), .wi(weighted_inputs3_2_0));
    weighted_inputs_2 w34_bar (.inputs(inputs2_3), .w(w3_1_3[2]), .wi(weighted_inputs3_2_1));
    weighted_inputs_2 w35 (.inputs(inputs3_3), .w(w3_0_3[3]), .wi(weighted_inputs3_3_0));
    weighted_inputs_2 w35_bar (.inputs(inputs3_3), .w(w3_1_3[3]), .wi(weighted_inputs3_3_1));
    weighted_inputs_2 w36 (.inputs(inputs4_3), .w(w3_0_3[4]), .wi(weighted_inputs3_4_0));
    weighted_inputs_2 w36_bar (.inputs(inputs4_3), .w(w3_1_3[4]), .wi(weighted_inputs3_4_1));
    weighted_inputs_2 w37 (.inputs(inputs5_3), .w(w3_0_3[5]), .wi(weighted_inputs3_5_0));
    weighted_inputs_2 w37_bar (.inputs(inputs5_3), .w(w3_1_3[5]), .wi(weighted_inputs3_5_1));
    weighted_inputs_2 w38 (.inputs(inputs6_3), .w(w3_0_3[6]), .wi(weighted_inputs3_6_0));
    weighted_inputs_2 w38_bar (.inputs(inputs6_3), .w(w3_1_3[6]), .wi(weighted_inputs3_6_1));
    weighted_inputs_2 w39 (.inputs(inputs7_3), .w(w3_0_3[7]), .wi(weighted_inputs3_7_0));
    weighted_inputs_2 w39_bar (.inputs(inputs7_3), .w(w3_1_3[7]), .wi(weighted_inputs3_7_1));
    weighted_inputs_2 w40 (.inputs(inputs8_3), .w(w3_0_3[8]), .wi(weighted_inputs3_8_0));
    weighted_inputs_2 w40_bar (.inputs(inputs8_3), .w(w3_1_3[8]), .wi(weighted_inputs3_8_1));
    weighted_inputs_2 w41 (.inputs(inputs9_3), .w(w3_0_3[9]), .wi(weighted_inputs3_9_0));
    weighted_inputs_2 w41_bar (.inputs(inputs9_3), .w(w3_1_3[9]), .wi(weighted_inputs3_9_1));
    weighted_inputs_2 w42 (.inputs(inputs10_3), .w(w3_0_3[10]), .wi(weighted_inputs3_10_0));
    weighted_inputs_2 w42_bar (.inputs(inputs10_3), .w(w3_1_3[10]), .wi(weighted_inputs3_10_1));
    weighted_inputs_2 w43 (.inputs(inputs11_3), .w(w3_0_3[11]), .wi(weighted_inputs3_11_0));
    weighted_inputs_2 w43_bar (.inputs(inputs11_3), .w(w3_1_3[11]), .wi(weighted_inputs3_11_1));
    weighted_inputs_2 w44 (.inputs(inputs12_3), .w(w3_0_3[12]), .wi(weighted_inputs3_12_0));
    weighted_inputs_2 w44_bar (.inputs(inputs12_3), .w(w3_1_3[12]), .wi(weighted_inputs3_12_1));
    weighted_inputs_2 w45 (.inputs(inputs13_3), .w(w3_0_3[13]), .wi(weighted_inputs3_13_0));
    weighted_inputs_2 w45_bar (.inputs(inputs13_3), .w(w3_1_3[13]), .wi(weighted_inputs3_13_1));
    weighted_inputs_2 w46 (.inputs(inputs14_3), .w(w3_0_3[14]), .wi(weighted_inputs3_14_0));
    weighted_inputs_2 w46_bar (.inputs(inputs14_3), .w(w3_1_3[14]), .wi(weighted_inputs3_14_1));
    weighted_inputs_2 w47 (.inputs(inputs15_3), .w(w3_0_3[15]), .wi(weighted_inputs3_15_0));
    weighted_inputs_2 w47_bar (.inputs(inputs15_3), .w(w3_1_3[15]), .wi(weighted_inputs3_15_1));
    weighted_inputs_2 w48 (.inputs(inputs0_3), .w(w4_0_3[0]), .wi(weighted_inputs4_0_0));
    weighted_inputs_2 w48_bar (.inputs(inputs0_3), .w(w4_1_3[0]), .wi(weighted_inputs4_0_1));
    weighted_inputs_2 w49 (.inputs(inputs1_3), .w(w4_0_3[1]), .wi(weighted_inputs4_1_0));
    weighted_inputs_2 w49_bar (.inputs(inputs1_3), .w(w4_1_3[1]), .wi(weighted_inputs4_1_1));
    weighted_inputs_2 w50 (.inputs(inputs2_3), .w(w4_0_3[2]), .wi(weighted_inputs4_2_0));
    weighted_inputs_2 w50_bar (.inputs(inputs2_3), .w(w4_1_3[2]), .wi(weighted_inputs4_2_1));
    weighted_inputs_2 w51 (.inputs(inputs3_3), .w(w4_0_3[3]), .wi(weighted_inputs4_3_0));
    weighted_inputs_2 w51_bar (.inputs(inputs3_3), .w(w4_1_3[3]), .wi(weighted_inputs4_3_1));
    weighted_inputs_2 w52 (.inputs(inputs4_3), .w(w4_0_3[4]), .wi(weighted_inputs4_4_0));
    weighted_inputs_2 w52_bar (.inputs(inputs4_3), .w(w4_1_3[4]), .wi(weighted_inputs4_4_1));
    weighted_inputs_2 w53 (.inputs(inputs5_3), .w(w4_0_3[5]), .wi(weighted_inputs4_5_0));
    weighted_inputs_2 w53_bar (.inputs(inputs5_3), .w(w4_1_3[5]), .wi(weighted_inputs4_5_1));
    weighted_inputs_2 w54 (.inputs(inputs6_3), .w(w4_0_3[6]), .wi(weighted_inputs4_6_0));
    weighted_inputs_2 w54_bar (.inputs(inputs6_3), .w(w4_1_3[6]), .wi(weighted_inputs4_6_1));
    weighted_inputs_2 w55 (.inputs(inputs7_3), .w(w4_0_3[7]), .wi(weighted_inputs4_7_0));
    weighted_inputs_2 w55_bar (.inputs(inputs7_3), .w(w4_1_3[7]), .wi(weighted_inputs4_7_1));
    weighted_inputs_2 w56 (.inputs(inputs8_3), .w(w4_0_3[8]), .wi(weighted_inputs4_8_0));
    weighted_inputs_2 w56_bar (.inputs(inputs8_3), .w(w4_1_3[8]), .wi(weighted_inputs4_8_1));
    weighted_inputs_2 w57 (.inputs(inputs9_3), .w(w4_0_3[9]), .wi(weighted_inputs4_9_0));
    weighted_inputs_2 w57_bar (.inputs(inputs9_3), .w(w4_1_3[9]), .wi(weighted_inputs4_9_1));
    weighted_inputs_2 w58 (.inputs(inputs10_3), .w(w4_0_3[10]), .wi(weighted_inputs4_10_0));
    weighted_inputs_2 w58_bar (.inputs(inputs10_3), .w(w4_1_3[10]), .wi(weighted_inputs4_10_1));
    weighted_inputs_2 w59 (.inputs(inputs11_3), .w(w4_0_3[11]), .wi(weighted_inputs4_11_0));
    weighted_inputs_2 w59_bar (.inputs(inputs11_3), .w(w4_1_3[11]), .wi(weighted_inputs4_11_1));
    weighted_inputs_2 w60 (.inputs(inputs12_3), .w(w4_0_3[12]), .wi(weighted_inputs4_12_0));
    weighted_inputs_2 w60_bar (.inputs(inputs12_3), .w(w4_1_3[12]), .wi(weighted_inputs4_12_1));
    weighted_inputs_2 w61 (.inputs(inputs13_3), .w(w4_0_3[13]), .wi(weighted_inputs4_13_0));
    weighted_inputs_2 w61_bar (.inputs(inputs13_3), .w(w4_1_3[13]), .wi(weighted_inputs4_13_1));
    weighted_inputs_2 w62 (.inputs(inputs14_3), .w(w4_0_3[14]), .wi(weighted_inputs4_14_0));
    weighted_inputs_2 w62_bar (.inputs(inputs14_3), .w(w4_1_3[14]), .wi(weighted_inputs4_14_1));
    weighted_inputs_2 w63 (.inputs(inputs15_3), .w(w4_0_3[15]), .wi(weighted_inputs4_15_0));
    weighted_inputs_2 w63_bar (.inputs(inputs15_3), .w(w4_1_3[15]), .wi(weighted_inputs4_15_1));
    weighted_inputs_2 w64 (.inputs(inputs0_3), .w(w5_0_3[0]), .wi(weighted_inputs5_0_0));
    weighted_inputs_2 w64_bar (.inputs(inputs0_3), .w(w5_1_3[0]), .wi(weighted_inputs5_0_1));
    weighted_inputs_2 w65 (.inputs(inputs1_3), .w(w5_0_3[1]), .wi(weighted_inputs5_1_0));
    weighted_inputs_2 w65_bar (.inputs(inputs1_3), .w(w5_1_3[1]), .wi(weighted_inputs5_1_1));
    weighted_inputs_2 w66 (.inputs(inputs2_3), .w(w5_0_3[2]), .wi(weighted_inputs5_2_0));
    weighted_inputs_2 w66_bar (.inputs(inputs2_3), .w(w5_1_3[2]), .wi(weighted_inputs5_2_1));
    weighted_inputs_2 w67 (.inputs(inputs3_3), .w(w5_0_3[3]), .wi(weighted_inputs5_3_0));
    weighted_inputs_2 w67_bar (.inputs(inputs3_3), .w(w5_1_3[3]), .wi(weighted_inputs5_3_1));
    weighted_inputs_2 w68 (.inputs(inputs4_3), .w(w5_0_3[4]), .wi(weighted_inputs5_4_0));
    weighted_inputs_2 w68_bar (.inputs(inputs4_3), .w(w5_1_3[4]), .wi(weighted_inputs5_4_1));
    weighted_inputs_2 w69 (.inputs(inputs5_3), .w(w5_0_3[5]), .wi(weighted_inputs5_5_0));
    weighted_inputs_2 w69_bar (.inputs(inputs5_3), .w(w5_1_3[5]), .wi(weighted_inputs5_5_1));
    weighted_inputs_2 w70 (.inputs(inputs6_3), .w(w5_0_3[6]), .wi(weighted_inputs5_6_0));
    weighted_inputs_2 w70_bar (.inputs(inputs6_3), .w(w5_1_3[6]), .wi(weighted_inputs5_6_1));
    weighted_inputs_2 w71 (.inputs(inputs7_3), .w(w5_0_3[7]), .wi(weighted_inputs5_7_0));
    weighted_inputs_2 w71_bar (.inputs(inputs7_3), .w(w5_1_3[7]), .wi(weighted_inputs5_7_1));
    weighted_inputs_2 w72 (.inputs(inputs8_3), .w(w5_0_3[8]), .wi(weighted_inputs5_8_0));
    weighted_inputs_2 w72_bar (.inputs(inputs8_3), .w(w5_1_3[8]), .wi(weighted_inputs5_8_1));
    weighted_inputs_2 w73 (.inputs(inputs9_3), .w(w5_0_3[9]), .wi(weighted_inputs5_9_0));
    weighted_inputs_2 w73_bar (.inputs(inputs9_3), .w(w5_1_3[9]), .wi(weighted_inputs5_9_1));
    weighted_inputs_2 w74 (.inputs(inputs10_3), .w(w5_0_3[10]), .wi(weighted_inputs5_10_0));
    weighted_inputs_2 w74_bar (.inputs(inputs10_3), .w(w5_1_3[10]), .wi(weighted_inputs5_10_1));
    weighted_inputs_2 w75 (.inputs(inputs11_3), .w(w5_0_3[11]), .wi(weighted_inputs5_11_0));
    weighted_inputs_2 w75_bar (.inputs(inputs11_3), .w(w5_1_3[11]), .wi(weighted_inputs5_11_1));
    weighted_inputs_2 w76 (.inputs(inputs12_3), .w(w5_0_3[12]), .wi(weighted_inputs5_12_0));
    weighted_inputs_2 w76_bar (.inputs(inputs12_3), .w(w5_1_3[12]), .wi(weighted_inputs5_12_1));
    weighted_inputs_2 w77 (.inputs(inputs13_3), .w(w5_0_3[13]), .wi(weighted_inputs5_13_0));
    weighted_inputs_2 w77_bar (.inputs(inputs13_3), .w(w5_1_3[13]), .wi(weighted_inputs5_13_1));
    weighted_inputs_2 w78 (.inputs(inputs14_3), .w(w5_0_3[14]), .wi(weighted_inputs5_14_0));
    weighted_inputs_2 w78_bar (.inputs(inputs14_3), .w(w5_1_3[14]), .wi(weighted_inputs5_14_1));
    weighted_inputs_2 w79 (.inputs(inputs15_3), .w(w5_0_3[15]), .wi(weighted_inputs5_15_0));
    weighted_inputs_2 w79_bar (.inputs(inputs15_3), .w(w5_1_3[15]), .wi(weighted_inputs5_15_1));
    weighted_inputs_2 w80 (.inputs(inputs0_3), .w(w6_0_3[0]), .wi(weighted_inputs6_0_0));
    weighted_inputs_2 w80_bar (.inputs(inputs0_3), .w(w6_1_3[0]), .wi(weighted_inputs6_0_1));
    weighted_inputs_2 w81 (.inputs(inputs1_3), .w(w6_0_3[1]), .wi(weighted_inputs6_1_0));
    weighted_inputs_2 w81_bar (.inputs(inputs1_3), .w(w6_1_3[1]), .wi(weighted_inputs6_1_1));
    weighted_inputs_2 w82 (.inputs(inputs2_3), .w(w6_0_3[2]), .wi(weighted_inputs6_2_0));
    weighted_inputs_2 w82_bar (.inputs(inputs2_3), .w(w6_1_3[2]), .wi(weighted_inputs6_2_1));
    weighted_inputs_2 w83 (.inputs(inputs3_3), .w(w6_0_3[3]), .wi(weighted_inputs6_3_0));
    weighted_inputs_2 w83_bar (.inputs(inputs3_3), .w(w6_1_3[3]), .wi(weighted_inputs6_3_1));
    weighted_inputs_2 w84 (.inputs(inputs4_3), .w(w6_0_3[4]), .wi(weighted_inputs6_4_0));
    weighted_inputs_2 w84_bar (.inputs(inputs4_3), .w(w6_1_3[4]), .wi(weighted_inputs6_4_1));
    weighted_inputs_2 w85 (.inputs(inputs5_3), .w(w6_0_3[5]), .wi(weighted_inputs6_5_0));
    weighted_inputs_2 w85_bar (.inputs(inputs5_3), .w(w6_1_3[5]), .wi(weighted_inputs6_5_1));
    weighted_inputs_2 w86 (.inputs(inputs6_3), .w(w6_0_3[6]), .wi(weighted_inputs6_6_0));
    weighted_inputs_2 w86_bar (.inputs(inputs6_3), .w(w6_1_3[6]), .wi(weighted_inputs6_6_1));
    weighted_inputs_2 w87 (.inputs(inputs7_3), .w(w6_0_3[7]), .wi(weighted_inputs6_7_0));
    weighted_inputs_2 w87_bar (.inputs(inputs7_3), .w(w6_1_3[7]), .wi(weighted_inputs6_7_1));
    weighted_inputs_2 w88 (.inputs(inputs8_3), .w(w6_0_3[8]), .wi(weighted_inputs6_8_0));
    weighted_inputs_2 w88_bar (.inputs(inputs8_3), .w(w6_1_3[8]), .wi(weighted_inputs6_8_1));
    weighted_inputs_2 w89 (.inputs(inputs9_3), .w(w6_0_3[9]), .wi(weighted_inputs6_9_0));
    weighted_inputs_2 w89_bar (.inputs(inputs9_3), .w(w6_1_3[9]), .wi(weighted_inputs6_9_1));
    weighted_inputs_2 w90 (.inputs(inputs10_3), .w(w6_0_3[10]), .wi(weighted_inputs6_10_0));
    weighted_inputs_2 w90_bar (.inputs(inputs10_3), .w(w6_1_3[10]), .wi(weighted_inputs6_10_1));
    weighted_inputs_2 w91 (.inputs(inputs11_3), .w(w6_0_3[11]), .wi(weighted_inputs6_11_0));
    weighted_inputs_2 w91_bar (.inputs(inputs11_3), .w(w6_1_3[11]), .wi(weighted_inputs6_11_1));
    weighted_inputs_2 w92 (.inputs(inputs12_3), .w(w6_0_3[12]), .wi(weighted_inputs6_12_0));
    weighted_inputs_2 w92_bar (.inputs(inputs12_3), .w(w6_1_3[12]), .wi(weighted_inputs6_12_1));
    weighted_inputs_2 w93 (.inputs(inputs13_3), .w(w6_0_3[13]), .wi(weighted_inputs6_13_0));
    weighted_inputs_2 w93_bar (.inputs(inputs13_3), .w(w6_1_3[13]), .wi(weighted_inputs6_13_1));
    weighted_inputs_2 w94 (.inputs(inputs14_3), .w(w6_0_3[14]), .wi(weighted_inputs6_14_0));
    weighted_inputs_2 w94_bar (.inputs(inputs14_3), .w(w6_1_3[14]), .wi(weighted_inputs6_14_1));
    weighted_inputs_2 w95 (.inputs(inputs15_3), .w(w6_0_3[15]), .wi(weighted_inputs6_15_0));
    weighted_inputs_2 w95_bar (.inputs(inputs15_3), .w(w6_1_3[15]), .wi(weighted_inputs6_15_1));
    weighted_inputs_2 w96 (.inputs(inputs0_3), .w(w7_0_3[0]), .wi(weighted_inputs7_0_0));
    weighted_inputs_2 w96_bar (.inputs(inputs0_3), .w(w7_1_3[0]), .wi(weighted_inputs7_0_1));
    weighted_inputs_2 w97 (.inputs(inputs1_3), .w(w7_0_3[1]), .wi(weighted_inputs7_1_0));
    weighted_inputs_2 w97_bar (.inputs(inputs1_3), .w(w7_1_3[1]), .wi(weighted_inputs7_1_1));
    weighted_inputs_2 w98 (.inputs(inputs2_3), .w(w7_0_3[2]), .wi(weighted_inputs7_2_0));
    weighted_inputs_2 w98_bar (.inputs(inputs2_3), .w(w7_1_3[2]), .wi(weighted_inputs7_2_1));
    weighted_inputs_2 w99 (.inputs(inputs3_3), .w(w7_0_3[3]), .wi(weighted_inputs7_3_0));
    weighted_inputs_2 w99_bar (.inputs(inputs3_3), .w(w7_1_3[3]), .wi(weighted_inputs7_3_1));
    weighted_inputs_2 w100 (.inputs(inputs4_3), .w(w7_0_3[4]), .wi(weighted_inputs7_4_0));
    weighted_inputs_2 w100_bar (.inputs(inputs4_3), .w(w7_1_3[4]), .wi(weighted_inputs7_4_1));
    weighted_inputs_2 w101 (.inputs(inputs5_3), .w(w7_0_3[5]), .wi(weighted_inputs7_5_0));
    weighted_inputs_2 w101_bar (.inputs(inputs5_3), .w(w7_1_3[5]), .wi(weighted_inputs7_5_1));
    weighted_inputs_2 w102 (.inputs(inputs6_3), .w(w7_0_3[6]), .wi(weighted_inputs7_6_0));
    weighted_inputs_2 w102_bar (.inputs(inputs6_3), .w(w7_1_3[6]), .wi(weighted_inputs7_6_1));
    weighted_inputs_2 w103 (.inputs(inputs7_3), .w(w7_0_3[7]), .wi(weighted_inputs7_7_0));
    weighted_inputs_2 w103_bar (.inputs(inputs7_3), .w(w7_1_3[7]), .wi(weighted_inputs7_7_1));
    weighted_inputs_2 w104 (.inputs(inputs8_3), .w(w7_0_3[8]), .wi(weighted_inputs7_8_0));
    weighted_inputs_2 w104_bar (.inputs(inputs8_3), .w(w7_1_3[8]), .wi(weighted_inputs7_8_1));
    weighted_inputs_2 w105 (.inputs(inputs9_3), .w(w7_0_3[9]), .wi(weighted_inputs7_9_0));
    weighted_inputs_2 w105_bar (.inputs(inputs9_3), .w(w7_1_3[9]), .wi(weighted_inputs7_9_1));
    weighted_inputs_2 w106 (.inputs(inputs10_3), .w(w7_0_3[10]), .wi(weighted_inputs7_10_0));
    weighted_inputs_2 w106_bar (.inputs(inputs10_3), .w(w7_1_3[10]), .wi(weighted_inputs7_10_1));
    weighted_inputs_2 w107 (.inputs(inputs11_3), .w(w7_0_3[11]), .wi(weighted_inputs7_11_0));
    weighted_inputs_2 w107_bar (.inputs(inputs11_3), .w(w7_1_3[11]), .wi(weighted_inputs7_11_1));
    weighted_inputs_2 w108 (.inputs(inputs12_3), .w(w7_0_3[12]), .wi(weighted_inputs7_12_0));
    weighted_inputs_2 w108_bar (.inputs(inputs12_3), .w(w7_1_3[12]), .wi(weighted_inputs7_12_1));
    weighted_inputs_2 w109 (.inputs(inputs13_3), .w(w7_0_3[13]), .wi(weighted_inputs7_13_0));
    weighted_inputs_2 w109_bar (.inputs(inputs13_3), .w(w7_1_3[13]), .wi(weighted_inputs7_13_1));
    weighted_inputs_2 w110 (.inputs(inputs14_3), .w(w7_0_3[14]), .wi(weighted_inputs7_14_0));
    weighted_inputs_2 w110_bar (.inputs(inputs14_3), .w(w7_1_3[14]), .wi(weighted_inputs7_14_1));
    weighted_inputs_2 w111 (.inputs(inputs15_3), .w(w7_0_3[15]), .wi(weighted_inputs7_15_0));
    weighted_inputs_2 w111_bar (.inputs(inputs15_3), .w(w7_1_3[15]), .wi(weighted_inputs7_15_1));
    weighted_inputs_2 w112 (.inputs(inputs0_3), .w(w8_0_3[0]), .wi(weighted_inputs8_0_0));
    weighted_inputs_2 w112_bar (.inputs(inputs0_3), .w(w8_1_3[0]), .wi(weighted_inputs8_0_1));
    weighted_inputs_2 w113 (.inputs(inputs1_3), .w(w8_0_3[1]), .wi(weighted_inputs8_1_0));
    weighted_inputs_2 w113_bar (.inputs(inputs1_3), .w(w8_1_3[1]), .wi(weighted_inputs8_1_1));
    weighted_inputs_2 w114 (.inputs(inputs2_3), .w(w8_0_3[2]), .wi(weighted_inputs8_2_0));
    weighted_inputs_2 w114_bar (.inputs(inputs2_3), .w(w8_1_3[2]), .wi(weighted_inputs8_2_1));
    weighted_inputs_2 w115 (.inputs(inputs3_3), .w(w8_0_3[3]), .wi(weighted_inputs8_3_0));
    weighted_inputs_2 w115_bar (.inputs(inputs3_3), .w(w8_1_3[3]), .wi(weighted_inputs8_3_1));
    weighted_inputs_2 w116 (.inputs(inputs4_3), .w(w8_0_3[4]), .wi(weighted_inputs8_4_0));
    weighted_inputs_2 w116_bar (.inputs(inputs4_3), .w(w8_1_3[4]), .wi(weighted_inputs8_4_1));
    weighted_inputs_2 w117 (.inputs(inputs5_3), .w(w8_0_3[5]), .wi(weighted_inputs8_5_0));
    weighted_inputs_2 w117_bar (.inputs(inputs5_3), .w(w8_1_3[5]), .wi(weighted_inputs8_5_1));
    weighted_inputs_2 w118 (.inputs(inputs6_3), .w(w8_0_3[6]), .wi(weighted_inputs8_6_0));
    weighted_inputs_2 w118_bar (.inputs(inputs6_3), .w(w8_1_3[6]), .wi(weighted_inputs8_6_1));
    weighted_inputs_2 w119 (.inputs(inputs7_3), .w(w8_0_3[7]), .wi(weighted_inputs8_7_0));
    weighted_inputs_2 w119_bar (.inputs(inputs7_3), .w(w8_1_3[7]), .wi(weighted_inputs8_7_1));
    weighted_inputs_2 w120 (.inputs(inputs8_3), .w(w8_0_3[8]), .wi(weighted_inputs8_8_0));
    weighted_inputs_2 w120_bar (.inputs(inputs8_3), .w(w8_1_3[8]), .wi(weighted_inputs8_8_1));
    weighted_inputs_2 w121 (.inputs(inputs9_3), .w(w8_0_3[9]), .wi(weighted_inputs8_9_0));
    weighted_inputs_2 w121_bar (.inputs(inputs9_3), .w(w8_1_3[9]), .wi(weighted_inputs8_9_1));
    weighted_inputs_2 w122 (.inputs(inputs10_3), .w(w8_0_3[10]), .wi(weighted_inputs8_10_0));
    weighted_inputs_2 w122_bar (.inputs(inputs10_3), .w(w8_1_3[10]), .wi(weighted_inputs8_10_1));
    weighted_inputs_2 w123 (.inputs(inputs11_3), .w(w8_0_3[11]), .wi(weighted_inputs8_11_0));
    weighted_inputs_2 w123_bar (.inputs(inputs11_3), .w(w8_1_3[11]), .wi(weighted_inputs8_11_1));
    weighted_inputs_2 w124 (.inputs(inputs12_3), .w(w8_0_3[12]), .wi(weighted_inputs8_12_0));
    weighted_inputs_2 w124_bar (.inputs(inputs12_3), .w(w8_1_3[12]), .wi(weighted_inputs8_12_1));
    weighted_inputs_2 w125 (.inputs(inputs13_3), .w(w8_0_3[13]), .wi(weighted_inputs8_13_0));
    weighted_inputs_2 w125_bar (.inputs(inputs13_3), .w(w8_1_3[13]), .wi(weighted_inputs8_13_1));
    weighted_inputs_2 w126 (.inputs(inputs14_3), .w(w8_0_3[14]), .wi(weighted_inputs8_14_0));
    weighted_inputs_2 w126_bar (.inputs(inputs14_3), .w(w8_1_3[14]), .wi(weighted_inputs8_14_1));
    weighted_inputs_2 w127 (.inputs(inputs15_3), .w(w8_0_3[15]), .wi(weighted_inputs8_15_0));
    weighted_inputs_2 w127_bar (.inputs(inputs15_3), .w(w8_1_3[15]), .wi(weighted_inputs8_15_1));
    adder_tree_3 add0(
    .clk(clk), 
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
    adder_tree_3 add8(
    .clk(clk), 
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
    .clk(clk), 
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
    adder_tree_bar_3 addb8(
    .clk(clk), 
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
    .clk(clk), 
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
    adder_tree_3 add9(
    .clk(clk), 
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
    .clk(clk), 
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
    adder_tree_bar_3 addb9(
    .clk(clk), 
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
    adder_tree_3 add2(
    .clk(clk), 
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
    adder_tree_3 add10(
    .clk(clk), 
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
    adder_tree_bar_3 addb2(
    .clk(clk), 
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
    adder_tree_bar_3 addb10(
    .clk(clk), 
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
    adder_tree_3 add3(
    .clk(clk), 
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
    adder_tree_3 add11(
    .clk(clk), 
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
    adder_tree_bar_3 addb3(
    .clk(clk), 
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
    adder_tree_bar_3 addb11(
    .clk(clk), 
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
    adder_tree_3 add4(
    .clk(clk), 
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
    adder_tree_3 add12(
    .clk(clk), 
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
    adder_tree_bar_3 addb4(
    .clk(clk), 
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
    adder_tree_bar_3 addb12(
    .clk(clk), 
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
    adder_tree_3 add5(
    .clk(clk), 
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
    adder_tree_3 add13(
    .clk(clk), 
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
    adder_tree_bar_3 addb5(
    .clk(clk), 
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
    adder_tree_bar_3 addb13(
    .clk(clk), 
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
    adder_tree_3 add6(
    .clk(clk), 
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
    adder_tree_3 add14(
    .clk(clk), 
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
    adder_tree_bar_3 addb6(
    .clk(clk), 
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
    adder_tree_bar_3 addb14(
    .clk(clk), 
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
    adder_tree_3 add7(
    .clk(clk), 
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
    adder_tree_3 add15(
    .clk(clk), 
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
    adder_tree_bar_3 addb7(
    .clk(clk), 
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
    adder_tree_bar_3 addb15(
    .clk(clk), 
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
    add5bit_3 u0 (.a(sum1[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1[0]));
    add5bit_3 u8 (.a(sum2[0]), .b(b1_3), .cin(1'b0), .y(biased_sum2[0]));
    add5bitbar_3 ub0 (.a(sum1bar[0]), .b(b1_3), .cin(1'b0), .y(biased_sum1bar[0]));
    add5bitbar_3 ub8 (.a(sum2bar[0]), .b(b1_3), .cin(1'b0), .y(biased_sum2bar[0]));
    add5bit_3 u1 (.a(sum1[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1[1]));
    add5bit_3 u9 (.a(sum2[1]), .b(b2_3), .cin(1'b0), .y(biased_sum2[1]));
    add5bitbar_3 ub1 (.a(sum1bar[1]), .b(b2_3), .cin(1'b0), .y(biased_sum1bar[1]));
    add5bitbar_3 ub9 (.a(sum2bar[1]), .b(b2_3), .cin(1'b0), .y(biased_sum2bar[1]));
    add5bit_3 u2 (.a(sum1[2]), .b(b3_3), .cin(1'b0), .y(biased_sum1[2]));
    add5bit_3 u10 (.a(sum2[2]), .b(b3_3), .cin(1'b0), .y(biased_sum2[2]));
    add5bitbar_3 ub2 (.a(sum1bar[2]), .b(b3_3), .cin(1'b0), .y(biased_sum1bar[2]));
    add5bitbar_3 ub10 (.a(sum2bar[2]), .b(b3_3), .cin(1'b0), .y(biased_sum2bar[2]));
    add5bit_3 u3 (.a(sum1[3]), .b(b4_3), .cin(1'b0), .y(biased_sum1[3]));
    add5bit_3 u11 (.a(sum2[3]), .b(b4_3), .cin(1'b0), .y(biased_sum2[3]));
    add5bitbar_3 ub3 (.a(sum1bar[3]), .b(b4_3), .cin(1'b0), .y(biased_sum1bar[3]));
    add5bitbar_3 ub11 (.a(sum2bar[3]), .b(b4_3), .cin(1'b0), .y(biased_sum2bar[3]));
    add5bit_3 u4 (.a(sum1[4]), .b(b5_3), .cin(1'b0), .y(biased_sum1[4]));
    add5bit_3 u12 (.a(sum2[4]), .b(b5_3), .cin(1'b0), .y(biased_sum2[4]));
    add5bitbar_3 ub4 (.a(sum1bar[4]), .b(b5_3), .cin(1'b0), .y(biased_sum1bar[4]));
    add5bitbar_3 ub12 (.a(sum2bar[4]), .b(b5_3), .cin(1'b0), .y(biased_sum2bar[4]));
    add5bit_3 u5 (.a(sum1[5]), .b(b6_3), .cin(1'b0), .y(biased_sum1[5]));
    add5bit_3 u13 (.a(sum2[5]), .b(b6_3), .cin(1'b0), .y(biased_sum2[5]));
    add5bitbar_3 ub5 (.a(sum1bar[5]), .b(b6_3), .cin(1'b0), .y(biased_sum1bar[5]));
    add5bitbar_3 ub13 (.a(sum2bar[5]), .b(b6_3), .cin(1'b0), .y(biased_sum2bar[5]));
    add5bit_3 u6 (.a(sum1[6]), .b(b7_3), .cin(1'b0), .y(biased_sum1[6]));
    add5bit_3 u14 (.a(sum2[6]), .b(b7_3), .cin(1'b0), .y(biased_sum2[6]));
    add5bitbar_3 ub6 (.a(sum1bar[6]), .b(b7_3), .cin(1'b0), .y(biased_sum1bar[6]));
    add5bitbar_3 ub14 (.a(sum2bar[6]), .b(b7_3), .cin(1'b0), .y(biased_sum2bar[6]));
    add5bit_3 u7 (.a(sum1[7]), .b(b8_3), .cin(1'b0), .y(biased_sum1[7]));
    add5bit_3 u15 (.a(sum2[7]), .b(b8_3), .cin(1'b0), .y(biased_sum2[7]));
    add5bitbar_3 ub7 (.a(sum1bar[7]), .b(b8_3), .cin(1'b0), .y(biased_sum1bar[7]));
    add5bitbar_3 ub15 (.a(sum2bar[7]), .b(b8_3), .cin(1'b0), .y(biased_sum2bar[7]));
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
        $display("----- BNN LAYER 3 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_3, inputs1_3, inputs2_3, inputs3_3, inputs4_3, inputs5_3, inputs6_3, inputs7_3, inputs8_3, inputs9_3, inputs10_3, inputs11_3, inputs12_3, inputs13_3, inputs14_3, inputs15_3);
        $display("Weights0: %b %b %b %b %b %b %b %b", w1_0_3, w2_0_3, w3_0_3, w4_0_3, w5_0_3, w6_0_3, w7_0_3, w8_0_3);
        $display("Weights1: %b %b %b %b %b %b %b %b", w1_1_3, w2_1_3, w3_1_3, w4_1_3, w5_1_3, w6_1_3, w7_1_3, w8_1_3);
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


module activation_3 (

    input [5:0] inputs0_0,
    input [5:0] inputs0_1,

    input r0_0, r1_0, r2_0, r3_0, r4_0, r5_0,

    output masked_activation,
    output mask
);

    wire r1, r2, r3, r4, r5, r6;
    wire masked_c0_0, masked_c1_0, masked_c2_0, masked_c3_0, masked_c4_0, masked_c5_0;

    lut0 l0 (.a(inputs0_0[0]), .b(inputs0_1[0]), .c_in(1'b0), .r_i(r0_0), .r_out(r1), .c_masked(masked_c0_0));
    lut1 l1 (.a(inputs0_0[1]), .b(inputs0_1[1]), .c_in(masked_c0_0), .r_flow(r1), .r_i(r1_0), .r_out(r2), .c_masked(masked_c1_0));
    lut1 l2 (.a(inputs0_0[2]), .b(inputs0_1[2]), .c_in(masked_c1_0), .r_flow(r2), .r_i(r2_0), .r_out(r3), .c_masked(masked_c2_0));
    lut1 l3 (.a(inputs0_0[3]), .b(inputs0_1[3]), .c_in(masked_c2_0), .r_flow(r3), .r_i(r3_0), .r_out(r4), .c_masked(masked_c3_0));
    lut1 l4 (.a(inputs0_0[4]), .b(inputs0_1[4]), .c_in(masked_c3_0), .r_flow(r4), .r_i(r4_0), .r_out(r5), .c_masked(masked_c4_0));
    lut1 l5 (.a(inputs0_0[5]), .b(inputs0_1[5]), .c_in(masked_c4_0), .r_flow(r5), .r_i(r5_0), .r_out(r6), .c_masked(masked_c5_0));

    wire carry = r6 ^ masked_c5_0;
    wire activation = (carry ^ inputs0_0[5] ^ inputs0_1[5]) ? 1'b0 : 1'b1;

    assign masked_activation = activation ^ r6;
    assign mask = r6;

endmodule

module activation_array_3 (
    input  [5:0] inputs0_0, inputs0_1,
    input  [5:0] inputs1_0, inputs1_1,
    input  [5:0] inputs2_0, inputs2_1,
    input  [5:0] inputs3_0, inputs3_1,
    input  [5:0] inputs4_0, inputs4_1,
    input  [5:0] inputs5_0, inputs5_1,
    input  [5:0] inputs6_0, inputs6_1,
    input  [5:0] inputs7_0, inputs7_1,
    input  r0_0, r1_0, r2_0, r3_0, r4_0, r5_0,
    input  r0_1, r1_1, r2_1, r3_1, r4_1, r5_1,
    input  r0_2, r1_2, r2_2, r3_2, r4_2, r5_2,
    input  r0_3, r1_3, r2_3, r3_3, r4_3, r5_3,
    input  r0_4, r1_4, r2_4, r3_4, r4_4, r5_4,
    input  r0_5, r1_5, r2_5, r3_5, r4_5, r5_5,
    input  r0_6, r1_6, r2_6, r3_6, r4_6, r5_6,
    input  r0_7, r1_7, r2_7, r3_7, r4_7, r5_7,
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

    activation_3 a0 (
        .inputs0_0(inputs0_0), .inputs0_1(inputs0_1),
        .r0_0(r0_0),
        .r1_0(r1_0),
        .r2_0(r2_0),
        .r3_0(r3_0),
        .r4_0(r4_0),
        .r5_0(r5_0),
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
        .masked_activation(masked_activation3),
        .mask(mask3)
    );

    activation_3 a4 (
        .inputs0_0(inputs4_0), .inputs0_1(inputs4_1),
        .r0_0(r0_4),
        .r1_0(r1_4),
        .r2_0(r2_4),
        .r3_0(r3_4),
        .r4_0(r4_4),
        .r5_0(r5_4),
        .masked_activation(masked_activation4),
        .mask(mask4)
    );

    activation_3 a5 (
        .inputs0_0(inputs5_0), .inputs0_1(inputs5_1),
        .r0_0(r0_5),
        .r1_0(r1_5),
        .r2_0(r2_5),
        .r3_0(r3_5),
        .r4_0(r4_5),
        .r5_0(r5_5),
        .masked_activation(masked_activation5),
        .mask(mask5)
    );

    activation_3 a6 (
        .inputs0_0(inputs6_0), .inputs0_1(inputs6_1),
        .r0_0(r0_6),
        .r1_0(r1_6),
        .r2_0(r2_6),
        .r3_0(r3_6),
        .r4_0(r4_6),
        .r5_0(r5_6),
        .masked_activation(masked_activation6),
        .mask(mask6)
    );

    activation_3 a7 (
        .inputs0_0(inputs7_0), .inputs0_1(inputs7_1),
        .r0_0(r0_7),
        .r1_0(r1_7),
        .r2_0(r2_7),
        .r3_0(r3_7),
        .r4_0(r4_7),
        .r5_0(r5_7),
        .masked_activation(masked_activation7),
        .mask(mask7)
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
  input  wire [15:0] w1_0_3, w1_1_3,
  input  wire [15:0] w2_0_3, w2_1_3,
  input  wire [15:0] w3_0_3, w3_1_3,
  input  wire [15:0] w4_0_3, w4_1_3,
  input  wire [15:0] w5_0_3, w5_1_3,
  input  wire [15:0] w6_0_3, w6_1_3,
  input  wire [15:0] w7_0_3, w7_1_3,
  input  wire [15:0] w8_0_3, w8_1_3,
  input  wire [4:0] b1_3, b2_3, b3_3, b4_3, b5_3, b6_3, b7_3, b8_3,
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
  input  wire r0_3,
  input  wire r1_3,
  input  wire r2_3,
  input  wire r3_3,
  input  wire r4_3,
  input  wire r5_3,
  input  wire r0_4,
  input  wire r1_4,
  input  wire r2_4,
  input  wire r3_4,
  input  wire r4_4,
  input  wire r5_4,
  input  wire r0_5,
  input  wire r1_5,
  input  wire r2_5,
  input  wire r3_5,
  input  wire r4_5,
  input  wire r5_5,
  input  wire r0_6,
  input  wire r1_6,
  input  wire r2_6,
  input  wire r3_6,
  input  wire r4_6,
  input  wire r5_6,
  input  wire r0_7,
  input  wire r1_7,
  input  wire r2_7,
  input  wire r3_7,
  input  wire r4_7,
  input  wire r5_7,
  output wire masked_activation0_3, masked_activation0bar_3,
  output wire mask0_3, mask0bar_3,
  output wire masked_activation1_3, masked_activation1bar_3,
  output wire mask1_3, mask1bar_3,
  output wire masked_activation2_3, masked_activation2bar_3,
  output wire mask2_3, mask2bar_3,
  output wire masked_activation3_3, masked_activation3bar_3,
  output wire mask3_3, mask3bar_3,
  output wire masked_activation4_3, masked_activation4bar_3,
  output wire mask4_3, mask4bar_3,
  output wire masked_activation5_3, masked_activation5bar_3,
  output wire mask5_3, mask5bar_3,
  output wire masked_activation6_3, masked_activation6bar_3,
  output wire mask6_3, mask6bar_3,
  output wire masked_activation7_3, masked_activation7bar_3,
  output wire mask7_3, mask7bar_3
);

  wire [5:0] biased_sum0_0, biased_sum0_0bar;
  wire [5:0] biased_sum0_1, biased_sum0_1bar;
  wire [5:0] biased_sum1_0, biased_sum1_0bar;
  wire [5:0] biased_sum1_1, biased_sum1_1bar;
  wire [5:0] biased_sum2_0, biased_sum2_0bar;
  wire [5:0] biased_sum2_1, biased_sum2_1bar;
  wire [5:0] biased_sum3_0, biased_sum3_0bar;
  wire [5:0] biased_sum3_1, biased_sum3_1bar;
  wire [5:0] biased_sum4_0, biased_sum4_0bar;
  wire [5:0] biased_sum4_1, biased_sum4_1bar;
  wire [5:0] biased_sum5_0, biased_sum5_0bar;
  wire [5:0] biased_sum5_1, biased_sum5_1bar;
  wire [5:0] biased_sum6_0, biased_sum6_0bar;
  wire [5:0] biased_sum6_1, biased_sum6_1bar;
  wire [5:0] biased_sum7_0, biased_sum7_0bar;
  wire [5:0] biased_sum7_1, biased_sum7_1bar;

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
    .w1_0_3(w1_0_3), .w1_1_3(w1_1_3),
    .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
    .w3_0_3(w3_0_3), .w3_1_3(w3_1_3),
    .w4_0_3(w4_0_3), .w4_1_3(w4_1_3),
    .w5_0_3(w5_0_3), .w5_1_3(w5_1_3),
    .w6_0_3(w6_0_3), .w6_1_3(w6_1_3),
    .w7_0_3(w7_0_3), .w7_1_3(w7_1_3),
    .w8_0_3(w8_0_3), .w8_1_3(w8_1_3),
    .b1_3(b1_3),
    .b2_3(b2_3),
    .b3_3(b3_3),
    .b4_3(b4_3),
    .b5_3(b5_3),
    .b6_3(b6_3),
    .b7_3(b7_3),
    .b8_3(b8_3),
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

    activation_array_3 act1 (
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
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r0_7(r0_7),
    .r1_7(r1_7),
    .r2_7(r2_7),
    .r3_7(r3_7),
    .r4_7(r4_7),
    .r5_7(r5_7),
    .masked_activation0(masked_activation0_3),
    .masked_activation1(masked_activation1_3),
    .masked_activation2(masked_activation2_3),
    .masked_activation3(masked_activation3_3),
    .masked_activation4(masked_activation4_3),
    .masked_activation5(masked_activation5_3),
    .masked_activation6(masked_activation6_3),
    .masked_activation7(masked_activation7_3),
    .mask0(mask0_3),
    .mask1(mask1_3),
    .mask2(mask2_3),
    .mask3(mask3_3),
    .mask4(mask4_3),
    .mask5(mask5_3),
    .mask6(mask6_3),
    .mask7(mask7_3)
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
    .r0_3(r0_3),
    .r1_3(r1_3),
    .r2_3(r2_3),
    .r3_3(r3_3),
    .r4_3(r4_3),
    .r5_3(r5_3),
    .r0_4(r0_4),
    .r1_4(r1_4),
    .r2_4(r2_4),
    .r3_4(r3_4),
    .r4_4(r4_4),
    .r5_4(r5_4),
    .r0_5(r0_5),
    .r1_5(r1_5),
    .r2_5(r2_5),
    .r3_5(r3_5),
    .r4_5(r4_5),
    .r5_5(r5_5),
    .r0_6(r0_6),
    .r1_6(r1_6),
    .r2_6(r2_6),
    .r3_6(r3_6),
    .r4_6(r4_6),
    .r5_6(r5_6),
    .r0_7(r0_7),
    .r1_7(r1_7),
    .r2_7(r2_7),
    .r3_7(r3_7),
    .r4_7(r4_7),
    .r5_7(r5_7),
    .masked_activation0(masked_activation0bar_3),
    .masked_activation1(masked_activation1bar_3),
    .masked_activation2(masked_activation2bar_3),
    .masked_activation3(masked_activation3bar_3),
    .masked_activation4(masked_activation4bar_3),
    .masked_activation5(masked_activation5bar_3),
    .masked_activation6(masked_activation6bar_3),
    .masked_activation7(masked_activation7bar_3),
    .mask0(mask0bar_3),
    .mask1(mask1bar_3),
    .mask2(mask2bar_3),
    .mask3(mask3bar_3),
    .mask4(mask4bar_3),
    .mask5(mask5bar_3),
    .mask6(mask6bar_3),
    .mask7(mask7bar_3)
  );

    always @(posedge clk) begin
    $display("----- LAYER 3   boolean activations -----");
    $display("masked_activation : %b %b %b %b %b %b %b %b", masked_activation0_3, masked_activation1_3, masked_activation2_3, masked_activation3_3, masked_activation4_3, masked_activation5_3, masked_activation6_3, masked_activation7_3);
    $display("masked_activationbar : %b %b %b %b %b %b %b %b", masked_activation0bar_3, masked_activation1bar_3, masked_activation2bar_3, masked_activation3bar_3, masked_activation4bar_3, masked_activation5bar_3, masked_activation6bar_3, masked_activation7bar_3);
    $display("mask : %b %b %b %b %b %b %b %b", mask0_3, mask1_3, mask2_3, mask3_3, mask4_3, mask5_3, mask6_3, mask7_3);
    $display("maskbar : %b %b %b %b %b %b %b %b", mask0bar_3, mask1bar_3, mask2bar_3, mask3bar_3, mask4bar_3, mask5bar_3, mask6bar_3, mask7bar_3);
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

module add1bitbar_4(
    input wire [0:0] a,
    input wire [0:0] b,
    input wire  cin,
    output wire [1:0] y,
    output wire cout,
    output wire cout_bar
);

    wire s1, s1_1, s2, s2_1, s3, s3_1, s4, s4_1;
wire c1;

full_adderbar_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));

WddlNANDbar_4 wn1(.A(~a[0]), .B(b[0]), .C(~c1), .S(s1), .S1(s1_1));
WddlNANDbar_4 wn2(.A(a[0]), .B(~b[0]), .C(~c1), .S(s2), .S1(s2_1));
WddlNANDbar_4 wn3(.A(a[0]), .B(b[0]), .C(c1), .S(s3), .S1(s3_1));
WddlNANDbar_4 wn4(.A(~a[0]), .B(~b[0]), .C(c1), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[1] = cout_bar;

endmodule

module add2bitbar_4(
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

full_adderbar_4 fa0(.S(y[0]), .C(c1), .X(a[0]), .Y(b[0]), .Z(cin));
full_adderbar_4 fa1(.S(y[1]), .C(c2), .X(a[1]), .Y(b[1]), .Z(c1));

WddlNANDbar_4 wn1(.A(~a[1]), .B(b[1]), .C(~c2), .S(s1), .S1(s1_1));
WddlNANDbar_4 wn2(.A(a[1]), .B(~b[1]), .C(~c2), .S(s2), .S1(s2_1));
WddlNANDbar_4 wn3(.A(a[1]), .B(b[1]), .C(c2), .S(s3), .S1(s3_1));
WddlNANDbar_4 wn4(.A(~a[1]), .B(~b[1]), .C(c2), .S(s4), .S1(s4_1));

assign cout = ~(s1 & s2 & s3 & s4);
assign cout_bar = ~cout;
assign y[2] = cout_bar;

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


module adder_tree_bar_4 (
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

    wire [1:0] stage0_0_lo_bar_4;
    wire [1:0] stage0_1_lo_bar_4;
    wire [1:0] stage0_2_lo_bar_4;
    wire [1:0] stage0_3_lo_bar_4;
    wire [1:0] stage0_4_lo_bar_4;
    wire [1:0] stage0_5_lo_bar_4;
    wire [1:0] stage0_6_lo_bar_4;
    wire [1:0] stage0_7_lo_bar_4;
    wire [2:0] stage1_0_lo_bar_4;
    wire [2:0] stage1_1_lo_bar_4;
    wire [2:0] stage1_2_lo_bar_4;
    wire [2:0] stage1_3_lo_bar_4;
    wire [3:0] stage2_0_lo_bar_4;
    wire [3:0] stage2_1_lo_bar_4;
    wire [4:0] stage3_0_lo_bar_4;
    reg  [1:0] stage0_0_bar_4;
    reg  [1:0] stage0_1_bar_4;
    reg  [1:0] stage0_2_bar_4;
    reg  [1:0] stage0_3_bar_4;
    reg  [1:0] stage0_4_bar_4;
    reg  [1:0] stage0_5_bar_4;
    reg  [1:0] stage0_6_bar_4;
    reg  [1:0] stage0_7_bar_4;
    reg  [2:0] stage1_0_bar_4;
    reg  [2:0] stage1_1_bar_4;
    reg  [2:0] stage1_2_bar_4;
    reg  [2:0] stage1_3_bar_4;
    reg  [3:0] stage2_0_bar_4;
    reg  [3:0] stage2_1_bar_4;
    reg  [4:0] stage3_0_bar_4;

    add1bitbar_4 u0_0_bar (.a(in0), .b(in1), .cin(1'b0), .y(stage0_0_lo_bar_4), .cout(), .cout_bar());
    add1bitbar_4 u0_1_bar (.a(in2), .b(in3), .cin(1'b0), .y(stage0_1_lo_bar_4), .cout(), .cout_bar());
    add1bitbar_4 u0_2_bar (.a(in4), .b(in5), .cin(1'b0), .y(stage0_2_lo_bar_4), .cout(), .cout_bar());
    add1bitbar_4 u0_3_bar (.a(in6), .b(in7), .cin(1'b0), .y(stage0_3_lo_bar_4), .cout(), .cout_bar());
    add1bitbar_4 u0_4_bar (.a(in8), .b(in9), .cin(1'b0), .y(stage0_4_lo_bar_4), .cout(), .cout_bar());
    add1bitbar_4 u0_5_bar (.a(in10), .b(in11), .cin(1'b0), .y(stage0_5_lo_bar_4), .cout(), .cout_bar());
    add1bitbar_4 u0_6_bar (.a(in12), .b(in13), .cin(1'b0), .y(stage0_6_lo_bar_4), .cout(), .cout_bar());
    add1bitbar_4 u0_7_bar (.a(in14), .b(in15), .cin(1'b0), .y(stage0_7_lo_bar_4), .cout(), .cout_bar());
    add2bitbar_4 u1_0_bar (.a(stage0_0_bar_4), .b(stage0_1_bar_4), .cin(1'b0), .y(stage1_0_lo_bar_4), .cout(), .cout_bar());
    add2bitbar_4 u1_1_bar (.a(stage0_2_bar_4), .b(stage0_3_bar_4), .cin(1'b0), .y(stage1_1_lo_bar_4), .cout(), .cout_bar());
    add2bitbar_4 u1_2_bar (.a(stage0_4_bar_4), .b(stage0_5_bar_4), .cin(1'b0), .y(stage1_2_lo_bar_4), .cout(), .cout_bar());
    add2bitbar_4 u1_3_bar (.a(stage0_6_bar_4), .b(stage0_7_bar_4), .cin(1'b0), .y(stage1_3_lo_bar_4), .cout(), .cout_bar());
    add3bitbar_4 u2_0_bar (.a(stage1_0_bar_4), .b(stage1_1_bar_4), .cin(1'b0), .y(stage2_0_lo_bar_4), .cout(), .cout_bar());
    add3bitbar_4 u2_1_bar (.a(stage1_2_bar_4), .b(stage1_3_bar_4), .cin(1'b0), .y(stage2_1_lo_bar_4), .cout(), .cout_bar());
    add4bitbar_4 u3_0_bar (.a(stage2_0_bar_4), .b(stage2_1_bar_4), .cin(1'b0), .y(stage3_0_lo_bar_4), .cout(), .cout_bar());

    assign sum =  stage3_0_lo_bar_4;

    always @(posedge clk) begin
        stage0_0_bar_4 <=  stage0_0_lo_bar_4;
        stage0_1_bar_4 <=  stage0_1_lo_bar_4;
        stage0_2_bar_4 <=  stage0_2_lo_bar_4;
        stage0_3_bar_4 <=  stage0_3_lo_bar_4;
        stage0_4_bar_4 <=  stage0_4_lo_bar_4;
        stage0_5_bar_4 <=  stage0_5_lo_bar_4;
        stage0_6_bar_4 <=  stage0_6_lo_bar_4;
        stage0_7_bar_4 <=  stage0_7_lo_bar_4;
        stage1_0_bar_4 <=  stage1_0_lo_bar_4;
        stage1_1_bar_4 <=  stage1_1_lo_bar_4;
        stage1_2_bar_4 <=  stage1_2_lo_bar_4;
        stage1_3_bar_4 <=  stage1_3_lo_bar_4;
        stage2_0_bar_4 <=  stage2_0_lo_bar_4;
        stage2_1_bar_4 <=  stage2_1_lo_bar_4;
        stage3_0_bar_4 <=  stage3_0_lo_bar_4;
    end
endmodule


module layer4(
    input clk,
    input [0:0] inputs0_4 , inputs1_4 , inputs2_4 , inputs3_4 , inputs4_4 , inputs5_4 , inputs6_4 , inputs7_4 , inputs8_4 , inputs9_4 , inputs10_4 , inputs11_4 , inputs12_4 , inputs13_4 , inputs14_4 , inputs15_4,
    input [15:0] w1_0_4, w1_1_4, w2_0_4, w2_1_4, w3_0_4, w3_1_4, w4_0_4, w4_1_4,
    input [4:0] b1_4, b2_4, b3_4, b4_4,
    output [5:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar, biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar, biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar, biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar
);
    wire [0:0] weighted_inputs1_0_0, weighted_inputs1_0_1;
    wire [0:0] weighted_inputs1_1_0, weighted_inputs1_1_1;
    wire [0:0] weighted_inputs1_2_0, weighted_inputs1_2_1;
    wire [0:0] weighted_inputs1_3_0, weighted_inputs1_3_1;
    wire [0:0] weighted_inputs1_4_0, weighted_inputs1_4_1;
    wire [0:0] weighted_inputs1_5_0, weighted_inputs1_5_1;
    wire [0:0] weighted_inputs1_6_0, weighted_inputs1_6_1;
    wire [0:0] weighted_inputs1_7_0, weighted_inputs1_7_1;
    wire [0:0] weighted_inputs1_8_0, weighted_inputs1_8_1;
    wire [0:0] weighted_inputs1_9_0, weighted_inputs1_9_1;
    wire [0:0] weighted_inputs1_10_0, weighted_inputs1_10_1;
    wire [0:0] weighted_inputs1_11_0, weighted_inputs1_11_1;
    wire [0:0] weighted_inputs1_12_0, weighted_inputs1_12_1;
    wire [0:0] weighted_inputs1_13_0, weighted_inputs1_13_1;
    wire [0:0] weighted_inputs1_14_0, weighted_inputs1_14_1;
    wire [0:0] weighted_inputs1_15_0, weighted_inputs1_15_1;
    wire [0:0] weighted_inputs2_0_0, weighted_inputs2_0_1;
    wire [0:0] weighted_inputs2_1_0, weighted_inputs2_1_1;
    wire [0:0] weighted_inputs2_2_0, weighted_inputs2_2_1;
    wire [0:0] weighted_inputs2_3_0, weighted_inputs2_3_1;
    wire [0:0] weighted_inputs2_4_0, weighted_inputs2_4_1;
    wire [0:0] weighted_inputs2_5_0, weighted_inputs2_5_1;
    wire [0:0] weighted_inputs2_6_0, weighted_inputs2_6_1;
    wire [0:0] weighted_inputs2_7_0, weighted_inputs2_7_1;
    wire [0:0] weighted_inputs2_8_0, weighted_inputs2_8_1;
    wire [0:0] weighted_inputs2_9_0, weighted_inputs2_9_1;
    wire [0:0] weighted_inputs2_10_0, weighted_inputs2_10_1;
    wire [0:0] weighted_inputs2_11_0, weighted_inputs2_11_1;
    wire [0:0] weighted_inputs2_12_0, weighted_inputs2_12_1;
    wire [0:0] weighted_inputs2_13_0, weighted_inputs2_13_1;
    wire [0:0] weighted_inputs2_14_0, weighted_inputs2_14_1;
    wire [0:0] weighted_inputs2_15_0, weighted_inputs2_15_1;
    wire [0:0] weighted_inputs3_0_0, weighted_inputs3_0_1;
    wire [0:0] weighted_inputs3_1_0, weighted_inputs3_1_1;
    wire [0:0] weighted_inputs3_2_0, weighted_inputs3_2_1;
    wire [0:0] weighted_inputs3_3_0, weighted_inputs3_3_1;
    wire [0:0] weighted_inputs3_4_0, weighted_inputs3_4_1;
    wire [0:0] weighted_inputs3_5_0, weighted_inputs3_5_1;
    wire [0:0] weighted_inputs3_6_0, weighted_inputs3_6_1;
    wire [0:0] weighted_inputs3_7_0, weighted_inputs3_7_1;
    wire [0:0] weighted_inputs3_8_0, weighted_inputs3_8_1;
    wire [0:0] weighted_inputs3_9_0, weighted_inputs3_9_1;
    wire [0:0] weighted_inputs3_10_0, weighted_inputs3_10_1;
    wire [0:0] weighted_inputs3_11_0, weighted_inputs3_11_1;
    wire [0:0] weighted_inputs3_12_0, weighted_inputs3_12_1;
    wire [0:0] weighted_inputs3_13_0, weighted_inputs3_13_1;
    wire [0:0] weighted_inputs3_14_0, weighted_inputs3_14_1;
    wire [0:0] weighted_inputs3_15_0, weighted_inputs3_15_1;
    wire [0:0] weighted_inputs4_0_0, weighted_inputs4_0_1;
    wire [0:0] weighted_inputs4_1_0, weighted_inputs4_1_1;
    wire [0:0] weighted_inputs4_2_0, weighted_inputs4_2_1;
    wire [0:0] weighted_inputs4_3_0, weighted_inputs4_3_1;
    wire [0:0] weighted_inputs4_4_0, weighted_inputs4_4_1;
    wire [0:0] weighted_inputs4_5_0, weighted_inputs4_5_1;
    wire [0:0] weighted_inputs4_6_0, weighted_inputs4_6_1;
    wire [0:0] weighted_inputs4_7_0, weighted_inputs4_7_1;
    wire [0:0] weighted_inputs4_8_0, weighted_inputs4_8_1;
    wire [0:0] weighted_inputs4_9_0, weighted_inputs4_9_1;
    wire [0:0] weighted_inputs4_10_0, weighted_inputs4_10_1;
    wire [0:0] weighted_inputs4_11_0, weighted_inputs4_11_1;
    wire [0:0] weighted_inputs4_12_0, weighted_inputs4_12_1;
    wire [0:0] weighted_inputs4_13_0, weighted_inputs4_13_1;
    wire [0:0] weighted_inputs4_14_0, weighted_inputs4_14_1;
    wire [0:0] weighted_inputs4_15_0, weighted_inputs4_15_1;

    wire [4:0] sum1 [3:0];
    wire [4:0] sum2 [3:0];
    wire [5:0] biased_sum1 [3:0];
    wire [5:0] biased_sum2 [3:0];
    wire [4:0] sum1bar [3:0];
    wire [4:0] sum2bar [3:0];
    wire [5:0] biased_sum1bar [3:0];
    wire [5:0] biased_sum2bar [3:0];
    weighted_inputs_2 w0 (.inputs(inputs0_4), .w(w1_0_4[0]), .wi(weighted_inputs1_0_0));
    weighted_inputs_2 w0_bar (.inputs(inputs0_4), .w(w1_1_4[0]), .wi(weighted_inputs1_0_1));
    weighted_inputs_2 w1 (.inputs(inputs1_4), .w(w1_0_4[1]), .wi(weighted_inputs1_1_0));
    weighted_inputs_2 w1_bar (.inputs(inputs1_4), .w(w1_1_4[1]), .wi(weighted_inputs1_1_1));
    weighted_inputs_2 w2 (.inputs(inputs2_4), .w(w1_0_4[2]), .wi(weighted_inputs1_2_0));
    weighted_inputs_2 w2_bar (.inputs(inputs2_4), .w(w1_1_4[2]), .wi(weighted_inputs1_2_1));
    weighted_inputs_2 w3 (.inputs(inputs3_4), .w(w1_0_4[3]), .wi(weighted_inputs1_3_0));
    weighted_inputs_2 w3_bar (.inputs(inputs3_4), .w(w1_1_4[3]), .wi(weighted_inputs1_3_1));
    weighted_inputs_2 w4 (.inputs(inputs4_4), .w(w1_0_4[4]), .wi(weighted_inputs1_4_0));
    weighted_inputs_2 w4_bar (.inputs(inputs4_4), .w(w1_1_4[4]), .wi(weighted_inputs1_4_1));
    weighted_inputs_2 w5 (.inputs(inputs5_4), .w(w1_0_4[5]), .wi(weighted_inputs1_5_0));
    weighted_inputs_2 w5_bar (.inputs(inputs5_4), .w(w1_1_4[5]), .wi(weighted_inputs1_5_1));
    weighted_inputs_2 w6 (.inputs(inputs6_4), .w(w1_0_4[6]), .wi(weighted_inputs1_6_0));
    weighted_inputs_2 w6_bar (.inputs(inputs6_4), .w(w1_1_4[6]), .wi(weighted_inputs1_6_1));
    weighted_inputs_2 w7 (.inputs(inputs7_4), .w(w1_0_4[7]), .wi(weighted_inputs1_7_0));
    weighted_inputs_2 w7_bar (.inputs(inputs7_4), .w(w1_1_4[7]), .wi(weighted_inputs1_7_1));
    weighted_inputs_2 w8 (.inputs(inputs8_4), .w(w1_0_4[8]), .wi(weighted_inputs1_8_0));
    weighted_inputs_2 w8_bar (.inputs(inputs8_4), .w(w1_1_4[8]), .wi(weighted_inputs1_8_1));
    weighted_inputs_2 w9 (.inputs(inputs9_4), .w(w1_0_4[9]), .wi(weighted_inputs1_9_0));
    weighted_inputs_2 w9_bar (.inputs(inputs9_4), .w(w1_1_4[9]), .wi(weighted_inputs1_9_1));
    weighted_inputs_2 w10 (.inputs(inputs10_4), .w(w1_0_4[10]), .wi(weighted_inputs1_10_0));
    weighted_inputs_2 w10_bar (.inputs(inputs10_4), .w(w1_1_4[10]), .wi(weighted_inputs1_10_1));
    weighted_inputs_2 w11 (.inputs(inputs11_4), .w(w1_0_4[11]), .wi(weighted_inputs1_11_0));
    weighted_inputs_2 w11_bar (.inputs(inputs11_4), .w(w1_1_4[11]), .wi(weighted_inputs1_11_1));
    weighted_inputs_2 w12 (.inputs(inputs12_4), .w(w1_0_4[12]), .wi(weighted_inputs1_12_0));
    weighted_inputs_2 w12_bar (.inputs(inputs12_4), .w(w1_1_4[12]), .wi(weighted_inputs1_12_1));
    weighted_inputs_2 w13 (.inputs(inputs13_4), .w(w1_0_4[13]), .wi(weighted_inputs1_13_0));
    weighted_inputs_2 w13_bar (.inputs(inputs13_4), .w(w1_1_4[13]), .wi(weighted_inputs1_13_1));
    weighted_inputs_2 w14 (.inputs(inputs14_4), .w(w1_0_4[14]), .wi(weighted_inputs1_14_0));
    weighted_inputs_2 w14_bar (.inputs(inputs14_4), .w(w1_1_4[14]), .wi(weighted_inputs1_14_1));
    weighted_inputs_2 w15 (.inputs(inputs15_4), .w(w1_0_4[15]), .wi(weighted_inputs1_15_0));
    weighted_inputs_2 w15_bar (.inputs(inputs15_4), .w(w1_1_4[15]), .wi(weighted_inputs1_15_1));
    weighted_inputs_2 w16 (.inputs(inputs0_4), .w(w2_0_4[0]), .wi(weighted_inputs2_0_0));
    weighted_inputs_2 w16_bar (.inputs(inputs0_4), .w(w2_1_4[0]), .wi(weighted_inputs2_0_1));
    weighted_inputs_2 w17 (.inputs(inputs1_4), .w(w2_0_4[1]), .wi(weighted_inputs2_1_0));
    weighted_inputs_2 w17_bar (.inputs(inputs1_4), .w(w2_1_4[1]), .wi(weighted_inputs2_1_1));
    weighted_inputs_2 w18 (.inputs(inputs2_4), .w(w2_0_4[2]), .wi(weighted_inputs2_2_0));
    weighted_inputs_2 w18_bar (.inputs(inputs2_4), .w(w2_1_4[2]), .wi(weighted_inputs2_2_1));
    weighted_inputs_2 w19 (.inputs(inputs3_4), .w(w2_0_4[3]), .wi(weighted_inputs2_3_0));
    weighted_inputs_2 w19_bar (.inputs(inputs3_4), .w(w2_1_4[3]), .wi(weighted_inputs2_3_1));
    weighted_inputs_2 w20 (.inputs(inputs4_4), .w(w2_0_4[4]), .wi(weighted_inputs2_4_0));
    weighted_inputs_2 w20_bar (.inputs(inputs4_4), .w(w2_1_4[4]), .wi(weighted_inputs2_4_1));
    weighted_inputs_2 w21 (.inputs(inputs5_4), .w(w2_0_4[5]), .wi(weighted_inputs2_5_0));
    weighted_inputs_2 w21_bar (.inputs(inputs5_4), .w(w2_1_4[5]), .wi(weighted_inputs2_5_1));
    weighted_inputs_2 w22 (.inputs(inputs6_4), .w(w2_0_4[6]), .wi(weighted_inputs2_6_0));
    weighted_inputs_2 w22_bar (.inputs(inputs6_4), .w(w2_1_4[6]), .wi(weighted_inputs2_6_1));
    weighted_inputs_2 w23 (.inputs(inputs7_4), .w(w2_0_4[7]), .wi(weighted_inputs2_7_0));
    weighted_inputs_2 w23_bar (.inputs(inputs7_4), .w(w2_1_4[7]), .wi(weighted_inputs2_7_1));
    weighted_inputs_2 w24 (.inputs(inputs8_4), .w(w2_0_4[8]), .wi(weighted_inputs2_8_0));
    weighted_inputs_2 w24_bar (.inputs(inputs8_4), .w(w2_1_4[8]), .wi(weighted_inputs2_8_1));
    weighted_inputs_2 w25 (.inputs(inputs9_4), .w(w2_0_4[9]), .wi(weighted_inputs2_9_0));
    weighted_inputs_2 w25_bar (.inputs(inputs9_4), .w(w2_1_4[9]), .wi(weighted_inputs2_9_1));
    weighted_inputs_2 w26 (.inputs(inputs10_4), .w(w2_0_4[10]), .wi(weighted_inputs2_10_0));
    weighted_inputs_2 w26_bar (.inputs(inputs10_4), .w(w2_1_4[10]), .wi(weighted_inputs2_10_1));
    weighted_inputs_2 w27 (.inputs(inputs11_4), .w(w2_0_4[11]), .wi(weighted_inputs2_11_0));
    weighted_inputs_2 w27_bar (.inputs(inputs11_4), .w(w2_1_4[11]), .wi(weighted_inputs2_11_1));
    weighted_inputs_2 w28 (.inputs(inputs12_4), .w(w2_0_4[12]), .wi(weighted_inputs2_12_0));
    weighted_inputs_2 w28_bar (.inputs(inputs12_4), .w(w2_1_4[12]), .wi(weighted_inputs2_12_1));
    weighted_inputs_2 w29 (.inputs(inputs13_4), .w(w2_0_4[13]), .wi(weighted_inputs2_13_0));
    weighted_inputs_2 w29_bar (.inputs(inputs13_4), .w(w2_1_4[13]), .wi(weighted_inputs2_13_1));
    weighted_inputs_2 w30 (.inputs(inputs14_4), .w(w2_0_4[14]), .wi(weighted_inputs2_14_0));
    weighted_inputs_2 w30_bar (.inputs(inputs14_4), .w(w2_1_4[14]), .wi(weighted_inputs2_14_1));
    weighted_inputs_2 w31 (.inputs(inputs15_4), .w(w2_0_4[15]), .wi(weighted_inputs2_15_0));
    weighted_inputs_2 w31_bar (.inputs(inputs15_4), .w(w2_1_4[15]), .wi(weighted_inputs2_15_1));
    weighted_inputs_2 w32 (.inputs(inputs0_4), .w(w3_0_4[0]), .wi(weighted_inputs3_0_0));
    weighted_inputs_2 w32_bar (.inputs(inputs0_4), .w(w3_1_4[0]), .wi(weighted_inputs3_0_1));
    weighted_inputs_2 w33 (.inputs(inputs1_4), .w(w3_0_4[1]), .wi(weighted_inputs3_1_0));
    weighted_inputs_2 w33_bar (.inputs(inputs1_4), .w(w3_1_4[1]), .wi(weighted_inputs3_1_1));
    weighted_inputs_2 w34 (.inputs(inputs2_4), .w(w3_0_4[2]), .wi(weighted_inputs3_2_0));
    weighted_inputs_2 w34_bar (.inputs(inputs2_4), .w(w3_1_4[2]), .wi(weighted_inputs3_2_1));
    weighted_inputs_2 w35 (.inputs(inputs3_4), .w(w3_0_4[3]), .wi(weighted_inputs3_3_0));
    weighted_inputs_2 w35_bar (.inputs(inputs3_4), .w(w3_1_4[3]), .wi(weighted_inputs3_3_1));
    weighted_inputs_2 w36 (.inputs(inputs4_4), .w(w3_0_4[4]), .wi(weighted_inputs3_4_0));
    weighted_inputs_2 w36_bar (.inputs(inputs4_4), .w(w3_1_4[4]), .wi(weighted_inputs3_4_1));
    weighted_inputs_2 w37 (.inputs(inputs5_4), .w(w3_0_4[5]), .wi(weighted_inputs3_5_0));
    weighted_inputs_2 w37_bar (.inputs(inputs5_4), .w(w3_1_4[5]), .wi(weighted_inputs3_5_1));
    weighted_inputs_2 w38 (.inputs(inputs6_4), .w(w3_0_4[6]), .wi(weighted_inputs3_6_0));
    weighted_inputs_2 w38_bar (.inputs(inputs6_4), .w(w3_1_4[6]), .wi(weighted_inputs3_6_1));
    weighted_inputs_2 w39 (.inputs(inputs7_4), .w(w3_0_4[7]), .wi(weighted_inputs3_7_0));
    weighted_inputs_2 w39_bar (.inputs(inputs7_4), .w(w3_1_4[7]), .wi(weighted_inputs3_7_1));
    weighted_inputs_2 w40 (.inputs(inputs8_4), .w(w3_0_4[8]), .wi(weighted_inputs3_8_0));
    weighted_inputs_2 w40_bar (.inputs(inputs8_4), .w(w3_1_4[8]), .wi(weighted_inputs3_8_1));
    weighted_inputs_2 w41 (.inputs(inputs9_4), .w(w3_0_4[9]), .wi(weighted_inputs3_9_0));
    weighted_inputs_2 w41_bar (.inputs(inputs9_4), .w(w3_1_4[9]), .wi(weighted_inputs3_9_1));
    weighted_inputs_2 w42 (.inputs(inputs10_4), .w(w3_0_4[10]), .wi(weighted_inputs3_10_0));
    weighted_inputs_2 w42_bar (.inputs(inputs10_4), .w(w3_1_4[10]), .wi(weighted_inputs3_10_1));
    weighted_inputs_2 w43 (.inputs(inputs11_4), .w(w3_0_4[11]), .wi(weighted_inputs3_11_0));
    weighted_inputs_2 w43_bar (.inputs(inputs11_4), .w(w3_1_4[11]), .wi(weighted_inputs3_11_1));
    weighted_inputs_2 w44 (.inputs(inputs12_4), .w(w3_0_4[12]), .wi(weighted_inputs3_12_0));
    weighted_inputs_2 w44_bar (.inputs(inputs12_4), .w(w3_1_4[12]), .wi(weighted_inputs3_12_1));
    weighted_inputs_2 w45 (.inputs(inputs13_4), .w(w3_0_4[13]), .wi(weighted_inputs3_13_0));
    weighted_inputs_2 w45_bar (.inputs(inputs13_4), .w(w3_1_4[13]), .wi(weighted_inputs3_13_1));
    weighted_inputs_2 w46 (.inputs(inputs14_4), .w(w3_0_4[14]), .wi(weighted_inputs3_14_0));
    weighted_inputs_2 w46_bar (.inputs(inputs14_4), .w(w3_1_4[14]), .wi(weighted_inputs3_14_1));
    weighted_inputs_2 w47 (.inputs(inputs15_4), .w(w3_0_4[15]), .wi(weighted_inputs3_15_0));
    weighted_inputs_2 w47_bar (.inputs(inputs15_4), .w(w3_1_4[15]), .wi(weighted_inputs3_15_1));
    weighted_inputs_2 w48 (.inputs(inputs0_4), .w(w4_0_4[0]), .wi(weighted_inputs4_0_0));
    weighted_inputs_2 w48_bar (.inputs(inputs0_4), .w(w4_1_4[0]), .wi(weighted_inputs4_0_1));
    weighted_inputs_2 w49 (.inputs(inputs1_4), .w(w4_0_4[1]), .wi(weighted_inputs4_1_0));
    weighted_inputs_2 w49_bar (.inputs(inputs1_4), .w(w4_1_4[1]), .wi(weighted_inputs4_1_1));
    weighted_inputs_2 w50 (.inputs(inputs2_4), .w(w4_0_4[2]), .wi(weighted_inputs4_2_0));
    weighted_inputs_2 w50_bar (.inputs(inputs2_4), .w(w4_1_4[2]), .wi(weighted_inputs4_2_1));
    weighted_inputs_2 w51 (.inputs(inputs3_4), .w(w4_0_4[3]), .wi(weighted_inputs4_3_0));
    weighted_inputs_2 w51_bar (.inputs(inputs3_4), .w(w4_1_4[3]), .wi(weighted_inputs4_3_1));
    weighted_inputs_2 w52 (.inputs(inputs4_4), .w(w4_0_4[4]), .wi(weighted_inputs4_4_0));
    weighted_inputs_2 w52_bar (.inputs(inputs4_4), .w(w4_1_4[4]), .wi(weighted_inputs4_4_1));
    weighted_inputs_2 w53 (.inputs(inputs5_4), .w(w4_0_4[5]), .wi(weighted_inputs4_5_0));
    weighted_inputs_2 w53_bar (.inputs(inputs5_4), .w(w4_1_4[5]), .wi(weighted_inputs4_5_1));
    weighted_inputs_2 w54 (.inputs(inputs6_4), .w(w4_0_4[6]), .wi(weighted_inputs4_6_0));
    weighted_inputs_2 w54_bar (.inputs(inputs6_4), .w(w4_1_4[6]), .wi(weighted_inputs4_6_1));
    weighted_inputs_2 w55 (.inputs(inputs7_4), .w(w4_0_4[7]), .wi(weighted_inputs4_7_0));
    weighted_inputs_2 w55_bar (.inputs(inputs7_4), .w(w4_1_4[7]), .wi(weighted_inputs4_7_1));
    weighted_inputs_2 w56 (.inputs(inputs8_4), .w(w4_0_4[8]), .wi(weighted_inputs4_8_0));
    weighted_inputs_2 w56_bar (.inputs(inputs8_4), .w(w4_1_4[8]), .wi(weighted_inputs4_8_1));
    weighted_inputs_2 w57 (.inputs(inputs9_4), .w(w4_0_4[9]), .wi(weighted_inputs4_9_0));
    weighted_inputs_2 w57_bar (.inputs(inputs9_4), .w(w4_1_4[9]), .wi(weighted_inputs4_9_1));
    weighted_inputs_2 w58 (.inputs(inputs10_4), .w(w4_0_4[10]), .wi(weighted_inputs4_10_0));
    weighted_inputs_2 w58_bar (.inputs(inputs10_4), .w(w4_1_4[10]), .wi(weighted_inputs4_10_1));
    weighted_inputs_2 w59 (.inputs(inputs11_4), .w(w4_0_4[11]), .wi(weighted_inputs4_11_0));
    weighted_inputs_2 w59_bar (.inputs(inputs11_4), .w(w4_1_4[11]), .wi(weighted_inputs4_11_1));
    weighted_inputs_2 w60 (.inputs(inputs12_4), .w(w4_0_4[12]), .wi(weighted_inputs4_12_0));
    weighted_inputs_2 w60_bar (.inputs(inputs12_4), .w(w4_1_4[12]), .wi(weighted_inputs4_12_1));
    weighted_inputs_2 w61 (.inputs(inputs13_4), .w(w4_0_4[13]), .wi(weighted_inputs4_13_0));
    weighted_inputs_2 w61_bar (.inputs(inputs13_4), .w(w4_1_4[13]), .wi(weighted_inputs4_13_1));
    weighted_inputs_2 w62 (.inputs(inputs14_4), .w(w4_0_4[14]), .wi(weighted_inputs4_14_0));
    weighted_inputs_2 w62_bar (.inputs(inputs14_4), .w(w4_1_4[14]), .wi(weighted_inputs4_14_1));
    weighted_inputs_2 w63 (.inputs(inputs15_4), .w(w4_0_4[15]), .wi(weighted_inputs4_15_0));
    weighted_inputs_2 w63_bar (.inputs(inputs15_4), .w(w4_1_4[15]), .wi(weighted_inputs4_15_1));
    adder_tree_4 add0(
    .clk(clk), 
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
    adder_tree_4 add4(
    .clk(clk), 
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
    adder_tree_bar_4 addb0(
    .clk(clk), 
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
    adder_tree_bar_4 addb4(
    .clk(clk), 
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
    adder_tree_4 add1(
    .clk(clk), 
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
    adder_tree_4 add5(
    .clk(clk), 
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
    adder_tree_bar_4 addb1(
    .clk(clk), 
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
    adder_tree_bar_4 addb5(
    .clk(clk), 
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
    adder_tree_4 add2(
    .clk(clk), 
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
    adder_tree_4 add6(
    .clk(clk), 
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
    adder_tree_bar_4 addb2(
    .clk(clk), 
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
    adder_tree_bar_4 addb6(
    .clk(clk), 
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
    adder_tree_4 add3(
    .clk(clk), 
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
    adder_tree_4 add7(
    .clk(clk), 
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
    adder_tree_bar_4 addb3(
    .clk(clk), 
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
    adder_tree_bar_4 addb7(
    .clk(clk), 
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
    add5bit_4 u0 (.a(sum1[0]), .b(b1_4), .cin(1'b0), .y(biased_sum1[0]));
    add5bit_4 u4 (.a(sum2[0]), .b(b1_4), .cin(1'b0), .y(biased_sum2[0]));
    add5bitbar_4 ub0 (.a(sum1bar[0]), .b(b1_4), .cin(1'b0), .y(biased_sum1bar[0]));
    add5bitbar_4 ub4 (.a(sum2bar[0]), .b(b1_4), .cin(1'b0), .y(biased_sum2bar[0]));
    add5bit_4 u1 (.a(sum1[1]), .b(b2_4), .cin(1'b0), .y(biased_sum1[1]));
    add5bit_4 u5 (.a(sum2[1]), .b(b2_4), .cin(1'b0), .y(biased_sum2[1]));
    add5bitbar_4 ub1 (.a(sum1bar[1]), .b(b2_4), .cin(1'b0), .y(biased_sum1bar[1]));
    add5bitbar_4 ub5 (.a(sum2bar[1]), .b(b2_4), .cin(1'b0), .y(biased_sum2bar[1]));
    add5bit_4 u2 (.a(sum1[2]), .b(b3_4), .cin(1'b0), .y(biased_sum1[2]));
    add5bit_4 u6 (.a(sum2[2]), .b(b3_4), .cin(1'b0), .y(biased_sum2[2]));
    add5bitbar_4 ub2 (.a(sum1bar[2]), .b(b3_4), .cin(1'b0), .y(biased_sum1bar[2]));
    add5bitbar_4 ub6 (.a(sum2bar[2]), .b(b3_4), .cin(1'b0), .y(biased_sum2bar[2]));
    add5bit_4 u3 (.a(sum1[3]), .b(b4_4), .cin(1'b0), .y(biased_sum1[3]));
    add5bit_4 u7 (.a(sum2[3]), .b(b4_4), .cin(1'b0), .y(biased_sum2[3]));
    add5bitbar_4 ub3 (.a(sum1bar[3]), .b(b4_4), .cin(1'b0), .y(biased_sum1bar[3]));
    add5bitbar_4 ub7 (.a(sum2bar[3]), .b(b4_4), .cin(1'b0), .y(biased_sum2bar[3]));
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
        $display("----- BNN LAYER 4 OUTPUTS -----");
        $display("Inputs : %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b %b", inputs0_4, inputs1_4, inputs2_4, inputs3_4, inputs4_4, inputs5_4, inputs6_4, inputs7_4, inputs8_4, inputs9_4, inputs10_4, inputs11_4, inputs12_4, inputs13_4, inputs14_4, inputs15_4);
        $display("Weights0: %b %b %b %b", w1_0_4, w2_0_4, w3_0_4, w4_0_4);
        $display("Weights1: %b %b %b %b", w1_1_4, w2_1_4, w3_1_4, w4_1_4);
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
    input  wire [15:0] w1_0_4, w1_1_4,
    input  wire [15:0] w2_0_4, w2_1_4,
    input  wire [15:0] w3_0_4, w3_1_4,
    input  wire [15:0] w4_0_4, w4_1_4,
    input  wire [4:0] b1_4,
    input  wire [4:0] b2_4,
    input  wire [4:0] b3_4,
    input  wire [4:0] b4_4,
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
    input  wire r0_1,
    input  wire r0_1bar,
    input  wire r1_1,
    input  wire r1_1bar,
    input  wire r2_1,
    input  wire r2_1bar,
    input  wire r3_1,
    input  wire r3_1bar,
    input  wire r4_1,
    input  wire r4_1bar,
    input  wire r5_1,
    input  wire r5_1bar,
    input  wire r6_1,
    input  wire r6_1bar,
    input  wire r0_2,
    input  wire r0_2bar,
    input  wire r1_2,
    input  wire r1_2bar,
    input  wire r2_2,
    input  wire r2_2bar,
    input  wire r3_2,
    input  wire r3_2bar,
    input  wire r4_2,
    input  wire r4_2bar,
    input  wire r5_2,
    input  wire r5_2bar,
    input  wire r6_2,
    input  wire r6_2bar,
    output reg  a0, a0_bar,
    output reg  a1, a1_bar,
    output reg  a2, a2_bar,
    output reg  a3, a3_bar
);

    wire [5:0] biased_sum0_0, biased_sum0_1, biased_sum0_0bar, biased_sum0_1bar;
    wire [5:0] biased_sum1_0, biased_sum1_1, biased_sum1_0bar, biased_sum1_1bar;
    wire [5:0] biased_sum2_0, biased_sum2_1, biased_sum2_0bar, biased_sum2_1bar;
    wire [5:0] biased_sum3_0, biased_sum3_1, biased_sum3_0bar, biased_sum3_1bar;

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
        .w1_0_4(w1_0_4), .w1_1_4(w1_1_4),
        .w2_0_4(w2_0_4), .w2_1_4(w2_1_4),
        .w3_0_4(w3_0_4), .w3_1_4(w3_1_4),
        .w4_0_4(w4_0_4), .w4_1_4(w4_1_4),
        .b1_4(b1_4),
        .b2_4(b2_4),
        .b3_4(b3_4),
        .b4_4(b4_4),
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

    wire [6:0] temp0_0, temp0_1, temp0_0bar, temp0_1bar;
    subtractor s0a (.A(biased_sum0_0), .B(biased_sum1_0), .Result(temp0_0));
    subtractor s0b (.A(biased_sum0_1), .B(biased_sum1_1), .Result(temp0_1));
    subtractor s0abar (.A(biased_sum0_0bar), .B(biased_sum1_0bar), .Result(temp0_0bar));
    subtractor s0bbar (.A(biased_sum0_1bar), .B(biased_sum1_1bar), .Result(temp0_1bar));
    wire comp0, comp0_bar;
    comparator_1 c0 (
        .inputs0_0(temp0_0), .inputs0_1(temp0_1),
        .r0_0(r0_0), .r1_0(r1_0), .r2_0(r2_0), .r3_0(r3_0), .r4_0(r4_0), .r5_0(r5_0), .r6_0(r6_0),
        .comparator(comp0)
    );
    comparator_1 c0_bar (
        .inputs0_0(temp0_0bar), .inputs0_1(temp0_1bar),
        .r0_0(r0_0bar), .r1_0(r1_0bar), .r2_0(r2_0bar), .r3_0(r3_0bar), .r4_0(r4_0bar), .r5_0(r5_0bar), .r6_0(r6_0bar),
        .comparator(comp0_bar)
    );
    reg [5:0] stage1_0_0, stage1_0_1, stage1_0_0bar, stage1_0_1bar;
    always @(*) begin
        if (comp0)      begin stage1_0_0 = biased_sum0_0;    stage1_0_1 = biased_sum0_1;    end
        else                    begin stage1_0_0 = biased_sum1_0;    stage1_0_1 = biased_sum1_1;    end
        if (comp0_bar)  begin stage1_0_0bar = biased_sum0_0bar; stage1_0_1bar = biased_sum0_1bar; end
        else                    begin stage1_0_0bar = biased_sum1_0bar; stage1_0_1bar = biased_sum1_1bar; end
    end

    wire [6:0] temp1_0, temp1_1, temp1_0bar, temp1_1bar;
    subtractor s1a (.A(biased_sum2_0), .B(biased_sum3_0), .Result(temp1_0));
    subtractor s1b (.A(biased_sum2_1), .B(biased_sum3_1), .Result(temp1_1));
    subtractor s1abar (.A(biased_sum2_0bar), .B(biased_sum3_0bar), .Result(temp1_0bar));
    subtractor s1bbar (.A(biased_sum2_1bar), .B(biased_sum3_1bar), .Result(temp1_1bar));
    wire comp1, comp1_bar;
    comparator_1 c1 (
        .inputs0_0(temp1_0), .inputs0_1(temp1_1),
        .r0_0(r0_1), .r1_0(r1_1), .r2_0(r2_1), .r3_0(r3_1), .r4_0(r4_1), .r5_0(r5_1), .r6_0(r6_1),
        .comparator(comp1)
    );
    comparator_1 c1_bar (
        .inputs0_0(temp1_0bar), .inputs0_1(temp1_1bar),
        .r0_0(r0_1bar), .r1_0(r1_1bar), .r2_0(r2_1bar), .r3_0(r3_1bar), .r4_0(r4_1bar), .r5_0(r5_1bar), .r6_0(r6_1bar),
        .comparator(comp1_bar)
    );
    reg [5:0] stage1_1_0, stage1_1_1, stage1_1_0bar, stage1_1_1bar;
    always @(*) begin
        if (comp1)      begin stage1_1_0 = biased_sum2_0;    stage1_1_1 = biased_sum2_1;    end
        else                    begin stage1_1_0 = biased_sum3_0;    stage1_1_1 = biased_sum3_1;    end
        if (comp1_bar)  begin stage1_1_0bar = biased_sum2_0bar; stage1_1_1bar = biased_sum2_1bar; end
        else                    begin stage1_1_0bar = biased_sum3_0bar; stage1_1_1bar = biased_sum3_1bar; end
    end

    wire [6:0] temp2_0, temp2_1, temp2_0bar, temp2_1bar;
    subtractor s2a (.A(stage1_0_0), .B(stage1_1_0), .Result(temp2_0));
    subtractor s2b (.A(stage1_0_1), .B(stage1_1_1), .Result(temp2_1));
    subtractor s2abar (.A(stage1_0_0bar), .B(stage1_1_0bar), .Result(temp2_0bar));
    subtractor s2bbar (.A(stage1_0_1bar), .B(stage1_1_1bar), .Result(temp2_1bar));
    wire comp2, comp2_bar;
    comparator_1 c2 (
        .inputs0_0(temp2_0), .inputs0_1(temp2_1),
        .r0_0(r0_2), .r1_0(r1_2), .r2_0(r2_2), .r3_0(r3_2), .r4_0(r4_2), .r5_0(r5_2), .r6_0(r6_2),
        .comparator(comp2)
    );
    comparator_1 c2_bar (
        .inputs0_0(temp2_0bar), .inputs0_1(temp2_1bar),
        .r0_0(r0_2bar), .r1_0(r1_2bar), .r2_0(r2_2bar), .r3_0(r3_2bar), .r4_0(r4_2bar), .r5_0(r5_2bar), .r6_0(r6_2bar),
        .comparator(comp2_bar)
    );
    reg [5:0] stage2_0_0, stage2_0_1, stage2_0_0bar, stage2_0_1bar;
    always @(*) begin
        if (comp2)      begin stage2_0_0 = stage1_0_0;    stage2_0_1 = stage1_0_1;    end
        else                    begin stage2_0_0 = stage1_1_0;    stage2_0_1 = stage1_1_1;    end
        if (comp2_bar)  begin stage2_0_0bar = stage1_0_0bar; stage2_0_1bar = stage1_0_1bar; end
        else                    begin stage2_0_0bar = stage1_1_0bar; stage2_0_1bar = stage1_1_1bar; end
    end

    always @(*) begin
        a0 = 0; a0_bar = 0;
        a1 = 0; a1_bar = 0;
        a2 = 0; a2_bar = 0;
        a3 = 0; a3_bar = 0;

        if (comp0 == 1 && comp2 == 1) a0     = 1;
        else if (comp0 == 0 && comp2 == 1) a1     = 1;
        else if (comp1 == 1 && comp2 == 0) a2     = 1;
        else             a3     = 1;

        if (comp0_bar == 1 && comp2_bar == 1) a0_bar     = 1;
        else if (comp0_bar == 0 && comp2_bar == 1) a1_bar     = 1;
        else if (comp1_bar == 1 && comp2_bar == 0) a2_bar     = 1;
        else             a3_bar     = 1;
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
    input  wire [15:0] w1_0_1, w1_1_1,
    input  wire [15:0] w2_0_1, w2_1_1,
    input  wire [15:0] w3_0_1, w3_1_1,
    input  wire [15:0] w4_0_1, w4_1_1,
    input  wire [15:0] w5_0_1, w5_1_1,
    input  wire [15:0] w6_0_1, w6_1_1,
    input  wire [15:0] w7_0_1, w7_1_1,
    input  wire [15:0] w8_0_1, w8_1_1,
    input  wire [11:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1,

    // Layer-2 weights & biases
    input  wire [15:0] w1_0_2, w1_1_2,
    input  wire [15:0] w2_0_2, w2_1_2,
    input  wire [15:0] w3_0_2, w3_1_2,
    input  wire [15:0] w4_0_2, w4_1_2,
    input  wire [15:0] w5_0_2, w5_1_2,
    input  wire [15:0] w6_0_2, w6_1_2,
    input  wire [15:0] w7_0_2, w7_1_2,
    input  wire [15:0] w8_0_2, w8_1_2,
    input  wire [4:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2,

    // Layer-3 weights & biases (output layer)
    input  wire [15:0] w1_0_3, w1_1_3,
    input  wire [15:0] w2_0_3, w2_1_3,
    input  wire [15:0] w3_0_3, w3_1_3,
    input  wire [15:0] w4_0_3, w4_1_3,
    input  wire [15:0] w5_0_3, w5_1_3,
    input  wire [15:0] w6_0_3, w6_1_3,
    input  wire [15:0] w7_0_3, w7_1_3,
    input  wire [15:0] w8_0_3, w8_1_3,
    input  wire [4:0] b1_3,
    input  wire [4:0] b2_3,
    input  wire [4:0] b3_3,
    input  wire [4:0] b4_3,
    input  wire [4:0] b5_3,
    input  wire [4:0] b6_3,
    input  wire [4:0] b7_3,
    input  wire [4:0] b8_3,

    // Layer-4 weights & biases (output layer)
    input  wire [15:0] w1_0_4, w1_1_4,
    input  wire [15:0] w2_0_4, w2_1_4,
    input  wire [15:0] w3_0_4, w3_1_4,
    input  wire [15:0] w4_0_4, w4_1_4,
    input  wire [4:0] b1_4,
    input  wire [4:0] b2_4,
    input  wire [4:0] b3_4,
    input  wire [4:0] b4_4,

    // Final outputs
    output wire a0, a0_bar,
    output wire a1, a1_bar,
    output wire a2, a2_bar,
    output wire a3, a3_bar
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
  reg  r7_0_1;
  reg  r8_0_1;
  reg  r9_0_1;
  reg  r10_0_1;
  reg  r11_0_1;
  reg  r12_0_1;
  reg  r0_1_1;
  reg  r1_1_1;
  reg  r2_1_1;
  reg  r3_1_1;
  reg  r4_1_1;
  reg  r5_1_1;
  reg  r6_1_1;
  reg  r7_1_1;
  reg  r8_1_1;
  reg  r9_1_1;
  reg  r10_1_1;
  reg  r11_1_1;
  reg  r12_1_1;
  reg  r0_2_1;
  reg  r1_2_1;
  reg  r2_2_1;
  reg  r3_2_1;
  reg  r4_2_1;
  reg  r5_2_1;
  reg  r6_2_1;
  reg  r7_2_1;
  reg  r8_2_1;
  reg  r9_2_1;
  reg  r10_2_1;
  reg  r11_2_1;
  reg  r12_2_1;
  reg  r0_3_1;
  reg  r1_3_1;
  reg  r2_3_1;
  reg  r3_3_1;
  reg  r4_3_1;
  reg  r5_3_1;
  reg  r6_3_1;
  reg  r7_3_1;
  reg  r8_3_1;
  reg  r9_3_1;
  reg  r10_3_1;
  reg  r11_3_1;
  reg  r12_3_1;
  reg  r0_4_1;
  reg  r1_4_1;
  reg  r2_4_1;
  reg  r3_4_1;
  reg  r4_4_1;
  reg  r5_4_1;
  reg  r6_4_1;
  reg  r7_4_1;
  reg  r8_4_1;
  reg  r9_4_1;
  reg  r10_4_1;
  reg  r11_4_1;
  reg  r12_4_1;
  reg  r0_5_1;
  reg  r1_5_1;
  reg  r2_5_1;
  reg  r3_5_1;
  reg  r4_5_1;
  reg  r5_5_1;
  reg  r6_5_1;
  reg  r7_5_1;
  reg  r8_5_1;
  reg  r9_5_1;
  reg  r10_5_1;
  reg  r11_5_1;
  reg  r12_5_1;
  reg  r0_6_1;
  reg  r1_6_1;
  reg  r2_6_1;
  reg  r3_6_1;
  reg  r4_6_1;
  reg  r5_6_1;
  reg  r6_6_1;
  reg  r7_6_1;
  reg  r8_6_1;
  reg  r9_6_1;
  reg  r10_6_1;
  reg  r11_6_1;
  reg  r12_6_1;
  reg  r0_7_1;
  reg  r1_7_1;
  reg  r2_7_1;
  reg  r3_7_1;
  reg  r4_7_1;
  reg  r5_7_1;
  reg  r6_7_1;
  reg  r7_7_1;
  reg  r8_7_1;
  reg  r9_7_1;
  reg  r10_7_1;
  reg  r11_7_1;
  reg  r12_7_1;
  initial begin
    r0_0_1 = $random;
    r1_0_1 = $random;
    r2_0_1 = $random;
    r3_0_1 = $random;
    r4_0_1 = $random;
    r5_0_1 = $random;
    r6_0_1 = $random;
    r7_0_1 = $random;
    r8_0_1 = $random;
    r9_0_1 = $random;
    r10_0_1 = $random;
    r11_0_1 = $random;
    r12_0_1 = $random;
    r0_1_1 = $random;
    r1_1_1 = $random;
    r2_1_1 = $random;
    r3_1_1 = $random;
    r4_1_1 = $random;
    r5_1_1 = $random;
    r6_1_1 = $random;
    r7_1_1 = $random;
    r8_1_1 = $random;
    r9_1_1 = $random;
    r10_1_1 = $random;
    r11_1_1 = $random;
    r12_1_1 = $random;
    r0_2_1 = $random;
    r1_2_1 = $random;
    r2_2_1 = $random;
    r3_2_1 = $random;
    r4_2_1 = $random;
    r5_2_1 = $random;
    r6_2_1 = $random;
    r7_2_1 = $random;
    r8_2_1 = $random;
    r9_2_1 = $random;
    r10_2_1 = $random;
    r11_2_1 = $random;
    r12_2_1 = $random;
    r0_3_1 = $random;
    r1_3_1 = $random;
    r2_3_1 = $random;
    r3_3_1 = $random;
    r4_3_1 = $random;
    r5_3_1 = $random;
    r6_3_1 = $random;
    r7_3_1 = $random;
    r8_3_1 = $random;
    r9_3_1 = $random;
    r10_3_1 = $random;
    r11_3_1 = $random;
    r12_3_1 = $random;
    r0_4_1 = $random;
    r1_4_1 = $random;
    r2_4_1 = $random;
    r3_4_1 = $random;
    r4_4_1 = $random;
    r5_4_1 = $random;
    r6_4_1 = $random;
    r7_4_1 = $random;
    r8_4_1 = $random;
    r9_4_1 = $random;
    r10_4_1 = $random;
    r11_4_1 = $random;
    r12_4_1 = $random;
    r0_5_1 = $random;
    r1_5_1 = $random;
    r2_5_1 = $random;
    r3_5_1 = $random;
    r4_5_1 = $random;
    r5_5_1 = $random;
    r6_5_1 = $random;
    r7_5_1 = $random;
    r8_5_1 = $random;
    r9_5_1 = $random;
    r10_5_1 = $random;
    r11_5_1 = $random;
    r12_5_1 = $random;
    r0_6_1 = $random;
    r1_6_1 = $random;
    r2_6_1 = $random;
    r3_6_1 = $random;
    r4_6_1 = $random;
    r5_6_1 = $random;
    r6_6_1 = $random;
    r7_6_1 = $random;
    r8_6_1 = $random;
    r9_6_1 = $random;
    r10_6_1 = $random;
    r11_6_1 = $random;
    r12_6_1 = $random;
    r0_7_1 = $random;
    r1_7_1 = $random;
    r2_7_1 = $random;
    r3_7_1 = $random;
    r4_7_1 = $random;
    r5_7_1 = $random;
    r6_7_1 = $random;
    r7_7_1 = $random;
    r8_7_1 = $random;
    r9_7_1 = $random;
    r10_7_1 = $random;
    r11_7_1 = $random;
    r12_7_1 = $random;
    #1;
  end

 wire masked_activation0_1, masked_activation0bar_1;
 wire masked_activation1_1, masked_activation1bar_1;
 wire masked_activation2_1, masked_activation2bar_1;
 wire masked_activation3_1, masked_activation3bar_1;
 wire masked_activation4_1, masked_activation4bar_1;
 wire masked_activation5_1, masked_activation5bar_1;
 wire masked_activation6_1, masked_activation6bar_1;
 wire masked_activation7_1, masked_activation7bar_1;
 wire mask0_1, mask0bar_1;
 wire mask1_1, mask1bar_1;
 wire mask2_1, mask2bar_1;
 wire mask3_1, mask3bar_1;
 wire mask4_1, mask4bar_1;
 wire mask5_1, mask5bar_1;
 wire mask6_1, mask6bar_1;
 wire mask7_1, mask7bar_1;
 reg masked_activationr0_1, masked_activationr0bar_1;
 reg masked_activationr1_1, masked_activationr1bar_1;
 reg masked_activationr2_1, masked_activationr2bar_1;
 reg masked_activationr3_1, masked_activationr3bar_1;
 reg masked_activationr4_1, masked_activationr4bar_1;
 reg masked_activationr5_1, masked_activationr5bar_1;
 reg masked_activationr6_1, masked_activationr6bar_1;
 reg masked_activationr7_1, masked_activationr7bar_1;
 reg maskr0_1, maskr0bar_1;
 reg maskr1_1, maskr1bar_1;
 reg maskr2_1, maskr2bar_1;
 reg maskr3_1, maskr3bar_1;
 reg maskr4_1, maskr4bar_1;
 reg maskr5_1, maskr5bar_1;
 reg maskr6_1, maskr6bar_1;
 reg maskr7_1, maskr7bar_1;
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
    .w1_0_1(w1_0_1), .w1_1_1(w1_1_1),
    .w2_0_1(w2_0_1), .w2_1_1(w2_1_1),
    .w3_0_1(w3_0_1), .w3_1_1(w3_1_1),
    .w4_0_1(w4_0_1), .w4_1_1(w4_1_1),
    .w5_0_1(w5_0_1), .w5_1_1(w5_1_1),
    .w6_0_1(w6_0_1), .w6_1_1(w6_1_1),
    .w7_0_1(w7_0_1), .w7_1_1(w7_1_1),
    .w8_0_1(w8_0_1), .w8_1_1(w8_1_1),
    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1), .b5_1(b5_1), .b6_1(b6_1), .b7_1(b7_1), .b8_1(b8_1),
    .r0_0(r0_0_1),
    .r1_0(r1_0_1),
    .r2_0(r2_0_1),
    .r3_0(r3_0_1),
    .r4_0(r4_0_1),
    .r5_0(r5_0_1),
    .r6_0(r6_0_1),
    .r7_0(r7_0_1),
    .r8_0(r8_0_1),
    .r9_0(r9_0_1),
    .r10_0(r10_0_1),
    .r11_0(r11_0_1),
    .r12_0(r12_0_1),
    .r0_1(r0_1_1),
    .r1_1(r1_1_1),
    .r2_1(r2_1_1),
    .r3_1(r3_1_1),
    .r4_1(r4_1_1),
    .r5_1(r5_1_1),
    .r6_1(r6_1_1),
    .r7_1(r7_1_1),
    .r8_1(r8_1_1),
    .r9_1(r9_1_1),
    .r10_1(r10_1_1),
    .r11_1(r11_1_1),
    .r12_1(r12_1_1),
    .r0_2(r0_2_1),
    .r1_2(r1_2_1),
    .r2_2(r2_2_1),
    .r3_2(r3_2_1),
    .r4_2(r4_2_1),
    .r5_2(r5_2_1),
    .r6_2(r6_2_1),
    .r7_2(r7_2_1),
    .r8_2(r8_2_1),
    .r9_2(r9_2_1),
    .r10_2(r10_2_1),
    .r11_2(r11_2_1),
    .r12_2(r12_2_1),
    .r0_3(r0_3_1),
    .r1_3(r1_3_1),
    .r2_3(r2_3_1),
    .r3_3(r3_3_1),
    .r4_3(r4_3_1),
    .r5_3(r5_3_1),
    .r6_3(r6_3_1),
    .r7_3(r7_3_1),
    .r8_3(r8_3_1),
    .r9_3(r9_3_1),
    .r10_3(r10_3_1),
    .r11_3(r11_3_1),
    .r12_3(r12_3_1),
    .r0_4(r0_4_1),
    .r1_4(r1_4_1),
    .r2_4(r2_4_1),
    .r3_4(r3_4_1),
    .r4_4(r4_4_1),
    .r5_4(r5_4_1),
    .r6_4(r6_4_1),
    .r7_4(r7_4_1),
    .r8_4(r8_4_1),
    .r9_4(r9_4_1),
    .r10_4(r10_4_1),
    .r11_4(r11_4_1),
    .r12_4(r12_4_1),
    .r0_5(r0_5_1),
    .r1_5(r1_5_1),
    .r2_5(r2_5_1),
    .r3_5(r3_5_1),
    .r4_5(r4_5_1),
    .r5_5(r5_5_1),
    .r6_5(r6_5_1),
    .r7_5(r7_5_1),
    .r8_5(r8_5_1),
    .r9_5(r9_5_1),
    .r10_5(r10_5_1),
    .r11_5(r11_5_1),
    .r12_5(r12_5_1),
    .r0_6(r0_6_1),
    .r1_6(r1_6_1),
    .r2_6(r2_6_1),
    .r3_6(r3_6_1),
    .r4_6(r4_6_1),
    .r5_6(r5_6_1),
    .r6_6(r6_6_1),
    .r7_6(r7_6_1),
    .r8_6(r8_6_1),
    .r9_6(r9_6_1),
    .r10_6(r10_6_1),
    .r11_6(r11_6_1),
    .r12_6(r12_6_1),
    .r0_7(r0_7_1),
    .r1_7(r1_7_1),
    .r2_7(r2_7_1),
    .r3_7(r3_7_1),
    .r4_7(r4_7_1),
    .r5_7(r5_7_1),
    .r6_7(r6_7_1),
    .r7_7(r7_7_1),
    .r8_7(r8_7_1),
    .r9_7(r9_7_1),
    .r10_7(r10_7_1),
    .r11_7(r11_7_1),
    .r12_7(r12_7_1),
    .masked_activation0_1(masked_activation0_1), .masked_activation0bar_1(masked_activation0bar_1),
    .masked_activation1_1(masked_activation1_1), .masked_activation1bar_1(masked_activation1bar_1),
    .masked_activation2_1(masked_activation2_1), .masked_activation2bar_1(masked_activation2bar_1),
    .masked_activation3_1(masked_activation3_1), .masked_activation3bar_1(masked_activation3bar_1),
    .masked_activation4_1(masked_activation4_1), .masked_activation4bar_1(masked_activation4bar_1),
    .masked_activation5_1(masked_activation5_1), .masked_activation5bar_1(masked_activation5bar_1),
    .masked_activation6_1(masked_activation6_1), .masked_activation6bar_1(masked_activation6bar_1),
    .masked_activation7_1(masked_activation7_1), .masked_activation7bar_1(masked_activation7bar_1),
    .mask0_1(mask0_1), .mask0bar_1(mask0bar_1),
    .mask1_1(mask1_1), .mask1bar_1(mask1bar_1),
    .mask2_1(mask2_1), .mask2bar_1(mask2bar_1),
    .mask3_1(mask3_1), .mask3bar_1(mask3bar_1),
    .mask4_1(mask4_1), .mask4bar_1(mask4bar_1),
    .mask5_1(mask5_1), .mask5bar_1(mask5bar_1),
    .mask6_1(mask6_1), .mask6bar_1(mask6bar_1),
    .mask7_1(mask7_1), .mask7bar_1(mask7bar_1)
  );

  always @(posedge clk) begin
    maskr0_1 <= mask0_1;
    maskr1_1 <= mask1_1;
    maskr2_1 <= mask2_1;
    maskr3_1 <= mask3_1;
    maskr4_1 <= mask4_1;
    maskr5_1 <= mask5_1;
    maskr6_1 <= mask6_1;
    maskr7_1 <= mask7_1;
    masked_activationr0_1 <= masked_activation0_1;
    masked_activationr1_1 <= masked_activation1_1;
    masked_activationr2_1 <= masked_activation2_1;
    masked_activationr3_1 <= masked_activation3_1;
    masked_activationr4_1 <= masked_activation4_1;
    masked_activationr5_1 <= masked_activation5_1;
    masked_activationr6_1 <= masked_activation6_1;
    masked_activationr7_1 <= masked_activation7_1;
    maskr0bar_1 <= mask0_1;
    maskr1bar_1 <= mask1_1;
    maskr2bar_1 <= mask2_1;
    maskr3bar_1 <= mask3_1;
    maskr4bar_1 <= mask4_1;
    maskr5bar_1 <= mask5_1;
    maskr6bar_1 <= mask6_1;
    maskr7bar_1 <= mask7_1;
    masked_activationr0bar_1 <= masked_activation0_1;
    masked_activationr1bar_1 <= masked_activation1_1;
    masked_activationr2bar_1 <= masked_activation2_1;
    masked_activationr3bar_1 <= masked_activation3_1;
    masked_activationr4bar_1 <= masked_activation4_1;
    masked_activationr5bar_1 <= masked_activation5_1;
    masked_activationr6bar_1 <= masked_activation6_1;
    masked_activationr7bar_1 <= masked_activation7_1;
  end

  //--------------------------------------------------------------------------
  // Layer-2 randomness taps
  //--------------------------------------------------------------------------
  reg  r0_0_2;
  reg  r1_0_2;
  reg  r2_0_2;
  reg  r3_0_2;
  reg  r4_0_2;
  reg  r5_0_2;
  reg  r0_1_2;
  reg  r1_1_2;
  reg  r2_1_2;
  reg  r3_1_2;
  reg  r4_1_2;
  reg  r5_1_2;
  reg  r0_2_2;
  reg  r1_2_2;
  reg  r2_2_2;
  reg  r3_2_2;
  reg  r4_2_2;
  reg  r5_2_2;
  reg  r0_3_2;
  reg  r1_3_2;
  reg  r2_3_2;
  reg  r3_3_2;
  reg  r4_3_2;
  reg  r5_3_2;
  reg  r0_4_2;
  reg  r1_4_2;
  reg  r2_4_2;
  reg  r3_4_2;
  reg  r4_4_2;
  reg  r5_4_2;
  reg  r0_5_2;
  reg  r1_5_2;
  reg  r2_5_2;
  reg  r3_5_2;
  reg  r4_5_2;
  reg  r5_5_2;
  reg  r0_6_2;
  reg  r1_6_2;
  reg  r2_6_2;
  reg  r3_6_2;
  reg  r4_6_2;
  reg  r5_6_2;
  reg  r0_7_2;
  reg  r1_7_2;
  reg  r2_7_2;
  reg  r3_7_2;
  reg  r4_7_2;
  reg  r5_7_2;
  initial begin
    r0_0_2 = $random;
    r1_0_2 = $random;
    r2_0_2 = $random;
    r3_0_2 = $random;
    r4_0_2 = $random;
    r5_0_2 = $random;
    r0_1_2 = $random;
    r1_1_2 = $random;
    r2_1_2 = $random;
    r3_1_2 = $random;
    r4_1_2 = $random;
    r5_1_2 = $random;
    r0_2_2 = $random;
    r1_2_2 = $random;
    r2_2_2 = $random;
    r3_2_2 = $random;
    r4_2_2 = $random;
    r5_2_2 = $random;
    r0_3_2 = $random;
    r1_3_2 = $random;
    r2_3_2 = $random;
    r3_3_2 = $random;
    r4_3_2 = $random;
    r5_3_2 = $random;
    r0_4_2 = $random;
    r1_4_2 = $random;
    r2_4_2 = $random;
    r3_4_2 = $random;
    r4_4_2 = $random;
    r5_4_2 = $random;
    r0_5_2 = $random;
    r1_5_2 = $random;
    r2_5_2 = $random;
    r3_5_2 = $random;
    r4_5_2 = $random;
    r5_5_2 = $random;
    r0_6_2 = $random;
    r1_6_2 = $random;
    r2_6_2 = $random;
    r3_6_2 = $random;
    r4_6_2 = $random;
    r5_6_2 = $random;
    r0_7_2 = $random;
    r1_7_2 = $random;
    r2_7_2 = $random;
    r3_7_2 = $random;
    r4_7_2 = $random;
    r5_7_2 = $random;
    #1;
  end

 wire masked_activation0_2, masked_activation0bar_2;
 wire masked_activation1_2, masked_activation1bar_2;
 wire masked_activation2_2, masked_activation2bar_2;
 wire masked_activation3_2, masked_activation3bar_2;
 wire masked_activation4_2, masked_activation4bar_2;
 wire masked_activation5_2, masked_activation5bar_2;
 wire masked_activation6_2, masked_activation6bar_2;
 wire masked_activation7_2, masked_activation7bar_2;
 wire mask0_2, mask0bar_2;
 wire mask1_2, mask1bar_2;
 wire mask2_2, mask2bar_2;
 wire mask3_2, mask3bar_2;
 wire mask4_2, mask4bar_2;
 wire mask5_2, mask5bar_2;
 wire mask6_2, mask6bar_2;
 wire mask7_2, mask7bar_2;
 reg masked_activationr0_2, masked_activationr0bar_2;
 reg masked_activationr1_2, masked_activationr1bar_2;
 reg masked_activationr2_2, masked_activationr2bar_2;
 reg masked_activationr3_2, masked_activationr3bar_2;
 reg masked_activationr4_2, masked_activationr4bar_2;
 reg masked_activationr5_2, masked_activationr5bar_2;
 reg masked_activationr6_2, masked_activationr6bar_2;
 reg masked_activationr7_2, masked_activationr7bar_2;
 reg maskr0_2, maskr0bar_2;
 reg maskr1_2, maskr1bar_2;
 reg maskr2_2, maskr2bar_2;
 reg maskr3_2, maskr3bar_2;
 reg maskr4_2, maskr4bar_2;
 reg maskr5_2, maskr5bar_2;
 reg maskr6_2, maskr6bar_2;
 reg maskr7_2, maskr7bar_2;
  activation_and_conversion_2 layer2_inst (
    .clk(clk),
    .inputs0_2(masked_activation0_1),
    .inputs1_2(masked_activation1_1),
    .inputs2_2(masked_activation2_1),
    .inputs3_2(masked_activation3_1),
    .inputs4_2(masked_activation4_1),
    .inputs5_2(masked_activation5_1),
    .inputs6_2(masked_activation6_1),
    .inputs7_2(masked_activation7_1),
    .inputs8_2(mask0_1),
    .inputs9_2(mask1_1),
    .inputs10_2(mask2_1),
    .inputs11_2(mask3_1),
    .inputs12_2(mask4_1),
    .inputs13_2(mask5_1),
    .inputs14_2(mask6_1),
    .inputs15_2(mask7_1),
    .w1_0_2(w1_0_2), .w1_1_2(w1_1_2),
    .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
    .w3_0_2(w3_0_2), .w3_1_2(w3_1_2),
    .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
    .w5_0_2(w5_0_2), .w5_1_2(w5_1_2),
    .w6_0_2(w6_0_2), .w6_1_2(w6_1_2),
    .w7_0_2(w7_0_2), .w7_1_2(w7_1_2),
    .w8_0_2(w8_0_2), .w8_1_2(w8_1_2),
    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2), .b5_2(b5_2), .b6_2(b6_2), .b7_2(b7_2), .b8_2(b8_2),
    .r0_0(r0_0_2),
    .r1_0(r1_0_2),
    .r2_0(r2_0_2),
    .r3_0(r3_0_2),
    .r4_0(r4_0_2),
    .r5_0(r5_0_2),
    .r0_1(r0_1_2),
    .r1_1(r1_1_2),
    .r2_1(r2_1_2),
    .r3_1(r3_1_2),
    .r4_1(r4_1_2),
    .r5_1(r5_1_2),
    .r0_2(r0_2_2),
    .r1_2(r1_2_2),
    .r2_2(r2_2_2),
    .r3_2(r3_2_2),
    .r4_2(r4_2_2),
    .r5_2(r5_2_2),
    .r0_3(r0_3_2),
    .r1_3(r1_3_2),
    .r2_3(r2_3_2),
    .r3_3(r3_3_2),
    .r4_3(r4_3_2),
    .r5_3(r5_3_2),
    .r0_4(r0_4_2),
    .r1_4(r1_4_2),
    .r2_4(r2_4_2),
    .r3_4(r3_4_2),
    .r4_4(r4_4_2),
    .r5_4(r5_4_2),
    .r0_5(r0_5_2),
    .r1_5(r1_5_2),
    .r2_5(r2_5_2),
    .r3_5(r3_5_2),
    .r4_5(r4_5_2),
    .r5_5(r5_5_2),
    .r0_6(r0_6_2),
    .r1_6(r1_6_2),
    .r2_6(r2_6_2),
    .r3_6(r3_6_2),
    .r4_6(r4_6_2),
    .r5_6(r5_6_2),
    .r0_7(r0_7_2),
    .r1_7(r1_7_2),
    .r2_7(r2_7_2),
    .r3_7(r3_7_2),
    .r4_7(r4_7_2),
    .r5_7(r5_7_2),
    .masked_activation0_2(masked_activation0_2), .masked_activation0bar_2(masked_activation0bar_2),
    .masked_activation1_2(masked_activation1_2), .masked_activation1bar_2(masked_activation1bar_2),
    .masked_activation2_2(masked_activation2_2), .masked_activation2bar_2(masked_activation2bar_2),
    .masked_activation3_2(masked_activation3_2), .masked_activation3bar_2(masked_activation3bar_2),
    .masked_activation4_2(masked_activation4_2), .masked_activation4bar_2(masked_activation4bar_2),
    .masked_activation5_2(masked_activation5_2), .masked_activation5bar_2(masked_activation5bar_2),
    .masked_activation6_2(masked_activation6_2), .masked_activation6bar_2(masked_activation6bar_2),
    .masked_activation7_2(masked_activation7_2), .masked_activation7bar_2(masked_activation7bar_2),
    .mask0_2(mask0_2), .mask0bar_2(mask0bar_2),
    .mask1_2(mask1_2), .mask1bar_2(mask1bar_2),
    .mask2_2(mask2_2), .mask2bar_2(mask2bar_2),
    .mask3_2(mask3_2), .mask3bar_2(mask3bar_2),
    .mask4_2(mask4_2), .mask4bar_2(mask4bar_2),
    .mask5_2(mask5_2), .mask5bar_2(mask5bar_2),
    .mask6_2(mask6_2), .mask6bar_2(mask6bar_2),
    .mask7_2(mask7_2), .mask7bar_2(mask7bar_2)
  );

  always @(posedge clk) begin
    maskr0_2 <= mask0_2;
    maskr1_2 <= mask1_2;
    maskr2_2 <= mask2_2;
    maskr3_2 <= mask3_2;
    maskr4_2 <= mask4_2;
    maskr5_2 <= mask5_2;
    maskr6_2 <= mask6_2;
    maskr7_2 <= mask7_2;
    masked_activationr0_2 <= masked_activation0_2;
    masked_activationr1_2 <= masked_activation1_2;
    masked_activationr2_2 <= masked_activation2_2;
    masked_activationr3_2 <= masked_activation3_2;
    masked_activationr4_2 <= masked_activation4_2;
    masked_activationr5_2 <= masked_activation5_2;
    masked_activationr6_2 <= masked_activation6_2;
    masked_activationr7_2 <= masked_activation7_2;
    maskr0bar_2 <= mask0_1;
    maskr1bar_2 <= mask1_1;
    maskr2bar_2 <= mask2_1;
    maskr3bar_2 <= mask3_1;
    maskr4bar_2 <= mask4_1;
    maskr5bar_2 <= mask5_1;
    maskr6bar_2 <= mask6_1;
    maskr7bar_2 <= mask7_1;
    masked_activationr0bar_2 <= masked_activation0_2;
    masked_activationr1bar_2 <= masked_activation1_2;
    masked_activationr2bar_2 <= masked_activation2_2;
    masked_activationr3bar_2 <= masked_activation3_2;
    masked_activationr4bar_2 <= masked_activation4_2;
    masked_activationr5bar_2 <= masked_activation5_2;
    masked_activationr6bar_2 <= masked_activation6_2;
    masked_activationr7bar_2 <= masked_activation7_2;
  end

  //--------------------------------------------------------------------------
  // Layer-3 randomness taps
  //--------------------------------------------------------------------------
  reg  r0_0_3;
  reg  r1_0_3;
  reg  r2_0_3;
  reg  r3_0_3;
  reg  r4_0_3;
  reg  r5_0_3;
  reg  r0_1_3;
  reg  r1_1_3;
  reg  r2_1_3;
  reg  r3_1_3;
  reg  r4_1_3;
  reg  r5_1_3;
  reg  r0_2_3;
  reg  r1_2_3;
  reg  r2_2_3;
  reg  r3_2_3;
  reg  r4_2_3;
  reg  r5_2_3;
  reg  r0_3_3;
  reg  r1_3_3;
  reg  r2_3_3;
  reg  r3_3_3;
  reg  r4_3_3;
  reg  r5_3_3;
  reg  r0_4_3;
  reg  r1_4_3;
  reg  r2_4_3;
  reg  r3_4_3;
  reg  r4_4_3;
  reg  r5_4_3;
  reg  r0_5_3;
  reg  r1_5_3;
  reg  r2_5_3;
  reg  r3_5_3;
  reg  r4_5_3;
  reg  r5_5_3;
  reg  r0_6_3;
  reg  r1_6_3;
  reg  r2_6_3;
  reg  r3_6_3;
  reg  r4_6_3;
  reg  r5_6_3;
  reg  r0_7_3;
  reg  r1_7_3;
  reg  r2_7_3;
  reg  r3_7_3;
  reg  r4_7_3;
  reg  r5_7_3;
  initial begin
    r0_0_3 = $random;
    r1_0_3 = $random;
    r2_0_3 = $random;
    r3_0_3 = $random;
    r4_0_3 = $random;
    r5_0_3 = $random;
    r0_1_3 = $random;
    r1_1_3 = $random;
    r2_1_3 = $random;
    r3_1_3 = $random;
    r4_1_3 = $random;
    r5_1_3 = $random;
    r0_2_3 = $random;
    r1_2_3 = $random;
    r2_2_3 = $random;
    r3_2_3 = $random;
    r4_2_3 = $random;
    r5_2_3 = $random;
    r0_3_3 = $random;
    r1_3_3 = $random;
    r2_3_3 = $random;
    r3_3_3 = $random;
    r4_3_3 = $random;
    r5_3_3 = $random;
    r0_4_3 = $random;
    r1_4_3 = $random;
    r2_4_3 = $random;
    r3_4_3 = $random;
    r4_4_3 = $random;
    r5_4_3 = $random;
    r0_5_3 = $random;
    r1_5_3 = $random;
    r2_5_3 = $random;
    r3_5_3 = $random;
    r4_5_3 = $random;
    r5_5_3 = $random;
    r0_6_3 = $random;
    r1_6_3 = $random;
    r2_6_3 = $random;
    r3_6_3 = $random;
    r4_6_3 = $random;
    r5_6_3 = $random;
    r0_7_3 = $random;
    r1_7_3 = $random;
    r2_7_3 = $random;
    r3_7_3 = $random;
    r4_7_3 = $random;
    r5_7_3 = $random;
    #1;
  end

 wire masked_activation0_3, masked_activation0bar_3;
 wire masked_activation1_3, masked_activation1bar_3;
 wire masked_activation2_3, masked_activation2bar_3;
 wire masked_activation3_3, masked_activation3bar_3;
 wire masked_activation4_3, masked_activation4bar_3;
 wire masked_activation5_3, masked_activation5bar_3;
 wire masked_activation6_3, masked_activation6bar_3;
 wire masked_activation7_3, masked_activation7bar_3;
 wire mask0_3, mask0bar_3;
 wire mask1_3, mask1bar_3;
 wire mask2_3, mask2bar_3;
 wire mask3_3, mask3bar_3;
 wire mask4_3, mask4bar_3;
 wire mask5_3, mask5bar_3;
 wire mask6_3, mask6bar_3;
 wire mask7_3, mask7bar_3;
 reg masked_activationr0_3, masked_activationr0bar_3;
 reg masked_activationr1_3, masked_activationr1bar_3;
 reg masked_activationr2_3, masked_activationr2bar_3;
 reg masked_activationr3_3, masked_activationr3bar_3;
 reg masked_activationr4_3, masked_activationr4bar_3;
 reg masked_activationr5_3, masked_activationr5bar_3;
 reg masked_activationr6_3, masked_activationr6bar_3;
 reg masked_activationr7_3, masked_activationr7bar_3;
 reg maskr0_3, maskr0bar_3;
 reg maskr1_3, maskr1bar_3;
 reg maskr2_3, maskr2bar_3;
 reg maskr3_3, maskr3bar_3;
 reg maskr4_3, maskr4bar_3;
 reg maskr5_3, maskr5bar_3;
 reg maskr6_3, maskr6bar_3;
 reg maskr7_3, maskr7bar_3;
  activation_and_conversion_3 layer3_inst (
    .clk(clk),
    .inputs0_3(masked_activation0_2),
    .inputs1_3(masked_activation1_2),
    .inputs2_3(masked_activation2_2),
    .inputs3_3(masked_activation3_2),
    .inputs4_3(masked_activation4_2),
    .inputs5_3(masked_activation5_2),
    .inputs6_3(masked_activation6_2),
    .inputs7_3(masked_activation7_2),
    .inputs8_3(mask0_2),
    .inputs9_3(mask1_2),
    .inputs10_3(mask2_2),
    .inputs11_3(mask3_2),
    .inputs12_3(mask4_2),
    .inputs13_3(mask5_2),
    .inputs14_3(mask6_2),
    .inputs15_3(mask7_2),
    .w1_0_3(w1_0_3), .w1_1_3(w1_1_3),
    .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
    .w3_0_3(w3_0_3), .w3_1_3(w3_1_3),
    .w4_0_3(w4_0_3), .w4_1_3(w4_1_3),
    .w5_0_3(w5_0_3), .w5_1_3(w5_1_3),
    .w6_0_3(w6_0_3), .w6_1_3(w6_1_3),
    .w7_0_3(w7_0_3), .w7_1_3(w7_1_3),
    .w8_0_3(w8_0_3), .w8_1_3(w8_1_3),
    .b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3), .b5_3(b5_3), .b6_3(b6_3), .b7_3(b7_3), .b8_3(b8_3),
    .r0_0(r0_0_3),
    .r1_0(r1_0_3),
    .r2_0(r2_0_3),
    .r3_0(r3_0_3),
    .r4_0(r4_0_3),
    .r5_0(r5_0_3),
    .r0_1(r0_1_3),
    .r1_1(r1_1_3),
    .r2_1(r2_1_3),
    .r3_1(r3_1_3),
    .r4_1(r4_1_3),
    .r5_1(r5_1_3),
    .r0_2(r0_2_3),
    .r1_2(r1_2_3),
    .r2_2(r2_2_3),
    .r3_2(r3_2_3),
    .r4_2(r4_2_3),
    .r5_2(r5_2_3),
    .r0_3(r0_3_3),
    .r1_3(r1_3_3),
    .r2_3(r2_3_3),
    .r3_3(r3_3_3),
    .r4_3(r4_3_3),
    .r5_3(r5_3_3),
    .r0_4(r0_4_3),
    .r1_4(r1_4_3),
    .r2_4(r2_4_3),
    .r3_4(r3_4_3),
    .r4_4(r4_4_3),
    .r5_4(r5_4_3),
    .r0_5(r0_5_3),
    .r1_5(r1_5_3),
    .r2_5(r2_5_3),
    .r3_5(r3_5_3),
    .r4_5(r4_5_3),
    .r5_5(r5_5_3),
    .r0_6(r0_6_3),
    .r1_6(r1_6_3),
    .r2_6(r2_6_3),
    .r3_6(r3_6_3),
    .r4_6(r4_6_3),
    .r5_6(r5_6_3),
    .r0_7(r0_7_3),
    .r1_7(r1_7_3),
    .r2_7(r2_7_3),
    .r3_7(r3_7_3),
    .r4_7(r4_7_3),
    .r5_7(r5_7_3),
    .masked_activation0_3(masked_activation0_3), .masked_activation0bar_3(masked_activation0bar_3),
    .masked_activation1_3(masked_activation1_3), .masked_activation1bar_3(masked_activation1bar_3),
    .masked_activation2_3(masked_activation2_3), .masked_activation2bar_3(masked_activation2bar_3),
    .masked_activation3_3(masked_activation3_3), .masked_activation3bar_3(masked_activation3bar_3),
    .masked_activation4_3(masked_activation4_3), .masked_activation4bar_3(masked_activation4bar_3),
    .masked_activation5_3(masked_activation5_3), .masked_activation5bar_3(masked_activation5bar_3),
    .masked_activation6_3(masked_activation6_3), .masked_activation6bar_3(masked_activation6bar_3),
    .masked_activation7_3(masked_activation7_3), .masked_activation7bar_3(masked_activation7bar_3),
    .mask0_3(mask0_3), .mask0bar_3(mask0bar_3),
    .mask1_3(mask1_3), .mask1bar_3(mask1bar_3),
    .mask2_3(mask2_3), .mask2bar_3(mask2bar_3),
    .mask3_3(mask3_3), .mask3bar_3(mask3bar_3),
    .mask4_3(mask4_3), .mask4bar_3(mask4bar_3),
    .mask5_3(mask5_3), .mask5bar_3(mask5bar_3),
    .mask6_3(mask6_3), .mask6bar_3(mask6bar_3),
    .mask7_3(mask7_3), .mask7bar_3(mask7bar_3)
  );

  always @(posedge clk) begin
    maskr0_3 <= mask0_3;
    maskr1_3 <= mask1_3;
    maskr2_3 <= mask2_3;
    maskr3_3 <= mask3_3;
    maskr4_3 <= mask4_3;
    maskr5_3 <= mask5_3;
    maskr6_3 <= mask6_3;
    maskr7_3 <= mask7_3;
    masked_activationr0_3 <= masked_activation0_3;
    masked_activationr1_3 <= masked_activation1_3;
    masked_activationr2_3 <= masked_activation2_3;
    masked_activationr3_3 <= masked_activation3_3;
    masked_activationr4_3 <= masked_activation4_3;
    masked_activationr5_3 <= masked_activation5_3;
    masked_activationr6_3 <= masked_activation6_3;
    masked_activationr7_3 <= masked_activation7_3;
    maskr0bar_3 <= mask0_3;
    maskr1bar_3 <= mask1_3;
    maskr2bar_3 <= mask2_3;
    maskr3bar_3 <= mask3_3;
    maskr4bar_3 <= mask4_3;
    maskr5bar_3 <= mask5_3;
    maskr6bar_3 <= mask6_3;
    maskr7bar_3 <= mask7_3;
    masked_activationr0bar_3 <= masked_activation0_3;
    masked_activationr1bar_3 <= masked_activation1_3;
    masked_activationr2bar_3 <= masked_activation2_3;
    masked_activationr3bar_3 <= masked_activation3_3;
    masked_activationr4bar_3 <= masked_activation4_3;
    masked_activationr5bar_3 <= masked_activation5_3;
    masked_activationr6bar_3 <= masked_activation6_3;
    masked_activationr7bar_3 <= masked_activation7_3;
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
    #1;
  end

 reg a0_reg ;
 reg a1_reg ;
 reg a2_reg ;
 reg a3_reg ;
 reg a0_bar_reg ;
 reg a1_bar_reg ;
 reg a2_bar_reg ;
 reg a3_bar_reg ;
  output_layer_max layer4 (
    .clk(clk),
    .inputs0_4(masked_activation0_3),
    .inputs1_4(masked_activation1_3),
    .inputs2_4(masked_activation2_3),
    .inputs3_4(masked_activation3_3),
    .inputs4_4(masked_activation4_3),
    .inputs5_4(masked_activation5_3),
    .inputs6_4(masked_activation6_3),
    .inputs7_4(masked_activation7_3),
    .inputs8_4(mask0_3),
    .inputs9_4(mask1_3),
    .inputs10_4(mask2_3),
    .inputs11_4(mask3_3),
    .inputs12_4(mask4_3),
    .inputs13_4(mask5_3),
    .inputs14_4(mask6_3),
    .inputs15_4(mask7_3),
    .w1_0_4(w1_0_4), .w1_1_4(w1_1_4),
    .w2_0_4(w2_0_4), .w2_1_4(w2_1_4),
    .w3_0_4(w3_0_4), .w3_1_4(w3_1_4),
    .w4_0_4(w4_0_4), .w4_1_4(w4_1_4),
    .b1_4(b1_4), .b2_4(b2_4), .b3_4(b3_4), .b4_4(b4_4),
    .r0_0(r0_0), .r0_0bar(r0_0bar),
    .r1_0(r1_0), .r1_0bar(r1_0bar),
    .r2_0(r2_0), .r2_0bar(r2_0bar),
    .r3_0(r3_0), .r3_0bar(r3_0bar),
    .r4_0(r4_0), .r4_0bar(r4_0bar),
    .r5_0(r5_0), .r5_0bar(r5_0bar),
    .r6_0(r6_0), .r6_0bar(r6_0bar),
    .r0_1(r0_1), .r0_1bar(r0_1bar),
    .r1_1(r1_1), .r1_1bar(r1_1bar),
    .r2_1(r2_1), .r2_1bar(r2_1bar),
    .r3_1(r3_1), .r3_1bar(r3_1bar),
    .r4_1(r4_1), .r4_1bar(r4_1bar),
    .r5_1(r5_1), .r5_1bar(r5_1bar),
    .r6_1(r6_1), .r6_1bar(r6_1bar),
    .r0_2(r0_2), .r0_2bar(r0_2bar),
    .r1_2(r1_2), .r1_2bar(r1_2bar),
    .r2_2(r2_2), .r2_2bar(r2_2bar),
    .r3_2(r3_2), .r3_2bar(r3_2bar),
    .r4_2(r4_2), .r4_2bar(r4_2bar),
    .r5_2(r5_2), .r5_2bar(r5_2bar),
    .r6_2(r6_2), .r6_2bar(r6_2bar),
    .a0(a0), .a0_bar(a0_bar),
    .a1(a1), .a1_bar(a1_bar),
    .a2(a2), .a2_bar(a2_bar),
    .a3(a3), .a3_bar(a3_bar)
  );

  always @(posedge clk) begin
    a0_reg <= a0;
    a1_reg <= a1;
    a2_reg <= a2;
    a3_reg <= a3;
    a0_bar_reg <= a0_bar;
    a1_bar_reg <= a1_bar;
    a2_bar_reg <= a2_bar;
    a3_bar_reg <= a3_bar;
  end

endmodule
`default_nettype wire

