# 1701 Polymorph

A smart Polymorph addon for World of Warcraft 1.12 (Vanilla) that automatically handles mind-controlled players and adds variety to your sheep game.

## Features

- **Mind Control Priority**: Automatically detects and polymorphs mind-controlled raid/party members
- **Auto-Announce**: Announces to raid/party chat when polymorphing an MC'd player
- **Random Polymorph Variants**: Randomly selects from all Polymorph spells you know (Pig, Turtle, Black Cat, etc.)
- **Smart Target Validation**: Checks if targets can actually be polymorphed before casting
- **Helpful Feedback**: Shows clear messages when Polymorph can't be cast and why

## Installation

1. Download or clone this repository
2. Copy the `1701-Polymorph` folder to your `Interface/AddOns/` directory
3. Restart WoW or reload your UI with `/reload`

## Usage

```
/poly
```

That's it! The addon handles the rest automatically.

## Behavior

When you use `/poly`, the addon follows this priority:

1. **Check for MC'd players**: Scans your raid or party for any attackable members (mind-controlled players)
   - If found, targets them, casts Polymorph, and announces to raid/party chat

2. **Fall back to current target**: If no MC'd players are found, casts on your current target
   - Validates the target is attackable and polymorphable
   - Randomly picks from your known Polymorph variants for variety

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

- **1.3.0** - Added feedback messages when Polymorph fails to cast
- **1.2.0** - Dynamic spell detection (no longer uses predefined spell list)
- **1.1.0** - Initial release with MC detection and random variants

## License

MIT License - Feel free to modify and distribute.
