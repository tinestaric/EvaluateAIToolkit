interface ISchemaTester
{
    procedure LoadSchema(Schema: Text)
    procedure Test(Completion: Text) IsSuccess: Boolean
}