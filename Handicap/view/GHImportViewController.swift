//
//  GHImportViewController
//  Handicap
//
//  Created by Dunbar, Bryan on 6/26/19.
//  Copyright © 2019 bdun. All rights reserved.
//

import UIKit
import CoreServices

class GHImportViewController: UIViewController, UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate, ImporterDelegate {

    var isImporting:Bool = false
    fileprivate var file:URL? {
        didSet {
            updateDisplay()
        }
    }
    @IBOutlet weak var fileTextField: UITextField!
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var importButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDisplay()
   }


    @IBAction func onSelectFileEditingDidBegin(_ sender: Any) {
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [kUTTypeSpreadsheet as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func updateDisplay() {
        
        if let file = file {
            self.importButton.isEnabled = !self.isImporting
            self.fileTextField.text = file.lastPathComponent
        } else {
            self.importButton.isEnabled = false
            self.fileTextField.text = nil
        }
        
    }
    @IBAction func importButtonTapped(_ sender: Any) {
        let context = SSManagedObject.mainQueueContext()!
        if let file = file,
            let importer = Importer(file.path, managedObjectContext: context) {
            self.isImporting = true
            self.logTextView.text = nil
            updateDisplay()
            importer.delegate = self
            importer.go()
            self.isImporting = false
            self.logTextView.text += "\nDone!"
            updateDisplay()
        } else {
            // Import failed
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        self.file = url
    }
    
    
    func importerProgressUpdate(_ importer: Importer, progressText: String) {
        self.logTextView.text += "\n\(progressText)"
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        print("in didPickDocumentPicker")
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
        updateDisplay()
    }
}
