# Diseño teórico de la calculadora

## 1. Objetivo

Diseñar una calculadora digital de 4 bits utilizando Verilog e implementarla posteriormente en una FPGA Lattice iCE40 HX1K.

La lógica combinacional deberá construirse mediante compuertas lógicas, sin utilizar directamente operadores aritméticos de alto nivel.

## 2. ¿Qué significa trabajar con 4 bits?

Un bit solamente puede valer 0 o 1. Al utilizar cuatro bits existen 16 combinaciones posibles:

- Sin signo: valores desde 0 hasta 15.
- Con complemento a dos: valores desde -8 hasta 7.

Si una operación produce más de cuatro bits, solamente se conservarán los cuatro bits menos significativos.

## 3. Entradas de la calculadora

- `op1[3:0]`: primer operando de cuatro bits.
- `op2[3:0]`: segundo operando externo de cuatro bits.
- `operation[2:0]`: código de la operación.
- `use_previous`: selecciona entre `op2` y el resultado anterior.
- `execute`: confirma y ejecuta la operación.

## 4. Salida

- `result[3:0]`: resultado de cuatro bits almacenado en un registro.

## 5. Bloques principales

La calculadora estará dividida en:

1. Selector del segundo operando.
2. Circuitos de suma y resta.
3. Circuitos de desplazamiento.
4. Selector de operación.
5. Registro para almacenar el resultado.
6. Control de botones, LED y displays.