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

package com.ibm.mq.samples.jms;

import java.util.Random;

import javax.jms.Destination;
import javax.jms.JMSConsumer;
import javax.jms.JMSContext;
import javax.jms.JMSException;
import javax.jms.JMSProducer;
import javax.jms.TextMessage;
import javax.jms.Message;

import com.ibm.msg.client.jms.JmsConnectionFactory;
import com.ibm.msg.client.jms.JmsFactoryFactory;
import com.ibm.msg.client.wmq.WMQConstants;

/**
 * A minimal and simple application for Point-to-point messaging.
 *
 * Application makes use of fixed literals, any customisations will require
 * re-compilation of this source file. Application assumes that the named queue
 * is empty prior to a run.
 *
 * Notes:
 *
 * API type: JMS API (v2.0, simplified domain)
 *
 * Messaging domain: Point-to-point
 *
 * Provider type: IBM MQ
 *
 * Connection mode: Client connection
 *
 * JNDI in use: No
 *
 */
public class JmsPutGet {

	// System exit status value (assume unset value to be 1)
	private static int status = 1;

	// Create variables for the connection to MQ
	private static final String HOST = System.getenv("QMGR_HOST"); // Host name or IP address
	private static final int PORT = Integer.parseInt(System.getenv("QMGR_PORT")); // Listener port for your queue manager
	private static final String CHANNEL = "CLOUD.APP.SVRCONN"; // Channel name
	private static final String QMGR = System.getenv("QMGR_NAME"); // Queue manager name
	private static final String APP_USER = System.getenv("APP_USER"); // User name that application uses to connect to MQ
	private static final String APP_PASSWORD = System.getenv("APP_PASSWORD"); // Password that the application uses to connect to MQ
	private static final String TARGET_QUEUE_NAME = "STOCK.REPLY"; // Queue that the application uses to put and get messages to and from
  	private static final String SOURCE_QUEUE_NAME = "STOCK"; // Queue that the application uses to put and get messages to and from

	/**
	 * Main method
	 *
	 * @param args
	 */
	public static void main(String[] args) {
		System.out.println("Host name is: " + HOST);
		System.out.println("port is: " + PORT);
		System.out.println("qmgr name " + QMGR);
		System.out.println("App_user is: " + APP_USER);
		System.out.println("app api key is: " + APP_PASSWORD);
		// Variables
		JMSContext context = null;
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
			context = cf.createContext();
			destination = context.createQueue("queue:///" + TARGET_QUEUE_NAME);
      		source = context.createQueue("queue:///" + SOURCE_QUEUE_NAME);

      while (true) {
			   consumer = context.createConsumer(source); // autoclosable

          Message msg = consumer.receive();
          TextMessage TMreceivedMessage = (TextMessage)msg;

         String corrid;
         if (TMreceivedMessage.getJMSCorrelationID() != null) {
           corrid = TMreceivedMessage.getJMSCorrelationID();
         } else {
           System.out.println("\n\ncorrid was null");
           corrid = "blank";
         }

//         String receivedMessage = TMreceivedMessage.toString();
         String receivedMessage = TMreceivedMessage.getBody(String.class);

         if ( receivedMessage != null ) {

           System.out.println("\n\n}============================{\n");

           //receivedMessage = "{ \"product\": \"iphone8\" }";  //TMP
			     System.out.println("\nGot message from STOCK queue:\n  " + receivedMessage);

           System.out.println("\n\nRetrieving stock level ...\n");

           Random rn = new Random();
           int randomNum = rn.nextInt(20);
           //randomNum = 7; //TMP

           String resp = "{ \"count\": " + randomNum + " }";
           TextMessage message = context.createTextMessage(resp);
           message.setJMSCorrelationID(corrid);

           producer = context.createProducer();
           producer.setTimeToLive(30000);
           producer.send(destination, message);
           System.out.println("\nPut message to STOCK.REPLY queue\n  " + resp);
         }
      }
		} catch (JMSException jmsex) {
			System.out.println("FAILED" + "Error is: "+ jmsex);
		}

	} // end main()

	/**
	 * Record this run as successful.
	 */
	private static void recordSuccess() {
		System.out.println("SUCCESS");
		status = 0;
		return;
	}

	/**
	 * Record this run as failure.
	 *
	 * @param ex
	 */
	private static void recordFailure(Exception ex) {
		if (ex != null) {
			if (ex instanceof JMSException) {
				processJMSException((JMSException) ex);
			} else {
				System.out.println(ex);
			}
		}
		System.out.println("FAILURE");
		status = -1;
		return;
	}

	/**
	 * Process a JMSException and any associated inner exceptions.
	 *
	 * @param jmsex
	 */
	private static void processJMSException(JMSException jmsex) {
		System.out.println(jmsex);
		Throwable innerException = jmsex.getLinkedException();
		if (innerException != null) {
			System.out.println("Inner exception(s):");
		}
		while (innerException != null) {
			System.out.println(innerException);
			innerException = innerException.getCause();
		}
		return;
	}

}
