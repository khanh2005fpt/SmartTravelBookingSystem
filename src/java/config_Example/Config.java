/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package config_Example;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 *
 * @author nqagh
 */
public class Config {
     private static Properties properties = new Properties();

    static {
        try {
          
            InputStream input = config.Config.class.getClassLoader().getResourceAsStream("config/config.properties");

            if (input ==null) {
           
                input = config.Config.class.getClassLoader().getResourceAsStream("config.properties");
            }

            if (input == null) {
                throw new RuntimeException("Không tìm thấy file config.properties trong classpath!");
            }

            properties.load(input);

        } catch (IOException e) {
            throw new RuntimeException("Lỗi khi đọc config.properties", e);
        }
    }

    public static String get(String key) {
        return properties.getProperty(key);
    }
}
