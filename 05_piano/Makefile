PROJECT := top
CONTAINER := ${QUARTUS_CONTAINER}

TESTBENCHES := $(wildcard *_tb.v)
SOURCES := $(filter-out $(TESTBENCHES),$(wildcard *.v))
TB_VVP := $(patsubst %_tb.v,output_files/%.vvp,$(TESTBENCHES))
TB_VCD := $(patsubst %_tb.v,output_files/%.vcd,$(TESTBENCHES))

ifeq ($(PROJECT),max)
	FIRM_EXT := .pof
else
	FIRM_EXT := .sof
endif

ifeq ($(CONTAINER),)
	FIRMWARE_FILE := output_files/$(PROJECT)$(FIRM_EXT)
else
	FIRMWARE_FILE := output_files/firmware.svf
endif

.PHONY: all flash firmware waves clean quartus

all: firmware waves

waves: $(TB_VCD)

flash: $(FIRMWARE_FILE)
ifeq ($(CONTAINER),)
	quartus_pgm -c "USB-Blaster [USB-0]" -m JTAG -o "p;$(subst /,\,$(FIRMWARE_FILE))"
else
	openocd -f interface/altera-usb-blaster.cfg -c "init" -c "svf $(FIRMWARE_FILE)" -c "shutdown"
endif

firmware: $(FIRMWARE_FILE)

$(FIRMWARE_FILE): $(SOURCES) output_files
ifeq ($(CONTAINER),)
	quartus_sh --flow compile "$(PROJECT).qsf"
else
	docker start $(CONTAINER)
	docker cp . $(CONTAINER):/build/
	docker exec -t $(CONTAINER) quartus_wrapper quartus_sh --flow compile $(PROJECT)
	docker exec -t $(CONTAINER) quartus_wrapper quartus_cpf -q 10.0Mhz -g 3.3 -c -n p /build/output_files/$(PROJECT)$(FIRM_EXT) /build/output_files/firmware.svf
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
	rmdir /S /Q output_files || echo 0
else
	rm -rf output_files
endif

quartus:
ifeq ($(CONTAINER),)
	quartus $(PROJECT).qpf
else
	docker start $(CONTAINER)
	docker exec -t $(CONTAINER) bash -c "rm -rf /build"
	docker exec -t $(CONTAINER) bash -c "rm -rf /extract"
	docker cp . $(CONTAINER):/build/
	docker exec -t $(CONTAINER) quartus_wrapper /opt/intelFPGA_lite/19.1/quartus/bin/quartus /build/$(PROJECT).qpf
	docker cp $(CONTAINER):/build/$(PROJECT).qpf .
	docker cp $(CONTAINER):/build/$(PROJECT).qsf .
	docker exec -t $(CONTAINER) mkdir /extract
	docker exec -t $(CONTAINER) bash -c "cp /build/*.v /extract/" || echo copy
	docker exec -t $(CONTAINER) bash -c "cp /build/*.qip /extract/" || echo copy
	docker exec -t $(CONTAINER) bash -c "cp /build/*.hex /extract/" || echo copy
	docker exec -t $(CONTAINER) bash -c "cp /build/*.mif /extract/" || echo copy
	docker cp $(CONTAINER):/extract .
	docker exec -t $(CONTAINER) bash -c "rm -rf /build"
	docker exec -t $(CONTAINER) bash -c "rm -rf /extract"
	docker stop $(CONTAINER)
	mv -f extract/* .
	rmdir extract
endif