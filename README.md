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

## Levantar el stack completo

```bash
docker-compose up -d
```

Esto inicia MySQL, ambos backends y el frontend. El frontend queda accesible en `http://localhost`.

## Levantar servicios individuales

Cada subproyecto tiene su propio Dockerfile para build individual:

```bash
# Frontend
cd front_despacho
docker build -t front-despacho .
docker run -d --name front-despacho -p 80:8080 front-despacho

# Backend Ventas
cd back-Ventas_SpringBoot/Springboot-API-REST
docker build -t back-ventas .
docker run -d --name back-ventas -p 8080:8080 -e DB_ENDPOINT=localhost ... back-ventas

# Backend Despachos
cd back-Despachos_SpringBoot/Springboot-API-REST-DESPACHO
docker build -t back-despachos .
docker run -d --name back-despachos -p 8081:8081 -e DB_ENDPOINT=localhost ... back-despachos
```

## Variables de Entorno

| Variable | Default | Descripción |
|---|---|---|
| `MYSQL_ROOT_PASSWORD` | root123 | Contraseña root de MySQL |
| `DB_NAME` | ventas_db | Nombre de la base de datos |
| `DB_ENDPOINT` | mysql | Host de MySQL |
| `DB_PORT` | 3306 | Puerto de MySQL |
| `DB_USERNAME` | root | Usuario de BD |
| `DB_PASSWORD` | root123 | Contraseña de BD |

## Persistencia de Datos

Se usa un **named volume** (`mysql_data`) montado en `/var/lib/mysql` para persistir los datos de MySQL. Esto asegura que la información no se pierde al reiniciar contenedores.

## CI/CD - GitHub Actions

Cada servicio tiene su propio pipeline en `.github/workflows/deploy.yml` que se activa con **push a la rama `deploy`**:

1. **Build**: Construye la imagen Docker multi-stage
2. **Push**: Publica la imagen en Docker Hub
3. **Deploy**: Conecta vía SSH a EC2, descarga la nueva imagen y reinicia el contenedor

### Secrets requeridos en GitHub

| Secret | Propósito |
|---|---|
| `DOCKER_USERNAME` | Usuario de Docker Hub |
| `DOCKER_PASSWORD` | Token/contraseña de Docker Hub |
| `EC2_HOST_FRONT` | IP pública EC2 Frontend |
| `EC2_HOST_VENTAS` | IP privada EC2 Backend Ventas |
| `EC2_HOST_DESPACHOS` | IP privada EC2 Backend Despachos |
| `EC2_USER` | Usuario SSH de EC2 |
| `EC2_SSH_KEY` | Clave privada SSH de EC2 |
| `DB_ENDPOINT` | Host de MySQL |
| `DB_NAME` | Nombre BD |
| `DB_USERNAME` | Usuario BD |
| `DB_PASSWORD` | Contraseña BD |

## Decisiones Técnicas

- **Multi-stage build**: Reduce tamaño de imágenes finales separando compilación de ejecución
- **Usuario no root**: Backends usan `adduser` + `USER appuser`; frontend usa `nginxinc/nginx-unprivileged`
- **Named volumes**: Elegido sobre bind mounts por mejor portabilidad, rendimiento y aislamiento
- **Docker Hub**: Seleccionado sobre ECR por simplicidad y costo cero
- **Rama deploy**: Aísla el despliegue del desarrollo activo en main
