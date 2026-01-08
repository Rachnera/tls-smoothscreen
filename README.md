## Setup

Scripts:
- Comment out old fullscreen script with Ctrl+A/Ctrl+Q (or remove it entirely if feeling confident)
- Add Zeus Module.rb
- Add Fullscreen++.rb
- Add Fullscreen Settings.rb

Other files:
- Add Fullscreen.dll to the game folder (root level, same as the steam_api.dll)
- Edit Game.ini and replace the [Fullscreen++] section with:
```
[Fullscreen++]
Fullscreen=true
VSync=true
BlackFrame=false
KeepAspect=1
Overscan=0.0
BackEffect=
BackAspect=0
EffectId=1
Effect0=SimpleScale()
Effect1=FSR() RAA() SimpleScale()
```

## Behavior

F5 works as previously
F6 does not do anything anymore
You can switch between different anti-aliasing configuration with Ctrl+F11
Rather than using keyboard shortcuts, everything can now be changed in the settings

## Known issues

If you switch between display options using the keyboard shortcuts while on the settings screen, the displayed values aren't instantly refreshed.

## Credits

Fullscreen script by Zeus81: https://forums.rpgmakerweb.com/index.php?threads/fullscreen-new-version-4.14081/
Config by JollyRogerQZR
