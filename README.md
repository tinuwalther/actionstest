# GitHub Actions

:boom: GitHub Actions Testrepository :boom:

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

The Pull request trigger a GitHub Action that run Pester Tests and upload the result as Last-TestsReport.csv and Last-TestsReport.NUnitXml.

### 4. Merge the Pull Request

Merge the Pull Request manually. Later, this should be done with a GitHub Action too.

![GitHub last commit (branch)](https://img.shields.io/github/last-commit/tinuwalther/actionstest/main)

## Last Pester-run

Fore more information, see Reports/Last-TestsReport.csv

Last run|Result|Total|Passed|Failed|Error|Skipped|NotRun
-|-|-|-|-|-|-|-
2022-07-04 11:44:23|Success|7|6|0|0|0|1
2022-07-05 13:07:45|Failure|26|19|3|0|0|4
