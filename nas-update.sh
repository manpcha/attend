#!/bin/sh
# Run on NAS: /volume1/docker/attend/nas-update.sh
# git pull + docker build with host network (DNS bypass)

set -e
cd "$(dirname "$0")"

REPO_URL="https://github.com/manpcha/attend.git"
BRANCH="master"

echo "attend: NAS update start"

if [ -d .git ]; then
  echo "attend: git pull"
  git pull origin "$BRANCH"
else
  echo "attend: git init (first time)"
  git init
  git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"
  git fetch origin "$BRANCH"
  git checkout -B "$BRANCH" "origin/$BRANCH"
fi

echo "attend: docker build (network=host for DNS)"
export DOCKER_BUILDKIT=1
docker compose build

echo "attend: docker up"
docker compose up -d

echo "attend: status"
docker compose ps
curl -s http://127.0.0.1:8102/api/status || echo "(api not ready yet)"
echo ""
echo "attend: done"
