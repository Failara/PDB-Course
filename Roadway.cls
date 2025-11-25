Class City.Roadway Extends (%Persistent, %Populate) [ Abstract ]
{

Property Name As %String(MINLEN=1, MAXLEN=120) [ Required ];

Property LengthKm As %Numeric(MINVAL=0.01, MAXVAL=200.0);

Relationship City As City.City [ Cardinality = one, Inverse = Roadways ];

}
