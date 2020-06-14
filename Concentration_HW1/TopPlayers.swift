//
//  TopPlayers.swift
//  Concentration_HW1
//
//  Created by user167535 on 5/26/20.
//  Copyright © 2020 user167535. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Navigation

class TopPlayers: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var playersList: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    var players : [Player] = []
    var playersSorted : [String] = []
    public static var playersCounter : Int = 0
    var winners : [Player] = []
    let cellReuseIdentifier = "player_cell"
    var curPlayer : Player?
    var x : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playersList.delegate = self
        playersList.dataSource = self
        getPlayerCounter()
        getPlayersFromLocalStorage()
 
        
        for i in players {
            i.printPlayer()
        }
    }
    
    func getPlayersFromLocalStorage() {
        for x in 0..<TopPlayers.playersCounter {
        
            let playerJson = UserDefaults.standard.string(forKey: "PL_\(x)")
         
            if let safePlayerJson = playerJson {
                let decoder = JSONDecoder()
                let data = Data(safePlayerJson.utf8)
                do {
                    self.curPlayer = try decoder.decode(Player.self, from: data)
               
                    players.append(self.curPlayer!)
                    playersSorted.append((self.curPlayer?.gameTime)!)
                    setupList()
                } catch {}
            }
        }
     //   let sa = players.sorted { players[$0].}
        let sortedArray = playersSorted.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    
      
        for i in 0..<sortedArray.count {
            print ("\(i)   \(sortedArray[i])")
            for t in 0..<sortedArray.count {
                if(sortedArray[i] == players[t].gameTime) {
                    winners.append(players[t])
                    players.remove(at: t)
                    break
                }
            }
        }

        }
    
     
func savePlayersInLocalStorage(player : Player) {
        let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try! encoder.encode(player)
            let jsonString: String = String(data: data, encoding: .utf8)!
            UserDefaults.standard.set(jsonString, forKey: "X")
     }
    
    func savePlayerCounter() {
        UserDefaults.standard.set(TopPlayers.playersCounter, forKey: "PLAYER_COUNTER")

    }
    
    func getPlayerCounter() {
        TopPlayers.playersCounter = UserDefaults.standard.integer(forKey: "PLAYER_COUNTER")
    }
    
    func setupList() {
          playersList.delegate = self
          playersList.dataSource = self
          playersList.reloadData()
      }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (winners.count < 10) {
            return winners.count
        } else {
            return 10
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MyCustomCell? = self.playersList.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? MyCustomCell
        cell?.cellNameLabel?.text = winners[indexPath.row].name
        cell?.cellDateLabel?.text = winners[indexPath.row].date
        cell?.cellTimeLabel?.text = winners[indexPath.row].gameTime
        cell?.cellGameTypeLabel?.text = winners[indexPath.row].gameType
        if (cell == nil) {
            cell = MyCustomCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellReuseIdentifier)
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: winners[indexPath.row].lat , longitude: winners[indexPath.row].lng)
        annotation.subtitle = "game of ..."
            mapView.addAnnotation(annotation)

         
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
    }
}
