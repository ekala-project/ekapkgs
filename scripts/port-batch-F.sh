#!/usr/bin/env bash
set -euo pipefail

NIXPKGS="/home/jon/projects/nixpkgs"
EKAPKGS="/home/jon/projects/ekapkgs"
cd "$EKAPKGS"

PACKAGES=(
  u9fs uacme uarmsolver ubi_reader ubuntu-classic ucarp uchmviewer ucommon
  ucon64 u-config ucs-fonts ucspi-tcp udevil udftools udis86 udns udunits
  uemacs uftp ugit uhexen2 uhttpmock uhubctl uid_wrapper uif2iso uisp
  ultimate-oldschool-pc-font-pack umlet umoci umoria ums umurmur unclutter
  unclutter-xfixes undbx undervolt unfs3 unhide uni uni-algo unicon-lang
  unicorn unionfs-fuse unison uni-vga unnethack unordered_dense unrar-free
  unscd untex unyaffs up upscayl uptimed urdfdom-headers urlscan urlwatch
  usbguard usb-modeswitch-data usbtop usbview usrsctp ustr uucp uudeview
  uutils-findutils uwimap uxn valentina valijson varscan vassal vc vcdimager
  vcftools vcsh vdirsyncer vdpauinfo vectoroids vectorscan vegeta velero
  verbiste verdict veroroute vesta veusz vgrep vice video-compare vimiv-qt
  vim-vint vis visual-hexdiff visualvm vitetris vkbasalt vkeybd vkmark vlan
  vlock vmmlib vms-empire vnote vobcopy volatility3 volta vopono vorbisgain
  vowpal-wabbit vpl-gpu-rt vpn-slice vrpn vsqlite vtm vulkan-extension-layer
  vulkan-memory-allocator vulkan-validation-layers vuls vultr vultr-cli vvenc
  vxl vym waagent wabt wafw00f wait4x wakeonlan wallust wally-cli wander
  wandio wannier90 waon wapiti wargus wasm-component-ld wasmedge wasm-pack
  wasm-tools watchdog wavegain waycheck wayclip way-displays wayidle
  wayland-logout waynergy wayout waypipe wayshot wdisplays weather webalizer
  webdis webfs webhook webp-pixbuf-loader websocat websocketd websocketpp
  webtunnel wego wemux wev wgcf wgetpaste whatsie when wideriver widevine-cdm
  wiggle wiiuse wiki-tui windowlab wipe wire wiredtiger wireguard-go wiringpi
  wishlist witr wkhtmltopdf wla-dx wlc wl-clip-persist wlclock wlcs wlgreet
  wl-kbptr wlopm wlrctl wlr-randr wl-screenrec wlsunset wlvncc wmenu wmfs
  wml wmname wob wofi wol wordnet worker wpaperd wpscan wpsoffice writefreely
  w_scan2 wsdd wslay wstunnel wtf wtfutil wthrr wtype wush wuzz wv2 wvkbd
  wvstreams x11perf x11_ssh_askpass x2vnc x2x x42-avldrums x42-gmsynth
  x86info xalanc xan xandikos xaos xapp-symbolic-icons xautomation xavs xavs2
  xbacklight xbanish xbattbar xbindkeys xboard xbps xbyak xc xc3sprog xca
  xcaddy xcape xcftools xcfun xcircuit xcolor xconq xcp xcpc xcur2png
  xcursorgen xdgmenumaker xdg-terminal-exec xdg-utils-cxx xdiskusage xdo
  xdpyinfo xdriinfo xe xed xedit xe-guest-utilities xev xevd xeve xeyes
  xfce4-exo xfce4-panel-profiles xfce4-taskmanager xfel xflr5 xfr xfractint
  xfs-undelete xfwm4 xfwm4-themes xgalagapp xgamma xhost xhtml1 xiccd xidel
  xinput xinput-calibrator xjobs xkbcomp xkbevd xkblayout-state xkbprint
  xkbset xkb-switch xkill xl2tpd xlogo xlsatoms xlsclients xlsfonts xmacro
  xmake xmenu xmind xmlbird xmldiff xmlformat xmodmap xmoto xnec2c xnee xob
  xorg-cf-files xorg-docs xorg-rgb xorg-sgml-doctools xortool xosd xosview
  xosview2 xplanet xplr xpr xprop xqilla xq-xml xrandr xrdb xrefresh
  xr-hardware xschem xscope xsct xset xsetroot xsettingsd xss-lock xst
  xstdcmap xstow xteddy xtermcontrol xtitle xtl xtrace xurls xv xva-img
  xvinfo xvkbd xwallpaper xwd xwiimote xwininfo xxdiff xygrib yabasic
  yabause yamlfix yamlfmt yaml-language-server yank yanone-kaffeesatz yara-x
  yascreen yash yasr yate yeahconsole yed yetris yewtube yggdrasil yj yle-dl
  ympd ymuse yokadi you-get youki ypbind-mt ytalk ytcc yt-dlg ytmdl ytree ytt
  yubico-piv-tool yubihsm-connector yubikey-agent yubikey-manager
  yubikey-touch-detector yudit yuicompressor z88dk
  zabbix-agent2-plugin-postgresql zap zarchive zaz zcfan zdbsp zdns zeronet
  zfsnap zile zinnia zita-alsa-pcmi zita-resampler zizmor zk zlint zlog
  znapzend zoom zpaq zpaqfranz zps zrepl zsh-autocomplete zsh-autosuggestions
  zsh-completions zsh-fzf-tab zsh-history-substring-search zsh-powerlevel10k
  zsh-syntax-highlighting zsnes zssh zsync zug zuo zvm zx zxcvbn-c zxing zydis
)

SUCCESS=()
FAIL_EVAL=()
FAIL_BUILD=()
FAIL_OTHER=()
SKIPPED=()

for pkg in "${PACKAGES[@]}"; do
  echo ""
  echo "================================================================"
  echo "Processing: $pkg"
  echo "================================================================"

  prefix="${pkg:0:2}"
  src_dir="$NIXPKGS/pkgs/by-name/${prefix}/${pkg}"
  dest_dir="$EKAPKGS/pkgs/${pkg}"
  src_file="$src_dir/package.nix"

  # Skip if already exists
  if [ -d "$dest_dir" ]; then
    echo "SKIP: $pkg already exists"
    SKIPPED+=("$pkg: already exists")
    continue
  fi

  if [ ! -f "$src_file" ]; then
    echo "SKIP: source not found at $src_file"
    SKIPPED+=("$pkg: source not found")
    continue
  fi

  # Create destination directory
  mkdir -p "$dest_dir"

  # Copy package.nix as default.nix
  cp "$src_file" "$dest_dir/default.nix"

  # Copy any extra files (patches, etc.) but skip test directories and update scripts
  for f in "$src_dir"/*; do
    fname=$(basename "$f")
    if [ "$fname" = "package.nix" ]; then
      continue
    fi
    # Skip nixos test files and update scripts
    if [ "$fname" = "test-local-relay.nix" ] || [ "$fname" = "update.sh" ] || [ "$fname" = "update.py" ]; then
      continue
    fi
    # Copy patches, other nix files, directories (like tests/)
    cp -r "$f" "$dest_dir/"
  done

  # Apply transforms to default.nix
  nix_file="$dest_dir/default.nix"

  # Transform 1: Set meta.maintainers = [ ]
  # Replace various maintainers patterns (single-line)
  sed -i -E 's/maintainers = with lib\.maintainers; \[[^]]*\]/maintainers = [ ]/g' "$nix_file"
  sed -i -E 's/maintainers = \[ lib\.maintainers\.[^ ]* \]/maintainers = [ ]/g' "$nix_file"
  # Multi-line maintainers - handle with perl
  perl -0777 -i -pe 's/maintainers\s*=\s*with\s+lib\.maintainers\s*;\s*\[(?:[^\]]*)\]/maintainers = [ ]/gs' "$nix_file"
  perl -0777 -i -pe 's/maintainers\s*=\s*\[(?:[^\]]*?lib\.maintainers[^\]]*?)\]/maintainers = [ ]/gs' "$nix_file"
  # Catch remaining multi-line maintainers with team refs
  perl -0777 -i -pe 's/maintainers\s*=\s*(?:with\s+lib\.maintainers\s*;\s*)?\[[^\]]*\]/maintainers = [ ]/gs' "$nix_file"

  # Transform 2: Remove passthru.updateScript (various patterns)
  # Remove nix-update-script from inputs
  sed -i '/^\s*nix-update-script,$/d' "$nix_file"
  sed -i '/^\s*nix-update-script$/d' "$nix_file"
  # Remove unstableGitUpdater from inputs
  sed -i '/^\s*unstableGitUpdater,$/d' "$nix_file"
  sed -i '/^\s*unstableGitUpdater$/d' "$nix_file"
  # Remove gitUpdater from inputs
  sed -i '/^\s*gitUpdater,$/d' "$nix_file"
  sed -i '/^\s*gitUpdater$/d' "$nix_file"

  # Remove passthru.updateScript lines (single-line)
  sed -i '/passthru\.updateScript/d' "$nix_file"
  # Remove updateScript from passthru blocks (multi-line)
  perl -0777 -i -pe 's/\s*updateScript = nix-update-script \{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript = unstableGitUpdater \{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript = nix-update-script \{\s*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript = nix-update-script;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript = unstableGitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript = gitUpdater \{[^}]*\};\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript = gitUpdater;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript = \.\/update\.sh;\n?//gs' "$nix_file"
  perl -0777 -i -pe 's/\s*updateScript = \.\/update\.py;\n?//gs' "$nix_file"

  # Transform 3: Remove nixosTests refs in passthru.tests
  sed -i '/^\s*nixosTests,$/d' "$nix_file"
  sed -i '/^\s*nixosTests$/d' "$nix_file"
  # Remove specific nixosTests references in passthru.tests
  sed -i '/inherit (nixosTests)/d' "$nix_file"
  sed -i '/nixosTests\./d' "$nix_file"
  # Remove tests that reference nixosTests
  perl -0777 -i -pe 's/\n\s*tests = \{ inherit \(nixosTests\) [^;]*; \};\n/\n/gs' "$nix_file"
  perl -0777 -i -pe 's/\n\s*tests\s*=\s*\{\s*inherit\s+nixosTests\.[^;]*;\s*\};\n/\n/gs' "$nix_file"

  # Transform 4: CMake - add cmake.configurePhaseHook to nativeBuildInputs
  if grep -q '\bcmake\b' "$nix_file" && ! grep -q 'cmake\.configurePhaseHook' "$nix_file"; then
    if ! grep -q 'dontUseCmakeConfigure' "$nix_file"; then
      # Add cmake.configurePhaseHook after cmake in nativeBuildInputs
      perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bcmake\b)/$1$2\n    cmake.configurePhaseHook/s' "$nix_file"
    fi
  fi

  # Transform 5: Meson - add meson.configurePhaseHook after meson in nativeBuildInputs
  if grep -q '\bmeson\b' "$nix_file" && ! grep -q 'meson\.configurePhaseHook' "$nix_file"; then
    perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    meson.configurePhaseHook/s' "$nix_file"
    # Add ninja if not present
    if ! grep -q '\bninja\b' "$nix_file"; then
      perl -0777 -i -pe 's/(nativeBuildInputs\s*=\s*\[(?:(?!\]).)*)(\bmeson\b)/$1$2\n    ninja/s' "$nix_file"
      # Also add ninja to inputs if needed
      if ! grep -q 'ninja' "$nix_file"; then
        sed -i 's/\(\s*meson,\)/\1\n  ninja,/' "$nix_file"
      fi
    fi
    # Add meson to inputs if not present
    if ! grep -q '^\s*meson,' "$nix_file" && ! grep -q '^\s*meson$' "$nix_file"; then
      # meson might already be there as a buildInput
      true
    fi
  fi

  # Transform 6: Remove versionCheckHook and related nativeInstallCheckInputs
  sed -i '/^\s*versionCheckHook,$/d' "$nix_file"
  sed -i '/^\s*versionCheckHook$/d' "$nix_file"
  sed -i '/nativeInstallCheckInputs = \[ versionCheckHook \];/d' "$nix_file"
  perl -0777 -i -pe 's/\n\s*nativeInstallCheckInputs = \[\s*\n\s*versionCheckHook\s*\n\s*\];\n/\n/gs' "$nix_file"
  # Remove versionCheckHook from multi-item nativeInstallCheckInputs
  sed -i 's/versionCheckHook//g' "$nix_file"
  # Remove doInstallCheck if versionCheckHook was removed and no other check inputs remain
  if ! grep -q 'versionCheckHook' "$nix_file" && ! grep -q 'nativeInstallCheckInputs' "$nix_file"; then
    sed -i '/^\s*doInstallCheck = true;$/d' "$nix_file"
    sed -i '/^\s*versionCheckProgram = /d' "$nix_file"
    sed -i '/^\s*versionCheckProgramArg = /d' "$nix_file"
  fi

  # Clean up any empty passthru blocks
  perl -0777 -i -pe 's/\n\s*passthru\s*=\s*\{\s*\};\n/\n/gs' "$nix_file"

  # Remove any 'tests,' from inputs if nixosTests was removed
  sed -i '/^\s*tests,$/d' "$nix_file"

  # Clean up double blank lines
  sed -i '/^$/N;/^\n$/d' "$nix_file"

  # Format the file
  nixfmt "$nix_file" 2>/dev/null || true

  # Validate: nix-instantiate
  echo "  Evaluating..."
  if ! nix-instantiate -A "$pkg" 2>/dev/null; then
    echo "FAIL: nix-instantiate failed for $pkg"
    rm -rf "$dest_dir"
    FAIL_EVAL+=("$pkg")
    continue
  fi

  # Validate: nix-build with timeout
  echo "  Building (timeout 300s)..."
  if ! timeout 300 nix-build -A "$pkg" --timeout 300 2>&1 | tail -5; then
    echo "FAIL: nix-build failed or timed out for $pkg"
    rm -rf "$dest_dir"
    FAIL_BUILD+=("$pkg")
    continue
  fi

  # Re-format after successful build
  nixfmt "$nix_file" 2>/dev/null || true

  # Determine version for commit message
  version=$(nix-instantiate --eval -A "$pkg".version 2>/dev/null | tr -d '"' || echo "unknown")

  # Commit
  git -C "$EKAPKGS" add "pkgs/${pkg}/"
  git -C "$EKAPKGS" commit -m "${pkg}: init at ${version}"

  echo "SUCCESS: $pkg at $version"
  SUCCESS+=("$pkg: $version")
done

echo ""
echo "================================================================"
echo "RESULTS"
echo "================================================================"
echo ""
echo "SUCCESS (${#SUCCESS[@]}):"
for s in "${SUCCESS[@]}"; do echo "  $s"; done
echo ""
echo "FAILED EVAL (${#FAIL_EVAL[@]}):"
for s in "${FAIL_EVAL[@]}"; do echo "  $s"; done
echo ""
echo "FAILED BUILD (${#FAIL_BUILD[@]}):"
for s in "${FAIL_BUILD[@]}"; do echo "  $s"; done
echo ""
echo "SKIPPED (${#SKIPPED[@]}):"
for s in "${SKIPPED[@]}"; do echo "  $s"; done
