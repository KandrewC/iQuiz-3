//
//  FinishedViewController.swift
//  iQuiz
//
//  Created by Andrew Kan on 11/13/16.
//  Copyright © 2016 Andrew Kan. All rights reserved.
//

import UIKit

class FinishedViewController: UIViewController {

    var numCorrect: Int = 0
    var totalQuestions: Int = 0
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var finalText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let percentCorrect: Double = Double (numCorrect) / Double(totalQuestions)
        if percentCorrect == 1.0 {
            answerLabel.text = "Perfect Score!"
        } else if percentCorrect >= 0.5 {
            answerLabel.text = "Try Again! :D"
        } else {
            answerLabel.text = "Practice makes perfect! Try again!"
        }
        finalText.text = "You got \(numCorrect) out of \(totalQuestions) correct."
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
