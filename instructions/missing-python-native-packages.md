# Missing Native Dependencies for Python Packages

Native C/C++ libraries and system packages needed by Python packages in the
python-packages repo. Each entry lists the native dependency and the Python
packages it would unblock.

**Total: 103 native dependencies blocking ~170 Python packages**

## GUI / Desktop Frameworks

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `pygobject3` | 8 | `gaphas`, `gatt`, `liblarch`, `mpris-server`, `nbxmpp`, `notify2`, `pydbus`, `pygtkspellcheck` |
| `pyqt6` | 7 | `echo`, `napari-console`, `pyqt6-charts`, `pyqt6-webengine`, `qpageview`, `qtawesome`, `qtconsole` |
| `pyqt5` | 4 | `poppler-qt5`, `pyface`, `superqt`, `traitsui` |
| `SDL2` | 3 | `pygame-sdl2`, `pysdl2`, `vulkan` |
| `pygame` | 2 | `moderngl-window`, `pytmx` |
| `at-spi2-core` | 2 | `dogtail`, `pyatspi` |
| `gst_all_1` | 1 | `gst-python` |
| `goocanvas_2` | 1 | `goocalendar` |
| `sdl3` | 1 | `pysdl3` |
| `glfw3` | 1 | `glfw` |

## Multimedia / Imaging

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `libpulseaudio` | 5 | `libpulse`, `pulsectl`, `pulsectl-asyncio`, `pyglet`, `soundcard` |
| `libmediainfo` | 3 | `knowit`, `pymediainfo`, `subliminal` |
| `libraw` | 2 | `rawkit`, `rawpy` |
| `tesseract` | 1 | `pytesseract` |
| `leptonica` | 1 | `tesserocr` |
| `portmidi` | 1 | `mido` |
| `opusfile` | 1 | `pyogg` |
| `libvlc` | 1 | `python-vlc` |
| `libsamplerate` | 1 | `samplerate` |
| `zbar` | 1 | `pyzbar` |
| `djvulibre` | 1 | `wand` |
| `jxrlib` | 1 | `imagecodecs` |
| `libdiscid` | 1 | `discid` |
| `libcdio` | 1 | `pycdio` |

## Crypto / Security

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `libxeddsa` | 5 | `oldmemo`, `omemo`, `twomemo`, `x3dh`, `xeddsa` |
| `c-siphash` | 4 | `cgen`, `codepy`, `pytools`, `siphash24` |
| `srtp` | 2 | `aiortc`, `pylibsrtp` |
| `krb5-c` (available as `krb5`) | 2 | `k5test`, `pykerberos` |
| `libnitrokey` | 1 | `pynitrokey` |
| `ocl-icd` | 1 | `pyopencl` |

## Scientific / Math

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `cppunit` | 4 | `oslotest`, `python-subunit`, `stestr`, `testrepository` |
| `htslib` | 2 | `htseq`, `pysam` |
| `gdal-cpp` | 2 | `rasterio`, `rioxarray` |
| `z3-solver` | 2 | `qiskit`, `qiskit-aer` |
| `suitesparse` | 1 | `cvxopt` |
| `ipopt` | 1 | `cyipopt` |
| `fplll` | 1 | `fpylll` |
| `ppl` | 1 | `pplpy` |
| `pari` | 1 | `cypari2` |
| `openmm` | 1 | `pdbfixer` |
| `openmp` | 1 | `pykdtree` |
| `vtk` | 1 | `pyvista` |
| `gmt` | 1 | `pygmt` |
| `precice` | 1 | `pyprecice` |
| `primecount` | 1 | `primecountpy` |
| `faiss-build` | 1 | `faiss` |

## Build / Packaging Infrastructure

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `pyprojectVersionPatchHook` | 8 | `aiohasupervisor`, `junos-eznc`, `napalm`, `nbmake`, `pysmi`, `pysnmp`, `pywbem`, `yamlloader` |
| `snakemake` | 6 | `snakemake-interface-common`, `snakemake-interface-executor-plugins`, `snakemake-interface-logger-plugins`, `snakemake-interface-report-plugins`, `snakemake-interface-scheduler-plugins`, `snakemake-interface-storage-plugins` |
| `pandoc` | 5 | `checkdmarc`, `corner`, `pelican`, `publicsuffixlist`, `pypandoc` |
| `ansible-core` | 1 | `ansible-compat` |
| `postgresqlTestHook` | 1 | `pgspecial` |
| `pnpm_10` | 1 | `yt-dlp-ejs` |
| `playwright-driver` | 1 | `playwright` |
| `pytest-asyncio_0` | 1 | `aresponses` |

## Networking / System

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `curl-impersonate` | 3 | `curl-cffi`, `soundcloud-v2`, `yfinance` |
| `fluent-syntax` | 3 | `translate-toolkit`, `translation-finder`, `weblate-language-data` |
| `cbor-diag` | 2 | `aiocoap`, `aiohomekit` |
| `networkmanager` | 2 | `nmcli`, `proton-vpn-api-core` |
| `xauth` | 2 | `pytest-xvfb`, `pyvirtualdisplay` |
| `inetutils` | 1 | `whois` |
| `watchman` | 1 | `pywatchman` |
| `wirelesstools` | 1 | `iwlib` |
| `rtl-sdr` | 1 | `pyrtlsdr` |
| `libgpiod` | 1 | `gpiod` |
| `acpi` | 1 | `py3status` |
| `apt` | 1 | `python-apt` |
| `esptool` | 1 | `rns` |
| `pkgsLibpcap` | 1 | `libpcap` |

## Text / Language Processing

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `mecab` | 3 | `fugashi`, `ipadic`, `unidic` |
| `opentype-sanitizer` | 1 | `ots-python` |
| `libgdstk` | 1 | `gdstk` |
| `castxml` | 1 | `pygccxml` |
| `readstat` | 1 | `pyreadstat` |

## Database

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `mysql84` | 1 | `mysql-connector-python` |
| `sqlcipher` | 1 | `sqlcipher3` |
| `odpic` | 1 | `cx-oracle` |
| `libmemcached` | 1 | `pylibmc` |

## Misc Native Libraries

| Dependency | Blocks | Python Packages |
|------------|--------|-----------------|
| `bytesize` | 1 | `blivet` |
| `cabextract` | 1 | `patool` |
| `chmlib` | 1 | `pychm` |
| `clipper` | 1 | `pynest2d` |
| `coin3d` | 1 | `pivy` |
| `freefont_ttf` | 1 | `pyqtgraph` |
| `ghostscript_headless` | 1 | `ghostscript` |
| `isa-l` | 1 | `isal` |
| `jrl-cmakemodules` | 1 | `eigenpy` |
| `lato` | 1 | `kaleido` |
| `liberasurecode` | 1 | `pyeclib` |
| `libgeoip` | 1 | `geoip` |
| `libgphoto2` | 1 | `gphoto2` |
| `liblo` | 1 | `pyliblo3` |
| `libmilter` | 1 | `pymilter` |
| `lief` | 1 | `pymisp` |
| `optipng` | 1 | `mne` |
| `radare2` | 1 | `r2pipe` |
| `sabnzbd` | 1 | `sabctools` |
| `sane-backends` | 1 | `sane` |
| `sdcc` | 1 | `fx2` |
| `taglib` | 1 | `pytaglib` |
| `taskwarrior2` | 1 | `taskw` |
| `unrar` | 1 | `unrardll` |
| `vectorscan` | 1 | `pyperscan` |
| `wireshark-cli` | 1 | `pyshark` |
| `exempi` | 1 | `python-xmp-toolkit` |
| `libleidenalg` | 1 | `leidenalg` |
| `paup-cli` | 1 | `dendropy` |
| `cbc` | 1 | `pulp` |

## Highest Impact (5+ Python packages unblocked)

Adding these native dependencies would unblock the most Python packages:

1. **`pygobject3`** (8) — GObject introspection, needed for GTK/GNOME Python bindings
2. **`pyprojectVersionPatchHook`** (8) — Nix Python build hook for patching pyproject versions
3. **`pyqt6`** (7) — Qt 6 Python bindings
4. **`snakemake`** (6) — Workflow management system
5. **`libpulseaudio`** (5) — PulseAudio client library
6. **`libxeddsa`** (5) — XEdDSA signature scheme (Signal protocol)
7. **`pandoc`** (5) — Universal document converter (Haskell)
