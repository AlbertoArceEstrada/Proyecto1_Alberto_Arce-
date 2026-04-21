// tb_receptor_top.sv
// Testbench de integración completa del receptor SECDED[8,4]
// Ejercita el sistema completo: sin error, error simple, doble error

`timescale 1ns/1ps

module tb_receptor_top;

    // Entradas físicas
    logic P0, P1, P2, d1_in, P4, d2_in, d3_in, d4_in;
    logic y0, y1, y2, y3;

    // Salidas
    logic ds1, ds2, ds3, ds4;
    logic s8, s4, s2, s1;
    logic led0, led1, led2, led3, led4, led5;
    logic led_doble_error;
    logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_dp;

    // DUT
    receptor_top uut (
        .P0(P0), .P1(P1), .P2(P2), .d1_in(d1_in),
        .P4(P4), .d2_in(d2_in), .d3_in(d3_in), .d4_in(d4_in),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3),
        .ds1(ds1), .ds2(ds2), .ds3(ds3), .ds4(ds4),
        .s8(s8), .s4(s4), .s2(s2), .s1(s1),
        .led0(led0), .led1(led1), .led2(led2), .led3(led3),
        .led4(led4), .led5(led5),
        .led_doble_error(led_doble_error),
        .seg_a(seg_a), .seg_b(seg_b), .seg_c(seg_c), .seg_d(seg_d),
        .seg_e(seg_e), .seg_f(seg_f), .seg_g(seg_g), .seg_dp(seg_dp)
    );

    task aplicar(
        input logic b_P0, b_P1, b_P2, b_d1, b_P4, b_d2, b_d3, b_d4,
        input logic b_y0, b_y1, b_y2, b_y3,
        input string desc
    );
        {P0,P1,P2,d1_in,P4,d2_in,d3_in,d4_in} = {b_P0,b_P1,b_P2,b_d1,b_P4,b_d2,b_d3,b_d4};
        {y0,y1,y2,y3} = {b_y0,b_y1,b_y2,b_y3};
        #20;
        $display("--- %s ---", desc);
        $display("  Entrada   : P0=%b P1=%b P2=%b d1=%b P4=%b d2=%b d3=%b d4=%b",
                  P0,P1,P2,d1_in,P4,d2_in,d3_in,d4_in);
        $display("  LEDs dato : %b%b%b%b (d1 d2 d3 d4)",led3,led2,led1,led0);
        $display("  Sindrome  : s4=%b s2=%b s1=%b", s4,s2,s1);
        $display("  Display   : segs=%b%b%b%b%b%b%b", seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g);
        $display("  Doble err : %b", led_doble_error);
        $display("");
    endtask

    initial begin
        $display("========================================");
        $display("  TB INTEGRACIÓN: receptor_top SECDED  ");
        $display("========================================\n");

        // ── Dato: d1=1,d2=0,d3=1,d4=1 (1011)
        // Paridad correcta: P1=0, P2=1, P4=0, P0=0
        // MUX y = palabra corregida 1011

        aplicar(0,0,1,1,0,0,1,1, 1,0,1,1,
                "1) Sin error | dato=1011 | MUX=palabra");

        // ── Error en d1 (bit 3, síndrome=011)
        aplicar(0,0,1,0,0,0,1,1, 0,0,1,1,
                "2) Error en d1 | dato=0011 recibido | esperado corregido=1011");

        // ── Error en d2 (bit 5, síndrome=101)
        aplicar(0,0,1,1,0,1,1,1, 0,1,0,1,
                "3) Error en d2 | MUX=sindrome(0101)");

        // ── Error en d3 (bit 6, síndrome=110)
        aplicar(0,0,1,1,0,0,0,1, 0,1,1,0,
                "4) Error en d3 | MUX=sindrome(0110)");

        // ── Error en d4 (bit 7, síndrome=111)
        aplicar(0,0,1,1,0,0,1,0, 0,1,1,1,
                "5) Error en d4 | MUX=sindrome(0111)");

        // ── Doble error: P1 y d1 invertidos
        aplicar(0,1,1,0,0,0,1,1, 0,0,0,0,
                "6) DOBLE ERROR | led_doble_error debe=1");

        // ── Dato todo ceros (0000)
        // P1=0^0^0=0, P2=0^0^0=0, P4=0^0^0=0, P0=0
        aplicar(0,0,0,0,0,0,0,0, 0,0,0,0,
                "7) Dato=0000 sin error | display debe mostrar 0");

        // ── Dato todo unos (1111)
        // P1=1^1^1=1, P2=1^1^1=1, P4=1^1^1=1, P0=1^1^1^1^1^1^1=1
        aplicar(1,1,1,1,1,1,1,1, 1,1,1,1,
                "8) Dato=1111 sin error | display debe mostrar F");

        $display("========================================");
        $display("  Fin del testbench de integración     ");
        $display("========================================");
        $finish;
    end

endmodule