# modules/home-manager/xdg.nix
{ ... }:
{
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        browser = "zen-beta.desktop";
        editor = "dev.zed.Zed.desktop";
        viewer = "org.kde.gwenview.desktop";
        files = "org.gnome.Nautilus.desktop";
        archives = "org.kde.ark.desktop";
        pdf = "okularApplication_pdf.desktop";
        media = "vlc.desktop";
      in
      {
        # Images
        "image/png" = viewer;
        "image/jpeg" = viewer;
        "image/gif" = viewer;
        "image/webp" = viewer;
        "image/svg+xml" = viewer;
        "image/bmp" = viewer;
        "image/tiff" = viewer;
        "image/x-icon" = viewer;

        # Web
        "text/html" = browser;
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;
        "x-scheme-handler/about" = browser;
        "x-scheme-handler/unknown" = browser;
        "application/xhtml+xml" = browser;

        # Text / code
        "text/plain" = editor;
        "text/x-python" = editor;
        "text/x-shellscript" = editor;
        "text/x-csrc" = editor;
        "text/x-chdr" = editor;
        "text/x-c++src" = editor;
        "text/x-c++hdr" = editor;
        "text/x-java" = editor;
        "text/x-makefile" = editor;
        "text/markdown" = editor;
        "text/csv" = editor;
        "text/xml" = editor;
        "application/json" = editor;
        "application/x-yaml" = editor;
        "application/toml" = editor;
        "application/xml" = editor;
        "application/javascript" = editor;

        # PDF
        "application/pdf" = pdf;

        # File manager
        "inode/directory" = files;

        # Archives
        "application/zip" = archives;
        "application/x-tar" = archives;
        "application/gzip" = archives;
        "application/x-compressed-tar" = archives;
        "application/x-7z-compressed" = archives;
        "application/x-rar" = archives;
        "application/x-bzip2" = archives;
        "application/x-xz" = archives;

        # Video
        "video/mp4" = media;
        "video/x-matroska" = media;
        "video/webm" = media;
        "video/quicktime" = media;
        "video/x-msvideo" = media;
        "video/mpeg" = media;
        "video/ogg" = media;

        # Audio
        "audio/mpeg" = media;
        "audio/mp4" = media;
        "audio/flac" = media;
        "audio/ogg" = media;
        "audio/x-wav" = media;
        "audio/x-flac" = media;
        "audio/opus" = media;
        "audio/webm" = media;
      };
  };
}
