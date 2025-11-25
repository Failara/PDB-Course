Class City.City Extends (%Persistent, %Populate)
{
Property OfficialName As %String(MINLEN=2, MAXLEN=80) [ Required ];

/// Alternative names (collection-list of simple type)
Property Aliases As list Of %String(MAXLEN=50);

/// Notable features (collection-array of simple type)
Property Landmarks As array Of %String(MAXLEN=80);

/// Free-form description (character stream)
Property Description As %Stream.GlobalCharacter;

/// One-to-many: City -> Roadways
Relationship Roadways As City.Roadway [ Cardinality = many, Inverse = City ];

Index NameIdx On (OfficialName);

}
