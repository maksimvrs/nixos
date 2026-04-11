# modules/home-manager/git.nix
{ variables, ... }:
{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = variables.gitName;
      user.email = variables.gitEmail;
      init.defaultBranch = "master";
      pull.rebase = true;
      merge.conflictstyle = "diff3";
    };
    includes = [
      {
        condition = "gitdir:~/zeustrack/";
        contents.user.email = variables.gitZeustrackEmail;
      }
    ];
  };
}
