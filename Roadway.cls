Class City.Roadway Extends (%Persistent, %Populate) [ Abstract ]
{

Property Name As %String(MAXLEN = 120, MINLEN = 1, POPSPEC = "Street()") [ Required ];

Property LengthKm As %Numeric(MAXVAL = 200.0, MINVAL = 0.01, POPSPEC = "Float(0.1, 50)");

Relationship City As City.City [ Cardinality = one, Inverse = Roadways ];

Property FullDescription As %String [ Calculated, SqlComputeCode = { set {FullDescription} = {Name} _ " (" _ {LengthKm} _ " km)" }, SqlComputed ];

Method FullDescriptionGet() As %String
{
    Quit ..Name _ " (" _ ..LengthKm _ " km)"
}

}
