FROM debian:bookworm AS build
RUN apt-get update && apt-get install -y g++ && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY main.cpp httplib.h ./
RUN g++ -std=c++17 -O2 -static-libstdc++ -static-libgcc main.cpp -o vedadb -lpthread

FROM debian:bookworm-slim
WORKDIR /app
COPY --from=build /app/vedadb ./vedadb
COPY index.html ./index.html

EXPOSE 8082
CMD ["./vedadb"]