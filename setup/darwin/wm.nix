{config, pkgs, ...}:

{
  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.yabai.config = ''
    yabai -m config mouse_follows_focus          off
    yabai -m config focus_follows_mouse          on
    yabai -m config window_placement             second_child
    yabai -m config window_topmost               off
    yabai -m config window_opacity               on
    yabai -m config window_opacity_duration      0.0
    yabai -m config window_shadow                on
    yabai -m config window_border                off
    yabai -m config active_window_opacity        1.0
    yabai -m config normal_window_opacity        0.85
    yabai -m config split_ratio                  0.62
    yabai -m config auto_balance                 on

    yabai -m config layout                       bsp
    yabai -m config top_padding                  0
    yabai -m config bottom_padding               0
    yabai -m config left_padding                 0
    yabai -m config right_padding                0
    yabai -m config window_gap                   0
  '';

  services.skhd.enable = true;
  services.skhd.package =  pkgs.skhd;
  services.skhd.skhdConfig = let
    modMask = "cmd";
    terminal = "open /Applications/Google\ Chrome.app";
    browser = "open /Applications/Utilities/Terminal.app";
    prefix = "${pkgs.yabai}/bin/yabai -m";
  in ''
    ${modMask} - return                       : ${terminal} 
    ${modMask} - b                            : ${browser}
    ${modMask} - f                            : ${prefix} window --toggle zoom-fullscreen
    ${modMask} - c                            : ${prefix} space --rotate 180
    ${modMask} + shift - q                    : ${prefix} window --close
    ${modMask} + shift - x                    : pkill yabai; pkill skhd
  '';
}
