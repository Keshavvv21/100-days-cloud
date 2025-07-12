# File Descriptors & Redirects

This section provides an overview of **file descriptors** and **I/O redirection** in Unix-like operating systems, suitable for inclusion in a `readme.md` file.

## What Are File Descriptors?

- **File descriptors** are non-negative integers that uniquely identify open files or input/output resources for a running process.
- Common file descriptors:
  - **0**: Standard Input (stdin)
  - **1**: Standard Output (stdout)
  - **2**: Standard Error (stderr)
- Any file, socket, or device opened by a process is assigned a file descriptor.

## Standard File Descriptors Table

| Descriptor | Name           | Description                      |
|------------|----------------|----------------------------------|
| 0          | Standard Input | Input stream (keyboard by default) |
| 1          | Standard Output| Output stream (terminal by default) |
| 2          | Standard Error | Error output stream               |

## I/O Redirection

Redirection allows you to change the standard input/output/error streams for a command.

### Output Redirection

- **Overwrite file:**  
  `command > file.txt`  
  Redirects standard output to `file.txt`, overwriting its contents.

- **Append to file:**  
  `command >> file.txt`  
  Appends standard output to `file.txt`.

- **Redirect standard error:**  
  `command 2> error.log`  
  Redirects standard error to `error.log`.

- **Redirect both stdout and stderr:**  
  `command > all.log 2>&1`  
  Redirects both standard output and error to `all.log`.

### Input Redirection

- **Read from file:**  
  `command &2`  
  Sends "Hello" to standard error.

- **Combine outputs:**  
  `ls > out.txt 2>&1`  
  Both normal output and errors go to `out.txt`.

- **Suppress output:**  
  `command > /dev/null 2>&1`  
  Discards all output and errors.

## Summary Table: Common Redirection Operators

| Operator    | Description                                 |
|-------------|---------------------------------------------|
| `>`         | Redirect stdout (overwrite)                 |
| `>>`        | Redirect stdout (append)                    |
| ``        | Redirect stderr                             |
| `2>&1`      | Merge stderr into stdout                    |
| `&>`        | Redirect both stdout and stderr (bash only) |

## Further Reading

- Unix man pages: `man bash`, `man sh`
- Online tutorials on shell scripting and redirection

This section covers the essentials of file descriptors and redirection, providing a practical reference for shell scripting and command-line usage.
