package main

import (
	"context"
	//	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"over-manga/config"

	"github.com/wailsapp/wails/v2/pkg/runtime"
)

func loadFile(path string) (string, bool) {
		
	dat, err := os.ReadFile(path)
	if err != nil {
		fmt.Printf(`Error "%s" while trying to read "%s".`, err, path)
		return "", false
	}
	
	return string(dat), true
}

type File struct {
	Name string `json:"name"`
	Dir  bool   `json:"dir"`
}

type ScanDirJSON struct {
	Files  []File `json:"files"`
	Status int    `json:"status"`
}

// App struct
type App struct {
	ctx context.Context
	_config* config.Config
	// Ensure that config is saved before quiting
	try_quit bool
	can_quit bool
}

// NewApp creates a new App application struct
func NewApp() *App {
	return &App{}
}

// startup is called when the app starts. The context is saved
// so we can call the runtime methods
func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
	a._config = config.NewConfig()

	a.try_quit = false
	a.can_quit = false
}

func (a *App) onBeforeClose(ctx context.Context) (prevent bool) {
	fmt.Println("Before Close")	
	
	runtime.EventsEmit(ctx, "before_close")

	a.try_quit = true	

	return !a.can_quit 
}

func (a *App) ScanDir(path string) ScanDirJSON{
	r := ScanDirJSON{Status: 0, Files: []File{}}

	fmt.Println("Try scan '" + path + "' dir.")

	paths, err := ioutil.ReadDir(path)
	if err != nil {
		fmt.Println("Error ", err)
		r.Status = 1
	} else {
		for _, f := range paths {
			r.Files = append(r.Files, File{Name: f.Name(), Dir: f.IsDir()})
		}
	}

	return r
}

func (a *App) UpdateConfig(c config.Config, save bool) config.Config {
	if save {
		a._config = &c
		a._config.Save(config.CONFIG_PATH)
		
		if a.try_quit {
			a.can_quit = true
		}
	}

	return *a._config
}

