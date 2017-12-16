---
title: websocket
date: 2017-12-16 13:06:35
category:
tags:
---
[https://www.imooc.com/video/15319](https://www.imooc.com/video/15319)
[https://www.websocket.org/](https://www.websocket.org/)
[https://github.com/sitegui/nodejs-websocket](https://github.com/sitegui/nodejs-websocket)
[https://socket.io/](https://socket.io/)

websocket 允许浏览器和服务器建立持久连接，借助nodejs-websocket实现群聊功能。

#### Echo 
wsSocket.js
```js
var ws = require("nodejs-websocket")

var PORT = 3000

var server = ws.createServer(function (conn) {
	console.log("New connection")
	conn.on("text", function (str) {
		console.log("Received "+str)
		conn.sendText(str)
	})
	conn.on("close", function (code, reason) {
		console.log("Connection closed")
	})
	conn.on("error", function(err){
		console.log("handle error")
		console.log(err)
	})
}).listen(PORT)

console.log("server listen on port " + PORT)
```

index.html
```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
	<title>Websocket</title>
</head>
<body>
	<h1>Echo Test</h1>
	<input id="sendTxt" type="text" name="" />
	<button id="sendBtn">发送</button>
	<div id="recv"></div>
	<script type="text/javascript">
		var websocket = new WebSocket("ws://localhost:3000/");
		websocket.onopen = function(){
			console.log('open');
			document.getElementById('recv').innerHTML = "connected";
		}
		websocket.onclose = function() {
			console.log('closed');
		}
		websocket.onmessage = function(e){
			console.log(e.data);
			document.getElementById('recv').innerHTML = e.data;
		}
		document.getElementById('sendBtn').onclick = function(){
			var txt = document.getElementById('sendTxt').value;
			websocket.send(txt);
		}
	</script>
</body>
</html>
```

#### Chat Room
##### V.1.0
```js
var ws = require("nodejs-websocket")

var PORT = 3000

var clientCount = 0

var server = ws.createServer(function (conn) {
	console.log("New connection")
	clientCount++
	conn.nickName = 'user' + clientCount
	broadcast(conn.nickName + 'comes in')
	conn.on("text", function (str) {
		console.log("Received "+str)
		broadcast(str)
	})
	conn.on("close", function (code, reason) {
		console.log("Connection closed")
		broadcast(conn.nickName + 'left')
	})
	conn.on("error", function(err){
		console.log("handle error")
		console.log(err)
	})
}).listen(PORT)

console.log("server listen on port " + PORT)

function broadcast(str) {
	server.connections.forEach(function(conn){
		conn.sendText(str)
	})
}
```

##### V.2.0
`curl -o socket.io.js https://cdnjs.cloudflare.com/ajax/libs/socket.io/2.0.4/socket.io.js`

socket.io.js 有两个优势：
1. 直接发送object对象，不必json/反json
2. 自定义发送消息类型

```js
var app = require('http').createServer()
var io = require('socket.io')(app);

var PORT = 3000

var clientCount = 0

app.listen(PORT)

io.on("connection", function(socket){
	console.log("New connection")
	clientCount++
	socket.nickName = 'user' + clientCount
	io.emit("enter", socket.nickName + " comes in")

	socket.on("say", function(str){
		io.emit("say", socket.nickName + " says: " + str)
	})

	socket.on("disconnect", function(){
		io.emit("leave", socket.nickName + " left")
	})
})

console.log("server listen on port " + PORT)
```

```html
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8"/>
	<title>Websocket</title>
	<script type="text/javascript" src="socket.io.js"></script>
</head>
<body>
	<h1>Chat Root</h1>
	<input id="sendTxt" type="text" name="" />
	<button id="sendBtn">发送</button>
	<script type="text/javascript">
		var socket = io("ws://localhost:3000/");
		socket.on("enter", function(data){
			showMessage(data, "enter")
		})
		socket.on("leave", function(data){
			showMessage(data, "leave")
		})
		socket.on("say", function(data){
			showMessage(data, "say")
		})
		function showMessage(msg, type) {
			var div = document.createElement('div')
			div.innerHTML = msg
			if(type == "enter"){
				div.style.color = "blue"
			} else if(type == "leave"){
				div.style.color = "red"
			}
			document.body.appendChild(div)
		}
		document.getElementById('sendBtn').onclick = function(){
			var txt = document.getElementById('sendTxt').value;
			if(txt){
				socket.emit('say', txt);
			}
		}
	</script>
</body>
</html>
``` 

















