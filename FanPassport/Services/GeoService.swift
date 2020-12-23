//
//  GeoService.swift
//  FanPassport
//
//  Created by tox on 10/31/20.
//  Copyright © 2020 yorich. All rights reserved.
//

import UIKit
import CoreLocation

enum WatchedEventStatus {
    case none, started, pause, end
}

class WatchedEvent {
    var event: Action? = nil
    var timer: Timer? = nil
    var status = WatchedEventStatus.none
}

class GeoService: NSObject {
    static let shared = GeoService()
    let locationManager = GlobalConstants.locationManager
    private var eventsLists = [WatchedEvent]()
    var actionHandler: ((WatchedEvent)->())?
    var sentHandler: ((Bool, String?)->())?
    override init() {
        super.init()
        self.first()
    }
    
    private func first(){
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringVisits ()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
        }
    }
    
    func checkIsWatched(event: Action) -> Bool{
        if let temp = eventsLists.filter({$0.event?.id == event.id }).first, temp.status == .started {
            return true
        }
        return false
    }
    
    func starWatch(event: Action) {
        var item: WatchedEvent!
        if let temp = eventsLists.filter({$0.event?.id == event.id }).first {
            item = temp
            item.timer?.invalidate()
            item.timer = nil
        }else{
            item = WatchedEvent()
            item.event = event
            eventsLists.append(item)
        }
        item.status = .started
        item.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {[weak self] timer in
            self?.timerAction(item: item)
            self?.actionHandler?(item)
            if item.status == .end {
                timer.invalidate()
                item.timer?.invalidate()
            }
        })
    }
    
    private func timerAction(item: WatchedEvent){
        if(item.status == .started) {
            item.event?.totaltime = (item.event?.totaltime ?? 0) + 1
        }
        let dist = locationManager.location?.distance(from: CLLocation(latitude: item.event?.lat ?? 0, longitude: item.event?.lon ?? 0))
        if let radius = item.event?.radius, radius < Int(dist ?? 0) {
            item.status = .pause
        }else{
            item.status = .started
        }
        let dateEnd = Date.init(timeIntervalSince1970: TimeInterval(Double(item.event?.enddate ?? "0")!))
        if dateEnd < Date() {
            item.status = .end
            self.sendTimeEndEvent(item: item)
        }
    }
    
    private func sendTimeEndEvent(item: WatchedEvent){
        guard let eventId = item.event?.id, let total = item.event?.totaltime else { return }
        GlobalConstants.apiService.postAddTime(idaction: eventId, totaltime: total) { result, error in
            if result {
                self.sentHandler?(true, nil)
            } else if let error = error {
                print(error)
                if let messages = error.messages, messages.count > 0 {
                    self.sentHandler?(true, messages[0].text)
                }else{
                    self.sentHandler?(true, "Ошибка отправки")
                }
            }
        }
    }
    
}
