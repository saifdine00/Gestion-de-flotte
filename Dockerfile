FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /App

COPY . ./
ARG TARGETARCH
RUN dotnet restore -a $TARGETARCH
RUN dotnet publish -a $TARGETARCH -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
COPY --from=build-env /App/out .
COPY start.sh /App/start.sh

# Create required directories for the application
RUN mkdir -p /App/data/images /App/data/documents /App/data/translations /App/data/temp /App/config /App/log && \
    chmod +x /App/start.sh

EXPOSE 8080
# Don't set ASPNETCORE_URLS here - let Program.cs handle it
# Railway will inject PORT automatically
ENTRYPOINT ["/App/start.sh"]
