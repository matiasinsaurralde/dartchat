import 'dart:html';

void main() {
/*  querySelector("#sample_text_id")
    ..text = "Click me!"
    ..onClick.listen(reverseText);*/
  var ws = new WebSocket( 'ws://127.0.0.1:5000/chat');

  ws.onMessage.listen((MessageEvent e) {
    print('Received message: ${e.data}');
  });
}

void reverseText(MouseEvent event) {
  var text = querySelector("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  querySelector("#sample_text_id").text = buffer.toString();
}
