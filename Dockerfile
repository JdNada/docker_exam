FROM python:3.9-slim

LABEL maintainer="nada"
LABEL version="1.0"
LABEL description="application d'inventaire"

RUN apt-get update \
 && apt-get install -y curl \
 && rm -rf /var/lib/apt/lists/* \
 && adduser --disabled-password --uid 1000 --gecos "" appuser

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir --prefer-binary -r requirements.txt

COPY . .

RUN chown -R appuser:appuser /app

# Donner les droits d'exécution aux scripts
RUN chmod +x /app/entrypoint.sh /app/healthcheck.sh || true

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV FLASK_APP=app.py

ENV DB_HOST=db
ENV DB_USER=inventoryuser
ENV DB_PASSWORD=secret
ENV DB_NAME=inventory

EXPOSE 5000

USER appuser

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD ["/app/healthcheck.sh"]

# Définir le script shell comme ENTRYPOINT
ENTRYPOINT ["/app/entrypoint.sh"]

# La commande par défaut
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
