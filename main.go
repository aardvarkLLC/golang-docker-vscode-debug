package main

import (
	"encoding/json"
	"net/http"
)

type H map[string]interface{}

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(H{
			"data": "some sample data",
		}); err != nil {
			panic(err)
		}
	})
	http.ListenAndServe(":8080", nil)
}
