#import "common.typ": *
#import "common.typ" as common
#import "../config.typ": 学生信息

// ============================================================
//  Java 实验报告 / 课程设计模版
//  遵循中南林业科技大学 Java 课程设计说明书及实验报告编写规范
// ============================================================

// 针对 Java 语言的高亮辅助函数
#let 源代码块(x, lang: "java") = common.源代码块(x, lang: lang)

#let 实验报告(
  实验名称: "",
  课程名称: "Java程序设计",
  实验日期: "",
  班级: none,
  姓名: none,
  学号: none,
  指导教师: none,
  地点: none,
  信息: 学生信息,
  // 兼容别名
  title: none,
  course: none,
  date: none,
  class: none,
  name: none,
  id: none,
  teacher: none,
  // 结构化参数支持（遵循：目的、要求、内容、结果、练习、总结）
  实验目的: none,
  实验要求: none,
  实验内容: none,
  实验结果: none,
  实验练习: none,
  实验总结: none,
  // 额外可选结构化参数
  实验环境: none,
  源代码: none,
  心得体会: none,
  总结: none,
  参考文献: none,
  // 格式控制
  分页小节: (),
  // 接收额外参数（支持 #show: 实验报告.with(...) 传入的 positional body）
  ..args,
) = {
  let body = if args.pos().len() > 0 { args.pos().at(0) } else { none }

  // 统一解析字段与默认值
  let report_title = if title != none { title } else { 实验名称 }
  let report_course = if course != none { course } else { 课程名称 }
  let report_date = if date != none { date } else { 实验日期 }
  let report_class = if class != none { class } else if 班级 != none { 班级 } else { 信息.班级 }
  let report_name = if name != none { name } else if 姓名 != none { 姓名 } else { 信息.姓名 }
  let report_id = if id != none { id } else if 学号 != none { 学号 } else { 信息.学号 }
  let report_teacher = if teacher != none { teacher } else if 指导教师 != none { 指导教师 } else if "指导教师" in 信息 { 信息.指导教师 } else { "" }
  let report_place = if 地点 != none { 地点 } else if "实验室" in 信息 { 信息.实验室 } else { "" }
  let report_summary = if 实验总结 != none { 实验总结 } else if 总结 != none { 总结 } else { 心得体会 }

  // A4 正文宽 16cm，页脚阿拉伯数字居中。
  set page(
    paper: "a4",
    margin: (top: 2.54cm, bottom: 2.54cm, x: 2.5cm),
    footer: context {
      let page_num = counter(page).display("1")
      // 显式指定字盒边界，避免继承正文字盒导致页码位置偏移
      align(center)[#text(font: 字体, size: 10pt, top-edge: "ascender", bottom-edge: "descender")[#page_num]]
    },
  )
  set text(lang: "zh")

  // 12pt 字号配 6pt 行间留白，正文基线间距为 18pt。
  show: 正文样式.with(
    size: 小四字号,
    leading: 6pt,
    spacing: 6pt,
    list-spacing: 4pt,
  )
  set par(justify: false, first-line-indent: 0pt)
  set list(indent: 0pt, body-indent: 0.5em, tight: false, spacing: 4pt)
  set enum(indent: 0pt, body-indent: 0.5em, tight: false, spacing: 4pt)
  set strong(delta: 0)
  show strong: set text(font: 黑体, weight: "regular")

  show: 代码块样式.with(
    size: 9pt,
    background: luma(250),
    inset: (top: 2.5pt, bottom: 2.5pt, left: 4pt, right: 4pt),
    above: 0.45em,
    lang: false,
    output-style: (
      above: 5pt,
      below: 7pt,
      fill: luma(250),
      stroke: (left: 0.6pt + luma(190)),
      radius: 0pt,
      inset: (x: 8pt, y: 5pt),
    ),
  )
  show raw.where(block: false): set text(size: 0.9em)

  // 插图居中
  show image: it => align(center, it)

  // 图表规范：
  // 1. 图的标题写在图下方，表的标题写在表上方
  // 2. 正文中表格与插图的字体一律用 5 号宋体（正文字号 10.5pt）
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: it => text(font: 字体, size: 正文字号)[#it]
  show figure: set text(font: 字体, size: 正文字号)
  show table: set text(font: 字体, size: 10.5pt)
  show table: set par(leading: 0.4em)
  show table: set table(stroke: 0.45pt + luma(140), inset: (x: 7pt, y: 5pt))

  show math.equation: set text(font: ("New Computer Modern Math", ..字体), weight: "regular")

  show heading: set text(font: 黑体, weight: "regular")
  show heading: set par(first-line-indent: 0pt, justify: false, leading: 0.4em)

  show heading.where(level: 1): set text(font: 黑体, size: 小三字号, weight: "regular")
  show heading.where(level: 1): set block(above: 1.4em, below: 0.65em)

  show heading.where(level: 2): set text(font: 黑体, size: 四号字号, weight: "regular")
  show heading.where(level: 2): set block(above: 1.1em, below: 0.45em)

  show heading.where(level: 3): set text(font: 黑体, size: 小四字号, weight: "regular")
  show heading.where(level: 3): set block(above: 1.1em, below: 0.65em)

  报告标题(report_title, 黑体)

  报告信息栏((
    课程: report_course,
    日期: report_date,
    班级: report_class,
    姓名: report_name,
    学号: report_id,
    指导教师: report_teacher,
    地点: report_place,
  ), size: 小四字号, leading: 0.6em, below: 0.35cm, teacher-width: 12em)

  // 结构化小节渲染（遵循：目的、要求、内容、结果、练习、总结）
  let 序号列表 = ("一", "二", "三", "四", "五", "六", "七", "八", "九", "十")
  let 结构化小节 = (
    ("实验目的", 实验目的),
    ("实验环境", 实验环境),
    ("实验要求", 实验要求),
    ("实验内容", 实验内容),
    ("实验结果", 实验结果),
    ("源代码", if 源代码 != none and 源代码 != [] { 源代码块(源代码, lang: "java") } else { none }),
    ("实验练习", 实验练习),
    ("实验总结", report_summary),
    ("参考文献", 参考文献),
  )

  报告小节(结构化小节, 序号列表, 分页小节: 分页小节)

  // 自由正文内容（支持文档流模式）
  if body != none and body != [] {
    body
  }
}

// 向下兼容旧版别名
#let project = 实验报告
