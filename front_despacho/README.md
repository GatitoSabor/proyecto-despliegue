# Frontend Despacho - React + Vite

Frontend para el sistema de despachos de Innovatech Chile.

## Requisitos

- Node.js 20
- Docker

## Ejecución con Docker

```bash
docker build -t front-despacho .
docker run -d --name front-despacho -p 80:8080 front-despacho
```

## CI/CD

El pipeline en `.github/workflows/deploy.yml` se activa con push a la rama `deploy`:
1. Construye la imagen Docker
2. Publica en Docker Hub
3. Despliega en EC2 vía SSH

## Arquitectura

- Nginx sirve el build estático en puerto 8080
- Proxy inverso: `/api/v1/ventas` → back-ventas, `/api/v1/despachos` → back-despachos
