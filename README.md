# GitHub Actions

GitHub Actions Testrepository.

## Structure

- .github (Workflows)
- Bin (PowerShell-Scripts)
- Nodes (Node.yml)
- Tests (Pester-Tests)
- whatever (Your turn)

## Issues

Every new issue create a new feature branch. The name of the issue is also the name of the feature branch.

![GitHub issues](https://img.shields.io/github/issues-raw/tinuwalther/actionstest)

## Branch

Every new feature branch contains an example.yml. The name of the issue is also the name of the new YAML-file and the value of the field Name inside the YAML-file. After the feature branch is pushed to the repository, the issue will closed by the GitHub Action.

````markdown
- Name: host2345
  IPAddress: 192.168.254.10
  Subnet: 255.255.255.0
  Gateway: 192.168.254.1
  Status: new
 ````

## Merge

Every merge request runs Pester-Tests and should do some other magic things... 

![GitHub last commit (branch)](https://img.shields.io/github/last-commit/tinuwalther/actionstest/main)
