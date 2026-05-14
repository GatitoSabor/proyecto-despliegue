# Proyecto Innovatech Chile - Despliegue DevOps

Arquitectura de microservicios contenerizados para el sistema de despachos de Innovatech Chile, con despliegue automatizado en AWS EC2 mediante CI/CD.

## Arquitectura

```
                    Internet
                        |
                  [EC2 Frontend]
                 (puerto 80:8080)
                        |
                    Nginx (proxy inverso)
                   /                   \
          /api/v1/ventas        /api/v1/despachos
                  |                       |
           [EC2 Backend]           [EC2 Backend]
          back-ventas:8080     back-despachos:8081
                  |                       |
                   \                     /
                    [MySQL:3306]
                  (volumen mysql_data)
```

## Servicios

| Servicio | Tecnología | Puerto | Docker Hub |
|---|---|---|---|
| front-despacho | React + Vite + Nginx | 80 → 8080 | `*/front-despacho` |
| back-ventas | Spring Boot + Java 17 | 8080 | `*/back-ventas` |
| back-despachos | Spring Boot + Java 17 | 8081 | `*/back-despachos` |
| mysql | MySQL 8.0 | 3306 | mysql:8.0 |

## Requisitos

- Docker Desktop
- Docker Compose
- Git


