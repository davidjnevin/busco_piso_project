from sqlalchemy import create_engine, text

from src.db.config import DATABASE_URL

engine = create_engine(DATABASE_URL, echo=True)


def hello_connection():
    with engine.connect() as conn:
        result = conn.execute(text("select 'hello, connection'"))
        print(result.all())
