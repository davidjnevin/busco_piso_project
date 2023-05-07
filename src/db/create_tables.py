from sqlalchemy import create_engine

from src.db.config import DATABASE_URL
from src.models.apartment_listing import create_apartment_listing

engine = create_engine(DATABASE_URL, echo=True)


def create_tables():
    create_apartment_listing()


if __name__ == "__main__":
    create_tables()
