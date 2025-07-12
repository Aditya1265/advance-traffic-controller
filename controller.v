module traffic_light_controller(
    input clk,
    input reset,
    input pred_NS,
    input pred_EW,
    input emergency_NS,
    input emergency_EW,
    output reg  [1:0] light_NS,
    output reg  [1:0] light_EW,
    output reg   pred_signal_NS,
    output reg   pred_signal_EW
);

parameter S0_NS_GREEN       = 3'd0;
parameter S1_NS_YELLOW      = 3'd1;
parameter S2_EW_GREEN       = 3'd2;
parameter S3_EW_YELLOW      = 3'd3;
parameter S4_EMERGENCY_NS   = 3'd4;
parameter S5_EMERGENCY_EW   = 3'd5;

reg [2:0] next_state, current_state;
reg [3:0] timer;

localparam GREEN_TIME      = 10;
localparam YELLOW_TIME     = 3;
localparam EMERGENCY_TIME  = 5;
localparam PED_EXTRA_TIME  = 3;

always @ (posedge clk or posedge reset)
begin
    if(reset)
    begin
        current_state <= S0_NS_GREEN;
        timer <= 0;
    end
    else
    begin
        if(
            (current_state == S0_NS_GREEN && timer == (pred_NS ? GREEN_TIME + PED_EXTRA_TIME : GREEN_TIME))||
            (current_state == S1_NS_YELLOW && timer == YELLOW_TIME)||
            (current_state == S2_EW_GREEN && timer == (pred_EW ? GREEN_TIME + PED_EXTRA_TIME : GREEN_TIME))||
            (current_state == S3_EW_YELLOW && timer == YELLOW_TIME)||
            (current_state == S4_EMERGENCY_NS && timer == EMERGENCY_TIME)||
            (current_state == S5_EMERGENCY_EW && timer == EMERGENCY_TIME)
        )
        begin
            current_state <= next_state;
            timer <= 0;
        end
        else
        begin
            timer <= timer+1;
        end
    end
end

always @ (*)
begin
    case(current_state)
    S0_NS_GREEN:
        if(emergency_EW)
            next_state = S5_EMERGENCY_EW;
        else
            next_state = S1_NS_YELLOW;

    S1_NS_YELLOW:
        if(emergency_EW)
            next_state = S5_EMERGENCY_EW;
        else
            next_state = S2_EW_GREEN;

    S2_EW_GREEN:
        if(emergency_NS)
            next_state = S4_EMERGENCY_NS;
        else
            next_state = S3_EW_YELLOW;

    S3_EW_YELLOW:
        if(emergency_NS)
            next_state = S4_EMERGENCY_NS;
        else
            next_state = S0_NS_GREEN;

    S4_EMERGENCY_NS:
        next_state = S2_EW_GREEN;

    S5_EMERGENCY_EW:            
        next_state = S0_NS_GREEN;

    default:       
        next_state = S0_NS_GREEN;
    endcase
end

always @ (*)
begin
    light_NS = 2'b00;
    light_EW = 2'b00;
    pred_signal_NS = 1'b0;
    pred_signal_EW = 1'b0;

    case(current_state)
    S0_NS_GREEN:begin
        light_NS = 2'b10;
        light_EW = 2'b00;
        pred_signal_NS = 1'b1;
    end
    S1_NS_YELLOW:begin
        light_NS = 2'b01;
        light_EW = 2'b00;
    end
    S2_EW_GREEN:begin
        light_NS = 2'b00;
        light_EW = 2'b10;
        pred_signal_EW = 1'b1;
    end
    S3_EW_YELLOW: begin
        light_NS = 2'b00;
        light_EW = 2'b01;
    end
    S4_EMERGENCY_NS : begin
        light_NS = 2'b10;
        light_EW = 2'b00;
    end
    S5_EMERGENCY_EW : begin
        light_NS = 2'b00;
        light_EW = 2'b10;
    end
    endcase
end 

endmodule
