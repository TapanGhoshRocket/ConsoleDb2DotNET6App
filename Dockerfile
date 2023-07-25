FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

ENV LD_LIBRARY_PATH="/app/clidriver/lib/"
RUN apt-get -y update && apt-get install -y libxml2

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY ["ConsoleDb2DotNET6App.csproj", "."]
RUN dotnet restore "./ConsoleDb2DotNET6App.csproj"

COPY . .
WORKDIR "/src/."
RUN dotnet build "ConsoleDb2DotNET6App.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ConsoleDb2DotNET6App.csproj" -c Release -o /app/publish 

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV PATH=$PATH:/app/clidriver/lib:/app/clidriver/adm
CMD tail -f /dev/null