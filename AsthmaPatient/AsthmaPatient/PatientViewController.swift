//
//  PatientViewController.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 23/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import UIKit
import Reusable

class PatientViewController: UIViewController, StoryboardSceneBased {
    
    @IBOutlet weak var tableView: UITableView!
    
    var patient: Patient?
    var statuses: [PatientStatus]?
    
    static var sceneStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    private let service = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let newPatient = patient {
            navigationItem.title = "\(newPatient.lastName) \(newPatient.firstName)"
            service.getPatientsHistory(id: newPatient.patientId, completionHandler: { [weak self] result in
                self?.statuses = result
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        }
    }
}

extension PatientViewController: UITableViewDelegate {
    
}

extension PatientViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PatientStatusTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
}
