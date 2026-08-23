{
  config,
  pkgs,
  lib,
  ...
}: {
  # Imports {{{
  imports = [
    ./hardware-configuration.nix
    ./prometheus-metrics.nix
    ./web.nix
    # ./snix.nix                # TODO: needs snix package + cachix
  ];
  # }}}

  # Boot {{{
  boot = {
    kernel.sysctl."net.core.rmem_max" = lib.mkForce 4150000;
    kernel.sysctl."vm.swappiness" = 0;

    loader.systemd-boot = {
      enable = true;
      memtest86.enable = true;
    };

    loader.efi.canTouchEfiVariables = true;

    tmp = {
      useTmpfs = true;
      tmpfsSize = "40%";
    };

    # ZFS needs zfs package
    # initrd.kernelModules = [ "zfs" ];
    # initrd.supportedFilesystems = [ "zfs" ];
    # zfs.extraPools = [ "tank" ];
    extraModulePackages = [ ];
    extraModprobeConfig = ''
      options kvm-amd nested=1
      options kvm ignore_msrs=1
    '';
  };
  # }}}

  # Services {{{
  services = {
    grafana.enable = false;
    grafana.settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3050;
      };
      "auth.anonymous".enabled = true;
    };

    nix-serve = {
      enable = false;
      secretKeyFile = "/var/cache-priv-key.pem";
    };

    # zfs.trim.enable = true;  # needs zfs package

    earlyoom = {
      enable = true;
      freeMemThreshold = 2;
    };

    journald.settings = {
      maxRetentionSec = "3week";
      systemMaxUse = "200M";
      runtimeMaxUse = "100M";
    };

    ollama = {
      enable = true;
      package = pkgs.ollama;
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql;
    };

    hydra = {
      enable = false;
      port = 3100;
    };

    fstrim.enable = true;

    openssh = {
      enable = true;
      settings = {
        ports = [ 22 2222 3000 9100 ];
        extraConfig = ''
          StreamLocalBindUnlink yes
        '';
        passwordAuthentication = false;
        authorizedKeysFiles = ["/etc/ssh/extra_authorized_keys"];
      };
    };

    kubo = {
      enable = true;
      dataDir = "/tank/ipfs";
      autoMount = true;
    };

    # plex download URL returns 403 — version needs updating
    # plex = {
    #   enable = true;
    #   group = "users";
    #   openFirewall = true;
    # };

    # factorio - needs package and complex module
    # factorio.enable = true;

    transmission = {
      enable = false;  # miniupnpc API mismatch
      group = "users";
      package = pkgs.transmission;
      settings = {
        peerPort = 51413;
        rpcPort = 9091;
        rpcWhitelistEnabled = false;
        extraSettings = {
          download-dir = "/tank/torrents";
          incomplete-dir = "/tank/torrents/.incomplete";
          incomplete-dir-enabled = true;
          message-level = 1;
          peer-port-random-high = 65535;
          peer-port-random-low = 49152;
          peer-port-random-on-start = false;
          rpc-bind-address = "127.0.0.1";
          script-torrent-done-enabled = false;
          umask = 2;
          utp-enabled = true;
          watch-dir = "/var/lib/transmission/watchdir";
          watch-dir-enabled = false;
        };
      };
    };

    # xserver blocked: corepkgs xorg scope still missing xorg.xauth etc.
    # desktopManager.plasma6.enable = true;
    # xserver.enable = true;
    # xserver.displayManager.lightdm.enable = true;

    gnome.at-spi2-core.enable = true;
  };
  # }}}

  # NetworkManager for wireless (wlo2) {{{
  # networkmanager package evaluates to null — still being ported
  # networking.networkmanager = {
  #   enable = true;
  #   unmanaged = [ "enp67s0" "enp68s0" ];
  # };
  # }}}

  # Programs {{{
  programs = {
    mosh.enable = true;

    zsh = {
      enable = true;
      interactiveShellInit = ''
        source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
      '';
      promptInit = "";
    };

    fish.enable = true;
  };
  # }}}

  # Networking {{{
  networking = {
    useDHCP = false;
    interfaces = {
      enp67s0.useDHCP = true;
      enp68s0.useDHCP = true;
    };

    hostId = "b5b5bea7";
    firewall.allowedTCPPorts = [
      config.services.hydra.port
      config.services.grafana.settings.server.http_port
      80
      443
      9091
      9100
      5001
      2222
      34159
    ];
  };
  # }}}

  # Nix&Nixpkgs {{{
  nix = {
    nrBuildUsers = 450;

    settings = {
      allowed-uris = ["git+https://" "https://" "github.com:jonringer/"];
      auto-optimise-store = true;
      sandbox = true;
      cores = 32;
      max-jobs = 40;

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [
        "root"
        "@wheel"
        "jon"
        "nixpkgs-update"
        "tim"
        "jtojnar"
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "*-*-1,4,7,10,13,16,19,22,25,28,31 00:00:00";
    };

    nixPath = ["nixpkgs=/etc/nix/inputs/nixpkgs"];
  };

  nixpkgs = {
    config.allowUnfree = true;
  };
  # }}}

  # Environment {{{
  environment = {
    # etc."nix/inputs/nixpkgs".source = pkgs.path;  # pkgs.path not available

    systemPackages = with pkgs; [
      wget
      vim
      git
      htop
      lm_sensors
      tmux
    ];
  };
  # }}}

  # Users {{{
  users = {
    users = {
      jon = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "plex"
          "libvirtd"
          # "networkmanager"  # package still being ported
        ];
      };

      tim = {
        isNormalUser = true;
        extraGroups = ["libvirtd"];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIf7jDfqGKNZVwrJ3Yl+4aJe8sZpCmhlOB5PJC9L1Kto tim.deherrera@iohk.io"
        ];
      };

      bemeurer = {
        shell = "${pkgs.zsh}/bin/zsh";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFAvxz7tBCov9310ucqrVeAS0aSWCVh5sSsLjH/62lIldFPd7JVK5y+f5VETycoRy9aQSzzlb4wsXtCX0WMtRx8tWbeV4MVXHSDROQEI1QpWM5BPgrLdNB5zR+czjSb0It+3XrzzOiu1RaIY/48EEhxxshghLEVQqwHplObQI9yzdxfVPD9ZOqbxQRi6hYm9uEU3DcAONhLDAIlaDltmZVr7Vfg3P+eucO+QJ7/aLuochWLxLX/NjBsihYLrZIY+y1JAP2jm+dkGVTimozr/zwopO4y4+FlLK71ZbE1xlLX/UZHdfN00rmmZwzeTN+S7+H3cQSCQO6p6qmk9fT94sr9S7pKa8/fSr/1q7wbvKcoOW0hYal4XHnuON58+kA7thgZgFEji6o9KqWsss1wqx/XLYu2ThU6OpplPzhL+AwaH1uQpmoQ5ge29Emadv42R1jw0js2nljA4sJFybFmV0LJwORvqjaYuEj2peS40BT3eI+51plD85p//gmTeT3W7zqR8KB5bWK1xzWReSOI0Vg6PGiBPSA38dH5V7OZXDjZRnlE1WTD3E7MVKGhQDwQHoQdAvNSG7LyBfK7eprCTQAR/LkTaIQrCxLsIkzoSor5ZkG6P+QWN+HaN9YFJT6p7TtHbzZqpRkKAcVkNwXcGOyIw4ofybmUUEQ8O5Y8CC9Fw== cardno:000610250089"
        ];
      };

      boredom101 = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjeemhlJimE+5/THTqeKyXuW2+2iDSZDdG0P2gz0x8SqQGJ5VeOYcxbOBzDdjXxgkScSVuCKbwSitpMsgLLlYhm3CfSP8rN0lhxz0t7Q7H6OWHzll07qLVvlh4BbBOwod8+NKHcPe+4Paur754IOlwCOb4kDRaUXBmyl84lgTik5g7m7XI7JJIQbZovguBZIVMjMNAPOonqL86OEk3WiuGOKrGFstLjl9P6LuA01Mz2E446PiajEMhzS5xPxs2s5Z/lT0+gLDdISQN69PaXy0kSZkXpjzoUADfgz4aZ/MgYTn6qR4ntlVHKxUpo8EbuTleFwsjMRHRA8bmCFReX4MMcj8/b0Vlzu7f9k1wADJAAT9GW+EVz7xgC4k9mMr0eWoYLYs0txuHwnG9DbA487p5R+P9LfUrXIYdqnk4YzvjbFIBJQIi3SQFdGlY1Z1989sQBBuuRkomZmnvKk1JPnrNtYQaXN4BzfJGydzpW8wEH/lBvoFckUviBodzGlCWnHk= yisroel@DESKTOP-MKI0HG0"
        ];
      };

      tomberek = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDSF4CzkvONzaze5m0huhLmED9fxQTtuyv7rszWI0ju/+U4Gq4+Sd800vFrADfnbiLS4hgK4pDw5D8dXxi74mPeXXZV4oomafCnlvW7tL7RidEXvkP2sr1ObgkuQ9K67hSqKjT21mCWdEN6WGHh9EtK5r3nXIzUWhATqDz/Al7sveDZ/gdapo+f3xnmpOu1mq+y5iOcRV7b98z/VaiWAvuG83toIBsK4Su/GWWfMNied9R2K2Z10NM3ART0Sk+4yqH4usJOieTQsLAq8Ykb3PAYDMVx41yy9QNcFnCyX/HJHFO/Q98BLQ2zPxVbBMwp99NrKLqrwkrVtrWbAttanm9 cardno:000607658414"
        ];
      };

      bill = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG2lfvWM5a7Xy255kRZN1c2Z5QToUm8ecF+/lP7FpS0 bill@ewanick.com"
        ];
      };

      jtojnar = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEH4OFCc6a84dXHFHjNQ2HohLTFcYkxe+Lz/t3teWCrQ jtojnar@brian"
        ];
      };

      jurraca = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGmwV0S9JoNaO3mMpSrjkv2gD4Vd0hw2ljLKaRzMQpv jurraca@nix"
        ];
      };

      cleeyv = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO4p4CqilI3n1GOyGcDgUh1UpwxeHSTIiV4oeHYjF431 cleeyv"
        ];
      };

      tshaynik = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3wOOYiW+G1u5zHpvzq0N+nhj5l9o8lMht4kYias28n tshaynik"
        ];
      };

      artturin = {
        shell = "${pkgs.zsh}/bin/zsh";
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtXhvhk+LLfrO2K11ftf2qRaczYvEJLLr7tNsENuErQ ar-keyfor-rs"
        ];
      };

      happysalada = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyQSeQ0CV/qhZPre37+Nd0E9eW+soGs+up6a/bwggoP raphael@RAPHAELs-MacBook-Pro.local"
        ];
      };

      ysander = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6VLyCv4qmk2coyzhjm4qhd5LpsTmbNGh1HbJOWzYvj openpgp:0xF401BBD4"
        ];
      };

      synthetica = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFZaNsfqer68KD68f2udjv6BGg66aaIdTFMB50iaYK21 synthetica@AquaRing"
        ];
      };

      dermetfan = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBiYIJBUMPZqmFUcqaVp5h+6lsmvHIAZhCAjJ8a3El/2 dermetfan@laptop"
        ];
      };

      milahu = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBuzJ8xfKAkt6m0ByZK26LZQaQQGsaX68D5/9UeiVGb9 user@laptop1"
        ];
      };

      davhau = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDuhpzDHBPvn8nv8RH1MRomDOaXyP4GziQm7r3MZ1Syk"
        ];
      };

      janne = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM35Bq87SBWrEcoDqrZFOXyAmV/PJrSSu3hl3TdVvo4C janne"
        ];
      };

      sgo = {
        isNormalUser = true;
        shell = "${pkgs.fish}/bin/fish";
        openssh.authorizedKeys.keys = [
          "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIKDXQTWMtazTjVEnktJxpKPOmdGHZNHMqNNwnI+hjmY1AAAABHNzaDo= stig+yk-rk@stig.io"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMXypzDKusK4bz7FSJkwlMUkXSXywf/xXvQSM7s5eJsEu68hD9i1wN4dHspqyZlqqNvlvtbS/DvnEP6z55g7CHY= stig+nixbuild@stig.io"
        ];
      };

      glepage = {
        isNormalUser = true;
        shell = "${pkgs.fish}/bin/fish";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAQCM25FgJo9CvSn2tNzmpBvuaK7LruFitUog7+SSPAP"
        ];
      };

      fmzakari = {
        isNormalUser = true;
        shell = "${pkgs.fish}/bin/fish";
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDruWlzuyOXV0Ltjv0vVoCSkf4/ic4ET4of6NTqLWfvw/wpNFDr3SXRDAftOFcyoKp0ls0z6xy3CH99pUNmVnU19nwPdPfY93FJHaVDmS3VUzhco+e+bd1Azds5bltg06H+2vuHFcFMA28Y1o5h6ISlVY45bUzhKnW6+9whwECGBQo5KSvSW0D50eP557DD1KZlWUuJrcno65iQUz6dZ+R5cwfoTRhCvh4ltzJ6Fel6RuHPzG3u56lHM+upsF1REljHsNGI6XF3bcRuIoSssvaT0ZzVJQz/YnI1+wGZDNSKJI7WE+xmhfhcGLDzVaxNkLuJLMv/goTcDsDBb1BVw0YF YubiKey #8531869 PIV Slot 9a"
        ];
      };
    };
  };
  # }}}

  # Misc {{{
  system.stateVersion = "19.09";

  hardware.cpu.amd.updateMicrocode = true;
  # virtualisation.libvirtd.enable = true;  # libvirt package needs more deps
  time.timeZone = "America/Los_Angeles";

  # services.snix.enable = true;  # TODO: needs snix package + cachix

  # systemd.services overrides - not available in EkaOS service contract model
  # systemd.services.nix-daemon.serviceConfig.LimitNOFILE = lib.mkForce 1048576;
  # systemd.services.factorio.serviceConfig = { ... };

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "4096";
    }
  ];
  # }}}
}
# vim: fdm=marker
