all: csharp/.compared java/.compared javascript/.compared
.PHONY: all

clean:
	cd csharp && make clean
	cd java && make clean
	cd javascript && make clean
.PHONY: clean

csharp/.compared:
	cd csharp && make

java/.compared:
	cd java && make

javascript/.compared:
	cd javascript && make
