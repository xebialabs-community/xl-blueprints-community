# XebiaLabs Blueprints

Blueprint definitions for xl-cli. These files will be synced to [https://xebialabs-community.github.io/xl-blueprints-community/](https://xebialabs-community.github.io/xl-blueprints-community/) and can be used as xl-cli blueprint repository (using `xl blueprint --blueprint-repository-url https://xebialabs-community.github.io/xl-blueprints-community/`).

## Blueprint Development

To develop new blueprints, fork the blueprints repository then do the following...
1. Run a web server container to serve content from your local blueprints directory.  The easiest approach is to use the included `docker-compose.yml` file to start an Apache web server as follows:
    ```
    docker-compose up
    ```
1. Edit config.yaml to point to your local XL Release and XL Deploy instances and the above http server
1. Create a directory for your new blueprint, e.g. `conjur`
1. Create a `xebialabs` directory for templates in your blueprint directory, e.g. `conjur/xebialabs`
  * **Note:** The directory must be called `xebialabs` or the secrets handling will not work
1. Add `blueprint.yaml` to your blueprint directory
1. Add one or more templates to the templates directory
1. Edit the `index.json` to include your blueprint directory
1. Test your blueprint by running with the local files, output yaml will be found in the blueprint `xebialabs` directory:
    ```
    ./xl --config config.yaml blueprint
    ```
1. Apply your generated .yaml(s) to XL tools:
    ```
    ./xl --config ./config.yaml apply -f ./xebialabs/<your template>.yaml
    ```
1. Once development is complete, commit and push the changes


## Docker
To host your blueprints locally, you can use the `Dockerfile` to run an Apache server:
1. Build and run: `docker build -t blueprints . && docker run -p 8080:80 -it blueprints`
1. Use a blueprint `xl blueprint --blueprint-repository-url http://localhost:8080`


## Publish

Any changes that are dependent on a new XL CLI version should be done only on the development branch. Master branch should only contain published changes. Development branch needs to be synced to master during every official XL-CLI release

The official blueprints are hosted on our distribution site and are published using the internal [Jenkins Job](https://jenkins-ng.xebialabs.com/jenkinsng/job/XL%20Devops%20As%20Code/job/Blueprints%20Release/) which is triggered manually.

Run `publish.py` script to update the S3 bucket for development availabvle at [https://s3.amazonaws.com/xl-cli/blueprints](https://s3.amazonaws.com/xl-cli/blueprints)

### Prerequisites

- python & pip is needed for the publish script
- For updating S3 bucket, you'll need to generate your local AWS credentials file as described [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html).
- For using S3 API, you need to install `boto3` library using `pip install boto3` command
