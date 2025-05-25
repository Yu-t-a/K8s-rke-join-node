#!/bin/bash


if [ -z "$1" ]; then
  echo "❌ กรุณาใส่ข้อความ commit เช่น: ./push.sh \"add new file\""
  exit 1
fi

commit_msg="$*"

git add .
git commit -m "$commit_msg"
git push origin $(git rev-parse --abbrev-ref HEAD)
