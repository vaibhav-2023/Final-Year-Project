//
//  ApiServices.swift
//  payment_app
//
//  Created by MacBook PRO on 31/12/22.
//

import Foundation
import Network
import Combine

//protocol to implement cancellables in all view model classes created on 31/12/22
protocol ViewModel: ObservableObject {
    func cancelAllCancellables()
}

//Class to handle all the Api Requests created on 31/12/22
class ApiServices {
    
    //function to create query items
    func getQueryItems(forURLString urlString: String, andParamters parameters: JSONKeyPair) -> URLComponents? {
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = []
        for (keyName, value) in parameters {
            urlComponents?.queryItems?.append(URLQueryItem(name: keyName, value: "\(value)"))
        }
        if let component = urlComponents {
            //https://stackoverflow.com/questions/27723912/swift-get-request-with-parameters
            //this code is added because some servers interpret '+' as space becuase of x-www-form-urlencoded specification
            //so we have to percent escape it manually because URLComponents does not perform it
            //space is percent encoded as %20 and '+' is encoded as "%2B"
            urlComponents?.percentEncodedQuery = component.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        return urlComponents
    }
    
    //function to create URLRequest with String
    func getURL(ofHTTPMethod httpMethod: HTTPMethod,
                forAppEndpoint appEndpoint: AppEndpoints,
                withQueryParameters queryParameters: JSONKeyPair? = nil) -> URLRequest? {
        return getURL(ofHTTPMethod: httpMethod, forString: appEndpoint.getURLString(), withQueryParameters: queryParameters)
    }
    
//    func getURL(ofHTTPMethod httpMethod: HTTPMethod,
//                forAppEndpoint appEndpoint: AppEndpointsWithParamters,
//                withQueryParameters queryParameters: JSONKeyPair?) -> URLRequest? {
//        return getURL(ofHTTPMethod: httpMethod, forString: appEndpoint.getURLString(), withQueryParameters: queryParameters)
//    }
    
    //function to create URLRequest with Endpoint Enum
    private func getURL(ofHTTPMethod httpMethod: HTTPMethod,
                        forString urlString: String,
                        withQueryParameters queryParameters: JSONKeyPair?) -> URLRequest? {
        var urlRequest: URLRequest? = nil
        if let queryParameters {
            let urlComponents = getQueryItems(forURLString: urlString, andParamters: queryParameters)
            if let url = urlComponents?.url {
                urlRequest = URLRequest(url: url)
            }
        } else if let url = URL(string: urlString) {
            urlRequest = URLRequest(url: url)
        }
        urlRequest?.httpMethod = httpMethod.rawValue
        print("\nurl", urlRequest?.url?.absoluteString ?? "URL not set for \(urlString)")
        print("http method is", urlRequest?.httpMethod ?? "http method not assigned")
        return urlRequest
    }
    
    //function to hit a URL Request, i.e., perform an API Task
    func hitApi<T: Decodable>(withURLRequest urlRequest: URLRequest?,
                              decodingStruct: T.Type,
                              outputBlockForInternetNotConnected: @escaping () -> Void) -> AnyPublisher<T, APIError> {
        
        print("headers are", urlRequest?.allHTTPHeaderFields ?? [:])
        let urlString = urlRequest?.url?.absoluteString ?? "URL not set"
        print("url", urlString, "\n")
        
        //if user is connected to internet only then perform API task
        if Singleton.sharedInstance.appEnvironmentObject.isConnectedToInternet {
            
            if let urlRequest {
                return URLSession
                    .shared
                    .dataTaskPublisher(for: urlRequest)
                    .receive(on: DispatchQueue.main)
                    .mapError { _ in
                        self.printApiError(.MapError, inUrl: urlString)
                        return APIError.MapError
                    }
                //.decode(type: T.self, decoder: Singleton.sharedInstance.jsonDecoder)
                    .flatMap { data, response -> AnyPublisher<T, APIError> in
                        //check if response is in form of HTTPResponse or not
                        guard let response = response as? HTTPURLResponse else{
                            return self.getApiErrorPublisher(.InvalidHTTPURLResponse, inUrl: urlString)
                        }
                        let jsonConvert = try? JSONSerialization.jsonObject(with: data, options: [])
                        let json = jsonConvert as AnyObject
                        
                        //handle cases according to http status code
                        switch response.statusCode {
                        case 100...199:
                            return self.getApiErrorPublisher(.InformationalError(response.statusCode), inUrl: urlString)
                        case 200...299:
                            #if DEBUG
                            //print(json)
                            do {
                                let _ = try Singleton.sharedInstance.jsonDecoder.decode(decodingStruct.self, from: data)
                            } catch let DecodingError.typeMismatch(type, context)  {
                                print("Type '\(type)' mismatch:", context.debugDescription)
                                print("codingPath:", context.codingPath)
                            } catch {
                                print(error.localizedDescription)
                            }
                            #endif
                            return Just(data).decode(type: decodingStruct.self, decoder: Singleton.sharedInstance.jsonDecoder)
                                .mapError { _ in
                                    self.printApiError(.DecodingError, inUrl: urlString)
                                    return APIError.DecodingError
                                }
                                .eraseToAnyPublisher()
                        case 300...399:
                            return self.getApiErrorPublisher(.RedirectionalError(response.statusCode), inUrl: urlString)
                        case 400...499:
                            let clientErrorEnum = ClientErrorsEnum(rawValue: response.statusCode) ?? .Other
                            switch clientErrorEnum {
                            case .Unauthorized:
                                Singleton.sharedInstance.alerts.handle401StatueCode()
                            case .BadRequest, .PaymentRequired, .Forbidden, .NotFound, .MethodNotAllowed, .NotAcceptable, .URITooLong, .Other:
                                if let message = json["message"] as? String {
                                    Singleton.sharedInstance.alerts.errorAlertWith(message: message)
                                } else if let errorMessage = json["error"] as? String {
                                    Singleton.sharedInstance.alerts.errorAlertWith(message: errorMessage)
                                } else if let errorMessages = json["error"] as? [String] {
                                    var errorMessage = ""
                                    for message in errorMessages {
                                        if errorMessage != "" {
                                            errorMessage = errorMessage + ", "
                                        }
                                        errorMessage = errorMessage + message
                                    }
                                    Singleton.sharedInstance.alerts.errorAlertWith(message: errorMessage)
                                } else{
                                    Singleton.sharedInstance.alerts.errorAlertWith(message: "Server Error")
                                }
                            }
                            return self.getApiErrorPublisher(.ClientError(clientErrorEnum), inUrl: urlString)
                        case 500...599:
                            return self.getApiErrorPublisher(.ServerError(response.statusCode), inUrl: urlString)
                        default:
                            return Fail(error: APIError.Unknown(response.statusCode)).eraseToAnyPublisher()
                        }
                    }.eraseToAnyPublisher()
            } else {
                return getApiErrorPublisher(.UrlNotValid, inUrl: urlString)
            }
        } else {
            //if internet is not connected, add observer, so that when internet access is acquired
            //perform the task
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: urlString)
            monitor.pathUpdateHandler = { path in
                DispatchQueue.main.async {
                    if path.status == .satisfied {
                        outputBlockForInternetNotConnected()
                        monitor.cancel()
                    }
                }
            }
            monitor.start(queue: queue)
            return getApiErrorPublisher(.InternetNotConnected, inUrl: urlString)
        }
    }
    
    //to return the error in AnyPublisher class form
    private func getApiErrorPublisher<T: Decodable>(_ apiError: APIError, inUrl urlString: String) -> AnyPublisher<T, APIError> {
        printApiError(apiError, inUrl: urlString)
        return Fail(error: apiError).eraseToAnyPublisher()
    }
    
    private func printApiError(_ apiError: APIError, inUrl urlString: String) {
        print("in api \(urlString) \(apiError)")
    }
}

extension URL {
    //Extension to get Query Parameters
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}

extension URLRequest {
    //extension to add headers to the URL Request
    mutating func addHeaders(_ headers: JSONKeyPair? = nil, shouldAddAuthToken: Bool = false) {
        //set headers
        self.addValue("iOS", forHTTPHeaderField: "device")
        self.addValue("application/json", forHTTPHeaderField: "Accept")
        if shouldAddAuthToken, let token = UserDefaults.standard.string(forKey: UserDefaultKeys.authToken) {
            self.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        if let headers {
            headers.forEach { key, value in
                self.addValue(key, forHTTPHeaderField: "\(value)")
            }
        }
    }
    
    //extension to add body to the URL Request
    mutating func addParameters(_ parameters: JSONKeyPair?, withFileModel fileModel: [FileModel]? = nil, as parameterEncoding: ParameterEncoding) {
        let urlString = self.url?.absoluteString ?? ""
        
        //every body type requires different steps
        switch parameterEncoding {
        case .JSONBody:
            if let parameters {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                    self.httpBody = jsonData
                    self.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    print("error in \(urlString) with parameterEncoding \(parameterEncoding)", error.localizedDescription)
                }
            }
        case .URLFormEncoded:
            if let parameters {
                let urlComponents = Singleton.sharedInstance.apiServices.getQueryItems(forURLString: urlString, andParamters: parameters)
                let formEncodedString = urlComponents?.percentEncodedQuery
                if let formEncodedData = formEncodedString?.data(using: .utf8) {
                    self.httpBody = formEncodedData
                    self.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                } else {
                    print("error in \(urlString) with parameterEncoding \(parameterEncoding)")
                }
            }
        case .FormData:
            //https://stackoverflow.com/questions/26162616/upload-image-with-parameters-in-swift
            //https://orjpap.github.io/swift/http/ios/urlsession/2021/04/26/Multipart-Form-Requests.html
            //https://bhuvaneswarikittappa.medium.com/upload-image-to-server-using-multipart-form-data-in-ios-swift-5c4eb6de26e2
            
            let boundary = "Boundary-\(UUID().uuidString)"
            let lineBreak = "\r\n"
            
            var body = Data()
            
            if let parameters {
                parameters.forEach { key, value in
                    if let params = value as? JSONKeyPair, let data = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
                        body.appendString("--\(boundary + lineBreak)")
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                        //body.appendString("Content-Type: application/json;charset=utf-8\(lineBreak + lineBreak)")
                        body.append(data)
                        body.appendString(lineBreak)
                    } else if let data = "\(value)".data(using: .utf8) {
                        body.appendString("--\(boundary + lineBreak)")
                        body.appendString("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                        //body.appendString("Content-Type: text/plain;charset=utf-8\(lineBreak + lineBreak)")
                        body.append(data)
                        body.appendString(lineBreak)
                    }
                }
            }
            
            if let fileModel {
                for fileModel in fileModel {
                    body.appendString("--\(boundary + lineBreak)")
                    body.appendString("Content-Disposition: form-data; name=\"\(fileModel.fileKeyName)\"; filename=\"\(fileModel.fileName)\"\(lineBreak)")
                    body.appendString("Content-Type: \(fileModel.mimeType + lineBreak + lineBreak)")
                    body.append(fileModel.file)
                    body.appendString(lineBreak)
                }
            }
            
            body.appendString("--\(boundary)--\(lineBreak)")
            
            self.httpBody = body
            self.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            self.addValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        }
        
        print("paramenterEncoding is", parameterEncoding)
        print("http paramters", parameters ?? [:])
        print("http body data", self.httpBody ?? Data())
    }
}
