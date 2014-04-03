DMD=dmd
DFLAGS=
SRCS=${wildcard ./*.d}
TARGET=main

all: $(TARGET)

$(TARGET): $(SRCS)
	$(DMD) $(SRCS) $(DFLAGS) -of$(TARGET)

run: all
	./$(TARGET)

clean:
	rm -f *.o
	rm $(TARGET)
