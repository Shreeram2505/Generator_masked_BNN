`timescale 1ns/1ps
`default_nettype none

`include "pipellined1.v"

module connector_tb;
  // Layer‑1 inputs
  reg         clk;
  reg  [7:0] inputs0_1, inputs1_1, inputs2_1, inputs3_1;
  reg  [7:0] inputs4_1, inputs5_1, inputs6_1, inputs7_1;
  reg  [7:0] w1_0_1, w1_1_1, w2_0_1, w2_1_1;
  reg  [7:0] w3_0_1, w3_1_1, w4_0_1, w4_1_1;
  reg  [10:0] b1_1, b2_1, b3_1, b4_1;

  // Layer‑2 weights & biases
  reg  [7:0] w1_0_2, w1_1_2, w2_0_2, w2_1_2;
  reg  [7:0] w3_0_2, w3_1_2, w4_0_2, w4_1_2;
  reg  [3:0] b1_2, b2_2, b3_2, b4_2;

  // Layer‑3 weights & biases
  reg  [7:0] w1_0_3, w1_1_3, w2_0_3, w2_1_3;
  reg  [7:0] w3_0_3, w3_1_3, w4_0_3, w4_1_3;
  reg  [3:0] b1_3, b2_3, b3_3, b4_3;

  // Layer‑4 weights & biases
  reg  [7:0] w1_0_4, w1_1_4, w2_0_4, w2_1_4;
  reg  [3:0] b1_4, b2_4;

  // Outputs
  wire a0, a0_bar, a1, a1_bar;

  // Instantiate DUT
  connector uut (
    .clk(clk),
    .inputs0_1(inputs0_1), .inputs1_1(inputs1_1), .inputs2_1(inputs2_1), .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1), .inputs5_1(inputs5_1), .inputs6_1(inputs6_1), .inputs7_1(inputs7_1),
    .w1_0_1   (w1_0_1),    .w1_1_1   (w1_1_1),
    .w2_0_1   (w2_0_1),    .w2_1_1   (w2_1_1),
    .w3_0_1   (w3_0_1),    .w3_1_1   (w3_1_1),
    .w4_0_1   (w4_0_1),    .w4_1_1   (w4_1_1),
    .b1_1     (b1_1),      .b2_1     (b2_1),
    .b3_1     (b3_1),      .b4_1     (b4_1),

    .w1_0_2   (w1_0_2),    .w1_1_2   (w1_1_2),
    .w2_0_2   (w2_0_2),    .w2_1_2   (w2_1_2),
    .w3_0_2   (w3_0_2),    .w3_1_2   (w3_1_2),
    .w4_0_2   (w4_0_2),    .w4_1_2   (w4_1_2),
    .b1_2     (b1_2),      .b2_2     (b2_2),
    .b3_2     (b3_2),      .b4_2     (b4_2),

    .w1_0_3   (w1_0_3),    .w1_1_3   (w1_1_3),
    .w2_0_3   (w2_0_3),    .w2_1_3   (w2_1_3),
    .w3_0_3   (w3_0_3),    .w3_1_3   (w3_1_3),
    .w4_0_3   (w4_0_3),    .w4_1_3   (w4_1_3),
    .b1_3     (b1_3),      .b2_3     (b2_3),
    .b3_3     (b3_3),      .b4_3     (b4_3),

    .w1_0_4   (w1_0_4),    .w1_1_4   (w1_1_4),
    .w2_0_4   (w2_0_4),    .w2_1_4   (w2_1_4),
    .b1_4     (b1_4),      .b2_4     (b2_4),

    .a0       (a0),        .a0_bar   (a0_bar),
    .a1       (a1),        .a1_bar   (a1_bar)
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

    inputs0_1 = 8'd2; inputs1_1 = 8'd2; inputs2_1 = 8'd3; inputs3_1 = 8'd3;
    inputs4_1 = 8'd253; inputs5_1 = 8'd254; inputs6_1 = 8'd255; inputs7_1 = 8'd254;
    {w1_0_1,w2_0_1,w3_0_1,w4_0_1} = {4{8'h0F}};
    {w1_1_1, w2_1_1, w3_1_1, w4_1_1} = {4{8'h55}};

    {w1_0_2,w2_0_2,w3_0_2,w4_0_2} = {4{8'h34}};
    {w1_1_2,w2_1_2,w3_1_2,w4_1_2} = {4{8'hCC}};

    {w1_0_3,w2_0_3,w3_0_3,w4_0_3} = {4{8'h27}};
    {w1_1_3,w2_1_3,w3_1_3,w4_1_3} = {4{8'h88}};


    {b1_1,b2_1,b3_1,b4_1}         = {4{10'd0}};
    {b1_2,b2_2,b3_2,b4_2}         = {4{4'd1}};
    {b1_3,b2_3,b3_3,b4_3}         = {4{4'd0}};

    w1_0_4 = 8'h5A; 
    w1_1_4 = 8'h05;

    w2_0_4 = 8'h5A; 
    w2_1_4 = 8'h05;

    {b1_4,b2_4} = {4'd0,4'd0};


    // let pipeline settle
    wait_cycles(20);
    $display("TV1 -> a0=%b a1=%b a0_bar=%b a1_bar=%b", a0,a1,a0_bar,a1_bar);



    $finish;
  end
endmodule
