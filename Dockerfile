FROM python:3.11

WORKDIR /app

# App requirements
COPY requirements.txt .
RUN pip install --no-cache -r requirements.txt

# Dev Requirements
COPY requirements-dev.txt .
RUN pip install --no-cache -r requirements-dev.txt

COPY . .

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
