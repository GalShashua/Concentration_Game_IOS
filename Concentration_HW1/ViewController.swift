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
    @IBOutlet weak var labelFinishedGame: UILabel!
    @IBOutlet weak var abel: UILabel!
    
    private var cardsArray = [Card]()
    private var numOfPairs: Int!
    private var indexOfOneAndOnlyFaceUpCard: Int?
    private var previouslySeenCards: [Int:Int]!
    private var movesCounter : Double = 0
    private var isGameOver = false
    
    private var imagesArray = [#imageLiteral(resourceName: "card_5"),#imageLiteral(resourceName: "card_6"),#imageLiteral(resourceName: "card_2"),#imageLiteral(resourceName: "card_8"),#imageLiteral(resourceName: "card_4"),#imageLiteral(resourceName: "card_1"),#imageLiteral(resourceName: "card_7"),#imageLiteral(resourceName: "card_3")]
    var playableEmoji = [Int:UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        numOfPairs = (cardButtons.count + 1) / 2

        
        previouslySeenCards = Dictionary<Int, Int>()
        divideImagesForCards()
  
        for index in cardButtons.indices{
            let card = cardsArray[index] // get the coresponding card from model
            let button = cardButtons[index]
            button.setBackgroundImage(#imageLiteral(resourceName: "depositphotos_294620642-stock-illustration-cute-safari-background-with-monkeyleaves (1)") , for: UIControl.State.normal)
            button.backgroundColor = card.matching ?  ( #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694) ): #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        var castInt = Int(movesCounter)
        abel.text = "Moves: \(castInt)"
        if isGameOver{
            for index in cardButtons.indices{
                cardButtons[index].backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694)
            }
        //    flipCountrLabel.text = ""
            labelFinishedGame.text  = "Done. Another?"
            labelFinishedGame.isHidden = false
        } else {
            labelFinishedGame.isHidden = true
        }
    } //viewDidLoad
    
    
    @IBAction func cardClicked(_ sender: UIButton) {
        let idCardClicked = cardButtons.index(of: sender)
        
        //if the card not matched yet and he close now ->
        if (cardsArray[idCardClicked!].matching == false && cardsArray[idCardClicked!].isClosed) {
            movesCounter += 0.5
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != idCardClicked {
                if cardsArray[matchIndex].imageName == cardsArray[idCardClicked!].imageName{
                    cardsArray[matchIndex].matching = true
                    cardsArray[idCardClicked!].matching = true
                    
                } else{
                    previouslySeenCards[cardsArray[idCardClicked!].id] = (previouslySeenCards[cardsArray[idCardClicked!].id] ?? -1) + 1
                    previouslySeenCards[cardsArray[matchIndex].id] = (previouslySeenCards[cardsArray[matchIndex].id] ?? -1) + 1
                }
                cardsArray[idCardClicked!].isClosed = false
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                for flipDownCards in cardsArray.indices{
                    cardsArray[flipDownCards].isClosed = true
                }
                cardsArray[idCardClicked!].isClosed = false
                indexOfOneAndOnlyFaceUpCard = idCardClicked
            }
               let matched = cardsArray.filter({!$0.matching}).count
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
        cardsArray.removeAll()
        divideImagesForCards()
        displayUpdate()
    }
    
    
    func divideImagesForCards() {
        for i in 1...numOfPairs {
                    var card1 = Card()
                    card1.imageName = "card_\(i)"
                    print(card1.imageName)
                    
                    //create second card:
                    var card2 = Card()
                    card2.imageName = "card_\(i)"
                    print(card2.imageName)
                    
                    cardsArray.append(card1)
                    cardsArray.append(card2)
                    
                }
                cardsArray.shuffle()
    }
    
    
    func displayUpdate(){
        for index in cardButtons.indices{
            let card = cardsArray[index] // get the coresponding card from model
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
                var imageForCard = cardsArray[index].imageName
                print("image for cars issss \(imageForCard)")
                button.setBackgroundImage(UIImage(named: imageForCard), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // pic background
            }
        }
        var castInt = Int(movesCounter)
        abel.text = "Moves: \(castInt)"
        
        if isGameOver{
            for index in cardButtons.indices{
                cardButtons[index].backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 0.3961542694)
         
                
            }
            abel.text = ""
            labelFinishedGame.text  = "Done. Another?"
            labelFinishedGame.isHidden = false
        } else {
            labelFinishedGame.isHidden = true
        }
        
    }
}

