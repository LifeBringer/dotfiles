{ user, pkgs, nixpkgs-unstable, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  # Install fonts through macOS so CoreText applications such as Ghostty can
  # discover them. Home Manager's fontconfig path is sufficient for WezTerm,
  # but it is not visible to Ghostty's native font backend.
  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  # yt-dlp breaks whenever a site changes how it serves video, and fixes ship
  # roughly weekly, so the release branch is always too far behind to be useful.
  nixpkgs.overlays = [
    (final: prev: {
      yt-dlp = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.yt-dlp;
    })
  ];

  security.sudo.extraConfig = ''
    Defaults secure_path="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
  '';

  system.primaryUser = "rona";
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      AppleShowAllExtensions = true;
    };
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    brews = [
      "gh"
      "herdr"
      "pandoc"
      "tectonic"
      "poppler"
      "mermaid-cli"
      "ffmpeg"
      "uv"
    ];
    casks = [
      "wezterm"
      "ghostty"
      "claude-code@latest"
      "opensuperwhisper"
      "basictex"
      "typora"
      "uvtools"
      "libreoffice"
    ];
  };
}
