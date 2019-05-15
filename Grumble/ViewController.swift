//
//  ViewController.swift
//  Grumble
// Purpose: app to faciliate finding food
//Version 1
//  Created by Luis on 7/6/18.
//  Copyright © 2018 SkyCloud. All rights reserved.
// Last updated 03/31/2019

import UIKit
import CoreData

class ViewController: UIViewController, HomeModelProtocol {
    //properties
    var feedItems: NSArray = NSArray()
    var selectedItem: LocationModel = LocationModel()
    var counter = 0
    var maxCount = 0
    var foodLabel: UILabel = UILabel()
    var foodPictureView = UIImageView()
    var foodUsedArray: Array<Int> = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        let homeModel = HomeModel()
        homeModel.delegate = self
        //here is where we download the items
        homeModel.downloadItems()
        print(feedItems.count)
       
        //grab location and query database for nearby items
        //TODO: calculate distance based on user location
        //to do this, we have to pass the query to maps API, then return distance
        
        
        //pulls local results that are stored from core data ( this will be useful later to save static information such as user preferences)
        pullFromCoreData()
        
        //generates default picture
        let foodPicture = UIImage(named: "testfood")
        
        foodPictureView = UIImageView(frame: CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2  + 100, width: 200, height: 100))
        foodPictureView.image = foodPicture
        foodPictureView.contentMode = UIImageView.ContentMode.scaleAspectFill
        //foodPictureView.layer.cornerRadius = 8.0
        //foodPictureView.clipsToBounds = true
        //foodPictureView.backgroundColor = UIColor.red
        
        //creates food label
        foodLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - 150, y: self.view.bounds.height / 2 - 50 , width: 300, height: 200))
        
        //Sets the properties of the foodlabel
        //FIXME: improve font to something larger and easier to move (UI improvement)
        foodLabel.lineBreakMode = .byWordWrapping
        foodLabel.numberOfLines = 3
        foodLabel.text = "Swipe to start"
        foodLabel.textAlignment = NSTextAlignment.center
        foodLabel.font = UIFont(name: "Noteworthy", size: 42)
       
        
        //adds the picture and label to the main view controller
        view.addSubview(foodPictureView)
        view.addSubview(foodLabel)
        //creates gesture and adds it to the label
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        foodLabel.isUserInteractionEnabled = true
        foodPictureView.isUserInteractionEnabled = true
        foodLabel.addGestureRecognizer(panGesture)
        
        //create a gesture for image to be tapped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        foodPictureView.addGestureRecognizer(tapGesture)
        
        
        //end of viewDidLoad
    }
    
    //Gesture Recognizer used to control the text
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: view)
        let foodLabel = gestureRecognizer.view!
        foodLabel.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.width / 2 + translation.y)
        //rotation of label
        let xFromCenter = foodLabel.center.x - self.view.bounds.width / 2
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(abs(100 / xFromCenter), 1)
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale)
        foodLabel.transform = stretchAndRotation
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended {
            //checks to see if finger has been lifted
            
            if foodLabel.center.x < 100 {
                notChosen()
            } else if foodLabel.center.x > self.view.bounds.width - 100 {
                foodChosen()
            }
            //resets label
            rotation = CGAffineTransform(rotationAngle: 0)
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            foodLabel.transform = stretchAndRotation
            foodLabel.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2 )
        }
        
        
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        //if the tapped view is an ImageView then set it to imageview
        if(gesture.view as? UIImageView) != nil {
            //FIXME: image counter should properly display current image
            print(counter)
            let imagecounter = Swift.abs(counter - 1)
            print("image tapped")
            print(imagecounter)
            selectedItem = feedItems[imagecounter] as! LocationModel
            //self.performSegue(withIdentifier: "mapSegue", sender: self)
            
            //pass name to maps API
            let foodMapQuery = selectedItem.foodName
            var mapRequest = ""
            //Check to see if google maps is installed, if not use apple maps
            if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
                 mapRequest = "comgooglemapsurl://?q=\(foodMapQuery!)"
            }else {
                 mapRequest = "http://maps.apple.com/?q=\(foodMapQuery!)"
            }
            print(mapRequest)
            mapRequest = mapRequest.replacingOccurrences(of: " ", with: "+")
                print(mapRequest)
                if let mapURL = (URL(string: mapRequest))
                {
                     UIApplication.shared.open(mapURL)
                } else {
                    print("Could not open URL")
                }
            
                }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        detailVC.selectedLocation = selectedItem
    }
    
    func foodChosen() {
        //print chosen to console
        //display chosen picture, then animate swipe and generate next food
        let chosenPicture = UIImage(named: "like")
        let chosenPictureView = UIImageView(frame: CGRect(x: self.view.bounds.width / 2 - 200, y: self.view.bounds.height / 2, width: 200, height: 180))
        chosenPictureView.image = chosenPicture
        view.addSubview(chosenPictureView)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            chosenPictureView.alpha = 0.0
        })
        //chosenPictureView.image = nil
        
        updateImage()
        
        print("chosen has worked")
        foodUsedArray = Array(0...feedItems.count)
        //shuffle array
        print(foodUsedArray)
        
       
    }
    
    func notChosen() {
        //print not chosen
        print("not chosen")
        let notChosenPicture = UIImage(named: "nope")
        let notChosenPictureView = UIImageView(frame: CGRect(x: self.view.bounds.width / 2 + 50, y: self.view.bounds.height / 2, width: 150, height: 100))
        notChosenPictureView.image = notChosenPicture
        view.addSubview(notChosenPictureView)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations:  {
            notChosenPictureView.alpha = 0.0
        })
        updateImage()
        //notChosenPictureView.image = nil
        
    }
    
    func randomSort(incomingCounter: Int) {
        
        
        
    }
    
    func updateImage() {
        //this method should generate a new picture or object from the core data or database array
        //create user query
        //check for attributes based on preferences
        //query.limit = 1
        //check array of results
        //loop through array
        // set image to imageUIView.image = UIImage(data: imageData)
        
        //stores the string of path to server and folder of web server
        let imageServerURL = "http://skycloudapps.com/foodimages/"
       
        
        //keeps track of items that are available in the database
        
        maxCount = feedItems.count - 1
        print("max count has been set to \(feedItems.count)")
        selectedItem = feedItems[counter] as! LocationModel
        //forces items array into selected item as a locationObject
        print(selectedItem.description)
        print("counter is now: \(counter)")
      
        if counter < maxCount {
            //checks to see if there is more items to display
            //TODO: check to see if png exists, if not, use jpg
            let imagePath = imageServerURL + selectedItem.foodImage! + ".png"
            
            let imageURL = URL(string: imagePath)
            let imageRequest = NSMutableURLRequest(url: imageURL!)
            
            let imageTask = URLSession.shared.dataTask(with: imageRequest as URLRequest) {
                data, response, error in
                
                if error != nil {
                    print(error!)
                } else {
                    if let data = data {
                        if let foodImg = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.foodPictureView.image = foodImg
                                
                                }
                                }
                        }
                    }
                }//end of else
            
            imageTask.resume()
            
            foodLabel.text = selectedItem.foodName
            
            print("image has been updated")
            //TODO: instead of adding to counter, we should randomize order
            counter = counter + 1
        } else if counter == maxCount {
            //if all the items have been loaded, sets text and image and resets counter for next swipe
            print("max count reached: \(counter), no new items to display")
            foodLabel.text = "No more items to display"
            foodLabel.sizeToFit()
            foodPictureView.image = nil
            counter = 0
        }
        
        
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        
    }
    
    func addNewItemToCoreData() {
        // let newFood = NSEntityDescription.insertNewObject(forEntityName: "FoodList", into: context)
        //add item to core data
        /* newFood.setValue("pasta", forKey: "foodName")
         //save item to core data
         do {
         //  try context.save()
         print("saved")
         } catch {
         print("There was an error")
         }
         */
    }
    
    func pullFromCoreData() {
        //setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        //pull information from core data
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FoodList")
        request.returnsObjectsAsFaults = false;
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let foodName = result.value(forKey: "foodName") as? String {
                        print(foodName)
                    }
                }
            } else {
                print("results are empty")
            }
        }catch {
            print("Couldn't fetch coredata results")
        }
    }
    
    func saveImageToLocalStorage(imageFile: UIImage, fileName: String) {
        //check local directory for image
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        if documentsPath.count > 0 {
            //checks to see if there is a path
            let documentsDirectory = documentsPath[0]
            let savePath = documentsDirectory + "/" + fileName + ".png"
            do {
                try UIImagePNGRepresentation(imageFile)?.write(to: URL(fileURLWithPath: savePath))
            } catch {
                //process error
                
            }
    }
    }//end of func

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

