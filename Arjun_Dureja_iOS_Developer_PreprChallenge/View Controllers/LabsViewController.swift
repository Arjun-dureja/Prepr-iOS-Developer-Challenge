//
//  LabsViewController.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-08.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import GooglePlaces

class LabsViewController: UITableViewController {

    var labs = [Lab]()
    var name: String?
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        
        title = "‎‎‎‎‎‏‏‎‏Available Labs"

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.customGreen
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.customGreen
    }
    
    @objc func addTapped() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "create") as? CreateLabViewController else { return }
        vc.delegate = self
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Lab") as? LabCell else {
            fatalError("Unable to dequeue cell")
        }
        setupCell(named: cell, at: indexPath)
        return cell
    }
    
    func setupCell(named cell: LabCell, at indexPath: IndexPath) {
        cell.backgroundColor = UIColor.customGray
        
        cell.labImage.image = UIImage(named: "lab")
        
        cell.labTitle.text = labs[indexPath.row].name
        cell.labTitle.font = UIFont.boldSystemFont(ofSize: 18)
        cell.labTitle.textColor = UIColor.white
        
        let date = DateFormatter()
        date.dateFormat = "MM/dd/yyyy"
        cell.labDate.text = "Date Added: \(date.string(from: Date()))"
        cell.labDate.font = UIFont.boldSystemFont(ofSize: 14)
        cell.labDate.textColor = UIColor.black
        
        cell.labLocation.text = "Location: \(labs[indexPath.row].locationName)"
        cell.labLocation.textColor = UIColor.black
        cell.labLocation.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "View Location", style: .default, handler: {
            [weak self] _ in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "map") as? MapViewController else { return }
            vc.lab = self?.labs[indexPath.row]
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        
        ac.addAction(UIAlertAction(title: "Edit Details", style: .default, handler:  {
            [weak self] _ in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "create") as? CreateLabViewController else { return }
            vc.delegate = self
            vc.index = indexPath
            vc.lab.name = (self?.labs[indexPath.row].name)!
            vc.lab.locationName = (self?.labs[indexPath.row].locationName)!
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.type = .push
            transition.subtype = .fromTop
            self?.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self?.navigationController?.pushViewController(vc, animated: false)
        }))
        
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            [weak self] _ in
            self?.labs.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            [weak self] _ in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }))
        
        present(ac, animated: true)
    }
}

extension LabsViewController: CreateLabViewControllerDelegate {
    func finishedCreatingLab(lab: Lab, indexPath: IndexPath?) {
        if let index = indexPath {
            labs[index.row] = lab
            tableView.reloadData()
        } else {
            labs.insert(lab, at: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
}
