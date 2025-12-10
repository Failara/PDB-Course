Class City.City Extends (%Persistent, %Populate, %XML.Adaptor, %JSON.Adaptor)
{

Property OfficialName As %String(MAXLEN = 80, MINLEN = 2, POPSPEC = "City()") [ Required ];

Property MainStreet As City.Roadway;

Property Coordinates As City.Coordinates;

Property Aliases As list Of %String(MAXLEN = 50);

Property Landmarks As array Of %String(MAXLEN = 80, POPSPEC = "Mission():5");

Property Description As %Stream.GlobalCharacter;

Property LastUpdated As %TimeStamp;

Relationship Roadways As City.Roadway [ Cardinality = many, Inverse = City ];

Index IDKEY On OfficialName [ IdKey ];

Query FindByName(name As %String) As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, OfficialName, Coordinates_Latitude, Coordinates_Longitude
    FROM City.City
    WHERE OfficialName %STARTSWITH :name
    ORDER BY OfficialName
}

ClassMethod GetAliasesDynamic(cityName As %String)
{
    Set sql = "SELECT Aliases FROM City.City WHERE OfficialName = ?"
    Set tStatement = ##class(%SQL.Statement).%New()
    Set tStatus = tStatement.%Prepare(sql)
    
    If $$$ISERR(tStatus) { Do $System.Status.DisplayError(tStatus) Quit }
    
    Set rset = tStatement.%Execute(cityName)
    
    Write "Aliases for ", cityName, ": ",!
    While rset.%Next() {
        Write rset.%Get("Aliases"),!
    }
}

Trigger LogModification [ Event = UPDATE, Foreach = row/object, Time = AFTER ]
{
    Set ^CityLog({ID}, $ZTIMESTAMP) = "Updated. New Timestamp: " _ {LastUpdated}
}

Storage Default
{
<Data name="CityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MainStreet</Value>
</Value>
<Value name="3">
<Value>Coordinates</Value>
</Value>
<Value name="4">
<Value>Aliases</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>LastUpdated</Value>
</Value>
</Data>
<Data name="Landmarks">
<Attribute>Landmarks</Attribute>
<Structure>subnode</Structure>
<Subscript>"Landmarks"</Subscript>
</Data>
<DataLocation>^City.CityD</DataLocation>
<DefaultData>CityDefaultData</DefaultData>
<IdLocation>^City.CityD</IdLocation>
<IndexLocation>^City.CityI</IndexLocation>
<StreamLocation>^City.CityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
