# CSUFT CS Typst 实验报告模板

中南林业科技大学计算机相关课程的 Typst 实验报告模板，支持 C、C++、数据结构和 Java，输出 PDF。

## 快速开始

安装 [Typst CLI](https://github.com/typst/typst#installation)，准备 Bash 4+；使用 `make` 命令还需要 GNU Make。已有 Rust 工具链时，可运行 `cargo install --locked typst-cli` 安装 Typst。

推荐字体为 SimSun、Times New Roman、SimHei（Java 标题），代码字体使用 Fira Code 或 Sarasa Mono SC。运行 `typst fonts` 查看已识别字体；缺少字体时构建会警告，替代字体可能影响分页。首次编译且无缓存时需要联网下载 `@preview/zebraw:0.4.4`。

在仓库根目录执行：

```bash
# 首次创建个人配置，保留已有文件
[ -f config.typ ] || cp config.example.typ config.typ
# 编辑 config.typ，填写学生信息后编译示例
make demo
```

PDF 输出到 `build/demo/`。各模板均需要 `config.typ`，该文件由 Git 忽略，个人信息保留在本地。

## 从示例编写报告

| 课程 | 示例 | 模板 |
| --- | --- | --- |
| C 程序设计 | [demo/c.typ](demo/c.typ) | [lib/c-report.typ](lib/c-report.typ) |
| C++ 程序设计 | [demo/c++.typ](demo/c++.typ) | [lib/c++-report.typ](lib/c++-report.typ) |
| 数据结构 | [demo/data-stru.typ](demo/data-stru.typ) | [lib/data-stru-report.typ](lib/data-stru-report.typ) |
| Java 程序设计 | [demo/java.typ](demo/java.typ) | [lib/java-report.typ](lib/java-report.typ) |

复制对应 demo 到 `reports/`，按示例填写实验内容。各模板参数不同，正文、表格及代码的具体写法见示例；多个源码文件使用 C 示例中的内容块写法。复制时同步调整 `read(...)` 和图片的相对路径，路径以调用所在的 `.typ` 文件为基准。

例如：

```bash
mkdir -p reports
cp demo/java.typ reports/my-java.typ
# 编辑 reports/my-java.typ 后编译
./build.sh reports/my-java.typ
```

输出为 `build/reports/my-java.pdf`。报告中的 C、C++、Java 源码仅作为文本展示。

## 构建与预览

在仓库根目录执行：

```bash
make                    # 编译 reports/ 下的报告
make demo               # 编译 demo/ 下的示例
make all                # 编译报告与示例
./build.sh demo/c.typ    # 编译指定文件，也可传入多个文件
make help               # 查看命令帮助
make clean              # 删除整个 build/，包括手动放入的文件
```

可以用 `./build.sh demo`、`./build.sh all` 代替对应 Make 命令。输出保留输入的相对路径：`<目录>/<文件>.typ` → `build/<目录>/<文件>.pdf`。

持续预览：

```bash
mkdir -p build/demo
typst watch --root . demo/java.typ build/demo/java.pdf
```

## 本地资源与维护

`lib/` 存放模板和公共样式，`assets/` 存放数据结构封面图片，`demo/code/` 存放示例源码。`reports/` 是本地报告目录，部分报告从 `project/` 读取课程源码。

`config.typ`、`build/`、`project/`、`.vscode/` 及匹配 `lab*.typ` 的报告（`lab-demo.typ` 例外）由 Git 忽略，不一定随仓库分发。编译本地报告前检查所需资源及 `project/` 的符号链接目标；首次验证模板使用 `make demo`。

维护约定与验证要求见 [AGENTS.md](AGENTS.md)。
