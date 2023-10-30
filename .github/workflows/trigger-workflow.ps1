# GitHub information
$GitHubUsername = "Kathir2804"
$GitHubRepo = "testautomate-deploy"
$WorkflowID = "devtest.yaml"
$PAT = "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"

# GitHub API endpoint for triggering a workflow dispatch
$ApiEndpoint = "https://api.github.com/repos/$GitHubUsername/$GitHubRepo/actions/workflows/$WorkflowID/dispatches"


# JSON payload to specify the branch or reference
$JsonPayload = @{
    ref = "test-dev"
}

# Send a POST request to trigger the workflow
$Headers = @{
    Authorization = "token $PAT"
    Accept = "application/vnd.github.v3+json"
}
Invoke-RestMethod -Uri $ApiEndpoint -Method POST -Headers $Headers -ContentType "application/json" -Body ($JsonPayload | ConvertTo-Json)
