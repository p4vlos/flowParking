//
//  RecentDataController.swift
//  FlowParking
//
//  Created by Pavlos Nicolaou on 26/03/2017.
//  Copyright © 2017 Pavlos Nicolaou. All rights reserved.
//

import UIKit

class RecentDataController: UIViewController {

    @IBOutlet weak var dataTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dataTxtView.text = ViewController.message
    }

    @IBAction func shareBtnPressed(_ sender: Any) {
        let sheet = UIActivityViewController(
            activityItems: [ViewController.message],
            applicationActivities: nil)
        self.present(sheet, animated: true, completion: nil)
    }
    
    
    
}
