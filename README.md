# riscv_soc_proj
本项目来源于github网站上liangkangnan的tinyriscv工程，主要是想利用此RISC-V核进行SOC芯片设计，学习如何在RISC-V上挂接一些外设或者IP核.   
代码来源链接: https://github.com/liangkangnan/tinyriscv.   

# RISC-V处理器
本项目实现的是一个单核32位的小型RISC-V处理器核(tinyriscv)，采用verilog语言编写。设计目标是对标ARM Cortex-M3系列处理器。tinyriscv有以下特点：

1. 支持RV32IM指令集，通过RISC-V指令兼容性测试；
3. 采用三级流水线，即取指，译码，执行；
4. 可以运行C语言程序；
5. 支持JTAG，可以通过openocd读写内存(在线更新程序)；
6. 支持中断；
6. 支持总线；
7. 支持FreeRTOS；
8. 支持通过串口更新程序；
9. 容易移植到任何FPGA平台(如果资源足够的话)；

项目中的各目录说明：

**rtl**：该目录包含tinyriscv的所有verilog源码；

**sim**：该目录包含仿真批处理bat文件和脚本；

**tests**：该目录包含测试程序源码，其中example目录为C语言程序例程源码，isa目录为RV32指令测试源码；

**tools**：该目录包含编译汇编和C语言程序所需GNU工具链和将二进制文件转成仿真所需的mem格式文件的工具BinToMem，还有通过串口下载程序的脚本。BinToMem\_CLI.exe需要在cmd窗口下执行，BinToMem\_GUI.exe提供图形界面，双击即可运行；

**pic**：存放图片；

**tb**：该目录包含仿真的testbench文件；

**fpga**：存放FPGA相关文件，比如约束文件；

tinyriscv的整体框架如下：

![tinyriscv整体框架](./pic/arch.jpg)

tinyriscv目前外挂了6个外设，每个外设的空间大小为256MB，地址空间分配如下图所示：

<img src="./pic/addr_alloc.jpg" alt="地址空间分配" style="zoom:70%;" />