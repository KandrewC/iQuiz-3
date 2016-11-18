//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Andrew Kan on 11/13/16.
//  Copyright © 2016 Andrew Kan. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    
    @IBOutlet weak var userAnswer: UILabel!
    @IBOutlet weak var currentQuestion: UITextView!
   
    @IBOutlet weak var finishedButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    

    
        
    var category: String = ""
//    var questionDictionary: [String : [String]] = [:]
//    var answerDictionary: [String : [[String]]] = [:]
    
    var questionDictionary = [String: [(String, String)]]()
    var answerDictionary:[String : [[String]]] = [:]

    
//    var questionList: [String: [(String, String)]] =
//        ["Mathematics": [("What is 1 + 1", "2"), ("If Johnny buys 3 packs of apples and each pack has 6 apples, how many apples does he have?", "18"), ("What is 2 - 5?", "-3")],
//         
//        "Marvel Super Heroes": [("Who can talk to dolphins?", "AquaMan"), ("Who is the fastest man alive?", "The Flash"), ("Who leads the Avengers Team?", "Captain America")],
//        
//        "Science": [("How much does gravity affect acceleration?", "9.8 m/s"), ("What is the table of elements called", "Periodic"), ("The mitochondria is the...", "Powerhouse of the cell")]]
//    
//    var answerList: [String: [[String]]] =
//        ["Mathematics": [["0", "-1000", "-1", "2"], ["64", "18", "63", "1"],  ["-2", "-3", "-4", "-5"]],
//        
//         "Marvel Super Heroes": [["The Flash", "AquaMan", "IronMan", "Hulk"], ["Dr. Strange", "Harry Potter", "The Flash", "Barry Ballin"], ["Captain America", "AquaMan", "IronMan", "Hulk"]],
//         
//         "Science": [["12.1 m/s", "9.8 ft/s", "10.2 m/s", "9.8 m/s"], ["Periodic", "Paroic", "Knowledge", "Pedantic"], ["Powerhouse of the cell", "Energy user of the Cell", "Atom", "Computer of the cell"]]]
    
    var isQuestion: Bool = true
    var numCorrect: Int  = 0
    var index: Int  = 0
    var pickedAnswer: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(questionDictionary)
        print(answerDictionary)
        pickerView.delegate = self
        pickerView.dataSource = self
        answerLabel.isHidden = true
        correctAnswerLabel.isHidden = true
        userAnswer.isHidden = true
        pickedAnswer = (answerDictionary[category]?[index][0])!
        currentQuestion.text = questionDictionary[category]?[index].0
        finishedButton.isHidden = true
        finishedButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return answerDictionary[category]![index][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedAnswer = answerDictionary[category]![index][row]
    }
    
    @IBAction func tapGo(_ sender: Any) {
       if isQuestion {
            continueButton.setTitle("Next", for: .normal)
            self.pickerView.isHidden = true
            self.answerLabel.isHidden = false
            self.correctAnswerLabel.isHidden = false
            self.userAnswer.isHidden = false
            let correctAnswer = questionDictionary[category]![index].1
            self.correctAnswerLabel.text = "The Correct Answer: \(correctAnswer)"
            userAnswer.text = "You Chose: \(pickedAnswer)"
            if pickedAnswer == correctAnswer {
                answerLabel.text = "Good Job!"
                numCorrect += 1
            } else {
                answerLabel.text = "Awh :("
            }
            index += 1
        } else if index < (questionDictionary[category]?.count)! {
            self.pickerView.isHidden = false
            self.answerLabel.isHidden = true
            self.correctAnswerLabel.isHidden = true
            self.userAnswer.isHidden = true
        
            pickedAnswer = answerDictionary[category]![index][0]
            continueButton.setTitle("Am I right?", for: .normal)
        
            currentQuestion.text = questionDictionary[category]?[index].0
            pickerView.dataSource = self
        } else {
            userAnswer.removeFromSuperview()
            answerLabel.removeFromSuperview()
            pickerView.removeFromSuperview()
            currentQuestion.removeFromSuperview()
            correctAnswerLabel.removeFromSuperview()
        
            continueButton.setTitle("Done", for: .normal)
            finishedButton.isHidden = false
            finishedButton.isEnabled = true
            continueButton.isHidden = true

        }
        isQuestion = !isQuestion
    }
     /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Finished") {
            let controller = segue.destination as! FinishedViewController
         
            controller.numCorrect = self.numCorrect
            controller.totalQuestions = index
        }
    }
    
}
