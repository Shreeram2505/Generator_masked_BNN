`timescale 1ns/1ns
`default_nettype none
`include "c14.v"


module connector_tb;

  // Layer-1 inputs
  reg  [2:0] inputs0_1,  inputs1_1,  inputs2_1,  inputs3_1;
  reg  [2:0] inputs4_1,  inputs5_1,  inputs6_1,  inputs7_1;
  reg  [2:0] inputs8_1,  inputs9_1,  inputs10_1, inputs11_1;
  reg  [2:0] inputs12_1, inputs13_1, inputs14_1, inputs15_1;

  // Layer-1 weights & biases
  reg [15:0] w1_0_1, w1_1_1;
  reg [15:0] w2_0_1, w2_1_1;
  reg [15:0] w3_0_1, w3_1_1;
  reg [15:0] w4_0_1, w4_1_1;
  reg [15:0] w5_0_1, w5_1_1;
  reg [15:0] w6_0_1, w6_1_1;
  reg [15:0] w7_0_1, w7_1_1;
  reg [15:0] w8_0_1, w8_1_1;
  reg  [6:0] b1_1, b2_1, b3_1, b4_1;
  reg  [6:0] b5_1, b6_1, b7_1, b8_1;

   // Layer-2 weights & biases
    reg [15:0] w1_0_2, w1_1_2;
    reg [15:0] w2_0_2, w2_1_2;
    reg [15:0] w3_0_2, w3_1_2;
    reg [15:0] w4_0_2, w4_1_2;
    reg [ 6:0] b1_2, b2_2, b3_2, b4_2;
    //layer3 output 
    reg [7:0] w1_0_3, w1_1_3;
    reg [7:0] w2_0_3, w2_1_3;
    reg [5:0] b1_3;
    reg [5:0] b2_3;

    // Outputs
    wire a0,   a0_bar;
    wire a1,   a1_bar;

  // instantiate UUT
  connector uut (
    // layer-1
    .inputs0_1(inputs0_1),  .inputs1_1(inputs1_1),
    .inputs2_1(inputs2_1),  .inputs3_1(inputs3_1),
    .inputs4_1(inputs4_1),  .inputs5_1(inputs5_1),
    .inputs6_1(inputs6_1),  .inputs7_1(inputs7_1),
    .inputs8_1(inputs8_1),  .inputs9_1(inputs9_1),
    .inputs10_1(inputs10_1),.inputs11_1(inputs11_1),
    .inputs12_1(inputs12_1),.inputs13_1(inputs13_1),
    .inputs14_1(inputs14_1),.inputs15_1(inputs15_1),

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

    // layer-2
    .w1_0_2(w1_0_2), .w1_1_2(w1_1_2),
    .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
    .w3_0_2(w3_0_2), .w3_1_2(w3_1_2),
    .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2),

    // layer-3
    .w1_0_3(w1_0_3), .w1_1_3(w1_1_3),
    .w2_0_3(w2_0_3), .w2_1_3(w2_1_3),
    .b1_3(b1_3),     .b2_3(b2_3),

    // final outputs
    .a0(a0), .a0_bar(a0_bar),
    .a1(a1), .a1_bar(a1_bar)
  );

  initial begin
    // example stimulus
    inputs0_1 = 3'd3;  inputs1_1 = 3'd5;  inputs2_1 = 3'd7;  inputs3_1 = 3'd1;
    inputs4_1 = 3'd0;  inputs5_1 = 3'd2;  inputs6_1 = 3'd0;  inputs7_1 = 3'd6;
    inputs8_1 = 3'd3;  inputs9_1 = 3'd5;  inputs10_1= 3'd7;  inputs11_1= 3'd1;
    inputs12_1= 3'd0;  inputs13_1= 3'd2;  inputs14_1= 3'd0;  inputs15_1= 3'd6;



    w1_0_1 = 16'hB696;  w1_1_1 = 16'h0000; // 1011_0110_1001_0110
    w2_0_1 = 16'h6749;  w2_1_1 = 16'h0000; // 0110_0111_0100_1001
    w3_0_1 = 16'hCD25;  w3_1_1 = 16'h0000; // 1100_1101_0010_0101
    w4_0_1 = 16'h3A76;  w4_1_1 = 16'h0000; // 0011_1010_0111_0110
    w5_0_1 = 16'hF392;  w5_1_1 = 16'h0000; // 1111_0011_1001_0010
    w6_0_1 = 16'h8B3A;  w6_1_1 = 16'h0000; // 1000_1011_0011_1010
    w7_0_1 = 16'h5C6B;  w7_1_1 = 16'h0000; // 0101_1100_0110_1011
    w8_0_1 = 16'hC379;  w8_1_1 = 16'h0000; // 1100_0011_0111_1001

    
    b1_1 = 7'd1; b2_1 = 7'd0; b3_1 = 7'd1; b4_1 = 7'd0;
    b5_1 = 7'd1; b6_1 = 7'd0; b7_1 = 7'd0; b8_1 = 7'd1;                                        

    // Row 1 = 1011 0110 1011 0110 = 0xB6B6
    //w1_0_2 = 16'hB6B6;  
    //w1_1_2 = 16'h0000;
    w1_0_2 = 16'h5B0B; 
    w1_1_2 = 16'h5B0B;

    // Row 2 = 0110 0111 0110 0111 = 0x6767
    //w2_0_2 = 16'h6767;  
    //w2_1_2 = 16'h0000;
    w2_0_2 = 16'h3393; 
    w2_1_2 = 16'h3394;

    // Row 3 = 1100 1101 1100 1101 = 0xCDCD
    //w3_0_2 = 16'hCDCD;  
    //w3_1_2 = 16'h0000;
    w3_0_2 = 16'h66BE;  // 26302
    w3_1_2 = 16'h66BF;  // 26303

    // Row 4 = 0011 1010 0011 1010 = 0x3A3A
    w4_0_2 = 16'h3A3A;  
    w4_1_2 = 16'h0000;


    b1_2 = 7'd1; b2_2 = 7'd0; b3_2 = 7'd1; b4_2 = 7'd0;

    w1_0_3 = 8'hFF;  
    w1_1_3 = 8'h00;  

    w2_0_3 = 8'hFF;  
    w2_1_3 = 8'h00;  

    b1_3 = 6'd0;     b2_3 = 6'd1;

    #5;
    $display("RESULTS: a0=%b a0_bar=%b | a1=%b a1_bar=%b", a0,a0_bar,a1,a1_bar);
    #5 $finish;
  end

endmodule

`default_nettype wire
