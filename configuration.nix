{
  inputs,
  pkgs,
  self,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

#  boot.loader.grub = {
#    enable = true;
#    device = "/dev/sda"; # or "nodev" for EFI only
#  };
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "nixos-rohr";
    networkmanager.enable = true;
  };

  time.timeZone = "America/Toronto";

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    libinput.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  environment = {
    variables = {
      DEVENV_NAME = "(System)";
    };
    sessionVariables = {
      GDK_BACKEND = "wayland";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
      FUCKYOU = "rohr";
    };

    shellAliases = {
      c = "clear";
      rebuild = "nixos-rebuild switch --use-remote-sudo --flake ~/.config/flake";
    };


    systemPackages = with pkgs; [
      wget
      zathura
      git
      kitty
      firefox
      pavucontrol
      htop
      jq
      feh
      julia
      neovim

      # Sway essentials
      grim
      slurp
      wl-clipboard
      mako
      swayfx
      waybar

      (inputs.atomic-vim.systemLib."${system}".mkAtomic (self + "/atomic.nix"))
    ];
  };

  users.users.rohr = {
    isNormalUser = true;
    description = "No Rest Till Free Fall";
    extraGroups = [ "wheel" "video" "audio" "dialout" ];
    shell = pkgs.zsh;
    home = "/home/rohr";
    packages = with pkgs; [
      tree
      starship
      # Add nvf manually if desired
    ];
  };

  programs = {
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };


    zsh = {
      enable = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  # Only needed if you want flakes for user-level dev
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "24.11"; # Did you read the comment?
}
