//
//  RatingController.swift
//  GameOfMinds
//
//  Created by Vadim on 01/10/2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

class RatingController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let emptyView = EmptyView()
    var items = [[Rating]]()
    var headers = ["ЛИДЕРЫ", "МОЙ РЕЙТИНГ"]
    private var myPlace: Int = 0
    private let ownId = Int(UserDefaults.standard.string(forKey: UserKeys.id) ?? "0") ?? 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        refreshControl.tintColor = UIColor.redRounded
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
        getItems()
        NotificationCenter.default.addObserver(self, selector: #selector(getItems), name: Notification.Name(rawValue: "reloadRating"), object: nil)
        tableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func UISettings() {
        title = "Рейтинг"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = emptyView
        emptyView.isHidden = true
    }
    
    @objc
    func handleRefresh(){
        getItems()
    }
    
    @objc
    func getItems() {
        print(#function)
        guard GlobalConstants.apiService.isInternetAvailable(vc: self) else { return }
        showProgressHUD()
       
        GlobalConstants.apiService.getRatings() { [weak self] result, data, error in
            self?.refreshControl.endRefreshing()
            self?.hideProgressHUD()
            guard let self = self else {return}
            if result, var users = data {
                self.items.removeAll()
                if let first = users.firstIndex(where: { $0.idfun == self.ownId }) {
                    let user = users[first]
//                    users.remove(at: first)
                    self.items.append(users.sorted(by: { ($0.totaltime ?? 0) > ($1.totaltime ?? 0) }))
                    self.items.append([user])
                }else{
                    self.items.append(users.sorted(by: { ($0.totaltime ?? 0) > ($1.totaltime ?? 0) }))
                }
                self.tableView.reloadData()
            } else if let error = error {
                print(error)
                self.show(title: NSLocalizedString("Get users list failed", comment: ""), error: error)
            }
        }
    }
}

extension RatingController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        headers[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = DefaultHeaderView()
        view.titleLabel.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        view.titleLabel.font = UIFont.SVP.regular(size: 13)
        view.titleLabel.textColor = UIColor.svpMainText
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RatingTableCell", for: indexPath) as? RatingTableCell else {
            fatalError("The dequeued cell is not an instance for table.")
        }
        let obj = items[indexPath.section][indexPath.row]
        cell.avatarImage.image = UIImage()
        if let imgName = obj.avatar, imgName != "http://portal.autoimport62.ru" {
            cell.initialsLabel.isHidden = true
            GlobalConstants.apiService.setImageInCache(imageName: imgName) { result in
                cell.avatarImage.image = GlobalConstants.apiService.getImageFromCache(imageName: imgName)
            }
        } else {
            cell.initialsLabel.text = (String(obj.secondname?.first ?? "X") + String(obj.name?.first ?? "X"))
            cell.initialsLabel.isHidden = false
            cell.avatarImage.backgroundColor = .lightGray
        }
        let sname = obj.secondname == nil ? "" : (obj.secondname! + " ")
        let name = obj.name == nil ? "" : (obj.name! + " ")
        let lname = obj.lastname == nil ? "" : (obj.lastname! + " ")
        cell.nameLabel.text = lname + name + sname
        
        if obj.idfun == ownId {
            if myPlace == 0 {
               myPlace = indexPath.row + 1
            }
            cell.medalImage.isHidden = myPlace > 2 ? true : false
            cell.placeLabel.text = "\(myPlace) место"
        }else{
           cell.placeLabel.text = "\(indexPath.row + 1) место"
        }
        
        cell.moneyLabel.text = secondsToHoursMinutesSeconds(seconds: obj.totaltime ?? 0)
        
        cell.medalImage.isHidden = false
        switch indexPath.row + 1 {
            case 1:
                cell.medalImage.image = UIImage(named: "icons8-gold-medal 1")
            case 2:
                cell.medalImage.image = UIImage(named: "icons8-silver-medal 1")
            case 3:
                cell.medalImage.image = UIImage(named: "icons8-bronze-medal 1")
            default:
                cell.medalImage.isHidden = true
        }
        
        //костыль
        if obj.idfun == ownId {
            cell.medalImage.isHidden = myPlace > 2 ? true : false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = items[indexPath.section][indexPath.row]
        if (obj.idfun == ownId && indexPath.section == 0) || indexPath.row > 2 {
            return 0
        }
        return 98
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
        let hours = seconds / 3600
        let minuts = (seconds % 3600) / 60
        //let seconds = (seconds % 3600) % 60
        return "\(hours)ч \(minuts)мин"
    }
}
