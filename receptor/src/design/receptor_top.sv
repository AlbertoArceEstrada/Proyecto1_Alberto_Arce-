
module receptor_top (
    // Entradas desde el transmisor (orden físico: P0=77, P1=76, P2=75, d1=74, P4=73, d2=72, d3=71, d4=70)
    input  logic P0, P1, P2, d1_in, P4, d2_in, d3_in, d4_in,
    // Entradas de selección del mux externo (conectar a switches en protoboard)
    input  logic y0, y1, y2, y3,
    // Salidas hacia el mux externo (para conmutar palabra/síndrome)
    output logic ds1, ds2, ds3, ds4,
    output logic s8, s4, s2, s1,
    // LEDs de palabra corregida (pines 10,11,13,14)
    output logic led0, led1, led2, led3,
    // LED adicionales (opcionales, p.ej. led4, led5 no usados)
    output logic led4, led5,
    // LED indicador de doble error (pin 38)
    output logic error_led,
    // Display de 7 segmentos (pines: 51,53,54,55,56,57,68,69)
    output logic seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, seg_dp
);

    // Señales internas
    logic [2:0] sindrome;
    logic       doble_error;
    logic [3:0] palabra_corregida;
    logic [3:0] valor_display;

    // Instancia del decodificador de paridad
    decodificador_paridad u_decodificador (
        .P0(P0), .P1(P1), .P2(P2), .d1(d1_in), .P4(P4), .d2(d2_in), .d3(d3_in), .d4(d4_in),
        .sindrome(sindrome),
        .doble_error(doble_error)
    );

    // Instancia del corrector de errores
    correccion_error u_corrector (
        .P0(P0), .P1(P1), .P2(P2), .d1(d1_in), .P4(P4), .d2(d2_in), .d3(d3_in), .d4(d4_in),
        .sindrome(sindrome),
        .palabra_corregida(palabra_corregida)
    );

    // Instancia del selector
    selector u_selector (
        .palabra_corregida(palabra_corregida),
        .sindrome(sindrome),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3),
        .ds1(ds1), .ds2(ds2), .ds3(ds3), .ds4(ds4),
        .s8(s8), .s4(s4), .s2(s2), .s1(s1),
        .salida_display(valor_display)
    );

    // Instancia del despliegue en LEDs
    despliegue_leds u_leds (
        .palabra_corregida(palabra_corregida),
        .led0(led0), .led1(led1), .led2(led2), .led3(led3),
        .led4(led4), .led5(led5)
    );

    // Instancia del display de 7 segmentos
    despliegue_7seg_catodo_comun u_display (
        .valor_hex(valor_display),
        .seg_a(seg_a), .seg_b(seg_b), .seg_c(seg_c), .seg_d(seg_d),
        .seg_e(seg_e), .seg_f(seg_f), .seg_g(seg_g), .seg_dp(seg_dp)
    );

    // LED de doble error (activo alto)
    assign error_led = doble_error;

endmodule