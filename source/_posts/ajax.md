---
title: ajax
date: 2017-08-21 23:59:47
category:
tags: ajax
---
配起来nginx就可以学ajax了
[ajax w3schools](https://www.w3schools.com/xml/ajax_intro.asp)

```html
<!DOCTYPE html>
<html>
<meta charset="utf-8">
<head>
	<title>天文望远镜</title>
</head>
<body>
<div id="demo">
	<h1>XMLHttpRequest</h1>
	<button type="button" onclick="loadDoc()">Change Content</button>
</div>
<script type="text/javascript">
	function loadDoc(){
		var xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function(){
			if(this.readyState == 4 && this.status == 200){
				document.getElementById("demo").innerHTML = this.responseText;
			}
		};
		xhttp.open("GET", "ajax_info.txt", true);
		xhttp.send();
	}
</script>
</body>
</html>
```


