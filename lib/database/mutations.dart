const String mutationCreateComment =
    r"""mutation CreateComment($product_id: String!, $author: String!, $category: String!, $comment: String!) {
        createComment(product_id: $product_id, author: $author, category: $category, text:$comment){
        author,
        category,
        likes,
        text,
        date_added,
        id
       }
     }""";

const String mutationRemoveComment = r"""mutation RemoveComment($id: String!) {
        removeComment(id: $id)
     }""";

const String mutationAddLike =
    r"""mutation AddLike($comment_id: String!, $amount: Int!) {
        addLike(id: $comment_id, amount: $amount)
     }""";

const String mutationSetInitialUsername =
    r"""mutation SetInitialUsername($name: String!, $email: String!) {
        setInitialUsername(name: $name, email: $email)
    }""";

const String mutationUploadProductImage =
    r"""mutation UploadProductImage($image: Upload!, $productId: String!) {
        uploadProductImage(image: $image, productId: $productId)
    }""";

const String mutationSetPremium =
    r"""mutation SetPremium($status: Boolean!, $userID: ID!) {
        setPremium(status: $status, userID: $userID)
    }""";
