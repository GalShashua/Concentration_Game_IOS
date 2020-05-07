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
    @IBOutlet weak var labelMovesCounter: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    
    private var cardsArray = [Card]()
    private var numOfPairs: Int!
    private var rememberLastIdCard: Int?
    private var previouslySeenCards: [Int:Int]!
    private var movesCounter : Double = 0
    private var isGameOver = false
    private var imagesArray = [#imageLiteral(resourceName: "card_5"),#imageLiteral(resourceName: "card_6"),#imageLiteral(resourceName: "card_2"),#imageLiteral(resourceName: "card_8"),#imageLiteral(resourceName: "card_4"),#imageLiteral(resourceName: "card_1"),#imageLiteral(resourceName: "card_7"),#imageLiteral(resourceName: "card_3")]
    var timer : Timer!
    var timerCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numOfPairs = (cardButtons.count + 1) / 2
        divideImagesBetweenCards()
        updateCardDisplay()
        updateLabelsDisplay()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeTimerLabel), userInfo: nil, repeats: true)
    }
    
    @objc func changeTimerLabel() {
        timerCounter += 1
        labelTimer.text = String(timerCounter)
    }
    
    @IBAction func newGame(_ sender: Any) {
        movesCounter=0
        Card.resetCardIds()
        cardsArray.removeAll()
        divideImagesBetweenCards()
        updateCardDisplay()
        labelFinishedGame.text = ""
    }
    
    
    func divideImagesBetweenCards() {
        for i in 1...numOfPairs {
                    var card1 = Card()
                    card1.cardImage = "card_\(i)"
                    var card2 = Card()
                    card2.cardImage = "card_\(i)"
                    cardsArray.append(card1)
                    cardsArray.append(card2)
                }
                cardsArray.shuffle()
    }
    
    
    func checkIfAllCardsMatched() -> Bool{
        var counterMatchedCards : Int = 0
        for card in cardsArray {
            if card.wasMatched {
                counterMatchedCards += 1
            }
        }
        return counterMatchedCards==cardsArray.count
    }
    
    func updateCardDisplay(){
        var i = 0
        for card in cardsArray{
            if card.isClosed{
                if(card.wasMatched) {
                    cardButtons[i].setBackgroundImage( #imageLiteral(resourceName: "matched") , for: UIControl.State.normal)
                }
                else {
                    cardButtons[i].setBackgroundImage( #imageLiteral(resourceName: "depositphotos_294620642-stock-illustration-cute-safari-background-with-monkeyleaves (1)") , for: UIControl.State.normal)
                }
            } else {
                cardButtons[i].setBackgroundImage(UIImage(named: card.cardImage), for: UIControl.State.normal)
                cardButtons[i].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            i += 1
        }
    }
        
        func updateLabelsDisplay(){
            labelMovesCounter.text = "Moves: \(Int(movesCounter))"
            if isGameOver{
                for index in cardButtons.indices{
                    cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                labelFinishedGame.text  = "congratulation!!!"
                labelFinishedGame.isHidden = false
            } else {
                labelFinishedGame.isHidden = true
            }
        }
    
    @IBAction func cardClicked(_ sender: UIButton) {
        previouslySeenCards = Dictionary<Int, Int>()
        let idCardClicked = cardButtons.firstIndex(of: sender)
        
        //if the card not matched yet and he close now ->
        if (cardsArray[idCardClicked!].isClosed && cardsArray[idCardClicked!].wasMatched == false) {
            movesCounter += 0.5 // 1 move is after opened 2 cards
    
            if let matchIndex = rememberLastIdCard, matchIndex != idCardClicked {
                if cardsArray[matchIndex].cardImage == cardsArray[idCardClicked!].cardImage{
                    cardsArray[matchIndex].wasMatched = true
                    cardsArray[idCardClicked!].wasMatched = true
                } else{
                    previouslySeenCards[cardsArray[idCardClicked!].id] = (previouslySeenCards[cardsArray[idCardClicked!].id] ?? -1) + 1
                    previouslySeenCards[cardsArray[matchIndex].id] = (previouslySeenCards[cardsArray[matchIndex].id] ?? -1) + 1
                }
                cardsArray[idCardClicked!].isClosed = false
                rememberLastIdCard = nil
            } else {
                for flipDownCards in cardsArray.indices{
                    cardsArray[flipDownCards].isClosed = true
                }
                cardsArray[idCardClicked!].isClosed = false
                rememberLastIdCard = idCardClicked
            }
                 if checkIfAllCardsMatched() {
                     self.isGameOver = true
                 }
        }
        updateCardDisplay()
        updateLabelsDisplay()
    }
        
    }


