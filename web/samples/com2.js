if (AuthService.Login(username,password)) {
    Reponse.Send(
        TemplatesService.GetRendered("Dashboard.templ")
    );
}