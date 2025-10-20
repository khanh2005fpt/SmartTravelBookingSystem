/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package constant_Example;

import config_Example.Config;

/**
 *
 * @author nqagh
 */
public class Iconstant {

    public static final String GOOGLE_CLIENT_ID = Config.get("GOOGLE_CLIENT_ID");

    public static final String GOOGLE_CLIENT_SECRET = Config.get("GOOGLE_CLIENT_SECRET");

    public static final String GOOGLE_REDIRECT_URI = Config.get("GOOGLE_REDIRECT_URI");

    public static final String GOOGLE_GRANT_TYPE = "authorization_code";

    public static final String GOOGLE_LINK_GET_TOKEN = "https://oauth2.googleapis.com/token";

    // duong dan toi API Google de lay thong tin cua User
    public static final String GOOGLE_LINK_GET_USER_INFO = "https://www.googleapis.com/oauth2/v1/userinfo?access_token=";
}
