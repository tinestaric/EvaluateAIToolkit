codeunit 70107 SchemaTesterJSON implements ISchemaTester
{
    var
        SchemaJSONMgt: Codeunit "JSON Management";

    procedure LoadSchema(Schema: Text)
    begin
        SchemaJSONMgt.InitializeObject(Schema);
    end;

    procedure Test(Completion: Text) IsSuccess: Boolean
    begin
        //TODO: Implement the test        

        exit(true);
    end;
}