

all:
	wails build

setup:
	go install github.com/wailsapp/wails/v2/cmd/wails@latest

install:
	mkdir -p /usr/local/bin/
	cp build/bin/over-manga /usr/local/bin/

