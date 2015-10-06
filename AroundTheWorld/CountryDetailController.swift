//
//  CountryDetailController.swift
//  AroundTheWorld
//
//  Created by Ky Nguyen on 9/25/15.
//  Copyright © 2015 Ky Nguyen. All rights reserved.
//

import UIKit

class CountryDetailController: UITableViewController {

    var country: Country?
    
    @IBOutlet weak var capital: UILabel!
    
    @IBOutlet weak var subRegion: UILabel!
    
    @IBOutlet weak var area: UILabel!
    
    @IBOutlet weak var population: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

    func loadData() {
        
        capital.text = country?.capital
        subRegion.text = country?.subRegion

        area.text = "\(formatNumber((country!.area!))) km2"
        population.text = formatNumber(country!.population!)
        
        title = country?.name
    }
    
    func formatNumber(number: Double) -> String {
        
        let nf = NSNumberFormatter()
        nf.groupingSeparator = " "
        nf.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return nf.stringFromNumber(number)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

  
    
    
    
}
