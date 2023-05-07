import logging

from databases import Database
from fastapi import FastAPI

from src.db.config import DATABASE_URL

logger = logging.getLogger(__name__)


async def connect_to_db(app: FastAPI) -> None:
    database = Database(DATABASE_URL, min_size=10)

    try:
        await database.connect()
        app.state._db = database
    except Exception as e:
        logger.warn("--- DB CONNECTION ERROR ---")
        logger.warn(e)
        logger.warn("--- DB CONNECTION ERROR ---")
