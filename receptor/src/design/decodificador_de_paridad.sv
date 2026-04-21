// decodificador_paridad.sv
// Calcula el síndrome (S4,S2,S1) y detecta doble error
// Entradas: palabra codificada de 8 bits en orden: P0,P1,P2,d1,P4,d2,d3,d4
// Síndrome = 000 indica que no hay error (corrección aplicada)
// doble_error se activa cuando síndrome != 0 y paridad global par (0)

module decodificador_paridad (
    input  logic P0, P1, P2, d1, P4, d2, d3, d4,
    output logic [2:0] sindrome,    // {S4, S2, S1}
    output logic       doble_error
);

    // Cálculo del síndrome según Hamming (7,4) extendido
    // S1 = P1 ^ d1 ^ d2 ^ d4
    // S2 = P2 ^ d1 ^ d3 ^ d4
    // S4 = P4 ^ d2 ^ d3 ^ d4
    assign sindrome[0] = P1 ^ d1 ^ d2 ^ d4;   // S1
    assign sindrome[1] = P2 ^ d1 ^ d3 ^ d4;   // S2
    assign sindrome[2] = P4 ^ d2 ^ d3 ^ d4;   // S4

    // Paridad global recibida (XOR de los 8 bits) – debe ser 0 en paridad par
    logic paridad_global;
    assign paridad_global = P0 ^ P1 ^ P2 ^ d1 ^ P4 ^ d2 ^ d3 ^ d4;

    // Doble error: síndrome distinto de cero y paridad global correcta (par = 0)
    assign doble_error = (sindrome != 3'b000) & ~paridad_global;

endmodule