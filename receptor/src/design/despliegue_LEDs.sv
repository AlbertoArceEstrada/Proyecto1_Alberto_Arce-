// despliegue_leds.sv
// Muestra la palabra corregida en los LEDs de la FPGA
// Pines: led0(10), led1(11), led2(13), led3(14), led4(?), led5(?)
// Los LEDs 4 y 5 se dejan apagados si no se usan.

module despliegue_leds (
    input  logic [3:0] palabra_corregida,
    output logic       led0,
    output logic       led1,
    output logic       led2,
    output logic       led3,
    output logic       led4,   // opcional, se puede conectar a 0
    output logic       led5    // opcional
);

    assign led0 = palabra_corregida[0]; // d4
    assign led1 = palabra_corregida[1]; // d3
    assign led2 = palabra_corregida[2]; // d2
    assign led3 = palabra_corregida[3]; // d1

    // Si no se usan, se apagan
    assign led4 = 1'b0;
    assign led5 = 1'b0;

endmodule