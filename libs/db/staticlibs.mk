
DB_CSOURCES=$(wildcard $(SHOTODOL_DB_HOME)/libs/db/vsrc/*.c)
DB_VSOURCE_BASE=$(basename $(notdir $(DB_CSOURCES)))
OBJECTS+=$(addprefix $(SHOTODOL_DB_HOME)/build/.objects/, $(addsuffix .o,$(DB_VSOURCE_BASE)))

