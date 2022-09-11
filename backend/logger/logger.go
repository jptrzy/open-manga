package logger

import (
	"log"
	"os"
)

var (
    Warn *log.Logger
    Info *log.Logger
    Error *log.Logger
)

var CONFIG_PATH = os.Getenv("HOME") + "/.config/over-manga"

func init() {
	path := os.Getenv("XDG_CACHE_HOME")
	
	if (path == "") {
		path = os.Getenv("HOME") + "/.cache"
	}

	os.MkdirAll(path, os.ModePerm)

	path += "/over-manga.log"

	file, err := os.OpenFile(path, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0665)
	if err != nil {
		log.Fatal(err)
	}

	Info = log.New(file, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile)
	Warn = log.New(file, "WARNING: ", log.Ldate|log.Ltime|log.Lshortfile)
	Error = log.New(file, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile)
}

