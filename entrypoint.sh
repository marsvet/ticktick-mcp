#!/bin/sh
set -e

# Default to stdio mode
MCP_TRANSPORT=${MCP_TRANSPORT:-stdio}

if [ "$MCP_TRANSPORT" = "stdio" ]; then
    # stdio mode: Run MCP server directly
    exec uv run -m ticktick_mcp.cli run
elif [ "$MCP_TRANSPORT" = "http" ]; then
    # http mode: Use mcp-proxy wrapper
    MCP_HOST=${MCP_HOST:-0.0.0.0}
    MCP_PORT=${MCP_PORT:-8080}
    exec mcp-proxy \
        --host="$MCP_HOST" \
        --port="$MCP_PORT" \
        --pass-environment \
        --named-server \
        ticktick-mcp \
        "uv run -m ticktick_mcp.cli run"
else
    echo "Error: Unsupported transport mode '$MCP_TRANSPORT'. Supported modes: stdio, http"
    exit 1
fi
