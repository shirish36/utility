FROM alpine:latest

# Install utility packages
RUN apk update && apk add --no-cache \
    curl \
    wget \
    bind-tools \
    iputils \
    traceroute \
    openssh-client \
    python3 \
    py3-pip \
    git \
    vim \
    nano \
    bash \
    jq \
    tree \
    htop \
    netcat-openbsd \
    tcpdump \
    && rm -rf /var/cache/apk/*

# Create data directories for volume mounts
RUN mkdir -p /data/in /data/out && \
    chmod 755 /data/in /data/out

# Set environment variables (can be overridden in Cloud Run)
ENV TARGET_URL=https://www.google.com
ENV TARGET_HOST=google.com
ENV DOWNLOAD_URL=https://example.com/file.txt
ENV OUTPUT_FILE=output.txt
ENV INPUT_DIR=/data/in
ENV OUTPUT_DIR=/data/out

# Copy scripts and make them executable
COPY scripts/ /workspace/scripts/
RUN chmod +x /workspace/scripts/*.sh

# Set working directory
WORKDIR /workspace

# Default command (can be overridden in Cloud Run)
CMD ["/bin/bash"]
