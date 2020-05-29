//
//  NoteViewController.swift
//  Notes
//
//  Created by Carey Chua on 14/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    var note: Note!
    var noteManager: NoteManager!
    
    @IBOutlet var textView: UITextView!
    
    @IBAction func saveNote() {
        note.contents = textView.text
        noteManager.save(note: note)
        done()
    }
    
    @IBAction func revertNote() {
        done()
    }
    
    @IBAction func deleteNote() {
        noteManager.delete(note: note)
        done()
    }
    
    func done() {
        navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textView.text = note.contents
    }
}
