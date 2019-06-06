//
//  ThemeChooserVC.swift
//  Concentration
//
//  Created by Кирилл Афонин on 27/03/2019.
//  Copyright © 2019 krrl. All rights reserved.
//

import UIKit

class ThemeChooserVC: UIViewController {
    
    @IBAction func changeTheme(_ sender: Any) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.themeKey = themeName
                }
            }
        }
    }
}
