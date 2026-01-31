AS=nasm
ASFLAGS=-felf64 -g -F dwarf
LD=ld
LDFLAGS=

SHARED_FILES = functions.asm print.asm
SHARED_OBJS = $(SHARED_FILES:.asm=.o)

PROJECTS = arg-calc/calc file-io/read file-io/write fizz-buzz/fizz-buzz socket/socket-recv socket/socket-send process-clone-multithreading/clone

all: $(SHARED_OBJS) $(PROJECTS)

%.o: %.asm
	$(AS) $(ASFLAGS) $<

%: %.o $(SHARED_OBJS)
	$(LD) -o $@ $^

.PHONY: clean all
clean:
	rm -f $(PROJECTS)
	rm -f *.o
