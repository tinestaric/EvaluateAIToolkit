namespace EvaluateAIToolkit.Common;

using System.AI;

codeunit 70100 "Register Capability"
{
    Subtype = Install;
    InherentEntitlements = X;
    InherentPermissions = X;
    Access = Internal;

    trigger OnInstallAppPerDatabase()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        LearnMoreUrlTxt: Label 'https://example.com/CopilotToolkit', Locked = true;
    begin
        if not CopilotCapability.IsCapabilityRegistered("Copilot Capability"::EvaluateAIToolkit) then
            CopilotCapability.RegisterCapability("Copilot Capability"::EvaluateAIToolkit, LearnMoreUrlTxt);
    end;
}