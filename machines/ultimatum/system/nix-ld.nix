{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [

      (pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")

      # List by default
      zlib
      zstd
      stdenv.cc.cc
      curl
      openssl
      attr
      libssh
      bzip2
      libxml2
      acl
      libsodium
      util-linux
      xz
      systemd

      # My own additions
      libxcomposite
      libxtst
      libxrandr
      libxext
      libx11
      libxfixes
      libGL
      libva
      pipewire
      libxcb
      libxdamage
      libxshmfence
      libxxf86vm
      libelf

      # Required
      glib
      gtk2

      # Inspired by steam
      networkmanager
      vulkan-loader
      libgbm
      libdrm
      libxcrypt
      coreutils
      pciutils
      zenity

      # Without these it silently fails
      libxinerama
      libxcursor
      libxrender
      libxscrnsaver
      libxi
      libsm
      libice
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      ffmpeg
      # Only libraries are needed from those two
      libudev0-shim

      # needed to run unity
      gtk3
      icu
      libnotify
      gsettings-desktop-schemas

      # Verified games requirements
      libxt
      libxmu
      libogg
      libvorbis
      SDL
      SDL2_image
      glew_1_10
      glfw
      glew.out
      libidn
      tbb
      alsa-plugins

      # Other things from runtime
      flac
      freeglut
      libjpeg
      libpng
      libpng12
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      libxft
      libvdpau

      # Some more libraries that I needed to run programs
      pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      dbus
      alsa-lib
      expat
      # for blender
      libxkbcommon

      libxcrypt-legacy # For natron
      libGLU # For natron

      # Appimages need fuse
      fuse
      e2fsprogs

      # darktable nightly AppImage
      gmp

      # RapidRaw
      harfbuzz
      libgpg-error
      fribidi
      librsvg
      (runCommand "librsvg" { } ''
        mkdir -p $out/lib/gdk-pixbuf-2.0/2.10.0/loaders
        ln -s "${librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders/libpixbufloader_svg.so" "$out/lib/libpixbufloader-svg.so"
      '')

      # pdfmastereditor
      sane-backends
      pkcs11helper

      # Qt6 requires this
      libpulseaudio
      krb5
      libxcb-cursor
      libxcb-wm
      libxcb-util
      libxcb-image
      libxcb-keysyms
      libxcb-render-util

    ];
  };

}
