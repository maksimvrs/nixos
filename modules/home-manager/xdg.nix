# modules/home-manager/xdg.nix
{ ... }: {
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = let
      browser = "zen-beta.desktop";
      editor  = "nvim.desktop";
      viewer  = "org.kde.gwenview.desktop";
      files   = "org.gnome.Nautilus.desktop";
    in {
      # Images
      "image/png"      = viewer;
      "image/jpeg"     = viewer;
      "image/gif"      = viewer;
      "image/webp"     = viewer;
      "image/svg+xml"  = viewer;
      "image/bmp"      = viewer;
      "image/tiff"     = viewer;
      "image/x-icon"   = viewer;

      # Web
      "text/html"                     = browser;
      "x-scheme-handler/http"         = browser;
      "x-scheme-handler/https"        = browser;
      "x-scheme-handler/about"        = browser;
      "x-scheme-handler/unknown"      = browser;
      "application/xhtml+xml"         = browser;

      # Text / code
      "text/plain"              = editor;
      "text/x-python"           = editor;
      "text/x-shellscript"      = editor;
      "text/x-csrc"             = editor;
      "text/x-chdr"             = editor;
      "text/x-c++src"           = editor;
      "text/x-c++hdr"           = editor;
      "text/x-java"             = editor;
      "text/x-makefile"         = editor;
      "text/markdown"           = editor;
      "text/csv"                = editor;
      "text/xml"                = editor;
      "application/json"        = editor;
      "application/x-yaml"      = editor;
      "application/toml"        = editor;
      "application/xml"         = editor;
      "application/javascript"  = editor;

      # PDF
      "application/pdf" = browser;

      # File manager
      "inode/directory" = files;

      # Archives
      "application/zip"              = files;
      "application/x-tar"            = files;
      "application/gzip"             = files;
      "application/x-compressed-tar" = files;
      "application/x-7z-compressed"  = files;
      "application/x-rar"            = files;
    };
  };
}
