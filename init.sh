#!/bin/bash

# Start promtail
nohup /app/promtail-linux-amd64-2.5 -config.file=/app/promtail-local-config.yaml -config.expand-env &

# Start .NET Application
dotnet /app/NET3.1-DOCKER.dll