#import "common.typ": *

#let 封面信息栏(信息) = align(center, block(width: 9.2cm)[
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

#let 报告登记表(元数据, 正文, 评分) = {
  // 原 Word 模板的九列宽度（twips，总和 9000）与最小行高。
  let 列 = (763fr, 2253fr, 829fr, 829fr, 828fr, 830fr, 721fr, 288fr, 1659fr)
  let 行高1 = 2.03cm
  let 行高2 = 1.81cm
  let 行高3 = 2.27cm
  let 内容高 = 9.55cm
  let 环境高 = 3.16cm
  let 目的高 = 5.24cm
  let 代码高 = 5.24cm
  let 分析高 = 5.24cm
  let 评定高 = 5.24cm

  正文样式(
    size: 正文字号,
    leading: 单倍行距,
    spacing: 0.5em,
    list-spacing: 0.5em,
  )[#{
    show: 代码块样式

    table(
      columns: 列,
      stroke: 边框,
      inset: 0pt,

      标签格(行高1)[年级], 信息格[#元数据.年级],
      标签格(行高1)[班号], 信息格[#元数据.班号],
      标签格(行高1)[组号], 信息格[#元数据.组号],
      标签格(行高1)[学号],
      信息格(colspan: 2)[#元数据.学号],

      标签格(行高2)[专业], 信息格[#元数据.专业],
      标签格(行高2)[日期],
      信息格(colspan: 3)[#if 元数据.实验日期 != "" [#元数据.实验日期] else [年　　月　　日]],
      标签格(行高2)[姓名],
      信息格(colspan: 2)[#元数据.姓名],

      标签格(行高3)[实验名称],
      信息格(colspan: 5)[#元数据.实验名称],
      标签格(行高3, colspan: 2)[实验室],
      信息格[#元数据.实验室],

      标签格(内容高)[实验内容],
      正文格(colspan: 8)[#正文.实验内容],

      标签格(环境高)[实验环境],
      正文格(colspan: 8)[#正文.实验环境],

      标签格(目的高)[实验目的],
      正文格(colspan: 8)[#正文.实验目的],

      竖标签格(代码高)[源代码],
      正文格(colspan: 8)[#正文.源代码],

      竖标签格(分析高)[实验结果分析及心得体会],
      正文格(colspan: 8)[#正文.实验结果分析及心得体会],

      竖标签格(评定高)[成绩评定],
      table.cell(colspan: 8, align: right + bottom, inset: (right: 1.5cm, bottom: 0.6cm))[
        #grid(
          columns: (auto,),
          row-gutter: 0.5cm,
          align: right,
          [实验评分：#填空(3.5cm, 评分.实验评分)],
          [教师签名：#填空(3.5cm, 评分.教师签名)],
          [#if 评分.评定日期 != "" [#评分.评定日期] else [#填空(1.2cm, "") 年 #填空(0.8cm, "") 月 #填空(0.8cm, "") 日]],
        )
      ],
    )
  }]
}
