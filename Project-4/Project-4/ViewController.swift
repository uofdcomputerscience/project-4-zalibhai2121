//
//  ViewController.swift
//  Project-4
//
//  Created by Zainab Alibhai on 12/13/19.
//  Copyright © 2019 Zainab Alibhai. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class ViewController: UIViewController {

    @IBOutlet weak var Calendar: UIButton!
    var store: EKEventStore?
    
    @IBAction func CalendarEvent(_ sender: Any) {
    store = EKEventStore()
    store?.requestAccess(to: .event, completion: { (didAllow, error) in
        guard didAllow else { return }
        let event = EKEvent(eventStore: self.store!)
        event.startDate = Date().addingTimeInterval(24*60*60)
        event.endDate = event.startDate.addingTimeInterval(30*60)
        event.title = "Something to do for class"
        DispatchQueue.main.async {
            let vc = EKEventEditViewController()
            vc.event = event
            vc.eventStore = self.store
            //vc.delegate = self as? UINavigationControllerDelegate
           // vc.editViewDelegate = self
            self.present(vc, animated: true)
            }
        })
    }

}

