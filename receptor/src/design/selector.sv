module selector (
    input  logic [3:0] palabra_corregida, // {d1, d2, d3, d4}
    input  logic [2:0] sindrome,
    input  logic       y0, y1, y2, y3,

    output logic ds1, ds2, ds3, ds4,
    output logic s8, s4, s2, s1,

    output logic [3:0] salida_display
);

    // Datos corregidos hacia MUX externo
    assign ds1 = palabra_corregida[3]; // d1 (MSB)
    assign ds2 = palabra_corregida[2];
    assign ds3 = palabra_corregida[1];
    assign ds4 = palabra_corregida[0]; // d4 (LSB)

    // Síndrome extendido
    assign s8 = 1'b0;
    assign s4 = sindrome[2];
    assign s2 = sindrome[1];
    assign s1 = sindrome[0];

    //  CORREGIDO: y0 = MSB, y3 = LSB
    assign salida_display = {y0, y1, y2, y3};
   
    
endmodule