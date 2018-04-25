package com.opendoormediadesign.houseandhome757;


import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.AlertDialog;

public class ChooseRecipientURIDialog extends DialogFragment {
    String[] allChoices;
    String[] phoneArray;
    String[] emailArray;
    static ChooseRecipientURIDialog newInstance(String[] allChoices, String[] phoneArray, String[] emailArray) {
        ChooseRecipientURIDialog f = new ChooseRecipientURIDialog();

        Bundle args = new Bundle();
        args.putStringArray("allChoices", allChoices);
        args.putStringArray("phoneArray", phoneArray);
        args.putStringArray("emailArray", emailArray);
        f.setArguments(args);
        return f;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        allChoices = getArguments().getStringArray("allChoices");
        phoneArray = getArguments().getStringArray("phoneArray");
        emailArray = getArguments().getStringArray("emailArray");
    }
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setTitle("Choose a phone number or email address")
                .setItems(allChoices, new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        int number = phoneArray.length;
                        if (which < number){
                            Intent intent = new Intent(Intent.ACTION_SENDTO);
                            intent.setData(Uri.parse("smsto:"+phoneArray[which]));
                            intent.putExtra("address", phoneArray[which]);
                            intent.putExtra("sms_body", "I would like to share the " + getResources().getString(R.string.app_name) + " app with you. Go to " + getResources().getString(R.string.open_door_realtor_website) + " for more information and download links.");
                            intent.putExtra(Intent.EXTRA_TEXT, "I would like to share the " + getResources().getString(R.string.app_name) + " app with you. Go to " + getResources().getString(R.string.open_door_realtor_website) + " for more information and download links.");
                            if (intent.resolveActivity(getActivity().getPackageManager()) != null) {
                                startActivity(intent);
                            }
                        }
                        else {
                            Intent intent = new Intent(Intent.ACTION_SENDTO);
                            intent.setData(Uri.parse("mailto:"+emailArray[which-number])); // only email apps should handle this
                            intent.putExtra(Intent.EXTRA_TEXT, "I would like to share the " + getResources().getString(R.string.app_name) + " app with you. Go to " + getResources().getString(R.string.open_door_realtor_website) + " for more information and download links.");
                            if (intent.resolveActivity(getActivity().getPackageManager()) != null) {
                                startActivity(intent);
                            }
                        }
                    }
                });
        return builder.create();
    }
}
