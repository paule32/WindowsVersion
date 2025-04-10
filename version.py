import platform
import wmi

def get_windows_version():
    version = platform.version()
    release = platform.release()
    system = platform.system()
    print("\nSystem: " + system + ", Release: " + release + ", Version: " + version)

def get_wmi_info():
    c = wmi.WMI()

    print("\nWin32_OperatingSystem:")
    for os in c.Win32_OperatingSystem():
        print("  OS Name        : " + os.Caption)
        print("  Version        : " + os.Version)
        print("  Build Number   : " + os.BuildNumber)
        print("  Registered User: " + os.RegisteredUser)
        print("  Install Date   : " + os.InstallDate)
        print("  System Root    : " + os.SystemDirectory)

    print("\nWin32_ComputerSystem:")
    for cs in c.Win32_ComputerSystem():
        print("  Computer Name  : " + cs.Name)
        print("  User Name      : " + cs.UserName)
        print("  Manufacturer   : " + cs.Manufacturer)
        print("  Model          : " + cs.Model)
        print("  RAM (MB)       : " + str(int(cs.TotalPhysicalMemory) // (1024 * 1024)))

    print("\nWin32_BIOS:")
    for bios in c.Win32_BIOS():
        print("  BIOS Version   : " + ' '.join(bios.BIOSVersion))
        print("  Serial Number  : " + bios.SerialNumber)
        print("  Release Date   : " + bios.ReleaseDate)

    print("\nWin32_Processor:")
    for cpu in c.Win32_Processor():
        print("  CPU Name       : " + cpu.Name)
        print("  Cores          : " + str(cpu.NumberOfCores))
        print("  Threads        : " + str(cpu.NumberOfLogicalProcessors))
        print("  Max Clock Speed: " + str(cpu.MaxClockSpeed) + " MHz")

    print("\nWin32_LogicalDisk:")
    for disk in c.Win32_LogicalDisk(DriveType=3):  # Only fixed disks
        print("  Drive " + disk.DeviceID + ": " + disk.VolumeName)
        print("    FileSystem   : " + disk.FileSystem)
        print("    Size (GB)    : " + str(int(disk.Size) // (1024**3)))
        print("    Free Space   : " + str(int(disk.FreeSpace) // (1024**3)))

if __name__ == "__main__":
    get_windows_version()
    get_wmi_info()
