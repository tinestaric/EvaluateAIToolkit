codeunit 70107 SchemaTesterJSON implements ISchemaTester
{
    var
        _SchemaJSONMgt: Codeunit "JSON Management";

    procedure LoadSchema(Schema: Text)
    begin
        _SchemaJSONMgt.InitializeObject(Schema);
    end;

    procedure Test(Completion: Text; var ErrorMessage: Text) IsSuccess: Boolean
    begin
        ErrorMessage := ErrorMessage;
        exit(true);
    end;
}