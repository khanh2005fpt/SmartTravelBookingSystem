FROM tomcat:10.1-jdk17 AS build
WORKDIR /app
COPY . .
# Iconstant.java is gitignored (secrets) -> generate one that reads Render env vars
RUN mkdir -p src/java/constant && [ -f src/java/constant/Iconstant.java ] || printf '%s\n' \
 'package constant;' \
 'public class Iconstant {' \
 '  private static String env(String k, String d) { String v = System.getenv(k); return v == null ? d : v; }' \
 '  public static final String GOOGLE_CLIENT_ID = env("GOOGLE_CLIENT_ID", "");' \
 '  public static final String GOOGLE_CLIENT_SECRET = env("GOOGLE_CLIENT_SECRET", "");' \
 '  public static final String GOOGLE_REDIRECT_URI = env("GOOGLE_REDIRECT_URI", "");' \
 '  public static final String GOOGLE_GRANT_TYPE = "authorization_code";' \
 '  public static final String GOOGLE_LINK_GET_TOKEN = "https://accounts.google.com/o/oauth2/token";' \
 '  public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";' \
 '}' > src/java/constant/Iconstant.java
RUN mkdir -p out/WEB-INF/classes && cp -r web/* out/ \
 && find src/java -name "*.java" > srcs.txt \
 && javac -encoding UTF-8 -nowarn -d out/WEB-INF/classes \
    -cp "web/WEB-INF/lib/*:/usr/local/tomcat/lib/*" @srcs.txt \
 && cd src/java && find . -type f ! -name "*.java" -exec cp --parents {} /app/out/WEB-INF/classes/ \;

FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/out /usr/local/tomcat/webapps/ROOT
EXPOSE 8080
