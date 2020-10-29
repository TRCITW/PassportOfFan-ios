//
//  EventsController.swift
//  FanPassport
//
//  Created by Vadim on 26.12.2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

enum FilterType {
    case all, sport, NHL
}

class EventsController: BaseViewController {
    
    @IBOutlet weak var filter1Button: EventsFilterButton!
    @IBOutlet weak var filter2Button: EventsFilterButton!
    @IBOutlet weak var filter3Button: EventsFilterButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var eventInfoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventInfoController") as! EventInfoController
    let emptyView = EmptyView()
    var items = [Action]() {
        didSet {
            itemsFiltered = items
            itemsfilter1.removeAll()
            itemsfilter2.removeAll()
            for elem in self.items {
                elem.mtype == 0 ? itemsfilter1.append(elem) : itemsfilter2.append(elem)
            }
        }
    }
    var itemsfilter1 = [Action]()
    var itemsfilter2 = [Action]()
    var itemsFiltered = [Action]()
    var itemsSorted: [[Action]] = [[Action](), [Action](), [Action]()]
    var headers = ["СЕГОДНЯ", "ПРЕДСТОЯЩИЕ", "ПРОШЕДШИЕ"]
    var selectedButton = 0
    var selectedType: FilterType = .all
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.redRounded
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
        setupFilter()
        getItems()
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func UISettings() {
        title = "Список мероприятий"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = emptyView
        emptyView.isHidden = true
    }
    
    func getItems(animation: Bool = false) {
        guard GlobalConstants.apiService.isInternetAvailable(vc: self) else {
            loadSavedActions(forUpdate: false)
            return
        }
        if animation {
            showProgressHUD()
        }
        GlobalConstants.apiService.getActions() { result, data, error in
            self.hideProgressHUD()
            self.refreshControl.endRefreshing()
            if result {
                self.items = data ?? [Action]()
                self.loadSavedActions(forUpdate: true)
                self.updateTable()
            } else if let error = error {
                print(error)
                self.show(title: NSLocalizedString("Get users list failed", comment: ""), error: error)
            }
        }
    }
    
    func updateTable() {
        var today = [Action]()
        var future = [Action]()
        var other = [Action]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let nowDate = Date()
        itemsFiltered.sort { (act1, act2) -> Bool in
            return (Double(act1.startdate ?? "0") ?? 0) > (Double(act2.startdate ?? "0") ?? 0)
        }
        today = itemsFiltered.filter({ (act) -> Bool in
            let startdate = Date.init(timeIntervalSince1970: TimeInterval(Double(act.startdate ?? "0")!))
            return dateFormatter.string(from: nowDate) == dateFormatter.string(from: startdate)
        })
        
        future = itemsFiltered.filter({ (act) -> Bool in
            let startdate = Date.init(timeIntervalSince1970: TimeInterval(Double(act.startdate ?? "0")!))
            return startdate > nowDate
        })
        
        other = itemsFiltered.filter({ (act) -> Bool in
            let startdate = Date.init(timeIntervalSince1970: TimeInterval(Double(act.startdate ?? "0")!))
            return startdate < nowDate
        })
        
//        for elem in self.itemsFiltered {
//            let date = Date.init(timeIntervalSince1970: TimeInterval(Double(elem.startdate ?? "0")!))
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "dd.MM.yyyy"
//            if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) {
//                today.append(elem)
//            } else if dateFormatter.string(from: date) > dateFormatter.string(from: Date()) {
//                future.append(elem)
//            }else {
//                other.append(elem)
//            }
//        }

        if selectedType == .sport {
            today = today.filter({ $0.mtype == 1 })
            future = future.filter({ $0.mtype == 1 })
            other = other.filter({ $0.mtype == 1 })
        }else if selectedType == .NHL {
            today = today.filter({ $0.mtype != 1 })
            future = future.filter({ $0.mtype != 1 })
            other = other.filter({ $0.mtype != 1 })
        }
        
        self.itemsSorted[0] = today
        self.itemsSorted[1] = future
        self.itemsSorted[2] = other
        
        self.tableView.reloadData()
    }
    
    func setupFilter() {
        filter1Button.setTitle("Все", for: .normal)
        filter2Button.setTitle("Спартакиада - Автоспорт", for: .normal)
        filter3Button.setTitle("Ночная Хоккейная Лига", for: .normal)
        
        filter1Button.addTarget(self, action:#selector(updateFilter), for: .touchUpInside)
        filter2Button.addTarget(self, action:#selector(updateFilter), for: .touchUpInside)
        filter3Button.addTarget(self, action:#selector(updateFilter), for: .touchUpInside)
        
        filter1Button.selectedStyle(isSelected: true)
        filter2Button.selectedStyle(isSelected: false)
        filter3Button.selectedStyle(isSelected: false)
    }
    
    @objc func handleRefresh(){
        getItems(animation: false)
    }
    
    @objc func updateFilter(_ sender: EventsFilterButton) {
        if sender == filter1Button {
            filter1Button.selectedStyle(isSelected: true)
            filter2Button.selectedStyle(isSelected: false)
            filter3Button.selectedStyle(isSelected: false)
            selectedType = .all
//            itemsFiltered = items
        } else if sender == filter2Button {
            filter1Button.selectedStyle(isSelected: false)
            filter2Button.selectedStyle(isSelected: true)
            filter3Button.selectedStyle(isSelected: false)
            selectedType = .sport
//            itemsFiltered = itemsfilter1
        } else if sender == filter3Button {
            filter1Button.selectedStyle(isSelected: false)
            filter2Button.selectedStyle(isSelected: false)
            filter3Button.selectedStyle(isSelected: true)
            selectedType = .NHL
//            itemsFiltered = itemsfilter2
        }
        self.updateTable()
    }
    
    func loadSavedActions(forUpdate: Bool) {
        if let savedActions = UserDefaults.standard.array(forKey: UserKeys.actions) {
            var tempActions = [Action]()
            for elem in savedActions {
                if let dict = elem as? [String : AnyObject] {
                    tempActions.append(Action(dictionary: dict))
                }
            }
            if forUpdate {
                for item in items {
                    for tempAction in tempActions {
                        if tempAction.id == item.id {
                            item.getStarted = tempAction.getStarted
                            item.isSented = tempAction.isSented
                            item.totaltime = tempAction.totaltime
                            break
                        }
                    }
                }
                UserDefaults.standard.set(self.items, forKey: UserKeys.actions)
                UserDefaults.standard.synchronize()
            } else {
                self.items = tempActions
            }
        }
    }
}

extension EventsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        headers[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 2 ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = DefaultHeaderView()
        view.titleLabel.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        view.titleLabel.font = UIFont.SVP.regular(size: 13)
        view.titleLabel.textColor = UIColor.svpMainText
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let view = DefaultHeaderView()
            view.titleLabel.isHidden = true
            view.showButton.isHidden = false
            view.showButton.setTitle("Показать ещё", for: .normal)
            return view
        } else {
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return itemsSorted.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsSorted[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableCell", for: indexPath) as? EventsTableCell else {
            fatalError("The dequeued cell is not an instance for table.")
        }
        let obj = itemsSorted[indexPath.section][indexPath.row]
        cell.eventImage.image = UIImage()
        if let imgName = obj.avatar {
            GlobalConstants.apiService.setImageInCache(imageName: imgName) { result in
                cell.eventImage.image = GlobalConstants.apiService.getImageFromCache(imageName: imgName)
            }
        }
        
        let date = Date.init(timeIntervalSince1970: TimeInterval(Double(obj.startdate ?? "0")!))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.eventDateLabel.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "HH:mm"
        let startTime = dateFormatter.string(from: date)
        let dateEnd = Date.init(timeIntervalSince1970: TimeInterval(Double(obj.enddate ?? "0")!))
        let endTime = dateFormatter.string(from: dateEnd)
        cell.eventTimeLabel.text = startTime + " - " + endTime
        cell.eventNameLabel.text = obj.name
        cell.eventButton.indexRow = indexPath.row
        cell.eventButton.indexSection = indexPath.section
        cell.eventButton.addTarget(self, action: #selector(showEventInfo), for: .touchUpInside)
        //cell.eventPlaceLabel.text = obj.place
        
        return cell
    }
    
    @objc func showEventInfo(_ sender: EventCellButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EventInfoController") as! EventInfoController
        vc.event = itemsSorted[sender.indexSection][sender.indexRow]
        vc.events = items
        self.navigationController?.show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventInfoController.event = itemsSorted[indexPath.section][indexPath.row]
        eventInfoController.events = items
        self.navigationController?.show(eventInfoController, sender: self)
    }
    
}

class EventCellButton: UIButton {
    var indexSection: Int = 0
    var indexRow: Int = 0
}
