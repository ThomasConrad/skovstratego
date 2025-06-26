#set page(
  paper: "a4",
  margin: 0mm,
  flipped: true,
)

// Set main font to Dominican for body text
#set text(
  font: ("Dominican", "Times New Roman", "Georgia"),
  size: 9pt
)

// Function to simulate bold text when font doesn't have bold variant
#let fake-bold(content) = {
  text(stroke: 0.3pt + black, content)
}

// A7 card dimensions
#let card-width = 74mm
#let card-height = 105mm

// Enhanced styling and colors for classical theme

// UNIT CONFIGURATION SYSTEM
// Define unit properties and team-specific names
#let unit-configs = (
  // Greek team configuration
  "GREEK": (
    team-name: "GREEK",
    heading-font: "Diogenes",
    border-image: "greek-border.png",
    units: (
      "0": (name: "LABARUM", flavor: "Sacred Eagle Standard", count: 1),
      "1": (name: "GREEK FIRE", flavor: "Burning Oil Trap", count: 9),
      "2": (name: "KRYPTEIA", flavor: "Spartan Secret Agent", count: 1),
      "3": (name: "GYMNETES", flavor: "Light Skirmisher", count: 14),
      "4": (name: "SAPPER", flavor: "Wall Underminer", count: 6),
      "5": (name: "DEKADARCH", flavor: "Squad Leader", count: 6),
      "6": (name: "LOCHAGOS", flavor: "Company Captain", count: 6),
      "7": (name: "TAXIARCH", flavor: "Regiment Commander", count: 6),
      "8": (name: "CHILIARCH", flavor: "Battalion Leader", count: 5),
      "9": (name: "POLEMARCH", flavor: "War General", count: 3),
      "10": (name: "STRATEGOS", flavor: "Supreme General", count: 2),
      "11": (name: "BASILEUS", flavor: "Divine King", count: 1),
    )
  ),
  // Trojan team configuration  
  "TROJAN": (
    team-name: "TROJAN",
    heading-font: "Cinzel Decorative",
    border-image: "trojan-border.png",
    units: (
      "0": (name: "PALLADIUM", flavor: "Sacred Athena Statue", count: 1),
      "1": (name: "CALTROPS", flavor: "Spike Trap", count: 9),
      "2": (name: "INFILTRATOR", flavor: "City Spy", count: 1),
      "3": (name: "PELTAST", flavor: "Javelin Thrower", count: 14),
      "4": (name: "ENGINEER", flavor: "Siege Breaker", count: 6),
      "5": (name: "HOPLITE", flavor: "Shield Bearer", count: 6),
      "6": (name: "PENTEKONTARCH", flavor: "Fifty-Leader", count: 6),
      "7": (name: "HIPPARCHUS", flavor: "Cavalry Commander", count: 6),
      "8": (name: "HERO", flavor: "Noble Champion", count: 5),
      "9": (name: "ANAX", flavor: "Warrior Lord", count: 3),
      "10": (name: "PRIAM", flavor: "Royal Prince", count: 2),
      "11": (name: "DARDANUS", flavor: "Founder King", count: 1),
    )
  )
)

// Unit special rules and combat data
#let unit-rules = (
  "0": (
    special: "Cannot attack. Capture enemy flag to win the game!",
    defeats: (),
    defeated-by: ("1",) // Only bombs can attack flags, but flags are immune
  ),
  "1": (
    special: "Cannot attack or move. Destroys attackers.",
    defeats: ("11", "10", "9", "8", "7", "6", "5", "3", "2"), // All except miner and flag
    defeated-by: ("4",) // Only miner
  ),
  "2": (
    special: "Can defeat the highest-ranking enemy.",
    defeats: ("0", "11"),
    defeated-by: ("11", "10", "9", "8", "7", "6", "5", "4", "3", "1") // All other pieces
  ),
  "3": (
    special: none, // No special rules - just standard attacking
    defeats: ("2", "0"),
    defeated-by: ("11", "10", "9", "8", "7", "6", "5", "4", "1") // All military ranks, miner, bomb
  ),
  "4": (
    special: "Only piece that can defeat Bombs.",
    defeats: ("3", "2", "1", "0"),
    defeated-by: ("11", "10", "9", "8", "7", "6", "5") // All military ranks
  ),
  "5": (
    special: none, // No special rules - just standard attacking
    defeats: ("4", "3", "2", "0"),
    defeated-by: ("11", "10", "9", "8", "7", "6", "1") // All higher military ranks, bomb
  ),
  "6": (
    special: none, // No special rules - just standard attacking
    defeats: ("5", "4", "3", "2", "0"),
    defeated-by: ("11", "10", "9", "8", "7", "1") // Higher military ranks, bomb
  ),
  "7": (
    special: none, // No special rules - just standard attacking
    defeats: ("6", "5", "4", "3", "2", "0"),
    defeated-by: ("11", "10", "9", "8", "1") // Senior officers, bomb
  ),
  "8": (
    special: none, // No special rules - just standard attacking
    defeats: ("7", "6", "5", "4", "3", "2", "0"),
    defeated-by: ("11", "10", "9", "1") // Colonel, general, field marshal, bomb
  ),
  "9": (
    special: none, // No special rules - just standard attacking
    defeats: ("8", "7", "6", "5", "4", "3", "2", "0"),
    defeated-by: ("11", "10", "1") // General, field marshal, bomb
  ),
  "10": (
    special: none, // No special rules - just standard attacking
    defeats: ("9", "8", "7", "6", "5", "4", "3", "2", "0"),
    defeated-by: ("11", "2", "1") // Field marshal, spy, bomb
  ),
  "11": (
    special: "Vulnerable to Spy.",
    defeats: ("10", "9", "8", "7", "6", "5", "4", "3", "0"),
    defeated-by: ("2", "1") // Spy, bomb
  )
)

// Helper function to capitalize names (only first letter capital)
#let capitalize(text) = {
  if text.len() == 0 {
    ""
  } else {
    upper(text.first()) + lower(text.slice(1))
  }
}

// Helper function to get opposite team key
#let get-opposite-team(team-key) = {
  if team-key == "GREEK" {
    "TROJAN"
  } else {
    "GREEK"
  }
}

// Helper function to format defeat lists with opposite team's unit names
#let format-defeats(defeats, current-team-key) = {
  if defeats.len() == 0 {
    "None"
  } else {
    let opposite-team-key = get-opposite-team(current-team-key)
    let opposite-config = unit-configs.at(opposite-team-key)
    
    defeats.map(val => {
      let unit = opposite-config.units.at(val)
      capitalize(unit.name) + " (" + val + ")"
    }).join(", ")
  }
}

// Define single card creation function
#let make-card(title, number, description, border-image: none, heading-font: "Diogenes") = {
  let inner-padding = if border-image != none { 16mm } else { 4mm }
  
  let card-content = rect(
    width: card-width,
    height: card-height,
    stroke: if border-image != none { none } else { 1pt + black },
    inset: 0pt,
    [
      #v(15mm)
      // Title with enhanced styling
      #align(center)[
        #text(
          size: 11pt, 
          weight: "bold", 
          font: (heading-font, "Times New Roman")
        )[#title]
      ]
      #v(2mm)
      // Number circle with enhanced styling
      #align(center)[
        #circle(
          radius: 7mm,
          stroke: 2pt + black,
          inset: 0pt,
          align(center + horizon)[
            #text(
              size: 20pt, 
              weight: "bold",
              font: (heading-font, "Times New Roman")
            )[#number]
          ]
        )
      ]
      #v(2mm)
      // Description with better formatting
      #pad(x: inner-padding)[
        #set par(justify: true, leading: 0.6em)
        #set text(size: 7.5pt, font: ("Dominican", "Times New Roman", "Georgia"))
        #description
      ]
      #v(1fr)
      #v(8mm)
    ]
  )
  
  if border-image != none {
    box(
      width: card-width,
      height: card-height,
      [
        #card-content
        #place(
          top + left,
          image(border-image, width: card-width, height: card-height, fit: "stretch")
        )
      ]
    )
  } else {
    card-content
  }
}

// Function to create n copies of a card
#let make-cards(n, title, number, description, border-image: none, heading-font: "Diogenes") = {
  range(n).map(_ => make-card(title, number, description, border-image: border-image, heading-font: heading-font))
}

// Helper function to create pages with 8 cards each
#let card-pages(cards) = {
  let i = 0
  
  while i < cards.len() {
    let page-cards = cards.slice(i, calc.min(i + 8, cards.len()))
    
    // Fill remaining slots with empty rectangles
    let filled-cards = page-cards
    while filled-cards.len() < 8 {
      filled-cards = filled-cards + (rect(width: card-width, height: card-height, stroke: none),)
    }
    
    grid(
      columns: (card-width, card-width, card-width, card-width),
      rows: (card-height, card-height),
      column-gutter: 0mm,
      row-gutter: 0mm,
      ..filled-cards
    )
    
    if i + 8 < cards.len() {
      pagebreak()
    }
    
    i += 8
  }
}

// PROPORTIONALLY BALANCED DISTRIBUTION FOR 60 CARDS:
// Flag (0): 1 card (unchanged - unique objective)
// Bomb (1): 9 cards (1.5x from 6)
// Spy (2): 1 card (unchanged - unique ability)
// Scout (3): 14 cards (1.75x from 8)
// Miner (4): 6 cards (1.5x from 4)
// Sergeant (5): 6 cards (1.5x from 4)
// Lieutenant (6): 6 cards (1.5x from 4)
// Captain (7): 6 cards (1.5x from 4)
// Major (8): 5 cards (1.67x from 3)
// Colonel (9): 3 cards (1.5x from 2)
// General (10): 2 cards (2x from 1)
// Field Marshal (11): 1 card (unchanged - unique highest rank)
// TOTAL: 60 cards

// Function to generate all cards for a team using configuration
#let make-team-cards(team-key) = {
  let team-config = unit-configs.at(team-key)
  let cards = ()
  
  // Generate cards for each unit type (0-11)
  for unit-val in ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11") {
    let unit = team-config.units.at(unit-val)
    let rules = unit-rules.at(unit-val)
    
    let unit-cards = make-cards(
      unit.count, 
      team-config.team-name + "\n" + unit.name, 
      unit-val,
      [
        #set text(style: "italic")
        #fake-bold[#unit.flavor]
        
        #set text(style: "normal")
        #if rules.special != none [
          #fake-bold[Special Rules:] #rules.special
          
          #v(2mm)
        ]
        
        #fake-bold[Can defeat:] #format-defeats(rules.defeats, team-key)
        
        #fake-bold[Defeated by:] #format-defeats(rules.defeated-by, team-key)
      ],
      border-image: team-config.border-image,
      heading-font: team-config.heading-font
    )
    
    cards = cards + unit-cards
  }
  
  cards
}



// Generate cards for both teams
#card-pages(make-team-cards("GREEK"))
#pagebreak()
#card-pages(make-team-cards("TROJAN"))
