/**
* © Copyright IBM Corporation 2018
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

package com.example.lambda.ibmmq;
import java.util.Map;
import java.util.UUID;
import javax.jms.Destination;
import javax.jms.JMSConsumer;
import javax.jms.JMSContext;
import javax.jms.JMSException;
import javax.jms.JMSProducer;
import javax.jms.TextMessage;

import com.ibm.msg.client.jms.JmsConnectionFactory;
import com.ibm.msg.client.jms.JmsFactoryFactory;
import com.ibm.msg.client.wmq.WMQConstants;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class JMSLambda implements RequestHandler<Map<String,String>,String> {

	// Create variables for the connection to MQ
	private static final String HOST = System.getenv("QMGR_HOST");// Host name or IP address
	private static final String PORT_STRING = System.getenv("QMGR_PORT");
	private static final int PORT = Integer.parseInt(PORT_STRING); // Listener port for your queue manager
	private static final String CHANNEL = "CLOUD.APP.SVRCONN"; // Channel name
	private static final String QMGR = System.getenv("QMGR_NAME"); // Queue manager name
	private static final String APP_USER = System.getenv("APP_USER"); // User name that application uses to connect to MQ
	private static final String APP_PASSWORD = System.getenv("APP_PASSWORD"); //Password that the application uses to connect to MQ
	private static final String TARGET_QUEUE_NAME = System.getenv("TARGET_QUEUE_NAME"); // Queue that the application uses to put and get messages to and from
	private static final String RESPONSE_QUEUE_NAME = System.getenv("RESPONSE_QUEUE_NAME"); // Queue that the application uses to put and get messages to and from

    @Override
    public String handleRequest(Map<String, String> input, Context context) {
  	  //context.getLogger().log("Input: " + input);

  	  JMSContext jmscontext = null;
  	  Destination destination = null;
  	  Destination source = null;
  	  JMSProducer producer = null;
  	  JMSConsumer consumer = null;

  	  try {
		// Create a connection factory
		JmsFactoryFactory ff = JmsFactoryFactory.getInstance(WMQConstants.WMQ_PROVIDER);
		JmsConnectionFactory cf = ff.createConnectionFactory();

		// Set the properties
		cf.setStringProperty(WMQConstants.WMQ_HOST_NAME, HOST);
		cf.setIntProperty(WMQConstants.WMQ_PORT, PORT);
		cf.setStringProperty(WMQConstants.WMQ_CHANNEL, CHANNEL);
		cf.setIntProperty(WMQConstants.WMQ_CONNECTION_MODE, WMQConstants.WMQ_CM_CLIENT);
		cf.setStringProperty(WMQConstants.WMQ_QUEUE_MANAGER, QMGR);
		cf.setStringProperty(WMQConstants.WMQ_APPLICATIONNAME, "JmsPutGet (JMS)");
		cf.setBooleanProperty(WMQConstants.USER_AUTHENTICATION_MQCSP, true);
		cf.setStringProperty(WMQConstants.USERID, APP_USER);
		cf.setStringProperty(WMQConstants.PASSWORD, APP_PASSWORD);

		// Create JMS objects
		jmscontext = cf.createContext();
		destination = jmscontext.createQueue("queue:///" + TARGET_QUEUE_NAME);



		String product = input.get("product");
		String jsonbody = "{ \"product\": \"" + product + "\" }";
		TextMessage message = jmscontext.createTextMessage(jsonbody);

		UUID uuid = UUID.randomUUID();
		String corrid = uuid.toString();
 		message.setJMSCorrelationID(corrid);

        System.out.println("\n\n}============================{\n");

		System.out.println("\nRest request received with body: " + jsonbody);


		producer = jmscontext.createProducer();
		producer.setTimeToLive(30000);

		producer.send(destination, message);
		System.out.println("\nPut message to STOCK queue: " + jsonbody);

		source = jmscontext.createQueue("queue:///" + RESPONSE_QUEUE_NAME);

		consumer = jmscontext.createConsumer(source, "JMSCorrelationID='"+corrid+"'"); // autoclosable
		String receivedMessage = consumer.receiveBody(String.class, 15000); // in ms or 15 seconds

		System.out.println("\nGot reply message from STOCK.REPLY queue: " + receivedMessage);

		//System.out.println("\ncontent.logGroupname: " + context.getLogGroupName() +  "\ncontext.logStreamName: " + context.getLogStreamName());

		return receivedMessage;

  	  } catch (JMSException jmsex) {
		return "THIS FAILED IT SEEMS! Rest body: " + input.toString();
  	  }

    }

}
