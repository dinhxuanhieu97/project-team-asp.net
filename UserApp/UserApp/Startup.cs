using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(UserApp.Startup))]
namespace UserApp
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
