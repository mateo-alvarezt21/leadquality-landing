# ─── Etapa 1: Build ───────────────────────────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

# Instalar dependencias primero (aprovecha caché de Docker)
COPY package*.json ./
RUN npm ci

# Copiar el resto del código y construir
COPY . .
RUN npm run build

# ─── Etapa 2: Servidor de producción ──────────────────────────────────────────
FROM nginx:1.27-alpine AS runner

# Copiar el build estático
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiar configuración personalizada de nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
