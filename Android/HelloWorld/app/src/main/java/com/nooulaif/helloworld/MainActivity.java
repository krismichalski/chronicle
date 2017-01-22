package com.nooulaif.helloworld;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.content.Intent;
import android.view.View;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    /** Called when the user clicks the gotoSearchFlight button */
    public void gotoSearchFlight(View view) {
        Intent intent = new Intent(this, FlightsSearchActivity.class);
        startActivity(intent);
    }

    /** Called when the user clicks the gotoContacts button */
    public void gotoContacts(View view) {
        Intent intent = new Intent(this, Contacts.class);
        startActivity(intent);
    }
}
