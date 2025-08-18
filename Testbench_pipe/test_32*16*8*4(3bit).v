`timescale 1ns/1ns
`default_nettype none
`include "c12.v"

module connector_tb;

  // ----------------------------
  // DUT input wires and outputs
  // ----------------------------

  // Layer-1 inputs (32x3-bit)
reg [2:0] inputs0_1,  inputs1_1,  inputs2_1,  inputs3_1;
reg [2:0] inputs4_1,  inputs5_1,  inputs6_1,  inputs7_1;
reg [2:0] inputs8_1,  inputs9_1,  inputs10_1, inputs11_1;
reg [2:0] inputs12_1, inputs13_1, inputs14_1, inputs15_1;
reg [2:0] inputs16_1, inputs17_1, inputs18_1, inputs19_1;
reg [2:0] inputs20_1, inputs21_1, inputs22_1, inputs23_1;
reg [2:0] inputs24_1, inputs25_1, inputs26_1, inputs27_1;
reg [2:0] inputs28_1, inputs29_1, inputs30_1, inputs31_1;


  // Layer-1 weights and biases
  reg [31:0] w1_0_1, w1_1_1, w2_0_1, w2_1_1, w3_0_1, w3_1_1;
  reg [31:0] w4_0_1, w4_1_1, w5_0_1, w5_1_1, w6_0_1, w6_1_1;
  reg [31:0] w7_0_1, w7_1_1, w8_0_1, w8_1_1, w9_0_1, w9_1_1;
  reg [31:0] w10_0_1, w10_1_1, w11_0_1, w11_1_1, w12_0_1, w12_1_1;
  reg [31:0] w13_0_1, w13_1_1, w14_0_1, w14_1_1, w15_0_1, w15_1_1;
  reg [31:0] w16_0_1, w16_1_1;

  reg [7:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1;
  reg [7:0] b9_1, b10_1, b11_1, b12_1, b13_1, b14_1, b15_1, b16_1;

  // Layer-2 weights and biases
  reg [31:0] w1_0_2, w1_1_2, w2_0_2, w2_1_2, w3_0_2, w3_1_2;
  reg [31:0] w4_0_2, w4_1_2, w5_0_2, w5_1_2, w6_0_2, w6_1_2;
  reg [31:0] w7_0_2, w7_1_2, w8_0_2, w8_1_2;

  reg [7:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2;

  // Layer-3 weights and biases
  reg [15:0] w1_0_3, w1_1_3, w2_0_3, w2_1_3;
  reg [15:0] w3_0_3, w3_1_3, w4_0_3, w4_1_3;
  reg [6:0] b1_3, b2_3, b3_3, b4_3;

  // Outputs
  wire a0, a0_bar, a1, a1_bar, a2, a2_bar, a3, a3_bar;

  // --------------------------
  // DUT Instantiation
  // --------------------------

  connector uut (
    .inputs0_1(inputs0_1),   .inputs1_1(inputs1_1),   .inputs2_1(inputs2_1),   .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1),   .inputs5_1(inputs5_1),   .inputs6_1(inputs6_1),   .inputs7_1(inputs7_1),
    .inputs8_1(inputs8_1),   .inputs9_1(inputs9_1),   .inputs10_1(inputs10_1), .inputs11_1(inputs11_1),
    .inputs12_1(inputs12_1), .inputs13_1(inputs13_1), .inputs14_1(inputs14_1), .inputs15_1(inputs15_1),
    .inputs16_1(inputs16_1), .inputs17_1(inputs17_1), .inputs18_1(inputs18_1), .inputs19_1(inputs19_1),
    .inputs20_1(inputs20_1), .inputs21_1(inputs21_1), .inputs22_1(inputs22_1), .inputs23_1(inputs23_1),
    .inputs24_1(inputs24_1), .inputs25_1(inputs25_1), .inputs26_1(inputs26_1), .inputs27_1(inputs27_1),
    .inputs28_1(inputs28_1), .inputs29_1(inputs29_1), .inputs30_1(inputs30_1), .inputs31_1(inputs31_1),
    // ... (weights, biases, outputs connected as needed)
  

    // Weights & biases (Layer-1, 2, 3)
// Layer-1 Weights and Biases
.w1_0_1(w1_0_1), .w1_1_1(w1_1_1),
.w2_0_1(w2_0_1), .w2_1_1(w2_1_1),
.w3_0_1(w3_0_1), .w3_1_1(w3_1_1),
.w4_0_1(w4_0_1), .w4_1_1(w4_1_1),
.w5_0_1(w5_0_1), .w5_1_1(w5_1_1),
.w6_0_1(w6_0_1), .w6_1_1(w6_1_1),
.w7_0_1(w7_0_1), .w7_1_1(w7_1_1),
.w8_0_1(w8_0_1), .w8_1_1(w8_1_1),
.w9_0_1(w9_0_1), .w9_1_1(w9_1_1),
.w10_0_1(w10_0_1), .w10_1_1(w10_1_1),
.w11_0_1(w11_0_1), .w11_1_1(w11_1_1),
.w12_0_1(w12_0_1), .w12_1_1(w12_1_1),
.w13_0_1(w13_0_1), .w13_1_1(w13_1_1),
.w14_0_1(w14_0_1), .w14_1_1(w14_1_1),
.w15_0_1(w15_0_1), .w15_1_1(w15_1_1),
.w16_0_1(w16_0_1), .w16_1_1(w16_1_1),

.b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1),
.b5_1(b5_1), .b6_1(b6_1), .b7_1(b7_1), .b8_1(b8_1),
.b9_1(b9_1), .b10_1(b10_1), .b11_1(b11_1), .b12_1(b12_1),
.b13_1(b13_1), .b14_1(b14_1), .b15_1(b15_1), .b16_1(b16_1),

// Layer-2 Weights and Biases
.w1_0_2(w1_0_2), .w1_1_2(w1_1_2),
.w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
.w3_0_2(w3_0_2), .w3_1_2(w3_1_2),
.w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
.w5_0_2(w5_0_2), .w5_1_2(w5_1_2),
.w6_0_2(w6_0_2), .w6_1_2(w6_1_2),
.w7_0_2(w7_0_2), .w7_1_2(w7_1_2),
.w8_0_2(w8_0_2), .w8_1_2(w8_1_2),

.b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2),
.b5_2(b5_2), .b6_2(b6_2), .b7_2(b7_2), .b8_2(b8_2),

// Layer-3 Weights and Biases
.w1_0_3(w1_0_3), .w1_1_3(w1_1_3),
.w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
.w3_0_3(w3_0_3), .w3_1_3(w3_1_3),
.w4_0_3(w4_0_3), .w4_1_3(w4_1_3),

.b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3),


    // Outputs
    .a0(a0), .a0_bar(a0_bar),
    .a1(a1), .a1_bar(a1_bar),
    .a2(a2), .a2_bar(a2_bar),
    .a3(a3), .a3_bar(a3_bar)
  );

  // --------------------------
  // Stimulus Generation
  // --------------------------

initial begin
inputs0_1  = 3'd3;  inputs1_1  = 3'd6;  inputs2_1  = 3'd7;  inputs3_1  = 3'd1;
inputs4_1  = 3'd0;  inputs5_1  = 3'd2;  inputs6_1  = 3'd0;  inputs7_1  = 3'd6;

inputs8_1  = 3'd3;  inputs9_1  = 3'd6;  inputs10_1 = 3'd7;  inputs11_1 = 3'd1;
inputs12_1 = 3'd0;  inputs13_1 = 3'd2;  inputs14_1 = 3'd0;  inputs15_1 = 3'd6;

inputs16_1 = 3'd3;  inputs17_1 = 3'd6;  inputs18_1 = 3'd7;  inputs19_1 = 3'd1;
inputs20_1 = 3'd0;  inputs21_1 = 3'd2;  inputs22_1 = 3'd0;  inputs23_1 = 3'd6;

inputs24_1 = 3'd3;  inputs25_1 = 3'd6;  inputs26_1 = 3'd7;  inputs27_1 = 3'd1;
inputs28_1 = 3'd0;  inputs29_1 = 3'd2;  inputs30_1 = 3'd0;  inputs31_1 = 3'd6;




// ------------ Layer-1 Weights (32-bit) ------------
w1_0_1  = 32'h00000000;  w1_1_1  = 32'hFFFFFFFF;
w2_0_1  = 32'h00000000;  w2_1_1  = 32'hFFFFFFFF;
w3_0_1  = 32'h00000000;  w3_1_1  = 32'hFFFFFFFF;
w4_0_1  = 32'h00000000;  w4_1_1  = 32'hFFFFFFFF;
w5_0_1  = 32'h00000000;  w5_1_1  = 32'hFFFFFFFF;
w6_0_1  = 32'h00000000;  w6_1_1  = 32'hFFFFFFFF;
w7_0_1  = 32'h00000000;  w7_1_1  = 32'hFFFFFFFF;
w8_0_1  = 32'h00000000;  w8_1_1  = 32'hFFFFFFFF;
w9_0_1  = 32'h00000000;  w9_1_1  = 32'hFFFFFFFF;
w10_0_1 = 32'h00000000;  w10_1_1 = 32'hFFFFFFFF;
w11_0_1 = 32'h00000000;  w11_1_1 = 32'hFFFFFFFF;
w12_0_1 = 32'h00000000;  w12_1_1 = 32'hFFFFFFFF;
w13_0_1 = 32'h00000000;  w13_1_1 = 32'hFFFFFFFF;
w14_0_1 = 32'h00000000;  w14_1_1 = 32'hFFFFFFFF;
w15_0_1 = 32'h00000000;  w15_1_1 = 32'hFFFFFFFF;
w16_0_1 = 32'h00000000;  w16_1_1 = 32'hFFFFFFFF;


// ------------ Layer-1 Biases (8-bit) ------------
b1_1  = 8'd0;  b2_1  = 8'd0;
b3_1  = 8'd0;  b4_1  = 8'd0;
b5_1  = 8'd0;  b6_1  = 8'd0;
b7_1  = 8'd0;  b8_1  = 8'd0;
b9_1  = 8'd0;  b10_1 = 8'd0;
b11_1 = 8'd0;  b12_1 = 8'd0;
b13_1 = 8'd0;  b14_1 = 8'd0;
b15_1 = 8'd0;  b16_1 = 8'd0;


// ------------ Layer-2 Weights (32-bit, 8 neurons, 2 shares) ------------
w1_0_2 = 32'hFFFFFFFF;  w1_1_2 = 32'h00000000;
w2_0_2 = 32'hFFFFFFFF;  w2_1_2 = 32'h00000000;
w3_0_2 = 32'hFFFFFFFF;  w3_1_2 = 32'h00000000;
w4_0_2 = 32'hFFFFFFFF;  w4_1_2 = 32'h00000000;
w5_0_2 = 32'hFFFFFFFF;  w5_1_2 = 32'h00000000;
w6_0_2 = 32'hFFFFFFFF;  w6_1_2 = 32'h00000000;
w7_0_2 = 32'hFFFFFFFF;  w7_1_2 = 32'h00000000;
w8_0_2 = 32'hFFFFFFFF;  w8_1_2 = 32'h00000000;


// ------------ Layer-2 Biases (8-bit) ------------
b1_2 = 8'd0;  b2_2 = 8'd0;
b3_2 = 8'd0;  b4_2 = 8'd0;
b5_2 = 8'd0;  b6_2 = 8'd0;
b7_2 = 8'd0;  b8_2 = 8'd0;


// ------------ Layer-3 Weights (16-bit, 4 neurons, 2 shares) ------------
w1_0_3 = 16'h0000;  w1_1_3 = 16'hFFFF;
w2_0_3 = 16'h0000;  w2_1_3 = 16'hFFFF;
w3_0_3 = 16'h0000;  w3_1_3 = 16'hFFFF;
w4_0_3 = 16'h0000;  w4_1_3 = 16'hFFFF;


// ------------ Layer-3 Biases (7-bit) ------------
b1_3 = 7'd0;   b2_3 = 7'd2;
b3_3 = 7'd1;   b4_3 = 7'd0;

    // --------------------------
    // Simulation output monitor
    // --------------------------
    $monitor("Time = %0t | a0 = %b a0_bar = %b | a1 = %b a1_bar = %b | a2 = %b a2_bar = %b | a3 = %b a3_bar = %b",
             $time, a0, a0_bar, a1, a1_bar, a2, a2_bar, a3, a3_bar);

    #10 $finish;
  end

endmodule
