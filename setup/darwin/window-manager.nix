{config, pkgs, ...}:

{
  services.spacebar.enable = true;
  services.spacebar.package = pkgs.spacebar;
  services.spacebar.config = {
    position         = "top";
    height           = 26;
    text_font        = ''"Helvetica Neue:Bold:12.0"'';
    icon_font        = ''"FontAwesome:Regular:13.0"'';
    background_color = "0xff202020";
    foreground_color = "0xffa8a8a8";
    space_icon_strip = "I II III IV V VI VII VIII IX X XI XII";
    power_icon_strip = " ";
    space_icon       = "";
    clock_icon       = "";
    dnd_icon         = "";
    clock_format     = ''"%R"'';
  };

  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.yabai.enableScriptingAddition = false;
  services.yabai.config = {
    external_bar                 = "all:26:0";

    mouse_follows_focus          = "off";
    focus_follows_mouse          = "autoraise";
    window_placement             = "second_child";
    window_topmost               = "on";
    window_opacity               = "off";
    window_opacity_duration      = 0.0;
    window_shadow                = "off";

    window_border                = "on";
    window_border_placement      = "inset";
    window_border_width          = "1";
    window_border_radius         = -1.0;
    active_window_border_topmost = "off";
    active_window_border_color   = "0xff775759";
    normal_window_border_color   = "0xff505050";
    insert_window_border_color   = "0xffd75f5f";

    active_window_opacity        = 1.0;
    normal_window_opacity        = 0.90;
    split_ratio                  = 0.5;
    auto_balance                 = "on";

    mouse_modifier               = "fn";
    mouse_action1                = "move";
    mouse_action2                = "resize";

    layout                       = "bsp";
    top_padding                  = 0;
    bottom_padding               = 0;
    left_padding                 = 0;
    right_padding                = 0;
    window_gap                   = 0;
  };
  services.yabai.extraConfig = ''
    yabai -m rule --add app='System Preferences' manage=off
  '';

  services.skhd.enable = true;
  services.skhd.package =  pkgs.skhd;
  services.skhd.skhdConfig = let yabai = "${pkgs.yabai}/bin/yabai -m";
  in ''
    alt - return  : kitty --single-instance /run/current-system/sw/bin/bash
    # NOTE(tweidner): Handled by Alfred itself.
    # alt - p       : open --new ~/Applications/Alfred.app
    alt - d       : open --new ~/Applications/Dash.app
    alt - b       : open --new ~/Applications/GoogleChrome.app --args --incognito

    alt - f       : ${yabai} window --toggle zoom-fullscreen
    alt - c       : ${yabai} space --rotate 90
    alt - t       : ${yabai} window --toggle float; ${yabai} window --grid 4:4:1:1:2:2

    alt - h       : ${yabai} window --focus west
    alt - j       : ${yabai} window --focus south
    alt - k       : ${yabai} window --focus north
    alt - l       : ${yabai} window --focus east

    # FIXME(tweidner): Does not yet work under Catalina:
    # https://github.com/koekeishiya/yabai/issues/205
    alt - 1       : ${yabai} space --focus 1
    alt - 2       : ${yabai} space --focus 2
    alt - 3       : ${yabai} space --focus 3
    alt - 4       : ${yabai} space --focus 4
    alt - 5       : ${yabai} space --focus 5
    alt - 6       : ${yabai} space --focus 6
    alt - 7       : ${yabai} space --focus 7
    alt - 8       : ${yabai} space --focus 8
    alt - 9       : ${yabai} space --focus 9

    shift + alt - h      : ${yabai} window --warp west
    shift + alt - j      : ${yabai} window --warp south
    shift + alt - k      : ${yabai} window --warp north
    shift + alt - l      : ${yabai} window --warp east

    shift + alt - 1      : ${yabai} window --space  1
    shift + alt - 2      : ${yabai} window --space  2
    shift + alt - 3      : ${yabai} window --space  3
    shift + alt - 4      : ${yabai} window --space  4
    shift + alt - 5      : ${yabai} window --space  5
    shift + alt - 6      : ${yabai} window --space  6
    shift + alt - 7      : ${yabai} window --space  7
    shift + alt - 8      : ${yabai} window --space  8
    shift + alt - 9      : ${yabai} window --space  9

    shift + alt - q      : ${yabai} window --close
    shift + alt - x      : pkill yabai; pkill skhd
  '';
}
