all: csharp/.compared golang/.compared java/.compared javascript/.compared ruby/.compared
.PHONY: all

clean:
	cd csharp && make clean
	cd golang && make clean
	cd java && make clean
	cd javascript && make clean
	cd ruby && make clean
.PHONY: clean

csharp/.compared:
	cd csharp && make

golang/.compared:
	cd golang && make

java/.compared:
	cd java && make

javascript/.compared:
	cd javascript && make

ruby/.compared:
	cd ruby && make
