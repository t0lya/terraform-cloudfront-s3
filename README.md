[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)](http://commitizen.github.io/cz-cli/)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/let00/terraform-cloudfront-s3/blob/master/LICENSE)

# terraform-cloudfront-s3 <!-- omit in toc -->

Quickly setup a AWS Cloudfront + Lambda@Edge + S3 stack and host a static website. Uses Docker + Terraform to spin up the necessary AWS resources. Includes a Lambda@Edge function for handling 301 redirects, an S3 origin with access restricted to Cloudfront and other sane defaults. DOES NOT include Amazon Route53 for managing DNS or AWS Certificate Manager for managing SSL/TLS certificates.

## Table of Contents <!-- omit in toc -->

- [Usage](#usage)
  - [Prerequisites](#prerequisites)
  - [Deploy](#deploy)
- [Structure](#structure)
- [License](#license)

## Usage

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/)

### Deploy

1. Create an `.env` file in the root of the project and add your AWS credentials. Refer to `.sample-env` for the required environment variables.

2. Do a dry run to make sure everything is setup correctly (runs `terraform plan` behind the scenes).

   ```sh
   sh deploy.sh plan
   ```

3. If dry run succeeds, proceed with the real deploy (runs `terraform apply` behind the scenes).

   ```sh
   sh deploy.sh apply
   ```

## Structure

- `lambda`

  This folder contains the AWS Lambda@Edge functions that allow you to hook into Cloudfront request lifecycle. Allows you to use Cloudfront as a reverse proxy layer to your static website. For more details, refer to [official AWS documentation](https://docs.aws.amazon.com/lambda/latest/dg/lambda-edge.html).

  - `lambda/origin-request/redirects.js`

    Contains an array of redirects. Pass in a regular expression to match the incoming URL path and specify the outgoing redirect.

- `terraform`

  Contains the Terraform configuration files for creating and managing your Cloudfront + Lambda@Edge + S3 resources. If you need to customize your resource settings, this is where you can do so.

- `deploy.sh`

  A shell script that automates the process of deploying your Cloudfront + Lambda@Edge + S3 stack. Creates a Docker container that has Terraform 12 installed, and then runs `terraform/scripts/entrypoint.sh` inside the container. `terraform/scripts/entrypoint.sh` will use the configuration files in the `terraform` folder to deploy the stack.

## License

Distributed under the MIT License. See [LICENSE](https://github.com/let00/gatsby-source-amazon-paapi/blob/master/LICENSE) for more information.
