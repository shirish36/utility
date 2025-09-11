FROM debian:stable-slim

# Install networking utilities (Debian-based for richer tooling)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    dnsutils \
    iproute2 \
    iputils-ping \
    traceroute \
    openssh-client \
    netcat-openbsd \
    tcpdump \
    mtr-tiny \
    jq \
    bash \
    procps \
    net-tools \
    openssl \
    && rm -rf /var/lib/apt/lists/*

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

# Copy only the new network-focused scripts and make them executable
RUN mkdir -p /workspace/scripts
COPY scripts/00_net_info.sh /workspace/scripts/
COPY scripts/10_connectivity_check.sh /workspace/scripts/
COPY scripts/20_external_ip_check.sh /workspace/scripts/
COPY scripts/30_firewall_path_check.sh /workspace/scripts/
COPY scripts/net_all.sh /workspace/scripts/
RUN chmod +x /workspace/scripts/*.sh \
    && ls -la /workspace/scripts \
    && ln -sf /workspace/scripts/net_all.sh /usr/local/bin/net-all \
    && ln -sf /workspace/scripts/00_net_info.sh /usr/local/bin/net-info \
    && ln -sf /workspace/scripts/10_connectivity_check.sh /usr/local/bin/net-check \
    && ln -sf /workspace/scripts/20_external_ip_check.sh /usr/local/bin/net-egress \
    && ln -sf /workspace/scripts/30_firewall_path_check.sh /usr/local/bin/net-path

# Set working directory
WORKDIR /workspace

# Default command (can be overridden in Cloud Run)
CMD ["net-all"]
