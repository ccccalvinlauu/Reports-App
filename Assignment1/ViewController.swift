//
//  ViewController.swift
//  COMP327.u6tcl.Lau.TszChung.Assignment1
//
//  Created by lau tszchung on 31/10/2018.
//  Copyright © 2018 lau tszchung. All rights reserved.
//
// View Controller that will display all the information of the report that is clicked
import UIKit
import CoreData
import WebKit


class ViewController: UIViewController {
    
    var myindex = 0
    
    //Labels

    @IBOutlet weak var LabelForTitle: UILabel!
    
    @IBOutlet weak var LabelForYear: UILabel!
    
    @IBOutlet weak var LabelForAuthor: UILabel!
    
    @IBOutlet weak var LabelForOwner: UILabel!
    
    @IBOutlet weak var LabelForAbstract: UILabel!
    
    @IBOutlet weak var LabelForPDF: UILabel!
    
    @IBOutlet weak var LabelForComment: UILabel!
    
    @IBOutlet weak var LabelForLastModified: UILabel!
    
    @IBOutlet weak var Switch: UISwitch!
    
    
//Button action of ViewPDF, open the pdf file with the provided pdf url using webview
    @IBAction func ViewPDF(_ sender: UIButton) {
        //set the path
        if(ReportsData[myindex].pdf != nil){
            guard let path: URL = URL(string: ReportsData[myindex].pdf!) else { return }
            //creating a web view with the frame size as the view
            let webview = WKWebView(frame: self.view.frame)
            //URL Reuqest of path(pdf file)
            let urlrequest = URLRequest(url: path)
            //load it to webview
            webview.load(urlrequest as URLRequest)
            
            //New View Controller, pdf View COntroller
            let pdfViewControlloer = UIViewController()
            //adding the WebView to this View Controller
            pdfViewControlloer.view.addSubview(webview)
            //set the title as the report title
            pdfViewControlloer.title = ReportsData[myindex].title
            //push the pdf View Controller
            self.navigationController?.pushViewController(pdfViewControlloer, animated: true)
        } else{
            //If pdf is nil
            let alertController = UIAlertController(title: "Error", message: "There is no PDF file for this report", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
//The Switch button that can save and unsave reports
    @IBAction func `switch`(_ sender: UISwitch) {
        //when its turned offf
        if(sender.isOn == false){
            for item in list {
                if item.title == TitleSelected{
                    //Remove from Core Data
                    Favourite.context.delete(item)
                    Favourite.saveContext()
                    ReportsData[myindex].hasfavourited = false
                }
            }
        } else{
            //when its turned On, save it to Core Data
            let saveItem = Title(context: Favourite.context)
            saveItem.title = TitleSelected
            
            Favourite.saveContext()
            list.append(saveItem)
        }
    }
    
    //Set the initial position of the switch, if it is saved, set it to On, else set the Off
    func switchState() {
        if(ReportsData[myindex].hasfavourited){
            Switch.isOn = true
        }else{
            Switch.isOn = false
        }
    }
    
    //View Didd Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchState()
        self.navigationItem.title = "Report Details"
        //         Do any additional setup after loading the view, typically from a nib.
        
        //Set all the Values of Labels
        LabelForTitle.numberOfLines = 0
        LabelForTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        LabelForTitle.text = "Title : \(ReportsData[myindex].title)"
        
        LabelForYear.text = "Year : \(ReportsData[myindex].year)"
        
        
        LabelForAuthor.numberOfLines = 0
        LabelForAuthor.lineBreakMode = NSLineBreakMode.byWordWrapping
        LabelForAuthor.text = "Authors :  \(ReportsData[myindex].authors)"
        
        if ReportsData[myindex].owner != nil {
            LabelForOwner.text = "Owner :  \(ReportsData[myindex].owner!)"
            
        } else {
            LabelForOwner.text = "Owner :  nil"
        }
        
        
        LabelForAbstract.numberOfLines = 0
        LabelForAbstract.lineBreakMode = NSLineBreakMode.byWordWrapping
        if ReportsData[myindex].abstract != nil {
            LabelForAbstract.text = "Abstract :  \(ReportsData[myindex].abstract!)"
            
        } else {
            LabelForAbstract.text = "Abstract :  Abstract is not available"
        }
        
        
        
        LabelForPDF.numberOfLines = 0
        LabelForPDF.lineBreakMode = NSLineBreakMode.byWordWrapping
        if ReportsData[myindex].pdf != nil {
            LabelForPDF.text = "pdf file :  \(ReportsData[myindex].pdf!)"
            
        } else {
            LabelForPDF.text = "pdf file :  nil)"
        }
        
        
        if ReportsData[myindex].comment != nil {
            LabelForComment.text = "Comments :  \(ReportsData[myindex].comment!)"
            
        } else {
            LabelForComment.text = "Comments :  nil"
        }
        
        LabelForLastModified.text = "Last Modified :  \(ReportsData[myindex].lastModified)"
        
        
    }
    
    
}

