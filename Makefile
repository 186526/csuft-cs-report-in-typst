# ============================================================
#  CSUFT CS Typst 实验报告 Makefile
# ============================================================

.PHONY: default all demo clean help

# 默认目标：直接运行 ./build.sh（默认编译 reports/ 目录下的报告）
default:
	@./build.sh

# 编译 demo/ 目录下的示例报告
demo:
	@./build.sh demo

# 编译全部报告（reports/ 与 demo/）
all:
	@./build.sh all

# 清理构建生成的 PDF 目录
clean:
	@rm -rf build
	@echo "已清理 build 目录"

# 显示帮助信息
help:
	@echo "可用的 Make 目标:"
	@echo "  make            - 默认编译 reports/ 目录下的所有实验报告"
	@echo "  make demo       - 编译 demo/ 目录下的示例报告"
	@echo "  make all        - 编译 reports/ 与 demo/ 目录下的所有报告"
	@echo "  make <文件名>   - 编译指定名称的报告"
	@echo "  make clean      - 清理 build/ 目录"

# 捕获其他任意参数并透传给 ./build.sh
%:
	@./build.sh $@
