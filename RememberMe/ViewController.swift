import UIKit

class ViewController: UIViewController {

    let itemCollection = ["SquareRed", "SquareGreen", "SquareBlue",
                            "CircleRed", "CircleGreen", "CircleBlue",
                            "TriagleRed", "TriagleGreen", "TriagleBlue"]
    
    var max:UInt32 = 12
    
    var count:Int = 0
    
    var _currentIndex = 0
    var _previousIndex = 0
    
    var _score = 0

    let interval = 0.015
    let maxTime = 100
    var timer = NSTimer()
    var _timerCount = 0
    
    @IBOutlet weak var answerContainer: UIView!
    
    @IBOutlet weak var wrongButton: UIButton!
    
    @IBOutlet weak var rightButton: UIButton!
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var score: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startTouch(sender: AnyObject) {
        
        next()
        _currentIndex = selectRandomIndex()
        
        _score = 0
        score.text = String(0)

        rightButton.alpha = 0.0
        rightButton.center.y += 50
        
        wrongButton.alpha = 0.0
        wrongButton.center.y += 50
        
        UIView.animateWithDuration(0.5) { () -> Void in
            
            self.rightButton.center.y -= 50
            self.rightButton.alpha = 1.0
            
            self.wrongButton.alpha = 1.0
            self.wrongButton.center.y -= 50
        }
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.startButton.transform = CGAffineTransformMakeScale(5, 5)
            self.startButton.alpha = 0.0
        }
        
        animateChangeImage()
    }
    
    func hideImage() {
        
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.image.center.x -= 200
            self.image.alpha = 0.0
            
            }, completion: nil)
    }
    
    func showImage() {
        
        image.center.x = 400
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.image.center.x = self.view.center.x
            self.image.alpha = 1.0
            
            let img = UIImage(named: self.itemCollection[self._currentIndex])
            self.image.image = img
        }
    }
    
    func animateChangeImage() {
        
//        hideImage()
        showImage()
    }
    
    @IBAction func yesTouch(sender: AnyObject) {
        
        if checkMatch() == true {
            
            chooseRight()
        }
        else {
            
            chooseWrong()
        }
    }
    
    
    @IBAction func noTouch(sender: AnyObject) {

        if checkMatch() == false {
            
            chooseRight()
        }
        else {
            
            chooseWrong()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        count = itemCollection.count
        
        rightButton.alpha = 0.0
        wrongButton.alpha = 0.0
        
        startButton.alpha = 0.0
        startButton.center.y += 50
        
        image.alpha = 0.0
        image.center.y += 50
        
        UIView.animateWithDuration(0.3) { () -> Void in
            
            self.image.alpha = 1.0
            self.image.center.y -= 50
        }
        
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.startButton.alpha = 1.0
            self.startButton.center.y -= 50
            
            }, completion: nil)
    }

    func chooseRight() {
        
        next()
        animateChangeImage()
        _score++
        score.text = String(_score)
    }
    
    func chooseWrong() {
        
        end()
    }
    
    // random algorithm
    func next() {
        
        _previousIndex = _currentIndex
        _currentIndex = selectRandomIndex()
        
        startTimer()
    }

    func selectRandomIndex() -> Int {
        
        let random = Int(arc4random_uniform(max))
        
        if (random > count - 1) {
            
            return _currentIndex
        }
        
        return Int(random)
    }

    
    func startTimer() {
        
        timer.invalidate()
        _timerCount = maxTime
        timer = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: Selector("countDown"), userInfo: nil, repeats: true)
    }
    
    func countDown() {
        
        _timerCount--
        
        if _timerCount <= 0 {
            
            chooseWrong()
            progressView.progress = 0
            return
        }
        
        progressView.progress = Float(_timerCount) / 100
    }
    
    func end() {
        
        timer.invalidate()
        showResultAlert("Oops", message: "You scored: \(_score)")
        
//        rightButton.hidden = true
//        wrongButton.hidden = true
//        startButton.hidden = false
        
        startButton.alpha = 0.0
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.startButton.alpha = 1.0
            self.startButton.transform = CGAffineTransformMakeScale(1, 1)
        }
        
        UIView.animateWithDuration(0.25, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
                self.rightButton.alpha = 0.0
                self.wrongButton.alpha = 0.0
                
                self.rightButton.center.y += 50
                self.wrongButton.center.y += 50
                
            }) { (Bool) -> Void in
                
                self.rightButton.center.y -= 50
                self.wrongButton.center.y -= 50
        }
        
        
    }
    
    func reset() {
        
        _score = 0
        score.text = String(_score)
    }
    
    func checkMatch() -> Bool {
        
        if _previousIndex == _currentIndex {
            
            return true
        }
        else {
            return false
        }
    }
    
    func startProgress() {
        
        progressView.progress = Float(_timerCount)
    }

    func showResultAlert(title:String, message: String) {
        
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        showAlert(title, message: message, action: action)
    }
    
    func showAlert(title:String, message:String, action: UIAlertAction) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }


}

