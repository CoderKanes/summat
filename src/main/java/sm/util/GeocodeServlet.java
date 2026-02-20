package sm.util;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.net.*;

public class GeocodeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String q = req.getParameter("q");
        if (q == null || q.isEmpty()) {
            resp.sendError(400, "Missing q");
            return;
        }

        String urlStr =
            "https://nominatim.openstreetmap.org/search?format=json&q=" +
            URLEncoder.encode(q, "UTF-8");

        URL url = new URL(urlStr);
        System.out.println(url.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("User-Agent", "my-map-app"); // ★ 중요
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);

        resp.setContentType("application/json; charset=UTF-8");

        try (
            BufferedReader in = new BufferedReader(
                new InputStreamReader(conn.getInputStream(), "UTF-8"));
            PrintWriter out = resp.getWriter()
        ) {
            String line;
            while ((line = in.readLine()) != null) {
                out.write(line);
            }
        }
    }
}