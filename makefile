
all:
	valac --vapidir=vapi --pkg gtk4 src/*.vala -o om

run:
	rm -f res/ui/*.ui && blueprint-compiler batch-compile res/ui res/ui res/ui/*.blp
	meson setup build
	ninja -C build
	./build/OpenManga