//
//  LabsViewController.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-08.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase
import CodableFirebase

class LabsViewController: UITableViewController {
    var labs = [Lab]()
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var uid: String!
    let db = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        
        title = "‎‎‎‎‎‏‏‎‏Available Labs"
        
        // Navigation bar buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.customGreen
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.customGreen
        
        // Get existing labs from firestore based on the user's account id
        let doc = db.collection("users").document(uid)
        
        doc.getDocument { (document, error) in
            if let document = document, document.exists {
                if let labs = document.get("labs") as? NSArray {
                    for lab in labs {
                        let labData = try! FirestoreDecoder().decode(Lab.self, from: lab as! [String : Any])
                        self.labs.append(labData)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func addTapped() {
        // Handle adding a lab
        // Presents the create lab view controller
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
        // Styles the cell and displays the desired info
        cell.backgroundColor = UIColor.customGray
        
        cell.labImage.image = UIImage(named: "lab")
        
        cell.labTitle.text = labs[indexPath.row].name
        cell.labTitle.font = UIFont.boldSystemFont(ofSize: 18)
        cell.labTitle.textColor = UIColor.white
        
        cell.labDate.text = "Date Added: \(labs[indexPath.row].date)"
        cell.labDate.font = UIFont.boldSystemFont(ofSize: 14)
        cell.labDate.textColor = UIColor.black
        
        cell.labLocation.text = "Location: \(labs[indexPath.row].locationName)"
        cell.labLocation.textColor = UIColor.black
        cell.labLocation.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection
        // Shows an action sheet for the user to choose from
        let ac = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        
        // View location button, displays the location as a google maps query in a new view controller
        ac.addAction(UIAlertAction(title: "View Location", style: .default, handler: {
            [weak self] _ in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "map") as? MapViewController else { return }
            vc.lab = self?.labs[indexPath.row]
            self?.navigationController?.pushViewController(vc, animated: true)
        }))
        
        // Edit details button, allows the user to change any information they want
        ac.addAction(UIAlertAction(title: "Edit Details", style: .default, handler:  {
            [weak self] _ in
            guard let vc = self?.storyboard?.instantiateViewController(withIdentifier: "create") as? CreateLabViewController else { return }
            
            // Sends all the information to the create lab view controller
            vc.delegate = self
            vc.index = indexPath // Index that needs to be edited
            vc.lab.name = (self?.labs[indexPath.row].name)!
            vc.lab.locationName = (self?.labs[indexPath.row].locationName)!
            vc.lab.date = (self?.labs[indexPath.row].date)!
            vc.lab.longitude = (self?.labs[indexPath.row].longitude)!
            vc.lab.latitude = (self?.labs[indexPath.row].latitude)!
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            transition.type = .push
            transition.subtype = .fromTop
            self?.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self?.navigationController?.pushViewController(vc, animated: false)
        }))
        
        // Delete button, allows the user to delete a lab and updates the firestore database
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {
            [weak self] _ in
            self?.labs.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Update database
            self?.db.collection("users").document(self!.uid).setData(["labs": []])
            for lab in self!.labs {
                let labData = try! FirestoreEncoder().encode(lab)
                self?.db.collection("users").document(self!.uid).updateData(["labs": FieldValue.arrayUnion([labData])])
            }
        }))
        
        // Cancel button
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            [weak self] _ in
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }))
        
        present(ac, animated: true)
    }
}

extension LabsViewController: CreateLabViewControllerDelegate {
    // Protocol method - gets called when user finishes creating a lab
    func finishedCreatingLab(lab: Lab, indexPath: IndexPath?) {
        // Checks if there is an index, if there is, then the user has edited a lab
        if let index = indexPath {
            labs[index.row] = lab
            
            // Update database
            db.collection("users").document(uid).setData(["labs": []])
            for lab in labs {
                let labData = try! FirestoreEncoder().encode(lab)
                db.collection("users").document(uid).updateData(["labs": FieldValue.arrayUnion([labData])])
            }
            tableView.reloadData()
        } else {
            // If no index, then this is a new lab
            labs.insert(lab, at: 0)
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            
            // Update database
            let labData = try! FirestoreEncoder().encode(lab)
 
            db.collection("users").document(uid).updateData(["labs": FieldValue.arrayUnion([labData])])
        }
    }
}
