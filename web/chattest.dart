import 'dart:html';
import 'dart:convert';
import 'package:css_animation/css_animation.dart';

void main() {
  
/*  querySelector("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(reverseText);*/
  var ws = new WebSocket( 'ws://127.0.0.1:5000/chat');
  
  var welcomeBox = querySelector('#welcome');
  var chatBox = querySelector('#chat');
  var messageForm = querySelector('#messageForm');
  var nickname;

  ws.onMessage.listen((MessageEvent e) {
    
    if ( chatBox.children.length > 6 ) {
      chatBox.children.remove( chatBox.children[0] );
    };
    
    var message = JSON.decode( e.data );
    var messageHtml = '<p>';
    
    switch( message['type'] ) {
      case 'event':

        switch( message['name']) {
          case 'newUser':
            messageHtml += '<b>' + message['data'] + '</b> has joined the chat!';
            break;
        };
        break;
      case 'message':
        messageHtml += '<b>' + message['name'] + ':</b> ' + message['data'];
        break;
    };
    messageHtml+="</p>";
    querySelector('#chat').appendHtml( messageHtml );
    
  });  
  
  var animation = new CssAnimation('opacity', 0, 1);
  
  querySelector('#nickname').focus();
  
  welcomeBox.querySelector('form').onSubmit.listen( ( Event e ) {
    nickname = welcomeBox.querySelector('#nickname').value;
    new CssAnimation( 'opacity', 1, 0).apply( welcomeBox, duration: 500, onComplete: () { welcomeBox.style.display='none'; });
    ws.sendString( JSON.encode({ 'type': 'event', 'name': 'newUser', 'data': nickname }) );
    messageForm.querySelector('input').focus();
    e.preventDefault();
  });
  
  
  messageForm.onSubmit.listen( ( Event e ) {
    ws.sendString( JSON.encode({ 'type': 'message', 'name': nickname, 'data':messageForm.querySelector('input').value  }) );
    messageForm.querySelector('input').value = '';
    e.preventDefault();
  });
}