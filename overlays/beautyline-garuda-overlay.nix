# BeautyLine Garuda Fork - NixOS Overlay
# Place this file in your flake's overlays/ directory

final: prev: {
  beautyline-garuda = prev.stdenv.mkDerivation {
    pname = "beautyline-garuda";
    version = "unstable-2024-11-28";

    src = prev.fetchFromGitHub {
      owner = "Tekh-ops";
      repo = "Garuda-Linux-Icons";
      rev = "master";
      sha256 = "";  # First build will fail with correct hash - update this
      # After first failure, copy the hash from error and paste here
    };

    dontBuild = true;

    nativeBuildInputs = with prev; [
      gtk3  # for gtk-update-icon-cache
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/icons/BeautyLine

      # Copy all icon files
      cp -r apps $out/share/icons/BeautyLine/ || true
      cp -r actions $out/share/icons/BeautyLine/ || true
      cp -r devices $out/share/icons/BeautyLine/ || true
      cp -r places $out/share/icons/BeautyLine/ || true
      cp -r mimetypes $out/share/icons/BeautyLine/ || true

      # Copy metadata files
      cp index.theme $out/share/icons/BeautyLine/ || true
      cp AUTHORS $out/share/icons/BeautyLine/ || true
      cp COPYING $out/share/icons/BeautyLine/ || true

      # Fix badly named files (files with newlines in name)
      # This is a known issue in some BeautyLine versions
      find $out/share/icons/BeautyLine -type f -name "*\\n.svg" 2>/dev/null | while read -r file; do
        newname="$(echo "$file" | sed 's/\\n\.svg$/.svg/')"
        mv "$file" "$newname" 2>/dev/null || true
      done

      # Generate icon cache for faster loading
      ${prev.gtk3}/bin/gtk-update-icon-cache -f -t $out/share/icons/BeautyLine 2>/dev/null || {
        echo "Warning: Could not generate icon cache, but continuing..."
        true
      }

      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "BeautyLine icon theme - Garuda Linux fork with Candy Icons integration";
      longDescription = ''
        BeautyLine is a modern gradient-based icon theme with line art aesthetics.
        This is the Garuda Linux fork which includes:
        - 5,718 total icons (485 more than original)
        - 4,148 app icons (50% more than original)
        - Candy Icons integration by EliverLara
        - Excellent gaming and modern app coverage
      '';
      homepage = "https://github.com/Tekh-ops/Garuda-Linux-Icons";
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = [ ];
    };
  };
}
