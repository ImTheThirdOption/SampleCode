package com.opendoormediadesign.houseandhome757;


import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

class NotificationsDatabase  extends SQLiteOpenHelper {
    private static final int DATABASE_VERSION = BuildConfig.VERSION_CODE;
    private static final String DATABASE_NAME = "notifications";
    private static final String TABLE_MY_NOTIFICATIONS = "mynotifications";
    private static final String KEY_ID = "_id";
    private static final String KEY_TYPE = "type";
    private static final String KEY_FIRST = "first";
    private static final String KEY_SECOND = "second";
    private static final String KEY_THIRD = "third";

    private static NotificationsDatabase instance;

    static synchronized NotificationsDatabase getDatabase(Context context)
    {
        if (instance == null) {
            instance = new NotificationsDatabase(context);
        }

        return instance;
    }

    private NotificationsDatabase(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    @Override
    public void onCreate(SQLiteDatabase db) {
        String CREATE_MY_NOTIFICATIONS_TABLE = "CREATE TABLE " + TABLE_MY_NOTIFICATIONS + "("
                + KEY_ID + " INTEGER PRIMARY KEY, " + KEY_TYPE + " TEXT, " + KEY_FIRST + " TEXT, " + KEY_SECOND + " TEXT, " + KEY_THIRD + " TEXT" + ")";
        db.execSQL(CREATE_MY_NOTIFICATIONS_TABLE);
    }
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }
    int addNotification(String type, String first, String second, String third) {
        SQLiteDatabase db = this.getWritableDatabase();
        //db.rawQuery("INSERT INTO " + TABLE_MY_NOTIFICATIONS + " (" + KEY_TYPE + ", " + KEY_FIRST + ", " + KEY_SECOND + ", " + KEY_THIRD + ") VALUES (?, ?, ?, ?)", new String[] {type, first, second, third});
        ContentValues values = new ContentValues();
        values.put(KEY_TYPE, type);
        values.put(KEY_FIRST, first);
        values.put(KEY_SECOND, second);
        values.put(KEY_THIRD, third);
        int id = (int) db.insert(TABLE_MY_NOTIFICATIONS, null, values);
        db.close();
        return id;
    }
    Cursor loadNotifications(){
        SQLiteDatabase db = this.getWritableDatabase();

        return db.rawQuery("SELECT * FROM " + TABLE_MY_NOTIFICATIONS + " ORDER BY " + KEY_ID + " DESC", null);
    }
    Cursor loadNotifications(String notificationNumber){
        SQLiteDatabase db = this.getWritableDatabase();
        return db.rawQuery("SELECT * FROM " + TABLE_MY_NOTIFICATIONS + " WHERE " + KEY_ID + " = ?", new String[] {notificationNumber});
    }
    Cursor loadNotificationsFling(String direction, String notificationNumber){
        SQLiteDatabase db = this.getWritableDatabase();
        String query = null;
        if (direction.equals("left")) {
            query = "SELECT * FROM " + TABLE_MY_NOTIFICATIONS + " WHERE " + KEY_ID + " < ?" + " ORDER BY " + KEY_ID + " DESC LIMIT 1";
        }
        else if (direction.equals("right")){
            query = "SELECT * FROM " + TABLE_MY_NOTIFICATIONS + " WHERE " + KEY_ID + " > ?" + " ORDER BY " + KEY_ID + " ASC LIMIT 1";
        }
        return db.rawQuery(query, new String[]{notificationNumber});
    }

    void deleteNotification(String id){
        SQLiteDatabase db = this.getWritableDatabase();
        db.execSQL("DELETE FROM " + TABLE_MY_NOTIFICATIONS + " WHERE (" + KEY_ID + " = ?)", new String[] {id});
    }
    void deleteAllNotifications(){
        SQLiteDatabase db = this.getWritableDatabase();
        db.execSQL("DELETE FROM " + TABLE_MY_NOTIFICATIONS);
    }

    public int getLastMessageCount() {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery("SELECT * FROM " + TABLE_MY_NOTIFICATIONS, null);
        cursor.close();

        return cursor.getCount();
    }
}
