//
//  WorkoutViewController.swift
//  GroupDustinProject
//
//  Created by Heather Bishop on 4/13/26.
//

import UIKit

class WorkoutViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var curWeightLabel: UILabel!
    //Cardio Stuff
    @IBOutlet weak var cardioStepper: UIStepper!
    @IBOutlet weak var cardioIntenLabel: UILabel!
    @IBOutlet weak var cardioTimeTF: UITextField!
    @IBAction func cardioStepperChanged(_ sender: Any)
    {
        cardioIntenLabel.text = "Intensity: \(Int(cardioStepper.value))"
    }
    //Squat Stuff
    @IBOutlet weak var squatStepper: UIStepper!
    @IBOutlet weak var squatIntenLabel: UILabel!
    @IBOutlet weak var squatTimeTF: UITextField!
    @IBAction func squatStepperChanged(_ sender: Any)
    {
        squatIntenLabel.text = "Intensity: \(Int(squatStepper.value))"
    }
    //Bench Stuff
    @IBOutlet weak var benchStepper: UIStepper!
    @IBOutlet weak var benchIntenLabel: UILabel!
    @IBOutlet weak var benchTimeTF: UITextField!
    @IBAction func benchStepperChanged(_ sender: Any)
    {
        benchIntenLabel.text = "Intensity: \(Int(benchStepper.value))"
    }
    
    //Calculation stuff
    @IBOutlet weak var netCalorieLabel: UILabel!
    @IBAction func calculateNetCalorie(_ sender: Any)
    {
        let cardioMin = Double(cardioTimeTF.text ?? "") ?? 0
        let squatMin  = Double(squatTimeTF.text ?? "") ?? 0
        let benchMin  = Double(benchTimeTF.text ?? "") ?? 0
        
        let cardioCal = cardioCalories(minutes: cardioMin, met: Double(cardioStepper.value))
        let squatCal  = squatCalories(minutes: squatMin,  met: Double(squatStepper.value))
        let benchCal = benchCalories(minutes: benchMin,  met: Double(benchStepper.value))
        
        netCalorieLabel.text = "Net Calories: \(Int(cardioCal + squatCal + benchCal))"
        
        savedCalories = cardioCal + squatCal + benchCal
        
        UserDefaults.standard.set(savedCalories, forKey: "caloriesBurned")
    }
    
    var savedCalories: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardioTimeTF.delegate = self
        squatTimeTF.delegate = self
        benchTimeTF.delegate = self
        
        if let savedWeights = UserDefaults.standard.array(forKey: "weightsData") as? [[String]]
        {
            var latestWeight: String?
            
            for week in savedWeights.reversed()
            {
                for day in week.reversed()
                {
                    if !day.isEmpty
                    {
                        latestWeight = day
                        break
                    }
                }
                
                if latestWeight != nil { break }
            }
            if let latestWeight = latestWeight { curWeightLabel.text = "Current weight: \(latestWeight)" }
            else { curWeightLabel.text = "No weight logged"}
        }
        else{
            curWeightLabel.text = "No weight logged"
        }
    }
    
    func lbsToKG() -> Double
    {
        guard let text = curWeightLabel.text else { return 0.0 }
        let components = text.components(separatedBy: " ")
        
        guard let weightString = components.last, let weightLBS = Double(weightString) else { return 0.0 }
        
        return weightLBS / 2.20462
    }
    
    
    func cardioCalories(minutes: Double, met: Double) -> Double
    {
        let weightKG = lbsToKG()
        
        return met * weightKG * (minutes/60)
    }
    
    func benchCalories(minutes: Double, met: Double) -> Double
    {
        let weightKG = lbsToKG()
        
        return met * weightKG * (minutes/60)
    }
    
    func squatCalories(minutes: Double, met: Double) -> Double
    {
        let weightKG = lbsToKG()
        
        return met * weightKG * (minutes/60)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Allow backspace
        if string.isEmpty {
            return true
        }
        
        // 1. Only allow numbers
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) {
            return false
        }
        
        // 2. Limit to 3 characters
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return updatedText.count <= 3
    }
}
