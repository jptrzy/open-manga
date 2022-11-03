# TODO move all to meson

all: _build

_build:
	rm -f res/ui/*.ui
	blueprint-compiler batch-compile res/ui res/ui res/ui/*.blp
		
	cp res/ui/*.ui.in build
	perl-rename -v "s/.ui.in$$/.ui/g" build/*
	cp build/*.ui res/ui

	meson setup build
	ninja -C build

	rm -f res/ui/*.ui

run: _build
	./build/OpenManga