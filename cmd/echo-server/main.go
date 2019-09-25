package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"strconv"
)

func main() {
	var (
		msg  = flag.String("message", "Hello World!", "response message")
		port = flag.Int("port", 8080, "server port")
	)

	flag.Parse()

	log.Printf("Start Server - msg: %q port %q\n", *msg, strconv.Itoa(*port))
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Request - %s\n", r.URL.Path)
		fmt.Fprintf(w, *msg)
	})
	http.ListenAndServe(":"+strconv.Itoa(*port), nil)
}
