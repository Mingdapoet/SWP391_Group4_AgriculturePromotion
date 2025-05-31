<% 
    String message = request.getParameter("message");
    String sessionMessage = (String) session.getAttribute("message");
    System.out.println("notification.jsp: URL message=" + message + ", Session message=" + sessionMessage);
%>
<% if (sessionMessage != null && !sessionMessage.trim().isEmpty()) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= sessionMessage %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% session.removeAttribute("message"); %>
<% } else if (message != null && !message.trim().isEmpty()) { %>
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= message %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<% } %>