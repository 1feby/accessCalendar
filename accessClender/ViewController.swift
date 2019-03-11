//
//  ViewController.swift
//  accessClender
//
//  Created by phoebe on 3/10/19.
//  Copyright © 2019 phoebe. All rights reserved.
//

import UIKit
import EventKit
class ViewController: UIViewController {
     let eventStore : EKEventStore = EKEventStore()
   lazy var evet : EKEvent = EKEvent(eventStore: eventStore);
    var events: [EKEvent]?
    var calendars: [EKCalendar]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func loadEvents(_ sender: UIButton) {
        
    }
    
    @IBAction func AddEvent(_ sender: UIButton) {
       
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil ){
                print("granted\(granted)")
                
                self.evet.title = "Add event lololololoy"
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                let startDateTime = formatter.date(from: "2019/03/15 05:00");
                self.evet.startDate = startDateTime
                let endDateTime = formatter.date(from: "2019/03/16 05:35");
                self.evet.endDate = endDateTime
               // let alaram = EKAlarm(relativeOffset: 0)
              //  evet.alarms = [alaram]
                self.evet.addAlarm(.init(relativeOffset: -5*60))
                self.evet.notes = "This is note"
                self.evet.calendar = self.eventStore.defaultCalendarForNewEvents
                do{
                    try self.eventStore.save(self.evet, span: .thisEvent)
                }catch let error as NSError{
                    let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(OKAction)
                    
                    self.present(alert, animated: true, completion: nil)
                }
                print("Save Event")
            }else{
                print ("error is \(error)")
            }
        }
        
    }
    @IBAction func removeEvent(_ sender: UIButton) {
        // Create a date formatter instance to use for converting a string to a date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        self.calendars = eventStore.calendars(for: EKEntityType.event)
        // Create start and end date NSDate instances to build a predicate for which events to select
        let startDate = dateFormatter.date(from: "2019/03/15 04:00")
        let endDate = dateFormatter.date(from: "2019/03/17 20:00")
        let prediacte = eventStore.predicateForEvents(withStart: startDate!, end: endDate!, calendars: calendars!)
        self.events = eventStore.events(matching: prediacte)
        for i in events! {
            deleteEntry(event: i)
        }
            }
    func deleteEntry(event : EKEvent){
        do{
            try eventStore.remove(event, span: EKSpan.thisEvent, commit: true)
            
        }catch{
            print("Error while deleting event: \(error.localizedDescription)")
        }
    }
}

