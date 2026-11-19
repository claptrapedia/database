FROM postgres:17.2

# The database is created on first container start from POSTGRES_DB.
# Do not initialise data in this image; the official entrypoint owns that.
