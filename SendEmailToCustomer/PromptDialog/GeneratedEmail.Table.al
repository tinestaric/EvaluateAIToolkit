table 60100 GeneratedEmail
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; GenerationId; Integer) { Caption = 'Generation Id'; }
        field(20; Greeting; Text[150]) { Caption = 'Greeting'; }
        field(30; Content; Text[2048]) { Caption = 'Content'; }
        field(40; Signature; Text[250]) { Caption = 'Signature'; }
    }

    keys
    {
        key(Key1; GenerationId)
        {
            Clustered = true;
        }
    }
}