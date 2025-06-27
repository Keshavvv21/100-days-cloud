# Shell Scripting: Hello World + Variables

This guide will help you write your first shell script in Bash, print "Hello World", and introduce variables.

## What is a Shell Script?

A shell script is a text file containing a series of commands for the shell to execute. It automates repetitive tasks and can include logic, variables, and more[5][2].

## 1. Writing Your First "Hello World" Script

**Step 1: Create the Script File**

Open your terminal and create a new file:

```bash
touch hello.sh
```

**Step 2: Add the Shebang and Print Statement**

Edit `hello.sh` in your favorite text editor and add:

```bash
#!/bin/bash
# This is a comment
echo "Hello, World!"
```
- `#!/bin/bash` tells the system to use the Bash shell to interpret the script[2][5].
- `echo "Hello, World!"` prints the message to your terminal[1][2][3].

**Step 3: Make the Script Executable**

```bash
chmod +x hello.sh
```

**Step 4: Run the Script**

```bash
./hello.sh
```

**Output:**
```
Hello, World!
```

## 2. Using Variables in Shell Scripts

Variables let you store and reuse values in your scripts.

**Example Script Using Variables:**

```bash
#!/bin/bash
greeting="Hello"
target="World"
echo "$greeting, $target!"
```
- `greeting` and `target` are variables.
- `$greeting` and `$target` retrieve their values[5].

**How to Run:**
1. Save the script (e.g., `hello_vars.sh`).
2. Make it executable:  
   ```bash
   chmod +x hello_vars.sh
   ```
3. Run:  
   ```bash
   ./hello_vars.sh
   ```
**Output:**
```
Hello, World!
```

## 3. Passing Arguments to Scripts

You can pass values to your script as arguments:

**Script Example:**
```bash
#!/bin/bash
echo "$1 $2"
```
Run with:
```bash
./hello_args.sh Hello World
```
**Output:**
```
Hello World
```
- `$1` and `$2` refer to the first and second arguments[4].

## References & Further Reading

- [Shell Scripting Tutorial: First Script](https://www.shellscript.sh/first.html)[1]
- [LabEx: Hello World Bash](https://labex.io/tutorials/linux-hello-world-bash-153893)[2]
- [Log2Base2: Print Hello World](https://www.log2base2.com/shell-script-examples/basic/print-hello-world-shell-script.html)[4]
- [LambdaTest: Beginner's Guide to Unix Shell Scripting](https://www.lambdatest.com/blog/unix-shell-scripting/)[5]

Shell scripting is a powerful way to automate tasks. Start with these basics and explore more features as you grow!

[1] https://www.shellscript.sh/first.html
[2] https://labex.io/tutorials/linux-hello-world-bash-153893
[3] https://www.macs.hw.ac.uk/~hwloidl/Courses/LinuxIntro/x864.html
[4] https://www.log2base2.com/shell-script-examples/basic/print-hello-world-shell-script.html
[5] https://www.lambdatest.com/blog/unix-shell-scripting/
[6] https://labex.io/tutorials/linux-hello-bash-388809
