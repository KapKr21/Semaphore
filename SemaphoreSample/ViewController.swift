//
//  ViewController.swift
//  SemaphoreSample
//
//  Created by Kap's on 22/06/20.
//  Copyright © 2020 Kapil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sharedResource = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let dispatchQueue = DispatchQueue.global(qos: .background)
        
        dispatchQueue.async {
            
            self.fetchImage { (_,_) in
                print("Finished fetching image 1.")
                self.sharedResource.append("1")
                semaphore.signal()
            }
            semaphore.wait()
            
            self.fetchImage { (_,_) in
                print("Finished fetching image 2.")
                self.sharedResource.removeAll()
                semaphore.signal()
            }
            semaphore.wait()
            
            self.fetchImage { (_,_) in
                print("Finished fetching image 3.")
                self.sharedResource += ["3","4","5"]
                semaphore.signal()
            }
            semaphore.wait()
        }
       
//        let dispatchGroup = DispatchGroup()
//
//        dispatchGroup.enter()
//        fetchImage { (_,_) in
//            print("Finished fetching image 1.")
//            self.sharedResource.append("1")
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        fetchImage { (_,_) in
//            print("Finished fetching image 2.")
//            self.sharedResource.removeAll()
//            dispatchGroup.leave()
//        }
//
//        dispatchGroup.enter()
//        fetchImage { (_,_) in
//            print("Finished fetching image 3.")
//            self.sharedResource += ["3","4","5"]
//            dispatchGroup.leave()
//        }
//
//        //These above tasks will complete in no perticular order.
//
//        dispatchGroup.notify(queue: .main) {
//            print("Finished fetching images.")
//        }
        
        print("Waiting for images to finish fetching...")
    }

    func fetchImage(_ completion : @escaping (UIImage? ,Error?) -> ()) {
        
        guard let url = URL(string: "https://www.flaticon.com/premium-icon/personal-development_2415192?term=diagonal%20line&page=1&position=3") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                
            completion(UIImage(data: data ?? Data()), nil)
        }.resume()
        
        //DispatchQueue.global(qos: .)
        
    }
    

}

