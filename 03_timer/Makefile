ITEMS := debounce display sync

SOURCES := *.v
VVP := $(patsubst %,output/%,$(ITEMS))
WAVES := $(patsubst %,output/%.vcd,$(ITEMS))

.PHONY: all waves clean

all: waves

waves: $(WAVES)

$(WAVES): output/%.vcd: output/%
	$<;
	mv ./$(patsubst output/%,%.vcd,$^) $@

$(VVP): output/%: %_tb.v $(SOURCES) output
	iverilog -g2009 -o $@ $<

output:
	mkdir output

clean: output
	rm -rf output
