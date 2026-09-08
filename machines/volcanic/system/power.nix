{ ... }:
{
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "powersave";
        turbo = "never";
        energy_performance_preference = "power";
      };
      battery = {
        governor = "powersave";
        turbo = "never";
        energy_performance_preference = "power";
      };
    };
  };
  
  boot.kernelParams = [ 
    "pcie_aspm=force" 
    "processor.max_cstate=4" # 1st-Gen mobile chips only go down to C4 deep sleep
    "intel_idle.max_cstate=0" # Forces the kernel to use traditional ACPI idle rules instead of the modern driver
  ];

  # Force Powertop tuning for older SATA/PCI buses
  powerManagement.powertop.enable = true;

  # Block modern conflicting services
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = false;
    services.logind.settings.Login.HandleLidSwitch = "ignore";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };
}