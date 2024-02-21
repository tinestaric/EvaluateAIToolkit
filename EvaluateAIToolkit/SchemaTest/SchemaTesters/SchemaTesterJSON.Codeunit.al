codeunit 70107 SchemaTesterJSON implements ISchemaTester
{
    var
        _SchemaJSONMgt: Codeunit "JSON Management";
        _ResultLogger: Codeunit ResultLogger;

    procedure Initialize(ResultLogger: Codeunit ResultLogger)
    begin
        _ResultLogger := ResultLogger;
    end;

    procedure LoadSchema(Schema: Text)
    begin
        _SchemaJSONMgt.InitializeObject(Schema);
    end;

    procedure Test(Completion: Text) IsSuccess: Boolean
    begin
        _ResultLogger.LogResult(true, '');
        exit(true);
    end;
}