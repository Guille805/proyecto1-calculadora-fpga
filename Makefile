SRC_DIR := src
BUILD_DIR := build

IVERILOG := iverilog
VVP := vvp
GTKWAVE := gtkwave
YOSYS := yosys
NEXTPNR := nextpnr-ice40
ICEPACK := icepack
ICEPROG := iceprog

DESIGN_SOURCES := \
	$(SRC_DIR)/full_adder.v \
	$(SRC_DIR)/adder4.v \
	$(SRC_DIR)/not4.v \
	$(SRC_DIR)/subtractor4.v \
	$(SRC_DIR)/reverse_subtractor4.v \
	$(SRC_DIR)/shift_left4.v \
	$(SRC_DIR)/shift_right4.v \
	$(SRC_DIR)/mux2_1bit.v \
	$(SRC_DIR)/mux2_4bit.v \
	$(SRC_DIR)/alu4.v \
	$(SRC_DIR)/register4.v \
	$(SRC_DIR)/calculator_core.v \
	$(SRC_DIR)/value_counter4.v \
	$(SRC_DIR)/input_register4.v \
	$(SRC_DIR)/control_fsm.v \
	$(SRC_DIR)/calculator_input_control.v \
	$(SRC_DIR)/calculator_system.v \
	$(SRC_DIR)/magnitude4.v \
	$(SRC_DIR)/hex_to_7seg.v \
	$(SRC_DIR)/sign_to_7seg.v \
	$(SRC_DIR)/calculator_display.v \
	$(SRC_DIR)/calculator_fpga_interface.v \
	$(SRC_DIR)/calculator_complete.v \
	$(SRC_DIR)/debounce_button.v \
	$(SRC_DIR)/button_onepulse.v \
	$(SRC_DIR)/previous_selector.v \
	$(SRC_DIR)/go_board_top.v

TOP ?= tb_demo_calculator

.PHONY: all check-tools check-gates sim test wave-demo test-board \
	synth pnr pack bitstream program clean

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

check-tools:
	@echo "Verificando herramientas..."
	@command -v $(IVERILOG) >/dev/null || (echo "Falta iverilog" && exit 1)
	@command -v $(VVP) >/dev/null || (echo "Falta vvp" && exit 1)
	@command -v $(GTKWAVE) >/dev/null || (echo "Falta gtkwave" && exit 1)
	@command -v $(YOSYS) >/dev/null || (echo "Falta yosys" && exit 1)
	@command -v $(NEXTPNR) >/dev/null || (echo "Falta nextpnr-ice40" && exit 1)
	@command -v $(ICEPACK) >/dev/null || (echo "Falta icepack" && exit 1)
	@command -v $(ICEPROG) >/dev/null || (echo "Falta iceprog" && exit 1)
	@echo "Todas las herramientas necesarias están instaladas."

check-gates:
	@echo "Buscando operadores prohibidos en archivos sintetizables..."
	@grep -nE '(^|[^[:alnum:]_])(\+|-|<=|>=|<<|>>|\?|if[[:space:]]*\(|case[[:space:]])' $(DESIGN_SOURCES) \
		&& (echo "ATENCION: revisar coincidencias anteriores." ; exit 1) \
		|| echo "No se encontraron operadores prohibidos evidentes."

sim: $(BUILD_DIR)
	$(IVERILOG) -g2012 -s $(TOP) \
		-o $(BUILD_DIR)/$(TOP) \
		$(DESIGN_SOURCES) \
		$(SRC_DIR)/$(TOP).v
	$(VVP) $(BUILD_DIR)/$(TOP)

test: $(BUILD_DIR)
	@echo "Ejecutando pruebas principales..."
	$(MAKE) sim TOP=tb_full_adder
	$(MAKE) sim TOP=tb_adder4
	$(MAKE) sim TOP=tb_subtractor4
	$(MAKE) sim TOP=tb_reverse_subtractor4
	$(MAKE) sim TOP=tb_shift_left4
	$(MAKE) sim TOP=tb_shift_right4
	$(MAKE) sim TOP=tb_mux2_4bit
	$(MAKE) sim TOP=tb_alu4
	$(MAKE) sim TOP=tb_calculator_core
	$(MAKE) sim TOP=tb_calculator_system
	$(MAKE) sim TOP=tb_previous_integration
	@echo "Pruebas principales finalizadas."

wave-demo: $(BUILD_DIR)
	$(IVERILOG) -g2012 -s tb_demo_calculator \
		-o $(BUILD_DIR)/tb_demo_calculator \
		$(DESIGN_SOURCES) \
		$(SRC_DIR)/tb_demo_calculator.v
	cd $(BUILD_DIR) && $(VVP) tb_demo_calculator
	@if [ -f $(BUILD_DIR)/demo_calculator.vcd ]; then \
		$(GTKWAVE) $(BUILD_DIR)/demo_calculator.vcd; \
	elif [ -f demo_calculator.vcd ]; then \
		$(GTKWAVE) demo_calculator.vcd; \
	else \
		echo "No se encontró demo_calculator.vcd"; \
		exit 1; \
	fi

test-board: $(BUILD_DIR)
	$(IVERILOG) -g2012 -s tb_go_board_top \
		-o $(BUILD_DIR)/tb_go_board_top \
		$(DESIGN_SOURCES) \
		$(SRC_DIR)/tb_go_board_top.v
	$(VVP) $(BUILD_DIR)/tb_go_board_top

synth: $(BUILD_DIR)
	$(YOSYS) -p "read_verilog $(DESIGN_SOURCES); synth_ice40 -top go_board_top -json $(BUILD_DIR)/go_board.json"

pnr: synth
	$(NEXTPNR) --hx1k --package vq100 \
		--json $(BUILD_DIR)/go_board.json \
		--pcf $(SRC_DIR)/go_board.pcf \
		--asc $(BUILD_DIR)/go_board.asc

pack: pnr
	$(ICEPACK) $(BUILD_DIR)/go_board.asc $(BUILD_DIR)/go_board.bin

bitstream: pack
	@echo "Bitstream generado en $(BUILD_DIR)/go_board.bin"

program: bitstream
	$(ICEPROG) $(BUILD_DIR)/go_board.bin

clean:
	rm -rf $(BUILD_DIR)
	rm -f *.vcd
