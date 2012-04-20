
module inferred_rom(clka, clkb, ena, enb, addra, addrb, doa, dob);
        input clka, clkb;
        input ena, enb;
        input [8:0] addra, addrb;
        output reg [31:0] doa, dob;
        reg [31:0] RAM [511:0];

        always @(negedge clka) begin
                if (ena) begin
                        doa <= RAM[addra];
                end
        end

        always @(negedge clkb) begin
                if (enb) begin
                        dob <= RAM[addrb];
                end
        end
endmodule
