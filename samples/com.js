if (Auth.Login(username,password)) {
    Reponse.Send(Templates.Render("Dashboard.templ"));
}