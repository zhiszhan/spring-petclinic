#  Workshop: Deploy Spring Native Application to Azure Spring Apps Enterprise

You will find here a full training workshop on deploying a Spring application as a Java Native Image
to Azure Spring Apps Enterprise. For this workshop, we will use a standard Spring Petclinic app.

The workshop comprises 4 lab units that will walk you through the steps how to successfully deploy
a Spring application both as a traditional Java application and as Java Native image using GraalVM,
and then deployed to Azure Spring Apps Enterprise.

## [Unit 0 - Prerequisites and Setup](step-00-setup-your-environment/README.md)

This module defines all prerequisites and helps you prepare the environment for the rest of the
workshop. Typically, this module will be preconfigured before you start your workshop.

Please consult your workshop instructor to confirm the workshop setup has been pre-initialized.

## [Unit 1 - Create an Azure Spring Apps application](step-01-create-asa-app/README.md)

In this module, we will clone the repository, configure the environment variables and create
placeholders in Azure Spring Apps instance, for two versions of the Spring Petclinic application:
* Java application (e.g. `jar-app`)
* Native application (e.g. `native-app`)

## [Unit 2 - Deploy an Azure Spring Apps application](step-02-deploy-asa-app/README.md)

In this module we deploy the both versions of the app. We will use two different builders in 
Tanzu Build Service, one for each version of the application:
* Java Azure buildpack (e.g. `default`)
* Java Native Image buildpack (e.g. `native`)

## [Unit 3a - Bind to PostgreSQL Database](step-03a-bind-to-postgresql-database/README.md)

In this module we will connect to an existing SQL database (e.g. PostgreSQL).
We will use a database connector in Azure Spring Apps for each of the apps.
We need to use a proper `application.properties` file when building a Java Native image.

## [Unit 3b - Bind to MySQL Database](step-03b-bind-to-mysql-database/README.md)

In this module we will connect to an existing SQL database (e.g. MySQL).
We will use a database connector in Azure Spring Apps for each of the apps.
We need to use a proper `application.properties` file when building a Java Native image.

## [Unit 4 - Measuring and Optimizing Usage](step-04-measuring-and-optimizing-usage)

In this module we will observe the application with App Live View. We will compare the two versions
of the application and observe the memory profile differences. We will play with various log levels.
we will stress test the application with load testing tools.

## [Unit 5 - Run and Build App Locally](step-05-run-and-build-app-locally)

In this module we will run and build the application locally. We will look at both standard Java and
Java Native Image way to build a Java app.

