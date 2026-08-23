{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  version = "5.1.1";
  pname = "buku";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "buku";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-7dxe1GUdBDP/mNfYKkJzKNTgzXLfVQxp4REEkFIh4Bs=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  propagatedBuildInputs = with python3Packages; [
    cryptography
    beautifulsoup4
    certifi
    urllib3
    html5lib
  ];

  doCheck = false;

  postInstall = ''
    make install PREFIX=$out

    mkdir -p $out/share/zsh/site-functions $out/share/bash-completion/completions $out/share/fish/vendor_completions.d
    cp auto-completion/zsh/* $out/share/zsh/site-functions
    cp auto-completion/bash/* $out/share/bash-completion/completions
    cp auto-completion/fish/* $out/share/fish/vendor_completions.d

    rm -f $out/bin/bukuserver
  '';

  meta = {
    description = "Private cmdline bookmark manager";
    mainProgram = "buku";
    homepage = "https://github.com/jarun/Buku";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
