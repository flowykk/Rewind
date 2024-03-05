using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.UserControllersTests;

public class LoginRegisterControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();

    [Fact]
    public async void ItShould_successfully_login_user()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var loginController = new LoginController(_context);
        
        // Act
        var actionResult = await loginController.Login(ContextHelper.BuildTestLoginRequest());
        
        // Assert
        var result = actionResult as ObjectResult;
        Assert.Equal("200", result.StatusCode.ToString());
    }
    
    [Fact]
    public async void ItShould_fail_to_login_user_when_email_is_invalid()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var loginController = new LoginController(_context);
        
        // Act
        var actionResult = await loginController.Login(ContextHelper.BuildInvalidEmailLoginRequest());
        
        // Assert
        var result = actionResult as ObjectResult;
        Assert.Equal("400", result.StatusCode.ToString());
    }
    
    [Fact]
    public async void ItShould_fail_to_login_user_when_password_is_invalid()
    {
        // Arrange
        var registerController = new RegisterController(_context);
        await registerController.Register(ContextHelper.BuildTestRegisterRequest());

        var loginController = new LoginController(_context);
        
        // Act
        var actionResult = await loginController.Login(ContextHelper.BuildInvalidPasswordLoginRequest());
        
        // Assert
        var result = actionResult as ObjectResult;
        Assert.Equal("400", result.StatusCode.ToString());
    }
}
