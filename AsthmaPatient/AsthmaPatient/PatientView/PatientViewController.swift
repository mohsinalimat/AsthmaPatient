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

class PatientViewController: UIViewController, StoryboardSceneBased {
    
    @IBOutlet weak var tableView: UITableView!
    
    var patient: Patient?
    var states: [PatientStatus]?
    
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    private let service = APIService()
    private lazy var bulletinManager: BLTNItemManager = {
        let rootItem = BLTNNewStateItem(title: "Добавить состояние")
        rootItem.actionButtonTitle = "Добавить"
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewState))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280.0
        tableView.register(cellType: PatientStatusTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
        
        if let newPatient = patient {
            navigationItem.title = "\(newPatient.lastName) \(newPatient.firstName)"
            service.getPatientsHistory(id: newPatient.patientId, completionHandler: { [weak self] result in
                self?.states = result
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    @objc func addNewState() {
        bulletinManager.showBulletin(above: self)
    }
}

extension PatientViewController: UITableViewDelegate {
    
}

extension PatientViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PatientStatusTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let state = states?[indexPath.row] {
            cell.setupView(traitCollection.horizontalSizeClass, state: state)
        }
        
        return cell
    }
}


class BLTNNewStateItem: BLTNPageItem {
    var textFieldPEF: UITextField!
    var textFieldOPF2: UITextField!
    var switchWithTitle1: SwitchViewWithTitle!
    var switchWithTitle2: SwitchViewWithTitle!
    
//    override var actionButton: UIButton {
//        let doneButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 400.0, height: 44.0))
//        doneButton.titleLabel?.text = "Добавить"
//        return doneButton
//    }
    
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
