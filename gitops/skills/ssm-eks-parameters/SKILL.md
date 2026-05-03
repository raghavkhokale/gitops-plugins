---
name: gitops:ssm-eks-parameters
description: Get EKS/FluxCD SSM parameters (argo-application.
when_to_use: |
  Use this skill to invoke the `ssm_eks_parameters` operation directly.
  Trigger when the user asks specifically about ssm eks parameters or when a workflow skill
  delegates this specific operation.
---

# /gitops:ssm-eks-parameters

Get EKS/FluxCD SSM parameters (argo-application.

**MCP tool:** `mcp__gitops__ssm_eks_parameters`

## What To Do

1. Call `mcp__gitops__ssm_eks_parameters(environment, profile)`.
2. Show the structured result to the user in a readable format.
3. Suggest next steps if applicable (e.g., related tools to call, follow-up actions).

