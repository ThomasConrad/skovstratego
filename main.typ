#set page(
  paper: "a4",
  margin: 0mm,
  flipped: true,
)

#set text(size: 9pt)

// A7 card dimensions
#let card-width = 74mm
#let card-height = 105mm

// Define single card creation function
#let make-card(title, number, description, border-image: none) = {
  let inner-padding = if border-image != none { 16mm } else { 4mm }
  let card-content = rect(
    width: card-width,
    height: card-height,
    stroke: if border-image != none { none } else { 1pt + black },
    inset: 0pt,
    [
      #v(15mm)
      #align(center)[
        #text(size: 11pt, weight: "bold")[#title]
      ]
      #v(2mm)
      #align(center)[
        #circle(
          radius: 7mm,
          stroke: 2pt + black,
          inset: 0pt,
          align(center + horizon)[
            #text(size: 20pt, weight: "bold")[#number]
          ]
        )
      ]
      #v(2mm)
              #pad(x: inner-padding)[
          #text(size: 7.5pt)[#description]
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
#let make-cards(n, title, number, description, border-image: none) = {
  range(n).map(_ => make-card(title, number, description, border-image: border-image))
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
#let make-team-cards(team-name) = {
  let border-image = if team-name == "GREEK" { "greek-border.png" } else { "trojan-border.png" }
  
  (
    // Flag - 1 card
    ..make-cards(1, team-name + " FLAG", "0",
    [*Flag:*
    The Flag cannot challenge others.
    
    The Flag can be captured by all pieces except the Bomb(1).
    
    *Objective:* Protect your flag and capture the enemy flag!],
    border-image: border-image
    ),
  
    // Bomb - 9 cards
    ..make-cards(9, team-name + " BOMB", "1",
    [A bomb cannot challenge others.
    
    *Bomb(1) Can defeat:*
    Field Marshal(11), General(10), Colonel(9), Major(8), Captain(7), Lieutenant(6), Sergeant(5), Scout(3), Spy(2).
    
    *Bomb(1) Can be defeated by:*
    Miner(4).],
    border-image: border-image
    ),

    // Spy - 1 card
    ..make-cards(1, team-name + " SPY", "2",
      [*Spy(2) Can defeat:*
      Flag(0) and Field Marshal(11).
      
      *Spy(2) Can be defeated by:*
      General(10), Colonel(9), Major(8), Captain(7), Lieutenant(6), Sergeant(5), Miner(4), Scout(3), Bomb(1).],
      border-image: border-image
    ),

    // Scout - 14 cards
    ..make-cards(14, team-name + " SCOUT", "3",
      [*Scout(3) Can defeat:*
      Spy(2) and Flag(0).
      
      *Scout(3) Can be defeated by:*
      Field Marshal(11), General(10), Colonel(9), Major(8), Captain(7), Lieutenant(6), Sergeant(5), Miner(4), Bomb(1).],
      border-image: border-image
    ),

    // Miner - 6 cards
    ..make-cards(6, team-name + " MINER", "4",
      [*Miner(4) Can defeat:*
      Scout(3), Spy(2), Bomb(1), and Flag(0).
      
      *Miner(4) Can be defeated by:*
      Field Marshal(11), General(10), Colonel(9), Major(8), Captain(7), Lieutenant(6), Sergeant(5).],
      border-image: border-image
    ),

    // Sergeant - 6 cards
    ..make-cards(6, team-name + " SERGEANT", "5",
      [*Sergeant(5) Can defeat:*
      Miner(4), Scout(3), Spy(2), and Flag(0).
      
      *Sergeant(5) Can be defeated by:*
      Field Marshal(11), General(10), Colonel(9), Major(8), Captain(7), Lieutenant(6), Bomb(1).],
      border-image: border-image
    ),

    // Lieutenant - 6 cards
    ..make-cards(6, team-name + " LIEUTENANT", "6",
      [*Lieutenant(6) Can defeat:*
      Sergeant(5), Miner(4), Scout(3), Spy(2), and Flag(0).
      
      *Lieutenant(6) Can be defeated by:*
      Field Marshal(11), General(10), Colonel(9), Major(8), Captain(7), Bomb(1).],
      border-image: border-image
    ),

    // Captain - 6 cards
    ..make-cards(6, team-name + " CAPTAIN", "7",
      [*Captain(7) Can defeat:*
      Lieutenant(6), Sergeant(5), Miner(4), Scout(3), Spy(2), and Flag(0).
      
      *Captain(7) Can be defeated by:*
      Field Marshal(11), General(10), Colonel(9), Major(8), Bomb(1).],
      border-image: border-image
    ),

    // Major - 5 cards
    ..make-cards(5, team-name + " MAJOR", "8",
      [*Major(8) Can defeat:*
      Captain(7), Lieutenant(6), Sergeant(5), Miner(4), Scout(3), Spy(2), and Flag(0).
      
      *Major(8) Can be defeated by:*
      Field Marshal(11), General(10), Colonel(9), Bomb(1).],
      border-image: border-image
    ),

    // Colonel - 3 cards
    ..make-cards(3, team-name + " COLONEL", "9",
      [*Colonel(9) Can defeat:*
      Major(8), Captain(7), Lieutenant(6), Sergeant(5), Miner(4), Scout(3), Spy(2), and Flag(0).
      
      *Colonel(9) Can be defeated by:*
      Field Marshal(11), General(10), Bomb(1).],
      border-image: border-image
    ),

    // General - 2 cards
    ..make-cards(2, team-name + " GENERAL", "10",
      [*General(10) Can defeat:*
      Colonel(9), Major(8), Captain(7), Lieutenant(6), Sergeant(5), Miner(4), Scout(3), Spy(2), and Flag(0).
      
      *General(10) Can be defeated by:*
      Field Marshal(11), Bomb(1).],
      border-image: border-image
    ),

    // Field Marshal - 1 card
    ..make-cards(1, team-name + " FIELD MARSHAL", "11",
      [*Field Marshal(11) Can defeat:*
      General(10), Colonel(9), Major(8), Captain(7), Lieutenant(6), Sergeant(5), Miner(4), Scout(3), and Flag(0).
      
      *Field Marshal(11) Can be defeated by:*
      Spy(2), Bomb(1).],
      border-image: border-image
    )
  )
}

// Generate cards for both teams
#card-pages(make-team-cards("GREEK\n"))
#pagebreak()
#card-pages(make-team-cards("TROJAN\n"))
