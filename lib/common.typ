#import "@preview/zebraw:0.4.4": zebraw

// ============================================================
//  字体与字号常量
// ============================================================
#let 中文字体 = "SimSun"
#let 西文字体 = "Times New Roman"
#let 代码字体 = ("Fira Code", "Sarasa Mono SC")
#let 字体 = (西文字体, 中文字体)

#let 正文字号 = 10.5pt  // 五号
#let 代码字号 = 9.5pt
#let 小四字号 = 12pt
#let 四号字号 = 14pt
#let 小三字号 = 15pt
#let 封面字号 = 15pt
#let 三号字号 = 16pt
#let 小二字号 = 18pt
#let 二号字号 = 22pt
#let 边框 = 0.5pt

// ============================================================
//  行距与字盒模型（对齐 Word docGrid 15.6pt 行网格）
// ============================================================
// 原 Word 模板正文节启用了行网格 docGrid linePitch="312" twips，
// 也就是每一行固定 312/20 = 15.6pt，与行内是中文还是西文无关。
// Typst 默认按行内字体的包围盒算行高：纯中文约 15.6pt、中英混排约 14.9pt、
// 纯西文约 13.8pt。这里用 top-edge / bottom-edge 把每种字体强制成 1em 高的盒子，
// 再补 leading 凑到 15.6pt。上下取值 0.85em / -0.15em 可让中文墨迹落在垂直中心。
#let 字盒上 = 0.85em
#let 字盒下 = -0.15em
#let 行距 = 0.4857em   // 字号 10.5pt 时约 5.1pt，1em + 5.1pt = 15.6pt

// 统一的正文文字设置（行距始终为字号的 1.4857 倍）
#let 正文样式(size: 正文字号, body) = {
  set text(font: 字体, size: size, top-edge: 字盒上, bottom-edge: 字盒下)
  set par(leading: 行距, spacing: 行距)
  body
}

// ============================================================
//  代码块样式（Zebraw 隔行换色与行号分割线）
// ============================================================
#let 代码块样式(body) = {
  show raw.where(block: true): it => {
    set text(font: 代码字体, size: 代码字号)
    show grid: g => {
      if g.columns == () and g.stroke == (:) {
        if (
          g.children.len() > 0
            and g.children.at(0).has("body")
            and g.children.at(0).body.has("width")
            and g.children.at(0).body.width != auto
        ) {
          grid(
            rows: g.rows,
            stroke: (left: 0.6pt + luma(180)),
            ..g.children,
          )
        } else {
          g
        }
      } else {
        g
      }
    }
    zebraw(
      inset: (x: 8pt, y: 3.5pt),
    )[#it]
  }
  show raw.where(block: false): set text(font: 代码字体)
  body
}

// 源代码：字符串自动包成代码块，其余原样输出
#let 源代码块(x, lang: "cpp") = {
  if type(x) == str { raw(x, lang: lang, block: true) } else { x }
}

// ============================================================
//  下划线与填空组件
// ============================================================
// 下划线填空（固定宽度，文本水平居中）
#let 填空(width, value) = box(
  width: width,
  height: 1em,
  stroke: (bottom: 0.5pt + black),
)[#align(center)[#value]]

// 下划线字段（弹性或指定宽度，适合表头信息栏）
#let 下划线字段(content, width: 100%) = box(
  width: width,
  stroke: (bottom: 0.8pt + black),
  inset: (bottom: 2pt),
)[#align(center)[#content]]

// ============================================================
//  表格单元格工具
// ============================================================
// 竖排文字（s 可以是字符串或 content）
#let 竖排(s, 字距: 0.05em) = {
  let t = if type(s) == str { s } else { s.text }
  stack(dir: ttb, spacing: 字距, ..t.clusters().map(c => [#c]))
}

// 标签格：水平 + 垂直居中，高度取 max(设定最小高度, 内容实际高度)
#let 标签格(h, body, ..args) = table.cell(
  align: center + horizon,
  inset: (x: 4pt, y: 2pt),
  ..args,
)[
  #context {
    let 高 = calc.max(h, measure(body).height + 6pt)
    block(height: 高, align(center + horizon, body))
  }
]

// 竖排标签格：同标签格，文字竖排
#let 竖标签格(h, body, ..args) = table.cell(
  align: center + horizon,
  inset: (x: 4pt, y: 2pt),
  ..args,
)[
  #context {
    let 竖 = 竖排(body)
    let 高 = calc.max(h, measure(竖).height + 6pt)
    block(height: 高, align(center + horizon, 竖))
  }
]

// 信息格：用于年级、姓名、实验名称等单行元数据（水平 + 垂直居中）
#let 信息格(body, ..args) = table.cell(
  align: center + horizon,
  inset: (x: 4pt, y: 2pt),
  ..args,
)[#body]

// 正文格：用于实验内容、实验环境、实验目的等大段正文/列表/代码（靠左上对齐）
#let 正文格(body, ..args) = table.cell(
  align: left + top,
  inset: (x: 8pt, y: 6pt),
  ..args,
)[#body]

// 兼容别名
#let 内容格 = 信息格
