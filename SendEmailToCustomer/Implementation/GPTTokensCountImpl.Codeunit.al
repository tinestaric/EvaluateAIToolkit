codeunit 60101 GPTTokensCountImpl
{
    procedure PreciseTokenCount(Input: Text): Integer
    var
        RestClient: Codeunit "Rest Client";
        Content: Codeunit "Http Content";
        JContent: JsonObject;
        JTokenCount: JsonToken;
        UriTok: Label 'https://azure-openai-tokenizer.azurewebsites.net/api/tokensCount', Locked = true;
    begin
        exit(0);
        JContent.Add('text', Input);
        Content.Create(JContent);
        RestClient.Send("Http Method"::GET, UriTok, Content).GetContent().AsJson().AsObject().Get('tokensCount', JTokenCount);
        exit(JTokenCount.AsValue().AsInteger());
    end;

    procedure ListTokens(Input: Text) TokenList: List of [Text]
    var
        RestClient: Codeunit "Rest Client";
        Content: Codeunit "Http Content";
        JContent: JsonObject;
        JTokenArray: JsonToken;
        JToken: JsonToken;
        UriTok: Label 'https://azure-openai-tokenizer.azurewebsites.net/api/tokens', Locked = true;
        i: Integer;
    begin
        JContent.Add('text', Input);
        Content.Create(JContent);
        RestClient.Send("Http Method"::GET, UriTok, Content).GetContent().AsJson().AsObject().Get('tokens', JTokenArray);

        for i := 0 to JTokenArray.AsArray().Count - 1 do begin
            JTokenArray.AsArray().Get(i, JToken);
            TokenList.Add(JToken.AsValue().AsText());
        end;
    end;
}