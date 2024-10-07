const String queryProductIndex =
    r"""query ProductIndex($substr: String!, $categories: [String]!) {
      productIndex(substring: $substr, categories: $categories) {
        product_name,
    code,
    id
  }
  }""";

const String queryProductIndexNoBarcode =
    r"""query ProductIndex($substr: String!) {
      productIndex(substring: $substr, hasBarcode:false) {
        product_name,
        code,
        id
  }
  }""";

const String queryGetComments = r"""query GetComments($product_id: String!) {
      getComments(product_id: $product_id) {
        author,
        user_id,
        category,
        likes,
        text,
        date_added,
        id
       }
  }""";

const String queryGetHotItems = r"""query HotItems($category: String!, $amount: Int!) {
        hotItems(category: $category, amount: $amount) {
          product_name,
          id,
          comments_amount,
      }
    }""";

const String queryGetRandomDocuments = r"""query RandomDocument($amount: Int, $category: String) {
        randomDocument(amount: $amount, category: $category) {
          product_name,
          id,
      }
    }"""; //todo add comments amount

const String queryGetTotalCommentsOfUser = r"""query GetTotalCommentsOfUser($user_id: ID!) {
        getTotalCommentsOfUser(user_id: $user_id)
    }""";

const String queryGetTotalLikesOfUser = r"""query GetTotalLikesOfUser($user_id: ID!) {
        getTotalLikesOfUser(user_id: $user_id)
    }""";

const String queryGetUser = r"""query GetUser($name: String!, $password: String!) {
       getUser(name: $name, password: $password) {
        name,
        email,
        id,
        date_added,
        premium
      }
    }""";

const String queryGetUserInformation = r"""query GetUserInformation($userId: String!) {
       getUserInformation(userId: $userId) {
        name,
        id,
        date_added,
        likes,
        comments,
        premium
      }
    }""";

const String queryNameAvailable = r"""query NameAvailable($name: String!) {
       nameAvailable(name: $name)
    }""";

const String queryGetProductImage = r"""query GetProductImage($productId: String!) {
       getProductImage(productId: $productId) {
       image
       }
    }""";
