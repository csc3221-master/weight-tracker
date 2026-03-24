# .devcontainer/Dockerfile
# Devcontainer image for Node development (Express will be installed via npm later)

FROM node:20-bookworm

# Optional: install helpful CLI tools (git is already present in most devcontainer images)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Keep container alive for VS Code (Compose will run "sleep infinity")
WORKDIR /workspaces
