codeunit 70116 gpt35turbo16k implements IAOAIDeployment
{
    procedure GetEndpoint(): Text
    begin
        exit('https://bcaihackathon.openai.azure.com/');
    end;

    procedure GetDeployment(): Text
    begin
        exit('gpt-35-turbo-16k');
    end;

    procedure GetAPIKey(): SecretText
    begin
        exit(Format('7c77ad4735014e38b4336e578f78e938'));
    end;

    procedure MaxModelTokens(): Integer
    begin
        exit(16384);
    end;
}