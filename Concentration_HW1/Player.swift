//
//  Player.swift
//  Concentration_HW1
//
//  Created by user167535 on 5/26/20.
//  Copyright © 2020 user167535. All rights reserved.
//

import Foundation

class Player : Codable{
    var name : String?
    var gameTime : String?
    var date : String?
    var lat : Double = 0
    var lng : Double = 0
    var gameType : String?
    let key : String = "playerKey"
    var winners: [Player] = []
    
    init () {
        
    }
    
    init(name : String, date : String, timeToFinish : String, lat : Double, lng : Double, gameType: String) {
        self.name = name
        self.gameTime = timeToFinish
        self.date = date
        self.lat = lat
        self.lng = lng
        self.gameType = gameType
    }
    
     func addPlayer(player: Player) {
          winners = listPlayers()
          winners.append(player)
          UserDefaults.standard.set(winners, forKey: key)
      }
      
      func listPlayers() -> Array<Player> {
          let data = UserDefaults.standard.object(forKey: key)
          if data != nil {
              return data as! Array<Player>
          }
          return []
      }
      
      func deletePlayer(index: Int) {
          winners = listPlayers()
          winners.remove(at: index)
          UserDefaults.standard.set(winners, forKey: key)
      }
    
    func printPlayer() {
        print("name: \(name) date: \(date) time: \(gameTime) lat: \(lat) lng: \(lng) gameType: \(gameType)" )
    }

}
