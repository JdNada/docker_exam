Ce projet est une application Flask Dockerisée pour la gestion d'inventaire.  
Elle utilise Python 3.9, un utilisateur non-root, un script d'entrée (`entrypoint.sh`), et une configuration optimisée pour Docker.

🧱 Structure du projet
├── app.py
├── requirements.txt
├── entrypoint.sh
├── Dockerfile
└── README.md

🐳 Étapes de création de l'image Docker
1. Base de l'image
L'image de base utilisée est `python:3.9-slim`.
2. Métadonnées
L'image contient les métadonnées suivantes :
dockerfile
LABEL maintainer="nada"
LABEL version="1.0"
LABEL description="application d'inventaire"
3. Répertoire de travail
Le répertoire de travail dans le conteneur est /app.
dockerfile
WORKDIR /app
4. Optimisation du cache Docker
Copie des fichiers requirements.txt avant les fichiers de l'application :
dockerfile
COPY requirements.txt .
5. Installation des dépendances
Installation des dépendances avec pip et options d’optimisation :
dockerfile
RUN pip install --no-cache-dir --prefer-binary -r requirements.txt
6. Copie des fichiers de l'application
dockerfile
COPY . .
7. Création d'un utilisateur non-root
Un utilisateur appuser avec UID 1000 est créé et utilisé pour exécuter l’application :
dockerfile
RUN adduser --disabled-password --uid 1000 --gecos "" appuser
USER appuser
8. Port exposé
Le port 5000 est exposé :
dockerfile
EXPOSE 5000
9. Volume pour persistance des données
Définition d’un volume Docker pour /app/data :
dockerfile
VOLUME ["/app/data"]
10. Variables d’environnement
Définies dans le Dockerfile :
dockerfile
ENV DB_HOST=db
ENV DB_USER=inventoryuser
ENV DB_PASSWORD=secret
ENV DB_NAME=inventory
11. Healthcheck
Vérifie que l’application répond sur le port 5000 toutes les 30 secondes :
dockerfile
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5000/ || exit 1
⚠️ Nécessite curl installé dans l'image.
12. Script d’entrée (entrypoint.sh)
Le Dockerfile utilise un script shell comme point d’entrée :
dockerfile
ENTRYPOINT ["/app/entrypoint.sh"]
Ce script doit avoir les droits d’exécution (chmod +x entrypoint.sh).
13. Commande par défaut
La commande par défaut exécute l'application Flask :
dockerfile
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
🚀 Instructions de build et exécution
1. Construire l’image
bash:
docker build -t flask-app .
2. Exécuter le conteneur
bash:
docker run -p 5000:5000 flask-app
3. Accéder à l’application
Depuis un navigateur :
http://localhost:5000
Exécute la commande passée (CMD)







