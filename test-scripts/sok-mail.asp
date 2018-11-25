<%

sTo = "admin@serverok.in"
sFrom = "info@itsolexpert.com"
sSubject = "Test Subject " & Now()
sBody = "Test Body Message."
EmailSendingModule = 2

Dim Mail
set Mail=server.createobject("CDO.Message")
Mail.From = sFrom
Mail.To= sTo
Mail.Subject = sSubject
Mail.TextBody = sBody
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.itsolexpert.com"
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = "info@itsolexpert.com"
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "1l0v3y0u"

Mail.Configuration.Fields.Update
Mail.Send
set Mail=nothing

%>
Email sent.