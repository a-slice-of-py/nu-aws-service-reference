# nu-aws-service-reference
Browse and discover AWS Service Authorization Reference interactively in Nushell.

## Installation

Copy `awssr.nu` into one of your [`NU_LIB_DIRS`](https://www.nushell.sh/book/configuration.html#using-constants) and add `use awssr.nu` to your `config.nu`.

## Usage

```
> awssr <service> <action>

Parameters:
  service <string>: AWS service name (e.g. s3), supports tab completion and filtering
  action <string>: action name (e.g. ListBucket), supports tab completion only
```

## How it works

AWS service reference data are obtained programmatically via `http get` as suggested in the [AWS Service Authorization Reference docs](https://docs.aws.amazon.com/service-authorization/latest/reference/service-reference.html).

A table of the in-memory sqlite database is used to cache the list of services and corresponding reference URLs, as suggested in [nushell#12801](https://github.com/nushell/nushell/issues/12801#issuecomment-2676913305).

Each service action list is then served as [completion context](https://www.nushell.sh/book/custom_completions.html#context-aware-custom-completions).

The selected action reference is finally enriched with link to [Permissions](https://aws.permissions.cloud/) and displayed in the terminal.
