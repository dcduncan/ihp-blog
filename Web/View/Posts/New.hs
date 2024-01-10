module Web.View.Posts.New where
import Web.View.Prelude


instance CanSelect User where
    -- Here we specify that the <option> value should contain a `Id User`
    type SelectValue User = Id User
    -- Here we specify how to transform the model into <option>-value
    selectValue user = user.id
    -- And here we specify the <option>-text
    selectLabel user = user.name

data NewView = NewView { post :: Post, users :: [User] }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Post</h1>
        {renderForm post users}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                , breadcrumbText "New Post"
                ]

renderForm :: Post -> [User] -> Html
renderForm post users = formFor post [hsx|
    {(textField #title)}
    {(textareaField #body)  { helpText = "You can use Markdown here"} }
    {(selectField #userId users)}
    {submitButton}

|]