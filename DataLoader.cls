Class City.DataLoader
{

ClassMethod LoadData() As %Status
{
    set status = $$$OK
    
    try {
        do ..ClearData()
        
        set city1 = ##class(City.City).%New()
        set city1.OfficialName = "New York"
        do city1.Aliases.Insert("NYC")
        do city1.Aliases.Insert("The Big Apple")
        do city1.Aliases.Insert("Gotham")
        do city1.Landmarks.SetAt("Statue of Liberty", "Liberty")
        do city1.Landmarks.SetAt("Central Park", "Park")
        do city1.Landmarks.SetAt("Empire State Building", "Empire")
        
        set desc1 = ##class(%Stream.GlobalCharacter).%New()
        do desc1.Write("New York City is the most populous city in the United States. ")
        do desc1.Write("Known for its iconic skyline, diverse culture, and as a global hub for finance.")
        set city1.Description = desc1
        
        set status = city1.%Save()
        quit:$$$ISERR(status)
        
        set avenue1 = ##class(City.Avenue).%New()
        set avenue1.Name = "Fifth Avenue"
        set avenue1.LengthKm = 10.5
        set avenue1.City = city1
        set avenue1.RoadType = "AV" 
        set status = avenue1.%Save()
        quit:$$$ISERR(status)
        
        set avenue2 = ##class(City.Avenue).%New()
        set avenue2.Name = "Park Avenue"
        set avenue2.LengthKm = 8.3
        set avenue2.City = city1
        set avenue2.RoadType = "AV"
        set status = avenue2.%Save()
        quit:$$$ISERR(status)
        
        set street1 = ##class(City.Street).%New()
        set street1.Name = "Wall Street"
        set street1.LengthKm = 1.2
        set street1.City = city1
        set street1.RoadType = "ST"
        set status = street1.%Save()
        quit:$$$ISERR(status)
        
        set segment1 = ##class(City.StreetSegment).%New()
        set segment1.SequenceNo = 1
        set segment1.StartPost = 1
        set segment1.EndPost = 50
        set segment1.Street = street1
        set status = segment1.%Save()
        quit:$$$ISERR(status)
        
        set segment2 = ##class(City.StreetSegment).%New()
        set segment2.SequenceNo = 2
        set segment2.StartPost = 51
        set segment2.EndPost = 100
        set segment2.Street = street1
        set status = segment2.%Save()
        quit:$$$ISERR(status)
        
        set street2 = ##class(City.Street).%New()
        set street2.Name = "Broadway"
        set street2.LengthKm = 21.0
        set street2.City = city1
        set street2.RoadType = "ST"
        set status = street2.%Save()
        quit:$$$ISERR(status)

        set segment3 = ##class(City.StreetSegment).%New()
        set segment3.SequenceNo = 1
        set segment3.StartPost = 1
        set segment3.EndPost = 100
        set segment3.Street = street2
        set status = segment3.%Save()
        quit:$$$ISERR(status)
        
        set segment4 = ##class(City.StreetSegment).%New()
        set segment4.SequenceNo = 2
        set segment4.StartPost = 101
        set segment4.EndPost = 200
        set segment4.Street = street2
        set status = segment4.%Save()
        quit:$$$ISERR(status)

        set city1.MainStreet = avenue1
        set status = city1.%Save()
        quit:$$$ISERR(status)
        
        set city2 = ##class(City.City).%New()
        set city2.OfficialName = "San Francisco"
        do city2.Aliases.Insert("SF")
        do city2.Aliases.Insert("The City by the Bay")
        do city2.Landmarks.SetAt("Golden Gate Bridge", "Bridge")
        do city2.Landmarks.SetAt("Alcatraz Island", "Alcatraz")
        
        set desc2 = ##class(%Stream.GlobalCharacter).%New()
        do desc2.Write("San Francisco is a cultural and financial center in Northern California. ")
        set city2.Description = desc2
        
        set status = city2.%Save()
        quit:$$$ISERR(status)
        
        set blvd1 = ##class(City.Boulevard).%New()
        set blvd1.Name = "Sunset Boulevard"
        set blvd1.LengthKm = 15.7
        set blvd1.City = city2
        set blvd1.RoadType = "BLVD"
        set status = blvd1.%Save()
        quit:$$$ISERR(status)
        
        set blvd2 = ##class(City.Boulevard).%New()
        set blvd2.Name = "Mission Boulevard"
        set blvd2.LengthKm = 12.4
        set blvd2.City = city2
        set blvd2.RoadType = "BLVD"
        set status = blvd2.%Save()
        quit:$$$ISERR(status)
        
        set city2.MainStreet = blvd2
        set status = city2.%Save()
        quit:$$$ISERR(status)
        
        
        write !, "Data loaded successfully!"
        write !, "Created 2 Cities (with MainStreet set)."
        write !, "Created 2 Avenues, 2 Boulevards, 2 Streets."
        write !, "Created 4 StreetSegments."
        
    } catch ex {
        set status = ex.AsStatus()
        write !, "Error: ", $System.Status.GetErrorText(status)
    }
    
    quit status
}

ClassMethod ClearData() As %Status
{
    set status = $$$OK
    try {
        do ##class(City.StreetSegment).%DeleteExtent()
        do ##class(City.Street).%DeleteExtent()
        do ##class(City.Boulevard).%DeleteExtent()
        do ##class(City.Avenue).%DeleteExtent()
        do ##class(City.Roadway).%DeleteExtent()
        do ##class(City.City).%DeleteExtent()
        
        write !, "Existing data cleared."
    } catch ex {
        set status = ex.AsStatus()
        write !, "Error clearing data: ", $System.Status.GetErrorText(status)
    }
    quit status
}

ClassMethod DisplayData() As %Status
{
    set status = $$$OK
    
    write !, "=== CITIES ==="
    set rs = ##class(%ResultSet).%New("City.City:Extent")
    do rs.Execute()
    while rs.Next() {
        set city = ##class(City.City).%OpenId(rs.Data("ID"))
        write !, "City: ", city.OfficialName
        
        if $IsObject(city.MainStreet) {
             write !, "  Main Street: ", city.MainStreet.Name
        } else {
             write !, "  Main Street: [Not Set]"
        }

        write !, "  Aliases: "
        for i=1:1:city.Aliases.Count() {
            write city.Aliases.GetAt(i), " "
        }
        write !
    }
    
    write !, "=== ROADWAYS ==="
    set rs = ##class(%ResultSet).%New("City.Roadway:Extent")
    do rs.Execute()
    while rs.Next() {
        set roadway = ##class(City.Roadway).%OpenId(rs.Data("ID"))
        write !, $ClassName(roadway), ": ", roadway.Name, " (", roadway.RoadType, ")"
        write " - ", roadway.LengthKm, " km"
    }

    write !, !, "=== STREET SEGMENTS ==="
    set rs = ##class(%ResultSet).%New("City.StreetSegment:Extent")
    do rs.Execute()
    while rs.Next() {
        set segment = ##class(City.StreetSegment).%OpenId(rs.Data("ID"))
        write !, "Segment ", segment.SequenceNo
        write " of ", segment.Street.Name
        write ": Posts ", segment.StartPost, "-", segment.EndPost
    }
    write !
    
    quit status
}
}