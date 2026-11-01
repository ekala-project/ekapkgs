{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pillow,
  libGL,
  libGLU,
  libxxf86vm,
  libxrender,
  libxrandr,
  libxi,
  libxinerama,
  libxext,
  libx11,
  gdk-pixbuf,
  gtk3-x11,
  glibc,
  fontconfig,
  freetype,
  ffmpeg,
  openal-soft,
  libpulseaudio,
  harfbuzz,
}:

buildPythonPackage rec {
  version = "2.1.16";
  pname = "pyglet";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyglet";
    repo = "pyglet";
    tag = "v${version}";
    hash = "sha256-Wnpl2sqaK4AX6v70OjA10B9vMXQoC5QU1BP0UkYnJmU=";
  };

  postPatch =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    lib.optionalString stdenv.hostPlatform.isLinux ''
      cat > pyglet/lib.py <<EOF
      import ctypes
      def load_library(*names, **kwargs):
          for name in names:
              path = None
              if name == 'GL':
                  path = '${libGL}/lib/libGL${ext}'
              elif name == 'EGL':
                  path = '${libGL}/lib/libEGL${ext}'
              elif name == 'GLU':
                  path = '${libGLU}/lib/libGLU${ext}'
              elif name == 'c':
                  path = '${glibc}/lib/libc${ext}.6'
              elif name == 'X11':
                  path = '${libx11}/lib/libX11${ext}'
              elif name == 'gdk-x11-2.0':
                  path = '${gtk3-x11}/lib/libgdk-3${ext}'
              elif name == 'gdk_pixbuf-2.0':
                  path = '${gdk-pixbuf}/lib/libgdk_pixbuf-2.0${ext}'
              elif name == 'Xext':
                  path = '${libxext}/lib/libXext${ext}'
              elif name == 'fontconfig':
                  path = '${fontconfig.lib}/lib/libfontconfig${ext}'
              elif name == 'freetype':
                  path = '${freetype}/lib/libfreetype${ext}'
              elif name[0:2] == 'av' or name[0:2] == 'sw':
                  path = '${lib.getLib ffmpeg}/lib/lib' + name + '${ext}'
              elif name == 'openal':
                  path = '${openal-soft}/lib/libopenal${ext}'
              elif name == 'pulse':
                  path = '${libpulseaudio}/lib/libpulse${ext}'
              elif name == 'Xi':
                  path = '${libxi}/lib/libXi${ext}'
              elif name == 'Xinerama':
                  path = '${libxinerama}/lib/libXinerama${ext}'
              elif name == 'Xrandr':
                  path = '${lib.getLib libxrandr}/lib/libXrandr${ext}'
              elif name == 'Xrender':
                  path = '${lib.getLib libxrender}/lib/libXrender${ext}'
              elif name == 'Xxf86vm':
                  path = '${libxxf86vm}/lib/libXxf86vm${ext}'
              elif name == 'harfbuzz':
                  path = '${harfbuzz}/lib/libharfbuzz${ext}'
              if path is not None:
                  return ctypes.cdll.LoadLibrary(path)
          raise Exception("Could not load library {}".format(names))
      EOF
    '';

  build-system = [ flit-core ];

  dependencies = [ pillow ];

  # Needs GL setup which isn't possible in a build environment
  doCheck = false;

  pythonImportsCheck = [ "pyglet" ];

  meta = {
    homepage = "http://www.pyglet.org/";
    description = "Cross-platform windowing and multimedia library";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
