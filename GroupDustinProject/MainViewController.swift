//
//  ViewController.swift
//  GroupDustinProject
//
//  Created by Heather Bishop on 4/7/26.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func goToWorkout(_ sender: Any)
    {
        performSegue(withIdentifier: "showWorkout", sender: self)
    }
    
    @IBAction func goToCalorie(_ sender: Any)
    {
        performSegue(withIdentifier: "showCalorie", sender: self)
    }
    
    @IBAction func goToWeight(_ sender: Any)
    {
        performSegue(withIdentifier: "showWeight", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

