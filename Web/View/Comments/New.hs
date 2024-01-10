module Web.View.Comments.New where
import Web.View.Prelude

instance CanSelect User where
    -- Here we specify that the <option> value should contain a `Id User`
    type SelectValue User = Id User
    -- Here we specify how to transform the model into <option>-value
    selectValue user = user.id
    -- And here we specify the <option
    selectLabel user = user.name

data NewView = NewView { comment :: Comment, post :: Post, users :: [User] }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Comment for <q>{post.title}</q></h1>
        {renderForm comment users}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Comments" CommentsAction
                , breadcrumbText "New Comment"
                ]

renderForm :: Comment -> [User] -> Html
renderForm comment users = formFor comment [hsx|
    {(selectField #userId users)}
    {(hiddenField #postId)}
    {(textField #body)}
    {submitButton}

|]