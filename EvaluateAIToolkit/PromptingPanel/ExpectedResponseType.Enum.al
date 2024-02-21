enum 70100 ExpectedResponseType implements ISchemaTester
{
    Extensible = true;

    value(0; None) { Implementation = ISchemaTester = SchemaTesterNone; }
    value(1; JSON) { Implementation = ISchemaTester = SchemaTesterJSON; }
    value(2; XML) { Implementation = ISchemaTester = SchemaTesterXML; }
}