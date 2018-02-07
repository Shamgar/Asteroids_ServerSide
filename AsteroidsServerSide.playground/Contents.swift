import Vapor

extension Droplet {
    func setupRoutes() throws {
        //GET localhost/asteroidList/:startDate/:endDate/:id"
        
        //startDate    YYYY-MM-DD
        //endDate    YYYY-MM-DD
        //id    string
        get("asteroidList", ":startDate", ":endDate", ":id") {request in
            guard let startDate = request.parameters["startDate"]?.string,
                let endDate = request.parameters["endDate"]?.string, let id = request.parameters["id"]?.string else {
                    throw Abort.badRequest
            }
            print("startDate= ", startDate)
            print("endDate= ", endDate)
            print("id= ", id)
            return self.nasaGetRequest(startDate: startDate, endDate: endDate, id: id)
        }
        
        get("info") { req in
            return req.description
        }
        
        get("demo") { req in
            return "Mr.Anderson, welcome back. We missed you!"
        }
        
        print(self.router.routes)
        try resource("posts", PostController.self)
    }
}

extension Droplet {
    
    @discardableResult private func nasaGetRequest(startDate: String, endDate: String, id: String) -> Response {
        
        let endpoint = "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(startDate)&end_date=\(endDate)&api_key=\(id)"
        var res = Response(status: .ok)
        do {
            res = try self.client.get(endpoint)
        } catch {
            print(error)
            return Response(status: .forbidden)
        }
        return res
    }
}
