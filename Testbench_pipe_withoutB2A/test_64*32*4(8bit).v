



`timescale 1ns/1ps
`default_nettype none

`include "t5.v"

module connector_tb;
  reg         clk;
reg [7:0] inputs0_1;
reg [7:0] inputs1_1;
reg [7:0] inputs2_1;
reg [7:0] inputs3_1;
reg [7:0] inputs4_1;
reg [7:0] inputs5_1;
reg [7:0] inputs6_1;
reg [7:0] inputs7_1;
reg [7:0] inputs8_1;
reg [7:0] inputs9_1;
reg [7:0] inputs10_1;
reg [7:0] inputs11_1;
reg [7:0] inputs12_1;
reg [7:0] inputs13_1;
reg [7:0] inputs14_1;
reg [7:0] inputs15_1;
reg [7:0] inputs16_1;
reg [7:0] inputs17_1;
reg [7:0] inputs18_1;
reg [7:0] inputs19_1;
reg [7:0] inputs20_1;
reg [7:0] inputs21_1;
reg [7:0] inputs22_1;
reg [7:0] inputs23_1;
reg [7:0] inputs24_1;
reg [7:0] inputs25_1;
reg [7:0] inputs26_1;
reg [7:0] inputs27_1;
reg [7:0] inputs28_1;
reg [7:0] inputs29_1;
reg [7:0] inputs30_1;
reg [7:0] inputs31_1;
reg [7:0] inputs32_1;
reg [7:0] inputs33_1;
reg [7:0] inputs34_1;
reg [7:0] inputs35_1;
reg [7:0] inputs36_1;
reg [7:0] inputs37_1;
reg [7:0] inputs38_1;
reg [7:0] inputs39_1;
reg [7:0] inputs40_1;
reg [7:0] inputs41_1;
reg [7:0] inputs42_1;
reg [7:0] inputs43_1;
reg [7:0] inputs44_1;
reg [7:0] inputs45_1;
reg [7:0] inputs46_1;
reg [7:0] inputs47_1;
reg [7:0] inputs48_1;
reg [7:0] inputs49_1;
reg [7:0] inputs50_1;
reg [7:0] inputs51_1;
reg [7:0] inputs52_1;
reg [7:0] inputs53_1;
reg [7:0] inputs54_1;
reg [7:0] inputs55_1;
reg [7:0] inputs56_1;
reg [7:0] inputs57_1;
reg [7:0] inputs58_1;
reg [7:0] inputs59_1;
reg [7:0] inputs60_1;
reg [7:0] inputs61_1;
reg [7:0] inputs62_1;
reg [7:0] inputs63_1;


// Layer-1 weights & biases
reg [63:0] w1_0_1, w1_1_1;
reg [63:0] w2_0_1, w2_1_1;
reg [63:0] w3_0_1, w3_1_1;
reg [63:0] w4_0_1, w4_1_1;
reg [63:0] w5_0_1, w5_1_1;
reg [63:0] w6_0_1, w6_1_1;
reg [63:0] w7_0_1, w7_1_1;
reg [63:0] w8_0_1, w8_1_1;
reg [63:0] w9_0_1, w9_1_1;
reg [63:0] w10_0_1, w10_1_1;
reg [63:0] w11_0_1, w11_1_1;
reg [63:0] w12_0_1, w12_1_1;
reg [63:0] w13_0_1, w13_1_1;
reg [63:0] w14_0_1, w14_1_1;
reg [63:0] w15_0_1, w15_1_1;
reg [63:0] w16_0_1, w16_1_1;
reg [63:0] w17_0_1, w17_1_1;
reg [63:0] w18_0_1, w18_1_1;
reg [63:0] w19_0_1, w19_1_1;
reg [63:0] w20_0_1, w20_1_1;
reg [63:0] w21_0_1, w21_1_1;
reg [63:0] w22_0_1, w22_1_1;
reg [63:0] w23_0_1, w23_1_1;
reg [63:0] w24_0_1, w24_1_1;
reg [63:0] w25_0_1, w25_1_1;
reg [63:0] w26_0_1, w26_1_1;
reg [63:0] w27_0_1, w27_1_1;
reg [63:0] w28_0_1, w28_1_1;
reg [63:0] w29_0_1, w29_1_1;
reg [63:0] w30_0_1, w30_1_1;
reg [63:0] w31_0_1, w31_1_1;
reg [63:0] w32_0_1, w32_1_1;
reg [13:0] b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1, b9_1, b10_1, b11_1, b12_1, b13_1, b14_1, b15_1, b16_1, b17_1, b18_1, b19_1, b20_1, b21_1, b22_1, b23_1, b24_1, b25_1, b26_1, b27_1, b28_1, b29_1, b30_1, b31_1, b32_1;

// Layer-2 weights & biases

reg [63:0] w1_0_2, w1_1_2;
reg [63:0] w2_0_2, w2_1_2;
reg [63:0] w3_0_2, w3_1_2;
reg [63:0] w4_0_2, w4_1_2;
reg [6:0] b1_2;
reg [6:0] b2_2;
reg [6:0] b3_2;
reg [6:0] b4_2;

// Final s
wire a0, a0_bar;
wire a1, a1_bar;
wire a2, a2_bar;
wire a3, a3_bar;


  // Instantiate DUT
  connector uut (
    // Inputs (0 to 15)
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
    .inputs16_1(inputs16_1),
    .inputs17_1(inputs17_1),
    .inputs18_1(inputs18_1),
    .inputs19_1(inputs19_1),
    .inputs20_1(inputs20_1),
    .inputs21_1(inputs21_1),
    .inputs22_1(inputs22_1),
    .inputs23_1(inputs23_1),
    .inputs24_1(inputs24_1),
    .inputs25_1(inputs25_1),
    .inputs26_1(inputs26_1),
    .inputs27_1(inputs27_1),
    .inputs28_1(inputs28_1),
    .inputs29_1(inputs29_1),
    .inputs30_1(inputs30_1),
    .inputs31_1(inputs31_1),
    .inputs32_1(inputs32_1),
    .inputs33_1(inputs33_1),
    .inputs34_1(inputs34_1),
    .inputs35_1(inputs35_1),
    .inputs36_1(inputs36_1),
    .inputs37_1(inputs37_1),
    .inputs38_1(inputs38_1),
    .inputs39_1(inputs39_1),
    .inputs40_1(inputs40_1),
    .inputs41_1(inputs41_1),
    .inputs42_1(inputs42_1),
    .inputs43_1(inputs43_1),
    .inputs44_1(inputs44_1),
    .inputs45_1(inputs45_1),
    .inputs46_1(inputs46_1),
    .inputs47_1(inputs47_1),
    .inputs48_1(inputs48_1),
    .inputs49_1(inputs49_1),
    .inputs50_1(inputs50_1),
    .inputs51_1(inputs51_1),
    .inputs52_1(inputs52_1),
    .inputs53_1(inputs53_1),
    .inputs54_1(inputs54_1),
    .inputs55_1(inputs55_1),
    .inputs56_1(inputs56_1),
    .inputs57_1(inputs57_1),
    .inputs58_1(inputs58_1),
    .inputs59_1(inputs59_1),
    .inputs60_1(inputs60_1),
    .inputs61_1(inputs61_1),
    .inputs62_1(inputs62_1),
    .inputs63_1(inputs63_1),
 

// Weights & Biases (for nodes 1–8, all sets)
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
    .w17_0_1(w17_0_1), .w17_1_1(w17_1_1),
    .w18_0_1(w18_0_1), .w18_1_1(w18_1_1),
    .w19_0_1(w19_0_1), .w19_1_1(w19_1_1),
    .w20_0_1(w20_0_1), .w20_1_1(w20_1_1),
    .w21_0_1(w21_0_1), .w21_1_1(w21_1_1),
    .w22_0_1(w22_0_1), .w22_1_1(w22_1_1),
    .w23_0_1(w23_0_1), .w23_1_1(w23_1_1),
    .w24_0_1(w24_0_1), .w24_1_1(w24_1_1),
    .w25_0_1(w25_0_1), .w25_1_1(w25_1_1),
    .w26_0_1(w26_0_1), .w26_1_1(w26_1_1),
    .w27_0_1(w27_0_1), .w27_1_1(w27_1_1),
    .w28_0_1(w28_0_1), .w28_1_1(w28_1_1),
    .w29_0_1(w29_0_1), .w29_1_1(w29_1_1),
    .w30_0_1(w30_0_1), .w30_1_1(w30_1_1),
    .w31_0_1(w31_0_1), .w31_1_1(w31_1_1),
    .w32_0_1(w32_0_1), .w32_1_1(w32_1_1),
    .b1_1(b1_1), .b2_1(b2_1), .b3_1(b3_1), .b4_1(b4_1), .b5_1(b5_1), .b6_1(b6_1), .b7_1(b7_1), .b8_1(b8_1), .b9_1(b9_1), .b10_1(b10_1), .b11_1(b11_1), .b12_1(b12_1), .b13_1(b13_1), .b14_1(b14_1), .b15_1(b15_1), .b16_1(b16_1), .b17_1(b17_1), .b18_1(b18_1), .b19_1(b19_1), .b20_1(b20_1), .b21_1(b21_1), .b22_1(b22_1), .b23_1(b23_1), .b24_1(b24_1), .b25_1(b25_1), .b26_1(b26_1), .b27_1(b27_1), .b28_1(b28_1), .b29_1(b29_1), .b30_1(b30_1), .b31_1(b31_1), .b32_1(b32_1),

    .w1_0_2(w1_0_2), .w1_1_2(w1_1_2),
    .w2_0_2(w2_0_2), .w2_1_2(w2_1_2),
    .w3_0_2(w3_0_2), .w3_1_2(w3_1_2),
    .w4_0_2(w4_0_2), .w4_1_2(w4_1_2),
    .b1_2(b1_2), .b2_2(b2_2), .b3_2(b3_2), .b4_2(b4_2), 

    .a0(a0), .a0_bar(a0_bar),
    .a1(a1), .a1_bar(a1_bar),
    .a2(a2), .a2_bar(a2_bar),
    .a3(a3), .a3_bar(a3_bar)
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

inputs0_1  = 8'd2;
inputs1_1  = 8'd2;
inputs2_1  = 8'd3;
inputs3_1  = 8'd3;

inputs4_1  = 8'd2;
inputs5_1  = 8'd2;
inputs6_1  = 8'd3;
inputs7_1  = 8'd3;

inputs8_1  = 8'd2;
inputs9_1  = 8'd2;
inputs10_1 = 8'd3;
inputs11_1 = 8'd3;

inputs12_1 = 8'd2;
inputs13_1 = 8'd2;
inputs14_1 = 8'd3;
inputs15_1 = 8'd3;

inputs16_1 = 8'd2;
inputs17_1 = 8'd2;
inputs18_1 = 8'd3;
inputs19_1 = 8'd3;

inputs20_1 = 8'd2;
inputs21_1 = 8'd2;
inputs22_1 = 8'd3;
inputs23_1 = 8'd3;

inputs24_1 = 8'd2;
inputs25_1 = 8'd2;
inputs26_1 = 8'd3;
inputs27_1 = 8'd3;

inputs28_1 = 8'd2;
inputs29_1 = 8'd2;
inputs30_1 = 8'd3;
inputs31_1 = 8'd3;

inputs32_1 = 8'd2;
inputs33_1 = 8'd2;
inputs34_1 = 8'd3;
inputs35_1 = 8'd3;

inputs36_1 = 8'd2;
inputs37_1 = 8'd2;
inputs38_1 = 8'd3;
inputs39_1 = 8'd3;

inputs40_1 = 8'd2;
inputs41_1 = 8'd2;
inputs42_1 = 8'd3;
inputs43_1 = 8'd3;

inputs44_1 = 8'd2;
inputs45_1 = 8'd2;
inputs46_1 = 8'd3;
inputs47_1 = 8'd3;

inputs48_1 = 8'd2;
inputs49_1 = 8'd2;
inputs50_1 = 8'd3;
inputs51_1 = 8'd3;

inputs52_1 = 8'd2;
inputs53_1 = 8'd2;
inputs54_1 = 8'd3;
inputs55_1 = 8'd3;

inputs56_1 = 8'd2;
inputs57_1 = 8'd2;
inputs58_1 = 8'd3;
inputs59_1 = 8'd3;

inputs60_1 = 8'd2;
inputs61_1 = 8'd2;
inputs62_1 = 8'd3;
inputs63_1 = 8'd3;


// Weights example pattern for 8 nodes (0th and 1st sets)
{w1_0_1, w2_0_1, w3_0_1, w4_0_1, w5_0_1, w6_0_1, w7_0_1, w8_0_1,
 w9_0_1, w10_0_1, w11_0_1, w12_0_1, w13_0_1, w14_0_1, w15_0_1, w16_0_1,
 w17_0_1, w18_0_1, w19_0_1, w20_0_1, w21_0_1, w22_0_1, w23_0_1, w24_0_1,
 w25_0_1, w26_0_1, w27_0_1, w28_0_1, w29_0_1, w30_0_1, w31_0_1, w32_0_1} = {32{64'b0000111111111111000011111111111100001111111111110000111111111111}};

{w1_0_2, w2_0_2, w3_0_2, w4_0_2} = {4{64'b0000111111111111000011111111111100001111111111110000111111111111}};


{w1_1_1, w2_1_1, w3_1_1, w4_1_1, w5_1_1, w6_1_1, w7_1_1, w8_1_1,
 w9_1_1, w10_1_1, w11_1_1, w12_1_1, w13_1_1, w14_1_1, w15_1_1, w16_1_1,
 w17_1_1, w18_1_1, w19_1_1, w20_1_1, w21_1_1, w22_1_1, w23_1_1, w24_1_1,
 w25_1_1, w26_1_1, w27_1_1, w28_1_1, w29_1_1, w30_1_1, w31_1_1, w32_1_1} = {32{3'b111}};

{w1_1_2, w2_1_2, w3_1_2, w4_1_2} = {4{64'b0000111111111111000011111111111100001111111111110000111111111111}};


{b1_1, b2_1, b3_1, b4_1, b5_1, b6_1, b7_1, b8_1, 
 b9_1, b10_1, b11_1, b12_1, b13_1, b14_1, b15_1, b16_1, 
 b17_1, b18_1, b19_1, b20_1, b21_1, b22_1, b23_1, b24_1, 
 b25_1, b26_1, b27_1, b28_1, b29_1, b30_1, b31_1, b32_1} = {32{13'd0}};

{b1_2, b2_2, b3_2, b4_2} = {7'd1,7'd2,7'd1,7'd1};


    // let pipeline settle
    wait_cycles(40);
$display("TV1 -> a0=%b a1=%b a0_bar=%b a1_bar=%b  a2=%b a3=%b a2_bar=%b a3_bar=%b ",
         a0, a1, a0_bar, a1_bar, a2, a3, a2_bar, a3_bar);




    $finish;
  end
endmodule
