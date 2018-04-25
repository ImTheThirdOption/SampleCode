package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.Spinner;

public class SelectRecipientDialog extends DialogFragment {
    String[] firstNames, lastNames;
    static SelectRecipientDialog newInstance(String[] firstNames, String[] lastNames) {
        SelectRecipientDialog f = new SelectRecipientDialog();

        Bundle args = new Bundle();
        args.putStringArray("firstNames", firstNames);
        args.putStringArray("lastNames", lastNames);
        f.setArguments(args);

        return f;
    }

    public interface DialogListener {
        void onRecipientChosen(String firstName, String lastName);
    }
    SelectRecipientDialog.DialogListener mListener;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        try {
            mListener = (SelectRecipientDialog.DialogListener) activity;
        } catch (ClassCastException e) {
            throw new ClassCastException(activity.toString()
                    + " must implement RegisterNameDialogListener");
        }
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        firstNames = getArguments().getStringArray("firstNames");
        lastNames = getArguments().getStringArray("lastNames");

        LayoutInflater inflater = getActivity().getLayoutInflater();
        LinearLayout linearLayout = (LinearLayout) inflater.inflate(R.layout.select_recipient_dialog, null);

        final Spinner spinner = (Spinner) linearLayout.findViewById(R.id.recipients_spinner);

        String[] allContactsFullNames = new String[firstNames.length];
        for (int i=0; i<firstNames.length; i++){
            allContactsFullNames[i] = firstNames[i]+" "+lastNames[i];
        }

        ArrayAdapter<String> adapter = new ArrayAdapter<String>(getActivity(), R.layout.spinner_layout, allContactsFullNames);
        spinner.setAdapter(adapter);



        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setView(linearLayout)
                .setPositiveButton("Ok", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        mListener.onRecipientChosen(firstNames[(int)spinner.getSelectedItemId()],lastNames[(int)spinner.getSelectedItemId()]);
                    }
                })
                .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        SelectRecipientDialog.this.getDialog().cancel();
                    }
                });
        return builder.create();
    }
}
