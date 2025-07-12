`timescale 1ns/1ps

module tb_traffic_light_controller;

    reg clk;
    reg reset;
    reg pred_NS;
    reg pred_EW;
    reg emergency_NS;
    reg emergency_EW;
    wire [1:0] light_NS;
    wire [1:0] light_EW;
    wire pred_signal_NS;
    wire pred_signal_EW;

    traffic_light_controller dut (
        .clk(clk),
        .reset(reset),
        .pred_NS(pred_NS),
        .pred_EW(pred_EW),
        .emergency_NS(emergency_NS),
        .emergency_EW(emergency_EW),
        .light_NS(light_NS),
        .light_EW(light_EW),
        .pred_signal_NS(pred_signal_NS),
        .pred_signal_EW(pred_signal_EW)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("traffic_light.vcd");
        $dumpvars(0, tb_traffic_light_controller);

        clk = 0;
        reset = 1;
        pred_NS = 0;
        pred_EW = 0;
        emergency_NS = 0;
        emergency_EW = 0;

        #20 reset = 0;

        #50 pred_NS = 1;
        #100 pred_NS = 0;

        #100 emergency_EW = 1;
        #50 emergency_EW = 0;

        #200 pred_EW = 1;
        #100 pred_EW = 0;

        #100 emergency_NS = 1;
        #50 emergency_NS = 0;

        #300 $finish;
    end

endmodule
