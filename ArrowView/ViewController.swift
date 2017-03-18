//
//  ViewController.swift
//  ArrowView
//
//  Created by Guy Umbright on 3/14/17.
//  Copyright © 2017 Guy Umbright. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var hArrow: UIXArrowView!
    @IBOutlet weak var vArrow: UIXArrowView!
    @IBOutlet weak var bentArrow: UIXArrowView!
    @IBOutlet weak var vBentArrow: UIXArrowView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        hArrow.startCorner = .bottomRight
        hArrow.endCorner = .bottomLeft
        hArrow.tintColor = UIColor.green
        
        vArrow.startCorner = .topRight
        vArrow.endCorner = .bottomRight
        vArrow.tintColor = UIColor.darkGray
        
        bentArrow.startCorner = .topRight
        bentArrow.endCorner = .bottomLeft
        bentArrow.tintColor = UIColor.orange
        
        vBentArrow.startCorner = .topRight
        vBentArrow.endCorner = .bottomLeft
        vBentArrow.bendType = .verticalFirst
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

