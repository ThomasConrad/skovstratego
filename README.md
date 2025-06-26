# Skovstratego

A classical mythology-themed strategy card game generator built with Typst. Create printable playing cards for an epic battle between Greek and Trojan forces.

## Overview

Skovstratego is a strategy card game inspired by the classic Stratego, reimagined with ancient Greek and Trojan mythology. The game features two opposing teams, each with unique units ranging from humble messengers to mighty gods.

## Features

- **Two Themed Teams**: Greek and Trojan forces with mythologically-inspired unit names
- **60 Cards Per Team**: Balanced distribution of 12 different unit types
- **Print-Ready Format**: A7-sized cards (74mm × 105mm) optimized for printing
- **Beautiful Design**: Custom borders and classical typography using Dominican and Diogenes fonts
- **Combat System**: Rock-paper-scissors style combat with special abilities

## Requirements

- [Typst](https://typst.app/) - Modern markup-based typesetting system
- Fonts:
  - Dominican (primary body font)
  - Diogenes (headings and numbers)
  - Fallbacks: Times New Roman, Georgia

## Quick Start

1. **Install Typst**: Follow the [official installation guide](https://github.com/typst/typst#installation)

2. **Generate Cards**:
   ```bash
   typst compile main.typ main.pdf
   ```

3. **Print**: Open `main.pdf` and print on A4 paper. Cards are designed to be cut out along the borders.

## Game Rules

### Objective
Capture the enemy's sacred treasure (Golden Fleece for Greeks, Palladium for Trojans) to win the game.

### Unit Types & Abilities

#### Special Units
- **Flag/Treasure (0)**: Cannot attack or move. Capture to win!
- **Siren's Song (1)**: Cannot move. Destroys any attacker except Miners
- **Hero/Spy (2)**: Can defeat the highest-ranking enemy unit

#### Military Units
- **Messenger (3)**: Swift scout unit
- **Sailor (4)**: Only unit that can defeat Siren's Song
- **Navigator (5)**: Ship officer
- **Captain (6)**: Ship commander  
- **Admiral (7)**: Fleet commander
- **Hero (8)**: Legendary warrior
- **Champion (9)**: Favored by the gods
- **Demigod (10)**: Bearer of immortal blood
- **God (11)**: Highest-ranking unit, vulnerable only to Hero/Spy

### Combat System
- Higher-ranked units defeat lower-ranked units
- Special units have unique combat rules
- When units of equal rank meet, both are destroyed

## File Structure

```
skovstratego/
├── main.typ              # Main card generation script
├── main.pdf              # Generated card sheets
├── greek-border.png      # Decorative border for Greek cards
├── trojan-border.png     # Decorative border for Trojan cards
└── README.md             # This file
```

## Customization

### Adding New Teams
Edit the `unit-configs` dictionary in `main.typ`:

```typst
#let unit-configs = (
  "YOUR_TEAM": (
    team-name: "YOUR_TEAM",
    heading-font: "Diogenes",
    border-image: "your-border.png",
    units: (
      // Define your units here
    )
  )
)
```

### Modifying Unit Counts
Adjust the `count` values in the unit configurations. The default distribution for 60 cards per team is:

- Flag/Treasure: 1
- Siren's Song: 9  
- Hero/Spy: 1
- Messenger: 14
- Military ranks: 4-6 each
- God: 1

### Changing Card Appearance
- **Fonts**: Modify the `#set text()` declarations
- **Colors**: Adjust stroke and fill colors in the styling functions
- **Borders**: Replace the PNG border images
- **Card Size**: Modify `card-width` and `card-height` variables

## Development

### Code Structure
The Typst script is organized into several key sections:

1. **Configuration**: Page setup, fonts, and dimensions
2. **Unit System**: Team configurations and unit properties  
3. **Combat Rules**: Defeat relationships and special abilities
4. **Card Generation**: Functions to create and layout cards
5. **Output**: Generate cards for both teams

### Key Functions
- `make-card()`: Creates individual cards with styling
- `make-team-cards()`: Generates all cards for a team
- `card-pages()`: Layouts cards in printable pages
- `format-defeats()`: Formats combat information

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test card generation
5. Submit a pull request

## License

This project is open source. Feel free to use, modify, and distribute as needed.

## Acknowledgments

- Inspired by the classic Stratego board game
- Greek and Trojan mythology themes
- Built with the excellent [Typst](https://typst.app/) typesetting system 