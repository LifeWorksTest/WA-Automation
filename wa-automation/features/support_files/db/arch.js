db.user.insert({
 	"_id": ObjectId("54f42e9f29c48c14068b4588"),
  "display_name": "lifeworkstesting",
  "email": "lifeworkstesting@lifeworks.com",
  "password": "$2y$14$QWfDsGqibELloD8zeRZoouLBYl119hHjxQNxr4OUMfWPve5HobsQy",
  "roles": [
    {
      "$ref": "role",
      "$id": ObjectId("525d9d5ad474f8a092424062"),
      "$db": "arch" 
    },
    {
      "$ref": "role",
      "$id": ObjectId("525d9d5ad474f8a092424063"),
      "$db": "arch" 
    } 
  ],
  "state": NumberLong(2)
});

/** role indexes **/
db.getCollection("role").ensureIndex({
  "_id": NumberInt(1)
},[
  
]);

/** role records **/
db.getCollection("role").insert({
  "_id": ObjectId("525d9d5ad474f8a092424060"),
  "role_id": "guest",
  "label": "Guest"
});
db.getCollection("role").insert({
  "_id": ObjectId("525d9d5ad474f8a092424062"),
  "role_id": "user",
  "label": "User"
});
db.getCollection("role").insert({
  "_id": ObjectId("525d9d5ad474f8a092424061"),
  "role_id": "marketing",
  "label": "Marketing"
});
db.getCollection("role").insert({
  "_id": ObjectId("5295322c2f8d1f53a7924461"),
  "role_id": "account_manager",
  "label": "Account Manager"
});
db.getCollection("role").insert({
  "_id": ObjectId("528f7664950ff49e60a6e85f"),
  "role_id": "finance",
  "label": "Financial Accounts"
});
db.getCollection("role").insert({
  "_id": ObjectId("525d9d5ad474f8a092424063"),
  "role_id": "admin",
  "label": "Admin"
});

db.getCollection("sessions").insert({
   "_id": ObjectId("5624cc6829c48cb7358b4584"),
   "sessionId": "q6a8m1iacdt99hlffmsq2f5db6",
   "userId": "54f42e9f29c48c14068b4588" 
});


db.getCollection("role").insert({
    "_id" : ObjectId("527781d73f850366ab8bbab4"),
    "role_id" : "credit",
    "label" : "Credit Users"
});


db.getCollection("role").insert({
    "_id" : ObjectId("58886eb9e7eada3f2242b2b4"),
    "role_id" : "demo",
    "label" : "Demo"
});

db.getCollection("role").insert({
    "_id" : ObjectId("58886eb931fc5b1388bc6202"),
    "role_id" : "super_admin",
    "label" : "Super Admin"
});


