{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  libdaemon,
  dbus,
  expat,
  gettext,
  glib,
  autoreconfHook,
  libevent,
}:

stdenv.mkDerivation rec {
  pname = "avahi";
  version = "0.8";

  src = fetchurl {
    url = "https://github.com/lathiat/avahi/releases/download/v${version}/avahi-${version}.tar.gz";
    sha256 = "1npdixwxxn3s9q1f365x9n9rc5xgfz39hxf23faqvlrklgbhj0q6";
  };

  outputs = [
    "out"
    "dev"
    "man"
  ];

  patches = [
    (fetchpatch {
      name = "CVE-2021-3502.patch";
      url = "https://github.com/lathiat/avahi/commit/9d31939e55280a733d930b15ac9e4dda4497680c.patch";
      sha256 = "sha256-BXWmrLWUvDxKPoIPRFBpMS3T4gijRw0J+rndp6iDybU=";
    })
    (fetchpatch {
      name = "CVE-2021-3468.patch";
      url = "https://github.com/lathiat/avahi/commit/447affe29991ee99c6b9732fc5f2c1048a611d3b.patch";
      sha256 = "sha256-qWaCU1ZkCg2PmijNto7t8E3pYRN/36/9FrG8okd6Gu8=";
    })
    (fetchpatch {
      name = "CVE-2023-1981.patch";
      url = "https://github.com/lathiat/avahi/commit/a2696da2f2c50ac43b6c4903f72290d5c3fa9f6f.patch";
      sha256 = "sha256-BEYFGCnQngp+OpiKIY/oaKygX7isAnxJpUPCUvg+efc=";
    })
    (fetchpatch {
      name = "CVE-2023-38470.patch";
      url = "https://github.com/lathiat/avahi/commit/94cb6489114636940ac683515417990b55b5d66c.patch";
      sha256 = "sha256-Fanh9bvz+uknr5pAmltqijuUAZIG39JR2Lyq5zGKJ58=";
    })
    (fetchpatch {
      name = "bail-out-unless-escaped-labels-fit.patch";
      url = "https://github.com/avahi/avahi/commit/20dec84b2480821704258bc908e7b2bd2e883b24.patch";
      sha256 = "sha256-p/dOuQ/GInIcUwuFhQR3mGc5YBL5J8ho+1gvzcqEN0c=";
    })
    (fetchpatch {
      name = "CVE-2023-38473.patch";
      url = "https://github.com/lathiat/avahi/commit/b448c9f771bada14ae8de175695a9729f8646797.patch";
      sha256 = "sha256-/ZVhsBkf70vjDWWG5KXxvGXIpLOZUXdRkn3413iSlnI=";
    })
    (fetchpatch {
      name = "CVE-2023-38472.patch";
      url = "https://github.com/lathiat/avahi/commit/b024ae5749f4aeba03478e6391687c3c9c8dee40.patch";
      sha256 = "sha256-FjR8fmhevgdxR9JQ5iBLFXK0ILp2OZQ8Oo9IKjefCqk=";
    })
    (fetchpatch {
      name = "CVE-2023-38471.patch";
      url = "https://github.com/lathiat/avahi/commit/894f085f402e023a98cbb6f5a3d117bd88d93b09.patch";
      sha256 = "sha256-4dG+5ZHDa+A4/CszYS8uXWlpmA89m7/jhbZ7rheMs7U=";
    })
    (fetchpatch {
      name = "CVE-2023-38471-2.patch";
      url = "https://github.com/avahi/avahi/commit/b675f70739f404342f7f78635d6e2dcd85a13460.patch";
      sha256 = "sha256-uDtMPWuz1lsu7n0Co/Gpyh369miQ6GWGyC0UPQB/yI8=";
    })
    (fetchpatch {
      name = "CVE-2023-38469.patch";
      url = "https://github.com/avahi/avahi/commit/61b9874ff91dd20a12483db07df29fe7f35db77f.patch";
      sha256 = "sha256-qR7scfQqhRGxg2n4HQsxVxCLkXbwZi+PlYxrOSEPsL0=";
      excludes = [ ".github/workflows/smoke-tests.sh" ];
    })
    (fetchpatch {
      name = "fix-compare-rrs-with-zero-length-rdata.patch";
      url = "https://github.com/avahi/avahi/commit/177d75e8c43be45a8383d794ce4084dd5d600a9e.patch";
      sha256 = "sha256-uwIyruAWgiWt0yakRrvMdYjjhEhUk5cIGKt6twyXbHw=";
    })
    (fetchpatch {
      name = "reject-non-utf-8-service-names.patch";
      url = "https://github.com/avahi/avahi/commit/2b6d3e99579e3b6e9619708fad8ad8e07ada8218.patch";
      sha256 = "sha256-lwSA3eEQgH0g51r0i9/HJMJPRXrhQnTIEDxcYqUuLdI=";
      excludes = [ "fuzz/fuzz-domain.c" ];
    })
    (fetchpatch {
      name = "core-no-longer-supply-bogus-services-to-callbacks.patch";
      url = "https://github.com/avahi/avahi/commit/93b14365c1c1e04efd1a890e8caa01a2a514bfd8.patch";
      sha256 = "sha256-VBm8vsBZkTbbWAK8FI71SL89lZuYd1yFNoB5o+FvlEU=";
      excludes = [
        ".github/workflows/smoke-tests.sh"
        "fuzz/fuzz-packet.c"
      ];
    })
    (fetchpatch {
      name = "CVE-2024-52616.patch";
      url = "https://github.com/avahi/avahi/commit/f8710bdc8b29ee1176fe3bfaeabebbda1b7a79f7.patch";
      hash = "sha256-BUQOQ4evKLBzV5UV8xW8XL38qk1rg6MJ/vcT5NBckfA=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
    glib
    autoreconfHook
  ];

  buildInputs = [
    libdaemon
    dbus
    glib
    expat
    libevent
  ];

  configureFlags = [
    "--disable-gdbm"
    "--disable-mono"
    "--with-dbus-sys=${placeholder "out"}/share/dbus-1/system.d"
    "--disable-gtk3"
    "--disable-qt5"
    "--disable-python"
    "--localstatedir=/var"
    "--runstatedir=/run"
    "--sysconfdir=/etc"
    "--with-distro=none"
    "--with-systemdsystemunitdir=no"
  ];

  installFlags = [
    "avahi_runtime_dir=${placeholder "out"}/run"
    "sysconfdir=${placeholder "out"}/etc"
  ];

  meta = {
    description = "mDNS/DNS-SD implementation";
    homepage = "http://avahi.org";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
  };
}
