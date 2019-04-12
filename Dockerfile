FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY webtest/webtest.csproj webtest/
RUN dotnet restore webtest/webtest.csproj
COPY . .
WORKDIR /src/webtest
RUN dotnet build webtest.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish webtest.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "webtest.dll"]
