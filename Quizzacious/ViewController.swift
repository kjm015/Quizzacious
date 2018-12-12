//
//  ViewController.swift
//  Quizzacious
//
//  Created by Kevin Miyata on 11/20/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var difficultyPickerView: UIPickerView!
    @IBOutlet weak var startButton: UIButton!
    
    let apiUrl = "https://opentdb.com/api.php?amount=10&type=multiple"
    let categoriesUrl = "https://opentdb.com/api_category.php"
    
    var questions: [Question] = [Question]()
    var categories: [QuizCategory] = [QuizCategory]()
    var difficulties: [(key: String, value: String)] = [(String, String)]()
    
    var quizCategory: Int = 0
    var quizDifficulty: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        difficulties = [("Easy", "easy"), ("Medium", "medium"), ("Hard", "hard")]
        getCategories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Detail" {
            let controller = segue.destination as! QuizViewController
            
            // Set properties of controller as needed to pass objects
            controller.detailItem = questions
        }
    }
    
    func getCategories () {
        var newCategories = [QuizCategory]()
        do {
            // Try to upload jsonData
            guard let url = URL(string: categoriesUrl) else { // Perform some error handling
                print("Invalid URL string")
                return
            }
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                let httpResponse = response as? HTTPURLResponse
                if httpResponse!.statusCode == 404 {
                    DispatchQueue.main.async {
                        self.presentAlert(title: "Failed", message: ("Could not retrieve categories"))
                    }
                } else if httpResponse!.statusCode != 200 {
                    // Perform some error handling
                    print("Unexpected http response")
                    DispatchQueue.main.async {
                        self.presentAlert(title: "Failed", message: ("Unexpected http response"))
                    }
                } else if (data == nil && error != nil) {
                    // Perform some error handling
                    print(error!.localizedDescription)
                    DispatchQueue.main.async {
                        self.presentAlert(title: "Failed", message: (error!.localizedDescription))
                    }
                } else {
                    // Download succeeded, decode JSON into User object // and perform segue to DetailViewController
                    do {
                        let jsonString = String(data: data!, encoding: String.Encoding.utf8)
                        print(jsonString!)
                        let getCategoriesData = try JSONDecoder().decode(CategoryData.self, from: data!)
                        newCategories = getCategoriesData.trivia_categories
                        self.categories = newCategories
                        self.quizDifficulty = self.difficulties[0].value
                        self.quizCategory = self.categories[0].id
                        DispatchQueue.main.async {
                            self.categoryPickerView.reloadAllComponents()
                            self.difficultyPickerView.reloadAllComponents()
                        }
                    } catch {
                        print("Did not decode getUser data")
                    }
                }
            }
            task.resume()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == categoryPickerView) {
            return categories.count
        }
        else {
            return difficulties.count
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView == categoryPickerView) {
            return categories[row].name
        } else {
            return difficulties[row].key
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == categoryPickerView) {
            quizCategory = categories[row].id
        } else {
            quizDifficulty = difficulties[row].value
        }
    }
    
    func getQuestions (url: String) {
        do {
            // Try to upload jsonData
            guard let url = URL(string: url) else { // Perform some error handling
                print("Invalid URL string")
                return
            }
            let task = URLSession.shared.dataTask(with: url) {
                (data, response, error) in
                let httpResponse = response as? HTTPURLResponse
                if httpResponse!.statusCode == 404 {
                    DispatchQueue.main.async {
                        self.presentAlert(title: "Failed", message: ("Could not retrieve questions"))
                    }
                } else if httpResponse!.statusCode != 200 {
                    // Perform some error handling
                    print("Unexpected http response")
                    DispatchQueue.main.async {
                        self.presentAlert(title: "Failed", message: ("Unexpected http response"))
                    }
                } else if (data == nil && error != nil) {
                    // Perform some error handling
                    print(error!.localizedDescription)
                    DispatchQueue.main.async {
                        self.presentAlert(title: "Failed", message: (error!.localizedDescription))
                    }
                } else {
                    // Download succeeded, decode JSON into User object // and perform segue to DetailViewController
                    do {
                        // let jsonString = String(data: data!, encoding: String.Encoding.utf8)
                        // print(jsonString!)
                        let getQuizData = try JSONDecoder().decode(Quiz.self, from: data!)
                        self.questions = getQuizData.results
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "Show Detail", sender: self)
                        }
                    } catch {
                        print("Did not decode getUser data")
                    }
                }
            }
            task.resume()
        }
    }

    @IBAction func quizStarted(_ sender: Any) {
        if (quizCategory == 0 || quizDifficulty.isEmpty) {
            self.presentAlert(title: "Failed", message: ("Choose difficulty and category"))
        } else {
            getQuestions(url: "\(apiUrl)&difficulty=\(quizDifficulty)&category=\(quizCategory)")
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

