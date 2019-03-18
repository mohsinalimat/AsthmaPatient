//
//  BLTNNewPatientItem.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 04/03/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation
import UIKit
import BLTNBoard

protocol BLTNNewPatientItemDelegate {
    func create(newPatient:[String:Any])
}

class BLTNNewPatientItem: BLTNPageItem {
    
    var delegate: BLTNNewPatientItemDelegate?
    
    enum Sex: Int {
        case male = 1
        case female = 2
        
        var asString: String {
            get {
                switch self {
                case .male:
                    return "Мужской"
                case .female:
                    return "Женский"
                }
            }
        }
    }
    var firstName: UITextField!
    var lastName: UITextField!
    var sex: UITextField!
    var dateOfBirth: UITextField!
    var selectedSex = Sex.male
    
    private var sexData = [Sex.male.asString, Sex.female.asString]
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        firstName = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
        firstName.placeholder = "Имя"
        
        lastName = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
        lastName.placeholder = "Фамилия"
        
        sex = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
        sex.placeholder = "Пол"
        let sexPicker = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 160.0))
        sexPicker.delegate = self
        sexPicker.dataSource = self
        sex.inputView = sexPicker
        
        dateOfBirth = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
        dateOfBirth.placeholder = "Дата рождения"

        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerHasChanged(_:)), for: .valueChanged)
        datePicker.maximumDate = Date()
        dateOfBirth.inputView = datePicker
        
        let views: [UIView]
        views = [firstName, lastName, sex, dateOfBirth]
        return views
    }
    
    @objc func datePickerHasChanged(_ picker: UIDatePicker) {
        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "yyyy-MM-dd"
        let dateStr = df.string(from: picker.date)
        dateOfBirth.text = dateStr
    }
    
    override func actionButtonTapped(sender: UIButton) {
        super.actionButtonTapped(sender: sender)

        let df = DateFormatter()
        df.locale = Locale.current
        df.dateFormat = "yyyy-MM-dd"
        
        var data = [String : Any]()
        data["FirstName"] = firstName.text
        data["LastName"] = lastName.text
        data["GenderType"] = selectedSex.rawValue
        data["BirthDate"] = dateOfBirth.text
        
        delegate?.create(newPatient: data)
    }
}

extension BLTNNewPatientItem: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sexData[row]
    }

    //MARK: Not working
    func pickerView( pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }
}

extension BLTNNewPatientItem: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(integerLiteral: 44)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sex.text = sexData[row]
        selectedSex = sex.text == "Мужской" ? .male : .female
    }
}
