Class City.City Extends (%Persistent, %Populate)
{

Property OfficialName As %String(MAXLEN = 80, MINLEN = 2, POPSPEC = "City()") [ Required ];

Property MainStreet As City.Roadway;

Property Coordinates As City.Coordinates;

Property Aliases As list Of %String(MAXLEN = 50);

Property Landmarks As array Of %String(MAXLEN = 80, POPSPEC = "Mission():5");

Property Description As %Stream.GlobalCharacter;

Relationship Roadways As City.Roadway [ Cardinality = many, Inverse = City ];

Index NameIdx On OfficialName [ Unique ];

}
