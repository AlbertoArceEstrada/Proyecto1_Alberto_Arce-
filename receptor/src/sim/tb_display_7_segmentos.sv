// tb_despliegue_7seg.sv
// Testbench para despliegue_7seg_catodo_comun
// Verifica los 16 valores hexadecimales con PASS/FAIL automático

`timescale 1ns/1ps

module tb_despliegue_7seg;

    logic [3:0] valor_hex;
    logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_dp;

    despliegue_7seg_catodo_comun uut (
        .valor_hex(valor_hex),
        .seg_a(seg_a), .seg_b(seg_b), .seg_c(seg_c), .seg_d(seg_d),
        .seg_e(seg_e), .seg_f(seg_f), .seg_g(seg_g), .seg_dp(seg_dp)
    );

    logic [6:0] esperado [0:15];

    initial begin
        esperado[0]  = 7'b1111110; // 0
        esperado[1]  = 7'b0110000; // 1
        esperado[2]  = 7'b1101101; // 2
        esperado[3]  = 7'b1111001; // 3
        esperado[4]  = 7'b0110011; // 4
        esperado[5]  = 7'b1011011; // 5
        esperado[6]  = 7'b1011111; // 6
        esperado[7]  = 7'b1110000; // 7
        esperado[8]  = 7'b1111111; // 8
        esperado[9]  = 7'b1111011; // 9
        esperado[10] = 7'b1110111; // A
        esperado[11] = 7'b0011111; // B
        esperado[12] = 7'b1001110; // C
        esperado[13] = 7'b0111101; // D
        esperado[14] = 7'b1001111; // E
        esperado[15] = 7'b1000111; // F

        $display("=== TB: despliegue_7seg_catodo_comun ===");

        for (int i = 0; i < 16; i++) begin
            valor_hex = i[3:0];
            #10;
            if ({seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} === esperado[i])
                $display("PASS | Hex=%X | segs=%07b | dp=%b",
                         valor_hex, {seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g}, seg_dp);
            else
                $display("FAIL | Hex=%X | segs=%07b (esperado=%07b) !!!",
                         valor_hex, {seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g}, esperado[i]);
        end

        $display("=== Fin del testbench ===");
        $finish;
    end

endmodule