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

class ViewController: UIViewController {
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate weak var eventLabel: UILabel!
    var store: EKEventStore?
    var currentMonth = String()
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    private var datesRange: [Date]?
    
    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.groupTableViewBackground
        self.view = view
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        self.calendar = calendar
        calendar.allowsMultipleSelection = true
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.didMoveToSuperview()
        calendar.appearance.eventSelectionColor = UIColor.white
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 275).isActive = true
        calendar.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        calendar.scrollEnabled = true
        calendar.scrollDirection = .vertical
        calendar.isMultipleTouchEnabled = true
        view.addSubview(calendar)
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
        
        
        let label = UILabel(frame: CGRect(x: 0, y: calendar.frame.maxY + 10, width: self.view.frame.size.width, height: 50))
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        self.view.addSubview(label)
        self.eventLabel = label
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FSCalendar"
        // Uncomment this to perform an 'initial-week-scope'
        // self.calendar.scope = FSCalendarScopeWeek;
        
        let dates = [
            self.gregorian.date(byAdding: .day, value: -1, to: Date()),
            Date(),
            self.gregorian.date(byAdding: .day, value: 1, to: Date())
        ]
        dates.forEach { (date) in
            self.calendar.select(date, scrollToDate: false)
        }
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
    
        
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
            vc.cancelEditing()
            self.present(vc, animated: true)
            }
        })
    }

}
extension ViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
        return cell
    }
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        return ""
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        // in case of the "from" date is more than "to" date,
        // it should returns an empty array:
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }

        return array
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // nothing selected:
        if firstDate == nil {
            firstDate = date
            datesRange = [firstDate!]

            print("datesRange contains: \(datesRange!)")

            return
        }

        // only first date is selected:
        if firstDate != nil && lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if date <= firstDate! {
                calendar.deselect(firstDate!)
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains: \(datesRange!)")

                return
            }

            let range = datesRange(from: firstDate!, to: date)

            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range

            print("datesRange contains: \(datesRange!)")

            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []

            print("datesRange contains: \(datesRange!)")
        }
        
    }

    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // both are selected:

        // NOTE: the is a REDUANDENT CODE:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
            print("datesRange contains: \(datesRange!)")
        }
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 2
    }
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//        self.configure(cell: cell, for: date, at: position)
//    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendar.frame.size.height = bounds.height
        self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
}
