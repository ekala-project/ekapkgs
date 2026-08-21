# meson setup-hook is still sourced by default if meson was defined
if [ -z "${configurePhase-}" ]; then
    setOutputFlags=
    configurePhase=mesonConfigurePhase
fi
