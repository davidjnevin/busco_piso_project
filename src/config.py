from starlette.config import Config
from starlette.datastructures import Secret

config = Config(".env")

PROJECT_NAME = "busco_piso"
VERSION = "1.0.0"
API_PREFIX = "/api"

SECRET_KEY = config(
    "SECRET_KEY", cast=Secret, default="unsafesecretkey_please_CHANGEME"
)
