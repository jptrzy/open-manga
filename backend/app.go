package app 

import (
	"context"
	"fmt"
	"io/ioutil"

	"over-manga/backend/config"

	"github.com/wailsapp/wails/v2/pkg/runtime"
)

type File struct {
	Name string `json:"name"`
	Dir  bool   `json:"dir"`
}

type ScanDirJSON struct {
	Files  []File `json:"files"`
	Status int    `json:"status"`
}

/* App Init */

type App struct {
	ctx context.Context
	_config* config.Config
	// Ensure that config is saved before quiting
	try_quit bool
	can_quit bool
}

func NewApp() *App {
	return &App{}
}

/* Wails Events */

func (a *App) OnStartup(ctx context.Context) {
	a.ctx = ctx
	a._config = config.NewConfig()

	a.try_quit = false
	a.can_quit = false
}

func (a *App) OnBeforeClose(ctx context.Context) (prevent bool) {
	fmt.Println("Before Close")	
	
	runtime.EventsEmit(ctx, "before_close")

	a.try_quit = true	

	return !a.can_quit 
}

/* For TS use */

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

