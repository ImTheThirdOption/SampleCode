package com.opendoormediadesign.houseandhome757;

import android.app.IntentService;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

public class ConversationHistory extends IntentService {
    private static final String ACTION_SAVE_CONVERSATION = "com.opendoormediadesign.houseandhome757.action.save.conversation";
    private static final String ACTION_LOAD_CONVERSATION = "com.opendoormediadesign.houseandhome757.action.load.conversation";
    private static final String ACTION_LOAD_LAST_MESSAGES = "com.opendoormediadesign.houseandhome757.action.load.last.messages";
    public ConversationHistory() {
        super("ConversationHistory");
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        if (intent != null) {
            String action = intent.getStringExtra("action");
            if (ACTION_SAVE_CONVERSATION.equals(action)) {
                saveHistory(intent.getStringExtra("firstName"), intent.getStringExtra("lastName"), intent.getStringExtra("message"), intent.getIntExtra("sendOrReceive", -1));
            }
            else if (ACTION_LOAD_CONVERSATION.equals(action)){
                loadHistory(intent.getStringExtra("firstName")+"-"+intent.getStringExtra("lastName"));
            }
            else if (ACTION_LOAD_LAST_MESSAGES.equals(action)){
                loadLastMessages();
            }
        }
    }

    private void saveHistory(String firstName, String lastName, String message, int sendOrReceive) {
        String fileName = firstName+"-"+lastName;
        DataInputStream reader;
        int number = 1;
        int numberOfConversations = 1;
        try {
            reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/"+fileName+"-number")));
            number = reader.readInt()+1;
            reader.close();
        }
        catch (FileNotFoundException e){
            try {
                reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/numberOfConversations")));
                numberOfConversations = reader.readInt()+1;
                reader.close();
                number = 1;
            } catch (FileNotFoundException e1) {
                numberOfConversations = 1;
                e1.printStackTrace();
            } catch (IOException e1) {
                e1.printStackTrace();
            }
            DataOutputStream writer;
            try {
                writer = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(getFilesDir()+"/numberOfConversations")));
                writer.writeInt(numberOfConversations);
                writer.close();
                writer = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(getFilesDir()+"/firstNames", true)));
                writer.writeUTF(firstName);
                writer.close();
                writer = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(getFilesDir()+"/lastNames", true)));
                writer.writeUTF(lastName);
                writer.close();
            } catch (IOException e1) {
                e1.printStackTrace();
            }


        } catch (IOException e1) {
            e1.printStackTrace();
        }

        try{
            DataOutputStream writer;
            writer = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(getFilesDir()+"/"+fileName+"-number")));
            writer.writeInt(number);
            writer.close();


            writer = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(getFilesDir()+"/"+fileName+"-message", true)));
            writer.writeUTF(message);
            writer.close();

            writer = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(getFilesDir()+"/"+fileName+"-direction", true)));
            writer.writeInt(sendOrReceive);
            writer.close();

            writer = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(getFilesDir()+"/"+fileName+"-lastMessage")));
            writer.writeUTF(message);
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    private void loadHistory(String fileName){
        String[] conversation = null;
        int number=0;
        int[] direction = null;

        try {
            DataInputStream reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/"+fileName+"-number")));
            number = reader.readInt();
            reader.close();
        }
        catch (FileNotFoundException e){number = 0;} catch (IOException e1) {
            e1.printStackTrace();
        }
        try{
            DataInputStream reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/"+fileName+"-message")));
            conversation = new String[number];
            for (int i=0; i<number; i++){
                conversation[i] = reader.readUTF();
            }
            reader.close();
            reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/"+fileName+"-direction")));
            direction = new int[number];
            for (int i=0; i<number; i++) {
                direction[i] = reader.readInt();
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        Intent intent = new Intent ("conversationhistory");
        intent.putExtra("conversation", conversation);
        intent.putExtra("direction", direction);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }
    private void loadLastMessages(){
        String[] firstNames = null;
        String[] lastNames = null;
        String[] lastMessages = null;
        int numberOfConversations=0;

        try {
            DataInputStream reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/numberOfConversations")));
            numberOfConversations = reader.readInt();
            reader.close();
        }
        catch (FileNotFoundException e){numberOfConversations = 0;} catch (IOException e1) {
            e1.printStackTrace();
        }
        try{
            DataInputStream reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/firstNames")));
            firstNames = new String[numberOfConversations];
            for (int i=0; i<numberOfConversations; i++){
                firstNames[i] = reader.readUTF();
            }
            reader.close();
            reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/lastNames")));
            lastNames = new String[numberOfConversations];
            for (int i=0; i<numberOfConversations; i++) {
                lastNames[i] = reader.readUTF();
            }
            reader.close();
            lastMessages = new String[numberOfConversations];
            for (int i=0; i<numberOfConversations; i++) {
                reader = new DataInputStream(new BufferedInputStream(new FileInputStream(getFilesDir()+"/"+firstNames[i]+"-"+lastNames[i]+"-lastMessage")));
                lastMessages[i] = reader.readUTF();
                reader.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        Intent intent = new Intent ("lastmessagesloaded");
        intent.putExtra("firstNames", firstNames);
        intent.putExtra("lastNames", lastNames);
        intent.putExtra("lastMessages", lastMessages);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }
}