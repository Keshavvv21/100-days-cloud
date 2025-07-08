# System Usage Monitoring Tools

This guide provides an overview of essential Linux system monitoring tools—**top**, **ps**, and **vmstat**—that help you observe and analyze system performance and resource usage.

## Table of Contents

- [top](#top)
- [ps](#ps)
- [vmstat](#vmstat)
- [Comparison Table](#comparison-table)
- [Summary](#summary)

## top

**top** is an interactive, real-time system monitoring tool that displays a dynamic view of running processes and resource usage.

**Key Features:**
- Live updating of process list and system resource usage.
- Displays CPU, memory, and swap usage.
- Allows sorting and filtering of processes.
- Interactive commands for managing processes (e.g., killing, renicing).

**Basic Usage:**
```bash
top
```

**Common Options:**
- `-u `: Show only processes for a specific user.
- `-p `: Monitor specific process IDs.
- `-n `: Number of iterations before exiting.

## ps

**ps** (process status) provides a snapshot of current processes. Unlike `top`, it is non-interactive and shows process information at the moment the command is run.

**Key Features:**
- Flexible output formatting.
- Can display all processes or filter by user, group, etc.
- Useful for scripting and automation.

**Basic Usage:**
```bash
ps aux
```

**Common Options:**
- `a`: Show processes for all users.
- `u`: Display user/owner column.
- `x`: Show processes not attached to a terminal.
- `-ef`: Full-format listing (System V style).

## vmstat

**vmstat** (virtual memory statistics) reports information about processes, memory, paging, block IO, traps, and CPU activity.

**Key Features:**
- Summarizes overall system resource usage.
- Useful for diagnosing memory and performance issues.
- Can display output at regular intervals.

**Basic Usage:**
```bash
vmstat 1
```

**Common Options:**
- ``: Update interval in seconds (e.g., `vmstat 5`).
- ``: Number of updates before exiting (e.g., `vmstat 1 5`).

## Comparison Table

| Tool   | Type         | Real-Time | Interactive | Key Focus             | Typical Use Case                      |
|--------|--------------|-----------|-------------|-----------------------|---------------------------------------|
| top    | Process      | Yes       | Yes         | CPU/memory/processes  | Live monitoring and management        |
| ps     | Process      | No        | No          | Process snapshot      | Scripting, process listing            |
| vmstat | System-wide  | Yes       | No          | Memory/CPU/IO stats   | Performance analysis, bottleneck hunt |

## Summary

- **top**: Ideal for real-time, interactive system monitoring.
- **ps**: Best for capturing process snapshots and scripting.
- **vmstat**: Focused on overall system performance and memory statistics.

These tools are foundational for system administrators and developers to monitor and troubleshoot Linux systems efficiently.
