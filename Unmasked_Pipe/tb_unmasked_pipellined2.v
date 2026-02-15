`timescale 1ns/1ps
`default_nettype none

`include "unmasked_pipellined2.v"

module connector_tb;
  // Layer-1 inputs
  reg         clk;
  reg  [7:0]  inputs0_1, inputs1_1, inputs2_1, inputs3_1;
  reg  [7:0]  inputs4_1, inputs5_1, inputs6_1, inputs7_1;
  reg  [7:0]  inputs8_1, inputs9_1, inputs10_1, inputs11_1;
  reg  [7:0]  inputs12_1, inputs13_1, inputs14_1, inputs15_1;

  // Share (m1) inputs
  reg [15:0] w1_1, w2_1, w3_1,  w4_1;
  reg [15:0] w5_1, w6_1, w7_1,  w8_1;
  reg [11:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1;
  reg [3:0]  b1_2, b2_2, b3_2, b4_2, b5_2, b6_2, b7_2, b8_2;
  reg [3:0]  b1_3, b2_3, b3_3, b4_3, b5_3, b6_3, b7_3, b8_3;
  reg [3:0]  b1_4, b2_4, b3_4, b4_4;

  // Share (m2) inputs
  reg [7:0] w1_2, w2_2,  w3_2,  w4_2;
  reg [7:0] w5_2, w6_2, w7_2,  w8_2;

  reg [7:0] w1_3,  w2_3,  w3_3,  w4_3;
  reg [7:0] w5_3, w6_3,  w7_3,  w8_3;

  reg [7:0] w1_4,  w2_4,  w3_4,  w4_4;

  // Outputs  (declare ALL that you map!)
  wire a0,  a1, a2,  a3;

  // DUT
  connector uut (
    .clk(clk),
    .inputs0_1(inputs0_1),  .inputs1_1(inputs1_1),  .inputs2_1(inputs2_1),  .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1),  .inputs5_1(inputs5_1),  .inputs6_1(inputs6_1),  .inputs7_1(inputs7_1),
    .inputs8_1(inputs8_1),  .inputs9_1(inputs9_1),  .inputs10_1(inputs10_1), .inputs11_1(inputs11_1),
    .inputs12_1(inputs12_1),.inputs13_1(inputs13_1),.inputs14_1(inputs14_1), .inputs15_1(inputs15_1),

    .w1_1(w1_1), .w2_1(w2_1), 
    .w3_1(w3_1),  .w4_1(w4_1), 
    .w5_1(w5_1),  .w6_1(w6_1), 
    .w7_1(w7_1),  .w8_1(w8_1), 

    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1),
    .b5_1(b5_1), .b6_1(b6_1), .b7_1(b7_1), .b8_1(b8_1),

    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2),
    .b5_2(b5_2), .b6_2(b6_2), .b7_2(b7_2), .b8_2(b8_2),

    .b1_3(b1_3), .b2_3(b2_3), .b3_3(b3_3), .b4_3(b4_3),
    .b5_3(b5_3), .b6_3(b6_3), .b7_3(b7_3), .b8_3(b8_3),

    .b1_4(b1_4), .b2_4(b2_4), .b3_4(b3_4), .b4_4(b4_4),

    .w1_2(w1_2),  .w2_2(w2_2), 
    .w3_2(w3_2),  .w4_2(w4_2), 
    .w5_2(w5_2),  .w6_2(w6_2), 
    .w7_2(w7_2),  .w8_2(w8_2), 

    .w1_3(w1_3),  .w2_3(w2_3), 
    .w3_3(w3_3),  .w4_3(w4_3), 
    .w5_3(w5_3),  .w6_3(w6_3), 
    .w7_3(w7_3),  .w8_3(w8_3), 

    .w1_4(w1_4), .w2_4(w2_4), 
    .w3_4(w3_4),  .w4_4(w4_4), 

    .a0(a0), 
    .a1(a1), 
    .a2(a2), 
    .a3(a3)
  );

  // clock
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

  // helper
  task automatic wait_cycles(input integer n);
    integer i;
    begin for (i = 0; i < n; i = i + 1) @(posedge clk); end
  endtask

  initial begin
    $dumpfile("connector_tb.vcd");
    $dumpvars(0, connector_tb);

    // inputs (use 8'd for 8-bit regs)
    inputs0_1  = 8'd2; inputs1_1  = 8'd2; inputs2_1  = 8'd3; inputs3_1  = 8'd3;
    inputs4_1  = 8'd5; inputs5_1  = 8'd6; inputs6_1  = 8'd7; inputs7_1  = 8'd6;
    inputs8_1  = 8'd1; inputs9_1  = 8'd7; inputs10_1 = 8'd3; inputs11_1 = 8'd2;
    inputs12_1 = 8'd5; inputs13_1 = 8'd7; inputs14_1 = 8'd0; inputs15_1 = 8'd1;

    // weights
    {w1_1,w2_1,w3_1,w4_1,w5_1,w6_1,w7_1,w8_1} = {8{16'b0000_1011_1101_1101}};
    {w1_2,w2_2,w3_2,w4_2,w5_2,w6_2,w7_2,w8_2} = {8{8'b0100_1111}};
    {w1_3,w2_3,w3_3,w4_3,w5_3,w6_3,w7_3,w8_3} = {8{8'b0110_1111}};
    

    // biases — **drive all of them**
    {b1_1,b2_1,b3_1,b4_1} = {4{12'd1}};
    {b5_1,b6_1,b7_1,b8_1} = {4{12'd0}};

    {b1_2,b2_2,b3_2,b4_2} = {4{4'd1}};
    {b5_2,b6_2,b7_2,b8_2} = {4{4'd5}};  // or 0 — but don’t leave X

    {b1_3,b2_3,b3_3,b4_3} = {4{4'd0}};
    {b5_3,b6_3,b7_3,b8_3} = {4{4'd1}};

    w1_4 = 8'b0001_1111; 
    w2_4 = 8'b1100_1111; 
    w3_4 = 8'b0110_1111; 
    w4_4 = 8'b1000_1111; 

    b1_4 = 4'd0; b2_4 = 4'd0; b3_4 = 4'd0; b4_4 = 4'd0;

    // let pipeline settle
    wait_cycles(40);

    $display("TV1 -> a0=%b a1=%b a2=%b  a3=%b ", a0, a1,  a2, a3 );

    $finish;
  end
endmodule