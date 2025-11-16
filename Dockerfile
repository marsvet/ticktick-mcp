FROM python:3.11-alpine

EXPOSE 8080 8000

WORKDIR /app

RUN apk add uv && uv venv && source .venv/bin/activate

RUN uv tool install mcp-proxy
ENV PATH="/root/.local/bin:$PATH"

COPY requirements.txt setup.py .
RUN uv pip install -e .

COPY . .

# Copy and set permissions for entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Use ENTRYPOINT to support both stdio and http modes
# Control mode via MCP_TRANSPORT environment variable:
#   - stdio: Run MCP server directly (for standard input/output communication, default)
#   - http: Use mcp-proxy to provide HTTP interface
# Other optional environment variables:
#   - MCP_HOST: Host address for HTTP mode (default: 0.0.0.0)
#   - MCP_PORT: Port for HTTP mode (default: 8080)
ENTRYPOINT ["/entrypoint.sh"]
