// correccion_error.sv
// Corrige un error simple en la palabra de datos (d1,d2,d3,d4)
// basado en el síndrome. Solo actúa si el síndrome indica posición 1-7
// y la paridad global está equivocada (eso lo maneja el módulo superior).

module correccion_error (
    input  logic       P0, P1, P2, d1, P4, d2, d3, d4,
    input  logic [2:0] sindrome,           // {S4,S2,S1}
    output logic [3:0] palabra_corregida   // {d1, d2, d3, d4}
);

    // Señales de corrección por bit (activas en alto)
    logic corregir_bit1, corregir_bit2, corregir_bit3, corregir_bit4,
          corregir_bit5, corregir_bit6, corregir_bit7;

    // Decodificador de posición (1 a 7) a partir del síndrome
    assign corregir_bit1 = ~sindrome[2] & ~sindrome[1] &  sindrome[0]; // 001 -> bit 1 (P1)
    assign corregir_bit2 = ~sindrome[2] &  sindrome[1] & ~sindrome[0]; // 010 -> bit 2 (P2)
    assign corregir_bit3 = ~sindrome[2] &  sindrome[1] &  sindrome[0]; // 011 -> bit 3 (d1)
    assign corregir_bit4 =  sindrome[2] & ~sindrome[1] & ~sindrome[0]; // 100 -> bit 4 (P4)
    assign corregir_bit5 =  sindrome[2] & ~sindrome[1] &  sindrome[0]; // 101 -> bit 5 (d2)
    assign corregir_bit6 =  sindrome[2] &  sindrome[1] & ~sindrome[0]; // 110 -> bit 6 (d3)
    assign corregir_bit7 =  sindrome[2] &  sindrome[1] &  sindrome[0]; // 111 -> bit 7 (d4)

    // Bits de datos originales
    logic d1_original, d2_original, d3_original, d4_original;
    assign d1_original = d1;
    assign d2_original = d2;
    assign d3_original = d3;
    assign d4_original = d4;

    // Corrección por XOR (si la señal correspondiente está activa, se invierte)
    assign palabra_corregida[3] = d1_original ^ corregir_bit3;
    assign palabra_corregida[2] = d2_original ^ corregir_bit5;
    assign palabra_corregida[1] = d3_original ^ corregir_bit6;
    assign palabra_corregida[0] = d4_original ^ corregir_bit7;

endmodule