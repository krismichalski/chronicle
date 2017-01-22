package com.nooulaif.helloworld;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.View;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class Contacts extends AppCompatActivity {

    private RecyclerView mRecyclerView;
    private RecyclerView.Adapter mAdapter;
    private RecyclerView.LayoutManager mLayoutManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_contacts);

        ArrayList contacts = new ArrayList<>();

        try {
            JSONParser jsonParser = new JSONParser();
            JSONArray contacts_json = jsonParser.getJSONArrayFromUrl("http://10.0.2.2:3000/contacts", null);

            for (int i = 0; i < contacts_json.length(); i++) {
                JSONObject contact_json = contacts_json.getJSONObject(i);

                Contact contact = new Contact();
                contact.setId(contact_json.getInt("id"));
                contact.setFirstName(contact_json.getString("first_name"));
                contact.setLastName(contact_json.getString("last_name"));
                contact.setPhone(contact_json.getString("phone"));
                contact.setGender(contact_json.getString("gender"));

                contacts.add(contact);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        mRecyclerView = (RecyclerView) findViewById(R.id.contacts_list);

        // use this setting to improve performance if you know that changes
        // in content do not change the layout size of the RecyclerView
        mRecyclerView.setHasFixedSize(true);

        // use a linear layout manager
        mLayoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(mLayoutManager);

        // specify an adapter (see also next example)
        mAdapter = new ContactsAdapter(contacts);
        mRecyclerView.setAdapter(mAdapter);

        mRecyclerView.addOnItemTouchListener(
            new RecyclerItemClickListener(this, new RecyclerItemClickListener.OnItemClickListener() {
                @Override
                public void onItemClick(View view, int position) {
                    Context context = getApplicationContext();
                    CharSequence text = getString(R.string.contact_copied);
                    int duration = Toast.LENGTH_SHORT;

                    Toast toast = Toast.makeText(context, text, duration);
                    toast.show();
                }
            })
        );
    }
}
