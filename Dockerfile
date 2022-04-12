#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["HerokuDockerImageExample.csproj", "."]
RUN dotnet restore "./HerokuDockerImageExample.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "HerokuDockerImageExample.csproj" -c Release -o /app/build

FROM build AS publish
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --assume-yes nodejs
RUN dotnet publish "HerokuDockerImageExample.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
CMD ASPNETCORE_URLS=http://*:$PORT dotnet HerokuDockerImageExample.dll
