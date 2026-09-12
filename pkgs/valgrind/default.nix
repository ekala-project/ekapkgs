{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  perl,
  gdb,
}:

stdenv.mkDerivation rec {
  pname = "valgrind";
  version = "3.27.1";

  src = fetchurl {
    url = "https://sourceware.org/pub/valgrind/valgrind-${version}.tar.bz2";
    hash = "sha256-XViRUuuAccAv6rjOarcZ5DGh+8PisXAPVDJjKouSZNw=";
  };

  patches = [
    # Fix checks on Musl.
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=148912";
      sha256 = "Za+7K93pgnuEUQ+jDItEzWlN0izhbynX2crSOXBBY/I=";
    })
    (fetchpatch {
      url = "https://bugsfiles.kde.org/attachment.cgi?id=186451";
      hash = "sha256-IGmyHwwGoy00hcz3XxQSDcwcU8zHLBJ9dfqTvWDQ520=";
    })
    (fetchpatch {
      name = "reallocarray-test-musl.patch";
      url = "https://sourceware.org/git/?p=valgrind.git;a=patch;h=991961ece87e4cdc0771a05c956c55baa437bb07";
      hash = "sha256-U16384rLXMhLE5Em9z8FKYbshPlnq8l9ejC2+epL7M4=";
    })
    # Fix build on armv7l.
    (fetchpatch {
      url = "https://git.yoctoproject.org/poky/plain/meta/recipes-devtools/valgrind/valgrind/use-appropriate-march-mcpu-mfpu-for-ARM-test-apps.patch?id=b7a9250590a16f1bdc8c7b563da428df814d4292";
      sha256 = "sha256-sBZzn98Sf/ETFv8ubivgA6Y6fBNcyR8beB3ICDAyAH0=";
    })
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "doc"
  ];

  hardeningDisable = [
    "stackprotector"
  ];

  buildInputs = [
    gdb
    perl
  ];

  nativeBuildInputs = [
    autoreconfHook
    perl
  ];

  enableParallelBuilding = true;
  separateDebugInfo = stdenv.hostPlatform.isLinux;

  configureFlags = lib.optional stdenv.hostPlatform.isx86_64 "--enable-only64bit";

  postInstall = ''
    for i in $out/libexec/valgrind/*.supp; do
      substituteInPlace $i \
        --replace 'obj:/lib' 'obj:*/lib' \
        --replace 'obj:/usr/X11R6/lib' 'obj:*/lib' \
        --replace 'obj:/usr/lib' 'obj:*/lib'
    done
  '';

  meta = {
    homepage = "https://valgrind.org/";
    description = "Debugging and profiling tool suite";
    license = lib.licenses.gpl3Plus;
    mainProgram = "valgrind";
    platforms =
      with lib.platforms;
      lib.intersectLists (x86 ++ power ++ s390x ++ armv7 ++ aarch64 ++ mips ++ riscv64) (darwin ++ linux);
    broken = stdenv.hostPlatform.isDarwin;
  };
}
