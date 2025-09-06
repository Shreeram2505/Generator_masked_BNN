`timescale 1ns/1ps
`default_nettype none

`include "t8.v"   // Make sure this brings in layer, share_boolean_arithmetic, iterative_controller

module tb_iterative_controller;

  reg         clk, rst_n, start;
  wire        done;

  // Layer (m1) inputs
  reg  [2:0]  inputs0_1, inputs1_1, inputs2_1, inputs3_1;
  reg  [2:0]  inputs4_1, inputs5_1, inputs6_1, inputs7_1;
  reg  [7:0]  w1_0_1, w1_1_1, w2_0_1, w2_1_1;
  reg  [7:0]  w3_0_1, w3_1_1, w4_0_1, w4_1_1;
  reg  [5:0]  b1_1, b2_1, b3_1, b4_1;
  reg  [5:0]  b1_2, b2_2, b3_2, b4_2;
  reg  [5:0]  b1_3, b2_3, b3_3, b4_3;
  reg  [5:0]  b1_4, b2_4, b3_4, b4_4;

  // Share (m2) inputs
  reg  [7:0]  w1_0_2, w1_1_2, w2_0_2, w2_1_2;
  reg  [7:0]  w3_0_2, w3_1_2, w4_0_2, w4_1_2;
  reg  [7:0]  w1_0_3, w1_1_3, w2_0_3, w2_1_3;
  reg  [7:0]  w3_0_3, w3_1_3, w4_0_3, w4_1_3;
  reg  [7:0]  w1_0_4, w1_1_4, w2_0_4, w2_1_4;
  reg  [7:0]  w3_0_4, w3_1_4, w4_0_4, w4_1_4;

  // Share (m2) outputs
  wire [2:0]  act0_0_0_r, act0_0_1_r, act0_0_2_r, act0_0_3_r, act0_0_4_r, act0_0_5_r, act0_0_6_r, act0_0_7_r;
  wire [2:0]  act0_1_0_r, act0_1_1_r, act0_1_2_r, act0_1_3_r, act0_1_4_r, act0_1_5_r, act0_1_6_r, act0_1_7_r;
  wire [2:0]  act1_0_0_r, act1_0_1_r, act1_0_2_r, act1_0_3_r, act1_0_4_r, act1_0_5_r, act1_0_6_r, act1_0_7_r;
  wire [2:0]  act1_1_0_r, act1_1_1_r, act1_1_2_r, act1_1_3_r, act1_1_4_r, act1_1_5_r, act1_1_6_r, act1_1_7_r;
  wire [2:0]  act2_0_0_r, act2_0_1_r, act2_0_2_r, act2_0_3_r, act2_0_4_r, act2_0_5_r, act2_0_6_r, act2_0_7_r;
  wire [2:0]  act2_1_0_r, act2_1_1_r, act2_1_2_r, act2_1_3_r, act2_1_4_r, act2_1_5_r, act2_1_6_r, act2_1_7_r;
  wire [2:0]  act3_0_0_r, act3_0_1_r, act3_0_2_r, act3_0_3_r, act3_0_4_r, act3_0_5_r, act3_0_6_r, act3_0_7_r;
  wire [2:0]  act3_1_0_r, act3_1_1_r, act3_1_2_r, act3_1_3_r, act3_1_4_r, act3_1_5_r, act3_1_6_r, act3_1_7_r;

  // Device Under Test
  iterative_controller dut (
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .done(done),

    .inputs0_1(inputs0_1), .inputs1_1(inputs1_1), .inputs2_1(inputs2_1), .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1), .inputs5_1(inputs5_1), .inputs6_1(inputs6_1), .inputs7_1(inputs7_1),
    .w1_0_1(w1_0_1), .w1_1_1(w1_1_1), .w2_0_1(w2_0_1), .w2_1_1(w2_1_1),
    .w3_0_1(w3_0_1), .w3_1_1(w3_1_1), .w4_0_1(w4_0_1), .w4_1_1(w4_1_1),
    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1),
    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2),
    .b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3),
    .b1_4(b1_4), .b2_4(b2_4), .b3_4(b3_4), .b4_4(b4_4),

    .w1_0_2(w1_0_2), .w1_1_2(w1_1_2), .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
    .w3_0_2(w3_0_2), .w3_1_2(w3_1_2), .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
    .w1_0_3(w1_0_3), .w1_1_3(w1_1_3), .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
    .w3_0_3(w3_0_3), .w3_1_3(w3_1_3), .w4_0_3(w4_0_3), .w4_1_3(w4_1_3),
    .w1_0_4(w1_0_4), .w1_1_4(w1_1_4), .w2_0_4(w2_0_4), .w2_1_4(w2_1_4),
    .w3_0_4(w3_0_4), .w3_1_4(w3_1_4), .w4_0_4(w4_0_4), .w4_1_4(w4_1_4),

    .act0_0_0_r(act0_0_0_r), .act0_0_1_r(act0_0_1_r), .act0_0_2_r(act0_0_2_r), .act0_0_3_r(act0_0_3_r),
    .act0_0_4_r(act0_0_4_r), .act0_0_5_r(act0_0_5_r), .act0_0_6_r(act0_0_6_r), .act0_0_7_r(act0_0_7_r),
    .act0_1_0_r(act0_1_0_r), .act0_1_1_r(act0_1_1_r), .act0_1_2_r(act0_1_2_r), .act0_1_3_r(act0_1_3_r),
    .act0_1_4_r(act0_1_4_r), .act0_1_5_r(act0_1_5_r), .act0_1_6_r(act0_1_6_r), .act0_1_7_r(act0_1_7_r),
    .act1_0_0_r(act1_0_0_r), .act1_0_1_r(act1_0_1_r), .act1_0_2_r(act1_0_2_r), .act1_0_3_r(act1_0_3_r),
    .act1_0_4_r(act1_0_4_r), .act1_0_5_r(act1_0_5_r), .act1_0_6_r(act1_0_6_r), .act1_0_7_r(act1_0_7_r),
    .act1_1_0_r(act1_1_0_r), .act1_1_1_r(act1_1_1_r), .act1_1_2_r(act1_1_2_r), .act1_1_3_r(act1_1_3_r),
    .act1_1_4_r(act1_1_4_r), .act1_1_5_r(act1_1_5_r), .act1_1_6_r(act1_1_6_r), .act1_1_7_r(act1_1_7_r),
    .act2_0_0_r(act2_0_0_r), .act2_0_1_r(act2_0_1_r), .act2_0_2_r(act2_0_2_r), .act2_0_3_r(act2_0_3_r),
    .act2_0_4_r(act2_0_4_r), .act2_0_5_r(act2_0_5_r), .act2_0_6_r(act2_0_6_r), .act2_0_7_r(act2_0_7_r),
    .act2_1_0_r(act2_1_0_r), .act2_1_1_r(act2_1_1_r), .act2_1_2_r(act2_1_2_r), .act2_1_3_r(act2_1_3_r),
    .act2_1_4_r(act2_1_4_r), .act2_1_5_r(act2_1_5_r), .act2_1_6_r(act2_1_6_r), .act2_1_7_r(act2_1_7_r),
    .act3_0_0_r(act3_0_0_r), .act3_0_1_r(act3_0_1_r), .act3_0_2_r(act3_0_2_r), .act3_0_3_r(act3_0_3_r),
    .act3_0_4_r(act3_0_4_r), .act3_0_5_r(act3_0_5_r), .act3_0_6_r(act3_0_6_r), .act3_0_7_r(act3_0_7_r),
    .act3_1_0_r(act3_1_0_r), .act3_1_1_r(act3_1_1_r), .act3_1_2_r(act3_1_2_r), .act3_1_3_r(act3_1_3_r),
    .act3_1_4_r(act3_1_4_r), .act3_1_5_r(act3_1_5_r), .act3_1_6_r(act3_1_6_r), .act3_1_7_r(act3_1_7_r)
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
    inputs0_1 = 3'd2; inputs1_1 = 3'd2; inputs2_1 = 3'd3; inputs3_1 = 3'd3;
    inputs4_1 = 3'd5; inputs5_1 = 3'd6; inputs6_1 = 3'd7; inputs7_1 = 3'd6;

    {w1_0_1,w2_0_1,w3_0_1,w4_0_1} = {4{8'hFF}};
    {w1_0_2,w2_0_2,w3_0_2,w4_0_2} = {4{8'hFF}};
    {w1_0_3,w2_0_3,w3_0_3,w4_0_3} = {4{8'hFF}};

    {w1_1_1, w2_1_1, w3_1_1, w4_1_1} = {4{8'h00}};
    {w1_1_2, w2_1_2, w3_1_2, w4_1_2} = {4{8'h00}};
    {w1_1_3, w2_1_3, w3_1_3, w4_1_3} = {4{8'h00}};

    {w1_0_4,w2_0_4,w3_0_4,w4_0_4} = {4{8'hFF}};
    {w1_1_4,w2_1_4,w3_1_4,w4_1_4} = {4{8'h00}};


    {b1_1,b2_1,b3_1,b4_1}         = {4{6'd0}};
    {b1_2,b2_2,b3_2,b4_2}         = {4{6'd1}};
    {b1_3,b2_3,b3_3,b4_3}         = {4{6'd0}};
    {b1_4,b2_4,b3_4,b4_4}         = {{6'd2},{6'd0},{6'd0},{6'd0}};

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
        $display("output1: %b %b ", dut.a0 , dut.a1);
        $display("output2: %b %b ", dut.a0_bar ,dut.a1_bar);
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
