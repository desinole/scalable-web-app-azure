FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source

COPY app/wordyapi/wordyapi.csproj .
RUN dotnet restore --use-current-runtime  

COPY app/wordyapi/. .
RUN dotnet publish --use-current-runtime --self-contained false --no-restore -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "wordyapi.dll"]