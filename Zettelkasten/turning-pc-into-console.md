> **Source:** https://www.youtube.com/watch?v=xpki1IcjinU
# Setting up wake with controller
turning on the controller should turn on the PC

> **Issue**: After PC shutdown, the bluetooth connection is not persisted and the connection has to be manually persisted

This is possible with a 2.4 ghz connection using a dongle

```
Device Manager > Network adapters > Wireless Adapter for Windows
```

Run the following command in powershell,
```
powercfg -devicequery wake-armed
⬇︎
Wireless Adapter for Windows
```

# Setup autologin on Windows

Navigate to the below:
```
Regedit (Run as Administrator) > HKEY_LOCAL_MACHINE > Software > Microsoft > WindowsNT > CurrentVersion > Winlogon
```

Create a new default username and default password along with a boolean auto login
- Run Steam on Startup
- Uncheck Gamebar option in Settings/Gaming


