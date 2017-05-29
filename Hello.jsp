<html>
<head><title>Hello JSP</title></head>
<body>
  <% String name=request.getParameter("name"); %>
  Hello, <%= name %>  
</body>
</html>
