# GitHub Actions Self-Hosted Runner Docker Image

This repository provides the source code for a Docker image that sets up a self-hosted runner for GitHub Actions, including all dependencies and a registration script for your GitHub repo or organization.

- **.github/workflows/publish_docker_hub.yml**: GitHub Actions workflow for building and publishing the Docker image to Docker Hub.
- **Dockerfile**: Defines the Docker image, including dependencies and setup.
- **LICENSE**: The project's license (Mozilla Public License 2.0).
- **README.md**: This file.
- **self-hosted-runner-start.sh**: Script to register and start the self-hosted runner.

### Releases

Ironically, I build this `github-actions-self-hosted-runner` image on GitHub's `ubuntu-latest` runner. I avoid using self-hosted runners for public repos because it's easier and more secure to use GitHub's provided runners for the publish pipeline. The image is built and pushed to Docker Hub whenever a new release is published or on demand.

## Usage

To use this Docker image, you need to set up the necessary environment variables and run the container. The [self-hosted-runner-start.sh](self-hosted-runner-start.sh) script handles the registration and startup of the runner.

### Environment Variables

- `TOKEN`: GitHub personal access token with `repo` and `admin:org` permissions.
- `REPO`: GitHub repository in the format `owner/repo`.
- `ORG`: GitHub organization name (if using organization-level runners).
- `GROUP`: Runner group name (optional).
- `NAME`: Runner name (optional, defaults to hostname).
- `LABELS`: Runner labels (optional, defaults to `self-hosted`).

### Example

```sh
docker run -e TOKEN=<your_token> -e REPO=<your_repo> shatnord/github-actions-self-hosted-runner:latest
```
### License

This project is licensed under the Mozilla Public License 2.0. See the LICENSE file for details.
This [README.md](README.md) provides an overview of the project, explains the structure, and details the usage of the Docker image.