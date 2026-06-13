# ── Build stage ──
FROM gcc:13-bookworm AS build
WORKDIR /app
COPY main.cpp httplib.h ./
RUN g++ -std=c++17 -O2 main.cpp -o vedadb -lpthread

# ── Runtime stage ──
FROM debian:bookworm-slim
WORKDIR /app
COPY --from=build /app/vedadb ./vedadb
COPY index.html ./index.html

EXPOSE 8080
CMD ["./vedadb"]
