

# Common Bash Commands Practice

Welcome! This repository is designed to help you learn and practice the most common Bash commands. Whether you’re new to the terminal or want to sharpen your command-line skills, these exercises and examples will help you build a strong Bash foundation.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
- [Essential Bash Commands](#essential-bash-commands)
- [Practical Example](#practical-example)
- [Practice Exercises](#practice-exercises)
- [Additional Resources](#additional-resources)

## Overview

Bash is a powerful command-line shell used in Linux and macOS systems. Mastering Bash commands allows you to efficiently navigate directories, manage files, and automate tasks. This guide covers essential commands and provides hands-on exercises to accelerate your learning.

## Getting Started

1. **Open your terminal.**
2. **Clone this repository (optional):**
   ```bash
   git clone https://github.com/yourusername/bash-commands-practice.git
   cd bash-commands-practice
   ```
3. **Follow the exercises below.**

## Essential Bash Commands

| Command   | Description                       | Example Usage                |
|-----------|-----------------------------------|------------------------------|
| `ls`      | List directory contents           | `ls -a`                      |
| `cd`      | Change directory                  | `cd ~`                       |
| `pwd`     | Print working directory           | `pwd`                        |
| `echo`    | Display text/variables            | `echo $HOME`                 |
| `mkdir`   | Create directories                | `mkdir project_files`        |
| `touch`   | Create or update files            | `touch script.sh`            |
| `cat`     | Show file content                 | `cat notes.txt`              |
| `cp`      | Copy files or directories         | `cp file.txt backup/`        |
| `mv`      | Move or rename files/directories  | `mv old.txt new.txt`         |
| `rm`      | Remove files or directories       | `rm file.txt`                |
| `history` | Show command history              | `history`                    |
| `grep`    | Search text in files              | `grep "pattern" file.txt`    |

## Practical Example

Try this sequence to create a directory, add a file, and verify its contents:

```bash
mkdir practice_dir
cd practice_dir
touch example.txt
echo "Hello World" > example.txt
cat example.txt
ls -l
```

## Practice Exercises

- **Navigation Challenge**
  - Use `cd` and `ls` to locate a hidden file named `.solution` in a directory tree.
  - Reveal it with `ls -a`.

- **Script Execution**
  - Create a script (`touch hello.sh`) with:
    ```bash
    #!/bin/bash
    echo "Practice makes perfect!"
    ```
  - Run it with `source hello.sh`.

- **File Operations**
  - Copy a file to a new directory with `cp`.
  - Rename it using `mv`.
  - Delete a backup with `rm`.

- **Variable Practice**
  - Assign text to a variable: `msg="Bash Mastery"`
  - Print it with `echo $msg`
  - Concatenate strings: `echo "${msg} achieved!"`

## Additional Resources

- [Bash Cheat Sheet (GitHub)](https://github.com/RehanSaeed/Bash-Cheat-Sheet/blob/main/README.md)
- [Hostinger Bash Scripting Challenges](https://www.hostinger.com/tutorials/bash-script-examples)
- [LinuxCommand.org](http://linuxcommand.org/lc3_learning_the_shell.php)

