import 'dart:io';
import 'package:greentrition/database/server.dart';
import 'package:http/http.dart';
import 'package:graphql/client.dart';
import 'package:greentrition/classes/comment.dart';
import 'package:greentrition/classes/hot_item.dart';
import 'package:greentrition/classes/product.dart';
import 'package:greentrition/classes/product_suggestion_item.dart';
import 'package:greentrition/classes/user.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/database/authorization.dart';
import 'package:greentrition/database/mutations.dart';
import 'package:greentrition/database/queries.dart';
import 'package:greentrition/functions/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gql/ast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseDb {
  final product_collection = "codes";
  final information_collection = "information";
  final request_collection = "request";

  Future<Product> getProductById(String id) {
    return FirebaseFirestore.instance
        .collection(product_collection)
        .where("id", isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        return null;
      }
      var doc_data = value.docs.first.data();
      var additional_info = doc_data["additional_info"];
      String brands = doc_data["brands"];
      String code = doc_data["code"];
      String countries = doc_data["countries"];
      String date_added = doc_data["date_added"];
      String id = doc_data["id"];
      List<String> ingredients = [];
      if (doc_data["ingredients"] != null) {
        ingredients = List<String>.from(doc_data["ingredients"]);
      }
      String product_name = doc_data["product_name"];
      String quantity = doc_data["quantity"];
      String stores = doc_data["stores"];
      dynamic nutritional_values = doc_data["nutritional_values"];

      if (nutritional_values != null) {
        nutritional_values = Map<String, String>.from(nutritional_values);
      }
      return Product(additional_info, brands, code, countries, date_added, id,
          ingredients, product_name, quantity, stores, nutritional_values);
    });
  }

  Future<Product> getProductByCode(String code) {
    return FirebaseFirestore.instance
        .collection(product_collection)
        .where("code", isEqualTo: code)
        .get()
        .then((value) {
      if (value.docs.length == 0) {
        return null;
      }
      var doc_data = value.docs.first.data();
      var additional_info = doc_data["additional_info"];
      String brands = doc_data["brands"];
      String code = doc_data["code"];
      String countries = doc_data["countries"];
      String date_added = doc_data["date_added"];
      String id = doc_data["id"];
      List<String> ingredients = doc_data["ingredients"];
      String product_name = doc_data["product_name"];
      String quantity = doc_data["quantity"];
      String stores = doc_data["stores"];
      dynamic nutritional_values = doc_data["nutritional_values"];

      if (nutritional_values != null) {
        nutritional_values = Map<String, String>.from(nutritional_values);
      }
      return Product(additional_info, brands, code, countries, date_added, id,
          ingredients, product_name, quantity, stores, nutritional_values);
    });
  }

  void saveProduct(Product product) {
    Map<String, dynamic> doc_data = {
      "id": product.id,
      "code": product.id,
      "product_name": product.product_name,
      "brands": product.brands,
      "ingredients": product.ingredients,
      "quantity": product.quantity,
      "nutritional_values": product.nutritional_values,
      "additional_info": product.additional_info,
      "stores": product.stores,
      "countries": product.countries,
      "date_added": product.date_added,
      "type": "new_product"
    };

    FirebaseFirestore.instance
        .collection(product_collection)
        .where("code", isEqualTo: product.code)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        print("Product already exists.");
      } else {
        FirebaseFirestore.instance
            // disables writing to codes directly.
            .collection(request_collection)
            .doc(product.id)
            .set(doc_data)
            .then((value) => print("Document written successfully"))
            .catchError((onError) {
          print(onError);
        });
      }
    });
  }

  void addBarcodeForExistingProduct(String id, String code) {
    Map<String, dynamic> doc_data = {
      "id": id,
      "code": code,
      "type": "add_barcode"
    };

    FirebaseFirestore.instance
        .collection(request_collection)
        .where("id", isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs[0].data()["type"] == "add_barcode") {
        print("Product already exists");
      } else {
        FirebaseFirestore.instance
            .collection(request_collection)
            .doc(id)
            .set(doc_data)
            .then((value) {
          print("Document written successfully!");
        });
      }
    });
  }

  void requestChangeExistingProduct(
      Product product, String annotation, String date_added, String change) {
    Map<String, dynamic> doc_data = {
      "id": product.id,
      "product_name": product.product_name,
      "brands": product.brands,
      "ingredients": product.ingredients,
      "annotation": annotation,
      "change": change,
      "type": "existing_product",
      "date_added": date_added
    };

    FirebaseFirestore.instance
        .collection(request_collection)
        .where("id", isEqualTo: product.id)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        print("Product already exists");
      } else {
        FirebaseFirestore.instance
            .collection(request_collection)
            .doc(product.id)
            .set(doc_data)
            .then((value) {
          print("Document written successfully");
        });
      }
    });
  }

  void requestNewProduct(Product product) {
    Map<String, dynamic> doc_data = {
      "id": product.id,
      "code": product.id,
      "product_name": product.product_name,
      "brands": product.brands,
      "ingredients": product.ingredients,
      "quantity": product.quantity,
      "nutritional_values": product.nutritional_values,
      "additional_info": product.additional_info,
      "stores": product.stores,
      "countries": product.countries,
      "date_added": product.date_added
    };
    FirebaseFirestore.instance
        .collection(product_collection)
        .where("code", isEqualTo: product.code)
        .get()
        .then((value) {
      if (value.docs.length > 0) {
        print("Product already exists");
      } else {
        FirebaseFirestore.instance
            .collection(request_collection)
            .doc(product.id)
            .set(doc_data)
            .then((value) {
          print("Document written successfully");
        }).catchError((err) {
          print("Error writing document" + err.toString());
        });
      }
    });
  }
}

class FirebaseDbAdapter {
  FirebaseDb db;

  FirebaseDbAdapter() {
    db = FirebaseDb();
  }
}

class AppDb {
  static Future<GraphQLClient> getGraphQLClient() async {
    final HttpLink _httpLink = HttpLink(graphQLUrl);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth_key = prefs.getString("auth_key");

    final AuthLink _authLink = AuthLink(
      getToken: () async => auth_key,
    );

    final Link _link = _authLink.concat(_httpLink);

    if (kIsWeb) {
      final GraphQLClient _client = GraphQLClient(
        cache: GraphQLCache(),
        link: _link,
        defaultPolicies: DefaultPolicies(
          query: Policies(
            fetch: FetchPolicy.cacheAndNetwork,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
          mutate: Policies(
            fetch: FetchPolicy.cacheAndNetwork,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
        ),
      );

      return _client;

    } else {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();

      String hive_path = appDocDirectory.path + '/' + 'cache';
      //HiveStore persist to disk - may be Premium=
      final store = await HiveStore.open(path: hive_path);

      final GraphQLClient _client = GraphQLClient(
        cache: GraphQLCache(store: store),
        link: _link,
        defaultPolicies: DefaultPolicies(
          query: Policies(
            fetch: FetchPolicy.cacheAndNetwork,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
          mutate: Policies(
            fetch: FetchPolicy.cacheAndNetwork,
            cacheReread: CacheRereadPolicy.mergeOptimistic,
          ),
        ),
      );

      return _client;

    }
  }

  static Future<dynamic> query(String query, Map<String, dynamic> variables,
      {CacheDuration cacheDuration = CacheDuration.None}) async {
    final QueryOptions options = QueryOptions(
        document: gql(query),
        variables: variables,
        pollInterval: Duration(seconds: 5),
        fetchPolicy: FetchPolicy.cacheAndNetwork);

    GraphQLClient _client = await getGraphQLClient();
    QueryResult result = await _client.query(options);

    if (result.hasException) {
      print(result.exception.toString());
      if (result.exception.toString().toLowerCase().contains("unauthorized")) {
        print("authorization failed");
        Future.delayed(Duration(milliseconds: 300))
            .then((value) => Authorization().authorize());
        //fe-query
        result = await _client.query(options);
      }
    }

    //assume query name is equal to operation name with first letter lowerCap
    String queryName = "";
    if (options.document.definitions.first.runtimeType ==
        OperationDefinitionNode) {
      queryName =
          (options.document.definitions.first as OperationDefinitionNode)
              .name
              .value
              .toString();
      queryName = queryName[0].toLowerCase() + queryName.substring(1);
    }

    if (result.data[queryName].runtimeType == bool) {
      return [result.data[queryName]];
    }

    return result.data[queryName];
  }

  static Future<List<dynamic>> mutation(
      String mutation, Map<String, dynamic> variables) async {
    final MutationOptions options = MutationOptions(
      document: gql(mutation),
      variables: variables,
    );
    GraphQLClient _client = await getGraphQLClient();
    final QueryResult result = await _client.mutate(options);
    if (result.hasException) {
      print(result.exception.toString());
      if (result.exception.toString().toLowerCase().contains("unauthorized")) {
        Future.delayed(Duration(milliseconds: 300))
            .then((value) => Authorization().authorize());
      }
    }

    //assume query name is equal to operation name with first letter lowerCap
    String queryName = "";
    if (options.document.definitions.first.runtimeType ==
        OperationDefinitionNode) {
      queryName =
          (options.document.definitions.first as OperationDefinitionNode)
              .name
              .value
              .toString();
      queryName = queryName[0].toLowerCase() + queryName.substring(1);
    }

    List<dynamic> list = [];
    if (result.data == null) {
      return list;
    }

    if (result.data[queryName].runtimeType == bool) {
      return [result.data[queryName]];
    }

    list = result.data[queryName] as List<dynamic>;
    return list;
  }

  static Future<List<ProductIndex>> fetchSearchbarContent(
      String substr, List<Category> categories) async {
    List<String> categoriesRefactored = categories
        .map((e) => e.toString().replaceFirst("Category.", ""))
        .toList();
    List<dynamic> list = await query(queryProductIndex,
        {"substr": substr, "categories": categoriesRefactored},
        cacheDuration: CacheDuration.oneDay);
    List<ProductIndex> retList = [];
    for (int i = 0; i < list.length; i++) {
      retList.add(new ProductIndex(list[i]["code"], list[i]["date_added"],
          list[i]["id"], list[i]["product_name"]));
    }
    return retList;
  }

  static Future<List<ProductIndex>> fetchItemsWithoutBarcode(
      String substr) async {
    List<dynamic> list = await query(
        queryProductIndexNoBarcode, {"substr": substr},
        cacheDuration: CacheDuration.halfHour);
    List<ProductIndex> retList = [];
    for (int i = 0; i < list.length; i++) {
      retList.add(new ProductIndex(list[i]["code"], list[i]["date_added"],
          list[i]["id"], list[i]["product_name"]));
    }
    return retList;
  }

  static Future<List<Comment>> getComments(String product_id) async {
    List<Comment> retList = [];
    List<dynamic> list = await query(
        queryGetComments, {"product_id": product_id},
        cacheDuration: CacheDuration.None);
    for (int i = 0; i < list.length; i++) {
      retList.add(new Comment(
          list[i]["author"],
          list[i]["user_id"],
          list[i]["id"],
          list[i]["text"],
          list[i]["date_added"],
          list[i]["category"],
          list[i]["likes"]));
    }
    return retList;
  }

  static void addComment(
      String product_id, String comment, String author, String category) async {
    List<dynamic> list = await mutation(mutationCreateComment, {
      "product_id": product_id,
      "author": author,
      "category": category,
      "comment": comment
    });

    /*List<Comment> retList = [];
    for (int i = 0; i < list.length; i++) {
      retList.add(new Comment(list[i]["author"], list[i]["product_id"],
          list[i]["text"], list[i]["date_added"], list[i]["category"],
          list[i]["likes"]));
    }
    return retList;*/
  }

  static void removeComment(String comment_id) async {
    await mutation(mutationRemoveComment, {"id": comment_id});
  }

  static void addLike(String comment_id, int amount) async {
    List<dynamic> list = await mutation(
        mutationAddLike, {"comment_id": comment_id, "amount": amount});
    /* List<dynamic> list  = json.decode(resp.body)["data"]["getComments"];
    List<Comment> retList = [];
    for (int i = 0; i < list.length; i++) {
      retList.add(new Comment(list[i]["author"], list[i]["product_id"],
          list[i]["text"], list[i]["date_added"], list[i]["category"],
          list[i]["likes"]));
    }
    return retList;*/
  }

  static Future<bool> setInitialUsername(String name, String email) async {
    List<dynamic> list = await mutation(
        mutationSetInitialUsername, {"name": name, "email": email});

    return list[0];
  }

  static Future<List<ProductItem>> getHotItems(Category category,
      {int amount = 5}) async {
    String categoryString = category.toString().replaceFirst("Category.", "");

    List<dynamic> list = await query(
        queryGetHotItems, {"category": categoryString, "amount": amount},
        cacheDuration: CacheDuration.halfHour);
    List<ProductItem> retList = [];
    for (int i = 0; i < list.length; i++) {
      retList.add(new ProductItem(
          list[i]["code"],
          list[i]["id"],
          list[i]["date_added"],
          list[i]["product_name"],
          list[i]["comments_amount"]));
    }
    return retList;
  }

  static Future<List<ProductItem>> getRandomDocuments(Category category,
      {int amount = 10}) async {
    String categoryString = category.toString().replaceFirst("Category.", "");

    List<dynamic> list = await query(
        queryGetRandomDocuments, {"amount": amount, "category": categoryString},
        cacheDuration: CacheDuration.oneDay);
    List<ProductItem> retList = [];
    for (int i = 0; i < list.length; i++) {
      retList.add(new ProductItem(
          list[i]["code"],
          list[i]["id"],
          list[i]["date_added"],
          list[i]["product_name"],
          list[i]["comments_amount"]));
    }
    return retList;
  }

  static Future<User> getUser() async {
    String name = await getUsername();
    String password = await getPassword();

    Map<String, dynamic> ret = await query(
        queryGetUser, {"name": name, "password": password},
        cacheDuration: CacheDuration.None);
    return User(ret["name"], ret["email"], ret["id"], ret["date_added"],
        ret["premium"]);
  }

  static Future<UserInformation> getUserInformation(String userId) async {
    Map<String, dynamic> ret = await query(
        queryGetUserInformation, {"userId": userId},
        cacheDuration: CacheDuration.halfHour);
    UserInformation userinformation = UserInformation(
        ret["name"], ret["id"], ret["date_added"],
        premium: ret["premium"]);
    if (ret["likes"] != null) {
      userinformation.likes = ret["likes"];
    }
    if (ret["comments"] != null) {
      userinformation.comments = ret["comments"];
    }

    return userinformation;
  }

  static Future<bool> isNameAvailable(String name) async {
    List<dynamic> ret = await query(queryNameAvailable, {"name": name});
    return ret[0];
  }

  static Future<bool> setPremium(bool status, String userId) async {
    List<dynamic> ret = await mutation(
        mutationSetPremium, {"status": status, "userID": userId});
    return ret[0];
  }

  static Future<bool> uploadProductImage(
      MultipartFile image, String productId) async {
    List<dynamic> list = await mutation(
        mutationUploadProductImage, {"image": image, "productId": productId});

    return list[0];
  }
}

enum CacheDuration { None, halfHour, oneDay, thirtyDays }
