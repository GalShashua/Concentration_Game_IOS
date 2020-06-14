//
//  Card.swift
//  Concentration_HW1
//
//  Created by user167535 on 5/3/20.
//  Copyright © 2020 user167535. All rights reserved.
//

import Foundation

struct Card{
    private var cardsArray = [Card]()

    var isClosed = true
    var wasMatched = false
    var cardImage = ""
    var id: Int
    
    static var idGenerator = 0

    init(){
        self.id = Card.setCardId()
    }
    
    static func setCardId() -> Int {
        idGenerator += 1
        return idGenerator
    }
    
    static func resetCardIds(){
        idGenerator = 0
    }
    

    mutating func divideImagesBetweenCards(numOfPairs : Int) -> [Card] {
        for i in 1...numOfPairs {
            var card1 = Card()
            card1.cardImage = "card_\(i)"
            var card2 = Card()
            card2.cardImage = "card_\(i)"
            cardsArray.append(card1)
            cardsArray.append(card2)
        }
        return cardsArray
    }


}
