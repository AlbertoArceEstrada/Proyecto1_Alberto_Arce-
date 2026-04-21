module despliegue_7seg_catodo_comun (
    input  logic [3:0] valor_hex,
    output logic seg_a,
    output logic seg_b,
    output logic seg_c,
    output logic seg_d,
    output logic seg_e,
    output logic seg_f,
    output logic seg_g,
    output logic seg_dp
);

    // Tabla correcta (1 = encendido)
    assign {seg_a,seg_b,seg_c,seg_d,seg_e,seg_f,seg_g} =
        (valor_hex == 4'h0) ? 7'b1111110 :
        (valor_hex == 4'h1) ? 7'b0110000 :
        (valor_hex == 4'h2) ? 7'b1101101 :
        (valor_hex == 4'h3) ? 7'b1111001 :
        (valor_hex == 4'h4) ? 7'b0110011 :
        (valor_hex == 4'h5) ? 7'b1011011 :
        (valor_hex == 4'h6) ? 7'b1011111 :
        (valor_hex == 4'h7) ? 7'b1110000 :
        (valor_hex == 4'h8) ? 7'b1111111 :
        (valor_hex == 4'h9) ? 7'b1111011 :
        (valor_hex == 4'hA) ? 7'b1110111 :
        (valor_hex == 4'hB) ? 7'b0011111 :
        (valor_hex == 4'hC) ? 7'b1001110 :
        (valor_hex == 4'hD) ? 7'b0111101 :
        (valor_hex == 4'hE) ? 7'b1001111 :
                             7'b1000111; // F

    assign seg_dp = 1'b0;

endmodule