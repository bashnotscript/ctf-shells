{ pkgs, lib }:

with pkgs; rec {
  sniffSpoof = [
    # tcpdump already in common; keep this file conservative
  ];

  hardware = [
    # Most hardware tooling is better in a Linux VM; leave empty for macOS by default
  ];
}
