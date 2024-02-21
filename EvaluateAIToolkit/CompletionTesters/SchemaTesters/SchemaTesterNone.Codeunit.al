codeunit 70106 SchemaTesterNone implements ISchemaTester
{
    procedure LoadSchema(Schema: Text)
    begin
        // do nothing
    end;

    procedure Test(Completion: Text; var ErrorMessage: Text) IsSuccess: Boolean
    begin
        // do nothing
        ErrorMessage := ErrorMessage;
        exit(true);
    end;
}