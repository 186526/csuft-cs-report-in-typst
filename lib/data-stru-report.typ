#import "common.typ": *
#import "../config.typ": 学生信息

// ---------- 封面艺术字图片与尺寸（cm，与原 Word 模板一致） ----------
// 顶部“数据结构”4 字
#let 封面大图 = (
  ("../assets/cover-01.png", 3.00, 2.75),
  ("../assets/cover-02.png", 2.52, 2.83),
  ("../assets/cover-03.png", 2.46, 2.87),
  ("../assets/cover-04.png", 2.56, 2.84),
)
// 中部“学生实验报告”6 字
#let 封面小图 = (
  ("../assets/cover-05.png", 1.08, 1.35),
  ("../assets/cover-06.png", 0.96, 1.14),
  ("../assets/cover-07.png", 1.05, 1.36),
  ("../assets/cover-08.png", 1.36, 1.18),
  ("../assets/cover-09.png", 1.18, 1.22),
  ("../assets/cover-10.png", 1.09, 1.39),
)

// 针对数据结构实验，字符串源代码默认使用 C 语言高亮
#let 源代码块(x, lang: "c") = {
  if type(x) == str { raw(x, lang: lang, block: true) } else { x }
}



// ============================================================
//  封面
// ============================================================
#let 封面(信息: 学生信息) = {
  set page(
    paper: "a4",
    margin: (top: 2.8cm, bottom: 0.5cm, x: 2.4cm),
    fill: white,
  )
  正文样式(size: 封面字号)[#{
    v(3.5cm)

    // 顶部 4 张艺术字（“数据结构”）
    grid(
      columns: (1fr,) * 4,
      align: center + horizon,
      row-gutter: 0.4cm,
      ..封面大图.map(((f, w, h)) => image(f, width: w * 1cm, height: h * 1cm)),
    )

    v(3.6cm)

    // 6 张艺术字（“学生实验报告”，限制容器宽度与原版比例协调）
    align(center, block(width: 9.5cm)[
      #grid(
        columns: (1fr,) * 6,
        align: center + horizon,
        ..封面小图.map(((f, w, h)) => image(f, width: w * 1cm, height: h * 1cm)),
      )
    ])
    v(3.45cm)

    // 个人信息栏（下划线统一对齐）
    align(center, block(width: 9.2cm)[
      #grid(
        columns: (auto, 1fr),
        row-gutter: 0.55cm,
        column-gutter: 4pt,
        align: (col, _) => (if col == 0 { left + horizon } else { center + horizon }),
        [专　　业：], box(width: 100%, height: 1em, stroke: (bottom: 0.8pt + black))[#align(center)[#信息.专业]],
        [班　　级：], box(width: 100%, height: 1em, stroke: (bottom: 0.8pt + black))[#align(center)[#信息.班级]],
        [学　　号：], box(width: 100%, height: 1em, stroke: (bottom: 0.8pt + black))[#align(center)[#信息.学号]],
        [姓　　名：], box(width: 100%, height: 1em, stroke: (bottom: 0.8pt + black))[#align(center)[#信息.姓名]],
        [指导教师：], box(width: 100%, height: 1em, stroke: (bottom: 0.8pt + black))[#align(center)[#信息.指导教师]],
      )
    ])

    v(2.45cm)

    align(center)[#text(size: 12pt)[#(信息.学院)监制]]
  }]
}

// ============================================================
//  正文登记表
// ============================================================
#let 登记表(
  实验名称: "",
  实验室: "",
  实验日期: "",
  实验内容: [],
  实验环境: [],
  实验目的: [],
  源代码: [],
  实验结果分析及心得体会: [],
  实验评分: "",
  教师签名: "",
  评定日期: "",
  信息: 学生信息,
) = {
  // 9 列：直接照搬原 Word 模板的 gridCol 宽度（twips，总和 9000）
  // 763, 2253, 829, 829, 828, 830, 721, 288, 1659
  let 列 = (
    763fr,
    2253fr,
    829fr,
    829fr,
    828fr,
    830fr,
    721fr,
    288fr,
    1659fr,
  )
  // 行最小高度：照搬原模板 trHeight（twips → cm，1 twip = 0.0017639 cm）
  let 行高1 = 2.03cm // 1152 twips（年级/班号/组号/学号）
  let 行高2 = 1.81cm // 1029 twips（专业/日期/姓名）
  let 行高3 = 2.27cm // 1285 twips（实验名称/实验室）
  let 内容高 = 9.55cm // 5413 twips
  let 环境高 = 3.16cm // 1789 twips
  let 目的高 = 5.24cm // 2970 twips
  let 代码高 = 5.24cm // 2970 twips
  let 分析高 = 5.24cm // 2970 twips
  let 评定高 = 5.24cm // 2970 twips

  正文样式[#{
    show: 代码块样式


    table(
      columns: 列,
      stroke: 边框,
      inset: 0pt,

      // ---- 第 1 行：年级 / 班号 / 组号 / 学号 ----
      标签格(行高1)[年级], 信息格[#信息.年级],
      标签格(行高1)[班号], 信息格[#信息.班号],
      标签格(行高1)[组号], 信息格[#信息.组号],
      标签格(行高1)[学号],
      信息格(colspan: 2)[#信息.学号],

      // ---- 第 2 行：专业 / 日期 / 姓名 ----
      标签格(行高2)[专业], 信息格[#信息.专业],
      标签格(行高2)[日期],
      信息格(colspan: 3)[#if 实验日期 != "" [#实验日期] else [年　　月　　日]],
      标签格(行高2)[姓名],
      信息格(colspan: 2)[#信息.姓名],

      // ---- 第 3 行：实验名称 / 实验室 ----
      标签格(行高3)[实验名称],
      信息格(colspan: 5)[#实验名称],
      标签格(行高3, colspan: 2)[实验室],
      信息格[#实验室],

      // ---- 第 4 行：实验内容 ----
      标签格(内容高)[实验内容],
      正文格(colspan: 8)[#实验内容],

      // ---- 第 5 行：实验环境 ----
      标签格(环境高)[实验环境],
      正文格(colspan: 8)[#实验环境],

      // ---- 第 6 行：实验目的 ----
      标签格(目的高)[实验目的],
      正文格(colspan: 8)[#实验目的],

      // ---- 第 7 行：源代码 ----
      // 代码可能很长需要跨页，所以内容格不能写死高度
      竖标签格(代码高)[源代码],
      正文格(colspan: 8)[
        #源代码块(源代码)
      ],

      // ---- 第 8 行：实验结果分析及心得体会 ----
      竖标签格(分析高)[实验结果分析及心得体会],
      正文格(colspan: 8)[#实验结果分析及心得体会],

      // ---- 第 9 行：成绩评定 ----
      竖标签格(评定高)[成绩评定],
      table.cell(colspan: 8, align: right + bottom, inset: (right: 1.5cm, bottom: 0.6cm))[
        #grid(
          columns: (auto,),
          row-gutter: 0.5cm,
          align: right,
          [实验评分：#填空(3.5cm, 实验评分)],
          [教师签名：#填空(3.5cm, 教师签名)],
          [#if 评定日期 != "" [#评定日期] else [#填空(1.2cm, "") 年 #填空(0.8cm, "") 月 #填空(0.8cm, "") 日]],
        )
      ],
    )
  }]
}

// ============================================================
//  对外主函数
// ============================================================
#let 实验报告(
  实验名称: "",
  实验室: 学生信息.实验室,
  实验日期: "",
  实验内容: [],
  实验环境: [],
  实验目的: [],
  源代码: [],
  实验结果分析及心得体会: [],
  实验评分: "",
  教师签名: "",
  评定日期: "",
  显示封面: true,
  信息: 学生信息,
) = {
  if 显示封面 {
    封面(信息: 信息)
    pagebreak()
  }
  set page(
    paper: "a4",
    margin: (top: 2.54cm, bottom: 2.54cm, x: 3.17cm),
  )
  // 文字样式由 登记表 内部统一设置，这里不再重复
  登记表(
    实验名称: 实验名称,
    实验室: 实验室,
    实验日期: 实验日期,
    实验内容: 实验内容,
    实验环境: 实验环境,
    实验目的: 实验目的,
    源代码: 源代码,
    实验结果分析及心得体会: 实验结果分析及心得体会,
    实验评分: 实验评分,
    教师签名: 教师签名,
    评定日期: 评定日期,
    信息: 信息,
  )
}
