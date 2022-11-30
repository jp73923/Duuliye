//
//  PDFVC.swift
//  Duuliye
//
//  Created by Developer on 04/07/22.
//

import UIKit
import PDFKit

class PDFVC: UIViewController {
    
    @IBOutlet weak var PDFView1: PDFView!
    //   @IBOutlet weak var pdfView: PDFView!
    
    var pdfURL = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        let pdfView = PDFView(frame: PDFView1.bounds)
                PDFView1.addSubview(pdfView)

        
        pdfView.autoScales = true
        
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        
        let document = PDFDocument(url: URL(string: pdfURL)!)
        pdfView.document = document

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
