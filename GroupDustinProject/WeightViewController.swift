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
        "Monday-Weight:",
        "Tuesday-Weight:",
        "Wednesday-Weight:",
        "Thursday-Weight:",
        "Friday-Weight:",
        "Saturday-Weight:",
        "Sunday-Weight:"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.sectionHeaderTopPadding = 12
    }


}

extension WeightViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = weekDays[indexPath.row]

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
