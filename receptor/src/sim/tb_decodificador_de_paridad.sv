// tb_decodificador_paridad.sv
// Testbench para el módulo decodificador_paridad (SECDED)
// Prueba: sin error, error simple en cada bit, doble error

`timescale 1ns/1ps

module tb_decodificador_paridad;

    // Entradas
    logic P0, P1, P2, d1, P4, d2, d3, d4;

    // Salidas
    logic [2:0] sindrome;
    logic       doble_error;

    // Instancia del módulo bajo prueba
    decodificador_paridad uut (
        .P0(P0), .P1(P1), .P2(P2), .d1(d1),
        .P4(P4), .d2(d2), .d3(d3), .d4(d4),
        .sindrome(sindrome),
        .doble_error(doble_error)
    );

    // Tarea para aplicar una palabra y mostrar resultado
    task aplicar_palabra(
        input logic b_P0, b_P1, b_P2, b_d1, b_P4, b_d2, b_d3, b_d4,
        input string descripcion
    );
        {P0, P1, P2, d1, P4, d2, d3, d4} = {b_P0, b_P1, b_P2, b_d1, b_P4, b_d2, b_d3, b_d4};
        #10;
        $display("[%0t] %s | Entrada: P0=%b P1=%b P2=%b d1=%b P4=%b d2=%b d3=%b d4=%b | Sindrome=%03b | Doble_error=%b",
            $time, descripcion, P0, P1, P2, d1, P4, d2, d3, d4, sindrome, doble_error);
    endtask

    initial begin
        $display("=== TB: decodificador_paridad ===");
        $display("--- CASO 1: Palabra correcta (dato=1011, sin error) ---");
        // d1=1, d2=0, d3=1, d4=1 → Hamming(7,4)
        // P1 = d1^d2^d4 = 1^0^1 = 0
        // P2 = d1^d3^d4 = 1^1^1 = 1
        // P4 = d2^d3^d4 = 0^1^1 = 0
        // P0 = P1^P2^d1^P4^d2^d3^d4 = 0^1^1^0^0^1^1 = 0
        aplicar_palabra(0, 0, 1, 1, 0, 0, 1, 1, "Sin error        ");

        $display("--- CASO 2: Error en bit 1 (P1 invertido) ---");
        aplicar_palabra(0, 1, 1, 1, 0, 0, 1, 1, "Error en bit1(P1)");

        $display("--- CASO 3: Error en bit 2 (P2 invertido) ---");
        aplicar_palabra(0, 0, 0, 1, 0, 0, 1, 1, "Error en bit2(P2)");

        $display("--- CASO 4: Error en bit 3 (d1 invertido) ---");
        aplicar_palabra(0, 0, 1, 0, 0, 0, 1, 1, "Error en bit3(d1)");

        $display("--- CASO 5: Error en bit 4 (P4 invertido) ---");
        aplicar_palabra(0, 0, 1, 1, 1, 0, 1, 1, "Error en bit4(P4)");

        $display("--- CASO 6: Error en bit 5 (d2 invertido) ---");
        aplicar_palabra(0, 0, 1, 1, 0, 1, 1, 1, "Error en bit5(d2)");

        $display("--- CASO 7: Error en bit 6 (d3 invertido) ---");
        aplicar_palabra(0, 0, 1, 1, 0, 0, 0, 1, "Error en bit6(d3)");

        $display("--- CASO 8: Error en bit 7 (d4 invertido) ---");
        aplicar_palabra(0, 0, 1, 1, 0, 0, 1, 0, "Error en bit7(d4)");

        $display("--- CASO 9: Doble error (P1 y d1 invertidos) ---");
        aplicar_palabra(0, 1, 1, 0, 0, 0, 1, 1, "Doble error      ");

        $display("--- CASO 10: Doble error (d2 y d4 invertidos) ---");
        aplicar_palabra(0, 0, 1, 1, 0, 1, 1, 0, "Doble error 2    ");

        $display("=== Fin del testbench ===");
        $finish;
    end

endmodule