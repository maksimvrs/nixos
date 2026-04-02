# modules/home-manager/cursor.nix
{ pkgs, ... }: {
  programs.vscode = {
    enable    = true;
    package   = pkgs.code-cursor;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python
    ];
  };
}
