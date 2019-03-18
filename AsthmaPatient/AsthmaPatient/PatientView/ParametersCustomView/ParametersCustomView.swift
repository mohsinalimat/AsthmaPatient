//
//  ParametersCustomView.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 04/03/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation
import UIKit
import Reusable

class ParametersCustomView: UIView, NibLoadable {
    @IBOutlet weak var pefValueLabel: UILabel!
    @IBOutlet weak var opf2ValueLabel: UILabel!
    @IBOutlet weak var hospitalizedSwitch: UISwitch!
    @IBOutlet weak var hasCoughSwitch: UISwitch!
}
