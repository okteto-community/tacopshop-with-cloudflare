# Create a Development Environment with Okteto, Kubernetes, AWS, and CloudFlare

This is an example of how to configure and deploy a development environment that includes polyglot microservices, an AWS SQS queue, a Cloudflare R2 bucket and Cloudflare DNS. The infrastructure is deployed using Terraform.


## Run the demo application in Okteto

### Prequisites:
1. Okteto CLI 2.23 or newer
1. An AWS account
1. A Cloudflare account
1. An Okteto account ([Sign-up](https://www.okteto.com/try-free/) for 30 day, self-hosted free trial)
1. Create a set of IAM keys for your AWS account
1. Create the following Okteto secrets:

        AWS_ACCESS_KEY_ID: The Access Key ID of your IAM user
        AWS_SECRET_ACCESS_KEY: The Secret Access Key of your IAM user
        AWS_REGION: The region in AWS you would like to use for the external resources
        CLOUDFLARE_API_TOKEN: An API token with permissions to create, read, and delete hosts, page rules, and r2 buckets
        CLOUDFLARE_ACCOUNT_ID: Your Cloudflare Account ID
        CLOUDFLARE_ZONE_ID: Zone ID where you want to create records
        CLOUDFLARE_ACCESS_KEY_ID: Access Key to manage R2 buckets
        CLOUDFLARE_SECRET_ACCESS_KEY: Secret Access Key to manage R2 buckets

Make sure this AWS IAM has permissions to create, read from, and delete the following AWS services:

- SQS Queues

Make sure your Cloudflare Key has the following permissions:

- Account:Workers R2 Storage:Edit
- Account:Account Rulesets:Edit
- Zone:DNS:Edit
- Zone:Page Rules:Edit
- Zone:Dyanmic Redirects:Edit

> Alternatively if you are using Okteto Self-Hosted, you can configure your instance to use an AWS role instead of using an Acess Key and Secret Access Key.

Once this is configured, anyone with access to your Okteto instance will be able to deploy an development environment automatically, including the required cloud infrastructure.


```
$ git clone https://github.com/okteto-community/tacopshop-with-cloudflare
$ cd tacopshop-with-cloudflare
$ okteto context use $OKTETO_URL
$ okteto deploy
```

## Develop on the Menu microservice

```
$ okteto up menu
```

## Develop on the Kitchen microservice

```
$ okteto up kitchen
```

## Develop on the Result microservice

```
$ okteto up check
```

## Notes

This isn't an example of a properly architected perfectly designed distributed app... it's a simple
example of the various types of pieces and languages you might see (queues, persistent data, etc), and how to
deal with them in Okteto.

Happy coding!
