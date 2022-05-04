#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["NET3.1-DOCKER.csproj", "."]
RUN dotnet restore "./NET3.1-DOCKER.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "NET3.1-DOCKER.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NET3.1-DOCKER.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Install promtail using binary
COPY promtail-linux-amd64-2.5 /app
COPY promtail-local-config.yaml /app
RUN chmod a+x /app/promtail-linux-amd64-2.5

copy init.sh /app
ENTRYPOINT ["/app/init.sh"]