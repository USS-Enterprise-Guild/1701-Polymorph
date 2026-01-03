# 1701 Polymorph

A smart Polymorph addon for World of Warcraft 1.12 (Vanilla) that automatically handles mind-controlled players and adds variety to your sheep game.

## Features

- **Mind Control Priority**: Automatically detects and polymorphs mind-controlled raid/party members
- **Range Checking**: Alerts raid/party when MC'd players are detected but out of range
- **Target Restoration**: Automatically restores your previous target after polymorphing an MC'd player
- **Auto-Announce**: Announces to raid/party chat when polymorphing an MC'd player
- **Spam Control**: Prevents duplicate announcements when spamming the macro
- **MC-Only Mode**: Optional mode to only handle mind-controlled players
- **Random Polymorph Variants**: Randomly selects from all Polymorph spells you know (Pig, Turtle, Black Cat, etc.)
- **Smart Target Validation**: Checks if targets can actually be polymorphed before casting
- **Helpful Feedback**: Shows clear messages when Polymorph can't be cast and why

## Installation

1. Download or clone this repository
2. Copy the `1701-Polymorph` folder to your `Interface/AddOns/` directory
3. Restart WoW or reload your UI with `/reload`

## Usage

```
/poly      - Polymorph MC'd players, or fall back to current target
/poly mc   - Only polymorph MC'd players, ignore current target
```

That's it! The addon handles the rest automatically.

## Behavior

When you use `/poly`, the addon follows this priority:

1. **Check for MC'd players**: Scans your raid or party for any attackable members (mind-controlled players)
   - Checks if they are in Polymorph range
   - If in range: targets them, casts Polymorph, announces to raid/party chat, then restores your previous target
   - If out of range: announces to raid/party chat that they are out of range, continues checking other members

2. **Fall back to current target**: If no MC'd players are found (or none in range), casts on your current target
   - Validates the target is attackable and polymorphable
   - Randomly picks from your known Polymorph variants for variety
   - Skipped entirely when using `/poly mc`

## Polymorphable Targets

The addon will only attempt to polymorph valid targets:

- **Humanoids** (most common)
- **Beasts**
- **Critters**
- **Players** (including mind-controlled allies)

## Feedback Messages

When Polymorph can't be cast, you'll see a message explaining why:

| Message | Meaning |
|---------|---------|
| `<name> is mind controlled but out of range!` | MC'd player detected but too far away (also sent to raid/party) |
| `No target selected.` | You need to select a target first |
| `Cannot attack <name>.` | Target is friendly |
| `<name> cannot be polymorphed (Demon).` | Target's creature type can't be polymorphed |

## Supported Polymorph Variants

The addon automatically detects all Polymorph spells in your spellbook:

- Polymorph (Sheep)
- Polymorph: Pig
- Polymorph: Turtle
- Polymorph: Black Cat
- Any other variants added by the server

## API

The addon exports functions for use by other addons or macros:

```lua
-- Execute the polymorph logic
Polymorph1701.Execute()

-- Get list of known polymorph spell names
local spells = Polymorph1701.GetKnownPolymorphSpells()

-- Find an attackable group member (returns unit, name or nil, nil)
local unit, name = Polymorph1701.FindAttackableGroupMember()
```

## Example Raid Announcement

When polymorphing a mind-controlled player named "Legolas", the addon announces:

```
[Raid] Polymorphing Legolas! (Mind Controlled)
```

## Version History

- **1.6.0** - Restore previous target after polymorphing MC'd player
- **1.5.0** - Added `/poly mc` parameter for MC-only mode
- **1.4.0** - Added range checking and spam control for MC announcements
- **1.3.0** - Added feedback messages when Polymorph fails to cast
- **1.2.0** - Dynamic spell detection (no longer uses predefined spell list)
- **1.1.0** - Initial release with MC detection and random variants

## License

MIT License - Feel free to modify and distribute.
