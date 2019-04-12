# MIPS32 CPU design and test

Microprocessor without interlocked pipelined stages

I need a Verilog HDL fomatter QAQ

## VScode Extension

VScode Extension: [Verilog HDL support](https://github.com/mshr-h/vscode-verilog-hdl-support)

Verilog HDL support配置说明：

+ 下载[ctags](http://bleyer.org/icarus/)，并添加至env


+ 两种lint配置
  + xvlog
    1. 添加Vivado的linter即xvlog.exe到env
        + "...\Xilinx\Vivado\2018.3\bin\unwrapped\win64.o"
        + "...\Xilinx\Vivado\2018.3\bin"
    2. 设置"verilog.linting.linter": "xvlog"
  + iverilog
    1. 下载[iverilog](http://iverilog.icarus.com/)并添加至env
    2. 设置"verilog.linting.linter": "iverilog"

##  日程计划

+ Load-Store指令
+ 数据转发旁路机制
+ 分支跳转指令
+ Tomasulo指令调度

