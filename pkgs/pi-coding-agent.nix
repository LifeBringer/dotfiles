# pi.dev coding agent from upstream's prebuilt macOS release tarball, which
# the flake input `pi-bin` points at. The tarball is a self-contained tree:
# a Bun single-file executable plus the assets, themes, docs and native
# modules it looks up next to itself, so it is installed whole and `bin/pi`
# is a wrapper that execs the real binary in place.
{
  lib,
  stdenvNoCC,
  makeBinaryWrapper,
  ripgrep,
  fd,
  src,
}:
stdenvNoCC.mkDerivation {
  pname = "pi-coding-agent";
  version = (lib.importJSON "${src}/package.json").version;
  inherit src;

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true; # strip would cut the JS bundle out of the Bun executable

  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec $out/bin
    cp -R . $out/libexec/pi
    chmod 755 $out/libexec/pi/pi
    # Same environment nixpkgs gives its build: pi's tools shell out to rg
    # and fd, and the store copy can neither self-update nor phone home.
    makeWrapper $out/libexec/pi/pi $out/bin/pi \
      --prefix PATH : ${lib.makeBinPath [ ripgrep fd ]} \
      --set-default PI_SKIP_VERSION_CHECK 1 \
      --set-default PI_TELEMETRY 0
    runHook postInstall
  '';

  meta = {
    description = "Coding agent CLI with read, bash, edit, write tools and session management";
    homepage = "https://pi.dev/";
    changelog = "https://github.com/earendil-works/pi/releases";
    license = lib.licenses.mit;
    mainProgram = "pi";
    platforms = [ "aarch64-darwin" ];
  };
}
