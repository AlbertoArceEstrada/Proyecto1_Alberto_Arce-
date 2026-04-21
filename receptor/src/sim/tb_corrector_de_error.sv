// tb_correccion_error.sv
// Testbench para el módulo correccion_error
// Verifica que se corrige exactamente el bit indicado por el síndrome

`timescale 1ns/1ps

module tb_correccion_error;

    logic       P0, P1, P2, d1, P4, d2, d3, d4;
    logic [2:0] sindrome;
    logic [3:0] palabra_corregida;

    correccion_error uut (
        .P0(P0), .P1(P1), .P2(P2), .d1(d1),
        .P4(P4), .d2(d2), .d3(d3), .d4(d4),
        .sindrome(sindrome),
        .palabra_corregida(palabra_corregida)
    );

    task probar(
        input logic [7:0] entrada, // {P0,P1,P2,d1,P4,d2,d3,d4}
        input logic [2:0] sin,
        input logic [3:0] esperado,
        input string desc
    );
        {P0, P1, P2, d1, P4, d2, d3, d4} = entrada;
        sindrome = sin;
        #10;
        if (palabra_corregida === esperado)
            $display("PASS | %s | Corregida=%04b (esperado=%04b)", desc, palabra_corregida, esperado);
        else
            $display("FAIL | %s | Corregida=%04b (esperado=%04b) !!!", desc, palabra_corregida, esperado);
    endtask

    initial begin
        $display("=== TB: correccion_error ===");

        // Dato original d1=1,d2=0,d3=1,d4=1 → palabra_corregida esperada = 4'b1011
        // Síndrome 000: sin error → no cambia nada
        probar(8'b0_00_1_0_0_1_1, 3'b000, 4'b1011, "Sin error (000)         ");

        // Síndrome 011 → error en bit 3 = d1 → d1 se invierte (1→0)
        probar(8'b0_00_0_0_0_1_1, 3'b011, 4'b1011, "Error bit3 d1 (011)     ");

        // Síndrome 101 → error en bit 5 = d2 → d2 se invierte (1→0)
        probar(8'b0_00_1_0_1_1_1, 3'b101, 4'b1011, "Error bit5 d2 (101)     ");

        // Síndrome 110 → error en bit 6 = d3 → d3 se invierte (0→1)
        probar(8'b0_00_1_0_0_0_1, 3'b110, 4'b1011, "Error bit6 d3 (110)     ");

        // Síndrome 111 → error en bit 7 = d4 → d4 se invierte (0→1)
        probar(8'b0_00_1_0_0_1_0, 3'b111, 4'b1011, "Error bit7 d4 (111)     ");

        // Síndrome 001,010,100 → error en bits de paridad → datos sin cambio
        probar(8'b0_10_1_0_0_1_1, 3'b001, 4'b1011, "Error bit1 P1 (001)     ");
        probar(8'b0_01_1_0_0_1_1, 3'b010, 4'b1011, "Error bit2 P2 (010)     ");
        probar(8'b0_00_1_1_0_1_1, 3'b100, 4'b1011, "Error bit4 P4 (100)     ");

        $display("=== Fin del testbench ===");
        $finish;
    end

endmodule