package com.opendoormediadesign.houseandhome757;

import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.RelativeSizeSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

public class RegistrationDialog extends DialogFragment {

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        // Get the layout inflater
        LayoutInflater inflater = getActivity().getLayoutInflater();

        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        View view = inflater.inflate(R.layout.registration_dialog, null);
        builder.setView(view);
        TextView textView = (TextView)view.findViewById(R.id.registration_header);
        SpannableString spannableString=  new SpannableString("Registration (optional)");
        spannableString.setSpan(new RelativeSizeSpan(0.5f), 13, 23, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
        textView.setText(spannableString);
        return builder.create();
    }
}
