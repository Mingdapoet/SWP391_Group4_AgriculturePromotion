package controller.login;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import dal.UserDAO;
import domain.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GoogleCallbackServlet", urlPatterns = {"/googleCallback"})
public class GoogleCallbackServlet extends HttpServlet {
    private static final String CLIENT_ID = "799257369726-5f4bmtll9vr8hb1e066asncb2c1i0m4t.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/AgriculturePromotion/googleCallback";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            request.setAttribute("error", "Authorization code not found");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Exchange authorization code for access token
            GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                    new NetHttpTransport(),
                    GsonFactory.getDefaultInstance(),
                    "https://oauth2.googleapis.com/token",
                    CLIENT_ID,
                    CLIENT_SECRET,
                    code,
                    REDIRECT_URI)
                    .execute();

            // Get ID token
            GoogleIdToken idToken = tokenResponse.parseIdToken();
            GoogleIdToken.Payload payload = idToken.getPayload();

            // Get user information
            String email = payload.getEmail();
            String name = (String) payload.get("name");

            // Check if user exists in database or register new user
            UserDAO dao = new UserDAO();
            User user = dao.getUserByEmail(email);
            if (user == null) {
                // Register new user with Google info
                boolean success = dao.register(
                        email,
                        null,
                        "customer",
                        null,
                        null,
                        null,
                        name != null ? name : "",
                        null
                );
                if (!success) {
                    System.err.println("Failed to register user with email: " + email);
                    request.setAttribute("error", "Failed to register Google user. Email may already exist or database error.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                user = dao.getUserByEmail(email);
            }

            request.getSession().setAttribute("user", user);

            response.sendRedirect(request.getContextPath() + "/index.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Google login failed: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}