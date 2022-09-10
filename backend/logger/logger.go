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

func init() {
    file, err := os.OpenFile("logs.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
    if err != nil {
        log.Fatal(err)
    }

    Info = log.New(file, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile)
    Warn = log.New(file, "WARNING: ", log.Ldate|log.Ltime|log.Lshortfile)
    Error = log.New(file, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile)
}

