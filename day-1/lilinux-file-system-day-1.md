# Linux File System & Permissions: Quick Reference

## What is the Linux File System?

The Linux file system is a hierarchical structure that organizes all files and directories starting from the root directory `/`. Key directories include `/bin` (essential commands), `/home` (user data), `/etc` (system configs), `/boot` (boot files), and `/dev` (device files). Everything, including devices and partitions, is part of this unified directory tree, following the Filesystem Hierarchy Standard (FHS)[5][4][6].

**Learn More:**
- [Linux Foundation: The Linux Filesystem Explained](https://www.linuxfoundation.org/blog/blog/classic-sysadmin-the-linux-filesystem-explained)[1]
- [LinuxForDevices: Understanding the Linux File System](https://www.linuxfordevices.com/tutorials/linux-file-system)[5]
- [DEV Community: Simple Guide for Beginners](https://dev.to/davidmm1707/the-linux-file-system-a-simple-guide-for-beginners-3jao)[4]
- [YouTube: Linux File System in 4 Minutes](https://www.youtube.com/watch?v=995-SYn6960)[2]
- [YouTube: Linux File System Explained in Detail](https://www.youtube.com/watch?v=WbEHpl_W4pI)[7]

## Essential Commands

### Navigation

- `pwd` — Print current directory
- `ls` — List directory contents  
  - `ls -l` (long format with permissions)  
  - `ls -a` (show hidden files)
- `cd <directory>` — Change directory  
  - `cd ..` (up one level)  
  - `cd ~` (home directory)
- `tree` — Show directory structure (if installed)

### File and Directory Management

- `mkdir <directory>` — Create a new directory
- `mkdir -p path/to/directory` — Create nested directories
- `rmdir <directory>` — Remove empty directory
- `rm <file>` — Remove file
- `rm -r <directory>` — Remove directory and contents
- `cp <source> <destination>` — Copy files/directories
- `mv <source> <destination>` — Move or rename files/directories

### Viewing and Editing Files

- `cat <file>` — Show file contents
- `head <file>` — First 10 lines of file
- `tail <file>` — Last 10 lines of file

### File Permission Commands

- `ls -l` — List files with permissions
- `chmod <permissions> <file>` — Change file/directory permissions
- `chown <owner>:<group> <file>` — Change file/directory owner and group

## Courses & Tutorials

- [Linux Foundation: Free Intro to Linux Course](https://www.linuxfoundation.org/learn/intro-to-linux/)
- [UChicago CS: Linux Filesystem Tutorial](https://uchicago-cs.github.io/student-resource-guide/tutorials/linux-filesystem.html)[3]
- [YouTube: Linux File System in 4 Minutes](https://www.youtube.com/watch?v=995-SYn6960)[2]
- [YouTube: Linux File System Explained in Detail](https://www.youtube.com/watch?v=WbEHpl_W4pI)[7]
