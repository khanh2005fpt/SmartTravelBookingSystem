/*
* Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
* Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
*/
package controller.account;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import constant.Iconstant;
import java.io.IOException;
import model.GoogleAccount;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;

import org.apache.http.client.fluent.Request;
/**
*
* @author nqagh
*/
public class GoogleLogin {
   //nhan token  , truyen code de nhan access token

   public static String getToken(String code) throws ClientProtocolException, IOException {
       System.out.println("=== getToken called ===");
       System.out.println("Auth code: " + code);
       String response = Request.Post(Iconstant.GOOGLE_LINK_GET_TOKEN)
               .bodyForm(
                       // form object
                       Form.form()
                               .add("client_id", Iconstant.GOOGLE_CLIENT_ID)
                               .add("client_secret", Iconstant.GOOGLE_CLIENT_SECRET)
                               .add("redirect_uri", Iconstant.GOOGLE_REDIRECT_URI)
                               // code la ma xac thu nhan tu ham
                               .add("code", code)
                               // RANT_TYPE : Dai dien cho phuong thuc cap quyen truy cap
                               .add("grant_type", Iconstant.GOOGLE_GRANT_TYPE)
                               .build()
               )
               .execute().returnContent().asString();
       System.out.println("Token Response: " + response);

       JsonObject jobj = new Gson().fromJson(response, JsonObject.class);

       String accessToken = jobj.get("access_token").toString().replaceAll("\"", "");

       return accessToken;

   }
   // ham nay tra ve thong tin (doi tuong) tai khoan khi truyen accessToken
   //getUserInfo dung de gui yeu cau  httpGet den google de lay thong tin User = ma accessToken
   public static GoogleAccount getUserInfo(final String accessToken) throws ClientProtocolException, IOException {

       String link = Iconstant.GOOGLE_LINK_GET_USER_INFO + accessToken; // noi them acctoken de dam bao yeu cau dc xac thuc
       // nhan phan hoi tu goole
       String response = Request.Get(link).execute().returnContent().asString();

       GoogleAccount googlePojo = new Gson().fromJson(response, GoogleAccount.class);

       return googlePojo;

   }
}
