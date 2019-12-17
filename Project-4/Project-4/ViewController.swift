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
import FSCalendar

class ViewController: UIViewController, UICollectionViewDelegate {
    
    fileprivate weak var calendar: FSCalendar!

    var store: EKEventStore?
    
    let Months = ["January","February","March","April","May","June","July","August","September","October","November","December"]
    let DaysofMonths = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    let DaysinMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    var currentMonth = String()
    
    
    override func viewDidLoad() {
        self.viewDidLoad()
        // In loadView or viewDidLoad
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        self.calendar = calendar
        
        calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 250).isActive = false
        calendar.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = false
//        currentMonth = Months[month]
//
//        MonthLabel.text = "\(currentMonth), \(year)"
    }
    
    
    
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
//
//extension ViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return DaysinMonth.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionView
//        cell.backgroundColor = UIColor.clear
//        cell.DateLabel.text = "\(indexPath.row + 1)"
//        return cell
//
//    }
//}

extension ViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
        return cell
    }
}
