# nu-aws-service-reference
Browse and discover AWS Service Authorization Reference interactively in Nushell.

Recursively read and parse data from [AWS service reference](https://servicereference.us-east-1.amazonaws.com/) to obtain service actions reference, enrich it with link to [Permissions](https://aws.permissions.cloud/) and display in the terminal.
For caching, store the parent reference in a table of the in-memory sqlite database.

## Installation

Copy `awssr.nu` into one of your [`NU_LIB_DIRS`](https://www.nushell.sh/book/configuration.html#using-constants) and add `use awssr.nu` to your `config.nu`.

## Usage

```nushell
Usage:
  > awssr <service> <action>

Parameters:
  service <string>: AWS service name (e.g. s3), supports tab completion and filtering
  action <string>: action name (e.g. ListBucket), supports tab completion only
```
