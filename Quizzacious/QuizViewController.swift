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
    
    var currentQuestion: Int = 0
    var currentAnswer: String = String()
    
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
    
    func configureView() {
        if let detail = detailItem {
            if let label = questionLabel {
                label.text = detail[currentQuestion].question.htmlToString
            }
            if let label2 = questionNameLabel {
                label2.text = "Question \(currentQuestion + 1)"
            }
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //if (pickerView == answerPicker) {
            return detailItem![currentQuestion].incorrect_answers[row]
        //}
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == answerPicker) {
            currentAnswer = "Fake Answer"
        }
    }
    
}
