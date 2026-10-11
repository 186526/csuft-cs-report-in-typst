#import "common.typ": *
#import "../config.typ": 学生信息

// ============================================================
//  Java 实验报告 / 课程设计模版
//  遵循中南林业科技大学 Java 课程设计说明书及实验报告编写规范
// ============================================================

// 针对 Java 语言的高亮辅助函数
#let 源代码块(x, lang: "java") = {
  if type(x) == str { raw(x, lang: lang, block: true) } else { x }
}

#let 实验报告(
  实验名称: "",
  课程名称: "Java程序设计",
  实验日期: "",
  班级: none,
  姓名: none,
  学号: none,
  指导教师: none,
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
  let report_summary = if 实验总结 != none { 实验总结 } else if 总结 != none { 总结 } else { 心得体会 }

  // 页面基准配置（A4 纸，页边距按规范：上 2.54cm，下 2.54cm，左 3.17cm，右 3.17cm；页脚阿拉伯数字居中）
  set page(
    paper: "a4",
    margin: (top: 2.54cm, bottom: 2.54cm, x: 3.17cm),
    footer: context {
      let page_num = counter(page).display("1")
      align(center)[#text(font: 字体, size: 10pt)[#page_num]]
    },
  )
  set text(lang: "zh")

  // 正文样式（按规范：正文采用小4号宋体，1.5倍行距，首行缩进 2 字符）
  set text(font: 字体, size: 小四字号)
  set par(
    leading: 0.75em,
    spacing: 0.75em,
    justify: true,
    first-line-indent: 2em,
  )
  set list(spacing: 0.75em)
  set enum(spacing: 0.75em)

  // 代码块隔行换色与等宽字体规则
  show: 代码块样式

  // 插图居中
  show image: it => align(center, it)

  // 图表规范：
  // 1. 图的标题写在图下方，表的标题写在表上方
  // 2. 正文中表格与插图的字体一律用 5 号宋体（正文字号 10.5pt）
  show figure.where(kind: table): set figure.caption(position: top)
  show figure.caption: it => text(font: 字体, size: 正文字号)[#it]
  show figure: set text(font: 字体, size: 正文字号)
  show table: set table(inset: (x: 8pt, y: 6pt))

  // 标题级别样式（按规范）：
  // 一级标题：小3号黑体，加粗，段前0.5行，段后0.5行
  show heading.where(level: 1): it => block(above: 1.5em, below: 0.8em)[
    #set text(font: 黑体, size: 小三字号, weight: "bold")
    #set par(first-line-indent: 0pt)
    #it
  ]

  // 二级标题：4号黑体，加粗
  show heading.where(level: 2): it => block(above: 1.2em, below: 0.6em)[
    #set text(font: 黑体, size: 四号字号, weight: "bold")
    #set par(first-line-indent: 0pt)
    #it
  ]

  // 三级标题：小4号黑体，加粗
  show heading.where(level: 3): it => block(above: 1.0em, below: 0.5em)[
    #set text(font: 黑体, size: 小四字号, weight: "bold")
    #set par(first-line-indent: 0pt)
    #it
  ]

  // 顶部实验名称大标题（二号黑体居中）
  if report_title != "" {
    align(center)[
      #v(0.2cm)
      #text(font: 黑体, size: 二号字号, weight: "bold")[#report_title]
      #v(0.6cm)
    ]
  }

  // 顶部元数据栏（课程名称、实验日期、班级、姓名、学号、指导教师）
  block(width: 100%)[
    #set text(font: 字体, size: 四号字号)
    #set par(first-line-indent: 0pt, leading: 1.2em)
    #grid(
      columns: (auto, 1fr, 3em, auto, 1fr),
      align: horizon,
      [课程名称：], 下划线字段(report_course),
      [],
      [实验日期：], 下划线字段(report_date),
    )
    #v(0.4cm)
    #grid(
      columns: (auto, 1fr, 2em, auto, 1fr, 2em, auto, 1fr),
      align: horizon,
      [班#h(1em)级：], 下划线字段(report_class),
      [],
      [姓#h(1em)名：], 下划线字段(report_name),
      [],
      [学#h(1em)号：], 下划线字段(report_id),
    )
    #if report_teacher != "" {
      v(0.4cm)
      grid(
        columns: (auto, 1fr),
        align: horizon,
        [指导教师：], 下划线字段(report_teacher),
      )
    }
    #v(0.8cm)
  ]

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

  // 自由正文内容（支持文档流模式）
  if body != none and body != [] {
    body
  }
}

// 向下兼容旧版别名
#let project = 实验报告
