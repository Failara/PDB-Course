Class City.REST.Client
{

Parameter SERVER = "localhost";

Parameter PORT = 52773;

// Change to your port

Parameter BASEURL = "/csp/cityapi";

ClassMethod SendRequest(method As %String, url As %String, body As %DynamicObject = "")
{
    Set req = ##class(%Net.HttpRequest).%New()
    Set req.Server = ..#SERVER
    Set req.Port = ..#PORT
    Set req.ContentType = "application/json"
    
    If $IsObject(body) {
        Do req.EntityBody.Write(body.%ToJSON())
    }
    
    // Perform request
    Set type = $Case(method, "GET":1, "POST":2, "PUT":3, "DELETE":4, :0)
    
    If type=1 Set sc = req.Get(..#BASEURL_url)
    If type=2 Set sc = req.Post(..#BASEURL_url)
    If type=3 Set sc = req.Put(..#BASEURL_url)
    If type=4 Set sc = req.Delete(..#BASEURL_url)
    
    If $$$ISOK(sc) {
        If $IsObject(req.HttpResponse) {
            Write "Status: ", req.HttpResponse.StatusCode,!
            Write "Response: "
            Do req.HttpResponse.Data.OutputToDevice()
            Write !
        }
    } Else {
        Do $System.Status.DisplayError(sc)
    }
}

ClassMethod TestAll()
{
    Write "--- 1. Get All Cities ---",!
    Do ..SendRequest("GET", "/cities")
    
    Write !, "--- 2. Create 'RestCity' ---",!
    Set obj = {"OfficialName":"RestCity", "Coordinates":{"Latitude":50, "Longitude":50}}
    Do ..SendRequest("POST", "/city", obj)
    
    Write !, "--- 3. Get 'RestCity' ---",!
    Do ..SendRequest("GET", "/city/RestCity")
    
    Write !, "--- 4. Update 'RestCity' ---",!
    Set updateObj = {"Coordinates":{"Latitude":51.5, "Longitude":50.5}}
    Do ..SendRequest("PUT", "/city/RestCity", updateObj)
    
    Write !, "--- 5. Delete 'RestCity' ---",!
    Do ..SendRequest("DELETE", "/city/RestCity")
}

}
