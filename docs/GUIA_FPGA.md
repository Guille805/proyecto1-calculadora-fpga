# Guía para probar la calculadora de 4 bits

Esta guía supone que el proyecto está ubicado en:

```text
C:\Users\Edu Ponce\OneDrive\Proyecto 1
```

Los comandos de FPGA se ejecutan con las herramientas instaladas en WSL. No conectes ni programes la placa hasta llegar a la sección correspondiente.

## 1. Abrir el proyecto

Desde PowerShell:

```powershell
cd "C:\Users\Edu Ponce\OneDrive\Proyecto 1"
```

Para entrar a la misma carpeta desde WSL:

```powershell
wsl --cd "C:\Users\Edu Ponce\OneDrive\Proyecto 1"
```

Una vez dentro de WSL, puedes comprobar las herramientas:

```bash
iverilog -V
vvp -V
yosys -V
nextpnr-ice40 --version
icepack -h
iceprog -h
```

## 2. Simular módulos individuales

Los siguientes comandos deben ejecutarse dentro de WSL, desde la raíz del proyecto.

### ALU completa

```bash
iverilog -g2012 -Wall -s tb_alu4 -o alu4_test_new *.v
vvp alu4_test_new
```

Resultados principales esperados:

| Operación | A | B | Resultado |
|---|---:|---:|---:|
| `000` Reset | `0101` | `0011` | `0000` |
| `001` Suma | `0101` | `0011` | `1000` |
| `010` Resta | `0101` | `0011` | `0010` |
| `011` Resta inversa | `0101` | `0011` | `1110` |
| `100` Shift left 3 | `0101` | `0011` | `1000` |
| `101` Shift right 3 | `0101` | `0011` | `0000` |

### Shifts

```bash
iverilog -g2012 -Wall -s tb_shift_left4 -o shift_left4_test_new *.v
vvp shift_left4_test_new

iverilog -g2012 -Wall -s tb_shift_right4 -o shift_right4_test_new *.v
vvp shift_right4_test_new
```

### Suma y restas

```bash
iverilog -g2012 -Wall -s tb_adder4 -o adder4_test_new *.v
vvp adder4_test_new

iverilog -g2012 -Wall -s tb_subtractor4 -o subtractor4_test_new *.v
vvp subtractor4_test_new

iverilog -g2012 -Wall -s tb_reverse_subtractor4 -o reverse_subtractor4_test_new *.v
vvp reverse_subtractor4_test_new
```

### Display con signo y magnitud

```bash
iverilog -g2012 -Wall -s tb_calculator_display -o calculator_display_test_new *.v
vvp calculator_display_test_new
```

Para `1110`, que representa `-2`, se espera:

```text
sign=0000001
value_seg=1101101
```

### Resultado anterior y reset

```bash
iverilog -g2012 -Wall -s tb_calculator_core -o calculator_core_test_new *.v
vvp calculator_core_test_new
```

Este test debe mostrar:

```text
3 + 2 = 5       -> result=0101
1 + previous    -> result=0110
reset 000       -> result=0000
```

### Sistema completo sin debounce físico

```bash
iverilog -g2012 -Wall -s tb_calculator_system -o calculator_system_test_new *.v
vvp calculator_system_test_new
```

### Demostración rápida de resta

```bash
iverilog -g2012 -Wall -s tb_demo_calculator -o demo_calculator_test_new *.v
vvp demo_calculator_test_new
```

El resultado final esperado es:

```text
operation = 010
op1       = 0011
op2       = 0101
result    = 1110
```

## 3. Abrir una simulación en GTKWave

El test `tb_demo_calculator` genera `demo_calculator.vcd`.

```bash
iverilog -g2012 -s tb_demo_calculator -o demo_calculator_test_new *.v
vvp demo_calculator_test_new
gtkwave demo_calculator.vcd demo_calculator.gtkw
```

Si el archivo de configuración no abre correctamente:

```bash
gtkwave demo_calculator.vcd
```

En GTKWave agrega al menos estas señales:

- `state`
- `current_value`
- `operation`
- `op1`
- `op2`
- `select_previous`
- `execute`
- `result`

El test del núcleo también genera `calculator_core.vcd`:

```bash
iverilog -g2012 -s tb_calculator_core -o calculator_core_test_new *.v
vvp calculator_core_test_new
gtkwave calculator_core.vcd
```

## 4. Simular el top de la Go Board

```bash
iverilog -g2012 -Wall -s tb_go_board_top -o go_board_top_test_new *.v
vvp go_board_top_test_new
```

Esta simulación puede tardar varios minutos porque reproduce pulsaciones de aproximadamente 12 ms y cuatro circuitos de debounce de 18 bits. No la interrumpas inmediatamente si no imprime resultados.

## 5. Reconstruir el proyecto para la FPGA

Ejecuta los siguientes comandos dentro de WSL y en este orden.

### Síntesis con Yosys

```bash
yosys -p "read_verilog adder4.v alu4.v button_onepulse.v calculator_complete.v calculator_core.v calculator_display.v calculator_fpga_interface.v calculator_input_control.v calculator_system.v control_fsm.v debounce_button.v full_adder.v go_board_top.v hex_to_7seg.v input_register4.v magnitude4.v mux2_1bit.v mux2_4bit.v not4.v previous_selector.v register4.v reverse_subtractor4.v shift_left4.v shift_right4.v sign_to_7seg.v subtractor4.v value_counter4.v; synth_ice40 -top go_board_top -json go_board.json"
```

El comando debe terminar sin errores y crear `go_board.json`.

### Place and route con nextpnr

```bash
nextpnr-ice40 --hx1k --package vq100 --json go_board.json --pcf go_board.pcf --asc go_board.asc --freq 25
```

Debe terminar con `Program finished normally` y crear `go_board.asc`. También debe indicar `PASS at 25.00 MHz` para el reloj principal.

### Generar el bitstream

```bash
icepack go_board.asc go_board.bin
```

Comprueba que los tres archivos existan:

```bash
ls -lh go_board.json go_board.asc go_board.bin
```

## 6. Programar la Go Board

Conecta la Go Board por USB y comprueba que WSL pueda verla. Después ejecuta:

```bash
iceprog go_board.bin
```

No desconectes la placa mientras se está programando. El comando debe completar el borrado, programación y verificación sin errores.

Si aparece un error de acceso USB desde WSL, prueba `iceprog go_board.bin` desde el entorno Linux donde el dispositivo USB esté conectado, o configura el acceso USB de WSL antes de repetirlo.

## 7. Controles físicos

| Control | Función |
|---|---|
| SW1, superior izquierdo | Incrementar valor |
| SW2, inferior izquierdo | Disminuir valor |
| SW3, superior derecho | Confirmar/continuar |
| SW4, inferior derecho | Usar el resultado anterior como segundo operando |
| D1–D3 | Código binario de operación |
| D4 | Resultado anterior seleccionado |
| Display 1 | Signo |
| Display 2 | Magnitud hexadecimal |

Los segmentos físicos son activos en bajo. La inversión ya está implementada en `go_board_top.v`.

## 8. Códigos de operación y LEDs

| Código | D3 | D2 | D1 | Operación |
|---|---:|---:|---:|---|
| `000` | 0 | 0 | 0 | Reinicio |
| `001` | 0 | 0 | 1 | Suma `A+B` |
| `010` | 0 | 1 | 0 | Resta `A-B` |
| `011` | 0 | 1 | 1 | Resta inversa `B-A` |
| `100` | 1 | 0 | 0 | Shift left |
| `101` | 1 | 0 | 1 | Shift right |

## 9. Flujo normal de uso

1. En el estado inicial, usa SW1 o SW2 hasta obtener el código de operación en D1–D3.
2. Pulsa SW3 una vez para confirmar la operación.
3. Usa SW1 o SW2 para seleccionar `op1`. El display muestra signo y magnitud.
4. Pulsa SW3 para confirmar `op1`.
5. Usa SW1 o SW2 para seleccionar `op2`.
6. Pulsa SW3 para ejecutar.
7. Observa el resultado en los displays.
8. Pulsa SW3 nuevamente para volver a seleccionar una operación.

El contador editable conserva el último valor ingresado. Esto es intencional. Antes de cada paso, mira el display o los LEDs y calcula cuántas pulsaciones necesitas desde el valor actual; no supongas que comienza en cero.

SW1 y SW2 operan módulo 16:

- Incrementar `15` produce `0`.
- Disminuir `0` produce `15`, que representa `-1`.

## 10. Usar el resultado anterior

Ejemplo: primero calcular `3+2=5` y después `1+5=6` usando el resultado anterior.

### Primera operación: 3 + 2

1. Selecciona operación `001` y confirma con SW3.
2. Ajusta el contador a `3` y confirma.
3. Ajusta el contador a `2` y confirma.
4. Comprueba que el display muestre `5`.
5. Pulsa SW3 para regresar al estado inicial.

### Segunda operación: 1 + previous_result

1. Selecciona operación `001` y confirma.
2. Ajusta el contador a `1` y confirma como `op1`.
3. Durante la selección de `op2`, pulsa SW4 una sola vez.
4. Comprueba que D4 quede encendido. El valor editable de `op2` deja de importar para el cálculo.
5. Pulsa SW3 para ejecutar.
6. El resultado esperado es `6`.
7. Pulsa SW3 para volver al inicio; D4 debe apagarse.

## 11. Ejecutar Reset

La operación `000` pone el registro de resultado en `0000`.

1. Vuelve al estado inicial con SW3 si estás viendo un resultado.
2. Ajusta D1–D3 a `000` usando SW1 o SW2.
3. Confirma la operación con SW3.
4. Confirma cualquier valor para `op1`.
5. Confirma cualquier valor para `op2`.
6. El display debe mostrar `0` y el resultado anterior interno queda en `0000`.

## 12. Pruebas recomendadas en la placa

Como el contador conserva su valor, en cada prueba usa SW1/SW2 hasta que el display o los LEDs indiquen el valor deseado.

| Prueba | Operación | A | B | Resultado mostrado |
|---|---|---:|---:|---|
| Suma | `001` | 3 | 2 | `5` |
| Resta negativa | `010` | 3 | 5 | `-2` |
| Resta inversa | `011` | 3 | 5 | `2` |
| Shift left | `100` | 3 | 1 | `6` |
| Shift left extremo | `100` | 1 | 3 | `-8` |
| Shift right | `101` | 12 (`1100`) | 2 | `3` |
| Shift right extremo | `101` | 8 (`1000`) | 3 | `1` |
| Overflow | `001` | 7 | 3 | `-6` (`1010`) |

Para ingresar valores negativos, usa SW2 desde cero o continúa decrementando hasta el patrón requerido. Por ejemplo:

- `-1 = 1111`: una pulsación de SW2 desde `0000`.
- `-2 = 1110`: dos pulsaciones de SW2 desde `0000`.
- `-3 = 1101`: tres pulsaciones de SW2 desde `0000`.

## 13. Checklist rápida antes de la demostración

- [ ] La placa está conectada y `iceprog go_board.bin` termina correctamente.
- [ ] SW1 incrementa una sola vez por pulsación.
- [ ] SW2 disminuye una sola vez por pulsación.
- [ ] SW3 avanza una etapa por pulsación.
- [ ] D1–D3 coinciden con el código seleccionado.
- [ ] El display muestra signo y magnitud correctamente.
- [ ] `3+2` muestra `5`.
- [ ] `3-5` muestra `-2`, no `-E`.
- [ ] SW4 enciende D4 y permite obtener `1+previous_result=6`.
- [ ] Después de volver al inicio, D4 se apaga.
- [ ] La operación `000` deja el resultado anterior en cero.

