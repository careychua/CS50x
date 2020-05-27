//
//  ViewController.swift
//  Notes
//
//  Created by Carey Chua on 14/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var notes: [Note] = []
    
    @IBAction func createNote() {
        let _ = NoteManager.main.create()
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        reload()
    }
    
    // determines number of columns of table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // determines number of rows of table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    // get selected cell and populate with data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].contents
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            NoteManager.main.delete(note: notes[indexPath.row])
            reload()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NoteSegue" {
            if let destination = segue.destination as? UINavigationController {
                if let viewDestination = destination.topViewController as? NoteViewController {
                    viewDestination.note = notes[tableView.indexPathForSelectedRow!.row]
                    viewDestination.noteManager = NoteManager.main
                }
            }
        }
    }
    
    func reload() {
        notes = NoteManager.main.getAllNotes()
        tableView.reloadData()
    }
}

