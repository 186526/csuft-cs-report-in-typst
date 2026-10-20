#import "common.typ": *
#import "common.typ" as common
#import "form-layout.typ": 封面信息栏, 报告登记表
#import "../config.typ": 学生信息

// ============================================================
//  C 语言实验报告模版
//  适用课程：C 程序设计 / C 语言程序设计
// ============================================================

// 针对 C 语言的高亮辅助函数
#let 源代码块(x, lang: "c") = common.源代码块(x, lang: lang)

// ============================================================
//  封面
// ============================================================
#let 封面(
  课程名称: "C 程序设计",
  信息: 学生信息,
  专业: none,
  班级: none,
  学号: none,
  姓名: none,
  指导教师: none,
) = {
  let rep_major = if 专业 != none { 专业 } else if "专业" in 信息 { 信息.专业 } else { "" }
  let rep_class = if 班级 != none { 班级 } else if "班级" in 信息 { 信息.班级 } else { "" }
  let rep_id = if 学号 != none { 学号 } else if "学号" in 信息 { 信息.学号 } else { "" }
  let rep_name = if 姓名 != none { 姓名 } else if "姓名" in 信息 { 信息.姓名 } else { "" }
  let rep_teacher = if 指导教师 != none { 指导教师 } else if "指导教师" in 信息 { 信息.指导教师 } else { "" }
  let rep_college = if "学院" in 信息 { 信息.学院 } else { "中南林业科技大学计算机与数学学院" }

  set page(
    paper: "a4",
    margin: (top: 2.8cm, bottom: 0.5cm, x: 2.4cm),
    fill: white,
  )
  正文样式(size: 封面字号)[#{
    // 封面保持紧凑段距，不受正文段距影响
    set par(spacing: 0.5em)
    v(3.59cm)

    align(center)[#text(size: 48pt)[#课程名称]]

    v(3.18cm)

    align(center)[#text(size: 48pt)[实验报告]]

    v(4.18cm)

    封面信息栏((
      专业: rep_major,
      班级: rep_class,
      学号: rep_id,
      姓名: rep_name,
      指导教师: rep_teacher,
    ))

    v(2.99cm)

    align(center)[#text(size: 12pt)[#(rep_college)监制]]
  }]
}

// ============================================================
//  正文登记表
// ============================================================
#let 登记表(
  实验名称: "",
  实验室: "",
  实验日期: "",
  年级: none,
  班号: none,
  组号: none,
  学号: none,
  专业: none,
  姓名: none,
  实验内容: [],
  实验环境: [],
  实验目的: [],
  源代码: [],
  实验结果分析及心得体会: [],
  心得体会: [],
  实验评分: "",
  教师签名: "",
  评定日期: "",
  信息: 学生信息,
) = {
  let rep_grade = if 年级 != none { 年级 } else if "年级" in 信息 { 信息.年级 } else { "" }
  let rep_class_num = if 班号 != none { 班号 } else if "班号" in 信息 { 信息.班号 } else { "" }
  let rep_group_num = if 组号 != none { 组号 } else if "组号" in 信息 { 信息.组号 } else { "" }
  let rep_id = if 学号 != none { 学号 } else if "学号" in 信息 { 信息.学号 } else { "" }
  let rep_major = if 专业 != none { 专业 } else if "专业" in 信息 { 信息.专业 } else { "" }
  let rep_name = if 姓名 != none { 姓名 } else if "姓名" in 信息 { 信息.姓名 } else { "" }
  let rep_lab = if 实验室 != none and 实验室 != "" { 实验室 } else if "实验室" in 信息 { 信息.实验室 } else { "" }
  let rep_feedback = if 实验结果分析及心得体会 != none and 实验结果分析及心得体会 != [] {
    实验结果分析及心得体会
  } else if 心得体会 != none and 心得体会 != [] {
    心得体会
  } else {
    []
  }

  报告登记表(
    (
      年级: rep_grade,
      班号: rep_class_num,
      组号: rep_group_num,
      学号: rep_id,
      专业: rep_major,
      实验日期: 实验日期,
      姓名: rep_name,
      实验名称: 实验名称,
      实验室: rep_lab,
    ),
    (
      实验内容: 实验内容,
      实验环境: 实验环境,
      实验目的: 实验目的,
      源代码: [#源代码块(源代码, lang: "c")],
      实验结果分析及心得体会: rep_feedback,
    ),
    (实验评分: 实验评分, 教师签名: 教师签名, 评定日期: 评定日期),
  )
}

// ============================================================
//  对外主函数
// ============================================================
#let 实验报告(
  实验名称: "",
  课程名称: "C 程序设计",
  实验室: "",
  实验日期: "",
  班级: none,
  姓名: none,
  学号: none,
  专业: none,
  指导教师: none,
  年级: none,
  班号: none,
  组号: none,
  // 结构化正文
  实验内容: [],
  实验环境: [],
  实验目的: [],
  源代码: [],
  实验结果分析及心得体会: [],
  心得体会: [],
  实验评分: "",
  教师签名: "",
  评定日期: "",
  显示封面: true,
  信息: 学生信息,
  // 兼容别名
  title: none,
  course: none,
  date: none,
  class: none,
  name: none,
  id: none,
  teacher: none,
  ..args,
) = {
  let body = if args.pos().len() > 0 { args.pos().at(0) } else { none }

  let report_title = if title != none { title } else { 实验名称 }
  let report_course = if course != none { course } else { 课程名称 }
  let report_date = if date != none { date } else { 实验日期 }
  let report_class = if class != none { class } else if 班级 != none { 班级 } else if "班级" in 信息 { 信息.班级 } else { "" }
  let report_name = if name != none { name } else if 姓名 != none { 姓名 } else if "姓名" in 信息 { 信息.姓名 } else { "" }
  let report_id = if id != none { id } else if 学号 != none { 学号 } else if "学号" in 信息 { 信息.学号 } else { "" }
  let report_teacher = if teacher != none { teacher } else if 指导教师 != none { 指导教师 } else if "指导教师" in 信息 { 信息.指导教师 } else { "" }
  let report_major = if 专业 != none { 专业 } else if "专业" in 信息 { 信息.专业 } else { "" }
  let report_lab = if 实验室 != "" { 实验室 } else if "实验室" in 信息 { 信息.实验室 } else { "" }

  if 显示封面 {
    封面(
      课程名称: report_course,
      信息: 信息,
      专业: report_major,
      班级: report_class,
      学号: report_id,
      姓名: report_name,
      指导教师: report_teacher,
    )
    pagebreak()
  }

  set page(
    paper: "a4",
    margin: (top: 2.54cm, bottom: 2.54cm, x: 3.17cm),
  )

  // 文字样式由 登记表 内部统一设置
  登记表(
    实验名称: report_title,
    实验室: report_lab,
    实验日期: report_date,
    年级: 年级,
    班号: 班号,
    组号: 组号,
    学号: report_id,
    专业: report_major,
    姓名: report_name,
    实验内容: 实验内容,
    实验环境: 实验环境,
    实验目的: 实验目的,
    源代码: 源代码,
    实验结果分析及心得体会: 实验结果分析及心得体会,
    心得体会: 心得体会,
    实验评分: 实验评分,
    教师签名: 教师签名,
    评定日期: 评定日期,
    信息: 信息,
  )

  if body != none and body != [] {
    body
  }
}

// 向下兼容别名
#let project = 实验报告
