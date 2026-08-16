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

## 6. Operaciones requeridas

| Código | Operación | Resultado | Descripción |
|---|---|---|---|
| `3'b000` | Reinicio | `R = 4'b0000` | Coloca el resultado almacenado en cero. |
| `3'b001` | Suma | `R = A + B` | Suma ambos operandos. |
| `3'b010` | Resta | `R = A - B` | Resta B a A utilizando complemento a dos. |
| `3'b011` | Resta inversa | `R = B - A` | Resta A a B utilizando complemento a dos. |
| `3'b100` | Desplazamiento izquierdo | A desplazado a la izquierda | Desplaza A entre 0 y 3 posiciones usando `B[1:0]`. |
| `3'b101` | Desplazamiento derecho | A desplazado a la derecha | Desplaza A entre 0 y 3 posiciones usando `B[1:0]`. |

En esta tabla, `A` corresponde a `op1`. El valor `B` puede ser `op2` o el resultado anterior, según el selector `use_previous`.

Los códigos `3'b110` y `3'b111` quedan sin utilizar. Todas las operaciones conservan solamente los cuatro bits menos significativos del resultado.

## 7. Selector del segundo operando

El segundo operando de la calculadora se denominará `B`. Este valor se obtiene mediante un multiplexor de dos entradas.

- Si `use_previous = 0`, se selecciona el operando externo `op2`.
- Si `use_previous = 1`, se selecciona el resultado anterior `previous`.

### 7.1 Tabla de verdad para un bit

La siguiente tabla describe el comportamiento para cada bit `i`:

| `use_previous` | `op2[i]` | `previous[i]` | `B[i]` |
|---|---|---|---|
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 0 |
| 0 | 1 | 0 | 1 |
| 0 | 1 | 1 | 1 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 1 |
| 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 |

### 7.2 Expresión booleana

Para cada bit, la salida puede expresarse como:

`B[i] = (NOT use_previous AND op2[i]) OR (use_previous AND previous[i])`

El circuito necesita:

- Una compuerta NOT.
- Dos compuertas AND.
- Una compuerta OR.

Como los operandos tienen cuatro bits, este mismo circuito se repite cuatro veces, una vez para cada bit.

### 7.3 Mapa de Karnaugh

Para simplificar el mapa se utilizarán las siguientes variables:

- `S = use_previous`
- `X = op2[i]`
- `P = previous[i]`

Las columnas se ordenan utilizando el código Gray: `00`, `01`, `11`, `10`.

| `S / XP` | `00` | `01` | `11` | `10` |
|---|---|---|---|---|
| `0` | 0 | 0 | 1 | 1 |
| `1` | 0 | 1 | 1 | 0 |

En el mapa se forman dos grupos:

1. Los dos unos de la fila `S = 0` donde `X = 1`. Este grupo produce `NOT S AND X`.
2. Los dos unos de la fila `S = 1` donde `P = 1`. Este grupo produce `S AND P`.

Al unir ambos grupos mediante una compuerta OR se obtiene:

`B[i] = (NOT S AND X) OR (S AND P)`

Reemplazando los nombres abreviados:

`B[i] = (NOT use_previous AND op2[i]) OR (use_previous AND previous[i])`