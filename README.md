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

## 文件说明

最高层文件: CPU.v

RegistFile.v: 32个通用寄存器

inst_mem_data: 指令存储内容

data_mem_data: 数据存储内容

Inst_Mem.v: 指令存储器

Data_Mem.v: 数据存储器

PC.v: program counter 程序计数器

IF-ID.v: instructions fetch - instruction decode IF-ID流水寄存器

ID.v: 指令译码

ID-EX.v: instruction decode - excution ID-EX流水寄存器

ALU.v: 算术逻辑单元

EX-MEM.v: excution - memory EX-MEM流水寄存器

MEM.v: 访存单元

MEM-WB: memory - write back MEM-WB流水寄存器

test_banch文件: test_banch.v

## 日程计划

+ Load-Store指令
+ 数据转发旁路机制
+ 分支跳转指令
+ Tomasulo指令调度

