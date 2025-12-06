Class City.Tester
{

ClassMethod TestREST()
{
    Set req = ##class(%Net.HttpRequest).%New()
    Set req.Server = "localhost"
    Set req.Port = 52773 
    Set req.ContentType = "application/json"
    
    Do req.Delete("/api/city/city/RestCity")

    Write !, "--- 1. REST: Create City ---"
    Do req.EntityBody.Clear()
    Do req.EntityBody.Write({"OfficialName":"RestCity", "Coordinates":{"Latitude":10, "Longitude":10}}.%ToJSON())
    Do req.Post("/api/city/city")
    Do req.HttpResponse.Data.OutputToDevice()
    
    Write !!, "--- 2. REST: Get City (Check created) ---"
    Do req.Get("/api/city/city/RestCity")
    Do req.HttpResponse.Data.OutputToDevice()
    
    Write !!, "--- 3. REST: Update City ---"
    Do req.EntityBody.Clear()
    Do req.EntityBody.Write({"Coordinates":{"Latitude":99.9, "Longitude":88.8}}.%ToJSON())
    Do req.Put("/api/city/city/RestCity")
    Do req.HttpResponse.Data.OutputToDevice()

    Write !!, "--- 4. REST: Verify Update (Check changes) ---"
    Do req.Get("/api/city/city/RestCity")
    Do req.HttpResponse.Data.OutputToDevice()

    Write !!, "--- 5. REST: Delete City ---"
    Do req.Delete("/api/city/city/RestCity")
    Do req.HttpResponse.Data.OutputToDevice()

    Write !!, "--- 6. REST: Verify Delete (Expect 404) ---"
    Do req.Get("/api/city/city/RestCity")
    
    If req.HttpResponse.StatusCode = 404 {
        Write "SUCCESS: City not found (404) as expected."
    } Else {
        Write "FAILURE: City still exists or wrong error code: ", req.HttpResponse.StatusCode
    }
    Write !
}

ClassMethod TestSOAP()
{
    Try {
        Set client = ##class(City.SOAP.Client).%New() 
        
        Write !, "--- SOAP: Create ---"
        Write client.CreateCity("SoapCity", 50.5, 60.6)
        
        Write !, "--- SOAP: Get ---"
        Set city = client.GetCity("SoapCity")
        If $IsObject(city) {
            Write "Got city: ", city.OfficialName, " [", city.Coordinates.Latitude, "]", !
        }
        
        Write !, "--- SOAP: Update ---"
        Write client.UpdateCity("SoapCity", 11.1, 22.2)
        
        Write !, "--- SOAP: Delete ---"
        Write client.DeleteCity("SoapCity")
        
    } Catch ex {
        Write "SOAP Error: ", ex.DisplayString()
    }
}

}
