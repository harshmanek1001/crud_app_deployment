# Deployment Issues and Troubleshooting Guide

This document summarizes the deployment issues encountered while setting up the 3-tier CRUD application on Azure and the steps taken to resolve them.

## 1. Application Gateway: 502 Bad Gateway on `/api`

### Symptoms
Accessing the Application Gateway's public IP at the `/api` endpoint resulted in a `502 Bad Gateway` error.

### Root Cause
There were two overlapping issues in the Application Gateway configuration:
1. **Frontend Health Probe Failure:** The health probe for the `frontend` backend pool (Azure Storage static website) was configured to check port `80` (HTTP). However, the Storage Account had `enableHttpsTrafficOnly = true` enforced. The storage account rejected the HTTP probe with a `400 Bad Request`, causing the Application Gateway to mark the frontend pool as **Unhealthy**.
2. **Path Routing Fallback:** The URL path map routing rule for the backend API was strictly set to `["/api/*"]`. Accessing exactly `/api` (without a trailing slash) failed to match this rule. Consequently, the Application Gateway fell back to its default routing, which pointed to the frontend pool. Since the frontend pool was unhealthy, the Gateway immediately threw a `502 Bad Gateway`.

### Resolution
* **Updated Frontend Protocol:** Modified the Terraform module (`terraform/modules/application_gateway/main.tf`) to switch the frontend `backend_http_settings` and `probe` to use `Https` and port `443`.
* **Added Exact Path Match:** Added `"/api"` to the `api-route` path rules (making it `paths = ["/api/*", "/api"]`).

## 2. Missing Database Schema (Initial 500 Error)

### Symptoms
The frontend successfully loaded, but API requests to fetch items returned a `500 Internal Server Error`.

### Root Cause
The `items` table did not exist in the Azure MySQL Flexible Server. The `schema_script.sql` script had been used for local Docker Compose deployments but was never executed against the cloud database.

### Resolution
1. Temporarily added a firewall rule to the MySQL Flexible Server to allow remote access.
2. Retrieved the database administrator password from Azure Key Vault.
3. Connected directly to the MySQL database using the `mysql` CLI tool and executed the `schema_script.sql` file.
4. Deleted the temporary firewall rule for security.

## 3. Azure App Service Web SSH Failure

### Symptoms
Attempting to connect to the backend container via the Azure Portal's "Web SSH" feature resulted in an immediate connection drop with the message `SSH CONN CLOSE`.

### Root Cause
The backend application uses a Custom Container on Azure App Service for Linux, defined by `trainee_backend.Dockerfile`. The image is based on a standard `node:20-alpine` image. For the Azure Web SSH feature to function, the custom container must explicitly install an SSH server (`openssh-server`), configure it with a specific root password, and run it on port `2222`. Since this was not configured, Azure had no SSH daemon to connect to.

### Resolution
This is expected behavior for minimal custom containers. No code changes were required. Database management and troubleshooting were performed remotely (as seen in Issue #2) and via Azure App Service logs instead of SSH.

## 4. MySQL SSL Connection Rejection (Subsequent 500 Error)

### Symptoms
Even after the schema was created, API requests still failed with a `500 Internal Server Error`. Live container logs revealed the error: `Error: Connections using insecure transport are prohibited while --require_secure_transport=ON`.

### Root Cause
Azure MySQL Flexible Server strictly enforces secure transport (TLS/SSL) for all connections by default. The Node.js application's database configuration (`src/config/db.js`) was creating a connection pool without any SSL settings, causing the database to reject the insecure connection at the transport layer.

### Resolution
* Modified `src/config/db.js` to include the required SSL configuration for the `mysql2` pool:
  ```javascript
  ssl: {
    rejectUnauthorized: false // Required for Azure MySQL Flexible Server
  }
  ```
* Rebuilt the Docker image and pushed the updated `v1` tag to the Azure Container Registry.
* Restarted the Azure App Service to pull the latest image and re-establish the connection.
