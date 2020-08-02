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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UISettings()
        getItems()
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
    
    func getItems() {
        guard GlobalConstants.apiService.isInternetAvailable(vc: self) else { return }
        showProgressHUD()
        GlobalConstants.apiService.getRatings() { result, data, error in
            self.hideProgressHUD()
            if result, let users = data {
                self.items.removeAll()
                self.items.append(users.sorted(by: { ($0.totaltime ?? 0) > ($1.totaltime ?? 0) }))
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
        let lname = obj.lastname == nil ? "" : obj.lastname!
        cell.nameLabel.text = sname + name + lname
        cell.placeLabel.text = "\(indexPath.row + 1) место"
        cell.moneyLabel.text = secondsToHoursMinutesSeconds(seconds: obj.totaltime ?? 0)
        
        switch indexPath.row + 1 {
            case 1:
                cell.medalImage.image = UIImage(named: "medalGold.png")
            case 2:
                cell.medalImage.image = UIImage(named: "medalSilver.png")
            case 3:
                cell.medalImage.image = UIImage(named: "medalBronze.png")
            default:
                cell.medalImage.isHidden = true
        }
    
        
        return cell
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
        let hours = seconds / 3600
        let minuts = (seconds % 3600) / 60
        //let seconds = (seconds % 3600) % 60
        return "\(hours)ч \(minuts)мин"
    }
}
