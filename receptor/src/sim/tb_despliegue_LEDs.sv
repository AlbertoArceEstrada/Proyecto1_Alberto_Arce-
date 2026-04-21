// tb_despliegue_leds.sv
// Testbench para el módulo despliegue_leds
// Verifica que cada LED corresponde al bit correcto de palabra_corregida
// y que led4/led5 siempre están apagados

`timescale 1ns/1ps

module tb_despliegue_leds;

    logic [3:0] palabra_corregida;
    logic led0, led1, led2, led3, led4, led5;

    despliegue_leds uut (
        .palabra_corregida(palabra_corregida),
        .led0(led0), .led1(led1), .led2(led2), .led3(led3),
        .led4(led4), .led5(led5)
    );

    task probar(input logic [3:0] pal);
        palabra_corregida = pal;
        #10;
        if (led3 === pal[3] && led2 === pal[2] && led1 === pal[1] && led0 === pal[0]
            && led4 === 1'b0 && led5 === 1'b0)
            $display("PASS | palabra=%04b | led3(d1)=%b led2(d2)=%b led1(d3)=%b led0(d4)=%b | led4=%b led5=%b",
                     pal, led3, led2, led1, led0, led4, led5);
        else
            $display("FAIL | palabra=%04b | led3=%b led2=%b led1=%b led0=%b | led4=%b led5=%b  !!!",
                     pal, led3, led2, led1, led0, led4, led5);
    endtask

    initial begin
        $display("=== TB: despliegue_leds ===");

        // Recorre los 16 valores posibles
        for (int i = 0; i < 16; i++)
            probar(i[3:0]);

        $display("=== Fin del testbench ===");
        $finish;
    end

endmodule