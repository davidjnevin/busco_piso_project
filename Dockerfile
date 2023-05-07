FROM python:3.10-bullseye

WORKDIR /app
#set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

# install system dependencies
RUN apt-get update \
  && apt-get -y install netcat gcc postgresql \
  && apt-get clean


# App requirements
COPY requirements.txt .
RUN pip install --no-cache -r requirements.txt

# Dev Requirements
COPY requirements-dev.txt .
RUN pip install --no-cache -r requirements-dev.txt

COPY . .

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
