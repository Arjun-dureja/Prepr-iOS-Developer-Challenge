//
//  CreateLabViewController.swift
//  Arjun_Dureja_iOS_Developer_PreprChallenge
//
//  Created by Arjun Dureja on 2020-05-09.
//  Copyright © 2020 Arjun Dureja. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

protocol CreateLabViewControllerDelegate {
    // Tell delegate that the user has finished creating a lab, sends them the lab and an optional index
    func finishedCreatingLab(lab: Lab, indexPath: IndexPath?)
}

class CreateLabViewController: UITableViewController {
    // Properties to create a new lab
    var lab = Lab(name: "", locationName: "", latitude: 0, longitude: 0, date: "")
    var delegate: CreateLabViewControllerDelegate!
    var index: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Styling
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        
        // Set title based on if its a new lab or the user is editing an existing lab
        if let _ = index {
            title = "‏‏‎Edit Lab"
        } else {
            title = "‏‏‎‏‏‎Create Lab"
        }
        
        tableView.backgroundColor = UIColor.white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.customGreen
        navigationItem.leftBarButtonItem?.tintColor = UIColor.customGreen
        
    }
    
    @objc func saveTapped() {
        // Handle save
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CreateLabCell else { return }
        lab.name = cell.nameField.text!
        
        // Confirms the user has entered all required info
        if lab.name.isEmpty || lab.locationName.isEmpty {
            let ac = UIAlertController(title: "Error", message: "Please fill out all details", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        // Tells the delegate to create the lab
        delegate?.finishedCreatingLab(lab: lab, indexPath: index)
        popViewController()
    }
    
    @objc func cancelTapped() {
        popViewController()
    }
    
    func popViewController() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromBottom
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "createLab") as? CreateLabCell else {
            fatalError("Unable to dequeue cell")
        }
        cell.delegate = self
        
        // Styling
        cell.nameField.text = lab.name
        cell.locationField.text = lab.locationName
        cell.nameField.attributedPlaceholder = NSAttributedString(string: "Enter Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        cell.locationField.attributedPlaceholder = NSAttributedString(string: "Tap to Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        return cell
    }
    
    
    func locationTapped() {
        // Opens Google Places autocomplete controller
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }

}

extension CreateLabViewController: CreateLabCellDelgate {
    func didTapLocation(name: String?) {
        self.lab.name = name!
        self.locationTapped()
    }
}

extension CreateLabViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    // When the user finishes selecting a location, all values are assigned
    guard let placeName = place.name else { return }
    self.lab.locationName = placeName
    self.lab.latitude = Double(place.coordinate.latitude)
    self.lab.longitude = Double(place.coordinate.longitude)
    
    let date = DateFormatter()
    date.dateFormat = "MM/dd/yyyy"
    self.lab.date = date.string(from: Date())
    
    tableView.reloadData()
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
