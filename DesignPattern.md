Factory:
All notification logic should be present in the factory and client should talk only to that class, object creating logic should not be present in client class


EmailNotification - void send() println()
SMSNotification - void send() println()

OrderService - new of both() and send()

Voilation 1: Tight coupling

Create common interface Notification with send() and implement it

OrderService - Notification 
sendNotification(type){
  .....
  notification.send();
}

Voilation 2: DRY violation for another client we have to write same sendNotification code

shift that logic to NotificationFactory
NotificationFactory.sendNotification("EMAIL");

can also have logic to send all notification using List<Notification>
