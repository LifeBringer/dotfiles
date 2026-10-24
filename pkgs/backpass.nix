# backpass proposes AGENTS.md / CLAUDE.md edits from past agent sessions.
# Not in nixpkgs. It is plain JavaScript with no runtime dependencies, so
# the source tree is installed as is. Every model call goes through acpx,
# which the wrapper puts on its PATH.
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  acpx,
  makeBinaryWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "backpass";
  version = "0.1.32";

  src = fetchFromGitHub {
    owner = "kunchenguid";
    repo = "backpass";
    tag = "backpass-v${finalAttrs.version}";
    hash = "sha256-TtSMt1hWR0Z7Lz0gyoYn2JPDbBNEzlHlRurp6HTtI4g=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/backpass $out/bin
    cp -R bin src templates package.json $out/lib/backpass/
    makeWrapper ${lib.getExe nodejs} $out/bin/backpass \
      --add-flags $out/lib/backpass/bin/backpass.js \
      --suffix PATH : ${lib.makeBinPath [ acpx ]}
    runHook postInstall
  '';

  meta = {
    description = "Evidence-backed AGENTS.md / CLAUDE.md edits from past agent sessions";
    homepage = "https://github.com/kunchenguid/backpass";
    changelog = "https://github.com/kunchenguid/backpass/blob/backpass-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "backpass";
  };
})
