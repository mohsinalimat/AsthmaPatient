//
//  ViewController.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 20/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import UIKit
import Reusable

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var patients: [Patient]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private let service = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        
        tableView.delegate = self
        tableView.dataSource = self
        service.getPatients { [weak self] result in
            self?.patients = result
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PatientTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        if let patient = self.patients?[indexPath.row] { cell.setup(with: patient) }
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedPatient = patients?[indexPath.row] else { return }
        let newVC = PatientViewController.instantiate()
        newVC.patient = selectedPatient
        navigationController?.pushViewController(newVC, animated: true)
    }
}

