This repo contains the RTL generator codes and its respective RTL codes and the test benches for testing.

#Three kinds of masked  BNN model generators have been created
1) Iterative Model ( Reuses the same adder trees and the lut components for the computations of ball the layers which is controlled by a controller): Reduced Area but bad Througput
2) Pipellined Model ( Uses unique adder tree and components for the respective layer computations ) :Faster Througput but Huge Area overhead
3) Pipellined Model  without B2A ( Uses unique adder tree and components for the respective layer computations  without the use of binary to arithmetic converters ) :Faster Througput but Huge Area overhead


