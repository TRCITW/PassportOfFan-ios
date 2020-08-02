//
//  EventInfoController.swift
//  FanPassport
//
//  Created by Vadim on 29.12.2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit
import GoogleMaps

class EventInfoController: BaseViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventPlaceLabel: UILabel!
    @IBOutlet weak var eventInfoLabel: UILabel!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var eventButton: RedRoundedButton!
    
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var hLabel: UILabel!
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    
    
    
    let locationManager = GlobalConstants.locationManager
    var actionTimer = GlobalConstants.actionTimer
    var counter = 0
    let geoCoder = CLGeocoder()
    var map: GMSMapView!
    var region: CLCircularRegion!
    var events = [Action]()
    var event = Action()
    
    var showButton = true {
        didSet {
            eventButton.isHidden = showButton
            timerStackView.isHidden = !showButton
            if showButton, let seconds = event.totaltime {
                counter = seconds
                hLabel.text = "\(seconds / 3600)"
                mLabel.text = "\((seconds % 3600) / 60)"
                sLabel.text = "\((seconds % 3600) % 60)"
            } else {
                hLabel.text = "0"
                mLabel.text = "0"
                sLabel.text = "0"
            }
        }
    }
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringVisits ()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            if let radius = event.radius, let lat = event.lat, let lon = event.lon {
            locationManager.distanceFilter = Double(radius)
                region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), radius: CLLocationDistance(radius), identifier: event.name ?? "")
            }
            locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func UISettings() {
        title = "Мероприятие"
        timerStackView.isHidden = true
        eventImageView.image = UIImage()
        if let imgName = event.avatar {
            GlobalConstants.apiService.setImageInCache(imageName: imgName) { result in
                self.eventImageView.image = GlobalConstants.apiService.getImageFromCache(imageName: imgName)
            }
        }
        
        let date = Date.init(timeIntervalSince1970: TimeInterval(Double(event.startdate ?? "0")!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        eventDateLabel.text = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "HH:mm"
        let startTime = dateFormatter.string(from: date)
        let dateEnd = Date.init(timeIntervalSince1970: TimeInterval(Double(event.enddate ?? "0")!))
        let endTime = dateFormatter.string(from: dateEnd)
        eventTimeLabel.text = startTime + " - " + endTime
        
        eventNameLabel.text = event.name
        eventInfoLabel.text = event.descr
             
        if dateEnd < Date() {
            if let seconds = event.totaltime {
                self.show(title: "Мероприятие завершилось", message: "Общее время пребывания на мероприятии составило: \(seconds / 3600) час : \((seconds % 3600) / 60) мин : \((seconds % 3600) % 60) сек")
            }
            showButton = false
        } else if (event.getStarted ?? false) && (event.totaltime ?? 0) > 0 {
            showButton = false
        } else {
            showButton = true
        }
        
        
        let camera = GMSCameraPosition.camera(withLatitude: event.lat ?? 0, longitude: event.lon ?? 0, zoom: 6.0)
        map = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.addSubview(map)
        map.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            map.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            map.topAnchor.constraint(equalTo: mapView.topAnchor),
            map.bottomAnchor.constraint(equalTo: mapView.bottomAnchor)
        ])
        
       
    }
    
    @IBAction func eventButtonAction(_ sender: Any) {
        let dist = locationManager.location?.distance(from: CLLocation(latitude: event.lat ?? 0, longitude: event.lon ?? 0))
        if let radius = event.radius, radius >= Int(dist ?? 0) {
            startTimer()
        } else {
            self.show(title: "Несовпадение локаций", message: "Вы находитесь не в радиусе мероприятия", buttonText: "Назад")
        }
    }
    
    override func alertClose() {
        super.alertClose()
    }
    
    @objc func timerAction() {
        counter += 1
        hLabel.text = "\(counter / 3600)"
        mLabel.text = "\((counter % 3600) / 60)"
        sLabel.text = "\((counter % 3600) % 60)"
    }

    func startTimer() {
        if !actionTimer.isValid {
            counter = event.totaltime ?? 0
            actionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            event.isSented = false
        }
        eventButton.isHidden = true
        timerStackView.isHidden = false
    }
}

extension EventInfoController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let camera = GMSCameraPosition.camera(withLatitude: locValue.latitude,
                                              longitude: locValue.longitude,
                                              zoom: 5)
        map.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        startTimer()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        actionTimer.invalidate()
        event.totaltime = counter
        self.show(title: "Вы покинули мероприятие", message: "Таймер остановлен. Для возобновления - вернитесь в зону мероприятия.", buttonText: "Ясно")
        guard GlobalConstants.apiService.isInternetAvailable(vc: self) else { return }
        GlobalConstants.apiService.postAddTime(idaction: event.id ?? 0, totaltime: counter) { result, error in
            if result {
                print("Time for \(self.event.name ?? "") is sented!")
                self.event.isSented = true
                for (index, item) in self.events.enumerated() {
                    if item.id == self.event.id {
                       self.events[index] = self.event
                    }
                }
                UserDefaults.standard.set(self.events, forKey: UserKeys.actions)
                UserDefaults.standard.synchronize()
            } else if let error = error {
                print(error)
                self.show(title: NSLocalizedString("Get users list failed", comment: ""), error: error)
            }
        }
    }
    
}
