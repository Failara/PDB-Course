Class City.SOAP.Client Extends %SOAP.WebClient
{

// ADJUST THIS PORT TO MATCH YOUR SYSTEM (e.g., 52773 or 57772)

Parameter LOCATION = "http://localhost:52773/csp/user/City.SOAP.Service.cls";

Parameter NAMESPACE = "http://tempuri.org";

Parameter SERVICENAME = "CityService";

Method CreateCity(name As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
        Quit ..WebMethod("CreateCity").Invoke($this,"http://tempuri.org/City.SOAP.Service.CreateCity",.name)
}

}
