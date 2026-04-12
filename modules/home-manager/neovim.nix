# modules/home-manager/neovim.nix
{ pkgs, variables, ... }:
let
  treesitterParsers = pkgs.symlinkJoin {
    name = "treesitter-parsers";
    paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  };
in
{
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = false;
    withRuby = false;
    extraPackages = with pkgs; [
      gcc
    ];
  };

  xdg.configFile = {
    "nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "AstroNvim";
        repo = "template";
        rev = "main";
        hash = "sha256-zrwpZ6Ow5qL9dml5gJFmLEOlQa02qm/AdFYGlfpw8fY=";
      };
      recursive = true;
    };

    # Disable treesitter auto-compilation
    "nvim/lua/plugins/treesitter-nix.lua".text = ''
      return {
        {
          "nvim-treesitter/nvim-treesitter",
          opts = {
            auto_install = false,
            ensure_installed = {},
          },
        },
      }
    '';

    # Oil.nvim file explorer
    "nvim/lua/plugins/oil.lua".text = ''
      return {
        {
          "stevearc/oil.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          cmd = "Oil",
          keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
          },
          opts = {},
        },
      }
    '';

    # Symlink Nix-built parsers into ~/.config/nvim/parser/
    # This path survives lazy.nvim's runtimepath reset
    "nvim/parser".source = "${treesitterParsers}/parser";
  };
}
