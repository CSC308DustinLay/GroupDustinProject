//
//  CalorieViewController.swift
//  GroupDustinProject
//
//  Created by Heather Bishop on 4/9/26.
//

import UIKit

class CalorieViewController: UIViewController
{
    @IBOutlet weak var consumedCalorieTF: UITextField!
    @IBOutlet weak var burnedCalorieLabel: UILabel!
    @IBOutlet weak var netCalorieLabel: UILabel!
    
    @IBAction func calcNetCalorie(_ sender: Any)
    {
        // Get consumed calories
        guard let consumedText = consumedCalorieTF.text,
              let consumedCalories = Int(consumedText) else { return }
        
        // Get burned calories text
        guard let burnedText = burnedCalorieLabel.text else { return }
        
        // Extract digits
        let digits = burnedText.filter { $0.isNumber }
        
        // If no valid number → show alert
        guard let burnedCalories = Int(digits) else {
            let alert = UIAlertController(
                title: "Missing Workout Data",
                message: "Please visit the workout section before calculating net calories.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Calculate net
        let netCalories = consumedCalories - burnedCalories
        
        // Display result
        netCalorieLabel.text = "\(netCalories) Calories"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        consumedCalorieTF.delegate = self
        
        let savedCalorieBurned = UserDefaults.standard.double(forKey: "caloriesBurned")
        burnedCalorieLabel.text = "Net Calories: \(Int(savedCalorieBurned))"
    }
}

extension CalorieViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // Allow backspace
        if string.isEmpty { return true }
        
        // Limit to numbers only
        let allowedCharacters = CharacterSet.decimalDigits
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        
        // Limit length
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 4
    }
}
