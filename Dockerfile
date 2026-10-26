FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# непривилегированный пользователь
RUN groupadd --system --gid 10001 app \
 && useradd --system --uid 10001 --gid app --no-create-home --shell /usr/sbin/nologin app

WORKDIR /app

# сначала зависимости: слой кэшируется, пока requirements.txt не менялся
COPY requirements.txt .
RUN pip install -r requirements.txt

# затем код приложения
COPY --chown=app:app . .

USER app
EXPOSE 8003

# exec-форма: Flask — PID 1, SIGTERM доходит до приложения;
# 0.0.0.0 — слушаем на всех интерфейсах сетевого пространства контейнера
CMD ["flask", "--app", "app", "run", "--host", "0.0.0.0", "--port", "8003"]
