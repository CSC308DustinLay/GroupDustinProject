//
//  ViewController.swift
//  GroupDustinProject
//
//  Created by Heather Bishop on 4/7/26.
//

import UIKit

class WeightViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    
    let weekDays = [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
    ]
    
    // 3 weeks × 7 days, initially empty strings
    var weights: [[String]] = [
        Array(repeating: "", count: 7),
        Array(repeating: "", count: 7),
        Array(repeating: "", count: 7)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderTopPadding = 12
        
        // Load saved weights from the iphone
        if let savedWeights = UserDefaults.standard.array(forKey: "weightsData") as? [[String]] {
            weights = savedWeights
        }
    }
    
    // Optional safety: save before leaving VC
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //Basically saves the data in the iphone
        UserDefaults.standard.set(weights, forKey: "weightsData")
    }
}

extension WeightViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return weights.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let day = weekDays[indexPath.row]
        let weight = weights[indexPath.section][indexPath.row]

        if weight.isEmpty {
            cell.textLabel?.text = "\(day)-Weight:"
        } else {
            cell.textLabel?.text = "\(day)-Weight: \(weight)lbs"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Week 1"
        case 1: return "Week 2"
        case 2: return "Week 3"
        default: return nil
        }
    }
}

extension WeightViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Enter Weight", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter weight"
            textField.keyboardType = .numberPad
            textField.delegate = self
            // Pre-fill with existing weight if available
            let existing = self.weights[indexPath.section][indexPath.row]
            if !existing.isEmpty {
                textField.text = existing
            }
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self.weights[indexPath.section][indexPath.row] = text
                UserDefaults.standard.set(self.weights, forKey: "weightsData") // Save immediately
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension WeightViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Allow backspace
        if string.isEmpty { return true }
        
        // Only allow digits
        let allowedCharacters = CharacterSet.decimalDigits
        if string.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return false
        }
        
        // Limit length to 3 digits
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 3
    }
}
