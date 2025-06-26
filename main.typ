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

// Function to generate all cards for a team
#let make-team-cards(team-name, heading-font) = {
  let border-image = if team-name == "GREEK" { "greek-border.png" } else { "trojan-border.png" }
  
  (
    // Flag - 1 card
    ..make-cards(1, team-name + " FLAG", "0",
    [
      #set text(style: "italic")
      #fake-bold[The Sacred Standard]
      
      #set text(style: "normal")
      The Flag represents your army's honor and cannot engage in combat.
      
      #v(2mm)
      
      #fake-bold[Special Rules:]
      • Cannot challenge other pieces
      • Immune to Bombs
      • #fake-bold[Victory Condition:] Capture the enemy flag to win!
    ],
    border-image: border-image,
    heading-font: heading-font
    ),
  
    // Bomb - 9 cards
    ..make-cards(9, team-name + " BOMB", "1",
    [
      #set text(style: "italic")
      #fake-bold[Explosive Trap]
      
      #set text(style: "normal")
      A hidden mine that destroys most attackers but cannot move to attack.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Field Marshal, General, Colonel, Major, Captain, Lieutenant, Sergeant, Scout, Spy
      
      #fake-bold[Defeated by:] Miner (only)
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Spy - 1 card
    ..make-cards(1, team-name + " SPY", "2",
    [
      #set text(style: "italic")
      #fake-bold[Shadow Agent]
      
      #set text(style: "normal")
      A master of stealth who can eliminate the highest-ranking enemy through cunning.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Flag, Field Marshal
      
      #fake-bold[Defeated by:] All other pieces
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Scout - 14 cards
    ..make-cards(14, team-name + " SCOUT", "3",
    [
      #set text(style: "italic")
      #fake-bold[Swift Messenger]
      
      #set text(style: "normal")
      Light infantry skilled in reconnaissance and rapid movement across the battlefield.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Spy, Flag
      
      #fake-bold[Defeated by:] All military ranks, Miner, Bomb
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Miner - 6 cards
    ..make-cards(6, team-name + " MINER", "4",
    [
      #set text(style: "italic")
      #fake-bold[Siege Engineer]
      
      #set text(style: "normal")
      Specialized warrior trained to disarm explosives and breach fortifications.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Scout, Spy, #fake-bold[Bomb], Flag
      
      #fake-bold[Defeated by:] All military ranks
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Sergeant - 6 cards
    ..make-cards(6, team-name + " SERGEANT", "5",
    [
      #set text(style: "italic")
      #fake-bold[Veteran Warrior]
      
      #set text(style: "normal")
      Experienced soldier who leads from the front and commands respect on the battlefield.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Miner, Scout, Spy, Flag
      
      #fake-bold[Defeated by:] All higher military ranks, Bomb
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Lieutenant - 6 cards
    ..make-cards(6, team-name + " LIEUTENANT", "6",
    [
      #set text(style: "italic")
      #fake-bold[Junior Officer]
      
      #set text(style: "normal")
      Skilled officer who balances tactical knowledge with battlefield courage.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Sergeant, Miner, Scout, Spy, Flag
      
      #fake-bold[Defeated by:] Higher military ranks, Bomb
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Captain - 6 cards
    ..make-cards(6, team-name + " CAPTAIN", "7",
    [
      #set text(style: "italic")
      #fake-bold[Company Commander]
      
      #set text(style: "normal")
      Seasoned leader who commands troops with authority and strategic insight.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Lieutenant, Sergeant, Miner, Scout, Spy, Flag
      
      #fake-bold[Defeated by:] Senior officers, Bomb
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Major - 5 cards
    ..make-cards(5, team-name + " MAJOR", "8",
    [
      #set text(style: "italic")
      #fake-bold[Battalion Leader]
      
      #set text(style: "normal")
      High-ranking officer with significant tactical responsibility and battlefield experience.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Captain, Lieutenant, Sergeant, Miner, Scout, Spy, Flag
      
      #fake-bold[Defeated by:] Field Marshal, General, Colonel, Bomb
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Colonel - 3 cards
    ..make-cards(3, team-name + " COLONEL", "9",
    [
      #set text(style: "italic")
      #fake-bold[Regimental Commander]
      
      #set text(style: "normal")
      Senior officer with extensive command authority and deep strategic understanding.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Major, Captain, Lieutenant, Sergeant, Miner, Scout, Spy, Flag
      
      #fake-bold[Defeated by:] Field Marshal, General, Bomb
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // General - 2 cards
    ..make-cards(2, team-name + " GENERAL", "10",
    [
      #set text(style: "italic")
      #fake-bold[Army Commander]
      
      #set text(style: "normal")
      Elite military leader with supreme tactical knowledge and command over vast forces.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] Colonel, Major, Captain, Lieutenant, Sergeant, Miner, Scout, Spy, Flag
      
      #fake-bold[Defeated by:] Field Marshal, Bomb
    ],
    border-image: border-image,
    heading-font: heading-font
    ),

    // Field Marshal - 1 card
    ..make-cards(1, team-name + " FIELD MARSHAL", "11",
    [
      #set text(style: "italic")
      #fake-bold[Supreme Commander]
      
      #set text(style: "normal")
      The highest-ranking military officer, commanding respect from all but vulnerable to cunning and explosives.
      
      #v(2mm)
      
      #fake-bold[Can defeat:] All military ranks, Miner, Scout, Flag
      
      #fake-bold[Defeated by:] Spy, Bomb
      
      #v(1mm)
      #set text(size: 7pt, style: "italic")
      _"Leadership in war is bought with blood and wisdom."_
    ],
    border-image: border-image,
    heading-font: heading-font
    )
  )
}

// Generate cards for both teams
#card-pages(make-team-cards("GREEK\n", "Diogenes"))
#pagebreak()
#card-pages(make-team-cards("TROJAN\n", "Cinzel Decorative"))
