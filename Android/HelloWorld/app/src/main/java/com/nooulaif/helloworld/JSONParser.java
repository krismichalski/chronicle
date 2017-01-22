package com.nooulaif.helloworld;

import android.os.StrictMode;
import android.util.Log;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;

public class JSONParser {

    static InputStream is = null;
    static JSONObject json = null;
    static JSONArray json_array = null;
    static String output = "";

    // constructor
    public JSONParser() {
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
    }

    public JSONObject getJSONObjectFromUrl(String url, List params) {
        URL _url;
        HttpURLConnection urlConnection;

        try {
            _url = new URL(url);
            urlConnection = (HttpURLConnection) _url.openConnection();
        }
        catch (MalformedURLException e) {
            Log.e("JSON Parser", "Error due to a malformed URL " + e.toString());
            return null;
        }
        catch (IOException e) {
            Log.e("JSON Parser", "IO error " + e.toString());
            return null;
        }

        try {
            is = new BufferedInputStream(urlConnection.getInputStream());
            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            StringBuilder total = new StringBuilder(is.available());
            String line;
            while ((line = reader.readLine()) != null) {
                total.append(line).append('\n');
            }
            output = total.toString();
        }
        catch (IOException e) {
            Log.e("JSON Parser", "IO error " + e.toString());
            return null;
        }
        finally {
            urlConnection.disconnect();
        }

        try {
            json = new JSONObject(output);
        }
        catch (JSONException e) {
            Log.e("JSON Parser", "Error parsing data " + e.toString());
        }

        return json;
    }

    public JSONArray getJSONArrayFromUrl(String url, List params) {
        URL _url;
        HttpURLConnection urlConnection;

        try {
            _url = new URL(url);
            urlConnection = (HttpURLConnection) _url.openConnection();
        }
        catch (MalformedURLException e) {
            Log.e("JSON Parser", "Error due to a malformed URL " + e.toString());
            return null;
        }
        catch (IOException e) {
            Log.e("JSON Parser", "IO error " + e.toString());
            return null;
        }

        try {
            is = new BufferedInputStream(urlConnection.getInputStream());
            BufferedReader reader = new BufferedReader(new InputStreamReader(is));
            StringBuilder total = new StringBuilder(is.available());
            String line;
            while ((line = reader.readLine()) != null) {
                total.append(line).append('\n');
            }
            output = total.toString();
        }
        catch (IOException e) {
            Log.e("JSON Parser", "IO error " + e.toString());
            return null;
        }
        finally {
            urlConnection.disconnect();
        }

        try {
            json_array = new JSONArray(output);
        }
        catch (JSONException e) {
            Log.e("JSON Parser", "Error parsing data " + e.toString());
        }

        return json_array;
    }
}