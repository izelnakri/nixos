{ config, pkgs, lib, ... }:

let
  user = "izelnakri";
  password = "coolie";
  SSID = "UC_wifi_2D";
  SSIDpassword = "L0v31sth3k3y-2D";
  interface = "wlan0";
  hostname = "nixos-pi-1";
in {
  imports = [
    ./nixos-hardware/raspberry-pi/4
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4"; # Change to BTRFS
      options = [ "noatime" ];
    };
  };

  hardware = {
    enableRedistributableFirmware = true;
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    raspberry-pi."4".fkms-3d.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
    pulseaudio.enable = true;
  };

  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };

  sound.enable = true;

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    neovim
    git
    alacritty
    tmux
    zsh
    deno
    nodejs_20
    elixir_1_15
    ruby
    rustup
    ripgrep
    fzf
    lf
    kubectl
    pass
    fx
    iotop
    jq
    docker
    lsof
    nmap
    htop
    mdbook
    sc-im
    sqlite
    syncthing
    slides
    tcpdump
    gnutar
    wget
    which
    whois
  ];

  services.openssh.enable = true;

  system.stateVersion = "23.11";
}
