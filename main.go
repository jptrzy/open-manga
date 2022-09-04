package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"strings"

	"github.com/webview/webview"
)

type JsonFile struct {
	Name string `json:"name"`
	Dir  bool   `json:"dir"`
}

type JsonResult struct {
	Files  []JsonFile `json:"files"`
	Path   string     `json:"path"`
	Status int        `json:"status"`
}

func get_files(path string) JsonResult {
	var status int = 0

	paths, err := ioutil.ReadDir(path)
	var files []JsonFile = []JsonFile{}
	if err != nil {
		fmt.Println("ERROR", err)
		status = 1
	} else {
		for _, f := range paths {
			files = append(files, JsonFile{Name: f.Name(), Dir: f.IsDir()})
		}
	}

	return JsonResult{Files: files, Path: path, Status: status}
}

func viewHandler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Path[5:]
	// fmt.Fprintf(w, "TEST"+r.Form.Get("p"))
	b, e := os.ReadFile(path)
	if e != nil {
		log.Fatal(e)
	}
	w.Write(b)
}

func init_fileServer() {
	http.HandleFunc("/view/", viewHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	win := webview.New(true)
	defer win.Destroy()
	win.SetTitle("Bind Example")
	win.SetSize(480, 320, webview.HintNone)

	bhtml, _ := os.ReadFile("static/index.html")
	bcss, _ := os.ReadFile("static/styles.css")
	bjs, _ := os.ReadFile("static/main.js")

	html := strings.ReplaceAll(string(bhtml), "/* STYLES */", string(bcss))
	html = strings.ReplaceAll(html, "/* JS */", string(bjs))

	// win.SetHtml(string(html))
	win.Navigate(`data:text/html,` + strings.ReplaceAll(url.QueryEscape(html), "+", "%20"))

	win.Bind("get_files", get_files)

	go init_fileServer()

	win.Run()
}
