{
  description = "dotfiles";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Only for the handful of packages that go stale too fast on a release
    # branch. See the overlay in configuration.nix.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Not packaged in nixpkgs; upstream ships its own flake.
    treehouse.url = "github:kunchenguid/treehouse";
    treehouse.inputs.nixpkgs.follows = "nixpkgs";

    # pi releases about weekly and nixpkgs lags by weeks, so take upstream's
    # prebuilt macOS binary straight from the newest GitHub release. rebuild.sh
    # re-locks this input every run, so a rebuild always installs the current
    # release; between runs the lock pins the tarball hash.
    pi-bin.url = "https://github.com/earendil-works/pi/releases/latest/download/pi-darwin-arm64.tar.gz";
    pi-bin.flake = false;

    # The headless layer (key-only SSH, never sleep, ...) for the Mac that
    # runs unattended; only the leenaai configuration imports it. Its NixOS
    # inputs are never evaluated here, so they follow nixpkgs to keep the
    # lock to one nixpkgs.
    headless.url = "github:kunchenguid/headless";
    headless.inputs.nixpkgs.follows = "nixpkgs";
    headless.inputs.nix-darwin.follows = "nix-darwin";
    headless.inputs.nixpkgs-nixos.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs, nixpkgs-unstable, treehouse, pi-bin, headless }:
    let
      # The macOS user to configure, taken from whoever runs the rebuild.
      # darwin-rebuild runs under sudo, where USER is root, so prefer
      # SUDO_USER. Reading the environment needs --impure (rebuild.sh passes
      # it); a pure evaluation falls back to "rona".
      sudoUser = builtins.getEnv "SUDO_USER";
      envUser = builtins.getEnv "USER";
      user =
        if sudoUser != "" then sudoUser
        else if envUser != "" && envUser != "root" then envUser
        else "rona";

      mkDarwin = extraModules: nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user nixpkgs-unstable pi-bin; };
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = { inherit user treehouse; };
            home-manager.users.${user} = import ./home.nix;
          }
        ] ++ extraModules;
      };
    in
    {
      darwinConfigurations."archlinux" = mkDarwin [ ];
      # The same setup, run headless. rebuild.sh picks it on that Mac.
      darwinConfigurations."leenaai" = mkDarwin [
        headless.darwinModules.headless
        ./hosts/leenaai.nix
      ];
    };
}
