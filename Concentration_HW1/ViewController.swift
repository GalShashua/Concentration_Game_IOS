//
//  ViewController.swift
//  Concentration_HW1
//
//  Created by user167535 on 5/1/20.
//  Copyright © 2020 user167535. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var labelCongrats: UILabel!
    @IBOutlet weak var flipCountrLabel: UILabel!
    
    private var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int?
    private var previouslySeenCards: [Int:Int]!
    private var movesCounter : Double = 0
    private var isGameOver = false
    
    private var imagesArray = [#imageLiteral(resourceName: "card_5"),#imageLiteral(resourceName: "card_6"),#imageLiteral(resourceName: "card_2"),#imageLiteral(resourceName: "card_8"),#imageLiteral(resourceName: "card_4"),#imageLiteral(resourceName: "card_1"),#imageLiteral(resourceName: "card_7"),#imageLiteral(resourceName: "card_3")]
    var playableEmoji = [Int:UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        var numberOfPairsOfCards = (cardButtons.count + 1) / 2
        let numberOfCards = numberOfPairsOfCards * 2
        var allIndexes =  [Int](0..<numberOfCards)
        var emptyCardsArray: [Card?] = Array(repeating: nil, count: numberOfCards)
        previouslySeenCards = Dictionary<Int, Int>()
        
        for _ in 1...numberOfPairsOfCards {
            var firstRandomCardIndex = Int(arc4random_uniform(UInt32(allIndexes.count)))
            firstRandomCardIndex = allIndexes.remove(at: firstRandomCardIndex)
            var secondRandomCardIndex = Int(arc4random_uniform(UInt32(allIndexes.count)))
            secondRandomCardIndex = allIndexes.remove(at: secondRandomCardIndex)
            
            let card = Card()
            emptyCardsArray[firstRandomCardIndex] = card
            emptyCardsArray[secondRandomCardIndex] = card
            cards = emptyCardsArray.compactMap{$0}
        }
        
        for index in cardButtons.indices{
            let card = cards[index] // get the coresponding card from model
            let button = cardButtons[index]
            button.setBackgroundImage(#imageLiteral(resourceName: "depositphotos_294620642-stock-illustration-cute-safari-background-with-monkeyleaves (1)") , for: UIControl.State.normal)
            button.backgroundColor = card.matching ?  ( #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694) ): #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            
        }
        var castInt = Int(movesCounter)
        flipCountrLabel.text = "Moves: \(castInt)"
        
        if isGameOver{
            for index in cardButtons.indices{
                cardButtons[index].backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694)
                
                //    cardButtons[index].setTitle("", for: UIControl.State.normal)
                
                
            }
            flipCountrLabel.text = ""
            labelCongrats.text  = "Done. Another?"
            labelCongrats.isHidden = false
        } else {
            labelCongrats.isHidden = true
        }
        
    }
    
    
    @IBAction func cardClicked(_ sender: UIButton) {
        let idCardClicked = cardButtons.index(of: sender)
        
        //if the card not matched yet and he close now ->
        if (cards[idCardClicked!].matching == false && cards[idCardClicked!].isClosed) {
            movesCounter += 0.5
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != idCardClicked {
                if cards[matchIndex].id == cards[idCardClicked!].id{
                    cards[matchIndex].matching = true
                    cards[idCardClicked!].matching = true
                    
                } else{
                    previouslySeenCards[cards[idCardClicked!].id] = (previouslySeenCards[cards[idCardClicked!].id] ?? -1) + 1
                    previouslySeenCards[cards[matchIndex].id] = (previouslySeenCards[cards[matchIndex].id] ?? -1) + 1
                }
                cards[idCardClicked!].isClosed = false
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipDownCards in cards.indices{
                    cards[flipDownCards].isClosed = true
                }
                cards[idCardClicked!].isClosed = false
                indexOfOneAndOnlyFaceUpCard = idCardClicked
            }
               let matched = cards.filter({!$0.matching}).count
                 if  matched == 0 {
                     self.isGameOver = true
                 }
        }
        displayUpdate()
    }
    
    func emoji(for card: Card) -> UIImage {
        if playableEmoji[card.id] == nil, imagesArray.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(imagesArray.count)))
            playableEmoji[card.id] = imagesArray.remove(at: randomIndex)
        }
        return playableEmoji[card.id] ?? #imageLiteral(resourceName: "download")
    }
    
    
    @IBAction func newGame(_ sender: Any) {
        movesCounter=0
        Card.resetIdentifiers()
        var numberOfPairsOfCards = (cardButtons.count + 1) / 2
        let numberOfCards = numberOfPairsOfCards * 2
        var allIndexes =  [Int](0..<numberOfCards)
        var emptyCardsArray: [Card?] = Array(repeating: nil, count: numberOfCards)
        
        for _ in 1...numberOfPairsOfCards {
            var firstRandomCardIndex = Int(arc4random_uniform(UInt32(allIndexes.count)))
            firstRandomCardIndex = allIndexes.remove(at: firstRandomCardIndex)
            var secondRandomCardIndex = Int(arc4random_uniform(UInt32(allIndexes.count)))
            secondRandomCardIndex = allIndexes.remove(at: secondRandomCardIndex)
            
            let card = Card()
            emptyCardsArray[firstRandomCardIndex] = card
            emptyCardsArray[secondRandomCardIndex] = card
            cards = emptyCardsArray.compactMap{$0}
        }
        //              game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2 )
        //              emojiChoices = setTheme()
        displayUpdate()
        print("new game")
    }
    
    
    func displayUpdate(){
        for index in cardButtons.indices{
            let card = cards[index] // get the coresponding card from model
            let button = cardButtons[index]
            
            if card.isClosed{
                if(card.matching)
                {
                    cardButtons[index].setBackgroundImage( #imageLiteral(resourceName: "matched") , for: UIControl.State.normal)
                    
                } else {
                    button.setBackgroundImage( #imageLiteral(resourceName: "depositphotos_294620642-stock-illustration-cute-safari-background-with-monkeyleaves (1)") , for: UIControl.State.normal)
                    button.backgroundColor = card.matching ?  (  #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694) ): #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) //
                }
            } else {
                button.setBackgroundImage(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // pic background
            }
        }
        var castInt = Int(movesCounter)
        flipCountrLabel.text = "Moves: \(castInt)"
        //    labelScore.text = "Score: \(score)"
        
        if isGameOver{
            for index in cardButtons.indices{
                cardButtons[index].backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694)
         
                
            }
            flipCountrLabel.text = ""
            labelCongrats.text  = "Done. Another?"
            labelCongrats.isHidden = false
        } else {
            labelCongrats.isHidden = true
        }
        
    }
}

