# hosts/thinkpad-x1/variables.nix
{
  username    = "maksim";
  hostname    = "maksim-pc";
  timezone    = "Asia/Ho_Chi_Minh";
  # Location for gammastep (sunrise/sunset calculation). Da Nang, Vietnam.
  latitude    = 16.0544;
  longitude   = 108.2022;
  gitName      = "Maksim Vorontsov";
  gitEmail     = "social.maksim.vrs@gmail.com";
  gitZeustrackEmail = "maksim.vorontsov@zemomedia.com";
  ollamaModel  = "qwen2.5-coder:7b";
  # WARNING: stateVersion must never be changed after the first install.
  # Changing it can silently corrupt stateful services.
  stateVersion = "25.05";
}
