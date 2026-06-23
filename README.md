# Innovatech Chile - Sistema Orquestado y Automatizado en AWS (EP3)

Este repositorio contiene la solución de arquitectura, orquestación y automatización CI/CD para la plataforma de **Innovatech Chile**, migrando la infraestructura base y los contenedores hacia un clúster altamente disponible, escalable y tolerante a fallos en Amazon Web Services (AWS).

## 🚀 Arquitectura del Sistema

La arquitectura implementada se basa en servicios Serverless para optimizar costos y reducir la carga operativa de administración de servidores, utilizando **AWS ECS (Elastic Container Service) con AWS Fargate**.

* **Networking:** Configuración de VPC con subredes públicas y privadas distribuidas en múltiples zonas de disponibilidad (AZ) para garantizar alta disponibilidad.
* **Balanceo de Carga:** Un *Application Load Balancer* (ALB) actúa como punto único de entrada público (Puerto 80), redirigiendo el tráfico de manera inteligente hacia los contenedores del Frontend.
* **Seguridad (Security Groups):** El clúster de ECS está aislado internamente; solo acepta tráfico entrante en los puertos de la aplicación si este proviene directamente del Security Group del ALB.
* **Registro de Imágenes:** Las imágenes Docker optimizadas se almacenan de forma privada en **Amazon ECR (Elastic Container Registry)**.

---

## 🛠️ Stack Tecnológico & Insumos

* **Orquestador:** AWS ECS (Fargate)
* **Pipeline CI/CD:** GitHub Actions
* **Contenedores:** Docker / Amazon ECR
* **Monitoreo & Logs:** Amazon CloudWatch
* **Entorno de Despliegue:** AWS Academy Learner Lab

---

## 🤖 Pipeline CI/CD (GitHub Actions)

El flujo de integración y despliegue continuo está automatizado mediante la acción definida en `.github/workflows/deploy.yml`. Cada vez que se realiza un `push` a la rama `main`, se ejecutan de forma secuencial los siguientes pasos:

1.  **Checkout Code:** Clonación del código fuente en el runner de GitHub.
2.  **Configure AWS Credentials:** Autenticación en AWS utilizando variables temporales de AWS Academy (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_SESSION_TOKEN`).
3.  **Login to Amazon ECR:** Autenticación segura en el registro privado de AWS.
4.  **Build & Push:** Compilación de la imagen Docker basada en el `Dockerfile` local, asignándole un tag único mediante el hash del commit (`${{ github.sha }}`) y subiéndola a ECR.
5.  **Deploy to ECS:** Actualización del *Task Definition* con la nueva imagen y refresco automático del servicio en el clúster sin tiempo de inactividad (*Zero Downtime Deployment*).

---

## 📈 Configuración de Autoescalado (Autoscaling)

Para mitigar fallas ante aumentos imprevistos en la carga de usuarios, se configuró una política de **Target Tracking**:

* **Métrica:** Utilización promedio de CPU (`ECSServiceAverageCPUUtilization`).
* **Umbral (Target Value):** 50%.
* **Justificación Técnica:** Fijar el umbral al 50% permite al orquestador aprovisionar y levantar nuevas réplicas de los contenedores *antes* de que los servicios actuales se saturen por completo o experimenten degradación de rendimiento, garantizando una alta tolerancia a fallos.

---

## 🔍 Gestión de Secretos y Variables de Entorno

Toda la información sensible (credenciales de bases de datos, tokens de APIs y llaves de acceso de AWS) se encuentra protegida:
* **En GitHub:** Almacenada estrictamente en *GitHub Repository Secrets*.
* **En el Clúster:** Inyectada dinámicamente en los contenedores en tiempo de ejecución a través de la sección de variables de entorno de las *Task Definitions*, evitando la exposición de datos en texto plano en el repositorio de código.

---

## 🪵 Monitoreo y Análisis de Logs

El comportamiento de la aplicación, los tiempos de respuesta y la comunicación interna entre el Frontend y el Backend se auditan mediante **Amazon CloudWatch Logs**. Los flujos de logs permiten:
* Verificar el estado de salud (*Health Checks*) de los contenedores detrás del balanceador.
* Analizar fallas en tiempo de ejecución de la aplicación.
* Monitorear los tiempos de ejecución del pipeline de GitHub Actions para optimizar los procesos de Build.
