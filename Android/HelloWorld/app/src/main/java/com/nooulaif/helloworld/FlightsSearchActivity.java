package com.nooulaif.helloworld;

import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.TextView;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;

public class FlightsSearchActivity extends AppCompatActivity {

    private SeekBar editNumberOfAdults;
    private TextView textNumberOfAdults;

    private SeekBar editNumberOfKids;
    private TextView textNumberOfKids;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_flights_search);
        initializeVariables();

        textNumberOfAdults.setText(getString(R.string.number_of_adults) + " " + 0);
        textNumberOfKids.setText(getString(R.string.number_of_kids) + " " + 0);

        editNumberOfAdults.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progressValue, boolean fromUser) {
                textNumberOfAdults.setText(getString(R.string.number_of_adults) + " " + progressValue);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });

        editNumberOfKids.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progressValue, boolean fromUser) {
                textNumberOfKids.setText(getString(R.string.number_of_kids) + " " + progressValue);
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
            }
        });
    }

    public void showDatePickerDialog(View v) {
        DialogFragment newFragment = new DatePickerFragment();
        newFragment.show(getSupportFragmentManager(), v.getResources().getResourceEntryName(v.getId()));
    }

    // A private method to help us initialize our variables.
    private void initializeVariables() {
        editNumberOfAdults = (SeekBar) findViewById(R.id.editNumberOfAdults);
        textNumberOfAdults = (TextView) findViewById(R.id.textNumberOfAdults);
        editNumberOfKids = (SeekBar) findViewById(R.id.editNumberOfKids);
        textNumberOfKids = (TextView) findViewById(R.id.textNumberOfKids);
    }
}
