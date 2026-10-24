# Meta Muse Code's installer writes a self-updating launcher and binary beside
# each other. Keep that runtime under XDG_DATA_HOME so it can update outside
# the immutable Nix store, while exposing `muse` through the Nix profile.
{
  lib,
  writeShellApplication,
  bash,
  coreutils,
  curl,
}:
writeShellApplication {
  name = "muse";
  runtimeInputs = [ bash coreutils curl ];

  text = ''
    data_home="''${XDG_DATA_HOME:-$HOME/.local/share}"
    install_dir="$data_home/muse"
    launcher="$install_dir/muse"

    if [[ ! -x "$launcher" ]]; then
      export MUSE_INSTALL_DIR="$install_dir"
      export MUSE_NO_MODIFY_PATH=1
      export PATH="$install_dir:$PATH"

      curl \
        --fail \
        --silent \
        --show-error \
        --location \
        --max-redirs 3 \
        --proto '=https' \
        --proto-redir '=https' \
        --tlsv1.2 \
        https://dev.meta.ai/install.sh \
        | bash
    fi

    exec "$launcher" "$@"
  '';

  meta = {
    description = "Bootstrap wrapper for Meta Muse Code's self-updating CLI";
    homepage = "https://dev.meta.ai/";
    license = lib.licenses.unfree;
    mainProgram = "muse";
    platforms = lib.platforms.darwin;
  };
}
