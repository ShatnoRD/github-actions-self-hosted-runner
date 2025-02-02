# GitHub Actions Self-Hosted Runner Docker Image

This repository provides the source code for a Docker image that sets up a self-hosted runner for GitHub Actions, including all dependencies and a registration script for your GitHub repo or organization.

### Releases

Ironically, I build this `github-actions-self-hosted-runner` image on GitHub's `ubuntu-latest` runner. I avoid using self-hosted runners for public repos because it's easier and more secure to use GitHub's provided runners for the publish pipeline. The image is built and pushed to Docker Hub and GitHub Packages whenever a new release is published or on demand.

Currently, there are two separate build workflows for templating reasons:

- [publish_docker_hub.yml](.github/workflows/publish_docker_hub.yml): Builds and pushes the image to Docker Hub.
- [publish_github_packages.yml](.github/workflows/publish_github_packages.yml): Builds and pushes the image to GitHub Packages.

Although this setup could be optimized to use less worker time by combining the two separate ones into a single workflow,this approach allows for clearer separation and templating.

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