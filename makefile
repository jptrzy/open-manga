
build:
	meson setup build

all:
	valac --vapidir=vapi --pkg gtk4 src/*.vala -o om

run: build
	ninja -C build
	./build/OpenManga