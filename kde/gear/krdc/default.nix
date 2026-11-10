{
  mkKdeDerivation,
  pkg-config,
  shared-mime-info,
  qtwayland,
  libssh,
  libvncserver,
  freerdp,
  fuse,
}:
mkKdeDerivation {
  pname = "krdc";

  extraNativeBuildInputs = [
    pkg-config
    shared-mime-info
  ];

  extraBuildInputs = [
    qtwayland
    libssh
    libvncserver
    freerdp
    fuse
  ];

  meta.mainProgram = "krdc";
}
