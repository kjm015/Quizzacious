//
//  QuizViewController.swift
//  Quizzacious
//
//  Created by Kevin Miyata on 11/27/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

class QuizViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets for elements in the view controller
    @IBOutlet weak var questionNameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var answerPicker: UIPickerView!
    
    @IBOutlet var questionLabel2: UILabel!
    var currentQuestion: Int = 0
    var score: Int = 0
    var userAnswer: String = String()
    
    var pickerData: [String] = [String]()
    
    var detailItem: [Question]? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count //(detailItem?.incorrect_answers.count)! + 1
    }
    
    
    @IBAction func submitAnswer(_ sender: Any) {
        if (!userAnswer.isEmpty) {
            if let detail = detailItem {
                if (detail[currentQuestion].correct_answer.htmlToString == userAnswer) {
                    score += 1
                    presentAlert(title: "Correct", message: "\(detail[currentQuestion].question.htmlToString): \"\(detail[currentQuestion].correct_answer.htmlToString)\"")
                } else {
                    presentAlert(title: "Incorrect", message: "\(detail[currentQuestion].question.htmlToString): \"\(detail[currentQuestion].correct_answer.htmlToString)\"")
                }
                currentQuestion += 1
                if (currentQuestion == detail.count) {
                    //presentAlert(title: "Score", message: "\(score) / \(detail.count)")
                    print("Quiz finished")
                }
                else if (currentQuestion < detail.count) {
                    configureView()
                }
            }
        }
        else {
            presentAlert(title: "Choose", message: "Pick an answer")
        }
    }
    
    func configureView() {
        if let detail = detailItem {
            if let label = questionLabel {
                //String.replacingOccurrences(of: "", with: "")
                label.text = detail[currentQuestion].question.htmlToString
            }
            
            //questionLabel2.text = detail[currentQuestion].question
//            questionNameLabel.text = "Question \(currentQuestion)"
            print("This is the Quiz View Controller contents")
            print(detail[currentQuestion].question)
        }
    }
    
    override func viewDidLoad() {
        // Connect data:
        self.answerPicker.delegate = self
        self.answerPicker.dataSource = self
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureView()
        
    }
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
