# ctf-shell (Nix flake)

A multi-profile Nix devShell repo for CTFs and penetration testing engagements. You opt into **only the tool categories you need** per session (e.g., `web` vs `pwn`), so you don't pull heavy tooling like Ghidra unless you want it.

This works on **macOS (darwin)** and **Linux**. The same shell names are used on both platforms; Nix automatically evaluates the correct host system (e.g., `aarch64-darwin`, `x86_64-linux`). Some toolsets (notably wireless/hardware and certain sniff/spoof tools) are **Linux-only** and are only included when you run the shell on Linux.

---

## What this repo provides

This repo exposes multiple `devShells` (profiles) via Nix flakes:

- `base` (default): light baseline tooling for general use
- `info`: recon / information gathering
- `web`: web application testing + vuln analysis
- `pwn`: exploitation + reversing tools (includes heavy RE tools like `ghidra`)
- `exploitation`: exploitation tooling (and RE helpers)
- `forensics`: forensics and file analysis tooling
- `passwords`: password cracking / wordlists
- `sniff`: sniffing/spoofing (portable core; Linux gets additional tools)
- `stress`: stress testing (Linux gets additional tooling)
- `reporting`: report generation (pandoc/latex)
- `access`: maintaining access / pivoting helpers (use responsibly)
- `wireless`: wireless tools (Linux-only additions)
- `webplus`: common combo for web CTFs (web + vuln + recon + sniff)
- `full`: everything (plus Linux-only extras where applicable)

Category composition is defined in:

- `pkgs/categories.nix` (cross-platform)
- `pkgs/linux.nix` (Linux-only extras)
- `pkgs/darwin.nix` (macOS-only extras, conservative)

---

## Prerequisites

### Install Nix

Install Nix using the official installer (multi-user recommended where supported). Ensure flakes are enabled (most modern Nix installs enable them; otherwise you may need to enable `nix-command` and `flakes`).

---

## Quick start

Clone the repo:

```bash
git clone https://github.com/<you>/ctf-shell.git
cd ctf-shell-shell
```

Enter the default (light) shell:

```
nix develop
```

Enter a specific category shell:

```
nix develop .#web
nix develop .#pwn
nix develop .#forensics
```

When the shell starts it creates these local directories if missing:

- `loot/` (captures/artifacts)
- `reports/` (writeups/output)
- `wordlists/`
- `tmp/`

---

## Common workflows

### Web CTF / web pentest

```
nix develop .#web
```

Includes typical web tooling (dir/content discovery, SQLi tooling, proxy tooling) plus vulnerability analysis tools.

### Pwn / binary exploitation / reversing

```
nix develop .#pwn
```

Includes debuggers, pwntools, ELF tooling, ROP helpers, and reversing tools.

This is the “heavier” shell because it includes tools like `ghidra`.

### Forensics

```
nix develop .#forensics
```

Firmware/file carving, filesystem forensics, metadata, and analysis utilities.

### Password cracking

```
nix develop .#passwords
```

Hashcat/john/hydra + wordlists.

### Sniffing/spoofing

```
nix develop .#sniff
```

Cross-platform includes `tcpdump`. Linux adds additional tooling (e.g., `wireshark-cli`, `ettercap`, `bettercap`).

### Wireless (Linux recommended)

```
nix develop .#wireless
```

On Linux, adds aircrack/hcxtools/etc.

On macOS, this shell will only include the cross-platform components (no Linux-only wireless stack).

### Everything

```
nix develop .#full
```

---

## Notes on platform differences

- **macOS**: many recon/web/reversing tasks work well, but hardware/wireless and some low-level networking tools are limited compared to Linux. For serious wireless work, use a Linux host (bare metal or VM) with a compatible adapter.
- **Linux**: gets additional packages for wireless, sniffing/spoofing, and stress testing via `pkgs/linux.nix`.

The repo is designed so Linux-only tools are guarded and won’t break evaluation on macOS.

---

## Updating tools

This repo tracks `nixos-unstable`. To update dependencies:

```
nix flake update
```

---

## Shell list

To list available shells:

```
nix flake show
```

You’ll see outputs like:

- `devShells.<system>.web`
- `devShells.<system>.pwn`
- etc.

---

## Safety / legality

Use these tools only:

- on systems you own, or
- where you have explicit written authorization to test.

This repo is a convenience layer for bringing a consistent toolchain to CTFs and authorized engagements.
