# Base image manifest digests verified against Docker Hub on 2026-09-22.
FROM node:24.20.0-bookworm-slim@sha256:ba849c60be29959425b8734d57b8b4b7d56f98edd9504c9af091d5281095a71e AS frontend
WORKDIR /build/frontend
ENV CI=true
RUN npm install --global npm@11.19.0
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci
COPY frontend/ ./
RUN npm test -- --watch=false && npm run build

FROM eclipse-temurin:21-jdk-jammy@sha256:c7d5863b5dd8f26b90c64f1d80cc2b0e5a5e4642f8db9955a370d348edd8f438 AS backend
WORKDIR /build
RUN apt-get update \
	&& apt-get install --yes --no-install-recommends curl unzip \
	&& rm -rf /var/lib/apt/lists/*
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
COPY src/ src/
COPY --from=frontend /build/frontend/dist/skarb-kibica/browser/ src/main/resources/static/
RUN sh ./mvnw -B verify

FROM eclipse-temurin:21-jre-jammy@sha256:61d6c7b34d36aee3f45d043101259f97f3c6d428dc2a6f75513789983c5e254f AS runtime
WORKDIR /app
# Railway volumes are mounted as root. mountpoint verifies a real mount at startup.
USER 0:0
RUN apt-get update \
	&& apt-get install --yes --no-install-recommends util-linux \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir -p /data
COPY --from=backend /build/target/skarb-kibica-ligi-koszykowki-0.0.1-SNAPSHOT.jar /app/app.jar
COPY scripts/docker-entrypoint.sh /app/docker-entrypoint.sh
ENV PORT=8080 \
	DB_PATH=/data/skarb-kibica \
	DB_USERNAME=sa \
	JAVA_TOOL_OPTIONS="-Xmx256m -XX:+ExitOnOutOfMemoryError"
EXPOSE 8080
# Do not declare VOLUME: an implicit anonymous volume would hide a missing mount.
ENTRYPOINT ["sh", "/app/docker-entrypoint.sh"]
