#import "../lib/java-report.typ": 实验报告

#实验报告(
  实验名称: "实验一：面向对象程序设计与简单图形界面",
  实验日期: "2026 年 10 月 08 日",

  实验目的: [
    1. 掌握 Java 语言面向对象的核心特性（封装、继承与多态）及接口设计；
    2. 理解并掌握 Java 图形用户界面组件（Swing / AWT）的布局管理与事件监听机制；
    3. 熟练运用 Java 集合框架（List、Map）管理内存业务数据，培养工程规范与调试能力。
  ],

  实验要求: [
    1. *类设计*：设计学生信息实体类 `Student`，属性私有化并提供 getter/setter 及合规校验；
    2. *界面布局*：构建包含表单输入区、操作按钮组及结果展示表格的主窗口；
    3. *事件处理*：为“添加”、“查询”、“清除”等按钮注册监听器，处理用户交互异常并弹窗提示；
    4. *代码规范*：类名、方法名遵循驼峰命名法，关键逻辑添加完整注释。
  ],

  实验内容: [
    本次实验主要编写 `Student` 实体类及管理主窗口 `StudentManagerFrame`。核心代码如下所示：

    ```java
    package com.csuft.cs.lab;

    import java.io.Serializable;

    /**
     * 学生实体类，封装学生基础属性
     */
    public class Student implements Serializable {
        private String id;       // 学号
        private String name;     // 姓名
        private String major;    // 专业
        private double score;    // 综合成绩

        public Student(String id, String name, String major, double score) {
            this.id = id;
            this.name = name;
            this.major = major;
            this.score = score;
        }

        public String getId() { return id; }
        public String getName() { return name; }
        public String getMajor() { return major; }
        public double getScore() { return score; }

        @Override
        public String toString() {
            return String.format("[%s] %s - %s (%.1f分)", id, name, major, score);
        }
    }
    ```

    界面控制器中通过集合存储实体对象，并在点击按钮时触发动态更新与表格重绘。
  ],

  实验结果: [
    系统运行后，各测试用例输入验证情况如下表所示：

    #figure(
      table(
        columns: (1fr, 2fr, 2fr, 1.5fr),
        align: center + horizon,
        [测试编号], [输入学号与姓名], [测试场景], [预期与实际结果],
        [TC-01], [2026001 / 张三], [正常添加合规学生记录], [成功插入列表并清空表单],
        [TC-02], [留空 / 李四], [学号非空校验拦截], [弹出提示并终止添加],
        [TC-03], [2026001 / 重复项], [学号重复性校验], [正确捕获异常并阻止录入],
      ),
      caption: [学生信息管理系统核心测试用例及执行结果],
    )

    经过上述多组边界条件测试，各模块功能均达到设计预期，界面响应及时，未发生未捕获异常。
  ],

  实验练习: [
    *练习 1：如何利用泛型和 Comparator 接口对学生按综合成绩降序排列？*

    *解答*：在管理类中可通过 `Collections.sort(studentList, (s1, s2) -> Double.compare(s2.getScore(), s1.getScore()))` 传入 Lambda 表达式实现自定义降序排序，或者让实体类实现 `Comparable<Student>` 接口并重写 `compareTo` 方法。

    *练习 2：在关闭窗口时如何防止未保存数据丢失？*

    *解答*：通过为 `JFrame` 注册 `WindowListener`，在 `windowClosing(WindowEvent e)` 回调中弹出确认对话框（`JOptionPane.showConfirmDialog`），经用户确认后再执行持久化与程序退出。
  ],

  实验总结: [
    *1. 遇到的主要问题与解决途径*：
    初始阶段在主线程中执行耗时初始化导致界面短暂卡顿，通过查阅 Java 文档改用 `SwingUtilities.invokeLater()` 调度事件分发线程（EDT）后成功解决。

    *2. 创新与体会*：
    实现了基于表格模型的动态无刷新更新，并在表单校验环节引入了轻量级正则表达式检查，提升了系统的健壮性。

    *3. 改进设想*：
    后续可将内存集合进一步对接本地 SQLite 数据库或 JSON 文件持久化，支持更大规模数据的分页浏览。
  ],
)
