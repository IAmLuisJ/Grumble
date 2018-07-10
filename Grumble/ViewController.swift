//
//  ViewController.swift
//  Grumble
//
//  Created by Luis on 7/6/18.
//  Copyright © 2018 SkyCloud. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //setup core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newFood = NSEntityDescription.insertNewObject(forEntityName: "FoodList", into: context)
        //add item to core data
        newFood.setValue("pasta", forKey: "foodName")
        //save item to core data
        do {
            try context.save()
            print("saved")
        } catch {
            print("There was an error")
        }
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
        
        let foodLabel = UILabel(frame: CGRect(x: self.view.bounds.width / 2 - 100, y: self.view.bounds.height / 2 - 50, width: 200, height: 100))
        
        foodLabel.text = "Food Name"
        
        foodLabel.textAlignment = NSTextAlignment.center
        
        view.addSubview(foodLabel)
        
        //gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        foodLabel.isUserInteractionEnabled = true
        
        foodLabel.addGestureRecognizer(panGesture)
    }
    
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
                print("not chosen")
            } else if foodLabel.center.x > self.view.bounds.width - 100 {
                print("chosen")
            }
            rotation = CGAffineTransform(rotationAngle: 0)
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1)
            foodLabel.transform = stretchAndRotation
            foodLabel.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

