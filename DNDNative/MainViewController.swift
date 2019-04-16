//
//  MainViewController.swift
//  DNDNative
//
//  Created by Ashley Ng on 6/26/18.
//  Copyright © 2018 AshleyNg. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var items: [ComplexObject] = (0..<40).map { i in ComplexObject(name: "\(i) Lorem ipsum dolor sit amet, has nulla menandri efficiendi et, probo ludus dicunt duo an. Lobortis reformidans an mea in.") }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableViewCell")
//        tableView.estimatedRowHeight = 110
        tableView.rowHeight = 110
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
        tableView.dragInteractionEnabled = true
    }
}

extension MainViewController: UITableViewDropDelegate, UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("itemsForBeginning")
        let item = self.items[indexPath.row]
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, dragSessionWillBegin session: UIDragSession) {
        print("drag session will begin")
    }
    
    func tableView(_ tableView: UITableView, dragSessionDidEnd session: UIDragSession) {
        print("drag session will end")
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard session.localDragSession != nil else {
            return UITableViewDropProposal(operation: .forbidden)
        }
        
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = tableView.numberOfRows(inSection: 0)
            destinationIndexPath = IndexPath(row: row, section: 0)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            tableView.performBatchUpdates({
                var indexPaths = [IndexPath]()
                for (index, item) in coordinator.items.enumerated() {
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: 0)
//                    self.items.insert(item.dragItem.localObject, at: indexPath.row)
                    indexPaths.append(indexPath)
                    item.dragItem.itemProvider.loadObject(ofClass: ComplexObject.self) { subject, error in
                        if let subject = subject as? ComplexObject {
                            self.items.insert(subject, at: indexPath.row)
                        }
                    }
                }
                tableView.insertRows(at: indexPaths, with: .none)
            }, completion: nil)
        default:
            return
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let item = items[indexPath.row]
        cell.configureWithLabel(item.loremIpsum)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = self.items[sourceIndexPath.row]
        self.items.remove(at: sourceIndexPath.row)
        self.items.insert(item, at: destinationIndexPath.row)
    }
}
