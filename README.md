# SeekDB
Aardwolf MUSHclient plugin to report and store Seekers clanskill Seek data.

## Updates:
### 1.7
- New 'seekdb summary' command to summarize an area's mobs' resists/immunities
- 'seekdb find [target] [area]' is now used to search the database instead of 'seekdb'
- 'seek' default for enemy/SnD target improved
- Included number of strong resists to the neutral threshold, mobs with many strengths will now show neutral resists
- Using 'seekrep' no longer toggles seekrep reporting on for every seek
- Text in the window now wraps

### 1.61
- Seekdb now searches correctly based on whether the SnD target is from q/cp/gq or quickwhere
- Colour codes no longer appear in coloured enemy names when fighting them
- 'seek' without a target will now default to your enemy or your SnD

## Installation
Built on Anssett's SeekRep plugin. Only have one installed.
1. Download the raw SeekDB.xml and SeekDB.lua files.
2. Move them to your Aardwolf\worlds\plugins folder.
3. In MUSHclient, File->Plugins, click Add, open SeekDB.xml.

## Usage
### Seek the target and add it to the database:
```
seek <target>
```
### Seek your current enemy, or your current SnD target if not fighting:
```
seek
```
### Search the database and display the results in miniwindow and output:
```
seekdb find <target> <area>
```
### Seek and report:
```
seekrep <target> [top|bot] [quantity]
```
### Switch seek reporting on/off:
```
seekrep toggle
```
### Show number of mobs weak/strong/immune to each damtype in the area:
```
seekdb summary [full|totals|average]
```
### Right-click on the miniwindow to customize font, colours, whitelists, etc.

The miniwindow displays the current enemy and SnD quest/campaign/global quest or quickwhere target, in addition to 'seekdb <target> <area>' results.

Mob weaknesses are shown in green, in order from weakest to strongest.
Neutral resists are shown in grey, in order from weakest to strongest. Neutral resists are only shown when the number of immunities meets or exceeds the set threshold (5 by default).
Mob strengths are shown in orange, in order from strongest to weakest.
Mob immunites are shown in red.

Data is stored in SeekDB.db.

## Known Issues
- Window does not update immediately after toggling Short Resists mode or whitelist changes
- The order of damage types in whitelist menu can change, but they still work correctly
- seekrep and seekdb only take one keyword as a name argument
- Window enemy/target can only show one mob even if there are multiple database results
- Search & Destroy quickwhere doesn't show the name of the actual mob found in SeekDB

## Future Updates
- Option to show and group resist values
- Fixes for multiple database results, window updating after short resist and whitelist changes
- Scan and con overwriting
- Scan for mobs missing from database
- Database backups
- More advanced searches
- Etc.

## Debug Mode
### Toggle debug mode, will show mob IDs in seekdb results and additional DebugNotes (need cleaning up)
```
seekdb debug
```
### Delete a mob
```
seekdb delete <mobid>
```

### Confirm mob deletion
```
seekdb delete <mobid> confirm
```

## Credits
- Anssett: SeekRep 
- Crowley: Plugin updating stuff, SnD
- Fiendish: Aardwolf MUSHclient, GMCP Handler,  miniwindow stuff from Stat Monitor
- Nick Gammon: MUSHclient, all the documentation
