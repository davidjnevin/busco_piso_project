from fastapi import FastAPI

from src.api_routes.health_check import router as health_check_router

app = FastAPI()
app.include_router(health_check_router)
