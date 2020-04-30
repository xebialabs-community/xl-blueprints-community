# aws-ec2wildfly-app-demo

## Introduction

This blueprint demo will show you how to download, customize and then apply a blueprint to XL Release and XL Deploy. The applied blueprint configures an XL Release \ XL Deploy deployment pipeline that can be used to spin up an instance of an AWS Wildfly AMI in your AWS account and then deploy a simple application to that instance.

For the sake of convenience, this project also includes the files necessary to run XL Deploy and XL Release in Docker containers.

## Before you get started

If you're new to XebiaLabs blueprints, check out:

* [Get started with DevOps as Code](https://docs.xebialabs.com/xl-release/concept/get-started-with-devops-as-code.html)
* [Get started with blueprints](https://docs.xebialabs.com/xl-release/concept/get-started-with-blueprints.html)

## Prerequisites

### XebiaLabs Prerequisites

You will need to install the [XebiaLabs XL CLI tool](https://docs.xebialabs.com/v.9.5/xl-release/how-to/install-the-xl-cli/).

### Docker Prerequisites

The XebiaLabs Dev Ops Platform - XL Release and XL Deploy - can be run in Docker containers using the docker-compose file included in this project. You will need to have [Docker Desktop](https://www.docker.com/products/docker-desktop) installed.

### AWS Prerequisites

This demo requires that you have an AWS account and have the AWS credentials including an AWS access key ID and AWS secret access key. Note: In a scenario in which you are already interacting with AWS using the AWS CLI, the blueprint configuration can pull existing credentials from your local configuration. If not, you can provide the credentials directly when running the blueprint.
[More information about creating an AWS Key ID and Secret Access Key](https://aws.amazon.com/premiumsupport/knowledge-center/create-access-key/)

XL Deploy will interact with the AWS instance via SSH so you will need to create and download an AWS key pair for the AWS region you plan to deploy to. If you already have a key pair there is no need to create a new one.
[More information about creating an AWS key pair](https://docs.bitnami.com/aws/get-started-console/#step-2-generate-an-aws-key-pair)

You will need to create a security group within your AWS account that allows access to port 80 (http) and port 22 (ssh). 
[More information about creating a security group](https://docs.bitnami.com/aws/get-started-console/#step-3-create-an-aws-security-group)

By default, this blueprint uses a 'free of charge' Bitnami AMI to create the Wildfly server (version 19) in AWS. It may be necessary to subscibe to this image first via the [AWS marketplace](https://aws.amazon.com/marketplace/pp/B00NN8XQWU?qid=1588103837986&sr=0-1&ref_=srh_res_product_title). If you wish to use a different AMI, you will be given an opportunity to indicate that during blueprint configuration.

## Security warning

This demonstration blueprint will store your AWS Access Key and Secret Key in plain text in a file called xebialabs/secrets.xlvals. The password for the dynamically created Wildfly admin user is also displayed in plain text within XL Deploy and XL Release. This is not production-level secure. If you wish to use a more secure method for dealing with secrets and passwords, refer to the showcases/dictionaries-and-secret-stores blueprint in the [XebiaLabs official blueprint repository](https://github.com/xebialabs/blueprints/tree/master/showcases/dictionaries-and-secret-stores) for a demonstration that uses CyberArk Conjur or HashiCorp Vault to better store and handle secrets.

### Information you will need before beginning

As part of the blueprint download/customization process, you will need to answer a few questions. It is best to have these answers at hand before you start.

If, during blueprint configuration, you indicate that you wish to use your previously installed AWS CLI configuration, that AWS Access Key and Secret will be used automatically, without having to manually enter the values. Otherwise you will need to supply:

1. AWS Access Key ID
2. AWS Secret Access Key

Additionally, you will need the following information;

1. The AWS Region your account operates within
2. The AWS Security Group ID - this group must allow access to ports 80 and 22
3. The AWS Market Place AMI ID - the blueprint defaults to ID ami-08774d91adb972d1d, which references a 'free of charge' Bitnami Wildfly AMI
4. Information about your AWS Key Pair File
   1. The Key File Name - DO NOT include the .pem extension
   2. The full path to the directory where your key file is stored - Be sure to include the trailing / character, as in '/User/username/.ssh/'

## Usage

To use this blueprint/demo, you will need to perform the following steps:

1. Set up a new configuration file for your XL CLI tool
   1. The default configuration is set up to interact with the official XebiaLabs blueprint repository and your local installations of XL Release and XL Deploy. Since this blueprint is stored in the XebiaLabs Community blueprint repository, you will need to set up an alternative config file. The new config file will also be set up to interact with the XL Deploy and XL Release instances running in the Docker containers that you will use for this blueprint demo.
      1. Make a copy of the current XL CLI configuration file found in the hidden directory in your user home directory  ~/.xebialabs/config.yaml
      2. Name the copy communityConfig.yaml
      3. Edit it so it contains these values:

```yaml
blueprint:
  current-repository: XL Blueprints Community
  repositories:
  - name: XL Blueprints Community
    type: http
    url: https://xebialabs-community.github.io/xl-blueprints-community/
xl-deploy:
  authmethod: http
  password: admin
  url: http://localhost:14516/
  username: admin
xl-release:
  authmethod: http
  password: admin
  url: http://localhost:15516/
  username: admin
```

* You can now download the blueprint:
   1. Within a terminal window, create an empty directory and cd into it.
   2. Using the XL CLI tool, run the 'blueprint' command, while setting the configuration file to communityConfig.yaml:

```bash
   <path to your XL CLI Tool directory>/xl --config ~/.xebialabs/communityConfig.yaml blueprint
```

* Configure the blueprint:
   1. You will be presented with a list of the blueprints available in the community blueprint repository
   2. Choose the aws-ec2wildfly-app-demo blueprint
   3. Answer the questions

* Start up the XebiaLabs dev-ops platform in Docker
  1. In a terminal cd into the directory where you downloaded the blueprint and then cd into the docker directory
  2. Run

```plain
docker-compose up
```

* When XL Release and XL Docker have finished starting up, you can log into both of them using the credentials admin/admin. XL Release is accessible at this url: http://localhost:15516 and XL Deploy at: http://localhost:14516. You should see that XL Release has already be configured with a shared configuration connecting it to the XL Deploy instance running in Docker.
  
* You can now apply the newly configured blueprint to XL Release and XL Deploy by opening a terminal, cd into your blueprint directory, then run

```bash
    <path to your XL CLI Tool directory>/xl --config ~/.xebialabs/communityConfig.yaml apply
```

* Log into XL Release and run a release from the template 'Deploy Pet Clinic to AWS'
* The first phase in the release will perform a couple of XL Deploy 'deploy' tasks that will create the environment and then deploy the application to AWS.
* The next phase is a manual step wherein you will confirm that the deployment to AWS was successful.
* Once you have indicated that the deployment was successful, the next phase will automatically run undeploy tasks to tear down and clean up the demo deployment.

When all phases have run you can stop the XL Release and XL Deploy instances by running the following command in a terminal opened in your blueprint/docker directory:

```bash
   docker-compose down -v
```

Finally, log into your AWS account to ensure all instances have been stopped and have been removed.

## Minimum required versions

This blueprint version has been tested with the following versions of the XebiaLabs Platform:

* XL Deploy: Version 9.5.0
* XL Release: Version 9.5.0
* XL CLI: Version 9.0.0
