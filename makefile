
all:
	valac --vapidir=vapi --pkg gtk4 src/*.vala -o om

run: build
	meson setup build
	ninja -C build
	./build/OpenManga