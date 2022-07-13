# GitHub Actions

:boom: GitHub Actions Testrepository :boom:

## The goal

I would like to do the following scenario with GitHub Actions, PowerShell and Pester:

````mermaid
sequenceDiagram
    actor User
    User->>main: New Issue
    main->>Action New issue: Trigger Action 'Checkout feature branch'
    Action New issue->>Feature branch: Check out feature branch
    Action New issue->>Feature branch: Add new Yaml-file
    Action New issue->>Feature branch: Push feature branch
    Action New issue->>Feature branch: Close Issue
    User->>Feature branch: Edit Yaml
    User->>main: Pull request
    main->>Action Pull request: Trigger Action 'Pull request'
    Action Pull request->>Feature branch: Checkout feature branch
    Action Pull request->>Feature branch: Invoke Pester Tests
    Action Pull request->>Feature branch: Upload Test-files
    Action Pull request-->>Feature branch: Merge pull request
    Feature branch-->>main: Merge and delete Feature branch
````

## Usage

### 1. Create a new issue with the name of a computer

A GitHub Action creates a new feature branch with en example Yaml-file.  

![GitHub issues](https://img.shields.io/github/issues-raw/tinuwalther/actionstest)

### 2. Edit the Yaml-file

Edit the Yaml-file, add more Yaml-files and create a Pull request with the name of the feature branch. After the feature branch is pushed to the repository, the issue will closed by the GitHub Action.

````markdown
- Name:      host2345
  IPAddress: 192.168.254.10
  Subnet:    255.255.255.0
  Gateway:   192.168.254.1
  Status:    new
 ````

### 3. Create a Pull request

The Pull request trigger a GitHub Action that runs Pester Tests, upload the result as Last-TestsReport.csv and Last-TestsReport.NUnitXml and update the table under Last Pester-run in the file README.md.

### 4. Merge the Pull Request

Merge the Pull Request manually. Later, this should be done with a GitHub Action too.

![GitHub last commit (branch)](https://img.shields.io/github/last-commit/tinuwalther/actionstest/main)

## Last Pester-run

Fore more information, see Reports/Last-TestsReport.csv

Last run (UTC)|Result|Total|Passed|Failed|Error|Skipped|NotRun
-|-|-|-|-|-|-|-
2022-07-05 13:29:45|Success|8|8|0|0|0|0
2022-07-13 10:15:29|Success|14|14|0|0|0|0
