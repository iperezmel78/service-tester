/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.sidc.service.tester.utils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 *
 * @author admin
 */
public class PropertyLoader {

    public static Map<String, String> getServicesKeyValues(String[] keys) throws IOException {
        Map<String, String> values = new HashMap();
        Properties props = new Properties();
        props.load(PropertyLoader.class.getClassLoader().getResourceAsStream("config.properties"));
        for (String s : keys) {
            values.put(props.getProperty("service." + s + ".url"), 
                    props.getProperty("service." + s + ".val"));
        }
        return values;
    }

}
