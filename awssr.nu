const SERVICE_REFERENCE_TABLE_NAME = "_aws_service_reference"

def get-service-reference [] {
    try {
        stor open | query db $"select * from ($SERVICE_REFERENCE_TABLE_NAME)"
    } catch {
        stor create --table-name $SERVICE_REFERENCE_TABLE_NAME --columns {service: str, url: str}
        http get https://servicereference.us-east-1.amazonaws.com/ | from json | stor insert --table-name $SERVICE_REFERENCE_TABLE_NAME       
    }   
    stor open | query db $"select * from ($SERVICE_REFERENCE_TABLE_NAME)"
}

def services [] {
    get-service-reference | get service 
}

def service-actions [context: string] {
    let services = get-service-reference
    match ($context | split words | last) {
        $service => (
            http get ($services | where service == $service | get url.0) | get Actions.Name
        )
    }
}

# Browse and discover AWS Service Authorization Reference interactively in Nushell.
# 
# Recursively read and parse data from https://servicereference.us-east-1.amazonaws.com/
# to obtain service actions reference, enrich it with link to
# https://aws.permissions.cloud/ and display in the terminal.
# For caching, store the parent reference in a table of the in-memory sqlite database.
export def main [
    service: string@services # AWS service name (e.g. s3), supports tab completion and filtering
    action: string@service-actions # action name (e.g. ListBucket), supports tab completion only
] {
    let service_url = get-service-reference | where service == $service | get url.0
    let service_actions = http get $service_url
    (
        $service_actions
        | get Actions
        | where Name == $action
        | upsert Name (
            $"https://aws.permissions.cloud/iam/($service)#($service)-($action)"
            | ansi link --text $'(ansi xterm_orange1)($action)'
        )
    )
}
