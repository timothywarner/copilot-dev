FROM mcr.microsoft.com/devcontainers/universal:2

# Install additional OS packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        jq \
        tree \
        httpie \
        redis-tools \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install global Node.js packages
RUN su vscode -c "npm install -g typescript ts-node nodemon"

# Install Python packages
RUN su vscode -c "pip install --no-cache-dir \
    black \
    pylint \
    pytest \
    jupyter \
    redis \
    requests \
    fastapi \
    uvicorn"

# Copy custom VS Code settings
COPY .vscode/settings.json /home/vscode/.vscode-remote/data/Machine/settings.json

# Set up Git configuration
RUN git config --global pull.rebase true \
    && git config --global core.editor "code --wait" \
    && git config --global init.defaultBranch main

# Set up PowerShell profile
RUN mkdir -p /home/vscode/.config/powershell \
    && echo '$env:PYTHONPATH = "/workspace"' > /home/vscode/.config/powershell/Microsoft.PowerShell_profile.ps1 \
    && echo 'function prompt { "PS $($executionContext.SessionState.Path.CurrentLocation)> " }' >> /home/vscode/.config/powershell/Microsoft.PowerShell_profile.ps1

# Set ownership
RUN chown -R vscode:vscode /home/vscode/ 