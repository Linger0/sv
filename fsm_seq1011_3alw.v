module fsm_seq1011_3alw (
  input      clk,
  input      clr,
  input      x,
  output reg z
);
  reg  [1:0] state, next_state;
  parameter S0 = 2'b00,
            S1 = 2'b01,
            S2 = 2'b10,
            S3 = 2'b11;

  always @(posedge clk or posedge clr) begin
    if (clr) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end

  always @(state or x) begin
    case (state)
      S0: if (x == 1'b0) next_state = S0; else next_state = S1;
      S1: if (x == 1'b0) next_state = S2; else next_state = S1;
      S2: if (x == 1'b0) next_state = S0; else next_state = S3;
      default: if (x == 1'b0) next_state = S2; else next_state = S1;
    endcase
  end

  always @(state or x) begin
    if (state==S3 && x==1'b1) begin
      z = 1;
    end else begin
      z = 0;
    end
  end

endmodule