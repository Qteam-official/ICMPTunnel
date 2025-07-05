FROM debian:bookworm-slim

LABEL version="1.3.0"
LABEL description="ICMPTunnel - Tunneling over ICMP protocol (commonly used by ping)"

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    bash \
    procps && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV REPO="Qteam-official/ICMPTunnel"
ENV RELEASE_ID="230106703"
ENV GITHUB_API="https://api.github.com/repos/$REPO/releases/$RELEASE_ID"
ENV BINARY_NAME="ICMPTunnel"
ENV INSTALL_PATH="/usr/local/bin/$BINARY_NAME"

# Create working directory
WORKDIR /app

# Download and install ICMPTunnel binary based on architecture
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        ARCH="amd64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        ARCH="arm64"; \
    elif [ "$TARGETARCH" = "arm" ]; then \
        ARCH="arm"; \
    else \
        ARCH="amd64"; \
    fi && \
    TARGET="ICMPTunnel-linux-$ARCH" && \
    URL=$(curl -s "$GITHUB_API" | grep browser_download_url | grep "$TARGET" | cut -d '"' -f 4) && \
    curl -L -o "$INSTALL_PATH" "$URL" && \
    chmod +x "$INSTALL_PATH"

# Download GeoIP database
RUN curl -L -o geoip-country.mmdb \
    "https://raw.githubusercontent.com/Qteam-official/ICMPTunnel/main/geoip/geoip-country.mmdb"

# Set proper permissions
RUN chown -R root:root /app

# Default command
CMD ["/usr/local/bin/ICMPTunnel", "-config", "/app/config.json"]
