package com.nooulaif.helloworld;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.widget.DatePicker;
import android.widget.TextView;

import java.util.Calendar;

public class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        // Use the current date as the default date in the picker
        final Calendar c = Calendar.getInstance();
        int year = c.get(Calendar.YEAR);
        int month = c.get(Calendar.MONTH);
        int day = c.get(Calendar.DAY_OF_MONTH);

        // Create a new instance of DatePickerDialog and return it
        return new DatePickerDialog(getActivity(), this, year, month, day);
    }

    public void onDateSet(DatePicker view, int year, int month, int day) {
        // Do something with the date chosen by the user
        TextView tv = null;
        switch (getTag()) {
            case "editWhenStart":
                tv = (TextView) getActivity().findViewById(R.id.editWhenStart);
                break;
            case "editWhenEnd":
                tv = (TextView) getActivity().findViewById(R.id.editWhenEnd);
                break;
        }

        tv.setText(view.getDayOfMonth() + "-" + (view.getMonth() + 1) + "-" + view.getYear());
    }
}