# syntax=docker/dockerfile:1.7

# ------------------------------------------------------------
# Builder base with Amazon Corretto 25 (JDK) on Alpine
# ------------------------------------------------------------
FROM amazoncorretto:25-alpine AS build-base

# Install minimal tooling for Maven Wrapper and debugging
RUN apk add --no-cache bash binutils coreutils curl findutils gzip tar unzip
WORKDIR /workspace

# Leverage Docker BuildKit caches for Maven repository
# https://docs.docker.com/build/buildkit/
# Prepare Maven Wrapper first to warm up wrapper distribution cache
COPY .mvn/ .mvn/
COPY mvnw mvnw
RUN chmod +x mvnw

# Copy only Maven descriptor to resolve dependencies
COPY pom.xml .

# Go offline to prefetch dependencies using cache mounts
RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw -B -V -e -DskipTests dependency:go-offline

# ------------------------------------------------------------
# Build the application
# ------------------------------------------------------------
FROM build-base AS build

# Now copy sources (done after deps to keep cache efficiency)
COPY src ./src

# Build the fat jar
RUN --mount=type=cache,target=/root/.m2 \
    ./mvnw -B -DskipTests=true clean package

# Determine the application jar path (avoid copying the *.original)
# and expose as build ARG/ENV for later stages
RUN APP_JAR=$(ls -1 target/*.jar | grep -v "original" | head -n1) && \
    echo "Detected artifact: ${APP_JAR}" && \
    mkdir -p /out && cp "$APP_JAR" /out/app.jar

# ------------------------------------------------------------
# Create a minimized JRE with jlink using module deps from the app jar
# ------------------------------------------------------------
FROM build-base AS jre

COPY --from=build /out/app.jar /workspace/app.jar

# Compute required modules using jdeps and assemble a compact runtime with jlink
# Strip debug symbols, man pages and exclude locales to reduce size
RUN set -eux; \
    MODULES=$(jdeps \
        --multi-release=base \
        --ignore-missing-deps \
        --print-module-deps \
        /workspace/app.jar); \
    echo "Detected modules: ${MODULES}"; \
    jlink \
      --add-modules "${MODULES},java.desktop,java.management" \
      --no-man-pages \
      --no-header-files \
      --strip-debug \
      --compress=2 \
      --output /opt/jre;

# Sanity check
RUN /opt/jre/bin/java -version

# ------------------------------------------------------------
# Runtime stage: lightweight base image + non-root user
# ------------------------------------------------------------
FROM alpine:3.20 AS runtime

# Add minimal runtime deps (certs, tzdata, and busybox wget for healthcheck)
RUN apk add --no-cache busybox-extras ca-certificates tzdata && \
    addgroup -S app && adduser -S -G app app
ENV TZ=UTC \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    JAVA_TOOL_OPTIONS="-XX:MaxRAMPercentage=75 -XX:InitialRAMPercentage=50 -XX:+UseZGC -XX:+ZGenerational -XX:+ExitOnOutOfMemoryError" \
    SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JAVA_HOME=/opt/jre \
    PATH=/opt/jre/bin:$PATH

WORKDIR /app

# Copy minimal JRE and the application
COPY --from=jre /opt/jre /opt/jre
COPY --from=build /out/app.jar /app/app.jar

# Use a writable tmp dir
RUN mkdir -p /app/logs /tmp && chown -R app:app /app /tmp

USER app

EXPOSE 8080

# JVM flags tuned for containers; enable CDS/AppCDS is possible in advanced builds
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app/app.jar"]

# ------------------------------------------------------------
# Pro tips
# ------------------------------------------------------------
# 1) Build with BuildKit for faster caching and smaller layers:
#    DOCKER_BUILDKIT=1 docker build -t demo-java25:latest .
# 2) Run:
#    docker run --rm -p 8080:8080 demo-java25:latest
# 3) Slim it further using Docker Slim (https://dockersl.im):
#    docker-slim build --http-probe=false --include-path /app --include-path /opt/jre \
#      --env JAVA_TOOL_OPTIONS --expose 8080 --copy-meta-artifacts demo-java25:latest
# 4) If your build needs proxies or private repos, pass Maven settings at build time:
#    docker build --build-arg MAVEN_CONFIG=... -t demo-java25:latest .
