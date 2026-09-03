from fastapi import FastAPI
app = FastAPI()

@app.get("/health")
def health(): return {"status": "UP", "service": "cart-service"}

@app.get("/items")
def get_cart():
    return {
        "status": "SUCCESS",
        "cart_id": "cart_99182",
        "items": [
            {"test_id": "T101", "name": "Complete Blood Count (CBC)", "qty": 1, "price": 25},
            {"test_id": "T104", "name": "HbA1c (Diabetes Test)", "qty": 1, "price": 30}
        ],
        "total_amount": 55,
        "currency": "USD"
    }
