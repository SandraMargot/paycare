# Image Python alignée avec les tests
FROM python:3.10-slim

WORKDIR /app
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

# On monte un répertoire data (lecture/écriture)
VOLUME ["/app/data"]

# Pas de port à exposer pour un ETL batch
# EXPOSE 8090  # inutile, on supprime

# Lancer l'ETL (qui lit/écrit dans /app/data)
CMD ["python", "app/etl.py"]