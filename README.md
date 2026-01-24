## Setup

### Scripts

First, the old fullscreen script is to be commented out (Ctrl+A/Ctrl+Q), or even removed entirely if feeling confident, as it would conflict with the new one.

Then, add the following scripts, as usual in that order and at the bottom of all other custom scripts but before Main:
- Zeus Module.rb
- Fullscreen++.rb
- Fullscreen Settings.rb

### Other files

First, backup the existing Game.exe and Game.ini somewhere else. Better safe than sorry.

Then:
- Replace Game.exe with the one available in this repository
- Add Fullscreen.dll to the System/ folder, next to RGSS301.dll
- Edit Game.ini and remove the [Fullscreen++] section and all its contents (the section will be automatically created with the default values on game launch)

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
