`timescale 1ns/1ps
`default_nettype none

`include "a1_it_new.v"   // Make sure this brings in layer, share_boolean_arithmetic, iterative_controller

module tb_iterative_controller;

  reg         clk, rst_n, start;
  wire        done;

  // Layer (m1) inputs
  reg  [2:0]  inputs0_1, inputs1_1, inputs2_1, inputs3_1;
  reg  [2:0]  inputs4_1, inputs5_1, inputs6_1, inputs7_1;
  reg  [2:0]  inputs8_1, inputs9_1, inputs10_1, inputs11_1;
  reg  [2:0]  inputs12_1, inputs13_1, inputs14_1, inputs15_1;
// Share (m1) inputs
  reg [15:0] w1_0_1, w1_1_1, w2_0_1, w2_1_1, w3_0_1, w3_1_1, w4_0_1, w4_1_1;
  reg [15:0] w5_0_1, w5_1_1, w6_0_1, w6_1_1, w7_0_1, w7_1_1, w8_0_1, w8_1_1;
  reg [6:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1;
  reg [6:0] b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2;
  reg [6:0] b1_3, b2_3, b3_3, b4_3, b5_3, b6_3, b7_3, b8_3;
  reg [6:0] b1_4, b2_4, b3_4, b4_4, b5_4, b6_4, b7_4, b8_4;

// Share (m2) inputs
reg [15:0] w1_0_2, w1_1_2, w2_0_2, w2_1_2, w3_0_2, w3_1_2, w4_0_2, w4_1_2;
reg [15:0] w5_0_2, w5_1_2, w6_0_2, w6_1_2, w7_0_2, w7_1_2, w8_0_2, w8_1_2;

reg [15:0] w1_0_3, w1_1_3, w2_0_3, w2_1_3, w3_0_3, w3_1_3, w4_0_3, w4_1_3;
reg [15:0] w5_0_3, w5_1_3, w6_0_3, w6_1_3, w7_0_3, w7_1_3, w8_0_3, w8_1_3;

reg [15:0] w1_0_4, w1_1_4, w2_0_4, w2_1_4, w3_0_4, w3_1_4, w4_0_4, w4_1_4;
reg [15:0] w5_0_4, w5_1_4, w6_0_4, w6_1_4, w7_0_4, w7_1_4, w8_0_4, w8_1_4;


  // Share (m2) outputs
wire [2:0] act0_0_0_r,  act0_0_1_r,  act0_0_2_r,  act0_0_3_r,  act0_0_4_r,  act0_0_5_r,  act0_0_6_r,  act0_0_7_r,
           act0_0_8_r,  act0_0_9_r,  act0_0_10_r, act0_0_11_r, act0_0_12_r, act0_0_13_r, act0_0_14_r, act0_0_15_r;
wire [2:0] act0_1_0_r,  act0_1_1_r,  act0_1_2_r,  act0_1_3_r,  act0_1_4_r,  act0_1_5_r,  act0_1_6_r,  act0_1_7_r,
           act0_1_8_r,  act0_1_9_r,  act0_1_10_r, act0_1_11_r, act0_1_12_r, act0_1_13_r, act0_1_14_r, act0_1_15_r;

wire [2:0] act1_0_0_r,  act1_0_1_r,  act1_0_2_r,  act1_0_3_r,  act1_0_4_r,  act1_0_5_r,  act1_0_6_r,  act1_0_7_r,
           act1_0_8_r,  act1_0_9_r,  act1_0_10_r, act1_0_11_r, act1_0_12_r, act1_0_13_r, act1_0_14_r, act1_0_15_r;
wire [2:0] act1_1_0_r,  act1_1_1_r,  act1_1_2_r,  act1_1_3_r,  act1_1_4_r,  act1_1_5_r,  act1_1_6_r,  act1_1_7_r,
           act1_1_8_r,  act1_1_9_r,  act1_1_10_r, act1_1_11_r, act1_1_12_r, act1_1_13_r, act1_1_14_r, act1_1_15_r;

wire [2:0] act2_0_0_r,  act2_0_1_r,  act2_0_2_r,  act2_0_3_r,  act2_0_4_r,  act2_0_5_r,  act2_0_6_r,  act2_0_7_r,
           act2_0_8_r,  act2_0_9_r,  act2_0_10_r, act2_0_11_r, act2_0_12_r, act2_0_13_r, act2_0_14_r, act2_0_15_r;
wire [2:0] act2_1_0_r,  act2_1_1_r,  act2_1_2_r,  act2_1_3_r,  act2_1_4_r,  act2_1_5_r,  act2_1_6_r,  act2_1_7_r,
           act2_1_8_r,  act2_1_9_r,  act2_1_10_r, act2_1_11_r, act2_1_12_r, act2_1_13_r, act2_1_14_r, act2_1_15_r;

wire [2:0] act3_0_0_r,  act3_0_1_r,  act3_0_2_r,  act3_0_3_r,  act3_0_4_r,  act3_0_5_r,  act3_0_6_r,  act3_0_7_r,
           act3_0_8_r,  act3_0_9_r,  act3_0_10_r, act3_0_11_r, act3_0_12_r, act3_0_13_r, act3_0_14_r, act3_0_15_r;
wire [2:0] act3_1_0_r,  act3_1_1_r,  act3_1_2_r,  act3_1_3_r,  act3_1_4_r,  act3_1_5_r,  act3_1_6_r,  act3_1_7_r,
           act3_1_8_r,  act3_1_9_r,  act3_1_10_r, act3_1_11_r, act3_1_12_r, act3_1_13_r, act3_1_14_r, act3_1_15_r;

wire [2:0] act4_0_0_r,  act4_0_1_r,  act4_0_2_r,  act4_0_3_r,  act4_0_4_r,  act4_0_5_r,  act4_0_6_r,  act4_0_7_r,
           act4_0_8_r,  act4_0_9_r,  act4_0_10_r, act4_0_11_r, act4_0_12_r, act4_0_13_r, act4_0_14_r, act4_0_15_r;
wire [2:0] act4_1_0_r,  act4_1_1_r,  act4_1_2_r,  act4_1_3_r,  act4_1_4_r,  act4_1_5_r,  act4_1_6_r,  act4_1_7_r,
           act4_1_8_r,  act4_1_9_r,  act4_1_10_r, act4_1_11_r, act4_1_12_r, act4_1_13_r, act4_1_14_r, act4_1_15_r;

wire [2:0] act5_0_0_r,  act5_0_1_r,  act5_0_2_r,  act5_0_3_r,  act5_0_4_r,  act5_0_5_r,  act5_0_6_r,  act5_0_7_r,
           act5_0_8_r,  act5_0_9_r,  act5_0_10_r, act5_0_11_r, act5_0_12_r, act5_0_13_r, act5_0_14_r, act5_0_15_r;
wire [2:0] act5_1_0_r,  act5_1_1_r,  act5_1_2_r,  act5_1_3_r,  act5_1_4_r,  act5_1_5_r,  act5_1_6_r,  act5_1_7_r,
           act5_1_8_r,  act5_1_9_r,  act5_1_10_r, act5_1_11_r, act5_1_12_r, act5_1_13_r, act5_1_14_r, act5_1_15_r;

wire [2:0] act6_0_0_r,  act6_0_1_r,  act6_0_2_r,  act6_0_3_r,  act6_0_4_r,  act6_0_5_r,  act6_0_6_r,  act6_0_7_r,
           act6_0_8_r,  act6_0_9_r,  act6_0_10_r, act6_0_11_r, act6_0_12_r, act6_0_13_r, act6_0_14_r, act6_0_15_r;
wire [2:0] act6_1_0_r,  act6_1_1_r,  act6_1_2_r,  act6_1_3_r,  act6_1_4_r,  act6_1_5_r,  act6_1_6_r,  act6_1_7_r,
           act6_1_8_r,  act6_1_9_r,  act6_1_10_r, act6_1_11_r, act6_1_12_r, act6_1_13_r, act6_1_14_r, act6_1_15_r;

wire [2:0] act7_0_0_r,  act7_0_1_r,  act7_0_2_r,  act7_0_3_r,  act7_0_4_r,  act7_0_5_r,  act7_0_6_r,  act7_0_7_r,
           act7_0_8_r,  act7_0_9_r,  act7_0_10_r, act7_0_11_r, act7_0_12_r, act7_0_13_r, act7_0_14_r, act7_0_15_r;
wire [2:0] act7_1_0_r,  act7_1_1_r,  act7_1_2_r,  act7_1_3_r,  act7_1_4_r,  act7_1_5_r,  act7_1_6_r,  act7_1_7_r,
           act7_1_8_r,  act7_1_9_r,  act7_1_10_r, act7_1_11_r, act7_1_12_r, act7_1_13_r, act7_1_14_r, act7_1_15_r;


  // Device Under Test
  iterative_controller dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .done(done),

  // Inputs (0 to 15)
.inputs0_1(inputs0_1),  .inputs1_1(inputs1_1),  .inputs2_1(inputs2_1),  .inputs3_1(inputs3_1),
.inputs4_1(inputs4_1),  .inputs5_1(inputs5_1),  .inputs6_1(inputs6_1),  .inputs7_1(inputs7_1),
.inputs8_1(inputs8_1),  .inputs9_1(inputs9_1),  .inputs10_1(inputs10_1), .inputs11_1(inputs11_1),
.inputs12_1(inputs12_1),.inputs13_1(inputs13_1),.inputs14_1(inputs14_1), .inputs15_1(inputs15_1),

// Weights & Biases (for nodes 1–8, all sets)
.w1_0_1(w1_0_1), .w1_1_1(w1_1_1), .w2_0_1(w2_0_1), .w2_1_1(w2_1_1),
.w3_0_1(w3_0_1), .w3_1_1(w3_1_1), .w4_0_1(w4_0_1), .w4_1_1(w4_1_1),
.w5_0_1(w5_0_1), .w5_1_1(w5_1_1), .w6_0_1(w6_0_1), .w6_1_1(w6_1_1),
.w7_0_1(w7_0_1), .w7_1_1(w7_1_1), .w8_0_1(w8_0_1), .w8_1_1(w8_1_1),

.b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1), .b5_1(b5_1), .b6_1(b6_1), .b7_1(b7_1), .b8_1(b8_1),
.b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2), .b5_2(b5_2), .b6_2(b6_2), .b7_2(b7_2), .b8_2(b8_2),
.b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3), .b5_3(b5_3), .b6_3(b6_3), .b7_3(b7_3), .b8_3(b8_3),
.b1_4(b1_4), .b2_4(b2_4), .b3_4(b3_4), .b4_4(b4_4), .b5_4(b5_4), .b6_4(b6_4), .b7_4(b7_4), .b8_4(b8_4),

.w1_0_2(w1_0_2), .w1_1_2(w1_1_2), .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
.w3_0_2(w3_0_2), .w3_1_2(w3_1_2), .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
.w5_0_2(w5_0_2), .w5_1_2(w5_1_2), .w6_0_2(w6_0_2), .w6_1_2(w6_1_2),
.w7_0_2(w7_0_2), .w7_1_2(w7_1_2), .w8_0_2(w8_0_2), .w8_1_2(w8_1_2),

.w1_0_3(w1_0_3), .w1_1_3(w1_1_3), .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
.w3_0_3(w3_0_3), .w3_1_3(w3_1_3), .w4_0_3(w4_0_3), .w4_1_3(w4_1_3),
.w5_0_3(w5_0_3), .w5_1_3(w5_1_3), .w6_0_3(w6_0_3), .w6_1_3(w6_1_3),
.w7_0_3(w7_0_3), .w7_1_3(w7_1_3), .w8_0_3(w8_0_3), .w8_1_3(w8_1_3),

.w1_0_4(w1_0_4), .w1_1_4(w1_1_4), .w2_0_4(w2_0_4), .w2_1_4(w2_1_4),
.w3_0_4(w3_0_4), .w3_1_4(w3_1_4), .w4_0_4(w4_0_4), .w4_1_4(w4_1_4),
.w5_0_4(w5_0_4), .w5_1_4(w5_1_4), .w6_0_4(w6_0_4), .w6_1_4(w6_1_4),
.w7_0_4(w7_0_4), .w7_1_4(w7_1_4), .w8_0_4(w8_0_4), .w8_1_4(w8_1_4),


.act0_0_0_r(act0_0_0_r), .act0_0_1_r(act0_0_1_r), .act0_0_2_r(act0_0_2_r), .act0_0_3_r(act0_0_3_r),
.act0_0_4_r(act0_0_4_r), .act0_0_5_r(act0_0_5_r), .act0_0_6_r(act0_0_6_r), .act0_0_7_r(act0_0_7_r),
.act0_0_8_r(act0_0_8_r), .act0_0_9_r(act0_0_9_r), .act0_0_10_r(act0_0_10_r), .act0_0_11_r(act0_0_11_r),
.act0_0_12_r(act0_0_12_r), .act0_0_13_r(act0_0_13_r), .act0_0_14_r(act0_0_14_r), .act0_0_15_r(act0_0_15_r),
.act0_1_0_r(act0_1_0_r), .act0_1_1_r(act0_1_1_r), .act0_1_2_r(act0_1_2_r), .act0_1_3_r(act0_1_3_r),
.act0_1_4_r(act0_1_4_r), .act0_1_5_r(act0_1_5_r), .act0_1_6_r(act0_1_6_r), .act0_1_7_r(act0_1_7_r),
.act0_1_8_r(act0_1_8_r), .act0_1_9_r(act0_1_9_r), .act0_1_10_r(act0_1_10_r), .act0_1_11_r(act0_1_11_r),
.act0_1_12_r(act0_1_12_r), .act0_1_13_r(act0_1_13_r), .act0_1_14_r(act0_1_14_r), .act0_1_15_r(act0_1_15_r),

.act1_0_0_r(act1_0_0_r), .act1_0_1_r(act1_0_1_r), .act1_0_2_r(act1_0_2_r), .act1_0_3_r(act1_0_3_r),
.act1_0_4_r(act1_0_4_r), .act1_0_5_r(act1_0_5_r), .act1_0_6_r(act1_0_6_r), .act1_0_7_r(act1_0_7_r),
.act1_0_8_r(act1_0_8_r), .act1_0_9_r(act1_0_9_r), .act1_0_10_r(act1_0_10_r), .act1_0_11_r(act1_0_11_r),
.act1_0_12_r(act1_0_12_r), .act1_0_13_r(act1_0_13_r), .act1_0_14_r(act1_0_14_r), .act1_0_15_r(act1_0_15_r),
.act1_1_0_r(act1_1_0_r), .act1_1_1_r(act1_1_1_r), .act1_1_2_r(act1_1_2_r), .act1_1_3_r(act1_1_3_r),
.act1_1_4_r(act1_1_4_r), .act1_1_5_r(act1_1_5_r), .act1_1_6_r(act1_1_6_r), .act1_1_7_r(act1_1_7_r),
.act1_1_8_r(act1_1_8_r), .act1_1_9_r(act1_1_9_r), .act1_1_10_r(act1_1_10_r), .act1_1_11_r(act1_1_11_r),
.act1_1_12_r(act1_1_12_r), .act1_1_13_r(act1_1_13_r), .act1_1_14_r(act1_1_14_r), .act1_1_15_r(act1_1_15_r),

.act2_0_0_r(act2_0_0_r),   .act2_0_1_r(act2_0_1_r),   .act2_0_2_r(act2_0_2_r),   .act2_0_3_r(act2_0_3_r),
.act2_0_4_r(act2_0_4_r),   .act2_0_5_r(act2_0_5_r),   .act2_0_6_r(act2_0_6_r),   .act2_0_7_r(act2_0_7_r),
.act2_0_8_r(act2_0_8_r),   .act2_0_9_r(act2_0_9_r),   .act2_0_10_r(act2_0_10_r), .act2_0_11_r(act2_0_11_r),
.act2_0_12_r(act2_0_12_r), .act2_0_13_r(act2_0_13_r), .act2_0_14_r(act2_0_14_r), .act2_0_15_r(act2_0_15_r),
.act2_1_0_r(act2_1_0_r),   .act2_1_1_r(act2_1_1_r),   .act2_1_2_r(act2_1_2_r),   .act2_1_3_r(act2_1_3_r),
.act2_1_4_r(act2_1_4_r),   .act2_1_5_r(act2_1_5_r),   .act2_1_6_r(act2_1_6_r),   .act2_1_7_r(act2_1_7_r),
.act2_1_8_r(act2_1_8_r),   .act2_1_9_r(act2_1_9_r),   .act2_1_10_r(act2_1_10_r), .act2_1_11_r(act2_1_11_r),
.act2_1_12_r(act2_1_12_r), .act2_1_13_r(act2_1_13_r), .act2_1_14_r(act2_1_14_r), .act2_1_15_r(act2_1_15_r),

.act3_0_0_r(act3_0_0_r),   .act3_0_1_r(act3_0_1_r),   .act3_0_2_r(act3_0_2_r),   .act3_0_3_r(act3_0_3_r),
.act3_0_4_r(act3_0_4_r),   .act3_0_5_r(act3_0_5_r),   .act3_0_6_r(act3_0_6_r),   .act3_0_7_r(act3_0_7_r),
.act3_0_8_r(act3_0_8_r),   .act3_0_9_r(act3_0_9_r),   .act3_0_10_r(act3_0_10_r), .act3_0_11_r(act3_0_11_r),
.act3_0_12_r(act3_0_12_r), .act3_0_13_r(act3_0_13_r), .act3_0_14_r(act3_0_14_r), .act3_0_15_r(act3_0_15_r),
.act3_1_0_r(act3_1_0_r),   .act3_1_1_r(act3_1_1_r),   .act3_1_2_r(act3_1_2_r),   .act3_1_3_r(act3_1_3_r),
.act3_1_4_r(act3_1_4_r),   .act3_1_5_r(act3_1_5_r),   .act3_1_6_r(act3_1_6_r),   .act3_1_7_r(act3_1_7_r),
.act3_1_8_r(act3_1_8_r),   .act3_1_9_r(act3_1_9_r),   .act3_1_10_r(act3_1_10_r), .act3_1_11_r(act3_1_11_r),
.act3_1_12_r(act3_1_12_r), .act3_1_13_r(act3_1_13_r), .act3_1_14_r(act3_1_14_r), .act3_1_15_r(act3_1_15_r),

.act4_0_0_r(act4_0_0_r),   .act4_0_1_r(act4_0_1_r),   .act4_0_2_r(act4_0_2_r),   .act4_0_3_r(act4_0_3_r),
.act4_0_4_r(act4_0_4_r),   .act4_0_5_r(act4_0_5_r),   .act4_0_6_r(act4_0_6_r),   .act4_0_7_r(act4_0_7_r),
.act4_0_8_r(act4_0_8_r),   .act4_0_9_r(act4_0_9_r),   .act4_0_10_r(act4_0_10_r), .act4_0_11_r(act4_0_11_r),
.act4_0_12_r(act4_0_12_r), .act4_0_13_r(act4_0_13_r), .act4_0_14_r(act4_0_14_r), .act4_0_15_r(act4_0_15_r),
.act4_1_0_r(act4_1_0_r),   .act4_1_1_r(act4_1_1_r),   .act4_1_2_r(act4_1_2_r),   .act4_1_3_r(act4_1_3_r),
.act4_1_4_r(act4_1_4_r),   .act4_1_5_r(act4_1_5_r),   .act4_1_6_r(act4_1_6_r),   .act4_1_7_r(act4_1_7_r),
.act4_1_8_r(act4_1_8_r),   .act4_1_9_r(act4_1_9_r),   .act4_1_10_r(act4_1_10_r), .act4_1_11_r(act4_1_11_r),
.act4_1_12_r(act4_1_12_r), .act4_1_13_r(act4_1_13_r), .act4_1_14_r(act4_1_14_r), .act4_1_15_r(act4_1_15_r),

.act5_0_0_r(act5_0_0_r),   .act5_0_1_r(act5_0_1_r),   .act5_0_2_r(act5_0_2_r),   .act5_0_3_r(act5_0_3_r),
.act5_0_4_r(act5_0_4_r),   .act5_0_5_r(act5_0_5_r),   .act5_0_6_r(act5_0_6_r),   .act5_0_7_r(act5_0_7_r),
.act5_0_8_r(act5_0_8_r),   .act5_0_9_r(act5_0_9_r),   .act5_0_10_r(act5_0_10_r), .act5_0_11_r(act5_0_11_r),
.act5_0_12_r(act5_0_12_r), .act5_0_13_r(act5_0_13_r), .act5_0_14_r(act5_0_14_r), .act5_0_15_r(act5_0_15_r),
.act5_1_0_r(act5_1_0_r),   .act5_1_1_r(act5_1_1_r),   .act5_1_2_r(act5_1_2_r),   .act5_1_3_r(act5_1_3_r),
.act5_1_4_r(act5_1_4_r),   .act5_1_5_r(act5_1_5_r),   .act5_1_6_r(act5_1_6_r),   .act5_1_7_r(act5_1_7_r),
.act5_1_8_r(act5_1_8_r),   .act5_1_9_r(act5_1_9_r),   .act5_1_10_r(act5_1_10_r), .act5_1_11_r(act5_1_11_r),
.act5_1_12_r(act5_1_12_r), .act5_1_13_r(act5_1_13_r), .act5_1_14_r(act5_1_14_r), .act5_1_15_r(act5_1_15_r),

.act6_0_0_r(act6_0_0_r),   .act6_0_1_r(act6_0_1_r),   .act6_0_2_r(act6_0_2_r),   .act6_0_3_r(act6_0_3_r),
.act6_0_4_r(act6_0_4_r),   .act6_0_5_r(act6_0_5_r),   .act6_0_6_r(act6_0_6_r),   .act6_0_7_r(act6_0_7_r),
.act6_0_8_r(act6_0_8_r),   .act6_0_9_r(act6_0_9_r),   .act6_0_10_r(act6_0_10_r), .act6_0_11_r(act6_0_11_r),
.act6_0_12_r(act6_0_12_r), .act6_0_13_r(act6_0_13_r), .act6_0_14_r(act6_0_14_r), .act6_0_15_r(act6_0_15_r),
.act6_1_0_r(act6_1_0_r),   .act6_1_1_r(act6_1_1_r),   .act6_1_2_r(act6_1_2_r),   .act6_1_3_r(act6_1_3_r),
.act6_1_4_r(act6_1_4_r),   .act6_1_5_r(act6_1_5_r),   .act6_1_6_r(act6_1_6_r),   .act6_1_7_r(act6_1_7_r),
.act6_1_8_r(act6_1_8_r),   .act6_1_9_r(act6_1_9_r),   .act6_1_10_r(act6_1_10_r), .act6_1_11_r(act6_1_11_r),
.act6_1_12_r(act6_1_12_r), .act6_1_13_r(act6_1_13_r), .act6_1_14_r(act6_1_14_r), .act6_1_15_r(act6_1_15_r),

.act7_0_0_r(act7_0_0_r),   .act7_0_1_r(act7_0_1_r),   .act7_0_2_r(act7_0_2_r),   .act7_0_3_r(act7_0_3_r),
.act7_0_4_r(act7_0_4_r),   .act7_0_5_r(act7_0_5_r),   .act7_0_6_r(act7_0_6_r),   .act7_0_7_r(act7_0_7_r),
.act7_0_8_r(act7_0_8_r),   .act7_0_9_r(act7_0_9_r),   .act7_0_10_r(act7_0_10_r), .act7_0_11_r(act7_0_11_r),
.act7_0_12_r(act7_0_12_r), .act7_0_13_r(act7_0_13_r), .act7_0_14_r(act7_0_14_r), .act7_0_15_r(act7_0_15_r),
.act7_1_0_r(act7_1_0_r),   .act7_1_1_r(act7_1_1_r),   .act7_1_2_r(act7_1_2_r),   .act7_1_3_r(act7_1_3_r),
.act7_1_4_r(act7_1_4_r),   .act7_1_5_r(act7_1_5_r),   .act7_1_6_r(act7_1_6_r),   .act7_1_7_r(act7_1_7_r),
.act7_1_8_r(act7_1_8_r),   .act7_1_9_r(act7_1_9_r),   .act7_1_10_r(act7_1_10_r), .act7_1_11_r(act7_1_11_r),
.act7_1_12_r(act7_1_12_r), .act7_1_13_r(act7_1_13_r), .act7_1_14_r(act7_1_14_r), .act7_1_15_r(act7_1_15_r)


  );

  // clock generation
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // stimulus
  initial begin
    $dumpfile("tb_iterative_controller.vcd");
    $dumpvars(0, tb_iterative_controller);

    // reset and static init
    rst_n = 0; start = 0;

    #17 rst_n = 1;
    

    // Initialize static inputs
// Inputs initialization (example values adjusted and extended to 16)
inputs0_1 = 3'd2;  inputs1_1 = 3'd2;  inputs2_1 = 3'd3;  inputs3_1 = 3'd3;
inputs4_1 = 3'd5;  inputs5_1 = 3'd6;  inputs6_1 = 3'd7;  inputs7_1 = 3'd6;
inputs8_1 = 3'd1;  inputs9_1 = 3'd7;  inputs10_1 = 3'd3; inputs11_1 = 3'd2;
inputs12_1 = 3'd5; inputs13_1 = 3'd7; inputs14_1 = 3'd0; inputs15_1 = 3'd1;

// Weights example pattern for 8 nodes (0th and 1st sets)
{w1_0_1,w2_0_1,w3_0_1,w4_0_1,w5_0_1,w6_0_1,w7_0_1,w8_0_1} = {8{16'b0000111111111111}};
{w1_0_2,w2_0_2,w3_0_2,w4_0_2,w5_0_2,w6_0_2,w7_0_2,w8_0_2} = {8{16'b0000111111111111}};
{w1_0_3,w2_0_3,w3_0_3,w4_0_3,w5_0_3,w6_0_3,w7_0_3,w8_0_3} = {8{16'b0000111111111111}};

{w1_1_1,w2_1_1,w3_1_1,w4_1_1,w5_1_1,w6_1_1,w7_1_1,w8_1_1} = {8{16'b0000111111111111}};
{w1_1_2,w2_1_2,w3_1_2,w4_1_2,w5_1_2,w6_1_2,w7_1_2,w8_1_2} = {8{16'b0000111111111111}};
{w1_1_3,w2_1_3,w3_1_3,w4_1_3,w5_1_3,w6_1_3,w7_1_3,w8_1_3} = {8{16'b0000111111111111}};

{w1_0_4,w2_0_4,w3_0_4,w4_0_4,w5_0_4,w6_0_4,w7_0_4,w8_0_4} = {8{16'b0000111111111111}};
{w1_1_4,w2_1_4,w3_1_4,w4_1_4,w5_1_4,w6_1_4,w7_1_4,w8_1_4} = {8{16'b0000111111111111}};

// Biases for 8 nodes (4 sets)
{b1_1,b2_1,b3_1,b4_1,b5_1,b6_1,b7_1,b8_1} = {8{7'd0}};
{b1_2,b2_2,b3_2,b4_2,b5_2,b6_2,b7_2,b8_2} = {8{7'd1}};
{b1_3,b2_3,b3_3,b4_3,b5_3,b6_3,b7_3,b8_3} = {8{7'd0}};
{b1_4,b2_4,b3_4,b4_4,b5_4,b6_4,b7_4,b8_4} = {7'd1, 7'd0, 7'd0, 7'd0, 7'd1, 7'd1, 7'd0, 7'd0}; 


    // Pulse start
    #20 start = 1;
    #10 start = 0;

    // Wait for done
    wait(done);
    


    #20 $finish;
  end
   always @(posedge clk) begin
  if (dut.state == 4 && dut.done_share) begin // WAIT_SHARE and handshake received
    $display("Iteration %0d finished:", dut.s_count);
    $display("  Biased sums:");
    $display("    biased_sum0_0 = %b", dut.biased_sum0_0);
    $display("    biased_sum0_1 = %b", dut.biased_sum0_1);
    $display("    biased_sum0_0bar = %0d", dut.biased_sum0_0bar);
    $display("    biased_sum0_1bar = %0d", dut.biased_sum0_1bar);
    $display("    biased_sum1_0 = %b", dut.biased_sum1_0);
    $display("    biased_sum1_1 = %b", dut.biased_sum1_1);
    $display("    biased_sum1_0bar = %0d", dut.biased_sum1_0bar);
    $display("    biased_sum1_1bar = %0d", dut.biased_sum1_1bar);
    $display("    biased_sum2_0 = %b", dut.biased_sum2_0);
    $display("    biased_sum2_1 = %b", dut.biased_sum2_1);
    $display("    biased_sum2_0bar = %0d", dut.biased_sum2_0bar);
    $display("    biased_sum2_1bar = %0d", dut.biased_sum2_1bar);
    $display("    biased_sum3_0 = %0d", dut.biased_sum3_0);
    $display("    biased_sum3_1 = %0d", dut.biased_sum3_1);
    $display("    biased_sum3_0bar = %0d", dut.biased_sum3_0bar);
    $display("    biased_sum3_1bar = %0d", dut.biased_sum3_1bar);
    $display("----- LAYER    boolean activations -----");
    $display("masked_activation : %b %b %b %b", dut.masked_activation0_1, dut.masked_activation1_1, dut.masked_activation2_1, dut.masked_activation3_1);
    $display("mask : %b %b %b %b", dut.mask0_1, dut.mask1_1, dut.mask2_1, dut.mask3_1);
    // ----  MODULE OUTPUTS ----
        $display("----- output -----");
        $display("output1: %b %b %b %b ", dut.a0 , dut.a1, dut.a2 , dut.a3);
        $display("output2: %b %b %b %b ", dut.a0_bar ,dut.a1_bar , dut.a2_bar ,dut.a3_bar);
    // ---- SHARE MODULE OUTPUTS ----
    $display("----- SHARE module outputs -----");
    $display("share_activation : %b %b %b %b",
        dut.act0_0_0_r, 
        dut.act1_0_0_r, 
        dut.act2_0_0_r, 
        dut.act3_0_0_r);
    $display(" ");
  end
end
endmodule

`default_nettype wire
