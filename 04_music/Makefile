ITEMS := beeper delay sequencer top
CONTAINER := quartus
PROJECT := top

SOURCES := *.v
VVP := $(patsubst %,output/%,$(ITEMS))
WAVES := $(patsubst %,output/%.vcd,$(ITEMS))

.PHONY: all flash firmware waves clean quartus

all: firmware waves

waves: $(WAVES)

flash: firmware
	openocd -f interface/altera-usb-blaster.cfg -c "init" -c "svf output/firmware.svf" -c "shutdown"

firmware: output/firmware.svf

output/firmware.svf: $(SOURCES) output
	docker start $(CONTAINER)
	docker cp . $(CONTAINER):/build/
	docker exec -t $(CONTAINER) quartus_wrapper quartus_sh --flow compile $(PROJECT)
	docker cp $(CONTAINER):/build/output_files/top.svf $@
	docker exec -t $(CONTAINER) rm -rf /build
	docker stop $(CONTAINER)
	touch $@

$(WAVES): output/%.vcd: output/%
	@$<;
	@mv ./$(patsubst output/%,%.vcd,$^) $@

$(VVP): output/%: %_tb.v $(SOURCES) output
	@iverilog -g2009 -o $@ $<

output:
	mkdir output

clean: output
	rm -rf output

quartus:
	docker start $(CONTAINER)
	docker cp . $(CONTAINER):/build/
	docker exec -t $(CONTAINER) quartus_wrapper /opt/intelFPGA_lite/19.1/quartus/bin/quartus /build/top.qpf
	docker exec -t $(CONTAINER) rm -rf /build
	docker stop $(CONTAINER)