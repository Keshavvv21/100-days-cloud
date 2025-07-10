# Linux Process Signals

This repository contains notes, examples, and explanations on **Linux Process Signals** — a crucial part of process management in Unix-like operating systems.

## 📘 Overview

Signals are software interrupts sent to a process to notify it of various events like termination, pause, or user-defined actions. They are used for inter-process communication (IPC) and system-level process control.

---

## 🔥 Common Signals

| Signal | Name        | Description                        | Command to Send |
|--------|-------------|------------------------------------|-----------------|
| 1      | `SIGHUP`    | Hangup detected on controlling terminal | `kill -1 PID`  |
| 2      | `SIGINT`    | Interrupt from keyboard (Ctrl+C)   | `kill -2 PID`  |
| 9      | `SIGKILL`   | Kill signal (cannot be caught)     | `kill -9 PID`  |
| 15     | `SIGTERM`   | Termination signal (graceful)      | `kill -15 PID` |
| 18     | `SIGCONT`   | Continue if stopped                | `kill -18 PID` |
| 19     | `SIGSTOP`   | Stop process (cannot be ignored)   | `kill -19 PID` |

Use `kill -l` to see all available signals.

---

## 📂 Examples

### Sending a Signal

```bash
kill -SIGTERM 1234  # sends SIGTERM to process with PID 1234
