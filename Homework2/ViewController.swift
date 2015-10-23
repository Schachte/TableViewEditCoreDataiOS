

import UIKit
import CoreData


class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var personTable: UITableView!
    var person:Locate? = nil
  var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    var dataViewController: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFetchResultsController() -> NSFetchedResultsController {
        
        dataViewController = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return dataViewController
        
    }
    
    func listFetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Locate")
        let sortDescripter = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        return fetchRequest
        
    }
    
    //Fill the 5 needed locations into table view controller
    func hardCodeDefValues(name: String, descr: String, imgurl: String) {
        
        let insertionData = NSEntityDescription.entityForName("Locate", inManagedObjectContext: context)
        let locator = Locate(entity: insertionData!, insertIntoManagedObjectContext: context)
        locator.name = name
        locator.descr = descr
        locator.imgurl = imgurl

        context.save(nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        dataViewController = getFetchResultsController()
       
        dataViewController.delegate = self
        dataViewController.performFetch(nil)
        
        hardCodeDefValues("Los Angeles", descr: "Beautiful city in the heart of California", imgurl: "losangeles.jpg")
        hardCodeDefValues("Phoenix", descr: "Beautiful city in the heart of California", imgurl: "phoenix.jpg")
        hardCodeDefValues("Portland", descr: "Beautiful city in the heart of California", imgurl: "portland.jpg")
        hardCodeDefValues("Des Moines", descr: "Beautiful city in the heart of California", imgurl: "desmoines.jpg")
        hardCodeDefValues("Chicago", descr: "Beautiful city in the heart of California", imgurl: "chicago.jpg")
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.personTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections  = dataViewController.sections?.count
        return numberOfSections!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = dataViewController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.personTable.dequeueReusableCellWithIdentifier("dataCell", forIndexPath: indexPath) as! UITableViewCell
        let personInfo = dataViewController.objectAtIndexPath(indexPath) as! Locate
        var name = personInfo.name
        var descr = personInfo.descr
        cell.textLabel?.text = "Name: \(name)"
        cell.detailTextLabel?.text = "Description: \(descr)"
        
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle:   UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let record = dataViewController.objectAtIndexPath(indexPath) as! Locate
            context.deleteObject(record)
            context.save(nil)
            
        }
    }
    
    override func  prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "edit"
        {
            let cell = sender as! UITableViewCell
            let indexPath = self.personTable.indexPathForCell(cell)
            let dest: DetailViewController =  segue.destinationViewController as! DetailViewController
            let row = dataViewController.objectAtIndexPath(indexPath!) as! Locate
            dest.locObj = row
            
        }
        
    }


}

