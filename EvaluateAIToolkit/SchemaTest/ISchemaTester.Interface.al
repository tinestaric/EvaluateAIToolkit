interface ISchemaTester
{
    procedure Initialize(ResultLogger: Codeunit ResultLogger)
    procedure LoadSchema(Schema: Text)
    procedure Test(Completion: Text) IsSuccess: Boolean
}