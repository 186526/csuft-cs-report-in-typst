#!/usr/bin/env bash
# ============================================================
#  批量编译所有实验报告
#  用法：  ./build.sh          编译全部 lab*.typ
#          ./build.sh lab03    只编译 lab03
#  输出：  build/labXX.pdf
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p build

if [ $# -gt 0 ]; then
  targets=()
  for t in "$@"; do
    [[ "$t" == *.typ ]] && targets+=("$t") || targets+=("${t}.typ")
  done
else
  shopt -s nullglob
  targets=(lab*.typ)
fi

if [ ${#targets[@]} -eq 0 ]; then
  echo "没有找到 lab*.typ 文件" >&2
  exit 1
fi

for f in "${targets[@]}"; do
  out="build/${f%.typ}.pdf"
  printf '编译 %-24s -> %s\n' "$f" "$out"
  typst compile --root ../ "$f" "$out"
done

echo "完成，共 ${#targets[@]} 份报告，输出在 build/"
