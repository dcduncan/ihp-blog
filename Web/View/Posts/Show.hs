module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark

data ShowView = ShowView { post :: Include' ["comments", "userId"] Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{post.title}</h1>
        <p>{post.createdAt |> timeAgo}</p>
        <p>{post.userId.name}</p>
        <p>{post.body |> renderMarkdown}</p>
        <a href={NewCommentAction post.id}>Add Comment</a>
        <div>{forEach post.comments renderComment}</div>
    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ]

renderMarkdown text =
    case text |> MMark.parse "" of
        Left error -> "Something went wrong"
        Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

renderComment comment = [hsx|
    <div class="mt-4">
        <h5>{comment.userId}</h5>
        <p>{comment.body}</p>
    </div>
|]