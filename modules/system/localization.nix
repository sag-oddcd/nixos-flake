_: {
  # Timezone
  # Brazil abolished daylight saving time in 2019 - permanently UTC-3
  time.timeZone = "America/Sao_Paulo";

  # Localization
  i18n = {
    defaultLocale = "pt_BR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";  # US-style decimal formatting (1,234.56 instead of 1.234,56)
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  # Console
  console = {
    keyMap = "br-abnt2";
    font = "Lat2-Terminus16";
  };
}
