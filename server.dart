import 'dart:io';

void handleRequest( message ){
  print("new client!");
}

void main() {
  
  print("Starting.");

  HttpServer.bind( '0.0.0.0', 5000 ).then( (server )  {
    
    server.listen( (HttpRequest req) {
      WebSocketTransformer.upgrade(req).then((WebSocket websocket) {
        print("replying with hello...");
        websocket.add("hello!");
      });
      
    });
    
  });
  
}