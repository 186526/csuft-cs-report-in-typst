#import "@preview/zebraw:0.4.4": zebraw

// ============================================================
//  字体与字号常量
// ============================================================
#let 中文字体 = "SimSun"
#let 西文字体 = "Times New Roman"
#let 代码字体 = ("Fira Code", "Sarasa Mono SC")
#let 字体 = (西文字体, 中文字体)
#let 黑体 = (西文字体, "SimHei", 中文字体)

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
//  行距与字盒模型
// ============================================================
// 字盒边界：用 top-edge / bottom-edge 把每种字体强制成 1em 高的盒子，
// 保证中西文混排与纯中西文在不同行上的基线与行高绝对统一。上下取值 0.85em / -0.15em
// 可让中文字形墨迹居中对齐。
#let 字盒上 = 0.85em
#let 字盒下 = -0.15em

// 行距标准常量：
// 1. 单倍行距（0.4857em）：对齐 Word docGrid linePitch="312" twips（15.6pt 行网格），
//    字号 10.5pt 时行高 15.6pt（1em + 5.1pt），适用于紧凑表格单元格（如数据结构登记表）。
// 2. 一点二五倍行距（0.625em）：字号 10.5pt 时行高约 17.1pt，字号 12pt 时行高约 19.5pt，阅读适中。
// 3. 一点五倍行距（0.75em）：中南林业科技大学实验报告/课程设计标准行距（对应 Word 1.5 倍行距），
//    字号 12pt（小四）时行高 21pt（1em + 9pt），字号 10.5pt（五号）时行高 18.4pt。
#let 单倍行距 = 0.4857em
#let 一点二五倍行距 = 0.625em
#let 一点五倍行距 = 0.75em

// 默认正文行距采用高校实验报告主流的 1.5 倍行距（0.75em）
#let 行距 = 一点五倍行距

// 统一的正文文字设置（支持自定义字号、行距、段距与列表间距）
#let 正文样式(
  size: 正文字号,
  leading: 行距,
  spacing: 0.75em,
  list-spacing: 0.45em,
  body,
) = {
  set text(font: 字体, size: size, top-edge: 字盒上, bottom-edge: 字盒下)
  set par(leading: leading, spacing: spacing)
  set list(spacing: list-spacing)
  set enum(spacing: list-spacing)
  body
}

// ============================================================
//  代码块样式（Zebraw 隔行换色与行号分割线）
// ============================================================
#let 代码块样式(body) = {
  show raw.where(block: true): it => {
    // 代码块使用独立行高（cap-height→baseline），不受正文 1em 字盒与段距影响，
    // 这样不同正文号的模板代码行距一致，且不会被撑得过松。
    set text(font: 代码字体, size: 代码字号, top-edge: "cap-height", bottom-edge: "baseline")
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
    let is-code = it.lang != none and it.lang != "text" and it.lang != "txt"
    if is-code {
      set block(above: 0.4em, below: 0.4em)
      zebraw(
        inset: (x: 8pt, y: 2.8pt),
        lang: true,
      )[#it]
    } else {
      // 终端/报错/纯文本输出：无行号轻量控制台样式，整洁紧凑
      set block(above: 0.25em, below: 0.25em)
      block(
        fill: rgb("#f8fafc"),
        stroke: 0.5pt + rgb("#e2e8f0"),
        radius: 3pt,
        inset: (x: 8pt, y: 4pt),
        width: 100%,
        clip: true,
        {
          set text(font: 代码字体, size: 0.9em)
          set par(leading: 0.45em, justify: false)
          it.lines.map(l => l.body).join([\ ])
        },
      )
    }
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

// ============================================================
//  连续正文报告组件
// ============================================================
#let 报告标题(标题, 标题字体) = {
  if 标题 != "" {
    align(center)[
      #v(0.2cm)
      #text(font: 标题字体, size: 二号字号, weight: "bold")[#标题]
      #v(0.6cm)
    ]
  }
}

#let 报告信息栏(信息) = block(width: 100%)[
  #set text(font: 字体, size: 四号字号)
  #set par(first-line-indent: 0pt, leading: 1.2em)
  #grid(
    columns: (auto, 1fr, 3em, auto, 1fr),
    align: horizon,
    [课程名称：], 下划线字段(信息.课程),
    [],
    [实验日期：], 下划线字段(信息.日期),
  )
  #v(0.4cm)
  #grid(
    columns: (auto, 1fr, 2em, auto, 1fr, 2em, auto, 1fr),
    align: horizon,
    [班#h(1em)级：], 下划线字段(信息.班级),
    [],
    [姓#h(1em)名：], 下划线字段(信息.姓名),
    [],
    [学#h(1em)号：], 下划线字段(信息.学号),
  )
  #if "指导教师" in 信息 and 信息.指导教师 != "" {
    v(0.4cm)
    grid(
      columns: (auto, 1fr),
      align: horizon,
      [指导教师：], 下划线字段(信息.指导教师),
    )
  }
  #v(0.8cm)
]

#let 报告小节(结构化小节, 序号列表, 分页小节: ()) = {
  let sec_idx = 0
  for (sec_title, sec_content) in 结构化小节 {
    if sec_content != none and sec_content != [] {
      if sec_title in 分页小节 {
        pagebreak()
      }
      sec_idx += 1
      let num_str = if sec_idx <= 序号列表.len() { 序号列表.at(sec_idx - 1) } else { str(sec_idx) }
      [= #num_str、#sec_title]
      sec_content
    }
  }
}
