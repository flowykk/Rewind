using Microsoft.AspNetCore.Mvc;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;

namespace RewindApp.Tests.UserControllersTests;

public class LoginControllerTests
{
    private readonly DataContext _context = ContextGenerator.Generate();
    private readonly RegisterController _registerController;
    private readonly LoginController _loginController;
    
    public LoginControllerTests()
    {
        _loginController = new LoginController(_context);
        _registerController = new RegisterController(_context);
    }
    
    [Fact]
    public async void ItShould_successfully_login_user()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Act
        var actionResult = await _loginController.Login(ContextHelper.BuildTestLoginRequest());
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("200", result?.StatusCode.ToString());
    }
    
    [Fact]
    public async void ItShould_fail_to_login_user_with_invalid_email()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Act
        var actionResult = await _loginController.Login(ContextHelper.BuildInvalidEmailLoginRequest());
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
    }
    
    [Fact]
    public async void ItShould_fail_to_login_user_with_invalid_password()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Act
        var actionResult = await _loginController.Login(ContextHelper.BuildInvalidPasswordLoginRequest());
        var result = actionResult.Result as ObjectResult;
        
        // Assert
        Assert.Equal("400", result?.StatusCode.ToString());
    }
    
    [Fact]
    public async void ItShould_successfully_check_that_user_with_email_doesnt_exists()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Assert
        var actionResult = await _loginController.CheckEmail("no@no.no");
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("400", result?.StatusCode.ToString());
    }

    [Fact]
    public async void ItShould_successfully_check_that_user_with_email_exists()
    {
        // Arrange
        await _registerController.Register(ContextHelper.BuildTestRegisterRequest());
        
        // Assert
        var actionResult = await _loginController.CheckEmail("test@test.test");
        var result = actionResult as ObjectResult;
        
        // Act
        Assert.Equal("200", result?.StatusCode.ToString());
    }
}
