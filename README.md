# 操作系统 - Xv6 Copy-on-Write Fork

Score 121 /150

为了xv6能正常在qemu中运行，需要将 /xv6-labs/ModifyGIT 文件夹的文件名改为 .git

ps:我如果不把 .git 文件夹改名的话无法正常上传文件 


## 目录

- [环境配置](#环境配置)
- [实验准备](#实验准备)
- [实验任务](#实验任务)
- [提交要求](#提交要求)

---

## 环境配置

### Debian 或 Ubuntu

安装所需的工具链：

```bash
sudo apt-get install git build-essential gdb-multiarch qemu-system-misc gcc-riscv64-linux-gnu binutils-riscv64-linux-gnu
```

### 验证安装

验证 QEMU 安装：

```bash
qemu-system-riscv64 --version
# 应该显示：QEMU emulator version 5.1.0 或更高版本
```

验证 RISC-V 编译器（至少应有以下之一）：

```bash
riscv64-linux-gnu-gcc --version
# 或
riscv64-unknown-elf-gcc --version
# 或
riscv64-unknown-linux-gnu-gcc --version
```

---

## 实验准备

### 1. 获取 xv6 源代码

```bash
git clone https://gitee.com/yanjun-wen/xv6-labs.git
cd xv6-labs
```

### 2. 切换到 COW 分支

```bash
git fetch
git checkout cow
make clean
```

### 3. 启动 xv6

构建并运行 xv6：

```bash
make qemu
```

如果成功，您应该看到类似以下的输出：

```
xv6 kernel is booting

hart 2 starting
hart 1 starting
init: starting sh
$
```

在 xv6 shell 中，您可以：

- 输入 `ls` 查看文件列表
- 按 `Ctrl-p` 查看进程信息（xv6 没有 `ps` 命令）
- 按 `Ctrl-a x` 退出 QEMU

---

## 实验任务

### 任务 1：实现 Copy-on-Write Fork（必须完成，难度：困难）

#### 问题描述

传统的 `fork()` 系统调用会将父进程的所有用户空间内存复制到子进程。如果父进程很大，复制会很耗时。更糟糕的是，这个工作经常是浪费的：`fork()` 之后通常会调用 `exec()`，这会丢弃复制的内存，通常大部分都没有使用过。

#### 解决方案

实现 Copy-on-Write (COW) fork，延迟分配和复制物理内存页，直到真正需要时才进行复制。

COW fork 的工作方式：
1. 只为子进程创建页表，其 PTE 指向父进程的物理页
2. 将父子进程中所有用户内存的 PTE 标记为只读
3. 当任一进程尝试写入 COW 页时，CPU 会触发页错误
4. 内核页错误处理程序检测到这种情况，为出错进程分配新的物理页，复制原始页，并更新 PTE 指向新页且标记为可写
5. 页错误处理返回后，用户进程就可以写入其页面副本了

#### 实现步骤

1. **修改 `uvmcopy()`**
   - 将父进程的物理页映射到子进程，而不是分配新页
   - 清除父子进程中有 `PTE_W` 标记的 PTE 中的 `PTE_W` 位

2. **修改 `usertrap()` 以识别页错误**
   - 当发生写页错误且该 COW 页原本是可写的时：
     - 使用 `kalloc()` 分配新页
     - 将旧页复制到新页
     - 在 PTE 中安装新页，并设置 `PTE_W` 标记
   - 原本只读的页（如代码段）应保持只读并在父子进程间共享；尝试写入这些页的进程应被杀死

3. **确保物理页的正确释放**
   - 为每个物理页维护一个"引用计数"，记录有多少用户页表引用该页
   - `kalloc()` 分配时设置引用计数为 1
   - fork 导致子进程共享页时，增加引用计数
   - 任何进程从页表中删除页时，减少引用计数
   - `kfree()` 只在引用计数为 0 时才将页放回空闲列表

4. **修改 `copyout()`**
   - 当遇到 COW 页时，使用与页错误相同的处理方案

#### 测试

使用提供的测试程序验证实现：

```bash
# 在 xv6 shell 中运行
$ cowtest
```

成功时应看到：
```
simple: ok
simple: ok
three: zombie!
ok
three: zombie!
ok
three: zombie!
ok
file: ok
ALL COW TESTS PASSED
```

```bash
$ usertests -q
...
ALL TESTS PASSED
```

#### 实现提示

- 可以使用 RISC-V PTE 中的 RSW（保留供软件使用）位来标记 COW 映射
- `usertests -q` 会测试 `cowtest` 没有覆盖的场景，请确保两个测试都通过
- 页面表标志的有用宏和定义在 `kernel/riscv.h` 末尾
- 如果发生 COW 页错误且没有空闲内存，进程应被杀死

---

### 任务 2：实现 `cowstats` 系统调用（必须完成，难度：简单）

#### 函数原型

```c
int cowstats(void);  // 计算当前所有进程因COW而节省的字节数
```

#### 实现要求

实现一个系统调用 `cowstats`，计算当前所有进程因 Copy-on-Write 机制而节省的内存字节数。

#### 计算方式

根据物理页的引用计数计算节省的内存。例如，如果一个物理页被引用了两次，COW 机制节省了 1 个 `PGSIZE` 的内存。您需要计算 COW 节省的总内存空间（以字节为单位）。

#### 测试

使用提供的测试程序：

```bash
# 在 xv6 shell 中运行
$ cowstats_test
```

成功时应看到：
```
simple: ok
simple: ok
three: ok
three: ok
three: ok
file: ok
ALL COW TESTS PASSED
```

#### 实现提示

- 参考 Lab 2: Syscall 来回顾如何添加系统调用
- 基于物理页的引用计数计算节省的内存

---

## 提交要求

### 1. 记录时间

创建一个新文件 `time.txt`，在其中放入一个整数，表示您在实验中花费的小时数：

```bash
git add time.txt
git commit -m "Add time spent"
```

### 2. 回答问题（如果有）

如果实验有问题，将答案写在 `answers-*.txt` 文件中：

```bash
git add answers-*.txt
git commit -m "Add answers"
```

### 3. 提交代码

提交所有修改的源代码：

```bash
git add <修改的文件>
git commit -m "Implement COW fork and cowstats system call"
```

### 4. 生成提交包

在提交前，请确保：

- 运行 `make grade` 确保所有测试通过
- 提交所有修改的源代码（使用 `git add` 和 `git commit`）

然后生成提交包：

```bash
make zipball
```

这会生成 `lab.zip` 文件。如果 `make zipball` 显示未提交的更改或未跟踪的文件：

```
 M hello.c
?? bar.c
?? foo.pyc
Untracked files will not be handed in.  Continue? [y/N]
```

请检查这些行，确保所有需要的文件都被跟踪（没有以 `??` 开头的行）。可以使用 `git add {filename}` 来跟踪新创建的文件。

最后，将 `lab.zip` 上传到相应的 eduCoder 作业平台。

### 注意事项

- **重要**：运行 `make grade` 确保代码通过所有测试
- **重要**：在运行 `make zipball` 之前，先提交所有修改的源代码
- 使用 `git diff` 查看自上次提交以来的更改
- 使用 `git diff origin/cow` 查看相对于初始 `cow` 分支代码的更改

---

## Git 使用说明

实验使用 Git 版本控制系统来跟踪代码更改。一些有用的命令：

- 查看更改：`git diff`
- 查看相对于初始代码的更改：`git diff origin/cow`
- 暂存文件：`git add <file>`
- 提交更改：`git commit -m "commit message"`
- 查看提交历史：`git log`

Git 允许您跟踪对代码所做的更改。例如，如果完成了一个练习并想保存进度，可以运行：

```bash
git commit -am 'my solution for COW fork exercise'
```

---

## 故障排除

### QEMU 无法启动

- 检查 QEMU 是否正确安装：`qemu-system-riscv64 --version`
- 检查编译是否成功：`make clean && make`

### 编译错误

- 确保已安装所有必需的工具链
- 检查 RISC-V 编译器是否在 PATH 中：`which riscv64-linux-gnu-gcc` 或 `which riscv64-unknown-elf-gcc`

### 测试失败

- 仔细检查实现逻辑，特别是引用计数的管理
- 确保处理了所有边界情况（内存不足、只读页等）
- 使用 GDB 进行调试：`make qemu-gdb`，然后在另一个终端运行 `riscv64-linux-gnu-gdb` 或 `gdb-multiarch`

---

祝实验顺利！

