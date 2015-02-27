all: csharp/.compared java/.compared ruby/.compared
.PHONY: all

clean:
	cd csharp && make clean
	cd java && make clean
	cd ruby && make clean
	.PHONY: clean

csharp/.compared:
	cd csharp && make

java/.compared:
	cd java && make

ruby/.compared:
	cd java && make
