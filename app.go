package main

import (
	"context"
//	"encoding/json"
	"fmt"
	"io/ioutil"
)

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
}

// NewApp creates a new App application struct
func NewApp() *App {
	return &App{}
}

// startup is called when the app starts. The context is saved
// so we can call the runtime methods
func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

// Greet returns a greeting for the given name
func (a *App) Greet(name string) string {
	return fmt.Sprintf("Hello %s, It's show time!", name)
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
