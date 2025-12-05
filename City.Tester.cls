Class City.Tester
{

/// Run this to test REST
ClassMethod TestREST()
{
    Set req = ##class(%Net.HttpRequest).%New()
    Set req.Server = "localhost"
    Set req.Port = 52773 // Переконайтеся, що порт правильний (той самий, що в URL порталу)
    Set req.ContentType = "application/json"
    
    Write !, "--- REST: Create ---"
    Do req.EntityBody.Write({"OfficialName":"RestCity", "Latitude":50, "Longitude":50}.%ToJSON())
    
    // Виконуємо запит і перевіряємо статус
    Set sc = req.Post("/api/city/city")
    
    If $$$ISERR(sc) {
        Write !, "CONNECTION ERROR: ", $System.Status.GetErrorText(sc)
    } ElseIf (req.HttpResponse.StatusCode '= 200) && (req.HttpResponse.StatusCode '= 201) {
        Write !, "HTTP ERROR: ", req.HttpResponse.StatusCode, " ", req.HttpResponse.ReasonPhrase
        If $IsObject(req.HttpResponse.Data) Do req.HttpResponse.Data.OutputToDevice()
    } Else {
        // Все добре, виводимо відповідь
        Do req.HttpResponse.Data.OutputToDevice()
    }
    
    Write !!, "--- REST: Get ---"
    Set sc = req.Get("/api/city/city/RestCity")
    If $$$ISOK(sc) && (req.HttpResponse.StatusCode = 200) {
        Do req.HttpResponse.Data.OutputToDevice()
    } Else {
        Write "Error getting data."
    }
    Write !
}

/// Run this to test SOAP
ClassMethod TestSOAP()
{
    Try {
        Set client = ##class(City.SOAP.Client).%New()
        Write !, "--- SOAP: Create ---"
        Write client.CreateCity("SoapCity")
    } Catch ex {
        Write "Error: ", ex.DisplayString()
    }
}

}
