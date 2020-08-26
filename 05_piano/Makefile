SOLUTION := simple_piano
PROJECT := top
CONTAINER := quartus

TESTBENCHES := $(wildcard *_tb.v)
SOURCES := $(filter-out $(TESTBENCHES),$(wildcard *.v))
TB_VVP := $(patsubst %_tb.v,output_files/%.vvp,$(TESTBENCHES))
TB_VCD := $(patsubst %_tb.v,output_files/%.vcd,$(TESTBENCHES))

ifeq ($(CONTAINER),)
	FIRMWARE_FILE := output_files/$(PROJECT).sof
else
	FIRMWARE_FILE := output_files/firmware.svf
endif

.PHONY: all flash firmware waves clean quartus

all: firmware waves

waves: $(TB_VCD)

flash: $(FIRMWARE_FILE)
ifeq ($(CONTAINER),)
	quartus_pgm -c "USB-Blaster [USB-0]" -m JTAG -o "p;output_files\$(PROJECT).sof"
else
	openocd -f interface/altera-usb-blaster.cfg -c "init" -c "svf output_files/firmware.svf" -c "shutdown"
endif

firmware: $(FIRMWARE_FILE)

$(FIRMWARE_FILE): $(SOURCES) output_files
ifeq ($(CONTAINER),)
	quartus_sh --flow compile "$(PROJECT).qsf"
else
	docker start $(CONTAINER)
	docker cp . $(CONTAINER):/build/
	docker exec -t $(CONTAINER) quartus_wrapper quartus_sh --flow compile $(PROJECT)
	docker exec -t $(CONTAINER) quartus_wrapper quartus_cpf -q 25.0Mhz -g 3.3 -c -n p /build/output_files/$(PROJECT).sof /build/output_files/firmware.svf
	docker cp $(CONTAINER):/build/output_files/firmware.svf $@
	docker exec -t $(CONTAINER) rm -rf /build
	docker stop $(CONTAINER)
	touch $@
endif

$(TB_VCD): output_files/%.vcd: output_files/%.vvp
ifeq ($(OS), Windows_NT)
	@cd output_files && vvp $(patsubst output_files/%,%,$<)
else
	@cd output_files && ./$(patsubst output_files/%,%,$<)
endif

$(TB_VVP): output_files/%.vvp: %_tb.v $(SOURCES) output_files
	@iverilog -g2009 -o $@ $<

output_files:
	mkdir output_files

clean:
ifeq ($(OS), Windows_NT)
	rmdir /F /Q output_files
else
	rm -rf output_files
endif

quartus:
ifeq ($(CONTAINER),)
	quartus $(SOLUTION).qpf
else
	docker start $(CONTAINER)
	docker cp . $(CONTAINER):/build/
	docker exec -t $(CONTAINER) quartus_wrapper /opt/intelFPGA_lite/19.1/quartus/bin/quartus /build/$(SOLUTION).qpf
	docker cp $(CONTAINER):/build/$(SOLUTION).qpf .
	docker cp $(CONTAINER):/build/$(PROJECT).qsf .
	docker cp $(CONTAINER):/build/*.v .
	docker cp $(CONTAINER):/build/*.qip .
	docker cp $(CONTAINER):/build/*.hex .
	docker cp $(CONTAINER):/build/*.mif .
	docker exec -t $(CONTAINER) rm -rf /build
	docker stop $(CONTAINER)
endif