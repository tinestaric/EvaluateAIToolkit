table 60100 GeneratedEmail
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; GenerationId; Integer) { Caption = 'Generation Id'; }
        field(20; Content; Blob) { Caption = 'Content'; }
    }

    keys
    {
        key(Key1; GenerationId)
        {
            Clustered = true;
        }
    }

    internal procedure GetContent(): Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(Content);
        Rec.Content.CreateInStream(InStr);
        exit(ReadBlob(InStr));
    end;

    local procedure ReadBlob(InStr: InStream) OutText: Text
    var
        Text: Text;
    begin
        while not InStr.EOS do begin
            InStr.ReadText(Text);
            OutText += Text;
        end;
    end;

    internal procedure SetContent(Value: Text)
    var
        OutStr: OutStream;
    begin
        Clear(Rec.Content);
        Rec.Content.CreateOutStream(OutStr);
        OutStr.WriteText(Value);
    end;
}