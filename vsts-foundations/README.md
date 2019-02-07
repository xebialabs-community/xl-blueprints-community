# VSTS Foundations

This is a blueprint for Azure DevOps (VSTS), which includes automated interaction with VSTS work items, builds, and deployments.  Azure account details are required upon blueprint creation, while the team project name, build definition name, release definition name, and environment names are all provided to XLR at runtime.   

## Prerequisites

1. Azure DevOps (VSTS) instance with:
   1. A build definition
   1. A release definition
   1. A username and token pair for connections
      1. This API token needs to have full read/write access to work items, builds, and releases
1. XL Release version 8.5.0 or newer
1. XL Release VSTS plugin also 8.5.0 or newer (built-in)

## Usage

```
xl --blueprint-repository-url http://BLUEPRINTREPO blueprint
? Choose a blueprint: vsts
? What is the VSTS server URL (this should take the form of https://example.visualstudio.com)? https://example.visualstudio.com
? What is the VSTS username? azure@example.com
? What is the VSTS API token? ***************************************************
? Confirm to generate blueprint files? Yes
```