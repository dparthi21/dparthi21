Function MSTeamsNotification(){

[CmdletBinding()]
	param(
		[Parameter()]
		[string] $reportstaus
	)

$JSONBody = @{
    "@type"      = "MessageCard"
    "@context"   = "http://schema.org/extensions"
    "summary"    = "Bi Task Report to Microsoft Teams Channel...!"
    "title"      =  $reportstaus + "!!! Bi Task Report"
    "text"       = "For more information, please see deployment details"
}
$TeamMessageBody = ConvertTo-Json $JSONBody -Depth 100
 
$parameters = @{
    "URI"         = 'https://xome.webhook.office.com/webhookb2/c7d88b24-3a14-4a64-97e2-c753ab2bbd47@48e712aa-5a0a-4b80-892a-df758101d104/IncomingWebhook/d8a957098d4e4d0fa817945745a0d296/76425210-0dd9-4252-8967-493afe5cd4eb'
    "Method"      = 'POST'
    "Body"        = $TeamMessageBody
    "ContentType" = 'application/json'
}
Invoke-RestMethod @parameters

}

MSTeamsNotification -reportstaus "successfully Generated"