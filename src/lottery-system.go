package main

import (
	"encoding/json"
	"log"
	"net/http"
)

type Status struct {
	Status string `json:"status"`
}

type Lottery struct {
	Lottery_Number string `json:"lottery number"`
	Store_id       string `json:"store ID"`
}

func healthStatus(w http.ResponseWriter, req *http.Request) {

	status := Status{Status: "ok"}
	json.NewEncoder(w).Encode(status)
}

func lotteryCheck(w http.ResponseWriter, req *http.Request) {
	if req.Method == "POST" {
		var reqLottery Lottery
		decoder := json.NewDecoder(req.Body)
		err := decoder.Decode(&reqLottery)
		if err != nil {
			http.Error(w, "Bad request body", http.StatusBadRequest)
			return
		}
		if reqLottery.Lottery_Number != "" {
			if reqLottery.Store_id != "" {
				status := Status{Status: "ok"}
				json.NewEncoder(w).Encode(status)
			} else {
				log.Println("Valid Store ID not provided")
				http.Error(w, "Please provide a valid Store ID", http.StatusBadRequest)
				return
			}

		} else {
			log.Println("Valid Lottery Number not provided")
			http.Error(w, "Please provide a valid Lottery Number", http.StatusBadRequest)
			return

		}

	} else {
		log.Println("only POST request is supported")
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return

	}
}

func main() {

	http.HandleFunc("/health", healthStatus)
	http.HandleFunc("/lottery", lotteryCheck)

	log.Fatal(http.ListenAndServe(":8090", nil))
}
