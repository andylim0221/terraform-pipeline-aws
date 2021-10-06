# terraform-pipeline-aws

Terraform pipeline for AWS.

---

## Overview

Terraform pipelining experiment - the pipeline creates a secure Application Programming Interface (API) in AWS API Gateway with a Lambda Proxy backend. The API function is defined in the [Lambda function](resources/lambda_function.py).

## Contributions

### Changing API Function

1. Change Web Application Firewall rule configuration to change security behaviors. For details on which rule does what, visit the corresponding [AWS documentation](https://docs.aws.amazon.com/waf/latest/developerguide/aws-managed-rule-groups-list.html).

2. Change API Gateway request model definition to change request body components.

3. Change API Gateway method configuration to change required header, query string, and path parameter configurations.

4. Change Python input validators in the Lambda function to reflect the same changes.

5. Change Lambda function Python code to change what the API does.

### Steps

0. Quick way: use an IDE with Git integrations instead (such as Visual Studio Code).

1. Clone the *main* branch.

    ```bash
    git clone https://github.com/fer1035/terraform-pipeline-aws.git
    ```

2. Create your feature branch from *main*.

    ```bash
    git checkout -b my-branch
    ```

3. Make your changes.

4. Commit and push your feature branch to origin.

    ```bash
    git commit -m "Updating changes in my-branch."
    git push --set-upstream origin my-branch
    ```

5. Create a Pull Request from your feature branch to *main*.

    > Pull Requests will require the *Terraform* check to pass before merging.
