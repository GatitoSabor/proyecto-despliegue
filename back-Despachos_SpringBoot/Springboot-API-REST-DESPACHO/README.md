# Backend Despachos - Spring Boot API REST

Microservicio de despachos para Innovatech Chile.

## Requisitos

- Java 17
- Docker
- MySQL

## Ejecución con Docker

```bash
docker build -t back-despachos .
docker run -d --name back-despachos -p 8081:8081 \
  -e DB_ENDPOINT=localhost \
  -e DB_PORT=3306 \
  -e DB_NAME=ventas_db \
  -e DB_USERNAME=root \
  -e DB_PASSWORD=root123 \
  back-despachos
```

## CI/CD

El pipeline en `.github/workflows/deploy.yml` se activa con push a la rama `deploy`:
1. Construye la imagen Docker
2. Publica en Docker Hub
3. Despliega en EC2 vía SSH

## Variables de Entorno

| Variable | Descripción |
|---|---|
| DB_ENDPOINT | Host de MySQL |
| DB_PORT | Puerto de MySQL |
| DB_NAME | Nombre de BD |
| DB_USERNAME | Usuario BD |
| DB_PASSWORD | Contraseña BD |
