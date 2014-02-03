import 'package:redis_client/redis_client.dart';

import 'dart:io';
import 'dart:convert';

void main() {
  
  print("Starting.");

  HttpServer.bind( '0.0.0.0', 5000 ).then( (server )  {
    
    server.listen( (HttpRequest req) {
      
      WebSocketTransformer.upgrade(req).then((WebSocket websocket) {

        websocket.listen( ( rawData ) {
          RedisClient.connect( '127.0.0.1:6379' ).then( (redis) {
            redis.publish( 'chat', rawData );
            redis.close();
          });
          
          var data = JSON.decode(rawData); 
        });
        
        RedisClient.connect( '127.0.0.1:6379').then( (redis) {
          redis.subscribe( ['chat'], (Receiver message) {
            message.receiveMultiBulkStrings().then((List<String> message){
              websocket.add( message.last );
            });
          });
        });
        
      });
      
    });
    
  });
  
}