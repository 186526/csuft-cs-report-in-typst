#!/usr/bin/env bash
# ============================================================
#  批量编译实验报告
#  用法：  ./build.sh              编译 reports/ 目录下的所有报告（默认）
#          ./build.sh demo         编译 demo/ 目录下的所有示例报告
#          ./build.sh all          编译 reports/ 与 demo/ 目录下的所有报告
#          ./build.sh lab-0920     只编译指定的报告
#  输出：  build/reports/*.pdf, build/demo/*.pdf
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

# ------------------------------------------------------------
#  环境与字体检查
# ------------------------------------------------------------
check_environment() {
  if ! command -v typst >/dev/null 2>&1; then
    echo "❌ 错误: 未检测到 typst 命令行工具。" >&2
    echo "   请先安装 Typst: https://github.com/typst/typst" >&2
    echo "   Linux 用户可通过包管理器安装（如 pacman -S typst / cargo install --locked typst-cli）" >&2
    exit 1
  fi

  local typst_ver
  typst_ver="$(typst --version 2>/dev/null || echo "typst")"

  local available_fonts
  available_fonts="$(typst fonts 2>/dev/null || true)"

  local missing_fonts=()

  if ! grep -q -F "SimSun" <<< "$available_fonts"; then
    missing_fonts+=("SimSun (中文字体/宋体)")
  fi

  if ! grep -q -F "Times New Roman" <<< "$available_fonts"; then
    missing_fonts+=("Times New Roman (西文字体)")
  fi

  if ! grep -q -F "Fira Code" <<< "$available_fonts" && ! grep -q -F "Sarasa Mono SC" <<< "$available_fonts"; then
    missing_fonts+=("Fira Code / Sarasa Mono SC (代码等宽字体)")
  fi

  if [ ${#missing_fonts[@]} -gt 0 ]; then
    echo "⚠️  警告: 检测到当前环境缺少以下推荐字体，排版或代码块可能使用系统备选字体：" >&2
    for f in "${missing_fonts[@]}"; do
      echo "   - $f" >&2
    done
    echo "   提示: 可将所需字体（.ttf / .otf）放置在 ~/.local/share/fonts/ 或 /usr/share/fonts/ 下。" >&2
  else
    printf '环境正常: %s (SimSun / Times New Roman / 代码字体已就绪)\n' "$typst_ver"
  fi
}

check_environment

# ------------------------------------------------------------
#  目标解析
# ------------------------------------------------------------
targets=()

if [ $# -gt 0 ]; then
  for arg in "$@"; do
    case "$arg" in
      demo|demo/)
        shopt -s nullglob
        for f in demo/*.typ; do targets+=("$f"); done
        shopt -u nullglob
        ;;
      reports|reports/)
        shopt -s nullglob
        for f in reports/*.typ; do targets+=("$f"); done
        shopt -u nullglob
        ;;
      all)
        shopt -s nullglob
        for f in reports/*.typ demo/*.typ; do targets+=("$f"); done
        shopt -u nullglob
        ;;
      *)
        if [ -d "$arg" ]; then
          shopt -s nullglob
          for f in "$arg"/*.typ; do targets+=("$f"); done
          shopt -u nullglob
        elif [ -f "$arg" ]; then
          targets+=("$arg")
        elif [ -f "${arg}.typ" ]; then
          targets+=("${arg}.typ")
        elif [ -f "reports/$arg" ]; then
          targets+=("reports/$arg")
        elif [ -f "reports/${arg}.typ" ]; then
          targets+=("reports/${arg}.typ")
        elif [ -f "demo/$arg" ]; then
          targets+=("demo/$arg")
        elif [ -f "demo/${arg}.typ" ]; then
          targets+=("demo/${arg}.typ")
        else
          [[ "$arg" == *.typ ]] && targets+=("$arg") || targets+=("${arg}.typ")
        fi
        ;;
    esac
  done
else
  shopt -s nullglob
  for f in reports/*.typ; do targets+=("$f"); done
  shopt -u nullglob
fi

if [ ${#targets[@]} -eq 0 ]; then
  echo "未找到任何待编译的 .typ 文件。" >&2
  exit 1
fi

# 去重
readarray -t unique_targets < <(printf '%s\n' "${targets[@]}" | sort -u)

# ------------------------------------------------------------
#  批量编译
# ------------------------------------------------------------
for f in "${unique_targets[@]}"; do
  if [ ! -f "$f" ]; then
    echo "文件不存在: $f" >&2
    exit 1
  fi
  out="build/${f%.typ}.pdf"
  mkdir -p "$(dirname "$out")"
  printf '编译 %-30s -> %s\n' "$f" "$out"
  typst compile --root . "$f" "$out"
done

echo "完成，共编译 ${#unique_targets[@]} 份报告，输出在 build/"
