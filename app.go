package main

import (
	"context"
//	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
)

func loadFile(path string) (string, bool) {

	dat, err := os.ReadFile(path)
	if err != nil {
		fmt.Printf(`Error "%s" while trying to read "%s".`, err, path)
		return "", false
	}
	
	return string(dat), true
}

type Config struct {

	ImgWidgth int `json:"img_width"`	
	ShowHiddenFiles bool `json:"show_hidden_files"`
	
}

func NewConfig() *Config {
	return &Config{}
}

func (c *Config) load(path string) int {
	
	return 0
}


func (c *Config) save(path string) int {
	
	return 0
}

type Cache struct {

	LastOpenDir string `json:"last_open_dir"`	

}

func NewCache() *Cache {
	return &Cache{}
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
	config* Config
	cache* Cache	
}

// NewApp creates a new App application struct
func NewApp() *App {
	return &App{}
}

// startup is called when the app starts. The context is saved
// so we can call the runtime methods
func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
	a.config = NewConfig()
	a.cache = NewCache()
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

func (a *App) UpdateConfig(config Config, save bool) Config {

	if save {
		a.config = &config
		//a.config.save()
	}

	return *a.config
}

