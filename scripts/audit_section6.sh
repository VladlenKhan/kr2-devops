# Раздел [6] для scripts/audit.sh (репозиторий devops-course-2026)
echo "[6] Контрольная работа № 2"

check "redis: контейнер healthy" \
  bash -c '[ "$(docker inspect -f "{{.State.Health.Status}}" "$(docker compose --project-directory "$HOME/kr2" ps -q redis)")" = healthy ]'

check "app: порт 8003 опубликован только на 127.0.0.1" \
  bash -c '[ "$(docker compose --project-directory "$HOME/kr2" port app 8003)" = "127.0.0.1:8003" ]'

check "kr2/.env: права 600" \
  bash -c '[ "$(stat -c %a "$HOME/kr2/.env")" = 600 ]'

check "kr2.crt: срок действия не менее 30 дней" \
  openssl x509 -checkend 2592000 -noout -in /etc/ssl/certs/kr2.crt

check "nginx: ресурс kr2 активирован" \
  test -L /etc/nginx/sites-enabled/kr2
