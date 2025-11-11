FROM python:3.11-alpine

EXPOSE 8080 8000

WORKDIR /app

RUN apk add uv && uv venv && source .venv/bin/activate

RUN uv tool install mcp-proxy
ENV PATH="/root/.local/bin:$PATH"

COPY requirements.txt setup.py .
RUN uv pip install -e .

COPY . .

CMD [ \
    "mcp-proxy", \
    "--host=0.0.0.0", \
    "--port=8080", \
    "--pass-environment", \
    "--named-server", \
    "ticktick-mcp", \
    "uv run -m ticktick_mcp.cli run" \
]
