---
page_type: sample
languages:
- java
products:
- Azure Spring Apps
- Azure Database for MySQL
description: "Deploy Spring Native Apps to Azure"
urlFragment: "spring-petclinic"
---

# Deploy Spring Native Apps to Azure

Azure Spring Apps enables you to easily run Spring Native applications on Azure.

This quickstart shows you how to deploy existing applications written in Java to Azure. When you're finished, you can continue to manage the application via the Azure CLI or switch to using the Azure Portal.

## What will you experience

You will:

* Provision an Azure Spring Apps service instance.
* Deploy Spring Native applications to Azure and build using Tanzu Build Service
* Open the application
* Monitor applications

## Understanding the Spring Petclinic application with a few diagrams
<a href="https://speakerdeck.com/michaelisvy/spring-petclinic-sample-application">See the presentation here</a>

## Running petclinic locally
Petclinic is a [Spring Boot](https://spring.io/guides/gs/spring-boot) application built using [Maven](https://spring.io/guides/gs/maven/) or [Gradle](https://spring.io/guides/gs/gradle/). You can build a jar file and run it from the command line (it should work just as well with Java 17 or newer):


```
mkdir source-code
cd source-code
git clone https://github.com/selvasingh/spring-petclinic.git
cd spring-petclinic
./mvnw package
java -jar target/*.jar
```

You can then access petclinic at http://localhost:8080/

<img width="1042" alt="petclinic-screenshot" src="https://cloud.githubusercontent.com/assets/838318/19727082/2aee6d6c-9b8e-11e6-81fe-e889a5ddfded.png">

Or you can run it from Maven directly using the Spring Boot Maven plugin. If you do this, it will pick up changes that you make in the project immediately (changes to Java source files require a compile as well - most people use an IDE for this):

```
./mvnw spring-boot:run
```

> NOTE: If you prefer to use Gradle, you can build the app using `./gradlew build` and look for the jar file in `build/libs`.

## What you will need

In order to deploy a Java app to cloud, you need
an Azure subscription. If you do not already have an Azure
subscription, you can activate your
[MSDN subscriber benefits](https://azure.microsoft.com/pricing/member-offers/msdn-benefits-details/)
or sign up for a
[free Azure account]((https://azure.microsoft.com/free/)).

In addition, you will need the following:

| [Azure CLI version 2.47.0 or higher](https://docs.microsoft.com/cli/azure/install-azure-cli?view=azure-cli-latest)
| [Git](https://git-scm.com/)
| [`jq` utility](https://stedolan.github.io/jq/download/)
|

Note -  On Windows, the [`jq` utility](https://stedolan.github.io/jq/download/) should be renamed from `jq-win64.exe` to `jq.exe` and added to the `PATH`

Note - The Bash shell. While Azure CLI should behave identically on all environments, shell
semantics vary. Therefore, only bash can be used with the commands in this repo.
To complete these repo steps on Windows, use Git Bash that accompanies the Windows distribution of
Git. Use only Git Bash to complete this training on Windows. Do not use WSL.

### OR Use Azure Cloud Shell

Or, you can use the Azure Cloud Shell. Azure hosts Azure Cloud Shell, an interactive shell
environment that you can use through your browser. You can use the Bash with Cloud Shell
to work with Azure services. You can use the Cloud Shell pre-installed commands to run the
code in this README without having to install anything on your local environment. To start Azure
Cloud Shell: go to [https://shell.azure.com](https://shell.azure.com), or select the
Launch Cloud Shell button to open Cloud Shell in your browser.

To run the code in this article in Azure Cloud Shell:

1. Start Cloud Shell.

2. Select the Copy button on a code block to copy the code.

3. Paste the code into the Cloud Shell session by selecting Ctrl+Shift+V on Windows and Linux or by selecting Cmd+Shift+V on macOS.

4. Select Enter to run the code.

## Install the Azure CLI extension

Install the Azure Spring Apps extension for the Azure CLI using the following command

```shell
az extension add --name spring
```

If the extension is already installed, update it with the following command

```shell
az extension update --name spring
```

Note - In some cases, the update command may fail and it will be necessary to reinstall the Azure
Spring Apps extension. Use the following command to remove previous versions and install the latest 
Azure Spring Apps extension:

```shell
az extension remove --name spring-cloud
az extension remove --name spring
az extension add --name spring
```

## Clone the repo

### Create a new folder and clone the sample app repository to your Azure Cloud account

If you have not already cloned this sample repo, please clone the repo:

```shell
mkdir source-code
cd source-code
git clone https://github.com/selvasingh/spring-petclinic
cd spring-petclinic
```

## Unit 1 - Deploy and Build Applications

### Prepare your environment for deployments

Create a bash script with environment variables by making a copy of the supplied template:

```shell
cp ./azure/setup-env-variables-template.sh ./azure/setup-env-variables.sh
```

Open `./azure/setup-env-variables.sh` and enter the following information:

```shell
export SUBSCRIPTION=subscription-id                 # replace it with your subscription-id
export RESOURCE_GROUP=resource-group-name           # existing resource group or one that will be created in next steps
export SPRING_APPS_SERVICE=azure-spring-apps-name   # name of the service that will be created in the next steps
export LOG_ANALYTICS_WORKSPACE=log-analytics-name   # existing workspace or one that will be created in next steps
export REGION=region-name                           # choose a region with Enterprise tier support
```

The REGION value should be one of available regions for Azure Spring Apps (e.g. eastus). Please visit [here](https://azure.microsoft.com/en-us/global-infrastructure/services/?products=spring-apps&regions=all) for all available regions for Azure Spring Apps.

Then, set the environment:

```shell
source ./azure/setup-env-variables.sh
```

### Login to Azure

Login to the Azure CLI and choose your active subscription. 

```shell
az login
az account list -o table
az account set --subscription ${SUBSCRIPTION}
```

### Create Azure Spring Apps service instance

Prepare a name for your Azure Spring Apps service.  The name must be between 4 and 32 characters long and can contain only lowercase letters, numbers, and hyphens.  The first character of the service name must be a letter and the last character must be either a letter or a number.

Create a resource group to contain your Azure Spring Apps service.

> Note: This step can be skipped if using an existing resource group

```shell
az group create --name ${RESOURCE_GROUP} \
    --location ${REGION}
```

Accept the legal terms and privacy statements for the Enterprise tier.

> Note: This step is necessary only if your subscription has never been used to create an Enterprise tier instance of Azure Spring Apps.

```shell
az provider register --namespace Microsoft.SaaS
az term accept --publisher vmware-inc --product azure-spring-cloud-vmware-tanzu-2 --plan asa-ent-hr-mtr
```

Create an instance of Azure Spring Apps Enterprise.

```shell
az spring create --name ${SPRING_APPS_SERVICE} \
    --resource-group ${RESOURCE_GROUP} \
    --location ${REGION} \
    --sku Enterprise \
    --enable-alv \
    --build-pool-size S7 
```

> Note: If the `create` command fails, try updating the Azure Spring Apps extension described [here](#install-the-azure-cli-extension)

> Note: The service instance will take around 10-15 minutes to deploy.

Set your default resource group name and cluster name using the following commands:

```shell
az configure --defaults \
    group=${RESOURCE_GROUP} \
    location=${REGION} \
    spring=${SPRING_APPS_SERVICE}
```
### Configure Log Analytics for Azure Spring Apps

Create a Log Analytics Workspace to be used for your Azure Spring Apps service.

> Note: This step can be skipped if using an existing workspace

```shell
az monitor log-analytics workspace create \
  --workspace-name ${LOG_ANALYTICS_WORKSPACE} \
  --location ${REGION} \
  --resource-group ${RESOURCE_GROUP}   
```

Retrieve the resource ID for the recently create Azure Spring Apps Service and Log Analytics Workspace:

```shell
export LOG_ANALYTICS_RESOURCE_ID=$(az monitor log-analytics workspace show \
    --resource-group ${RESOURCE_GROUP} \
    --workspace-name ${LOG_ANALYTICS_WORKSPACE} | jq -r '.id')

export SPRING_APPS_RESOURCE_ID=$(az spring show \
    --name ${SPRING_APPS_SERVICE} \
    --resource-group ${RESOURCE_GROUP} | jq -r '.id')
```

Configure diagnostic settings for the Azure Spring Apps Service:

```shell
az monitor diagnostic-settings create --name "send-logs-and-metrics-to-log-analytics" \
    --resource ${SPRING_APPS_RESOURCE_ID} \
    --workspace ${LOG_ANALYTICS_RESOURCE_ID} \
    --logs '[
         {
           "category": "ApplicationConsole",
           "enabled": true,
           "retentionPolicy": {
             "enabled": false,
             "days": 0
           }
         },
         {
            "category": "SystemLogs",
            "enabled": true,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
            }
          },
         {
            "category": "IngressLogs",
            "enabled": true,
            "retentionPolicy": {
              "enabled": false,
              "days": 0
             }
           }
       ]' \
       --metrics '[
         {
           "category": "AllMetrics",
           "enabled": true,
           "retentionPolicy": {
             "enabled": false,
             "days": 0
           }
         }
       ]'
```

> Note: For Git Bash users, this command may fail when resource IDs are misinterpreted as file paths because they begin with `/`. 
> 
> If the above command fails, try setting MSYS_NO_PATHCONV using:
> 
> `export MSYS_NO_PATHCONV=1`

### Configure Tanzu Build Service

Create a custom builder in Tanzu Build Service using the Azure CLI:

```shell
az spring build-service builder create -n ${CUSTOM_BUILDER} \
    --builder-file azure/builder.json \
    --no-wait
```

### Create applications in Azure Spring Apps

Create an application for each service:

```shell
az spring app create --name ${JAR_APP} --cpu 2 --memory 4Gi --assign-endpoint &
az spring app create --name ${NATIVE_APP} --cpu 2 --memory 4Gi --assign-endpoint &
wait
```

### Build and Deploy Polyglot Applications

Deploy and build each application, specifying its required parameters

```shell
# Deploy Petclinic app built as JAR
az spring app deploy --name ${JAR_APP} \
    --builder ${CUSTOM_BUILDER} \
    --source-path . \
    --build-env BP_JVM_VERSION=17

# Deploy Petclinic app built as Java Native Image
az spring app deploy --name ${NATIVE_APP} \
    --builder ${CUSTOM_BUILDER} \
    --build-memory 16Gi \
    --source-path . \
    --build-env BP_JVM_VERSION=17 BP_NATIVE_IMAGE=true
```

> Note: Deploying all applications will take 5-10 minutes

## Next Steps









