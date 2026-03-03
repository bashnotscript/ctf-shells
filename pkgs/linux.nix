{ pkgs, lib }:

with pkgs; rec {
  # Sniffing & spoofing: Linux gets the real extras
  sniffSpoof = [
    wireshark-cli
    ettercap
    bettercap
    # arpspoof is often in dsniff
    dsniff
  ];

  # Wireless
  wireless = [
    aircrack-ng
    wifite2
    hcxdumptool
    hcxtools
    reaverwps
    bully
  ];

  # Hardware (Linux is generally the place to do this)
  hardware = [
    usbutils
    pciutils
  ];

  # Stress testing extras
  stressTesting = [
    masscan
  ];

  # Access/pivoting extras (often Linux-centric)
  accessExtras = [
    iproute2
  ];
}
