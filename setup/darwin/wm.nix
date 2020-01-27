{config, pkgs, ...}:

{
  services.yabai.enable = true;
  services.yabai.package = pkgs.yabai;
  services.yabai.config = ''
    yabai -m config status_bar                   on
    yabai -m config status_bar_text_font         "Helvetica Neue:Bold:12.0"
    yabai -m config status_bar_icon_font         "FontAwesome:Regular:12.0"
    yabai -m config status_bar_background_color  0xff202020
    yabai -m config status_bar_foreground_color  0xffa8a8a8
    yabai -m config status_bar_space_icon_strip  I II III IV V VI VII VIII IX X
    yabai -m config status_bar_power_icon_strip   
    yabai -m config status_bar_space_icon        
    yabai -m config status_bar_clock_icon        

    yabai -m config mouse_follows_focus          off
    yabai -m config focus_follows_mouse          on
    yabai -m config window_placement             second_child
    yabai -m config window_topmost               off
    yabai -m config window_opacity               on
    yabai -m config window_opacity_duration      0.0
    yabai -m config window_shadow                off

    yabai -m config window_border                on
    yabai -m config window_border_placement      inset
    yabai -m config window_border_width          1
    yabai -m config window_border_radius         -1.0
    yabai -m config active_window_border_topmost off
    yabai -m config active_window_border_color   0xff775759
    yabai -m config normal_window_border_color   0xff505050
    yabai -m config insert_window_border_color   0xffd75f5ff

    yabai -m config active_window_opacity        1.0
    yabai -m config normal_window_opacity        0.90
    yabai -m config split_ratio                  0.5
    yabai -m config auto_balance                 off

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
    mod = "alt";
    move = "alt + shift";
    terminal = "open --new /System/Applications/Utilities/Terminal.app";
    browser = "open --new /Applications/Google\ Chrome.app --args --incognito";
    yabai = "${pkgs.yabai}/bin/yabai -m";
  in ''
    ${mod} - return  : ${terminal} 
    ${mod} - b       : ${browser}

    ${mod} - f       : ${yabai} window --toggle zoom-fullscreen
    ${mod} - w       : ${yabai} space --rotate 180
    ${mod} - t       : ${yabai} window --toggle float; ${yabai} window --grid 4:4:1:1:2:2

    ${mod} - h       : ${yabai} window --focus west
    ${mod} - j       : ${yabai} window --focus south
    ${mod} - k       : ${yabai} window --focus north
    ${mod} - l       : ${yabai} window --focus east

    ${mod} - 1       : ${yabai} space --focus 1
    ${mod} - 2       : ${yabai} space --focus 2
    ${mod} - 3       : ${yabai} space --focus 3
    ${mod} - 4       : ${yabai} space --focus 4
    ${mod} - 5       : ${yabai} space --focus 5
    ${mod} - 6       : ${yabai} space --focus 6
    ${mod} - 7       : ${yabai} space --focus 7
    ${mod} - 8       : ${yabai} space --focus 8
    ${mod} - 9       : ${yabai} space --focus 9
    ${mod} - 0       : ${yabai} space --focus 10

    ${move} - h      : ${yabai} window --warp west
    ${move} - j      : ${yabai} window --warp south
    ${move} - k      : ${yabai} window --warp north
    ${move} - l      : ${yabai} window --warp east

    ${move} - 1      : ${yabai} window --space  1; ${yabai} space --focus 1
    ${move} - 2      : ${yabai} window --space  2; ${yabai} space --focus 2
    ${move} - 3      : ${yabai} window --space  3; ${yabai} space --focus 3
    ${move} - 4      : ${yabai} window --space  4; ${yabai} space --focus 4
    ${move} - 5      : ${yabai} window --space  5; ${yabai} space --focus 5
    ${move} - 6      : ${yabai} window --space  6; ${yabai} space --focus 6
    ${move} - 7      : ${yabai} window --space  7; ${yabai} space --focus 7
    ${move} - 8      : ${yabai} window --space  8; ${yabai} space --focus 8
    ${move} - 9      : ${yabai} window --space  9; ${yabai} space --focus 9
    ${move} - 0      : ${yabai} window --space 10; ${yabai} space --focus 10

    ${move} - q      : ${yabai} window --close
    ${move} - x      : pkill yabai; pkill skhd
  '';
}
