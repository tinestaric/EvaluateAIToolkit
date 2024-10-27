codeunit 70120 gpt4omini implements IAOAIDeployment
{
    procedure GetEndpoint(): Text
    begin
        exit('https://bcaihackathon.openai.azure.com/');
    end;

    procedure GetDeployment(): Text
    begin
        exit('gpt-4o-mini');
    end;

    procedure GetAPIKey(): SecretText
    begin
    end;

    procedure MaxModelTokens(): Integer
    begin
        exit(128000);
    end;
}