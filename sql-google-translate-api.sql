CREATE FUNCTION [dbo].[TRANSLATE] (@SENTENCE AS nVARCHAR(MAX),@SOURCELANG AS VARCHAR(10),@DESTLANG AS VARCHAR(10))
RETURNS VARCHAR(MAX)
AS
BEGIN
 
DECLARE @RESULT AS VARCHAR(MAX)
DECLARE @JSON AS VARCHAR(MAX)
Declare @Object as Int;
Declare @ResponseText as Varchar(8000);
DECLARE @hResult int
DECLARE @source varchar(255), @desc varchar(255) 
declare @Body as varchar(8000) = 
'{
    "Subsystem": 1,
    "Exception": "",
    "Message": "'+@SENTENCE+'",
    "Time": "2014-06-09T11:16:35",
    "Attribute": { "Number of attempts": "0" }
}' 
DECLARE @URL AS VARCHAR(MAX)='https://translation.googleapis.com/language/translate/v2/?q=%27+%40SENTENCE+%27&source=%27+%40sourcelang+%27&target=%27+%40destlang+%27&key=AIzaSyAnetSocg5kj.....%27'
Exec sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'open', NULL, 'GET', 
    @URL, 'false'
Exec sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'

declare @len int
set @len = len(@body)
--EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Length', @len
--Exec sp_OAMethod @Object, 'setRequestBody', null, 'Body', @body
EXEC sp_OAMethod @Object, 'send', null
Exec sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT

 SET @JSON= @ResponseText

DECLARE @PATTERN AS VARCHAR(100)='"translatedText": "'
DECLARE @POS1 AS INT=CHARINDEX(@PATTERN,@JSON)
SET @POS1=@POS1+LEN(@PATTERN)
SET @JSON=SUBSTRING(@JSON,@POS1,LEN(@JSON)-@POS1)
SET @POS1=CHARINDEX('}',@JSON)
SET @JSON=LEFT(@JSON,@POS1-2 )
SET @JSON=REPLACE(@JSON,'"','')
SET @JSON=LTRIM(RTRIM(@JSON))

RETURN  @JSON

END
