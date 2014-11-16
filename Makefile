all: csharp/.compared java/.compared
.PHONY: all

clean:
	cd csharp && make clean
	cd java && make clean
.PHONY: clean

csharp/.compared:
	cd csharp && make

java/.compared:
	cd java && make
