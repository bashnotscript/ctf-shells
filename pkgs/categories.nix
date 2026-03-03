{ pkgs, lib }:

with pkgs; rec {
  # Minimal baseline that should work on both macOS and Linux
  base = [
    bashInteractive
    zsh
    tmux
    git
    openssh
  ];

  utils = [
    curl wget
    jq yq-go
    ripgrep fd fzf
    coreutils gnused gawk gnumake
    file
    unzip p7zip
    socat
    netcat
  ];

  # Languages / runtimes frequently used in CTFs
  langs = [
    python3
    python3Packages.pip
    ruby
    go
    nodejs
  ];

  # Information Gathering
  infoGathering = [
    nmap
    dnsutils
    whois
    whatweb
    httpie
  ];

  # Web Applications
  webApps = [
    ffuf
    gobuster
    feroxbuster
    dirb
    nikto
    sqlmap
    mitmproxy
  ];

  # Vulnerability Analysis
  vulnAnalysis = [
    nuclei
    testssl
    openssl
  ];

  # Exploitation (pwn-ish tooling, kept reasonable)
  exploitation = [
    gcc
    binutils
    gdb
    lldb
    python3Packages.pwntools
    checksec
    ropper
    patchelf
    elfutils
    nasm
  ];

  # Reversing / RE (heavier tools live here so web shells don’t pull them)
  reversing = [
    radare2
    ghidra
  ];

  # Forensics
  forensics = [
    binwalk
    foremost
    sleuthkit
    exiftool
    strings
    sqlite
  ];

  # Passwords
  passwords = [
    hashcat
    john
    thc-hydra
    crunch
    seclists
  ];

  # Reporting
  reporting = [
    pandoc
    texliveSmall
  ];

  # Sniffing & Spoofing (portable subset)
  sniffSpoof = [
    tcpdump
  ];

  # Stress Testing (portable/light)
  stressTesting = [
    siege
  ];

  # Maintaining Access / pivoting (use responsibly)
  maintainingAccess = [
    chisel
    proxychains
  ];
}
