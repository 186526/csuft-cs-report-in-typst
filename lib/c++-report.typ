#import "common.typ": *
#import "../config.typ": 学生信息

// ============================================================
//  C++ 实验报告模版
// ============================================================
#let 实验报告(
  实验名称: "",
  课程名称: "C++程序设计",
  实验日期: "",
  班级: none,
  姓名: none,
  学号: none,
  信息: 学生信息,
  // 兼容别名
  title: none,
  course: none,
  date: none,
  class: none,
  name: none,
  id: none,
  // 结构化参数支持（可类似 data-stru 报告直接传参）
  实验目的: none,
  实验环境: none,
  实验要求: none,
  实验内容: none,
  源代码: none,
  心得体会: none,
  实验结果分析及心得体会: none,
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
  let report_feedback = if 实验结果分析及心得体会 != none { 实验结果分析及心得体会 } else { 心得体会 }

  // 页面基准配置
  set page(
    paper: "a4",
    margin: (top: 2.54cm, bottom: 2.54cm, x: 3.17cm),
  )
  set text(lang: "zh")

  // 正文样式与代码块样式
  正文样式(
    size: 正文字号,
    leading: 一点五倍行距,
    spacing: 0.75em,
    list-spacing: 0.75em,
  )[#{
    show: 代码块样式

    // 图片居中
    show image: it => align(center, it)

    // 图表标题样式
    show figure.caption: it => text(font: 字体, size: 10.5pt, weight: "bold")[#it]

    // 标题级别样式（四号/五号加粗，去除缩进，保持合理段距）
    show heading: set par(first-line-indent: 0pt)

    show heading.where(level: 1): set text(font: 字体, size: 四号字号, weight: "bold")
    show heading.where(level: 1): set block(above: 1.6em, below: 0.8em)

    show heading.where(level: 2): set text(font: 字体, size: 正文字号, weight: "bold")
    show heading.where(level: 2): set block(above: 1.3em, below: 0.65em)

    show heading.where(level: 3): set text(font: 字体, size: 正文字号, weight: "bold")
    show heading.where(level: 3): set block(above: 1.1em, below: 0.55em)

    // 顶部大标题
    报告标题(report_title, 字体)

    // 顶部元数据栏（课程、日期、班级、姓名、学号）
    报告信息栏((
      课程: report_course,
      日期: report_date,
      班级: report_class,
      姓名: report_name,
      学号: report_id,
    ))

    // 正文段落默认设置（首行缩进 2 字符，两端对齐）
    set par(justify: true, first-line-indent: 2em)

    // 结构化小节（如有直接传入则自动渲染对应小节）
    let 序号列表 = ("一", "二", "三", "四", "五", "六", "七", "八")
    let 结构化小节 = (
      ("实验目的", 实验目的),
      ("实验环境", 实验环境),
      ("实验要求", 实验要求),
      ("实验内容", 实验内容),
      ("源代码", if 源代码 != none and 源代码 != [] { 源代码块(源代码, lang: "cpp") } else { none }),
      ("实验结果分析及心得体会", report_feedback),
    )
    报告小节(结构化小节, 序号列表)

    // 自由正文内容
    if body != none and body != [] {
      body
    }
  }]
}

// 向下兼容旧版别名
#let project = 实验报告
