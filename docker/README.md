# MiniOps Docker Infrastructure Lab

## Overview

A hands-on local infrastructure lab built using Docker Engine, Docker Compose, Nginx, and Ubuntu on WSL 2.

This lab demonstrates containerization, service networking, persistent storage, backup and restore, and health monitoring.

## 1. Docker Images

Build the MiniOps application image:

```bash
docker build -f docker/Dockerfile -t miniops-web:1.0 .
```

List images:

```bash
docker images
```

Inspect an image:

```bash
docker image inspect miniops-web:1.0
```

## 2. Docker Containers

Run the standalone web container:

```bash
docker run -d \
  --name miniops-web \
  -p 127.0.0.1:8081:80 \
  miniops-web:1.0
```

List running containers:

```bash
docker ps
```

List all containers:

```bash
docker ps -a
```

Stop or start the standalone container:

```bash
docker stop miniops-web
docker start miniops-web
```

## 3. Docker Compose

Compose file: `docker/compose.yaml`

Validate configuration:

```bash
docker compose -f docker/compose.yaml config -q
```

Start services:

```bash
docker compose -f docker/compose.yaml up -d
```

List services:

```bash
docker compose -f docker/compose.yaml ps
```

Stop services:

```bash
docker compose -f docker/compose.yaml stop
```

The Compose project contains:

- web: Nginx web server
- toolbox: Alpine Linux diagnostic container

## 4. Docker Networking

Network: `miniops-lab_lab-net`

Type: User-defined bridge network.

The containers communicate using Docker service names.

Test internal connectivity:

```bash
docker compose -f docker/compose.yaml exec toolbox \
  wget -qO- http://web:80
```

Test the web service from the host:

```bash
curl -I http://127.0.0.1:8082
```

Expected response:

```text
HTTP/1.1 200 OK
```

## 5. Persistent Storage

Named Volume: `miniops-lab_lab-data`

Mount point inside toolbox: `/data`

Read the stored test file:

```bash
docker compose -f docker/compose.yaml exec toolbox \
  cat /data/last-check.txt
```

We verified that the file remains available after recreating the toolbox container.

## 6. Backup and Restore

### Create Backup

Run from the project root:

```bash
mkdir -p storage/backups

docker run --rm \
  -v miniops-lab_lab-data:/data:ro \
  -v "$PWD/storage/backups:/backup" \
  alpine:3.22 \
  tar -czf /backup/lab-data.tar.gz -C /data .
```

### Verify Backup

```bash
tar -tzf storage/backups/lab-data.tar.gz
```

### Create Restore Volume

```bash
docker volume create miniops-restore-test
```

### Restore Data

```bash
docker run --rm \
  -v miniops-restore-test:/data \
  -v "$PWD/storage/backups:/backup:ro" \
  alpine:3.22 \
  sh -c 'tar -xzf /backup/lab-data.tar.gz -C /data && cat /data/last-check.txt'
```

Result: Backup and Restore tested successfully.

The backup is stored locally and should also be copied off-device when used for important data.

## 7. Docker Healthchecks

The web service uses an HTTP healthcheck.

Health status:

- starting: Initial health evaluation
- healthy: Configured healthcheck passes
- unhealthy: Healthcheck fails repeatedly

We tested an intentionally failing healthcheck while Nginx continued returning HTTP 200.

Important: Running does not always mean Healthy.

Docker Engine does not automatically restart a container solely because its health status becomes unhealthy.

## 8. Security Notes

- Web ports are published to 127.0.0.1 for local access.
- Docker group membership grants powerful host privileges.
- Never commit secrets or sensitive backups to Git.
- Avoid `docker compose down -v` unless volume deletion is intentional.
- Persistent storage is not a substitute for backups.


## 9. Kubernetes Integration

After completing the Docker labs, I used the
MiniOps application to practice Kubernetes.

I created a local kind cluster and tested:

- Deployments and ReplicaSets
- ClusterIP Services
- Scaling and self-healing
- Readiness and Liveness probes
- Rolling updates and rollback
- ConfigMaps, Secrets and RBAC
- Multiple namespaces

The Kubernetes configuration files and detailed
test results are documented in kubernetes/README.md.

## What I Learned

Docker helped me understand how containers,
images, networks and volumes work.

One important lesson was that a running container
is not always healthy.

I also learned why persistent volumes and backups
are different, and why checking the actual service
response is important during troubleshooting.
