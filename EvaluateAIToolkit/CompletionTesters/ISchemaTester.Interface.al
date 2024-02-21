interface ISchemaTester
{
    procedure LoadSchema(Schema: Text)
    procedure Test(Completion: Text; var ErrorMessage: Text) IsSuccess: Boolean
}