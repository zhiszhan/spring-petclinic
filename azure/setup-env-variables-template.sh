# ==== Azure Spring Apps INFO ====
export SUBSCRIPTION=subscription-id                 # replace it with your subscription-id
export RESOURCE_GROUP=resource-group-name           # existing resource group or one that will be created in next steps
export SPRING_APPS_SERVICE=azure-spring-apps-name   # name of the service that will be created in the next steps
export LOG_ANALYTICS_WORKSPACE=log-analytics-name   # existing workspace or one that will be created in next steps
export REGION=region-name                           # choose a region with Enterprise tier support

export JAR_APP="jar-app"
export NATIVE_APP="native-app"

export DEFAULT_BUILDER="default"
export NATIVE_BUILDER="native"

# ==== MYSQL INFO ====
export MYSQL_SERVER_NAME=mysql-petclinic # customize this
export MYSQL_SERVER_ADMIN_NAME=azureuser # customize this
export MYSQL_SERVER_ADMIN_PASSWORD=SuperS3cr3t # customize this
export MYSQL_SERVER_FULL_NAME=${MYSQL_SERVER_NAME}.mysql.database.azure.com
export MYSQL_SERVER_ADMIN_LOGIN_NAME=${MYSQL_SERVER_ADMIN_NAME}\@${MYSQL_SERVER_NAME}
export MYSQL_DATABASE_NAME=petclinic
export MYSQL_IDENTITY=mysql-identity