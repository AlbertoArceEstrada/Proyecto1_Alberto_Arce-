// tb_selector.sv
// Testbench para el módulo selector
// Verifica: ds1-ds4 (palabra), s8-s1 (síndrome), salida_display (mux y0-y3)

`timescale 1ns/1ps

module tb_selector;

    logic [3:0] palabra_corregida;
    logic [2:0] sindrome;
    logic       y0, y1, y2, y3;

    logic ds1, ds2, ds3, ds4;
    logic s8, s4, s2, s1;
    logic [3:0] salida_display;

    selector uut (
        .palabra_corregida(palabra_corregida),
        .sindrome(sindrome),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3),
        .ds1(ds1), .ds2(ds2), .ds3(ds3), .ds4(ds4),
        .s8(s8), .s4(s4), .s2(s2), .s1(s1),
        .salida_display(salida_display)
    );

    task probar(
        input logic [3:0] pal,
        input logic [2:0] sin,
        input logic b_y0, b_y1, b_y2, b_y3,
        input string desc
    );
        palabra_corregida = pal;
        sindrome          = sin;
        {y0, y1, y2, y3} = {b_y0, b_y1, b_y2, b_y3};
        #10;
        $display("[%s] pal=%04b sin=%03b | ds=%b%b%b%b s=%b%b%b%b | display=%04b",
            desc, pal, sin,
            ds1, ds2, ds3, ds4,
            s8, s4, s2, s1,
            salida_display);
    endtask

    initial begin
        $display("=== TB: selector ===");

        // MUX muestra síndrome: y=0111
        probar(4'b1011, 3'b011, 0,1,1,1, "MUX=sindrome(0111)");

        // MUX muestra palabra: y=1011
        probar(4'b1011, 3'b000, 1,0,1,1, "MUX=palabra (1011)");

        // Todos ceros
        probar(4'b0000, 3'b000, 0,0,0,0, "Todos ceros       ");

        // Todos unos
        probar(4'b1111, 3'b111, 1,1,1,1, "Todos unos        ");

        // Verificar que s8 siempre es 0
        probar(4'b1010, 3'b101, 1,0,1,0, "s8 debe ser 0     ");

        $display("=== Fin del testbench ===");
        $finish;
    end

endmodule