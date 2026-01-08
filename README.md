## Setup

Scripts:
- Comment out old fullscreen script with Ctrl+A/Ctrl+Q (or remove it entirely if feeling confident)
- Add Zeus Module.rb
- Add Fullscreen++.rb

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
EffectId=0
Effect0=FSR() RAA() SimpleScale()
```

## Credits

Fullscreen script by Zeus81: https://forums.rpgmakerweb.com/index.php?threads/fullscreen-new-version-4.14081/
Config by JollyRogerQZR
