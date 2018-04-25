package com.opendoormediadesign.houseandhome757;

import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.widget.EditText;

public class SetMessageDialog extends DialogFragment {
    public interface DialogListener {
        void onSetMessageCancel();
    }
    // Use this instance of the interface to deliver action events
    DialogListener mListener;
    int emailOrText;
    static SetMessageDialog newInstance(int num) {
        SetMessageDialog f = new SetMessageDialog();

        // Supply num input as an argument.
        Bundle args = new Bundle();
        args.putInt("num", num);
        f.setArguments(args);

        return f;
    }


    // Override the Fragment.onAttach() method to instantiate the NoticeDialogListener
    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
        // Verify that the host activity implements the callback interface
        try {
            // Instantiate the NoticeDialogListener so we can send events to the host
            mListener = (DialogListener) activity;
        } catch (ClassCastException e) {
            // The activity doesn't implement the interface, throw exception
            throw new ClassCastException(activity.toString()
                    + " must implement DialogListener");
        }
    }
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        emailOrText = getArguments().getInt("num");
    }
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        // Get the layout inflater
        LayoutInflater inflater = getActivity().getLayoutInflater();

        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        builder.setView(inflater.inflate(R.layout.message_dialog, null))
                // Add action buttons
                .setPositiveButton("OK", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        Dialog f = (Dialog) dialog;
                        String message = ((EditText) f.findViewById(R.id.referral_message)).getText().toString();

                        if (0==emailOrText){
                            Intent intent = new Intent(Intent.ACTION_SENDTO);
                            intent.setData(Uri.parse("mailto:")); // only email apps should handle this
//                            intent.putExtra(Intent.EXTRA_TEXT, message);
                            intent.putExtra(Intent.EXTRA_TEXT, message+"\nGo to newsimonpmatthews.simonpmatthews.com/realtor.apk to download.\nGo to newsimonpmatthews.simonpmatthews.com/app-instructions/ for help with installing.");
                            if (intent.resolveActivity(getActivity().getPackageManager()) != null) {
                                startActivity(intent);
                            }

                            /*Intent intent = new Intent(Intent.ACTION_SENDTO);
                            intent.setData(Uri.parse("mailto:")); // only email apps should handle this
                            //intent.putExtra(Intent.EXTRA_TEXT, message+"\nGo to newsimonpmatthews.simonpmatthews.com/realtor.apk to download.\nGo to newsimonpmatthews.simonpmatthews.com/app-instructions/ for help with installing.");
                            intent.putExtra(Intent.EXTRA_TEXT, message);

                            if (intent.resolveActivity(getActivity().getPackageManager()) != null) {
                                startActivity(intent);
                            }*/
                        }
                        else if (1==emailOrText){
                            Intent intent = new Intent(Intent.ACTION_SENDTO);
                            intent.setData(Uri.parse("smsto:"));
//                            intent.putExtra("sms_body", message);
                            intent.putExtra("sms_body", message+"\nGo to newsimonpmatthews.simonpmatthews.com/realtor.apk to download.\nGo to newsimonpmatthews.simonpmatthews.com/app-instructions/ for help with installing.");
                            intent.putExtra(Intent.EXTRA_TEXT, message+"\nGo to newsimonpmatthews.simonpmatthews.com/realtor.apk to download.\nGo to newsimonpmatthews.simonpmatthews.com/app-instructions/ for help with installing.");
//                            intent.putExtra(Intent.EXTRA_TEXT, message);


                            if (intent.resolveActivity(getActivity().getPackageManager()) != null) {
                                startActivity(intent);
                            }

                        }
                    }
                })
                .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.cancel();
                        mListener.onSetMessageCancel();
                    }
                });
        return builder.create();
    }
}