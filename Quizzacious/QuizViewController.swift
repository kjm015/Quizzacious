//
//  QuizViewController.swift
//  Quizzacious
//
//  Created by Kevin Miyata on 11/27/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import Foundation
import UIKit

class QuizViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Outlets for elements in the view controller
    @IBOutlet weak var questionNameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var answerPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    var detailItem: Question? {
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
                label.text = "\(detail.question)"
            }
            if let answers = answerPicker {
                let number = Int.random(in: 0 ..< detail.incorrect_answers.count)

            }
        }
        
    }
    
    override func viewDidLoad() {
        // pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
        
        // Connect data:
        self.answerPicker.delegate = self
        self.answerPicker.dataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
}
