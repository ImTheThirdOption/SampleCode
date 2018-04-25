package com.opendoormediadesign.houseandhome757;


import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

class ConversationDatabase  extends SQLiteOpenHelper {
    private static final int DATABASE_VERSION = BuildConfig.VERSION_CODE;
    private static final String DATABASE_NAME = "conversations";
    private static final String TABLE_CONVERSATIONS_WITH = "conversationswith";
    private static final String TABLE_LAST_MESSAGES = "last_messages";
    private static final String KEY_ID = "_id";
    private static final String KEY_MESSAGE = "message";
    private static final String KEY_SEND_OR_RECEIVE = "send_or_receive";
    private static final String KEY_FIRST_NAME = "first_name";
    private static final String KEY_LAST_NAME = "last_name";

    private static ConversationDatabase instance;

    static synchronized ConversationDatabase getDatabase(Context context)
    {
        if (instance == null) {
            instance = new ConversationDatabase(context);
        }

        return instance;
    }

    private ConversationDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    @Override
    public void onCreate(SQLiteDatabase db) {
        String CREATE_LAST_MESSAGES_TABLE = "CREATE TABLE " + TABLE_LAST_MESSAGES + "("
        + KEY_ID + " INTEGER PRIMARY KEY, " + KEY_FIRST_NAME + " TEXT, " + KEY_LAST_NAME + " TEXT, " + KEY_MESSAGE + " TEXT" + ")";
        db.execSQL(CREATE_LAST_MESSAGES_TABLE);
    }
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }
    void addMessage(String firstName, String lastName, String message, int sendOrReceive) {
        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor = db.rawQuery("SELECT 1 FROM " + TABLE_LAST_MESSAGES + " WHERE (" + KEY_FIRST_NAME + " LIKE ? AND " + KEY_LAST_NAME + " LIKE ?)", new String[] {firstName, lastName});
        String fullTableName = TABLE_CONVERSATIONS_WITH+firstName.toLowerCase()+lastName.toLowerCase();
        if(cursor.getCount() <= 0){
            cursor.close();
            db.execSQL("CREATE TABLE IF NOT EXISTS '" + fullTableName + "' (" + KEY_ID + " INTEGER PRIMARY KEY, " + KEY_MESSAGE + " TEXT, " + KEY_SEND_OR_RECEIVE + " INTEGER)");
        }
        else {
            cursor.close();
            db.execSQL("DELETE FROM " + TABLE_LAST_MESSAGES + " WHERE (" + KEY_FIRST_NAME + " LIKE ? AND " + KEY_LAST_NAME + " LIKE ?)", new String[] {firstName, lastName});
        }
        db.execSQL("INSERT INTO '" + fullTableName + "' (" + KEY_MESSAGE + ", " + KEY_SEND_OR_RECEIVE + ") VALUES (?, ?)", new String[] {message, String.valueOf(sendOrReceive)});
        db.execSQL("INSERT INTO " + TABLE_LAST_MESSAGES + " (" + KEY_FIRST_NAME + ", " + KEY_LAST_NAME + ", " + KEY_MESSAGE + ") VALUES (?, ?, ?)", new String[] {firstName, lastName, message});
        db.close();
    }
    Cursor loadHistory(String tableName){
        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor = null;
        String fullTableName = TABLE_CONVERSATIONS_WITH+tableName.toLowerCase();
        try {
            db.execSQL("CREATE TABLE IF NOT EXISTS '" + fullTableName + "' (" + KEY_ID + " INTEGER PRIMARY KEY, " + KEY_MESSAGE + " TEXT, " + KEY_SEND_OR_RECEIVE + " INTEGER)");
            cursor = db.rawQuery("SELECT " + KEY_ID + ", " + KEY_MESSAGE + ", " + KEY_SEND_OR_RECEIVE + " FROM '" + fullTableName+"'", null);
        }
        catch (SQLiteException e){
            e.printStackTrace();
        }
        return cursor;
    }
    Cursor loadLastMessages(){
        SQLiteDatabase db = this.getWritableDatabase();

        return db.rawQuery("SELECT * FROM " + TABLE_LAST_MESSAGES + " ORDER BY " + KEY_ID + " DESC", null);
    }
    void deleteConversation(String firstName, String lastName){
        SQLiteDatabase db = this.getWritableDatabase();
        String fullTableName = TABLE_CONVERSATIONS_WITH+firstName.toLowerCase()+lastName.toLowerCase();
        db.execSQL("DELETE FROM " + TABLE_LAST_MESSAGES + " WHERE (" + KEY_FIRST_NAME + " LIKE ? AND " + KEY_LAST_NAME + " LIKE ?)", new String[] {firstName, lastName});
        db.execSQL("DROP TABLE IF EXISTS " + fullTableName);
    }
    public int getLastMessageCount() {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_LAST_MESSAGES, null);
        cursor.close();

        return cursor.getCount();
    }
}