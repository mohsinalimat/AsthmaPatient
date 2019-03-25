//
//  ViewController.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 20/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import UIKit
import Reusable
import BLTNBoard

class HomeViewController: UIViewController {
    
    //wired flex but ok
    enum ViewState {
        case empty
        case full
    }
    
    @IBOutlet private weak var tableView: UITableView!
    fileprivate let searchBar = UISearchBar()
    fileprivate var patients = [Patient]()
    fileprivate var filteredPatiens = [Patient]()
    fileprivate lazy var bulletinManager: BLTNItemManager = {
        let rootItem = BLTNNewPatientItem(title: "Добавить пациента")
        rootItem.delegate = self
        rootItem.actionButtonTitle = "Добавить"
        return BLTNItemManager(rootItem: rootItem)
    }()
    fileprivate var errorView: UIView? {
        let nib = UINib(nibName: "EmptyStateView", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? UIView else {
            return nil
        }
        return view
    }
    
    fileprivate var state: ViewState = .full {
        willSet {
            switch newValue {
            case .empty:
                tableView.isHidden = true
//                if let _ = errorView {
//                    view.addSubview(errorView!)
//                    errorView?.snp.makeConstraints({ (make) in
//                        make.centerX.centerY.equalTo(self.view)
//                    })
//                }
            case .full:
                tableView.isHidden = false
//                errorView?.removeFromSuperview()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        navigationItem.titleView = searchBar
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewPatient))
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPatients()
    }
    
    func getPatients() {
        APIPatients.getPatients { [weak self] result in
            DispatchQueue.main.async {
                guard let listOfPatient = result, let weakSelf = self else {
                    self?.state = .empty
                    return
                }
                weakSelf.patients = listOfPatient
                weakSelf.filteredPatiens = listOfPatient
                weakSelf.state = weakSelf.patients.count == 0 ? .empty : .full
                weakSelf.tableView.reloadData()
            }
        }

    }
    
    @objc func addNewPatient() {
        bulletinManager.showBulletin(above: self)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPatiens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PatientTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let patient = self.filteredPatiens[indexPath.row]
        cell.setup(with: patient)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPatient = filteredPatiens[indexPath.row]
        let newVC = PatientViewController.instantiate()
        newVC.patient = selectedPatient
        navigationController?.pushViewController(newVC, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredPatiens = patients
        } else {
            filteredPatiens = filteredPatiens.filter({ (patient) -> Bool in
                let fullName = patient.firstName + patient.lastName + (patient.middleName ?? "")
                return fullName.lowercased().contains(searchText.lowercased())
            })
        }
        tableView.reloadData()
    }
}

extension HomeViewController: BLTNNewPatientItemDelegate {
    func create(newPatient: [String : Any]) {
        bulletinManager.dismissBulletin()
        var patientData = Data()
        do {
            patientData = try JSONSerialization.data(withJSONObject: newPatient, options: .prettyPrinted)
        } catch {
            print("unable to encode patient's data")
            return
        }

        APIPatients.createPatient(data: patientData) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case true:
                weakSelf.getPatients()
                break
            case false:
                let alertView = UIAlertController(title: "Ошибка", message: "Не удалось добавить пациента, попробуйте позже", preferredStyle: .alert)
                let action = UIAlertAction(title: "Хорошо", style: UIAlertAction.Style.default, handler: { (action) in
                    alertView.dismiss(animated: true, completion: nil)
                })
                
                alertView.addAction(action)
                weakSelf.present(alertView, animated: true, completion: nil)
                break
            }
        }
    }
}
