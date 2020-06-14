import UIKit

class HardGame: UIViewController {
    // MARK: - IBOutlets & vars
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var labelFinishedGame: UILabel!
    @IBOutlet weak var labelMovesCounter: UILabel!
    @IBOutlet weak var labelTimer: UILabel!
    @IBOutlet weak var labelNumOfPairsMatched: UILabel!
    
    var lat : Double?
    var lng : Double?
    private var cardsArray = [Card]()
    private var numOfPairs: Int!
    private var rememberLastIdCard: Int?
    private var previouslySeenCards: [Int:Int]!
    private var movesCounter : Double = 0
    private var isGameOver = false
    private var imagesArray = [#imageLiteral(resourceName: "card_5"),#imageLiteral(resourceName: "card_6"),#imageLiteral(resourceName: "card_2"),#imageLiteral(resourceName: "card_8"),#imageLiteral(resourceName: "card_4"),#imageLiteral(resourceName: "card_1"),#imageLiteral(resourceName: "card_7"),#imageLiteral(resourceName: "card_3"),#imageLiteral(resourceName: "botanical"),#imageLiteral(resourceName: "btn")]
    var timer: Timer?
    var time: Int = 0
   
    // MARK: - Game logic

    override func viewDidLoad() {
        super.viewDidLoad()
        numOfPairs = (cardButtons.count + 1) / 2
        let gameLogic = GameLogic()
        cardsArray = gameLogic.divideImagesBetweenCards(numOfPairs: numOfPairs)
        updateCardDisplay()
        updateLabelsDisplay()
        resetTimer()
    }
    
    @IBAction func newGame(_ sender: Any) {
        movesCounter=0
        Card.resetCardIds()
        cardsArray.removeAll()
        let gameLogic = GameLogic()
        cardsArray = gameLogic.divideImagesBetweenCards(numOfPairs: numOfPairs)
        updateCardDisplay()
        labelMovesCounter.text="Moves : 0"
        labelNumOfPairsMatched.text = "\t\t  0 / \(numOfPairs!)"
        labelFinishedGame.text=""
        isGameOver=false
        timer?.invalidate()
        resetTimer()
        releaseCardsWhenGameStarted()
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
    
    func blockedCardsWhenGameOver(){
        for card in cardButtons {
            card.isEnabled=false
        }
    }
    
    func releaseCardsWhenGameStarted() {
        for card in cardButtons {
            card.isEnabled=true
        }
    }
    
    func updateLabelsDisplay(){
        let gameLogic = GameLogic()
        labelMovesCounter.text = "Moves: \(Int(movesCounter))"
        labelNumOfPairsMatched.text = "\t\t  \(gameLogic.checkHowMuchCardsMatched(cards: cardsArray)/2) / \(numOfPairs!)"
        if isGameOver{
            labelFinishedGame.text="GAME OVER!"
            blockedCardsWhenGameOver()
            timer?.invalidate()
            gameLogic.alertWithTF(viewController: self, time: (time-1), lat: self.lat ?? 0, lng: self.lng ?? 0,  gameType: "Hard")
            
            for index in cardButtons.indices{
                cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        } else {
            labelFinishedGame.text=""
        }
    }
    
    @IBAction func cardClicked(_ sender: UIButton) {
        let gameLogic = GameLogic()
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
            if gameLogic.checkHowMuchCardsMatched(cards: cardsArray)==cardsArray.count {
                self.isGameOver = true
            }
        }
        updateCardDisplay()
        updateLabelsDisplay()
    }
    
    // MARK: - Timer
    
    private func resetTimer() {
        self.time = 0
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(changeTimerLabel), userInfo: nil, repeats: true)
    }
    
    @objc func changeTimerLabel() {
        let gameLogic = GameLogic()
        self.labelTimer.text = ("Timer: \(gameLogic.timeFormatted(self.time))") // will show timer
        if time >= 0 {
            time += 1
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                labelFinishedGame.text="GAME OVER!"
                blockedCardsWhenGameOver()
            }
        }
    }
    
    // MARK: - Back to home page
    
    @IBAction func backToMainPage(_ sender: Any) {
        self.performSegue(withIdentifier: "fromHardToMain", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromHardToMain") {
            _ = segue.destination as! FirstPage
        }
    }
}
