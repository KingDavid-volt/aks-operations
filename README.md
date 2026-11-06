# Azure SRE Cluster Doctor Agent

An AI-powered **SRE Cluster Doctor Agent for Azure Kubernetes Service (AKS)** designed to autonomously investigate cluster incidents, identify root causes, recommend remediation, execute controlled corrective actions, and verify that the issue has been resolved.

The agent combines **Azure SRE capabilities, AKS MCP, Kubernetes tooling, Inspektor Gadget, Azure platform context, and GitOps-based remediation** to provide an intelligent operational layer for AKS.

## Objective

The primary objective of the Cluster Doctor Agent is to answer:

> **What is wrong with the AKS environment, why is it happening, what should be done, and did the remediation actually fix it?**

The agent is designed around the complete SRE incident lifecycle:

```text
Detect
  ↓
Investigate
  ↓
Diagnose
  ↓
Determine Root Cause
  ↓
Recommend Remediation
  ↓
Execute Controlled Remediation
  ↓
Verify
  ↓
Report
```

## Agent Architecture

```text
                         ┌───────────────────────┐
                         │   Azure SRE Agent     │
                         │                       │
                         │ Cluster Doctor        │
                         │ Reasoning / Planning  │
                         │ Incident Analysis     │
                         └───────────┬───────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
             ┌────────────┐   ┌──────────────┐  ┌──────────────┐
             │  AKS MCP   │   │ Azure MCP    │  │ Inspektor    │
             │            │   │              │  │ Gadget       │
             │ Kubernetes │   │ Azure Context│  │ Runtime      │
             │ Operations │   │ Monitor      │  │ Observability│
             └─────┬──────┘   └──────┬───────┘  └──────┬───────┘
                   │                 │                  │
                   └─────────────────┼──────────────────┘
                                     │
                              ┌──────▼──────┐
                              │  AKS Cluster │
                              │              │
                              │ Nodes        │
                              │ Pods         │
                              │ Deployments  │
                              │ Services     │
                              │ Networking   │
                              │ Workloads    │
                              └──────────────┘
                                     │
                                     ▼
                              ┌──────────────┐
                              │ GitOps Layer │
                              │              │
                              │ GitHub       │
                              │ Actions      │
                              │ Argo CD      │
                              └──────────────┘
```

## Core Agent Capabilities

### 1. Cluster Health Investigation

The agent can investigate:

* AKS cluster health
* Node conditions
* Pod failures
* CrashLoopBackOff
* Pending workloads
* Deployment failures
* Service availability
* Ingress issues
* Scheduling problems
* Resource pressure
* Kubernetes events

### 2. Runtime Investigation

When standard Kubernetes information is insufficient, the agent can use **Inspektor Gadget** to investigate deeper runtime behavior.

Examples include:

* Process activity
* Network connections
* DNS behavior
* Container activity
* System calls
* Network failures
* Unexpected workload behavior
* Runtime-level anomalies

This provides the agent with deeper diagnostic evidence rather than relying only on Kubernetes object status.

### 3. Azure Context

The agent can correlate Kubernetes problems with the underlying Azure platform.

Potential investigation areas include:

* AKS infrastructure
* Azure networking
* Load Balancers
* Managed identities
* Azure Monitor
* Log Analytics
* Azure resources
* Azure configuration
* Platform-level failures

This allows the agent to distinguish between:

```text
Application problem
        ↓
Kubernetes problem
        ↓
AKS problem
        ↓
Azure infrastructure problem
```

### 4. Root Cause Analysis

The agent should not immediately remediate the first symptom it encounters.

Instead, it should:

1. Collect evidence.
2. Correlate related symptoms.
3. Identify the most likely root cause.
4. Determine confidence.
5. Identify affected workloads.
6. Determine the safest remediation.

Example:

```text
Pod is failing
      ↓
Check pod events
      ↓
Check container logs
      ↓
Check deployment configuration
      ↓
Check node conditions
      ↓
Check resource pressure
      ↓
Check network dependencies
      ↓
Identify root cause
```

## AKS MCP

**AKS MCP** provides the agent with operational access to the Kubernetes and AKS environment.

The MCP layer allows the agent to interact with tools for:

* Kubernetes resources
* Nodes
* Pods
* Deployments
* Services
* Workloads
* Cluster diagnostics
* Azure resources
* Kubernetes operations
* Inspektor Gadget capabilities

The MCP server is deployed within the AKS environment and provides the operational tool interface used by the Cluster Doctor.

## Inspektor Gadget

Inspektor Gadget is an important diagnostic capability of the Cluster Doctor.

It is used when the agent needs information that cannot be obtained from standard Kubernetes APIs.

The agent can use it to investigate:

```text
Network
  ├── Connections
  ├── DNS
  └── Network failures

Runtime
  ├── Processes
  ├── Containers
  └── System calls

Workloads
  ├── Application behavior
  ├── Resource behavior
  └── Runtime anomalies
```

## Agent Decision Process

The Cluster Doctor follows an evidence-driven process.

### Observe

Collect information from:

* Kubernetes
* AKS MCP
* Azure MCP
* Inspektor Gadget
* Logs
* Metrics
* Events

### Correlate

Compare information across multiple sources.

### Reason

Determine:

* What changed?
* What is failing?
* What depends on the failed component?
* Is this a symptom or the root cause?
* How severe is the incident?

### Recommend

Generate a remediation plan containing:

* Root cause
* Evidence
* Impact
* Recommended action
* Risk
* Expected outcome

### Remediate

Where authorized, execute the corrective action using controlled mechanisms.

### Verify

After remediation, the agent verifies:

* Pod health
* Deployment health
* Service availability
* Error state
* Relevant metrics
* Events
* Runtime behavior

The agent should only consider an incident resolved when the verification stage confirms recovery.

## Remediation Model

The Cluster Doctor follows a controlled remediation model:

```text
Incident
   ↓
Diagnosis
   ↓
Remediation Plan
   ↓
Risk Assessment
   ↓
Approval / Policy Check
   ↓
Git Change
   ↓
GitHub Actions
   ↓
Argo CD
   ↓
AKS
   ↓
Health Verification
```

GitOps provides an auditable mechanism for infrastructure and workload changes rather than allowing uncontrolled changes directly against the cluster.

## Example Incident

### Scenario

A deployment begins returning errors and several pods enter `CrashLoopBackOff`.

### Cluster Doctor Investigation

```text
1. Detect unhealthy pods
2. Inspect pod events
3. Inspect container logs
4. Inspect deployment configuration
5. Inspect node health
6. Inspect resource availability
7. Inspect network/runtime behavior
8. Correlate evidence
9. Determine root cause
```

### Agent Output

```text
Incident:
Backend deployment unhealthy

Root Cause:
Application container is failing because of an invalid
configuration value introduced in the latest deployment.

Evidence:
- Pods repeatedly restart
- Container logs show configuration failure
- Deployment changed shortly before incident
- Previous ReplicaSet was healthy

Recommendation:
Revert the deployment configuration to the last known-good
version.

Confidence:
High

Expected Result:
Pods should return to Running/Ready state.
```

### Verification

The agent then checks:

```text
Deployment → Healthy
Pods        → Running
Readiness   → Passing
Errors      → Reduced/Resolved
Events      → No continuing failures
```

Only after successful verification is the incident marked resolved.

## Safety and Guardrails

The agent should operate with explicit controls around remediation.

Key principles:

* Read-only investigation by default.
* Evidence before action.
* No blind remediation.
* Explicit remediation policies.
* Least-privilege access.
* GitOps for persistent configuration changes.
* Auditability of agent actions.
* Post-remediation verification.
* Ability to stop when confidence is insufficient.

The agent should be able to respond:

> **"I don't have enough evidence to safely remediate this incident."**

rather than taking an unsafe action.

## Current Development Focus

The project is being developed in the following sequence:

1. Deploy and validate AKS MCP.
2. Enable and validate Inspektor Gadget.
3. Establish reliable MCP communication.
4. Expose Kubernetes and runtime diagnostic capabilities.
5. Connect the Cluster Doctor to AKS operational context.
6. Implement incident investigation workflows.
7. Implement root-cause reasoning.
8. Implement remediation planning.
9. Integrate controlled GitOps remediation.
10. Implement post-remediation verification.
11. Test the agent against realistic AKS failure scenarios.

## Target State

The final Cluster Doctor Agent should function as an intelligent AKS SRE operator capable of:

```text
                  ┌─────────────────────┐
                  │   AKS Incident      │
                  └──────────┬──────────┘
                             ↓
                  ┌─────────────────────┐
                  │  Cluster Doctor     │
                  │      Detect         │
                  └──────────┬──────────┘
                             ↓
                  ┌─────────────────────┐
                  │    Investigate      │
                  │ Kubernetes + Azure  │
                  │ + Inspektor Gadget  │
                  └──────────┬──────────┘
                             ↓
                  ┌─────────────────────┐
                  │    Root Cause       │
                  │      Analysis       │
                  └──────────┬──────────┘
                             ↓
                  ┌─────────────────────┐
                  │    Remediation      │
                  │       Plan          │
                  └──────────┬──────────┘
                             ↓
                  ┌─────────────────────┐
                  │   GitOps / Argo CD  │
                  └──────────┬──────────┘
                             ↓
                  ┌─────────────────────┐
                  │    AKS Recovery     │
                  └──────────┬──────────┘
                             ↓
                  ┌─────────────────────┐
                  │     Verify          │
                  │      Recovery       │
                  └─────────────────────┘
```

## Project Principle

> **The Cluster Doctor is not simply a chatbot that answers Kubernetes questions. It is an SRE agent that investigates incidents using live operational evidence, reasons about root cause, performs controlled remediation, and verifies the result.**
