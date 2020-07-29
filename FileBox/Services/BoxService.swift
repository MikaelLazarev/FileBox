//
//  ipfsService.swift
//  FileBox
//
//  Created by Mikhail Lazarev on 24.07.2020.
//  Copyright © 2020 Mikhail Lazarev. All rights reserved.
//

import Alamofire
import Foundation

class BoxService {
    
    // Creates box on server and return new Box
    func createBox(boxDTO: BoxCreateDTO, url: URL, completion: @escaping (Box) -> Void) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(boxDTO)

            AF.upload(multipartFormData: {
                multipartFormData in
                multipartFormData.append(jsonData, withName: "box")
                multipartFormData.append(url, withName: "file")
            }, to: getFullURL(url: "/api/boxes/"))

                .responseDecodable(of: Box.self) { response in
                    do {
                        print("Getting data back!", response)
                        let newBox = try response.result.get()
                        completion(newBox)

                    } catch {
                        print("Error, cant get ID")
                    }
                }
                .uploadProgress { progress in
                    print("Upload Progress: \(progress.fractionCompleted)")
                }
        } catch {
            return
        }
    }
    
    // Get box details
    func getBox(id: String, completetion: @escaping (Box) -> Void) {
        AF.request(getFullURL(url: "/api/boxes/\(id)/"))

            .responseDecodable(of: Box.self) { response in
                do {
                    print("Getting data back!", response)
                    let newBox = try response.result.get()
                    completetion(newBox)

                } catch {
                    print("Error, cant get ID")
                }
            }
    }
    
    // Get array of boxes around providing coordinates
    func getBoxesAround() {
        
    }
}