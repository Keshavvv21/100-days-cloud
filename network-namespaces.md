# Network Namespaces Basics

## Overview

**Network namespaces** are a powerful feature of the Linux kernel that allow you to create multiple, isolated network stacks on a single system. Each network namespace has its own interfaces, routing tables, firewall rules, and more, enabling secure and flexible network isolation for containers, applications, or testing environments.

---

## Key Concepts

- **Namespace:** An isolated copy of the network stack.
- **veth Pair:** Virtual Ethernet devices that connect namespaces, acting like a virtual cable.
- **Bridge:** A virtual switch to connect multiple namespaces or veth pairs.
- **Loopback Interface:** Each namespace has its own `lo` interface.
- **Routing Table:** Each namespace maintains its own routing rules and tables.

---

## Why Use Network Namespaces?

- **Isolation:** Separate network resources and traffic for different processes or containers.
- **Security:** Restrict network visibility and access between applications.
- **Testing:** Simulate complex network topologies on a single host.
- **Flexibility:** Run multiple applications with overlapping IP addresses or ports.

---

## Basic Commands

### Create a New Network Namespace

```
ip netns add mynamespace
```

### List Network Namespaces

```
ip netns list
```

### Run a Command in a Namespace

```
ip netns exec mynamespace bash
```

### Create a veth Pair

```
ip link add veth1 type veth peer name veth2
```

### Move veth to a Namespace

```
ip link set veth2 netns mynamespace
```

---

## Example: Isolating a Network

1. **Create a namespace:**
   ```
   ip netns add ns1
   ```
2. **Create a veth pair:**
   ```
   ip link add veth-ns1 type veth peer name veth-host
   ```
3. **Assign one end to the namespace:**
   ```
   ip link set veth-ns1 netns ns1
   ```
4. **Set up interfaces:**
   ```
   ip netns exec ns1 ip addr add 10.0.0.1/24 dev veth-ns1
   ip addr add 10.0.0.2/24 dev veth-host
   ```
5. **Bring up interfaces:**
   ```
   ip netns exec ns1 ip link set veth-ns1 up
   ip link set veth-host up
   ip netns exec ns1 ip link set lo up
   ```

---

## Use Cases

- **Containers (Docker, Kubernetes):** Each container gets its own network namespace.
- **Network Simulation:** Test firewalls, routing, and network software.
- **Security Sandboxing:** Restrict network access for sensitive applications.

---

## References

- [Linux Network Namespaces Documentation](https://man7.org/linux/man-pages/man7/network_namespaces.7.html)
- [ip-netns(8) Manual Page](https://man7.org/linux/man-pages/man8/ip-netns.8.html)
- [Linux Containers: Network Namespace Basics](https://wiki.archlinux.org/title/Linux_network_namespace)

---
