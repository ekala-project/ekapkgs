{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dkms";
  version = "3.1.5";

  src = fetchFromGitHub {
    owner = "dell";
    repo = "dkms";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WTO8XUgn5MiOeH9GEpNrZMRowVgorJdbRGWcwWoZeZc=";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "SBIN=/bin"
    "LIBDIR=/lib/dkms"
    "KCONF=/etc/kernel"
    "MODDIR=/lib/modules"
    "KINSTALL=/lib/kernel/install.d"
    "SYSTEMD=/lib/systemd/system"
  ];

  # dkms doesn't need to be compiled, just installed
  dontBuild = true;

  # The Makefile tries to create /var/lib/dkms which fails in the sandbox
  preInstall = ''
    substituteInPlace Makefile \
      --replace-fail 'install -d -m 0755 $(DESTDIR)/var/lib/dkms' "" \
      --replace-fail '$(DESTDIR)/usr/share' '$(DESTDIR)/share'
  '';

  meta = {
    description = "Dynamic Kernel Module Support framework";
    homepage = "https://github.com/dell/dkms";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "dkms";
  };
})
