# acpx, a headless CLI client for the Agent Client Protocol. Not in nixpkgs.
# It launches most ACP adapters through `npm exec`/`npx`, so the wrapper puts
# node on its PATH.
#
# Built from the tarball upstream publishes to npm, which ships the compiled
# dist/. A build from the git tag needs the whole pnpm toolchain, and pnpm
# fetches every platform's TypeScript 7 and bundler binaries for it while
# silently dropping any optional download that stalls, so that dependency
# hash never reproduced. npm tarballs carry no lockfile, so package-lock.json
# beside this file pins the runtime dependencies. To bump: change version and
# hash, then regenerate the lockfile from the new package.json with
# devDependencies and scripts removed (`npm install --package-lock-only`).
{
  lib,
  buildNpmPackage,
  fetchurl,
  jq,
  nodejs,
}:
buildNpmPackage (finalAttrs: {
  pname = "acpx";
  version = "0.19.4";

  src = fetchurl {
    url = "https://registry.npmjs.org/acpx/-/acpx-${finalAttrs.version}.tgz";
    hash = "sha512-fN1c3Ype4LrwZoeJwcZEnyO+1ArThgymwswmJyd52dHKaz+3hjkR6lYdlyBPOZYIIcCVARezcfvkFUNxsylSBA==";
  };

  # The published manifest still lists the build toolchain and the
  # prepack/prepare scripts that run it. dist/ is already compiled. jq is
  # referenced by path because the npm-deps fetcher runs this hook too.
  postPatch = ''
    ${lib.getExe jq} 'del(.devDependencies, .scripts)' package.json > package.json.tmp
    mv package.json.tmp package.json
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-RM2hOU4j3X/SLffPl6ZJBYd8IeZwpOxNVHB+vArHFfo=";

  dontNpmBuild = true;

  makeWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [ nodejs ])
  ];

  meta = {
    description = "Headless CLI client for the Agent Client Protocol";
    homepage = "https://github.com/openclaw/acpx";
    changelog = "https://github.com/openclaw/acpx/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "acpx";
  };
})
