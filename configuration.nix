# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
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
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";
  nixpkgs.config.allowUnfree = true;

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
    extraGroups = [ "wheel" "docker" ];

    packages = with pkgs; [
      tree
      wofi
      alacritty
      gnupg
      brightnessctl
      ripgrep
      fd
      go
      gopls
      nixfmt

      rustup
      mold

      gopls
      gore
      gotests

      sbcl

      clang
      clang-tools
      libtool
      cmake
      gnumake

      glslang

      texlive.combined.scheme-full

      direnv

      zig
      python3

      curl
      dbus
      openssl_3
      glib
      gtk3
      libsoup
      webkitgtk
      librsvg

      nodejs

      elixir
      erlang
      elixir-ls

      ruby
      rubyfmt
      rubyPackages.solargraph

      typescript
      nodePackages.typescript-language-server

      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk

      protobuf
      sqlite

      rofi-screenshot
      grim

      qemu

      pkg-config

      webkitgtk
      gtk3
      cairo
      gdk-pixbuf
      glib
      dbus
      openssl_3
      librsvg

      inotify-tools
      mullvad-vpn
      hyprshade
      ffcast
      slop
      xclip
      okular
      wl-clipboard
      nwg-panel
      blueberry
      tailscale
      htop
      dust
      file
      b3sum
      signal-desktop
      element-desktop
      prismlauncher
      qbittorrent
    ];

  };

  virtualisation.docker.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.pcscd.enable = true;
  services.mullvad-vpn.enable = true;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pipewire.wireplumber.configPackages = [
    (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua"
      "	bluez_monitor.properties = {\n		[\"bluez5.enable-sbc-xq\"] = true,\n		[\"bluez5.enable-msbc\"] = true,\n		[\"bluez5.enable-hw-volume\"] = true,\n		[\"bluez5.headset-roles\"] = \"[ hsp_hs hsp_ag hfp_hf hfp_ag ]\"\n	}\n")
  ];
  services.blueman.enable = true;
  services.tailscale.enable = true;
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "suspend";
  };

  home-manager.users.billy = {
    programs.fish = {
      enable = true;
      shellInit = ''
                direnv hook fish | source
                fish_add_path $HOME/.fly/bin/
        	fish_add_path ~/.config/doom/bin/
        	fish_add_path ~/.mix/escripts/
      '';
    };
    programs.alacritty.enable = true;
    programs.neovim.enable = true;
    programs.obs-studio.enable = true;

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
          "*".installation_mode =
            "blocked"; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url =
              "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
          };
          # Bitwarden:
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url =
              "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
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

    xdg.portal = {
      enable = true;
      config.common.default = [ "hyprland" ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      systemd.enable = true;

      settings = {
        exec-once = "nwg-panel";
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

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 0"
        ];
      };

    };

    home.file = {
      # I like my blue light filter
      "/home/billy/.config/hypr/shaders/blue-light-filter.glsl" = {
        text = ''
          // from https://github.com/hyprwm/Hyprland/issues/1140#issuecomment-1335128437

          precision highp float;
          varying vec2 v_texcoord;
          uniform sampler2D tex;

          const float temperature = 2600.0;
          const float temperatureStrength = 1.0;

          #define WithQuickAndDirtyLuminancePreservation
          const float LuminancePreservationFactor = 1.0;

          // function from https://www.shadertoy.com/view/4sc3D7
          // valid from 1000 to 40000 K (and additionally 0 for pure full white)
          vec3 colorTemperatureToRGB(const in float temperature) {
              // values from: http://blenderartists.org/forum/showthread.php?270332-OSL-Goodness&p=2268693&viewfull=1#post2268693
              mat3 m = (temperature <= 6500.0) ? mat3(vec3(0.0, -2902.1955373783176, -8257.7997278925690),
                                                      vec3(0.0, 1669.5803561666639, 2575.2827530017594),
                                                      vec3(1.0, 1.3302673723350029, 1.8993753891711275))
                                               : mat3(vec3(1745.0425298314172, 1216.6168361476490, -8257.7997278925690),
                                                      vec3(-2666.3474220535695, -2173.1012343082230, 2575.2827530017594),
                                                      vec3(0.55995389139931482, 0.70381203140554553, 1.8993753891711275));
              return mix(clamp(vec3(m[0] / (vec3(clamp(temperature, 1000.0, 40000.0)) + m[1]) + m[2]), vec3(0.0), vec3(1.0)),
                         vec3(1.0), smoothstep(1000.0, 0.0, temperature));
          }

          void main() {
              vec4 pixColor = texture2D(tex, v_texcoord);

              // RGB
              vec3 color = vec3(pixColor[0], pixColor[1], pixColor[2]);

          #ifdef WithQuickAndDirtyLuminancePreservation
              color *= mix(1.0, dot(color, vec3(0.2126, 0.7152, 0.0722)) / max(dot(color, vec3(0.2126, 0.7152, 0.0722)), 1e-5),
                           LuminancePreservationFactor);
          #endif

              color = mix(color, color * colorTemperatureToRGB(temperature), temperatureStrength);

              vec4 outCol = vec4(color, pixColor[3]);

              gl_FragColor = outCol;
          }
          	'';
        executable = false;

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
  environment.systemPackages = with pkgs; [ wget ];

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
  networking.firewall.enable = false;

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

  hardware.asahi.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.keyboard.zsa.enable = true;

  hardware.asahi.withRust = true;
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.experimentalGPUInstallMode = "replace";

}

