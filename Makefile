OUTPUT = simv
ALL_DEFINE = # +define+VCS
LINT = # +lint=all

CM = -cm line+cond+fsm+branch+tgl
CM_NAME = -cm_name $(OUTPUT)
CM_DIR = -cm_dir ./$(OUTPUT).vdb

VPD_NAME = +vpdfile+$(OUTPUT).vpd
FSDB_NAME = +fsdbfile+$(OUTPUT).fsdb

VCS = vcs +v2k -sverilog \
	-override_timescale=1ns/1ns \
	-full64 -LDFLAGS -Wl,-no-as-needed \
	-debug_acc+all -debug_region=lib+cell+encrypt \
	+nospecify +vcs+flush+all +vcs+fsdbon \
	$(CM) $(CM_NAME) $(CM_DIR) \
	$(ALL_DEFINE) \
	$(LINT) \
	-o $(OUTPUT) \
	-l com.log

SIM = ./$(OUTPUT) +ntb_random_seed_automatic \
	$(CM) $(CM_NAME) $(CM_DIR) \
	$(VPD_NAME) $(FSDB_NAME) \
	-l $(OUTPUT).log

VER = verdi -sverilog -ssf $(OUTPUT).fsdb \
	$(ALL_DEFINE)

com:
	$(VCS) -f file.lst

sim:
	$(SIM)

cov:
	dve -covdir *vdb &

debug:
	dve -vpd $(OUTPUT).vpd &

ver:
	$(VER) -f file.lst &

clean:
	rm -rf ./csrc *.daidir *.log *.vpd *.vdb simv* *.key \
		*race.out* novas* verdi* *.fsdb ./DVEfiles

.PHONY: none com sim cov clean debug ver