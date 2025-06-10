# tf-aws-app

Terraform code that:

- Compute infrastructure within AWS that an application could eventually run on.
- A data store in AWS, that the compute infrastructure can communicate with.

Assumptions:

- Terraform Version 1.21
- Application code is not provided, but I will assume this is just a backend app and there is no need to deploy public facing resources.
- Assume application is containerized.
- Assume only `us-east-1` region is required.
- Terraform Cloud is set up with GitHub as the control provider and uses OIDC to authenticate to AWS environment.
- Assuming data is compatible with relational database.

Decisions:

- Compute infra will use ECS Fargate because this reduces some infrastructure management and integrates with containers easily. the ECS will be deployed in a private subnet to protect it against the internet.
- AWS Aurora Serverless will be used. This is slightly more expensive than RDS but is more scalable, reliable, and durable.
- Only outbound traffic is allowed by security group. Inbound traffic was not specified because it is not needed.

Additional thoughts/improvements in no particular order:

- Use locals where possible.
- Use a secret manager as needed and avoid long term credentials where possible.
- Enforce not pushing to main without a PR.
- Add CI/CD scans.
- Build a hardened image.
- Tag resources according to org wide schema.
- Staging a sbx/dev/prd environment for testing before deploying to production.
- If this pattern will be widely used, create modules/abstraction that follow best practices and use case.
- Further reduce IAM, Network privileges.
- Scale up or down or even shut down to reduce costs (set up billing alerts).
- Ensure logs are enabled/setup (CloudTrail, VPC Flowlogs, Access logs, etc).
- Document how this stack works, why this was created.
