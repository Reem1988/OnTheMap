//
//  GetWebservices.swift
//  OnTheMap
//
//  Created by Reem Alosaimi on 11/01/19.
//  Copyright © 2019 Reem Alosaimi. All rights reserved.
//

import Foundation

class StudentServices{
    
    
    //Mark: - Data key and session id
    struct Authorization{
        static var accountKey=""
        static var sessionId=""
    }
    
    //MARK: - error set up
    
    //todo: - create an enum to hold custom errors for application
    enum Errors:Error,LocalizedError{
        
        //cases
        case urlError
        
        //A localized message describing what error occurred.
        public var errorDescription: String? {
            switch self {
            case .urlError:
                return NSLocalizedString("Invalid URL.",comment:"Invalid URL")
            }
        }
    }
    
    //MARK: - URL set up
    
    //TODO: - create an enum to hold the cases for the api requests
    enum Endpoints{
        
        //Base api for request
        static let baseAPI="https://onthemap-api.udacity.com/v1/"
        
        //cases
        case student(String)
        case studentLocations
        case newStudent
        case updateStudent(String)
        case login
        case logout
        
        //Return a specified string url for the request cases
        var stringValue:String{
            //switch on the case itself
            switch self{
            case .student(let accountKey):
                return Endpoints.baseAPI+"users/\(accountKey)"
            case .studentLocations:
                return Endpoints.baseAPI+"StudentLocation?order=-updatedAt&limit=100"
            case .newStudent:
                return Endpoints.baseAPI+"StudentLocation"
            case .updateStudent(let objectId):
                return Endpoints.baseAPI+"StudentLocation/\(objectId)"
            case .login:
                return Endpoints.baseAPI+"session"
            case .logout:
                return Endpoints.baseAPI+"session"
                
                
            }
        }
        //Return a URL from the specified string based on the case
        var url:URL?{
            return URL(string: stringValue)
        }
        
    }
    
    //MARK: - Get Requests
    
    //TODO: - Get a list of students location
    class func getStudents(completionHandler:@escaping ([Student],Error?)->()){
        
        
        //Make sure the url is not nil
        guard let url=Endpoints.studentLocations.url else{
            completionHandler([],Errors.urlError)
            return
        }
        
        //create and initialize a session
        let session=URLSession.shared.dataTask(with: url, completionHandler: {(data,response,error) in
            
            //make sure the data is not nil
            guard let data=data else{
                //return to the main thread
                DispatchQueue.main.async {
                    completionHandler([],error)
                }
                return
            }
            
            //create and initialize a json decoder
            let decoder=JSONDecoder()
            
            //decode the json response
            do{
                //if we cant ecode the response pass it to the completion handler
                let responseObject=try decoder.decode(StudentResults.self,from:data)
                print(responseObject.results)
                //return to the main thread
                DispatchQueue.main.async {
                    completionHandler(responseObject.results,nil)
                }
            }catch{//if we cant decode into the LoginResposne type that means there was a error logging in so we decode the data to FaieldResposne type and pass it to the completion handler as an error
                do{
                    let studentError=try decoder.decode(FailedResponse.self,from:data)
                    DispatchQueue.main.async {
                        completionHandler([],studentError)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completionHandler([],error)
                    }
                }
            }
        })
        
        //resume the session
        session.resume()
   }
    
    //TODO: -  get a specific student based on id
    class func getStudenyByID(completionHandler:@escaping (StudentByID?,Error?)->()){
        
        //create the url
        guard let url=Endpoints.student(Authorization.accountKey).url else{
            completionHandler(nil,Errors.urlError)
            return
            
        }
        
        //create a session
        let session=URLSession.shared.dataTask(with: url, completionHandler: {(data,response,error) in
            
            //make sure the data is not nil
            guard let data=data else{
                //return to the main thread
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
                return
            }
            
            
            //create the new data ,we do this because of udacity api response
            let newData=data.subdata(in: 5..<data.count)
            //create a json decoder
            let decoder=JSONDecoder()
            
            do{
                //if we cant ecode the response pass nil to the completion handler
                let responseObject=try decoder.decode(StudentByID.self,from:newData)
                print(responseObject)
                //return to the main thread
                DispatchQueue.main.async {
                    completionHandler(responseObject,nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
            }
            
        })
        
        //resume the session
        session.resume()

    }
    
    
    //MARK: - Post requests
    
    //TODO: - posting a student location
//    class func addStudent(mapString:String,mediaURL:String,longittude:Float,latitude:Float,completionHandler:@escaping(NewStudentResponse?,Error?)->()){
//        
//    }
    
    
    //TODO: - Login
    class func loginStudent(username:String,password:String,completionHandler:@escaping(Bool,Error?)->()){
        
        //Make sure the url is not nil
        guard let url=Endpoints.login.url else{
            completionHandler(false,Errors.urlError)
            return
        }
        
        //create and initialize a request
        var request=URLRequest(url: url)
        
        //add headers to the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json",forHTTPHeaderField: "Accept")
        
        //specify the method
        request.httpMethod="POST"
        
        //create the request body
        let userInfo=UserInfo(username,password)
        let loginBody=LoginRequest(udacity: userInfo)
        request.httpBody=try! JSONEncoder().encode(loginBody)
    
        //create a session
        let session=URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) in
            //make sure the data is not nil
            guard let data=data else{
                //return to the main thread
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
                return
            }
            
            //we have to subset the data for security reasons with udacity
            let newData=data.subdata(in: 5..<data.count)
            
            //create and initialize a decoder
            let decoder=JSONDecoder()

            do {
                //decode the new data into type LoginResponse
                let responseObject=try decoder.decode(LoginResponse.self,from:newData)
                //update the unique id for the user and the session is
                Authorization.accountKey=responseObject.account.key
                print(Authorization.accountKey)
                Authorization.sessionId=responseObject.session.id
                print(Authorization.sessionId)
                DispatchQueue.main.async {
                    //pass the data to the compeltion handler
                    completionHandler(true,nil)
                }
            }catch{//if we cant decode into the LoginResposne type that means there was a error logging in so we decode the data to FaieldResposne type and pass it to the completion handler as an error
                do{
                    let loginError=try decoder.decode(FailedResponse.self,from:newData)
                    DispatchQueue.main.async {
                    completionHandler(false,loginError)
                    }
                }catch{
                    DispatchQueue.main.async {
                        completionHandler(false,error)
                    }
                }
            }
        })
        
        //run the session
        session.resume()
    }
    
    //TODO: - post a student location
    class func postLocation(_ studentById:StudentByID,_ mediaURL:String,locationName:String,longitude:Double,latitude:Double,completionHandler:@escaping(NewStudentResponse?,Error?)->()){
        
        //Make sure the url is not nil
        guard let url=Endpoints.newStudent.url else{
            completionHandler(nil,Errors.urlError)
            return
        }
        
        //create a url request
        var request=URLRequest(url: url)
        
        //set the method
        request.httpMethod="POST"
        //set the header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //create a new instance of the StudentRequest
      let newStudent=StudentRequest(firstName: studentById.firstName, lastName: studentById.lastName, uniqueKey: studentById.key, mediaURL: mediaURL, longitude: longitude, latitude: latitude, mapString: locationName)
        //set the instance to the request body
        request.httpBody=try! JSONEncoder().encode(newStudent)
        
        //create the session
        let session=URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) in
            
            //make sure the data is not nil
            guard let data=data else{
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
                return
            }
            
            //create a json decoder
            let decoder=JSONDecoder()
            
            //decode the response into a NewStudentResponse instance
            do{
                let responseObject=try decoder.decode(NewStudentResponse.self,from:data)
                print(responseObject)
                DispatchQueue.main.async {
                    completionHandler(responseObject,nil)
                }
            }catch let decodeError{
                print(decodeError)
                DispatchQueue.main.async{
                completionHandler(nil,decodeError)
                }
            }
            
        })
        
        //resume the session
        session.resume()
    }
    
    //MARK: - PUT METHODS
    
    //TODO: - put a student
    class func putLocation(_ studentById:StudentByID,_ mediaURL:String,locationName:String,longitude:Double,latitude:Double,objectId:String,completionHandler:@escaping(UpdateStudentResponse?,Error?)->()){
        
        //Make sure the url is not nil
        guard let url=Endpoints.updateStudent(objectId).url else{
            completionHandler(nil,Errors.urlError)
            return
        }
        
        //create a url request
        var request=URLRequest(url: url)
        
        //set the method
        request.httpMethod="PUT"
        //set the header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //create a new instance of the StudentRequest
        let updateStudent=StudentRequest(firstName: studentById.firstName, lastName: studentById.lastName, uniqueKey: studentById.key, mediaURL: mediaURL, longitude: longitude, latitude: latitude, mapString: locationName)
        //set the instance to the request body
        request.httpBody=try! JSONEncoder().encode(updateStudent)
        
        //create the session
        let session=URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) in
            
            //make sure the data is not nil
            guard let data=data else{
                DispatchQueue.main.async {
                    completionHandler(nil,error)
                }
                return
            }
            
            //create a json decoder
            let decoder=JSONDecoder()
            
            //decode the response into a NewStudentResponse instance
            do{
                let responseObject=try decoder.decode(UpdateStudentResponse.self,from:data)
                print(responseObject)
                DispatchQueue.main.async {
                    completionHandler(responseObject,nil)
                }
            }catch let decodeError{
                print(decodeError)
                DispatchQueue.main.async{
                    completionHandler(nil,decodeError)
                }
            }
            
        })
        
        //resume the session
        session.resume()
    }
    //MARK: - Delete Requests
    
    //TODO: - Delete the session
    class func logout(completionHandler:@escaping (Bool,Error?)->()){
        //Make sure the url is not nil
        guard let url=Endpoints.logout.url else{
            completionHandler(false,Errors.urlError)
            return
        }
        
        //create a reuqest
        var request=URLRequest(url: url)
        
        //set the request method
        request.httpMethod="DELETE"
        
        let session=URLSession.shared.dataTask(with: request, completionHandler: {(data,response,error) in
            
            //make sure the data is not nil
            if let _ = data{//if its not nil that means there was a successful logout
                //set the unique id and session id to empty
                Authorization.accountKey=""
                Authorization.sessionId=""
                DispatchQueue.main.async{
                    completionHandler(true,nil)
                }
            } else{//if it is nil perform this code
                DispatchQueue.main.async {
                    completionHandler(false,error)
                }
                return
            }
        })
        
        //run the session
        session.resume()
    }
}
