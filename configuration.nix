# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <apple-silicon-support/apple-silicon-support>
      <home-manager/nixos>
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  #services.xserver = {
  #enable = true;
  #displayManager.gdm = {
  #  enable = true;
  #  wayland = true;
  #};
  #desktopManager.gnome.enable = true;
  #};


  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  environment.variables.EDITOR = "nvim";

  users.users.billy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; 

    packages = with pkgs; [
      tree
      wofi
      alacritty
      magic-wormhole
      gnupg
      brightnessctl
      ripgrep
      fd
      go
      gopls
      nixfmt

      cargo
      rustc
      rust-analyzer
      mold

      gopls
      gore
      gotests

      sbcl

      clang
      clang-tools
      glslang
      direnv
      cmake
      gnumake

      zig

      python3
      elixir
      elixir-ls

      protobuf
      inotify-tools
      mullvad
      mullvad-vpn
    ];

  };


  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  services.pcscd.enable = true;
  services.mullvad-vpn.enable = true;

  home-manager.users.billy = {
    programs.fish.enable = true;
    programs.alacritty.enable = true;

    programs.emacs = {
       enable = true;
       package = pkgs.emacs29-pgtk;
       #environment.systemPackages = with pkgs; [
       #   emacsPackages.vterm
       #   emacsPackages.adwaita-dark-theme 
       #];
    };

    programs.git = {
      enable = true;
      userName = "Billy Batista";
      userEmail = "bootlegbilly@protonmail.ch";

      extraConfig = {
        commit.gpgsign = true;
        user.signingkey = "2AEFC1D2E1754250547C98D55F69AE52CA83B3F6";
        push.autoSetupRemote = true;
        github.user = "billyb2";
      };
    };
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
          search = {
            force = true;
            default = "DuckDuckGo";
            order = [ "DuckDuckGo" "Google" ];

          };
        };
      };
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;

        ExtensionSettings = {
          "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
        };

        # Check about:config for options.
	Preferences = {
	  "extensions.pocket.enabled" = false;
	  "browser.startup.page" = 3;
	};

      };
    };

    programs.waybar = {
      enable = false;
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      systemd.enable = true;

      settings = {
        exec-once = "waybar";
        env = "XCURSOR_SIZE,24";

        input = {
          kb_layout = "us";
          follow_mouse = "1";
          touchpad.natural_scroll = "no";
          sensitivity = "0";
        };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, Q, exec, alacritty"
          "$mainMod, C, killactive,"
          "$mainMod, R, exec, wofi --show drun,run"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 0"
        ];
      };

    };

    home.stateVersion = "24.05";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code
      fira-code-symbols
    ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  hardware.asahi.withRust = true;
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.experimentalGPUInstallMode = "replace";

}
