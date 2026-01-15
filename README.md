## Setup

Scripts:
- Comment out old fullscreen script with Ctrl+A/Ctrl+Q (or remove it entirely if feeling confident)
- Add Zeus Module.rb
- Add Fullscreen++.rb
- Add Fullscreen Settings.rb after all other scripts adding settings or altering keybindings

Other files:
- Rename Game.exe to Game.old.exe (or delete if feeling really confident)
- Add the Game.exe of this repository in its stead
- Add Fullscreen.dll to System/ (next to RGSS301.dll)
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

You can switch between different anti-aliasing configuration with Ctrl+F11.

Rather than using keyboard shortcuts, everything can now be changed in the settings

## Known issues

If you switch between display options using the keyboard shortcuts while on the settings screen, the displayed values aren't instantly refreshed.

## Technical stuff

### Why the new exe?

The only difference between the .exe provided here and the one used until now is two extra flags telling the computer to use the dedicated GPU (if it exists) instead of the integrated one.

While the new shaders are powerful, they also are too resource-intensive to run smoothly on the modest performances of a non-dedicated card, leading to ostensible lag. The problem disappears when switching to dedicated but there's really only one way to tell the OS to do that automatically and it's to flag the exe itself. Hence why it has to be replaced.

In practice, all I did was take the original exe and run [nvpatch](https://github.com/toptensoftware/nvpatch) on it. See https://www.toptensoftware.com/blog/nvpatch-how-it-works/ for a more in-depth explanation of how it works.

## Credits

Fullscreen script by Zeus81: https://forums.rpgmakerweb.com/index.php?threads/fullscreen-new-version-4.14081/

Config by JollyRogerQZR

nvpatch by Topten Software: https://github.com/toptensoftware/nvpatch Special thanks to Brad Robinson for pretty much updating this tool just for us!
