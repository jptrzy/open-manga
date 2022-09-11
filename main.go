package main

import (
	"embed"

	"fmt"
	"net/http"
	"os"

	"over-manga/backend"
	log "over-manga/backend/logger"

	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
)

//go:embed frontend/dist
var assets embed.FS

type FileLoader struct {
    http.Handler
}

func NewFileLoader() *FileLoader {
    return &FileLoader{}
}

func (h *FileLoader) ServeHTTP(res http.ResponseWriter, req *http.Request) {
	var err error
	requestedFilename := req.URL.Path
	log.Info.Println("Requesting file:", requestedFilename, req.URL.Path)
	fileData, err := os.ReadFile(requestedFilename)
	if err != nil {
		res.WriteHeader(http.StatusBadRequest)
		res.Write([]byte(fmt.Sprintf("Could not load file %s", requestedFilename)))
	}

	res.Write(fileData)
}

func main() {
	_app := app.NewApp()

	err := wails.Run(&options.App{
		Title:            "Over Manga",
		Width:            1024,
		Height:           768,
		Assets:           assets,
		BackgroundColour: &options.RGBA{R: 27, G: 38, B: 54, A: 1},
		OnStartup:        _app.OnStartup,
		OnBeforeClose:		_app.OnBeforeClose,
		AssetsHandler:    NewFileLoader(),
		Bind: []interface{}{ _app },
	})

	if err != nil {
		log.Error.Println(err.Error())
	}
}
