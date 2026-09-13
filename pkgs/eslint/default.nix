{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "eslint";
  version = "10.9.0";

  src = fetchFromGitHub {
    owner = "eslint";
    repo = "eslint";
    tag = "v${version}";
    hash = "sha256-KmlBbcA+XyswWdgalBVkcoyPrv8/Qla0JkcT/RqaaR0=";
  };

  # NOTE: Generating lock-file
  # npm install --package-lock-only
  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-1UjRtZm8ykmxL24MVuELInnOwi+ma+MoZt2tQ7kPsY0=";
  npmInstallFlags = [ "--omit=dev" ];
  npmFlags = [ "--ignore-scripts" ];

  dontNpmBuild = true;
  dontNpmPrune = true;

  # Delete dangling symlinks
  preFixup = ''
    rm $out/lib/node_modules/eslint/node_modules/{eslint-config-eslint,@eslint/js}
  '';

  meta = {
    changelog = "https://github.com/eslint/eslint/blob/${src.rev}/CHANGELOG.md";
    description = "Find and fix problems in your JavaScript code";
    homepage = "https://eslint.org";
    license = lib.licenses.mit;
  };
}
