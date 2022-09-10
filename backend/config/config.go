package config

import (
	"os"
	"errors"
	"encoding/json"
	"io/ioutil"

	log "over-manga/backend/logger"
)

var CONFIG_PATH = os.Getenv("HOME") + "/.config/over-manga"

type Config struct {

	ImgWidgth int `json:"img_width"`	
	ShowHiddenFiles bool `json:"show_hidden_files"`

	LastDir string `json:"last_dir"`

}

func NewConfig() *Config {
	c := &Config{
		ImgWidgth: 200,
		ShowHiddenFiles: false,
		LastDir: "",
	}

	c.load()

	return c 
}

func (c *Config) load() int {

	if _, err := os.Stat(CONFIG_PATH+"/config.json"); err == nil {
		log.Info.Println("Loading config.")
		
		file, _ := ioutil.ReadFile(CONFIG_PATH+"/config.json")
		_ = json.Unmarshal([]byte(file), c)

	} else if errors.Is(err, os.ErrNotExist) {	
		log.Info.Println("Couldn't find config file.")
		c.Save(CONFIG_PATH)
	} else {
		log.Error.Println("Cute Schrödinger's cat while checking a config file.")
	}

	return 0
}


func (c *Config) Save(path string) int {
	log.Info.Println("Saving config.")

	os.MkdirAll(path, os.ModePerm)

	file, _ := json.MarshalIndent(c, "", " ")
	_ = ioutil.WriteFile(path+"/config.json", file, 0644)

	return 0
}

