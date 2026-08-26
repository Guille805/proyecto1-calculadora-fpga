# Proyecto 1 - Calculadora de 4 bits en FPGA

Proyecto de Arquitectura de Computadores (semestre 2026-2). Implementa una calculadora de 4 bits en Verilog para la FPGA Lattice iCE40 HX1K de la Nandland Go Board.

## Integrantes

- Guillermo Arriaza
- Christian Acevedo
- Eduardo Ponce

> Reemplazar los nombres antes de la entrega.

## Funcionalidad

La calculadora trabaja con patrones de cuatro bits. Los valores negativos se interpretan en complemento a dos y, cuando existe overflow, se conservan únicamente los cuatro bits menos significativos.

| Código | Operación | Resultado |
|---|---|---|
| `000` | Reinicio | `R = 0000` |
| `001` | Suma | `R = A + B` |
| `010` | Resta | `R = A - B` |
| `011` | Resta inversa | `R = B - A` |
| `100` | Shift left lógico | `R = A << B[1:0]` |
| `101` | Shift right lógico | `R = A >> B[1:0]` |

El segundo operando puede ser el valor ingresado por el usuario o el resultado almacenado de la operación anterior.

## Arquitectura

El diseño se divide en los siguientes bloques:

- ALU combinacional construida con primitivas `and`, `or`, `not`, `xor` y `buf`.
- Sumador ripple-carry de cuatro bits.
- Restadores implementados mediante complemento a dos.
- Barrel shifters lógicos de cuatro bits implementados con compuertas.
- Multiplexor para seleccionar `op2` o el resultado anterior.
- Registro de cuatro bits para almacenar el resultado.
- Máquina de cuatro estados para ingresar la operación, `op1`, `op2` y mostrar el resultado.
- Circuito de debounce y generación de un pulso por cada botón.
- Conversores de signo, magnitud y display de siete segmentos.

La lógica combinacional del diseño no utiliza directamente los operadores de alto nivel prohibidos por el enunciado. Los testbenches sí pueden emplear estructuras de control para comprobar automáticamente el circuito, porque no forman parte del hardware sintetizado.

## Estructura del repositorio

```text
.
|-- README.md
|-- Makefile
|-- docs/
|   |-- GUIA_FPGA.md
|   |-- diseno.md
|   `-- informe_proyecto1.pdf
`-- src/
    |-- go_board_top.v
    |-- go_board.pcf
    |-- *.v
    `-- tb_*.v
```

Descripción de los archivos principales:

- `README.md`: descripción general e instrucciones del proyecto.
- `Makefile`: comandos para simulación, síntesis y programación.
- `docs/GUIA_FPGA.md`: guía detallada de simulación y uso físico.
- `docs/diseno.md`: fuente editable del informe.
- `docs/informe_proyecto1.pdf`: informe preliminar del proyecto.
- `src/go_board_top.v`: módulo superior conectado a la FPGA.
- `src/go_board.pcf`: asignación de pines de la Go Board.
- `src/*.v`: módulos Verilog del diseño.
- `src/tb_*.v`: testbenches utilizados para verificar el circuito.

Los archivos generados por una nueva simulación o síntesis se guardan en `build/`.

## Requisitos

El flujo está preparado para Linux o WSL con las siguientes herramientas:

- GNU Make
- Icarus Verilog: `iverilog` y `vvp`
- GTKWave
- Yosys
- nextpnr-ice40
- Project IceStorm: `icepack` e `iceprog`

Para comprobar la instalación:

```bash
make check-tools
```

## Simulación

Todos los comandos deben ejecutarse desde la carpeta principal del repositorio.

Comprobar que los módulos sintetizables no contengan operadores prohibidos:

```bash
make check-gates
```

Ejecutar todos los testbenches rápidos, incluida la prueba exhaustiva de las seis operaciones de la ALU:

```bash
make test
```

Ejecutar un testbench específico:

```bash
make sim TOP=tb_alu4
make sim TOP=tb_calculator_core
make sim TOP=tb_demo_calculator
```

Generar y abrir la demostración en GTKWave:

```bash
make wave-demo
```

La simulación completa del módulo superior incluye el debounce físico de aproximadamente 10,5 ms y tarda más que las pruebas normales:

```bash
make test-board
```

## Informe PDF

La fuente editable del informe se encuentra en `docs/diseno.md`.

Para regenerar el PDF con los nombres correctos:

```bash
make report AUTHORS="Nombre Apellido · Nombre Apellido · Nombre Apellido"
```

El archivo resultante se guarda en:

```text
docs/informe_proyecto1.pdf
```

## Construcción del bitstream

Para ejecutar el flujo completo de síntesis, place-and-route y empaquetado:

```bash
make bitstream
```

Este comando genera:

```text
build/go_board.json
build/go_board.asc
build/go_board.bin
```

También es posible ejecutar cada etapa por separado:

```bash
make synth
make pnr
make pack
```

El proyecto utiliza:

- FPGA Lattice iCE40 HX1K.
- Encapsulado VQ100.
- Reloj de 25 MHz.
- Archivo de restricciones `src/go_board.pcf`.

La asignación de pines coincide con el pinout oficial de la Nandland Go Board.

## Programación de la FPGA

Con la placa conectada y visible desde Linux o WSL:

```bash
make program
```

También se puede programar directamente un bitstream existente:

```bash
iceprog src/go_board.bin
```

No se debe desconectar la placa durante el borrado, escritura o verificación del bitstream.

## Controles físicos

| Control | Función |
|---|---|
| SW1, superior izquierdo | Incrementar el valor |
| SW2, inferior izquierdo | Disminuir el valor |
| SW3, superior derecho | Confirmar o avanzar |
| SW4, inferior derecho | Usar el resultado anterior como `op2` |
| D1-D3 | Código binario de la operación |
| D4 | Indicador de resultado anterior seleccionado |
| Display 1 | Signo negativo |
| Display 2 | Magnitud hexadecimal |

## Flujo de uso

1. Seleccionar la operación con SW1 o SW2.
2. Confirmar la operación con SW3.
3. Seleccionar el primer operando `op1`.
4. Confirmar `op1` con SW3.
5. Seleccionar `op2` o pulsar SW4 para utilizar el resultado anterior.
6. Confirmar `op2` con SW3.
7. Revisar el resultado en los displays.
8. Pulsar SW3 para volver a la selección de operación.

El valor editable opera módulo 16. Por ejemplo, disminuir `0000` produce `1111`, que representa `-1` en complemento a dos.

## Pruebas mínimas en la placa

| Operación | A | B | Resultado esperado |
|---|---:|---:|---:|
| Suma | 3 | 2 | `5` |
| Resta | 3 | 5 | `-2` |
| Resta inversa | 3 | 5 | `2` |
| Shift left | 3 | 1 | `6` |
| Shift right | 12 (`1100`) | 2 | `3` |
| Overflow | 7 | 3 | `-6` (`1010`) |
| Resultado anterior | Primero `3+2`, luego `1+prev` | — | `6` |
| Reinicio | Cualquier A | Cualquier B | `0` |

Para realizar una prueba física paso a paso y revisar posibles problemas, consultar:

```text
docs/GUIA_FPGA.md
```

## Lista de verificación para la entrega

- [ ] Completar los nombres de los integrantes.
- [ ] Ejecutar `make check-gates` sin errores.
- [ ] Ejecutar `make test` sin errores.
- [ ] Ejecutar `make bitstream`.
- [ ] Comprobar el timing del reloj de 25 MHz.
- [ ] Programar y probar físicamente la Go Board.
- [ ] Actualizar los nombres del informe.
- [ ] Revisar `docs/informe_proyecto1.pdf`.
- [ ] Compartir el repositorio con el profesor y los ayudantes.
