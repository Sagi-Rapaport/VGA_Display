module VGA_top ( // VGA(60Hz) 640x480
    input  logic clk, // 50 MHz
    input  logic reset, // SW[0]
    output logic H_sync,
    output logic V_sync,
    output logic [3:0] Red,
    output logic [3:0] Green,
    output logic [3:0] Blue
);

    logic clk_pixel;
    logic enable_V_Counter;
    logic [9:0] H_Count_Value;
    logic [9:0] V_Count_Value;
    logic locked_sig; 
    logic system_reset; 

    assign system_reset = reset | (~locked_sig); // when external reset or ~locked_sig are high '1' 

PLL PLL_inst ( 
	.areset (0), // Active High
	.inclk0 (clk), // 50 MHz 
	.c0 (clk_pixel), // 25 MHz
	.locked (locked_sig)
);

horizontal_counter VGA_Horiz (
    .clk_pixel(clk_pixel),
    .reset(system_reset), 
    .enable_V_Counter(enable_V_Counter),
    .H_Count_Value(H_Count_Value)
);

vertical_counter VGA_Verti (
    .clk_pixel(clk_pixel),
    .reset(system_reset), 
    .enable_V_Counter(enable_V_Counter),
    .V_Count_Value(V_Count_Value)
);

VGA_pattern_generator VGA_pattern_gen (
    .H_Count_Value(H_Count_Value),
    .V_Count_Value(V_Count_Value),
    .Red(Red),
    .Green(Green),
    .Blue(Blue)
);

    // outputs
    assign H_sync = (H_Count_Value < 96) ? 1'b0 : 1'b1;
    assign V_sync = (V_Count_Value < 2) ? 1'b0 : 1'b1;
    
endmodule

module VGA_pattern_generator ( 
    input  logic [9:0] H_Count_Value,
    input  logic [9:0] V_Count_Value,
    output logic [3:0] Red,
    output logic [3:0] Green,
    output logic [3:0] Blue
);

    // colors logic
    always_comb begin
        if (H_Count_Value < 224 && H_Count_Value > 143 && V_Count_Value < 515 && V_Count_Value > 34) begin
            Red = 4'hf;
            Green = 4'hf;
            Blue = 4'hf;
        end
        else if (H_Count_Value < 304 && H_Count_Value > 223 && V_Count_Value < 515 && V_Count_Value > 34) begin
            Red = 4'hf;
            Green = 4'h0;
            Blue = 4'h0;
        end
        else if (H_Count_Value < 384 && H_Count_Value > 303 && V_Count_Value < 515 && V_Count_Value > 34) begin
            Red = 4'h0;
            Green = 4'hf;
            Blue = 4'h0;
        end
        else if (H_Count_Value < 464 && H_Count_Value > 383 && V_Count_Value < 515 && V_Count_Value > 34) begin
            Red = 4'h0;
            Green = 4'h0;
            Blue = 4'hf;
        end
        else if (H_Count_Value < 544 && H_Count_Value > 463 && V_Count_Value < 515 && V_Count_Value > 34) begin
            Red = 4'h0;
            Green = 4'h0;
            Blue = 4'h0;
        end
        else if (H_Count_Value < 624 && H_Count_Value > 543 && V_Count_Value < 515 && V_Count_Value > 34) begin
            Red = 4'hf;
            Green = 4'hf;
            Blue = 4'h0;
        end
        else if (H_Count_Value < 704 && H_Count_Value > 623 && V_Count_Value < 515 && V_Count_Value > 34) begin
            Red = 4'hf;
            Green = 4'h0;
            Blue = 4'hf;
        end
        else if (H_Count_Value < 784 && H_Count_Value > 703 && V_Count_Value < 515 && V_Count_Value > 34) begin
            Red = 4'h0;
            Green = 4'hf;
            Blue = 4'hf;
        end
        else begin // default: black
            Red = 4'h0;
            Green = 4'h0;
            Blue = 4'h0;
        end
    end
  
endmodule

module horizontal_counter (
    input  logic clk_pixel, // 25 MHz
    input  logic reset,
    output logic enable_V_Counter,
    output logic [9:0] H_Count_Value
);

    always_ff @(posedge clk_pixel) begin
        if (reset) begin
            H_Count_Value <= 0;
            enable_V_Counter <= 0;
        end
        else if (H_Count_Value < 799) begin // keep counting until 799
            H_Count_Value <= H_Count_Value + 1;
            enable_V_Counter <= 0; // disable vertical counter
        end
        else begin
            H_Count_Value <= 0; // reset horizontal_counter
            enable_V_Counter <= 1; // trigger V counter
        end
    end
    
endmodule

module vertical_counter (
    input  logic clk_pixel, // 25 MHz
    input  logic reset,
    input  logic enable_V_Counter,
    output logic [9:0] V_Count_Value
);

    always_ff @(posedge clk_pixel) begin
        if (reset) begin
            V_Count_Value <= 0;
        end
        else if (enable_V_Counter == 1'b1) begin
            if (V_Count_Value < 524) begin // keep counting until 524
                V_Count_Value <= V_Count_Value + 1;
            end
            else begin
                V_Count_Value <= 0; // reset vertical counter
            end
        end
    end
    
endmodule