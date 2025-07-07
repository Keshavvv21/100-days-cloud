# Understand iptables and Firewalls

## Introduction

iptables is a user-space utility program that allows a system administrator to configure the IP packet filter rules of the Linux kernel firewall.

## Basics of iptables

- iptables works by defining rules in tables.
- Each table contains chains.
- Chains contain rules that match packets.

## Common Tables

1. filter – default table for filtering packets
2. nat – used for network address translation
3. mangle – used for specialized packet alteration

## Chains

- INPUT: packets destined for the local system
- OUTPUT: packets originating from the local system
- FORWARD: packets being routed through the system

## Example Rule

```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

This rule allows incoming SSH connections.

## Conclusion

Understanding iptables is crucial for managing Linux firewalls effectively.
