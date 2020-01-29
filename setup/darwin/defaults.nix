{ config, pkgs, ...}:

{
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  system.defaults = {

    LaunchServices.LSQuarantine = true;

    NSGlobalDomain = {
      AppleFontSmoothing = 2;
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      AppleShowScrollBars = "Automatic";
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDisableAutomaticTermination = true;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSTableViewDefaultSizeMode = 2;
      NSTextShowsControlCharacters = false;
      NSUseAnimatedFocusRing = false;
      NSScrollAnimationEnabled = true;
      NSWindowResizeTime = "0.20";
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      "com.apple.keyboard.fnState" = false;
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.volume" = "0.000";
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.trackpadCornerClickBehavior" = null;
      "com.apple.trackpad.scaling" = "1";
      "com.apple.springing.enabled" = null;
      "com.apple.springing.delay" = "1.0";
      "com.apple.swipescrolldirection" = true;
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleTemperatureUnit = "Celsius";
      _HIHideMenuBar = true;
    };
   
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;

    alf = {
      globalstate = 2;
      allowsignedenabled = 0;
      allowdownloadsignedenabled = 0;
      loggingenabled = 1;
      stealthenabled = 1;
    };

    dock = {
      autohide = true;
      autohide-delay = "0.24";
      autohide-time-modifier = "1.0";
      dashboard-in-overlay = true;
      enable-spring-load-actions-on-all-items = false;
      expose-animation-duration = "1.0";
      expose-group-by-app = true;
      launchanim = false;
      mineffect = "scale";
      minimize-to-application = true;
      mouse-over-hilite-stack = true;
      mru-spaces = false;
      orientation = "bottom";
      show-process-indicators = true;
      showhidden = true;
      show-recents = false;
      static-only = false;
      tilesize = 48;
    };

    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    loginwindow = {
      SHOWFULLNAME = false;
      autoLoginUser = null;
      GuestEnabled = false;
      LoginwindowText = "timaa2k";
      DisableConsoleAccess = false;
    };

    spaces.spans-displays = false;

    trackpad = {
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
      ActuationStrength = 1;
      FirstClickThreshold = 1;
      SecondClickThreshold = 1;
    };

  };
 
}
