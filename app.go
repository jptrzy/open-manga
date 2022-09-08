package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
)

type File struct {
	name string `json:"name"`
	dir  bool   `json:"dir"`
}

type ScanDirJSON struct {
	files  []File `json:"files"`
	status int    `json:"status"`
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

func (a *App) ScanDir(path string) string {
	r := &ScanDirJSON{status: 0, files: []File{}}

	fmt.Println("Try scan '" + path + "' dir.")

	paths, err := ioutil.ReadDir(path)
	if err != nil {
		fmt.Println("Error ", err)
		r.status = 1
	} else {
		for _, f := range paths {
			r.files = append(r.files, File{name: f.Name(), dir: f.IsDir()})
		}
	}

	fmt.Println(r.files[0])

	rj, err := json.Marshal(r.files[0])
	fmt.Println(rj, string(rj), err)

	return fmt.Sprintf(string(rj))
}
