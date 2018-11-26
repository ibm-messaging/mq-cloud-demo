# Setting up the stock check backend JMS application

This next section will cover setting up a local JMS application which will act as the backend service (see diagram at top of page) that will return the stock count for a particular product.

## 1. Set the environment variables

First, change the values in the `.env` file found in the following directory - `mq-cloud-demo/ibm-backend-request/jmsapp`

Example of the `.env` file shown below;

```bash
export QMGR_NAME=<Your-IBM-cloud-queue-managers-name>
export QMGR_HOST=<Your-IBM-cloud-queue-managers-hostname>
export QMGR_PORT=<Your-IBM-cloud-queue-managers-listener-port>
export APP_USER=<Your-app-username>
export APP_PASSWORD=<Your-app-password>
```

Now source the `.env` file by running the following command:

```bash
cd mq-cloud-demo/ibm-backend-response/jmsapp
source .env
```

## 2. Compile the JMS application

Open your terminal / command prompt, and navigate to the JMS application directory.

``` bash
cd mq-cloud-demo/ibm-backend-request/jmsapp
```

Compile the JMS application with the following command:

``` bash
javac -cp ./jars/com.ibm.mq.allclient-9.0.4.0.jar:./jars/javax.jms-api-2.0.1.jar:. com/ibm/mq/samples/jms/JmsPutGet.java
```

This will compile the java application and point it at your queue manager

## 3. Run the JMS application

Insert the connection information for your IBM Cloud queue manager in the spaces shown below and execute the following command to run the newly compiled JMS application:

``` bash
java -cp ./jars/com.ibm.mq.allclient-9.0.4.0.jar:./jars/javax.jms-api-2.0.1.jar:. com.ibm.mq.samples.jms.JmsPutGet
```

The JMS application is now listening for connections on the STOCK message queue.

Now we can test the connectivity between the two applications using MQ, by sending a simple CURL command with a basic payload.

```bash
# change <api-gateway-url> to the URL for your API gateway
curl -X POST -d "{\"product\":\"phone\"}" <api-gateway-url>

# If successful you will see the following output
"{ \"count\": 18 }"
```

Success! You have now demonstrated cross-cloud, cross-region connectivity with IBM MQ on Cloud.

## Copyright

© Copyright IBM Corporation 2018