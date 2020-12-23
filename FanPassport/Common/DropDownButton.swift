//
//  DropDownButton.swift
//  GameOfMinds
//
//  Created by Vadim on 01/10/2019.
//  Copyright © 2019 yorich. All rights reserved.
//

import UIKit

protocol DropDownProtocol {
    func dropDownPressed(string : String, index: Int)
}

@IBDesignable class DropDownButton: UIButton, DropDownProtocol {
    
    let dropDownView = DropDownView(frame: CGRect.zero)
    var height = NSLayoutConstraint()
    var isOpen = false
    var delegate : BaseViewControllerProtocol!
    
    var buttonColor = UIColor.clear
    var buttonTextColor = #colorLiteral(red: 0.9904158711, green: 0.4409633279, blue: 0.2889467776, alpha: 1)
    var buttonDisabledColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    var buttonDisabledTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    func dropDownPressed(string: String, index: Int) {
        setTitle(string, for: .normal)
        dismissDropDown()
        delegate.updateController(string: nil, int: index, bool: isOpen)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }

    func setupView() {
        adjustsImageWhenHighlighted = false

        tintColor = buttonTextColor
        setTitleColor(buttonTextColor, for: .normal)
        setTitleColor(buttonDisabledTextColor, for: .disabled)
        titleLabel?.font = UIFont.SVP.regular(size: 14)
        dropDownView.delegate = self
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropDownView)
        self.superview?.bringSubviewToFront(dropDownView)
        dropDownView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dropDownView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dropDownView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        height = dropDownView.heightAnchor.constraint(equalToConstant: 0)
        height.isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen {
            isOpen = !isOpen
            //NSLayoutConstraint.deactivate([height])
            height.constant = 0
            //NSLayoutConstraint.activate([height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropDownView.frame.size.height = self.height.constant
                self.dropDownView.layoutIfNeeded()
            }, completion: nil)
        } else {
            isOpen = !isOpen
            //NSLayoutConstraint.deactivate([height])
            height.constant = dropDownView.rowHeight * CGFloat(dropDownView.items.count)
            //NSLayoutConstraint.activate([height])
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.dropDownView.frame.size.height = self.height.constant
                self.dropDownView.layoutIfNeeded()
            }, completion: nil)
        }
        delegate.updateController(string: nil, int: nil, bool: isOpen)
    }
    
    func dismissDropDown() {
        isOpen = false
        //NSLayoutConstraint.deactivate([self.height])
        height.constant = 0
        //NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropDownView.frame.size.height = self.height.constant
            self.dropDownView.layoutIfNeeded()
        }, completion: nil)
    }
}


class DropDownView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var items = [String]()
    var tableView = UITableView(frame: .zero)
    var delegate : DropDownProtocol!
    var rowHeight: CGFloat = 40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    func setupView() {
        backgroundColor = UIColor(hex: 0xE6ECF2, alpha: 0.5)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SortTableCell")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "SortTableCell")
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = UIFont.SVP.regular(size: 14)
        cell.textLabel?.textColor = UIColor.svpMainText
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate.dropDownPressed(string: items[indexPath.row], index: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
