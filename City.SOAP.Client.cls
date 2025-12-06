Class City.SOAP.Client Extends %SOAP.WebClient
{

Parameter LOCATION = "http://localhost:52773/csp/user/City.SOAP.Service.cls";

Parameter NAMESPACE = "http://tempuri.org";

Parameter SERVICENAME = "CityService";

Method CreateCity(name As %String, lat As %Numeric, lon As %Numeric) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
    Quit ..WebMethod("CreateCity").Invoke($this,"http://tempuri.org/City.SOAP.Service.CreateCity",.name,.lat,.lon)
}

Method GetCity(name As %String) As City.City [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
    Quit ..WebMethod("GetCity").Invoke($this,"http://tempuri.org/City.SOAP.Service.GetCity",.name)
}

Method UpdateCity(name As %String, lat As %Numeric, lon As %Numeric) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
    Quit ..WebMethod("UpdateCity").Invoke($this,"http://tempuri.org/City.SOAP.Service.UpdateCity",.name,.lat,.lon)
}

Method DeleteCity(name As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
    Quit ..WebMethod("DeleteCity").Invoke($this,"http://tempuri.org/City.SOAP.Service.DeleteCity",.name)
}

}
