//
//  ViewController.swift
//  CollectionView
//
//  Created by Soren Sonderby Nielsen on 19/03/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import UIKit

enum CellType {
    case multipleSelection(MultipleOptionsCellDelegate)
}

class ViewController: UITableViewController {

    var cells = [CellType]()

    var options = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.register(UINib(nibName: "MultipleOptionsCell", bundle: Bundle.main), forCellReuseIdentifier: "MultipleOptionsCell")

        add()
    }

    fileprivate func add() {
        cells.append(.multipleSelection(self))

        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: cells.count - 1, section: 0)], with: .left)
        tableView.endUpdates()
    }
}

// UITableViewDataSource
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch cells[indexPath.row] {
        case .multipleSelection(let delegate):
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleOptionsCell", for: indexPath) as! MultipleOptionsCell
            cell.delegate = delegate
            return cell
        }
    }
}

extension ViewController: MultipleOptionsCellDelegate {
    func numberOfOptions() -> Int {
        return options.count
    }

    func configure(_ cell: MultipleOptionsSelectionCell, for index: Int) {
        cell.text = options[index]
    }

    func didSelectItemAt(index: Int) {
        print("Did select option \"\(options[index])\"")
        add()
    }
}
