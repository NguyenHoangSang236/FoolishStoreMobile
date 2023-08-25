import 'package:fashionstore/data/static/api_authen_type.dart';

import '../../data/entity/cart_item.dart';
import '../../data/entity/product.dart';

class ValueRender {
  const ValueRender._();

  static String getGoogleDriveImageUrl(String imageId) {
    return 'https://drive.google.com/uc?export=view&id=$imageId';
  }

  static String getUrl({bool isAuthen = false, required type, required url}) {
    return '${isAuthen == true ? ApiAuthenType.authenApi : ApiAuthenType.unauthenApi}/$type$url';
  }

  static String getFileIdFromGoogleDriveViewUrl(String url) {
    return url.substring(url.indexOf('/d/') + 3, url.indexOf('/view'));
  }

  static double getDiscountPrice(double orgPrice, double discount) {
    return orgPrice - (orgPrice * (discount / 100));
  }

  static List<String> getProductColorList(List<Product> productList) {
    List<String> result = [];

    String color = '';

    for (int i = 0; i < productList.length; i++) {
      if (i == 0) {
        color = productList[i].color;
        result.add(color);
      } else if (productList[i].color != productList[i - 1].color) {
        color = productList[i].color;
        result.add(color);
      }
    }

    return result;
  }

  // get first images of product from different colors
  static List<String> getProductImagesFromDifferentColors(
      List<Product> productList) {
    List<String> result = [];

    String imgUrl = '';

    for (int i = 0; i < productList.length; i++) {
      if (i == 0) {
        imgUrl = productList[i].image1!;
        result.add(imgUrl);
      } else if (productList[i].image1 != productList[i - 1].image1) {
        imgUrl = productList[i].image1!;
        result.add(imgUrl);
      }
    }

    return result;
  }

  static List<String> getProductImageUrlListByColor(
    String color,
    List<Product> productList,
  ) {
    List<Product> coloredSelectedProductList =
        productList.where((element) => element.color == color).toList();

    List<String> imageUrlList = [
      coloredSelectedProductList[0].image1 ?? '',
      coloredSelectedProductList[0].image2 ?? '',
      coloredSelectedProductList[0].image3 ?? '',
      coloredSelectedProductList[0].image4 ?? '',
    ];

    return imageUrlList.where((element) => element.isNotEmpty).toList();
  }

  // get list of products size using product color
  static List<String> getProductSizeListByColor(
      String color, List<Product> productList) {
    return productList
        .where((element) => element.color == color)
        .map((e) => e.size)
        .toList();
  }

  static String getAddToCartPopupContent(
      String productName, String color, String size, int quantity) {
    String result = 'Selected product details:\n';

    if (productName != '') {
      result += '  + Name: $productName\n';
    }

    if (color != '' && color.toLowerCase() != 'none') {
      result += '  + Color: $color\n';
    }

    if (size != '' && size.toLowerCase() != 'none') {
      result += '  + Size: $size\n';
    }

    if (quantity > 0) {
      result += '  + Quantity: $quantity\n';
    }

    return '${result}Are you sure to add this product to your cart?';
  }

  static double totalCartPrice(List<CartItem> cartItemList) {
    double result = 0;

    for (CartItem cartItem in cartItemList) {
      result += getDiscountPrice(cartItem.sellingPrice, cartItem.discount) *
          cartItem.quantity;
    }

    return double.parse(result.toStringAsFixed(2));
  }
}
