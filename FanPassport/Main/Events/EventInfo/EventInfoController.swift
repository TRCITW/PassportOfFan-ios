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
    @IBOutlet weak var mapView: GMSMapView!
    var cirlce: GMSCircle!
    @IBOutlet weak var eventButton: RedRoundedButton!
    
    @IBOutlet weak var timerStackView: UIStackView!
    @IBOutlet weak var hLabel: UILabel!
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    private var alertShowed = 0
    
//    let locationManager = GlobalConstants.locationManager
//    var actionTimer = GlobalConstants.actionTimer
    var counter = 0
    let geoCoder = CLGeocoder()
//    var region: CLCircularRegion!
    var events = [Action]()
    var event = Action()
//    var counting = false
    var eventStarted = false
    private var localTimer = Timer()
    
    var showButton = true {
        didSet {
            eventButton.isHidden = !showButton
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

    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
        
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startMonitoringVisits ()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            if let radius = event.radius, let lat = event.lat, let lon = event.lon {
//            locationManager.distanceFilter = Double(radius)
//                region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), radius: CLLocationDistance(radius), identifier: event.name ?? "")
//            }
//            locationManager.requestAlwaysAuthorization()
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//            locationManager.allowsBackgroundLocationUpdates = true
//        }
        
        let camera = GMSCameraPosition.camera(withLatitude: event.lat ?? 0, longitude: event.lon ?? 0, zoom: 14.0)
        mapView.animate(to: camera)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        if let radius = event.radius {
            cirlce = GMSCircle(position: camera.target, radius: CLLocationDistance(radius))
            cirlce.fillColor = UIButton().titleLabel?.tintColor.withAlphaComponent(0.2)
            cirlce.map = mapView
        }
        
        eventPlaceLabel.text = ""
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2D(latitude: event.lat ?? 0, longitude: event.lon ?? 0)
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
              }
            self.eventPlaceLabel.text = lines.joined(separator: "\n")
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
        if GeoService.shared.checkIsWatched(event: event) {
            startWatching()
            eventButton.isHidden = true
            timerStackView.isHidden = false
        }
    }
    
    private func startWatching(){
        GeoService.shared.starWatch(event: event)
        GeoService.shared.actionHandler = { [weak self] item in
            print(item.status)
            guard let self = self else { return }
            let counter = item.event?.totaltime ?? 0
            self.hLabel.text = "\(counter / 3600)"
            self.mLabel.text = "\((counter % 3600) / 60)"
            self.sLabel.text = "\((counter % 3600) % 60)"
            if item.status == .end {
                let seconds = item.event?.totaltime ?? 0
                self.show(title: "Мероприятие завершилось", message: "Общее время пребывания на мероприятии составило: \(seconds / 3600) час : \((seconds % 3600) / 60) мин : \((seconds % 3600) % 60) сек")
                self.showButton = false
            }else if item.status == .pause {
                if self.alertShowed == 2 { return }
                self.show(title: "Вы покинули мероприятие", message: "Таймер остановлен. Для возобновления - вернитесь в зону мероприятия.", buttonText: "Ясно")
                self.alertShowed = 1
            }else{
                self.alertClose()
            }
        }
        GeoService.shared.sentHandler = { [weak self] status, error in
            guard let self = self else { return }
            if status {
                self.event.isSented = true
                for (index, item) in self.events.enumerated() {
                    if item.id == self.event.id {
                       self.events[index] = self.event
                    }
                }
//                UserDefaults.standard.set(self.events, forKey: UserKeys.actions)
                UserDefaults.standard.synchronize()
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadRating"), object: nil)
            }else{
                self.show(title: NSLocalizedString("Get users list failed", comment: ""), error: ResponseError(dictionary: [:]))
            }
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
        
        print("lat ", event.lat)
        print("lon ", event.lon)
        event.startdate = "\("20:04 20.10.2020".toDate(format: "HH:mm dd.MM.yyyy")!.timeIntervalSince1970)"
        event.enddate = "\("21:10 27.12.2020".toDate(format: "HH:mm dd.MM.yyyy")!.timeIntervalSince1970)"
        
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
        
        if date > Date() {
            print("рано")
            showButton = false
            localTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
                if date < Date() && !(self?.eventStarted ?? false) {
                    self?.showButton = true
                    timer.invalidate()
                }
            })
        }else{
            if dateEnd < Date() {
//                let seconds = event.totaltime ?? 0
//                self.show(title: "Мероприятие завершилось", message: "Общее время пребывания на мероприятии составило: \(seconds / 3600) час : \((seconds % 3600) / 60) мин : \((seconds % 3600) % 60) сек")
                showButton = false
            } else if (event.getStarted ?? false) && (event.totaltime ?? 0) > 0 {
                showButton = false
            } else {
                showButton = true
            }
        }
        
    }
    
    @IBAction func eventButtonAction(_ sender: Any) {
        let dist = GeoService.shared.locationManager.location?.distance(from: CLLocation(latitude: event.lat ?? 0, longitude: event.lon ?? 0))
        if let radius = event.radius, radius >= Int(dist ?? 0) {
            startTimer()
            eventStarted = true
        } else {
            self.show(title: "Несовпадение локаций", message: "Вы находитесь не в радиусе мероприятия", buttonText: "Назад")
        }
    }
    
    override func alertClose() {
        super.alertClose()
        if alertShowed == 1 {
            alertShowed = 2
        }
    }
    
    func startTimer() {
        startWatching()
        eventButton.isHidden = true
        timerStackView.isHidden = false
    }

}

extension EventInfoController: GMSMapViewDelegate {
    
}

extension EventInfoController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {

    }
    
}
