package main
import (
	"encoding/json"
	"net/http"
)

type Response struct {
	Status  string      `json:"status"`
	Service string      `json:"service"`
	Data    interface{} `json:"data,omitempty"`
}

func main() {
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(Response{Status: "UP", Service: "payment-service"})
	})

	http.HandleFunc("/transactions", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		mockTx := map[string]interface{}{
			"gateway": "CareGrid Secure Pay Engine",
			"status": "SETTLED",
			"recent_transactions": []map[string]string{
				{"tx_id": "tx_90114", "amount": "$55.00", "status": "SUCCESS", "timestamp": "2026-09-02T11:40:00Z"},
				{"tx_id": "tx_90115", "amount": "$35.00", "status": "SUCCESS", "timestamp": "2026-09-02T11:42:00Z"},
			},
		}
		json.NewEncoder(w).Encode(Response{Status: "SUCCESS", Service: "payment-service", Data: mockTx})
	})

	http.ListenAndServe(":5005", nil)
}
