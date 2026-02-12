`timescale 1ns/1ps
`default_nettype none

`include "unmasked_pipellined1.v"

module connector_tb;
  // Layer‑1 inputs
  reg         clk;
  reg  [7:0] inputs0_1, inputs1_1, inputs2_1, inputs3_1;
  reg  [7:0] inputs4_1, inputs5_1, inputs6_1, inputs7_1;
  reg  [7:0] w1_1, w2_1;
  reg  [7:0] w3_1,  w4_1;
  reg  [10:0] b1_1, b2_1, b3_1, b4_1;

  // Layer‑2 weights & biases
  reg  [3:0] w1_2,  w2_2;
  reg  [3:0] w3_2,  w4_2;
  reg  [2:0] b1_2, b2_2, b3_2, b4_2;

  // Layer‑3 weights & biases
  reg  [3:0] w1_3, w2_3;
  reg  [3:0] w3_3, w4_3;
  reg  [2:0] b1_3, b2_3, b3_3, b4_3;

  // Layer‑4 weights & biases
  reg  [3:0] w1_4, w2_4;
  reg  [2:0] b1_4, b2_4;

  // Outputs
  wire a0,  a1;

  // Instantiate DUT
  connector uut (
    .clk(clk),
    .inputs0_1(inputs0_1), .inputs1_1(inputs1_1), .inputs2_1(inputs2_1), .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1), .inputs5_1(inputs5_1), .inputs6_1(inputs6_1), .inputs7_1(inputs7_1),
    .w1_1   (w1_1),    
    .w2_1   (w2_1),   
    .w3_1   (w3_1),    
    .w4_1   (w4_1),    
    .b1_1     (b1_1),      .b2_1     (b2_1),
    .b3_1     (b3_1),      .b4_1     (b4_1),

    .w1_2   (w1_2),    
    .w2_2   (w2_2),    
    .w3_2   (w3_2),    
    .w4_2   (w4_2),    
    .b1_2     (b1_2),      .b2_2     (b2_2),
    .b3_2     (b3_2),      .b4_2     (b4_2),

    .w1_3   (w1_3),   
    .w2_3   (w2_3),  
    .w3_3   (w3_3),   
    .w4_3   (w4_3),  
    .b1_3     (b1_3),      .b2_3     (b2_3),
    .b3_3     (b3_3),      .b4_3     (b4_3),

    .w1_4   (w1_4),   
    .w2_4   (w2_4),  
    .b1_4     (b1_4),      .b2_4     (b2_4),

    .a0       (a0),        
    .a1       (a1)
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
    {w1_1,w2_1,w3_1,w4_1} = {4{8'h0F}};

    {w1_2,w2_2,w3_2,w4_2} = {4{4'h0}};
    {w1_3,w2_3,w3_3,w4_3} = {4{4'hF}};


    {b1_1,b2_1,b3_1,b4_1}         = {4{10'd0}};
    {b1_2,b2_2,b3_2,b4_2}         = {4{3'd1}};
    {b1_3,b2_3,b3_3,b4_3}         = {4{3'd0}};

    w1_4 = 4'hF;
    w2_4 = 4'hF; 

    {b1_4,b2_4} = {3'd0,3'd0};


    // let pipeline settle
    wait_cycles(20);
    $display("TV1 -> a0=%b a1=%b ", a0, a1);



    $finish;
  end
endmodule