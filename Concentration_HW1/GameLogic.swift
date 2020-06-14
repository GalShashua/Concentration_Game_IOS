////
////  GameLogic.swift
////  Concentration_HW1
////
////  Created by user167535 on 5/31/20.
////  Copyright © 2020 user167535. All rights reserved.
////
//
import UIKit
import Foundation
//
class GameLogic {
    private var cardsArray = [Card]()
    var player: Player!
     var name : String?
    private var rememberLastIdCard: Int?
    private var previouslySeenCards: [Int:Int]!

    func divideImagesBetweenCards(numOfPairs : Int) -> [Card] {
        for i in 1...numOfPairs {
            var card1 = Card()
            card1.cardImage = "card_\(i)"
            var card2 = Card()
            card2.cardImage = "card_\(i)"
            cardsArray.append(card1)
            cardsArray.append(card2)
        }
        return cardsArray.shuffled()
    }
    
    func checkHowMuchCardsMatched(cards: [Card]) -> Int{
        var counterMatchedCards : Int = 0
        for card in cards {
            if card.wasMatched {
                counterMatchedCards += 1
            }
        }
        return counterMatchedCards
    }

    func getCurrentDate() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YYYY"
        return formatter.string(from: now)
    }
    
    func alertWithTF(viewController: UIViewController, time: Int, lat: Double, lng: Double, gameType: String) {
        let alert = UIAlertController(title: "Player information", message: "Please enter your name", preferredStyle: UIAlertController.Style.alert)
        let save = UIAlertAction(title: "Save", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            if textField.text != "" {
                self.name = textField.text!
            } else {
                self.name = ""
            }
            let saveFinishTime = self.timeFormatted(time)
            self.savePlayerInformation(timeFinished: saveFinishTime, lat: lat, lng: lng, gameType: gameType)
        }
        alert.addTextField { (textField) in
            textField.placeholder = "name"
            textField.textColor = .red
        }
        alert.addAction(save)
        viewController.present(alert, animated:true, completion: nil)
    }
    
    
    func savePlayerInformation(timeFinished:String, lat:Double, lng: Double, gameType: String) {
        self.player = Player(name: self.name!, date: getCurrentDate(), timeToFinish:timeFinished, lat: lat, lng: lng, gameType: gameType)
        self.player.printPlayer()
        getPlayerCounter()
        savePlayerInLocalStorage(player: self.player!)
        TopPlayers.playersCounter += 1
        savePlayerCounter()
    }


    func savePlayerInLocalStorage(player : Player) {
             let encoder = JSONEncoder()
                 encoder.outputFormatting = .prettyPrinted
                 let data = try! encoder.encode(player)
                 let jsonString: String = String(data: data, encoding: .utf8)!
        UserDefaults.standard.set(jsonString, forKey: "PL_\(TopPlayers.playersCounter)")
          }
         
         func savePlayerCounter() {
            UserDefaults.standard.set(TopPlayers.playersCounter, forKey: "PLAYER_COUNTER")
         }
         
         func getPlayerCounter() {
             TopPlayers.playersCounter = UserDefaults.standard.integer(forKey: "PLAYER_COUNTER")
         }
    
    // Time Format
     func timeFormatted(_ totalSeconds: Int) -> String {
         let seconds: Int = totalSeconds % 60
         let minutes: Int = (totalSeconds / 60) % 60
         return String(format: "%02d:%02d", minutes, seconds)
     }

    
}
