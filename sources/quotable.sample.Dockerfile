FROM mcr.microsoft.com/dotnet/sdk:latest AS build-env
WORKDIR /app
COPY quotable/*.csproj ./
RUN dotnet restore
COPY quotable ./
RUN dotnet publish -c Release -o out -r linux-x64 /p:PublishSingleFile=true /p:PublishTrimmed=true /p:AssemblyName=Quotable

FROM mcr.microsoft.com/dotnet/aspnet:latest
WORKDIR /app
COPY --from=build-env /app/out /app/fonts .
ENTRYPOINT ["/app/Quotable"]
