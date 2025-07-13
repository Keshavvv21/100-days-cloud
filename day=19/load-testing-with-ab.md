# README: Load Testing with ab and wrk

This README provides instructions and context for using **Apache Benchmark (ab)** and **wrk** to perform load testing on your web server. These tools help you measure server performance, simulate concurrent users, and identify bottlenecks.

## Table of Contents

- [Purpose](#purpose)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
  - [Using ab](#using-ab)
  - [Using wrk](#using-wrk)
- [Example Output](#example-output)
- [Tips](#tips)
- [Summary Table](#summary-table)
- [References](#references)

## Purpose

**ab** and **wrk** are command-line tools for **load testing** web servers. Including them in your workflow allows you to:

- **Measure server performance:** Determine how many requests per second your server can handle.
- **Simulate concurrent users:** Test server behavior under multiple simultaneous connections.
- **Identify bottlenecks:** Analyze metrics like latency, throughput, and error rates.

### Why Use These Tools?

- **Quick Start for Developers:** Ready-to-use commands for testing server performance.
- **Performance Baseline:** Standardize benchmarking for your application.
- **Documentation Best Practice:** Demonstrates consideration for scalability and reliability.

### Example Use Cases

- **Before deployment:** Ensure the server can handle expected traffic.
- **After code changes:** Compare performance metrics across versions.
- **During optimization:** Test the impact of configuration or code changes.

## Prerequisites

- A running web server (e.g., `http://localhost:8080`)
- Either **ab** or **wrk** installed on your system

## Installation

### Apache Benchmark (ab)

- **Ubuntu/Debian:**
  ```bash
  sudo apt-get install apache2-utils
  ```
- **macOS (Homebrew):**
  ```bash
  brew install httpd
  ```

### wrk

- **Ubuntu/Debian:**
  ```bash
  sudo apt-get install wrk
  ```
- **macOS:**
  ```bash
  brew install wrk
  ```

## Usage

### Using ab

**Basic Command:**
```bash
ab -n 1000 -c 50 http://localhost:8080/
```
- `-n 1000`: Total number of requests to perform
- `-c 50`: Number of concurrent requests
- `http://localhost:8080/`: URL to test

### Using wrk

**Basic Command:**
```bash
wrk -t4 -c100 -d30s http://localhost:8080/
```
- `-t4`: Number of threads
- `-c100`: Number of open connections
- `-d30s`: Duration of test (30 seconds)
- `http://localhost:8080/`: URL to test

## Example Output

### ab
```
Concurrency Level:      50
Time taken for tests:   2.345 seconds
Complete requests:      1000
Failed requests:        0
Requests per second:    426.61 [#/sec] (mean)
Time per request:       117.25 [ms] (mean)
```

### wrk
```
Running 30s test @ http://localhost:8080/
  4 threads and 100 connections
  Requests/sec:  5000.12
  Transfer/sec:    1.20MB
```

## Tips

- Replace the example URL with your server address.
- Start with lower concurrency and increase gradually to avoid overwhelming the server.
- Review metrics like requests per second, latency, and failed requests to assess performance.

## Summary Table

| Tool | Purpose                                      | Example Usage                                   |
|------|----------------------------------------------|-------------------------------------------------|
| ab   | Simple HTTP load testing, basic metrics      | `ab -n 1000 -c 50 http://localhost:8080/`       |
| wrk  | Advanced load testing, multi-threaded, scripting | `wrk -t4 -c100 -d30s http://localhost:8080/` |

## References

- Official ab documentation
- Official wrk repository

: https://httpd.apache.org/docs/2.4/programs/ab.html
: https://github.com/wg/wrk
