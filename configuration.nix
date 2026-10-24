{ user, pkgs, nixpkgs-unstable, pi-bin, ... }:

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

  # Packages that go stale too fast for the release branch, or that nixpkgs
  # does not have.
  nixpkgs.overlays = [
    (final: prev: {
      # yt-dlp breaks whenever a site changes how it serves video, and fixes
      # ship roughly weekly.
      yt-dlp = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.yt-dlp;
      # cloudflared ships monthly against an edge that keeps changing, and the
      # release branch stays on the version it branched with.
      cloudflared = nixpkgs-unstable.legacyPackages.${prev.stdenv.hostPlatform.system}.cloudflared;
      # pi: even nixpkgs-unstable trails the newest release and its model
      # catalog, so it is built from upstream's release tarball (flake input).
      pi-coding-agent = final.callPackage ./pkgs/pi-coding-agent.nix { src = pi-bin; };
      # Not in nixpkgs at all.
      acpx = final.callPackage ./pkgs/acpx/package.nix { };
      backpass = final.callPackage ./pkgs/backpass.nix { };
      # Meta ships Muse through a bootstrap installer that writes its runtime
      # outside the Nix store.
      muse = final.callPackage ./pkgs/muse.nix { };
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
    # Third-party taps. nix-darwin trusts each fully-qualified formula below,
    # so the taps themselves stay untrusted.
    taps = [
      # Automic Vault Isotopes: builds of CLIs that keep their credentials in
      # Automic Vault custody.
      "automic-vault/isotopes"
      "anomalyco/tap"  # OpenCode
    ];
    brews = [
      "gh"
      # Only a launcher. After installing or upgrading it, run
      # `av harden wrangler` to install the signed runtime in /opt/av/wrangler.
      "automic-vault/isotopes/wrangler-isotope"
      # OpenCode v2 ships several releases a week and nixpkgs trails it, so
      # take upstream's own tap. `opencode upgrade` updates it through brew.
      "anomalyco/tap/opencode-v2"
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
