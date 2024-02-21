codeunit 70115 gpt432k implements IAOAIDeployment
{
    procedure GetEndpoint(): Text
    begin
        exit('https://bcaihackathon.openai.azure.com/');
    end;

    procedure GetDeployment(): Text
    begin
        exit('gpt-4-32k');
    end;

    procedure GetAPIKey(): SecretText
    begin
    end;

    procedure MaxModelTokens(): Integer
    begin
        exit(32768);
    end;
}