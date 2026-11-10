# leenaai: the work Mac that runs headless and is reached over Tailscale
# SSH. The headless module's options are listed in
# github:kunchenguid/headless, modules/darwin/headless.nix.
{ user, ... }:

{
  headless = {
    inherit user;
    # Keys sshd accepts besides ~/.ssh/authorized_keys (which the JumpCloud
    # agent manages). Tailscale SSH does not read these.
    sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILv6pZyI3KYoTY4VZzJNdTRZYnkon7Nr55Uu00tid6of"
    ];
    # The organization that manages this Mac keeps FileVault on, and
    # automatic sign-in cannot get past FileVault's unlock screen.
    autoLogin = false;
    # Tailscale already runs from boot as the Homebrew formula's root daemon
    # (configuration.nix). A second daemon from this module would fight it.
    tailscale.enable = false;
  };

  # Installed on this Mac only. Listing it keeps the Homebrew cleanup ("zap"
  # in configuration.nix) from removing it and its containers.
  homebrew.casks = [ "orbstack" ];
}
