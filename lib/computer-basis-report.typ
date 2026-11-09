#import "common.typ": *
#import "../config.typ": 学生信息

// ============================================================
//  计算机导论实验报告模版
//  依据《计算机导论》单个实验报告模板：小三号黑体加粗居中标题，
//  实验日期与地点信息行，实验目的、实验内容、实验过程记录、
//  实验小结四节，标题小四号黑体加粗，正文五号宋体 1.5 倍行距。
// ============================================================
#let 实验报告(
  实验名称: "",
  实验日期: "",
  地点: none,
  信息: 学生信息,
  // 兼容别名
  title: none,
  date: none,
  // 结构化小节
  实验目的: none,
  实验内容: none,
  实验过程记录: none,
  实验小结: none,
  // 格式控制
  分页小节: (),
  // 接收额外参数（支持 #show: 实验报告.with(...) 传入的 positional body）
  ..args,
) = {
  let body = if args.pos().len() > 0 { args.pos().at(0) } else { none }

  // 统一解析字段与默认值
  let report_title = if title != none { title } else { 实验名称 }
  let report_date = if date != none { date } else { 实验日期 }
  let report_place = if 地点 != none and 地点 != "" {
    地点
  } else if "实验室" in 信息 {
    信息.实验室
  } else {
    ""
  }

  // 页边距按课程模板：上下 2.54 cm，左右 3.17 cm
  set page(
    paper: "a4",
    margin: (top: 2.54cm, bottom: 2.54cm, x: 3.17cm),
  )
  set text(lang: "zh")

  正文样式(
    size: 正文字号,
    leading: 一点五倍行距,
    spacing: 0.75em,
    list-spacing: 0.45em,
  )[#{
    set par(justify: true, first-line-indent: 2em)

    // 插图居中，图题使用五号宋体
    show image: it => align(center, it)
    show figure.caption: it => text(font: 字体, size: 正文字号, weight: "bold")[#it]

    // 小节标题：小四号黑体加粗，段前段后各 0.5 行
    show heading: set text(font: 黑体, size: 小四字号, weight: "bold")
    show heading: set par(first-line-indent: 0pt, leading: 0.5em)
    show heading.where(level: 1): set block(above: 0.77em, below: 0.77em)

    // 标题：小三号黑体加粗居中
    if report_title != "" {
      align(center)[
        #v(0.3cm)
        #text(font: 黑体, size: 小三字号, weight: "bold")[#report_title]
        #v(0.3cm)
      ]
    }

    // 信息行：实验日期与地点
    block(width: 100%)[
      #set par(first-line-indent: 0pt)
      #grid(
        columns: (auto, 1fr, 3em, auto, 1fr),
        align: horizon,
        [实验日期：], 下划线字段(report_date),
        [],
        [地点：], 下划线字段(report_place),
      )
      #v(0.6cm)
    ]

    let 序号列表 = ("一", "二", "三", "四")
    let 结构化小节 = (
      ("实验目的", 实验目的),
      ("实验内容", 实验内容),
      ("实验过程记录", 实验过程记录),
      ("实验小结", 实验小结),
    )
    报告小节(结构化小节, 序号列表, 分页小节: 分页小节)

    // 自由正文内容
    if body != none and body != [] {
      body
    }
  }]
}

// 向下兼容旧版别名
#let project = 实验报告
