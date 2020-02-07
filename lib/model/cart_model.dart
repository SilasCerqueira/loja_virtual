import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{
    List<CartProduct> products = [];

    UserModel user;
    bool isLoading = false;

    CartModel(this.user){
      if(user.isLoggedIn())
        _loadCartItems();
    }


    static CartModel of(BuildContext context) =>
        ScopedModel.of<CartModel>(context);

    void addCartItem(CartProduct cartProduct){
      products.add(cartProduct);
      Firestore.instance.collection("users").document(user.firebaseUser.uid)
      .collection("cart").add(cartProduct.toMap()).then( (doc){
       cartProduct.cid = doc.documentID;
      });
      notifyListeners();
    }

    void removeCartItem(CartProduct cartProduct){
      Firestore.instance.collection("users").document(user.firebaseUser.uid)
          .collection("cart").document(cartProduct.cid).delete();

      products.remove(cartProduct);

      notifyListeners();
    }

  void addProduct(CartProduct cartProduct) {
      cartProduct.quantity ++;
      Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());
      notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
      cartProduct.quantity --;
      Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());
      notifyListeners();
  }

  void _loadCartItems() async{
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart")
        .getDocuments();

    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();
    notifyListeners();

  }
}