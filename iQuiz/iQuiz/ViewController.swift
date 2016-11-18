//
//  ViewController.swift
//  iQuiz
//
//  Created by Andrew Kan on 11/6/16.
//  Copyright © 2016 Andrew Kan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var settings: UIButton!
    
    @IBOutlet var tableView: UITableView!
    let textCellIdentifier = "quizCell"
   // let categories = ["Mathematics", "Marvel Super Heroes", "Science"]


    var urlString =  "https://tednewardsandbox.site44.com/questions.json"

    var categories: [String] = []
    var descriptions: [String] = []
    var questions = [String: [(String, String)]]()
    var answers = [String: [[String]]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadQuestions(url: urlString)
        self.tableView.delegate = self
        self.tableView.dataSource = self
       // tableView.delegate = self
        //tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadQuestions(url: String) {
        
        let urlString: URL = URL(string: url)!
        let userDefaults = UserDefaults.standard

        let task = URLSession.shared.dataTask(with: urlString) { (data, response, error) in
            if error != nil {
//                if let savedQuestions = userDefaults.dictionary(forKey: "questions") as? [String : [(String, String)]] {
//                    self.questions = savedQuestions
//                }
                
                if let savedAnswers = userDefaults.dictionary(forKey: "subjectQuestionsDict") as? [String : [[String]]] {
                    self.answers = savedAnswers
                }
            } else {
//                DispatchQueue.main.async{

                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as? [[String: Any]]
                    
                    for jsonData in json! {
                        
                        let title = jsonData["title"]! as! String
                        
                        if let questionList = jsonData["questions"] as? [[String:Any]] {
                            var tempQuestions: [(String,String)] = []
                            var tempAnswers: [[String]] = []
                            for part in questionList {
                                var tempArray = part["answers"]! as! [String]
                                let answerIndex = Int(part["answer"]! as! String)!
                                tempQuestions.append((part["text"]! as! String, tempArray[answerIndex - 1]))
                                tempAnswers.append(tempArray)
                            }
                            self.questions[title] = tempQuestions
                            self.answers[title] = tempAnswers
                        }
                        self.categories.append(title)
                        self.descriptions.append(jsonData["desc"]! as! String)
                        //this line breaks the code
                      //  userDefaults.setValue(self.questions, forKey: "questions")
                        userDefaults.setValue(self.answers, forKey: "answers")
                        self.tableView.reloadData()

                    }
                   

                } catch {
                    print("Error with Json: \(error)")
                }
            }

        }
//        }
        task.resume()
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        sleep(1) //having trouble with async
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath as IndexPath)
        cell.textLabel?.text = categories[indexPath.item]
        cell.detailTextLabel?.text = descriptions[indexPath.item]

        var image = UIImage(named: "")
        switch categories[indexPath.item] {
        case "Mathematics":
            image = UIImage(named: "math");
        case "Marvel Super Heroes":
            image = UIImage(named: "marvel");
        default:
            image = UIImage(named: "science");
        }
        cell.imageView?.image = image
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return cell
    }
    
    func tableView(_ tableView : UITableView,  titleForHeaderInSection section: Int)->String? {
        return "Quizzes"
    }
    
    
   
    @IBAction func settings(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Settings", message: "Use a different url for different quizzes!", preferredStyle: .alert)
        
        // Add text field
        alertController.addTextField { (textField) in
            textField.attributedPlaceholder = NSAttributedString(string:"Choose different quiz!", attributes:[NSForegroundColorAttributeName: UIColor.gray])
        }
        
        alertController.addAction(UIAlertAction(title: "Check Now", style: .default, handler: { (_) in
            self.urlString = alertController.textFields![0].text!
            self.loadQuestions(url: self.urlString)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegue(withIdentifier: "questionScene", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "questionScene") {
            
            let controller = segue.destination as! QuestionViewController
            let currentPath = self.tableView.indexPathForSelectedRow!
            let quizCategory = categories[currentPath[1]]
            controller.category = quizCategory
            controller.questionDictionary = questions
            controller.answerDictionary = answers
        }
    }
    
}
