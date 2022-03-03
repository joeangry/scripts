<#
    Useful for cleaning up old workflow files 
#>

# Get all run ids from the specified workflow_id
function GetWorkFlowRuns($owner, $repository, $workflow_id)
{
    return gh api repos/$owner/$repository/actions/workflows/$workflow_id/runs --jq '.workflow_runs[].id'
}

function DeleteWorkflowRun($owner, $repository, $workflow_run_id)
{
    Write-Host "Deleting run $workflow_run_id"
    gh api repos/$owner/$repository/actions/runs/$workflow_run_id -X DELETE
    Write-Host "Deleted run $workflow_run_id"
}

$github_runs = GetWorkFlowRuns("my-user", "my-repository")

foreach ($run_id in $github_runs)
{
    DeleteWorkflowRun("", "", $run_id)
}
