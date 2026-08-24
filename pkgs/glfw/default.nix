{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  vulkan-loader,
  libxrandr,
  libxinerama,
  libxcursor,
  libx11,
  libxi,
  libxext,
  libxxf86vm,
  wayland,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
}:

stdenv.mkDerivation {
  pname = "glfw";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = "3.5.1";
    hash = "sha256-Vwi7MbzrQmcsENez987/Ju7H0pz0tSV6YC0DqwGeQ+w=";
  };

  patches = [ ./x11.patch ];

  propagatedBuildInputs = [ libGL ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
    libxxf86vm
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-D_GLFW_GLX_LIBRARY=\"${lib.getLib libGL}/lib/libGLX.so.0\""
    "-D_GLFW_EGL_LIBRARY=\"${lib.getLib libGL}/lib/libEGL.so.1\""
    "-D_GLFW_OPENGL_LIBRARY=\"${lib.getLib libGL}/lib/libGL.so.1\""
    "-D_GLFW_GLESV1_LIBRARY=\"${lib.getLib libGL}/lib/libGLESv1_CM.so.1\""
    "-D_GLFW_GLESV2_LIBRARY=\"${lib.getLib libGL}/lib/libGLESv2.so.2\""
    "-D_GLFW_VULKAN_LIBRARY=\"${lib.getLib vulkan-loader}/lib/libvulkan.so.1\""
  ];

  meta = {
    description = "Multi-platform library for creating OpenGL contexts and managing input";
    homepage = "https://www.glfw.org/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
