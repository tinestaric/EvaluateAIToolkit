enum 70100 ExpectedResponseType implements ISchemaTester
{
    Extensible = true;

    value(0; None) { Caption = 'None'; Implementation = ISchemaTester = SchemaTesterNone; }
    value(1; JSON) { Caption = 'JSON'; Implementation = ISchemaTester = SchemaTesterJSON; }
    value(2; XML) { Caption = 'XML'; Implementation = ISchemaTester = SchemaTesterXML; }
}