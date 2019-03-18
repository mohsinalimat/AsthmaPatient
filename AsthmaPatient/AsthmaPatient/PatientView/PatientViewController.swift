//
//  PatientViewController.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 23/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import UIKit
import Reusable
import BLTNBoard
import SnapKit
import MagazineLayout

class PatientViewController: UIViewController, StoryboardSceneBased {
    
    var patient: Patient?
    var states: [PatientStatus]?
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MagazineLayout())
    
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    private let service = APIService()
    private lazy var bulletinManager: BLTNItemManager = {
        let rootItem = BLTNNewStateItem(title: "Добавить состояние")
        rootItem.actionButtonTitle = "Добавить"
        rootItem.delegate = self
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewState))
        view.addSubview(collectionView)
        collectionView.register(cellType: PatientStatusCollectionViewCell.self)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        collectionView.layoutIfNeeded()
        
        collectionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let newPatient = patient {
            navigationItem.title = "\(newPatient.lastName) \(newPatient.firstName)"
            service.getPatientsHistory(id: newPatient.patientId, completionHandler: { [weak self] result in
                self?.states = result
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            })
        }
    }
    
    @objc func addNewState() {
        bulletinManager.showBulletin(above: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionView.reloadData()
    }
}

extension PatientViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return states?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PatientStatusCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if let state = states?[indexPath.row] {
            cell.setupView(traitCollection.horizontalSizeClass, state: state)
        }
        cell.layer.cornerRadius = 15.0
        cell.clipsToBounds = true
        return cell
    }
}

extension PatientViewController: UICollectionViewDelegateMagazineLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeModeForItemAt indexPath: IndexPath) -> MagazineLayoutItemSizeMode {
        let widthMode = MagazineLayoutItemWidthMode.fullWidth(respectsHorizontalInsets: true)
        let heightMode = MagazineLayoutItemHeightMode.dynamic
        return MagazineLayoutItemSizeMode(widthMode: widthMode, heightMode: heightMode)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForHeaderInSectionAtIndex index: Int) -> MagazineLayoutHeaderVisibilityMode {
        return .visible(heightMode: .dynamic)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, visibilityModeForBackgroundInSectionAtIndex index: Int) -> MagazineLayoutBackgroundVisibilityMode {
        return .hidden
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, horizontalSpacingForItemsInSectionAtIndex index: Int) -> CGFloat {
        return  12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, verticalSpacingForElementsInSectionAtIndex index: Int) -> CGFloat {
        return  12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetsForItemsInSectionAtIndex index: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 24, right: 12)
    }
}

extension PatientViewController: BLTNNewStateItemDelegate {
    func create(newStateData: Data) {
        bulletinManager.dismissBulletin()
        guard let patientID = patient?.patientId else {
            return
        }
        
        let intVal = NSNumber(value: patientID).stringValue
        service.createPatientStatus(using: newStateData, patientId: intVal) {[weak self] (result) -> (Void) in
            self?.service.getPatientsHistory(id: patientID, completionHandler: { (result) -> (Void) in
                DispatchQueue.main.async {
                    self?.states = result
                    self?.collectionView.reloadData()
                }
            })
        }
    }
}

protocol BLTNNewStateItemDelegate {
    func create(newStateData: Data)
}

class BLTNNewStateItem: BLTNPageItem {
    var textFieldPEF: UITextField!
    var textFieldOPF2: UITextField!
    var switchWithTitle1: SwitchViewWithTitle!
    var switchWithTitle2: SwitchViewWithTitle!
    
    var delegate: BLTNNewStateItemDelegate?
    
    lazy var hospitalizedView: UIView = {
       let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
        let titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
        return view
    }()
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textFieldPEF = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
        textFieldPEF.placeholder = "PEF"
        textFieldPEF.keyboardType = .decimalPad
        
        textFieldOPF2 = UITextField(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
        textFieldOPF2.placeholder = "OPF2"
        textFieldOPF2.keyboardType = .decimalPad
        
        switchWithTitle1 = SwitchViewWithTitle(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0),
                                              title: "Госпитолизирован")
        
        switchWithTitle2 = SwitchViewWithTitle(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0),
                                              title: "Есть кашель")
        
        let views: [UIView]
        views = [textFieldPEF, textFieldOPF2, switchWithTitle1, switchWithTitle2]
        return views
    }
    
    override func actionButtonTapped(sender: UIButton) {
        let formatter = NumberFormatter()
        
        let data = ["pef": textFieldPEF.text,
                    "spO2" : textFieldOPF2.text,
                    "isHospitalized" : switchWithTitle1.state,
                    "isWheezing" : switchWithTitle2.state] as [String : Any]
        let newSymptom = ["parameters": data]
        do {
            let dict = try JSONSerialization.data(withJSONObject: newSymptom, options: .prettyPrinted)
            delegate?.create(newStateData: dict)
        } catch {
            
        }
    }
}

class SwitchViewWithTitle: UIView {
    private var switcher: UISwitch
    private var titleLabel: UILabel
    
    var state: Bool {
        get {
            return switcher.isOn
        }
    }
    
    init(frame: CGRect, title: String) {
        switcher = UISwitch(frame: CGRect(x: 0.0, y: 0.0, width: 88.0, height: 44.0))
        switcher.isOn = false
        titleLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 88.0, height: 44.0))
        titleLabel.text = title
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(switcher)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(self.frame.width).multipliedBy(0.8)
        }
        
        switcher.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
            make.width.equalTo(self.frame.width).multipliedBy(0.2)
        }
    }
}
